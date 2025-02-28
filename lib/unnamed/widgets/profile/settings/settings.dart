import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype25/blocs/app/app_bloc.dart';
import 'package:prototype25/blocs/app/app_event.dart';
import 'package:prototype25/blocs/app/app_state.dart';
import 'package:prototype25/blocs/auth/auth_bloc.dart';
import 'package:prototype25/blocs/auth/auth_event.dart';
import 'package:prototype25/login/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'manage_my_account_page.dart';
import 'privacy_and_safety_page.dart';
import 'content_preferences_page.dart';
import 'share_profile_page.dart';
import 'vreelscode_page.dart';
import 'push_notifications_page.dart';
import 'language_page.dart';
import 'digital_wellbeing_page.dart';
import 'accessibility_page.dart';
import 'data_saver_page.dart';
import 'report_problem_page.dart';
import 'help_center_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy and settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('ACCOUNT'),
            _buildSettingItem(
              Icons.person_outline,
              'Manage my account',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageMyAccountPage()),
              ),
            ),
            _buildSettingItem(
              Icons.lock_outline,
              'Privacy and safety',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyAndSafetyPage()),
              ),
            ),
            _buildSettingItem(
              Icons.video_library_outlined,
              'Content preferences',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContentPreferencesPage()),
              ),
            ),
            _buildSettingItem(
              Icons.ios_share_outlined,
              'Share profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShareProfilePage()),
              ),
            ),
            _buildSettingItem(
              Icons.qr_code_2_outlined,
              'Vreels Code',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VreelsCodePage()),
              ),
            ),
            const Divider(height: 32, thickness: 0.5),

            _buildSectionTitle('GENERAL'),
            _buildSettingItem(
              Icons.notifications_outlined,
              'Push notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PushNotificationsPage()),
              ),
            ),
            _buildSettingItem(
              Icons.language_outlined,
              'Language',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguagePage()),
              ),
            ),
            _buildSettingItem(
              Icons.health_and_safety_outlined,
              'Digital Wellbeing',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DigitalWellbeingPage()),
              ),
            ),
            _buildSettingItem(
              Icons.accessibility_new_outlined,
              'Accessibility',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccessibilityPage()),
              ),
            ),
            _buildSettingItem(
              Icons.data_saver_on_outlined,
              'Data Saver',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DataSaverPage()),
              ),
            ),
            const Divider(height: 32, thickness: 0.5),

            _buildSectionTitle('SUPPORT'),
            _buildSettingItem(
              Icons.report_outlined,
              'Report a problem',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportProblemPage()),
              ),
            ),
            _buildSettingItem(
              Icons.help_outline,
              'Help Center',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpCenterPage()),
              ),
            ),
            const Divider(height: 32, thickness: 0.5),

            
            _buildLogoutItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  
  Widget _buildSettingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLogoutItem() {
    return InkWell(
      onTap: () {
        logout(context.read<AppBloc>(), context.read<AuthBloc>());
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.logout_outlined, color: Colors.red, size: 22),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void logout(AppBloc appBloc, AuthBloc authBloc) {
    FirebaseAuth.instance.signOut();
    appBloc.add(const AppReset());
    authBloc.add(AuthReset());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyLoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
