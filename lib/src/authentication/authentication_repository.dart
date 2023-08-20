import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_x/utils/expection.dart';

class AuthRepository {
  const AuthRepository(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }

  Future<void> deleteUser() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw FlutterXException(e.message);
    } catch (e) {
      throw const FlutterXException();
    }
  }


  Stream<User?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((firebaseUser) => firebaseUser);
  }
}
