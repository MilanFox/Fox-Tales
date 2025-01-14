import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first(this.chatMessage, {super.key})
      : isFirstInSequence = true;

  const MessageBubble.next(this.chatMessage, {super.key})
      : isFirstInSequence = false;

  const MessageBubble.system(this.chatMessage, {super.key})
      : isFirstInSequence = true;

  final bool isFirstInSequence;
  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMe =
        chatMessage.user.uid == FirebaseAuth.instance.currentUser!.uid;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isFirstInSequence) const SizedBox(height: 18),
        if (isFirstInSequence)
          Row(
            textDirection: isMe ? TextDirection.ltr : TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                chatMessage.getDate(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 13,
                  right: 13,
                ),
                child: Text(
                  chatMessage.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : theme.colorScheme.primary.withAlpha(200),
            borderRadius: BorderRadius.only(
              topLeft: !isMe && isFirstInSequence
                  ? Radius.zero
                  : const Radius.circular(12),
              topRight: isMe && isFirstInSequence
                  ? Radius.zero
                  : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 14,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (chatMessage.mediaLink != "" && chatMessage.mediaLink != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CachedNetworkImage(
                    imageUrl: chatMessage.mediaLink!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              if (chatMessage.message != "")
                Text(
                  chatMessage.message,
                  style: TextStyle(
                    height: 1.3,
                    color: isMe ? Colors.black87 : theme.colorScheme.onPrimary,
                  ),
                  softWrap: true,
                ),
              Text(
                chatMessage.getTime(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w200,
                  color: isMe ? Colors.black87 : theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
