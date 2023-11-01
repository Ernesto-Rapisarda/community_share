import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CommunityRepository{
  final _db = FirebaseFirestore.instance;

  Future<void> createCommunity(BuildContext context, Community community) async{
    try{
      await _db.collection('communities').add(community.toJson());
    }
    catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<Community>> getMyCommunities(BuildContext context) async{
    List<Community> myCommunities = [];

    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .where('founder.Id',isEqualTo: context.read<UserProvider>().userDetails.id)
          .get();


      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Community community = Community.fromJson(document.data()!);
        community.id = document.id;
        myCommunities.add(community);
      });

      return myCommunities;
    }catch (error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }
  }
}