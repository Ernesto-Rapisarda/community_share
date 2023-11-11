
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConversationRepository{
  final _db = FirebaseFirestore.instance;

  Future<bool> createNewConversation(BuildContext context, Conversation conversation) async{
    try
    {
      await _db.collection('Users').doc(Auth().currentUser?.uid).collection('conversations').add(conversation.toJson());
      await _db.collection('Users').doc(conversation.members[1].id).collection('conversations').add(conversation.toJson());

      return true;
    }
    catch (error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return false;
    }
  }

  Future<bool> conversationAlreadyExists(BuildContext context, Conversation conversation) async {
    try
    {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('conversations')
          .where('id', isEqualTo: conversation.id)
          .get();

      if(snapshot.size >0){
        return true;
      }

      return false;
    }
    catch (error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return true;
    }
  }

  Future<List<Conversation>> getMyConversations(BuildContext context) async{
    List<Conversation> myConversations = [];
    try
    {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('conversations')
      .orderBy('lastUpdate', descending: true)
          .get();

      if(snapshot.size >0){
        snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          Conversation conversation = Conversation.fromJson(document.data()!);
          myConversations.add(conversation);
        });
      }

      return myConversations;
    }
    catch (error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return myConversations;
    }
  }
}