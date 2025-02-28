
class Message {
  final String sender;
  final String text;

  Message({
    required this.sender,
    required this.text,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
    };
  }

  
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] ?? '',
      text: map['text'] ?? '',
    );
  }
}
