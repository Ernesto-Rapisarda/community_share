import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserDetails(BuildContext context) async {
    try {
      print(context.read<UserProvider>().userDetails.toString());

      await _db.collection("Users").doc(Auth().currentUser?.uid).set(context.read<UserProvider>().userDetails.toJson());
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

  Future<void> updateUserDetails(BuildContext context) async {
    try {
      print(context.read<UserProvider>().userDetails.toString());

      await _db
          .collection("Users")
          .doc(Auth().currentUser?.uid)
          .update(context.read<UserProvider>().userDetails.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been updated"),
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

  Future<UserDetails> getUserDetails(BuildContext context) async {
    try {
      DocumentSnapshot userDocument = await _db.collection("Users").doc(Auth().currentUser?.uid).get();

      if (userDocument.exists) {
        UserDetails userDetails = UserDetails.fromJson(userDocument.data() as Map<String, dynamic>);
        context.read<UserProvider>().setUserDetails(userDetails);
        return userDetails;
      } else {
        throw Exception("User not found in database");
      }
    } catch (error) {
      print(error.toString());
      throw Exception("Failed to fetch user details");
    }
  }
}
