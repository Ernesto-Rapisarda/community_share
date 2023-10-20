import 'package:community_share/controllers/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password, required BuildContext context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    }on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);
    }
  }

  Future<void> createUserInWithEmailAndPassword({required String email,
    required String password,
    required BuildContext context}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signOut() async {

    await _firebaseAuth.signOut();
    //await _googleSignIn.signOut();

  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _firebaseAuth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verication sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async{
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print('ciao');

      if(googleUser != null ){
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        if(userCredential.user != null){
          if(userCredential.additionalUserInfo!.isNewUser){
            //posto dove storare roba in database
            print(userCredential.user?.displayName);
          }
          context.go('/');
          print('entro nellif');

        }
      }
      print('lo passo');

    } on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);

    }
  }
}
