import 'package:flutter/material.dart';
import 'package:prototype25/database/database_helper.dart';
import 'package:prototype25/unnamed/widgets/chats/chat_profile/profile_screen.dart';

import 'package:prototype25/utils/dummy_del/chat_dummy.dart';
import 'package:prototype25/utils/models/chat_history_model.dart';
import 'package:prototype25/utils/models/chats_list_model.dart';
import 'package:prototype25/utils/models/message_model.dart';
import 'chat_detail.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  
  String searchString = "";

  
  
  
  List<Chat> _allChats = [];
  List<Chat> res = [];

  
  
  
  
  

  
  String _getRelativeTime(String isoDateTime) {
    if (isoDateTime.isEmpty) return ''; 
    final dateTime = DateTime.tryParse(isoDateTime);
    if (dateTime == null) return ''; 

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      
      return 'Now';
    } else if (diff.inMinutes < 60) {
      
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      
      return '${diff.inHours} hour ago';
    } else if (diff.inDays == 1) {
      
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      
      return '${diff.inDays} days ago';
    } else {
      
      
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  
  Future<void> _loadChatsFromDB() async {
    final dbChats = await _dbHelper.getAllChats();
    
    
    final loadedChats = dbChats.map((row) => Chat.fromMap(row)).toList();

    setState(() {
      _allChats = loadedChats;
      res = List.from(loadedChats); 
    });
  }

  
  void _showNewChatOverlay() {
    showModalBottomSheet(
      backgroundColor: Colors.grey[100],
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return Container(
          height: mediaQuery.size.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Chat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter Phone Number',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '10-digit phone number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Check'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      
      _phoneController.clear();
    });
  }

  
  
  Future<void> _checkPhoneNumber() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit number.')),
      );
      return;
    }

    final newName = 'New User ($phone)';

    
    final dbChats = await _dbHelper.getAllChats();
    final existingChat = dbChats.firstWhere(
      (chat) => chat['name'] == newName,
      orElse: () => {},
    );

    Navigator.pop(context); 

    if (existingChat.isNotEmpty) {
      
      final existingChatId = existingChat['id'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            friendName: newName,
            id: existingChatId,
          ),
        ),
      );
      return;
    }

    
    dummyChats[newName] = ChatHistory(
      aboutYou: "I love making plans and trying new restaurants!",
      messages: [
        Message(sender: 'me', text: 'Hey, are we still meeting today?'),
      ],
    );

    
    final newChatData = Chat(
      name: newName,
      lastMessage: 'Say hello!',
      time: DateTime.now().toIso8601String(),
      unreadCount: 0,
      avatar: Icons.person,
      profilePic: 'assets/images/dummy_profile.png',
      aboutYou: "I love making plans and trying new restaurants!",
    );

    final newChatMap = newChatData.toMap();
    final insertedId = await _dbHelper.insertChat(newChatMap);

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          friendName: newName,
          id: insertedId,
        ),
      ),
    );
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _clearSearch();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    searchString = "";
    setState(() {
      res = List.from(_allChats);
    });
  }

  void _filterChats(String query) {
    setState(() {
      searchString = query;
      if (searchString.isEmpty) {
        res = List.from(_allChats);
      } else {
        res = _allChats
            .where((chat) =>
                chat.name.toLowerCase().contains(searchString.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Friends List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: _toggleSearchBar,
          ),
        ],
      ),
      
      body: Column(
        children: [
          if (_showSearchBar)
            Container(
              color: Colors.grey.shade200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterChats,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _clearSearch();
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<void>(
              stream: _dbHelper.chatStream, 
              builder: (context, snapshot) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _dbHelper.getAllChats(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    
                    List<Chat> newChats =
                        snapshot.data!.map((e) => Chat.fromMap(e)).toList();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _allChats = newChats;
                        if (searchString.isEmpty) {
                          res = List.from(_allChats);
                        } else {
                          _filterChats(searchString);
                        }
                      });
                    });

                    return res.isEmpty
                        ? const Center(child: Text("No results found"))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            itemCount: res.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final friend = res[index];
                              return _buildFriendItem(friend, context);
                            },
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: _showNewChatOverlay,
        child: const Icon(Icons.open_in_new_rounded, color: Colors.white),
      ),
    );
  }

  
  Widget _buildFriendItem(Chat friend, BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showChatOptions(context, friend), 
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2.0,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      friendName: friend.name,
                      id: friend.id!,
                    ),
                  ),
                );
              },
              icon: Icon(
                friend.avatar,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            friend.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            friend.lastMessage,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getRelativeTime(friend.time),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (friend.unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    friend.unreadCount.toString(),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatDetailPage(friendName: friend.name, id: friend.id!),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, Chat friend) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("View Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        friendName: friend.name,
                        id: friend.id!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.mark_chat_unread),
                title: Text(
                    friend.unreadCount > 0 ? "Mark as Read" : "Mark as Unread"),
                onTap: () {
                  Navigator.pop(context);
                  _toggleReadStatus(friend);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Chat",
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteChat(friend);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleReadStatus(Chat friend) {
    
    
    

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              friend.unreadCount == 0 ? "Marked as read" : "Marked as unread")),
    );
  }

  void _confirmDeleteChat(Chat friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Chat"),
          content: Text(
              "Are you sure you want to delete the chat with ${friend.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); 
                await _dbHelper.deleteChat(friend.id!);
                _loadChatsFromDB(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chat deleted successfully")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
