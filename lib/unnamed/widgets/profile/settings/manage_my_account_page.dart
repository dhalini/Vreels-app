import 'package:flutter/material.dart';
import 'manage_my_account_details_page.dart';

class ManageMyAccountPage extends StatelessWidget {
  const ManageMyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage my account',
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
          _buildAccountItem(
            context, 'Account Details', Icons.account_circle_outlined,
            const ManageMyAccountDetailsPage(),
          ),
          _buildAccountItem(context, 'Change Email', Icons.email_outlined, null),
          _buildAccountItem(context, 'Phone Number', Icons.phone_outlined, null),
          _buildAccountItem(context, 'Linked Accounts', Icons.link_outlined, null),
          _buildAccountItem(context, 'Delete Account', Icons.delete_outline, null),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, String title, IconData icon, Widget? page) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Padding(
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
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
