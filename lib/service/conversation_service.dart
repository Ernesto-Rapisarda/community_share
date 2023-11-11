
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/cupertino.dart';

import '../reporitory/conversation_repository.dart';

class ConversationService {
  final ConversationRepository _conversationRepository = ConversationRepository();

  Future<bool> createNewConversation(BuildContext context, ProductBasic productBasic, Message message) async{
    Conversation conversation = Conversation(
        id: IdGenerator.generateUniqueConversationId(message.sender.id, message.receiver.id, productBasic.id),
        productBasic: productBasic,
        members: [message.sender,message.receiver],
        indexOfLastSender: 0,
        startDate: DateTime.now(),
        lastUpdate: DateTime.now(),
        unreadMessage: 1,
        messages: [message]);

    bool conversationAlreadyExists = await _conversationRepository.conversationAlreadyExists(context, conversation);
    if(!conversationAlreadyExists){
      return await _conversationRepository.createNewConversation(context,conversation);
    }
    else{
      return false;
    }

  }

  Future<List<Conversation>> getMyConversations(BuildContext context) async{
    return await _conversationRepository.getMyConversations(context);
  }
}