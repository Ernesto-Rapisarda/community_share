import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/conversation_repository.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/conversation.dart';

class MailBox extends StatefulWidget {
  const MailBox({super.key});

  @override
  State<MailBox> createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  List<Conversation> _myConversations = [];
  final ConversationService _conversationService = ConversationService();

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  void fetchConversations() async {
    List<Conversation> myConversations =
        await _conversationService.getMyConversations(context);
    int unreadMessage = await _conversationService.unreadedMessageNumber();
    setState(() {
      context.read<UserProvider>().unreadMessage = unreadMessage;
      _myConversations = myConversations;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Message Box',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: ListView.builder(
        itemCount: _myConversations.length,
        itemBuilder: (context, index) {
          final conversation = _myConversations[index];
          final otherUser = conversation.members
              .firstWhere((member) => member.id != Auth().currentUser?.uid);
          bool imLastSender = conversation.members[conversation.indexOfLastSender].id == Auth().currentUser?.uid;

          return ListTile(
            onTap: () {
              context.go('/message_box/${conversation.id}',extra: conversation);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(otherUser.urlPhotoProfile),
              radius: 30,
            ),
            trailing: FaIcon(FontAwesomeIcons.chevronRight),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${otherUser.fullName}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.subject,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Unread message: ${conversation.unreadMessage}',style: TextStyle(color: !imLastSender && conversation.unreadMessage>0? Colors.red : Colors.green ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
