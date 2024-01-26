import 'package:flutter/material.dart';
import 'package:fox_tales/data/colors.dart';

class ChatSystemMessage extends StatelessWidget {
  const ChatSystemMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: primary),
    );
  }
}