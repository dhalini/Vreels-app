import 'package:flutter/material.dart';

class FollowOptionsOverlay extends StatelessWidget {
  final VoidCallback onUnfollow;

  const FollowOptionsOverlay({Key? key, required this.onUnfollow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(154, 255, 255, 255),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black, size: 24),
              ),
            ),
          ),

          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NFL",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          
          _buildOption(
            icon: Icons.mode_edit_outline_outlined,
            text: "Customize name",
            onTap: () {
              
            },
          ),

          const SizedBox(height: 10),
          
          _buildOption(
            icon: Icons.person_off_outlined,
            text: "Unfollow",
            onTap: () {
              onUnfollow(); 
              Navigator.pop(context); 
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  
  Widget _buildOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          trailing: Icon(icon, color: Colors.black, size: 22),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
