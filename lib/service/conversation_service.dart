import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/enum/order_status.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../reporitory/conversation_repository.dart';

class ConversationService {
  final ConversationRepository _conversationRepository =
  ConversationRepository();
  final UserRepository _userRepository = UserRepository();

  Future<bool> createNewConversation(BuildContext context,
      ProductBasic productBasic, Message message, String subject,
      bool order) async {
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
          conversation);
    } else {
      return false;
    }
  }

  Future<List<Conversation>> getMyConversations(BuildContext context) async {
    return await _conversationRepository.getMyConversations(context);
  }

  Future<void> setMessagesReaded(BuildContext context,
      Conversation conversation) async {
    if (conversation.members[conversation.indexOfLastSender].id !=
        Auth().currentUser?.uid) {
      conversation.unreadMessage = 0;
      conversation.lastUpdate = DateTime.now();
      await _conversationRepository.setMessagesReaded(context, conversation);

    }

  }

  Future<Conversation> sendReply(BuildContext context,
      Conversation conversation, String text) async {
    Conversation tmp = conversation;
    UserDetailsBasic sender = context.read<UserProvider>().getUserBasic();
    int senderIndex = conversation.members.indexOf(sender);
    UserDetailsBasic receiver = conversation.members[senderIndex == 0 ? 1 : 0];

    Message message = Message(
        id: IdGenerator.generateUniqueMessageId(sender.id, receiver.id),
        sender: sender,
        receiver: receiver,
        text: text,
        date: DateTime.now());

    tmp.unreadMessage = tmp.unreadMessage + 1;
    tmp.lastUpdate = DateTime.now();
    tmp.indexOfLastSender = senderIndex;
    tmp.messages.add(message);

    bool messageSended = await _conversationRepository.sendReply(context, tmp);
    if (messageSended) {
      return tmp;
    } else {
      return conversation;
    }
  }

  Future<bool> createOrderConversation(ProductOrder productOrder) async {
    try {
      UserDetails systemProfile = await _userRepository.getSystemProfile();

      Conversation giverConversation = Conversation(
          id: IdGenerator.generateUniqueConversationId(
              systemProfile.id!, productOrder.product.giver.id,
              productOrder.product.id),
          productBasic: ProductBasic(id: productOrder.product.id,
              title: productOrder.product.title,
              urlImages: productOrder.product.urlImages,
              uploadDate: productOrder.product.uploadDate,
              availability: productOrder.product.availability,
              docRefCompleteProduct: productOrder.product.docRef!),
          members: [
            UserDetailsBasic(id: systemProfile.id!,
                fullName: systemProfile.fullName,
                location: systemProfile.location,
                urlPhotoProfile: systemProfile.urlPhotoProfile),
            productOrder.product.giver
          ],
          subject: 'An order for ${productOrder.product.title} was created',
          indexOfLastSender: 0,
          startDate: DateTime.now(),
          lastUpdate: DateTime.now(),
          unreadMessage: 1,
          messages: [
            Message(id: IdGenerator.generateUniqueMessageId(
                systemProfile.id!, productOrder.product.giver.id),
                sender: UserDetailsBasic(id: systemProfile.id!,
                    fullName: systemProfile.fullName,
                    location: systemProfile.location,
                    urlPhotoProfile: systemProfile.urlPhotoProfile),
                receiver: productOrder.product.giver,
                text: 'An order for ${productOrder.product
                    .title} was created. Please, delivery the object to the designed hotspot.',
                date: DateTime.now())
          ],
          order: true,
          productOrderId: productOrder.id
      );

      Conversation receiverConversation = Conversation(
          id: IdGenerator.generateUniqueConversationId(
              systemProfile.id!, productOrder.receiver.id,
              productOrder.product.id),
          productBasic: ProductBasic(id: productOrder.product.id,
              title: productOrder.product.title,
              urlImages: productOrder.product.urlImages,
              uploadDate: productOrder.product.uploadDate,
              availability: productOrder.product.availability,
              docRefCompleteProduct: productOrder.product.docRef!),
          members: [
            UserDetailsBasic(id: systemProfile.id!,
                fullName: systemProfile.fullName,
                location: systemProfile.location,
                urlPhotoProfile: systemProfile.urlPhotoProfile),
            productOrder.receiver
          ],
          subject: 'An order for ${productOrder.product.title} was created',
          indexOfLastSender: 0,
          startDate: DateTime.now(),
          lastUpdate: DateTime.now(),
          unreadMessage: 1,
          messages: [
            Message(id: IdGenerator.generateUniqueMessageId(
                systemProfile.id!, productOrder.receiver.id),
                sender: UserDetailsBasic(id: systemProfile.id!,
                    fullName: systemProfile.fullName,
                    location: systemProfile.location,
                    urlPhotoProfile: systemProfile.urlPhotoProfile),
                receiver: productOrder.receiver,
                text: 'An order for ${productOrder.product
                    .title} was created. Please, wait for the communication of the object delivered to the designed hotspot.',
                date: DateTime.now())
          ],
          order: true,
          productOrderId: productOrder.id
      );


      await _conversationRepository.createNewConversation( giverConversation);
      await _conversationRepository.createNewConversation(receiverConversation);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateOrderConversation(ProductOrder productOrder) async{
    try{
      String forGiver;
      String forReceiver;
      if(productOrder.orderStatus == OrderStatus.productDeliveredToHotSpot){
        forGiver = 'Thank you for delivery the gift to the hotspot. We will update this chat, when the receiver will pickup the gift.';
        forReceiver = 'Your gift was delivered to ${productOrder.hotSpot.name}. Please, go to pick-up as soon as possible';
      }else{
        forGiver = 'Your donations is completed. Thank to be so generous.';
        forReceiver = 'Donations completed. We hope you can feel better with the help of the communities.';
      }
      return await _conversationRepository.updateOrderConversation(productOrder,forGiver,forReceiver);
    }catch (error){
      rethrow;
    }
  }

  Future<int> unreadedMessageNumber() async{
    try{
      return _conversationRepository.unreadedMessageNumber();
    } catch (error){rethrow;}
  }
}
