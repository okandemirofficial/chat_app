import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "error";
    try {
      if (email.isNotEmpty & password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {}
      return res;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String> signUpUser(
      {required String email, required String password}) async {
    String res = "error";
    try {
      if (email.isNotEmpty & password.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'uid':_auth.currentUser!.uid,
          'email':_auth.currentUser!.email
        });
        res = "success";
      }
      return res;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
