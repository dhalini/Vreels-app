import 'package:flutter/material.dart';
import 'widgets/calls/calls.dart';
import 'widgets/reels_2/reels.dart';
import 'widgets/upload/upload.dart';
import 'widgets/chats/friends_list.dart';
import 'widgets/profile/profile.dart';

class FiveWidgets extends StatefulWidget {
  const FiveWidgets({super.key});

  @override
  _FiveWidgetsState createState() => _FiveWidgetsState();
}

class _FiveWidgetsState extends State<FiveWidgets> {
  int _currentIndex = 1;

  final List<Widget> _mainPages = [
    const CallsPage(),
    const ReelsPage(),
    const UploadPage(),
    const FriendsListPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _mainPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: "Reels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
