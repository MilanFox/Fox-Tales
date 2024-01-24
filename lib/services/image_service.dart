import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

Future uploadImage(String bucket, File image, String description) async {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(bucket)
      .child('assets')
      .child('${DateTime.now()}.jpg');

  await storageRef.putFile(image);
  final imageURL = await storageRef.getDownloadURL();

  FirebaseFirestore.instance
      .collection('public_feed')
      .doc(DateTime.now().millisecondsSinceEpoch.toString())
      .set({
    'imageUrl': imageURL,
    'description': description,
    'createdAt': DateFormat('dd.MM.yyyy').format(DateTime.now()),
    'timestamp': DateTime.now().millisecondsSinceEpoch
  });
}
