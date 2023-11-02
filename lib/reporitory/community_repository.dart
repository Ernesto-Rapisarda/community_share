import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/model/event.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/community_provider.dart';
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

  Future<void> joinCommunity(BuildContext context, Community community) async{
    try{
      await _db
          .collection('communities')
          .doc(community.id)
          .collection('members')
          .add(context.read<UserProvider>().getUserBasic().toJson());
      await _db
          .collection('Users')
          .doc(context.read<UserProvider>().userDetails.id)
          .collection('myCommunities')
          .add(community.toJson());

    }catch (error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<Event>> getEventsForCommunity(BuildContext context) async{
    List<Event> events =[];
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(context.read<CommunityProvider>().community.id)
      .collection('events')
          .get();


      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Event event = Event.fromJson(document.data()!);
        event.id = document.id;
        events.add(event);
      });

      return events;

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

  Future<List<UserDetailsBasic>> getMembers(BuildContext context) async{
    List<UserDetailsBasic> members=[];
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(context.read<CommunityProvider>().community.id)
          .collection('members')
          .get();


      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        UserDetailsBasic member = UserDetailsBasic.fromJson(document.data()!);
        member.id = document.id;
        members.add(member);
      });

      return members;

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