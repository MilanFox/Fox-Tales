import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/models/chat_message.dart';
import 'package:fox_tales/models/user.dart';
import 'package:fox_tales/services/chat_service.dart';
import 'package:fox_tales/services/image_service.dart';
import 'package:fox_tales/widgets/atoms/chat_system_message.dart';
import 'package:fox_tales/widgets/atoms/message_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

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
  File? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _chatMessageController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future _sendMessage() async {
    if (_chatMessageController.text == "" && _image == null) return;

    setState(() {
      _isLoading = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    final user = AppUser(name: currentUser!.displayName!, uid: currentUser.uid);

    String? imageURL;
    if (_image != null) {
      imageURL = await uploadImage('chats', _image!);
    }

    final message = ChatMessage(
        user: user, message: _chatMessageController.text, mediaLink: imageURL);

    sendChatMessage(widget.name, message);
    _chatMessageController.clear();

    setState(() {
      _image = null;
      _isLoading = false;
    });
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
            .orderBy('timestamp', descending: true)
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
            return const Center(child: Text('Error while fetching the data.'));
          }

          final messages = data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      final message = ChatMessage(
                          user: AppUser(
                              name: messages[index]['user']['name'],
                              uid: messages[index]['user']['uid']),
                          message: messages[index]['message'],
                          timestamp: messages[index]['timestamp'],
                          mediaLink: messages[index]['mediaLink']);

                      if (messages[index]['user']['uid'] == "-") {
                        return ChatSystemMessage((messages[index]['message']));
                      }

                      final isFirstMessage = index == messages.length - 1;
                      final isDifferentUserThanPrev = message.user.uid !=
                          messages[index + 1]['user']['uid'];
                      final isDifferentDateThanPrev = DateFormat('dd.MM.yy')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  messages[index]['timestamp'])) !=
                          DateFormat('dd.MM.yy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  messages[index + 1]['timestamp']));

                      final messageBubble = isFirstMessage ||
                              isDifferentUserThanPrev ||
                              isDifferentDateThanPrev
                          ? MessageBubble.first(message)
                          : MessageBubble.next(message);

                      return GestureDetector(
                        onLongPress: () {
                          if (FirebaseAuth.instance.currentUser!.uid !=
                              messages[index]['user']['uid']) return;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Message?"),
                                content: const Text(
                                    "Do you really want to delete the message? It will be deleted permanently and will not be recoverable."),
                                surfaceTintColor: Colors.white,
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      deleteMessage(
                                          widget.name,
                                          messages[index].id,
                                          messages[index]['user']['name']);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.delete_forever),
                                    label: const Text("Delete permanently"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.restart_alt,
                                      color: Colors.black,
                                    ),
                                    label: const Text(
                                      "Go back",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: messageBubble,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    if (_image != null)
                      badges.Badge(
                        badgeContent: const Icon(Icons.close, size: 15),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.white,
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                        ),
                        position: badges.BadgePosition.topEnd(),
                        onTap: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                      ),
                    if (_image != null) const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(labelText: 'New Message'),
                        maxLines: 1,
                        controller: _chatMessageController,
                      ),
                    ),
                    IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.attach_file),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send),
                            color: primary,
                          ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
