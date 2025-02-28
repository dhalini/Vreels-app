import 'package:flutter/material.dart';
import 'package:prototype25/utils/dummy_del/chat_dummy.dart';
import 'package:prototype25/database/database_helper.dart';
import 'package:prototype25/utils/models/chat_history_model.dart';
import 'profile_actions.dart';
import 'profile_header.dart';

class ProfileScreen extends StatefulWidget {
  final String friendName;
  final int id;
  const ProfileScreen({Key? key, required this.friendName, required this.id})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late ChatHistory? person;
  String aboutYou ="";
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    
    _controller.forward();
  }

  Future<void> _loadProfileInfo() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'chats',
      where: 'id = ?', 
      whereArgs: [widget.id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      
      aboutYou = (result.first['about_you'] as String?) ?? 'Placeholder';
    } else {
      
      aboutYou = 'Placeholder';
    }

    
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      SlideTransition(
                        position: _slideAnimation,
                        child: ProfileHeader(
                          userName: widget.friendName,
                          bio: aboutYou,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProfileActions(
              onDeleteChat: () {
                
              },
              onReport: () {
                
              },
              onBlock: () {
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
