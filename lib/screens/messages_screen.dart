import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/screens/add_group_screen.dart';

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
        const Center(
          child: Text("You have not been added to any groups yet."),
        ),
      ],
    );
  }
}
