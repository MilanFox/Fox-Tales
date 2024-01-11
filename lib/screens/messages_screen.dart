import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/screens/add_group_screen.dart';
import 'package:fox_tales/widgets/atoms/chat_group_teaser.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() {
    return _MessagesScreenState();
  }
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('messages').snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  snapshot.hasError) {
                return const Center(
                  child: Center(child: Text('Data Fetching Error.')),
                );
              }

              final groups =
                  snapshot.data!.docs.firstWhere((doc) => doc.id == 'groups');
              final groupData = groups['groupData'] as List<dynamic>;

              return ListView.builder(
                  itemCount: groupData.length,
                  itemBuilder: (ctx, index) {
                    return ChatGroupTeaser(
                      name: groupData[index]['name'],
                      lastMessage: groupData[index]['lastMessage'],
                    );
                  });
            }),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const AddGroupScreen();
              }));
            },
            child: const Icon(
              Icons.add_box,
              size: 50,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}
