import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../reporitory/conversation_repository.dart';

class ConversationService {
  final ConversationRepository _conversationRepository =
      ConversationRepository();

  Future<bool> createNewConversation(
      BuildContext context, ProductBasic productBasic, Message message, String subject, bool order) async {
    Conversation conversation = Conversation(
        id: IdGenerator.generateUniqueConversationId(
            message.sender.id, message.receiver.id, productBasic.id),
        productBasic: productBasic,
        members: [message.sender, message.receiver],
        subject: subject,
        indexOfLastSender: 0,
        startDate: DateTime.now(),
        lastUpdate: DateTime.now(),
        unreadMessage: 1,
        messages: [message],
        order: order
    );

    bool conversationAlreadyExists = await _conversationRepository
        .conversationAlreadyExists(context, conversation);
    if (!conversationAlreadyExists) {
      return await _conversationRepository.createNewConversation(
          context, conversation);
    } else {
      return false;
    }
  }

  Future<List<Conversation>> getMyConversations(BuildContext context) async {
    return await _conversationRepository.getMyConversations(context);
  }

  void setMessagesReaded(
      BuildContext context, Conversation conversation) async {
    if (conversation.members[conversation.indexOfLastSender].id !=
        Auth().currentUser?.uid) {
      conversation.unreadMessage = 0;
      conversation.lastUpdate = DateTime.now();
      await _conversationRepository.setMessagesReaded(context, conversation);
    }
  }

  Future<Conversation> sendReply(BuildContext context, Conversation conversation, String text) async{
    Conversation tmp = conversation;
    UserDetailsBasic sender = context.read<UserProvider>().getUserBasic();
    int senderIndex = conversation.members.indexOf(sender) ;
    UserDetailsBasic receiver = conversation.members[senderIndex == 0 ? 1 : 0];

    Message message = Message(id: IdGenerator.generateUniqueMessageId(sender.id, receiver.id), sender: sender, receiver: receiver, text: text, date: DateTime.now());

    tmp.unreadMessage=tmp.unreadMessage + 1;
    tmp.lastUpdate = DateTime.now();
    tmp.indexOfLastSender = senderIndex;
    tmp.messages.add(message);

    bool messageSended = await _conversationRepository.sendReply(context,tmp);
    if(messageSended) {
      return tmp;
    } else {
      return conversation;
    }
  }
}
