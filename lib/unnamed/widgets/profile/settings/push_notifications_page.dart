import 'package:flutter/material.dart';

class PushNotificationsPage extends StatelessWidget {
  const PushNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Push notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotifToggle('Likes', true),
          _buildNotifToggle('Comments', false),
          _buildNotifToggle('Mentions', true),
          _buildNotifToggle('Direct Messages', true),
        ],
      ),
    );
  }

  Widget _buildNotifToggle(String title, bool currentValue) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            Switch(
              value: currentValue,
              onChanged: (val) {
                setState(() => val = !val);
              },
            ),
          ],
        ),
      );
    });
  }
}
