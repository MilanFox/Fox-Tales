import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future uploadImage(String bucket, File image) async {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(bucket)
      .child('assets')
      .child('${DateTime.now()}.jpg');

  await storageRef.putFile(image);
  final imageURL = await storageRef.getDownloadURL();

  return imageURL;
}
