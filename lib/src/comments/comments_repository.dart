import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/src/comments/comments.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/utils/expection.dart';

class CommentsRepository {
  CommentsRepository({
    required this.firestore,
    required this.storage,
  });

  final FirebaseFirestore firestore;

  final FirebaseStorage storage;

  static final commentCollection = FirebaseFirestore.instance.collection('comments').withConverter(
    fromFirestore: (snapshot, a) => Comments.fromJson(snapshot.data()!), 
    toFirestore: (model, _) => model.toMap(),
  );


  //final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> createComment(String parentId, String text, XUser user) async {
    try {
      DocumentReference commentRef = firestore.collection('comments').doc();      
      final comment = Comments(
        id: commentRef.id,
        text: text,
        tweetId: parentId,
        imagesUrl: [],
        userId: user.id,
        userName: user.name,
        userUrl: user.profileUrl,
        timestamp: DateTime.now(),
      );
      await commentRef.set(comment.toMap());
      DocumentReference tweetRef = firestore.collection("tweets").doc(parentId);
      await tweetRef.update({
        "replies": FieldValue.arrayUnion([commentRef.id]),
      });
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Stream<List<Comments>> getComments(String tweetId) {
    final commentRef = firestore.collection('comments').where("tweetId", isEqualTo: tweetId).snapshots();

    return commentRef.asyncMap((snapshot) {
      return snapshot.docs.map((doc) => Comments.fromSnapshot(doc)).toList();
    });
  }

  Future<List<Comments>> getUserComment(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> commentRef = await firestore.collection('comments').where("userId", isEqualTo: uid).get();
      return commentRef.docs.map((e) => Comments.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw FlutterXException(e.toString());
    }
  }

  Future<void> addComment(String id, String comment) async {
    firestore.collection('tweets').doc(id).update({
      "replies": FieldValue.arrayUnion([comment]),
    });
  }

  Future<void> addLikes(String id, String uid) async {
    firestore.collection('comments').doc(id).update({
      "likes": FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> removeLikes(String id, String uid) async {
    firestore.collection('comments').doc(id).update({
      "likes": FieldValue.arrayRemove([uid]),
    });
  }
}
