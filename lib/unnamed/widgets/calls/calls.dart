import 'package:flutter/material.dart';
import 'package:prototype25/database/database_helper.dart';
import 'package:prototype25/unnamed/widgets/calls/audio_calls/audio_call.dart';
import 'package:prototype25/unnamed/widgets/calls/video_calls/video_call.dart';
import 'package:prototype25/utils/dummy_del/call_logs.dart';
import 'package:prototype25/utils/dummy_del/chats_list.dart';
import 'package:prototype25/utils/models/call_model.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  
  String searchString = "";

  
  
  List<Call> res = calls;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCallsFromDB(); 
  }

  Future<void> _loadCallsFromDB() async {
    final dbCalls = await _dbHelper.getAllCalls(); 
    setState(() {
      res = dbCalls
          .map((map) => Call.fromMap(map))
          .toList(); 
    });
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
    _loadCallsFromDB();
  }

  void _filterChats(String query) {
    setState(() {
      searchString = query;
      if (searchString.isEmpty) {
        _loadCallsFromDB();
      } else {
        res = calls
            .where((call) =>
                call.name.toLowerCase().contains(searchString.toLowerCase()))
            .toList();
      }
    });
  }

  
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

  
  
  
  

  
  
  
  @override
  Widget build(BuildContext context) {
    final bool noResults =
        _showSearchBar && searchString.isNotEmpty && chats.isEmpty;

    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Calls',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: _toggleSearchBar,
          ),
        ],
      ),

      
      body: Column(children: [
        if (_showSearchBar)
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                          setState(() {
                            _clearSearch();
                          });
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
        if (noResults)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No results found.',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: res.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final call = res[index];
              return _buildCallItem(call);
            },
          ),
        ),
      ]),

      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          
        },
        child: const Icon(Icons.call, color: Colors.white),
      ),
    );
  }

  
  
  
  Widget _buildCallItem(call) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2.0,
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              call.avatar,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: Text(
            call.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${call.detail} · ${_getRelativeTime(call.time)}',
            style: TextStyle(
              color:
                  call.callType == CallType.missed ? Colors.red : Colors.grey,
              fontSize: 14,
            ),
          ),
          trailing: Icon(
            call.isVideo ? Icons.videocam : Icons.phone,
            color: call.callType == CallType.missed ? Colors.red : Colors.grey,
          ),
          onTap: () {
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                if (call.isVideo) {
                  return VideoCallPage(userName: call.name, avatarUrl: 'hi');
                }
                return AudioCallPage(userName: call.name, avatarUrl: 'Hi');
              }),
            );
          }),
    );
  }
}
