import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/material.dart';

import '../service/auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserDetails(BuildContext context) async {
    try {
      await _db.collection("Users").doc(Auth().currentUser?.uid).set(UserProvider().userDetails.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been created"),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      print(error.toString());
    }
  }
}
