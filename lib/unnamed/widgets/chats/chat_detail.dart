import 'package:flutter/material.dart';
import 'package:prototype25/database/database_helper.dart';
import 'package:prototype25/unnamed/widgets/calls/audio_calls/audio_call.dart';
import 'package:prototype25/unnamed/widgets/calls/video_calls/video_call.dart';

import 'package:prototype25/utils/models/message_model.dart';
import 'chat_profile/profile_screen.dart';

class ChatDetailPage extends StatefulWidget {
  final String friendName;
  final int id;

  const ChatDetailPage({
    Key? key,
    this.friendName = 'Unknown',
    required this.id,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _messageController = TextEditingController();

  

  
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatFromDB();
  }

  
  
  Future<void> _loadChatFromDB() async {
    final messageRows = await _dbHelper.getMessagesForChat(widget.id);
    final loadedMessages = messageRows.map((row) {
      return Message(
        sender: row['sender'],
        text: row['text'],
      );
    }).toList();

    setState(() {
      messages = loadedMessages;
    });
  }

  
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    String timestamp = DateTime.now().toIso8601String();

    
    await _dbHelper.insertMessage(
      chatId: widget.id,
      sender: 'me',
      text: text,
    );
    await _dbHelper.updateChatLastMessage(
      chatId: widget.id,
      lastMessage: text,
      time: timestamp,
    );
    await _loadChatFromDB(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  friendName: widget.friendName,
                  id: widget.id
                ),
              ),
            );
          },
          child: Text(
            widget.friendName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallPage(
                        userName: widget.friendName, avatarUrl: 'Hi'),
                  ),
                );
              }),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoCallPage(
                          userName: widget.friendName, avatarUrl: 'Hi')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, 
              itemCount: messages.length,
              itemBuilder: (context, index) {
                
                final reversedIndex = messages.length - 1 - index;
                final message = messages[reversedIndex];
                final isMe = message.sender == 'me';

                return Container(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Message...'),
                  ),
                ),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
