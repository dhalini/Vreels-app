import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/profile/settings/settings.dart';
import 'package:prototype25/unnamed/widgets/profile/settings/vreelscode_page.dart';

class ProfileMenuOverlay extends StatelessWidget {
  const ProfileMenuOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          _buildMenuItem(
            context,
            icon: Icons.star_border,
            text: "Studio",
            onTap: () {
              
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.account_balance_wallet_outlined,
            text: "Balance",
            onTap: () {
              
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.qr_code,
            text: "My QR Code",
            onTap: () {
              
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_)=> const VreelsCodePage()));
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            text: "Settings and Privacy",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
