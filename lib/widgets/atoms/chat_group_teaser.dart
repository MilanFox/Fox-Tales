import 'package:flutter/material.dart';
import 'package:fox_tales/screens/chat.dart';

class ChatGroupTeaser extends StatelessWidget {
  const ChatGroupTeaser({
    super.key,
    required this.name,
    required this.lastMessage,
  });

  final String name;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return Chat(name);
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
        child: Row(
          children: [
            const Icon(Icons.groups_2, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  Text(
                    lastMessage,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
