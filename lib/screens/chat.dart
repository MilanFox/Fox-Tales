import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/models/chat_message.dart';
import 'package:fox_tales/models/user.dart';
import 'package:fox_tales/services/chat_service.dart';
import 'package:fox_tales/widgets/atoms/chat_system_message.dart';
import 'package:fox_tales/widgets/atoms/message_bubble.dart';

class Chat extends StatefulWidget {
  const Chat(this.name, {super.key});

  final String name;

  @override
  State<Chat> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<Chat> {
  final _chatMessageController = TextEditingController();

  @override
  void dispose() {
    _chatMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .doc('groups')
              .collection(widget.name)
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No messages found'));
            }

            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error while fetching the data.'));
            }

            final messages = data!.docs;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) {
                        final message = ChatMessage(
                            user: AppUser(
                                name: messages[index]['user']['name'],
                                uid: messages[index]['user']['uid']),
                            message: messages[index]['message'],
                            timestamp: messages[index]['timestamp']);

                        if (messages[index]['user']['uid'] == "-") {
                          return ChatSystemMessage(
                              (messages[index]['message']));
                        }

                        return index == 0 ||
                                messages[index]['user']['uid'] !=
                                    messages[index - 1]['user']['uid']
                            ? MessageBubble.first(message)
                            : MessageBubble.next(message);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'New Message'),
                          maxLines: 1,
                          controller: _chatMessageController,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          final user = AppUser(
                              name: currentUser!.displayName!,
                              uid: currentUser.uid);
                          final message = ChatMessage(
                            user: user,
                            message: _chatMessageController.text,
                          );

                          sendChatMessage(widget.name, message);
                          _chatMessageController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
