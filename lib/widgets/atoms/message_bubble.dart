import 'package:flutter/material.dart';
import 'package:fox_tales/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.chatMessage, {super.key});

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Text(chatMessage.message);
  }
}
