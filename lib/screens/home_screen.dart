import 'package:flutter/material.dart';
import 'package:fox_tales/models/post.dart';
import 'package:fox_tales/widgets/atoms/feed_entry.dart';

Post sealPost = Post(
  description:
      'Dicker Seehund. 🦭 Ich bin der Eierschädel , oh sie sind die Eierschädel, oh ich bin das Walroß , GOO GOO G’JOOB. Sitz in einem Englischen Garten , warte auf die Sonne, wenn die Sonne nicht kommt, kriegst du eine Bräune vom stehen im Englischen Regen.',
  imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/foxtales-app.appspot.com/o/public_feed%2Fassets%2F2024-01-10%2012%3A39%3A09.304825.jpg?alt=media&token=eef8acd9-2503-42b4-8a3c-40719e6bcc86',
  createdAt: '10.01.2024',
);

Post verticalPost = Post(
  description: 'Hier kommt die Braut.👰🏻‍♂️',
  imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/foxtales-app.appspot.com/o/public_feed%2Fassets%2F2024-01-10%2012%3A48%3A46.311556.jpg?alt=media&token=7f5546db-3b9c-456f-a51a-a48e6e45be52',
  createdAt: '10.01.2024',
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FeedEntry(sealPost),
          FeedEntry(verticalPost),
        ],
      ),
    );
  }
}
