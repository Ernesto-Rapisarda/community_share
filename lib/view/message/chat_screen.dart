import 'package:community_share/service/auth.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/view/generic_components/message_composer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/conversation.dart';
import '../../model/message.dart';

class ChatScreen extends StatefulWidget {
  late Conversation _conversation;

  ChatScreen({super.key, required Conversation conversation}) {
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget._conversation.members[0].urlPhotoProfile),
            ),
            SizedBox(width: 8),
            Text(widget._conversation.members[0].fullName,style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),), // Nome dell'altro utente
          ],
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () {
            },
          ),

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
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          !widget._conversation.order? MessageComposer(messageController: _messageController, onSendPressed: onSendPressed, onClose: onClose):Center(),
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
          border: Border.all(
            width: 1,
            color: Theme.of(context).dividerColor
          )
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