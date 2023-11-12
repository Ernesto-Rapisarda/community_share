import 'package:community_share/service/auth.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/view/generic_components/message_composer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/conversation.dart';
import '../../model/message.dart';

class ChatScreen extends StatefulWidget {
  late Conversation _conversation;

  ChatScreen({Key? key, required Conversation conversation}) : super(key: key) {
    _conversation = conversation;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationService _conversationService = ConversationService();
  final TextEditingController _messageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setMessagesReaded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              // Mostra l'avatar dell'altro utente
              backgroundImage: NetworkImage(widget._conversation.members[1].urlPhotoProfile),
            ),
            SizedBox(width: 8),
            Text(widget._conversation.members[1].fullName), // Nome dell'altro utente
          ],
        ),
        actions: [
          // Aggiungi eventuali azioni all'appbar (es. chiamata, videochiamata, ecc.)
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Aggiungi la logica per la chiamata
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Aggiungi la logica per la videochiamata
            },
          ),
          // ... altre azioni
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget._conversation.messages.length,
              itemBuilder: (context, index) {
                final message = widget._conversation.messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          MessageComposer(messageController: _messageController, onSendPressed: onSendPressed, onClose: onClose),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final isMe = message.sender.id == Auth().currentUser?.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 16,color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat.Hm().format(message.date.toLocal()),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  

  onSendPressed() async{
    Conversation conversation = await _conversationService.sendReply(context,widget._conversation, _messageController.text);
    setState(() {
      widget._conversation = conversation;
    });
  }

  onClose() {
  }

  void setMessagesReaded() {
    _conversationService.setMessagesReaded(context, widget._conversation);
  }
}