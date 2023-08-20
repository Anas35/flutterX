import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/utils/expection.dart';

class TweetRepository {
  TweetRepository({
    required this.firestore,
    required this.storage,
  });

  final FirebaseFirestore firestore;

  final FirebaseStorage storage;

  static final tweetCollection = FirebaseFirestore.instance.collection('tweets').withConverter(
    fromFirestore: (snapshot, a) => Tweet.fromJson(snapshot.data()!), 
    toFirestore: (model, _) => model.toMap(),
  );


  //final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> createTweet(String text, List<String> images, XUser user) async {
    try {
      DocumentReference tweetRef = firestore.collection('tweets').doc();
      int count = 1;
      List<String> imagesUrl = [];
      final imageRef = storage.ref().child(user.id).child('tweets').child(tweetRef.id);
      for (final image in images) {
        await imageRef.child('$count').putFile(File(image));
        imagesUrl.add(await imageRef.getDownloadURL());
        count++;
      }
      final tweet = Tweet(
        id: tweetRef.id,
        text: text,
        imagesUrl: imagesUrl,
        userId: user.id,
        userName: user.name,
        userUrl: user.profileUrl,
        timestamp: DateTime.now(),
      );
      await tweetRef.set(tweet.toMap());
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Stream<List<Tweet>> getTweets() {
    Query tweetsQuery = firestore.collection('tweets').orderBy('timestamp', descending: true);

    return tweetsQuery.snapshots().asyncMap((snapshot) {
      return snapshot.docs.map((doc) => Tweet.fromSnapshot(doc)).toList();
    });
  }

  Future<List<Tweet>> getUserTweet(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> tweetRef = await firestore.collection('tweets').where("userId", isEqualTo: uid).get();
      return tweetRef.docs.map((e) => Tweet.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw FlutterXException(e.toString());
    }
  }

  Stream<Tweet> getTweet(String id) {
    try {
      final tweetRef = TweetRepository.tweetCollection.doc(id).snapshots();
      return tweetRef.asyncMap((event) => Tweet.fromSnapshot(event));
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
    firestore.collection('tweets').doc(id).update({
      "likes": FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> removeLikes(String id, String uid) async {
    firestore.collection('tweets').doc(id).update({
      "likes": FieldValue.arrayRemove([uid]),
    });
  }
}
