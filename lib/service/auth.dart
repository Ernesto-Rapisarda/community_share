import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/utils/show_snack_bar.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> createUserInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await sendEmailVerification();
      String uid = userCredential.user?.uid ?? '';
      return uid;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try{
      await _firebaseAuth.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleUser != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            context.go('/login/registration', extra: false);
          } else {
            context.go('/');
          }
        }
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      if (_firebaseAuth.currentUser != null) {
        context.go('/');
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> completeRegistration(String uid, UserDetails userDetails) async {
    try {
      final UserRepository userRepository = UserRepository();
      await userRepository.createUserDetails(uid, userDetails);
    } on FirebaseException {
      rethrow;
    }
  }
}
