import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_tales/models/chat_message.dart';
import 'package:fox_tales/models/user.dart';

final chatGroupsRef =
    FirebaseFirestore.instance.collection('messages').doc('groups');

Future getDataOfRef(DocumentReference<Map<String, dynamic>> ref) async {
  final currentData = await ref.get();
  return currentData.data()!;
}

Future updateLastMessageOnGroup(String group, String message) async {
  final groupData = await getDataOfRef(chatGroupsRef);
  final lastMessage = message == "" ? "New Message" : message;
  groupData['groupData'][group]['lastMessage'] = lastMessage;
  await chatGroupsRef.update(groupData);
}

Future sendChatMessage(String group, ChatMessage chatMessage) async {
  await chatGroupsRef.collection(group).add(chatMessage.toMap());
  await updateLastMessageOnGroup(group, chatMessage.message);
}

Future createNewGroup(String name, List<String> members) async {
  final groupData = await getDataOfRef(chatGroupsRef);

  groupData['groupData'][name] = {
    'name': name,
    'members': members,
    'lastMessage': "You have been added to group '$name'."
  };

  await chatGroupsRef.update(groupData);
  await chatGroupsRef.collection(name).add(ChatMessage(
        user: AppUser(name: 'system', uid: "-"),
        message: "You have been added to group '$name'.",
      ).toMap());
}

Future deleteMessage(group, messageID, name) async {
  await chatGroupsRef.collection(group).doc(messageID).update({
    "message": "A message has been deleted by $name.",
    "user": {"name": "system", "uid": "-"}
  });
}
