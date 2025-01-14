import 'package:fox_tales/models/user.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  ChatMessage(
      {required this.user,
      required this.message,
      int? timestamp,
      String? mediaLink})
      : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch,
        mediaLink = mediaLink ?? "";

  final AppUser user;
  final String message;
  final int timestamp;
  final String? mediaLink;

  Map<String, dynamic> toMap() {
    return {
      'user': {'name': user.name, "uid": user.uid},
      'message': message,
      'timestamp': timestamp,
      'mediaLink': mediaLink
    };
  }

  String getDate() => DateFormat('dd.MM.yy')
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  String getTime() => DateFormat('HH:mm')
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}
