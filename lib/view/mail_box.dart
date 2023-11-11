import 'package:community_share/reporitory/conversation_repository.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:flutter/material.dart';

import '../model/conversation.dart';

class MailBox extends StatefulWidget{

  const MailBox({super.key});

  @override
  State<MailBox> createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  List<Conversation> _myConversations=[];
  final ConversationService _conversationService = ConversationService();


  @override
  void initState() {
    super.initState();
    fetchConversations();

  }


  void fetchConversations() async{
    List<Conversation> myConversations = await _conversationService.getMyConversations(context);
    setState(() {
      _myConversations =myConversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _myConversations.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_myConversations[index].productBasic.title),
          subtitle: Text('Last message: ${_myConversations[index].messages.last.text}'),
          onTap: () {
            //todo  gestire visualizzazione scambi di messaggi
          }
            );
          },
        );


  }

}