import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/utils/expection.dart';

class UserRepository {
  UserRepository({
    required this.firestore,
    required this.storage,
  });

  final FirebaseFirestore firestore;

  final FirebaseStorage storage;

  late final userReF = firestore.collection('users');

  Future<void> createUserDoc(XUser user) async {
    try {
      DocumentReference userRef = firestore.collection('users').doc(user.id);
      final imageRef = storage.ref().child('users/${userRef.id}');
      await imageRef.putFile(File(user.profileUrl));
      final imageUrl = await imageRef.getDownloadURL();
      await userRef.set(user.copyWith(profileUrl: imageUrl).toJson());
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Future<bool> isDuplicateUniqueName(String userName) async {
    final query = await userReF.where('userName', isEqualTo: userName).get();
    return query.docs.isNotEmpty;
  }

  Future<void> update(XUser user, String? file) async {
    try {
      DocumentReference userRef = firestore.collection('users').doc(user.id);
      String? imageUrl;
      if (file != null) {
        final imageRef = storage.ref().child('users/${userRef.id}');
        await imageRef.putFile(File(file));
        imageUrl = await imageRef.getDownloadURL();
      }
      await userRef.update(user.copyWith(profileUrl: imageUrl ?? user.profileUrl).toJson());
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Future<XUser> getUser(String uid) async {
    try {
      final userData = await firestore.collection('users').doc(uid).get();
      return XUser.fromJson(userData.data()!);
    } on FirebaseException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw FlutterXException(e.toString());
    }
  }
}
