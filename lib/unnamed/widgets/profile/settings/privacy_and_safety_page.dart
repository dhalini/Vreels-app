import 'package:flutter/material.dart';

class PrivacyAndSafetyPage extends StatelessWidget {
  const PrivacyAndSafetyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Privacy and safety',
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
          _buildPrivacyItem('Private account', Icons.lock_outline, true),
          _buildPrivacyItem('Sync contacts', Icons.contact_page_outlined, false),
          _buildPrivacyItem('Blocked accounts', Icons.block_outlined, false),
          const SizedBox(height: 24),
          const Text(
            'SAFETY',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildPrivacyItem('Comments', Icons.comment_outlined, false),
          _buildPrivacyItem('Direct messages', Icons.message_outlined, false),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(String title, IconData icon, bool isToggle) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          if (isToggle)
            Switch(
              value: true,
              onChanged: (val) {},
            )
          else
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
