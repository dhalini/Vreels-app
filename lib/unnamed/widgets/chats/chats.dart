import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final List<Chat> _chats = [
    Chat(
      name: 'Sarah Wilson',
      message: 'Hey, are we still meeting today?',
      time: '9:45 AM',
      avatar: Icons.person,
      unreadCount: 0,
    ),
    Chat(
      name: 'Design Team',
      message: 'New project updates available...',
      time: '11:20 AM',
      avatar: Icons.group,
      unreadCount: 3,
    ),
    Chat(
      name: 'John Smith',
      message: 'Thanks for the help!',
      time: 'Yesterday',
      avatar: Icons.person,
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats.',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: _chats.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return _buildChatItem(chat);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2.0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            chat.avatar,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          chat.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          chat.message,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat.time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (chat.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          
        },
      ),
    );
  }
}

class Chat {
  final String name;
  final String message;
  final String time;
  final IconData avatar;
  final int unreadCount;

  Chat({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    required this.unreadCount,
  });
}
