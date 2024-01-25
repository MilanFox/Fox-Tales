import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fox_tales/models/post.dart';
import 'package:fox_tales/widgets/atoms/feed_entry.dart';

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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('public_feed')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (ctx, feedSnapshot) {
          if (feedSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!feedSnapshot.hasData || feedSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No images found'));
          }

          if (feedSnapshot.hasError) {
            return const Center(child: Text('Error while fetching the data.'));
          }

          final feed = feedSnapshot.data!.docs;

          return ListView.builder(
            itemCount: feed.length,
            itemBuilder: (ctx, index) {
              Post entry = Post(
                  description: feed[index]['description'],
                  imageUrl: feed[index]['imageUrl'],
                  createdAt: feed[index]['createdAt'],
                  timeStamp: feed[index]['timestamp']);
              return FeedEntry(entry);
            },
          );
        });
  }
}
