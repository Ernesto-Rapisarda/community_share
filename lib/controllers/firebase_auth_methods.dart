import 'package:community_share/controllers/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);

    }on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);
    }
  }

  Future<void> createUserInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try{
      await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    }on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);

    }

  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
