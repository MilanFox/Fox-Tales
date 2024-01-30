import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final firestore = FirebaseFirestore.instance;
final firebaseMessaging = FirebaseMessaging.instance;

Future<void> setupPushNotifications() async {
  await firebaseMessaging.requestPermission();
  final token = await firebaseMessaging.getToken();
  await registerNotificationToken(token);
}

Future<void> registerNotificationToken(token) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final notifications = firestore.collection('notifications');

  await notifications.doc(uid).set({
    "token": FieldValue.arrayUnion([token])
  }, SetOptions(merge: true));

  await notifications.doc('all').set({
    "token": FieldValue.arrayUnion([token])
  }, SetOptions(merge: true));
}

Future<List<String>> getNotificationTokenFromUid(uid) async {
  final userData = await firestore.doc(uid).get();
  return userData['token'];
}

Future<List<String>> getAllNotificationTokens() async {
  final userData = await firestore.doc('all').get();
  return userData['token'];
}

Future<void> subscribeToNotificationsFrom(topic) async {
  await firebaseMessaging.subscribeToTopic(topic);
}
