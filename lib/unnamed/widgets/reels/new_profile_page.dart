import 'package:flutter/material.dart';

class NewProfilePage extends StatefulWidget {
  final String username;

  const NewProfilePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  bool _isFollowing = false;
  bool _isGridView = true;

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message button tapped!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              
              
              
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 16),
                child: Column(
                  children: [
                    
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Text(
                      widget.username.isEmpty
                          ? 'No Username'
                          : widget.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "User’s short bio goes here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('1.2K', 'Followers'),
                        _buildStat('843', 'Following'),
                        _buildStat('156', 'Posts'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        ElevatedButton(
                          onPressed: _toggleFollow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isFollowing ? Colors.grey.shade300 : Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              color: _isFollowing ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.grid_on,
                      color: _isGridView ? Colors.blue : Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.list,
                      color: !_isGridView ? Colors.blue : Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = false;
                      });
                    },
                  ),
                ],
              ),

              
              
              
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isGridView
                    ? _buildVideoGrid(key: const ValueKey('grid'))
                    : _buildVideoList(key: const ValueKey('list')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoGrid({Key? key}) {
    return GridView.builder(
      key: key,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (_, index) {
        return Container(
          color: Colors.grey.shade300,
          child: Center(
            child: Text('Video ${index + 1}'),
          ),
        );
      },
    );
  }

  Widget _buildVideoList({Key? key}) {
    return ListView.builder(
      key: key,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 100,
          color: Colors.grey.shade300,
          child: Row(
            children: [
              
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey.shade400,
                  child: Center(
                    child: Text('Video ${index + 1}'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'A short description. Tap to watch!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
