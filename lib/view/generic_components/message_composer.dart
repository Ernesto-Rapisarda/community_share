import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageComposer extends StatefulWidget {
  final TextEditingController messageController;
  final Function() onSendPressed;
  final Function() onClose;


  const MessageComposer({super.key, required this.messageController, required this.onSendPressed, required this.onClose});


  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  bool _isEmojiPickerVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: widget.messageController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        if (_isEmojiPickerVisible)
          Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                widget.messageController.text =
                    widget.messageController.text + emoji.emoji;
                setState(() {
                  _isEmojiPickerVisible = !_isEmojiPickerVisible;
                });
              },
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.faceSmile),
              onPressed: () {
                setState(() {
                  _isEmojiPickerVisible = !_isEmojiPickerVisible;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                widget.onSendPressed();
                widget.onClose();
              },
            ),
            IconButton(onPressed: (){
              setState(() {
                widget.onClose();
              });
            }, icon: FaIcon(FontAwesomeIcons.circleXmark))
          ],
        ),
      ],
    );
  }
}