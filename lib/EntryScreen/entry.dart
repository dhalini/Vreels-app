import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype25/database/database_helper.dart';
import 'package:prototype25/unnamed/five_widgets.dart';
import 'package:prototype25/EntryScreen/loading_animation.dart';
import 'package:prototype25/utils/firebase/fetch_user.dart';
import 'package:prototype25/utils/permissions.dart';

class EntryWidget extends StatefulWidget {
  const EntryWidget({super.key});

  @override
  _EntryWidgetState createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget> {
  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper();
    _initializePermissions();
    _initializeFuture = _initializeUserData();
  }

  Future<void> _initializePermissions() async {
    await PermissionRequest.requestAppPermissions(context);
  }

  Future<void> _initializeUserData() async {
    
    await Future.delayed(const Duration(milliseconds: 500));

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await fetchAndUpdateUserData(context, currentUser.uid);
    } else {
      debugPrint('No authenticated user found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildContent(snapshot),
          );
        },
      ),
    );
  }

  Widget _buildContent(AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      
      return const LoadingPlaceholder();
    } else if (snapshot.hasError) {
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              'Something went wrong!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${snapshot.error}',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    
    return FiveWidgets();
  }
}

