import 'package:flutter/material.dart';
import 'package:prototype25/blocs/app/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowsPage extends StatefulWidget {
  final int defaultTab; 

  const FollowsPage({Key? key, required this.defaultTab}) : super(key: key);

  @override
  State<FollowsPage> createState() => _FollowsPageState();
}

class _FollowsPageState extends State<FollowsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.defaultTab, 
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appState.username,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true, 
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1), 
            color: Colors.black,
            onPressed: () {
              
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48), 
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            tabs: const [
              Tab(child: Text.rich(TextSpan(children: [TextSpan(text: 'Following '), TextSpan(text: '1', style: TextStyle(fontWeight: FontWeight.bold))]))),
              Tab(child: Text.rich(TextSpan(children: [TextSpan(text: 'Followers '), TextSpan(text: '0', style: TextStyle(fontWeight: FontWeight.bold))]))),
              Tab(text: 'Suggested'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          
          _buildFollowingTab(),
          
          _buildFollowersTab(),
          
          _buildSuggestedTab(),
        ],
      ),
    );
  }

  Widget _buildFollowingTab() {
    return Center(child: Text('Following tab content...'));
  }

  Widget _buildFollowersTab() {
    return Center(child: Text('Followers tab content...'));
  }

  Widget _buildSuggestedTab() {
    return Center(child: Text('Suggested tab content...'));
  }
}
