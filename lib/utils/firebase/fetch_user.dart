import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype25/blocs/app/app_event.dart';
import '../../blocs/app/app_bloc.dart'; 

Future<void> fetchAndUpdateUserData(BuildContext context, String userId) async {
  try {
    
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data();

      if (userData != null) {
        
        context.read<AppBloc>().add(
          UserUpdated(
            name: userData['name'] ?? '',
            username: userData['username'] ?? '',
            dob: userData['dob'] ?? '',
            gender: userData['gender'],
            email: userData['email'] ?? '',
            about: userData['about'] ?? '',
            phone: userData['phone'] ?? '',
          ),
        );
      }
    } else {
      debugPrint('User document does not exist.');
      throw Exception('User not found in Firestore.');
    }
  } catch (e) {
    debugPrint('Error fetching user data: $e');
    
  }
}
