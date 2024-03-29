
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConversationRepository{
  final _db = FirebaseFirestore.instance;

  Future<bool> createNewConversation(Conversation conversation) async{
    try
    {
      if(!conversation.order){
        await _db.collection('Users').doc(Auth().currentUser?.uid).collection('conversations').add(conversation.toJson());
      }
      await _db.collection('Users').doc(conversation.members[1].id).collection('conversations').add(conversation.toJson());

      return true;
    }
    catch (error)
    {
      rethrow;
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

  Future<void> setMessagesReaded(BuildContext context, Conversation conversation) async{
    try{
      if(!conversation.order){
        for(UserDetailsBasic userDetailsBasic in conversation.members){
          QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('Users').doc(userDetailsBasic.id).collection('conversations').where('id', isEqualTo: conversation.id).limit(1).get();
          if(snapshot.docs.isNotEmpty){
            print('set messages readed');
            String documentId = snapshot.docs[0].id;
            await _db.collection('Users').doc(userDetailsBasic.id).collection('conversations').doc(documentId).update(conversation.toJson());
          }
        }
      }
      else{
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('Users').doc(Auth().currentUser?.uid).collection('conversations').where('id', isEqualTo: conversation.id).limit(1).get();
        if(snapshot.docs.isNotEmpty){
          String documentId = snapshot.docs[0].id;
          await _db.collection('Users').doc(Auth().currentUser?.uid).collection('conversations').doc(documentId).update(conversation.toJson());
        }
      }

    }
    catch (error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> sendReply(BuildContext context, Conversation conversation) async{
    try{
      int updated = 0;
      for(UserDetailsBasic userDetailsBasic in conversation.members){
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('Users').doc(userDetailsBasic.id).collection('conversations').where('id', isEqualTo: conversation.id).limit(1).get();
        if(snapshot.docs.isNotEmpty){
          String documentId = snapshot.docs[0].id;
          await _db.collection('Users').doc(userDetailsBasic.id).collection('conversations').doc(documentId).update(conversation.toJson());
          updated= updated +1;
        }

      }
      if(updated==2){
        return true;
      }
      else{
        return false;
      }
    }
    catch (error){
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

  Future<int> unreadedMessageNumber() async{
    int unreadedMessageNumber = 0;
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('conversations')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document){
        Conversation conversation = Conversation.fromJson(document.data()!);
        if(conversation.members[conversation.indexOfLastSender].id != Auth().currentUser?.uid){
          unreadedMessageNumber = unreadedMessageNumber + conversation.unreadMessage;
        }
      });
      return unreadedMessageNumber;
    }catch (error){rethrow;}
  }

  Future<bool> updateOrderConversation(ProductOrder productOrder, String forGiver, String forReceiver) async{
    try{
      print('1');
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(productOrder.product.giver.id)
          .collection('conversations')
          .where('productOrderId',isEqualTo: productOrder.id)
          .limit(1)
          .get();
      print(snapshot.size);

      if(snapshot.size==1){
        print('2');

        String docId = snapshot.docs.first.id;
        Conversation conversation = Conversation.fromJson(snapshot.docs.first.data()!);
        conversation.unreadMessage = conversation.unreadMessage + 1;
        Message message = conversation.messages[0];
        message.id = IdGenerator.generateUniqueMessageId(message.sender.id, message.receiver.id);
        message.date = DateTime.now();
        message.text = forGiver;
        conversation.messages.add(message);
        conversation.lastUpdate = DateTime.now();

        await _db
            .collection('Users')
            .doc(productOrder.product.giver.id)
            .collection('conversations')
            .doc(docId)
            .update(conversation.toJson());

        print('3');

      }
      else{
        print('false');

        return false;
      }

      snapshot = await _db
          .collection('Users')
          .doc(productOrder.receiver.id)
          .collection('conversations')
          .where('productOrderId',isEqualTo: productOrder.id)
          .limit(1)
          .get();

      if(snapshot.size==1){
        String docId = snapshot.docs.first.id;
        Conversation conversation = Conversation.fromJson(snapshot.docs.first.data()!);
        conversation.unreadMessage = conversation.unreadMessage + 1;
        Message message = conversation.messages[0];
        message.id = IdGenerator.generateUniqueMessageId(message.sender.id, message.receiver.id);
        message.date = DateTime.now();
        message.text = forReceiver;
        conversation.messages.add(message);
        conversation.lastUpdate = DateTime.now();

        await _db
            .collection('Users')
            .doc(productOrder.receiver.id)
            .collection('conversations')
            .doc(docId)
            .update(conversation.toJson());
      }
      else{
        return false;
      }

      return true;

    }catch (error){
      rethrow;
    }

  }
}