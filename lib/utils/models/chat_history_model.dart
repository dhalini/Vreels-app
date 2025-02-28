import 'package:prototype25/utils/models/message_model.dart';

class ChatHistory {
  final List<Message> messages;
  final String aboutYou;

  ChatHistory({
    required this.messages,
    required this.aboutYou,
  });

  
  void addMessageAsMe(String text) {
    messages.add(Message(sender: 'me', text: text));
  }

  
  
  Map<String, dynamic> toMap() {
    return {
      'aboutYou': aboutYou,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  
  factory ChatHistory.fromMap(Map<String, dynamic> map) {
    final List<dynamic> msgList = map['messages'] ?? [];
    return ChatHistory(
      aboutYou: map['aboutYou'] ?? '',
      messages: msgList
          .map((msgMap) => Message.fromMap(msgMap as Map<String, dynamic>))
          .toList(),
    );
  }
}
