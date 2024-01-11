import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/models/chat_message.dart';
import 'package:fox_tales/models/user.dart';
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

            return Column(
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

                      return MessageBubble(message);
                    },
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'New Message'),
                  maxLines: 3,
                  controller: _chatMessageController,
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ));
  }
}
