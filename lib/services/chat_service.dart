import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_tales/models/chat_message.dart';
import 'package:fox_tales/models/user.dart';

final groupsRef =
    FirebaseFirestore.instance.collection('messages').doc('groups');

Future getDataOfRef(DocumentReference<Map<String, dynamic>> ref) async {
  final currentData = await ref.get();
  return currentData.data()!;
}

Future updateLastMessageOnGroup(String group, String message) async {
  final groupData = await getDataOfRef(groupsRef);
  groupData['groupData'][group]['lastMessage'] = message;
  await groupsRef.update(groupData);
}

Future sendChatMessage(String group, ChatMessage chatMessage) async {
  await groupsRef.collection(group).add(chatMessage.toMap());
  await updateLastMessageOnGroup(group, chatMessage.message);
}

Future createNewGroup(String name, List<String> members) async {
  final groupData = await getDataOfRef(groupsRef);

  groupData['groupData'][name] = {
    'name': name,
    'members': members,
    'lastMessage': "You have been added to group '$name'."
  };

  await groupsRef.update(groupData);
  await groupsRef.collection(name).add(ChatMessage(
        user: AppUser(name: 'system', uid: "-"),
        message: "You have been added to group '$name'.",
      ).toMap());
}
