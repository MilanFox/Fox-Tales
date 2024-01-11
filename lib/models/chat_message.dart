import 'package:fox_tales/models/user.dart';

class ChatMessage {
  ChatMessage({
    required this.user,
    required this.message,
  });

  final AppUser user;
  final String message;
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'user': {'name': user.name, "uid": user.uid},
      'message': message,
      'timestamp': timestamp,
    };
  }
}
