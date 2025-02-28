

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype25/Registration/custom_dropdown.dart';


import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/app/app_bloc.dart';
import '../blocs/app/app_event.dart';


import './validators.dart';
import './picture_upload.dart';


import 'custom_text_field.dart';


import 'cold_start.dart'; 

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutController = TextEditingController();

  
  String? _selectedGender;

  
  String? _genderError;
  String? _nameError;
  String? _usernameError;
  String? _dobError;
  String? _emailError;
  String? _aboutError;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final appBloc = context.read<AppBloc>();

    return PopScope(
      canPop: true, 
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          name(authBloc,appBloc);
        }
      },

      
      
      child: Scaffold(
        backgroundColor: Colors.white, 
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                name(authBloc,appBloc);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: Title(
              color: Colors.black,
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 18),
              )),
          centerTitle: true,
        ),

        
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 10, 
                color: Colors.blue[100], 
                child: Row(
                  children: [
                    
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.blue, 
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: PictureUpload()),
                      const SizedBox(height: 32),

                      
                      CustomTextField(
                        controller: _nameController,
                        label: 'Name*',
                        hint: 'Enter your full name.',
                        maxLength: 50,
                        errorText: _nameError,
                        onChanged: (value) {
                          setState(() {
                            _nameError = Validators.validateName(value.trim());
                          });
                        },
                      ),

                      
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username*',
                        hint: 'Choose a username.',
                        maxLength: 20,
                        errorText: _usernameError,
                        onChanged: (value) {
                          setState(() {
                            _usernameError =
                                Validators.validateUsername(value.trim());
                          });
                        },
                      ),

                      
                      
                      CustomDropdownField(
                        label: 'Gender*',
                        value: _selectedGender,
                        hint: 'Select your gender',
                        options: const ['Male','Female'],
                        errorText: _genderError,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                            
                            _genderError = null;
                          });
                        },
                      ),

                      
                      CustomTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        hint: 'DD/MM/YYYY',
                        errorText: _dobError,
                        hasDatePickerIcon: true,
                        onDateIconTap: () => _selectDate(),
                        onChanged: (value) {
                          setState(() {
                            value = Validators.formatDOB(value);
                            _dobController.text = value;
                            _dobError = Validators.validateDOB(value.trim());
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),

                      
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email address.',
                        maxLength: 50,
                        errorText: _emailError,
                        onChanged: (value) {
                          setState(() {
                            _emailError =
                                Validators.validateEmail(value.trim());
                          });
                        },
                      ),

                      
                      CustomTextField(
                        controller: _aboutController,
                        label: 'About You',
                        hint: 'Tell us about yourself (max 150 characters).',
                        maxLines: 3,
                        maxLength: 150,
                        errorText: _aboutError,
                        onChanged: (value) {
                          setState(() {
                            _aboutError =
                                Validators.validateAbout(value.trim());
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      
                      ElevatedButton(
                        onPressed: _onSaveAndContinue,
                        
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.blue, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save and Continue',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void name(AuthBloc authBloc, AppBloc appBloc) {
    authBloc.add(AuthReset());
    appBloc.add(const AppReset());
    FirebaseAuth.instance.signOut();
  }

  void _onSaveAndContinue() async {
    final authState = context.read<AuthBloc>().state;
    final appBloc = context.read<AppBloc>();
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final dob = _dobController.text.trim();
    final email = _emailController.text.trim();
    final about = _aboutController.text.trim();

    
    setState(() {
      _nameError = Validators.validateName(name);
      _usernameError = Validators.validateUsername(username);
      _dobError = Validators.validateDOB(dob);
      _emailError = Validators.validateEmail(email);
      _aboutError = Validators.validateAbout(about);
    });

    
    if (_nameError != null ||
        _usernameError != null ||
        _dobError != null ||
        _emailError != null ||
        _aboutError != null) {
      return;
    }

    
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _usernameError =
              'Username is already taken, please choose another one.';
        });
        return;
      }
    } catch (e) {
      debugPrint('Error checking username uniqueness: $e');
      return;
    }

    
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No authenticated user found.')),
      );
      return;
    }

    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'name': name,
        'username': username,
        'dob': dob,
        'gender': _selectedGender,
        'email': email,
        'about': about,
        'phone': '${authState.countryCode}${authState.phoneNumber}',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving user data to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving data. Please try again.')),
      );
      return;
    }

    
    appBloc.add(
      UserUpdated(
        name: name,
        username: username,
        dob: dob,
        gender: _selectedGender,
        email: email,
        about: about,
        phone: '${authState.countryCode}${authState.phoneNumber}',
      ),
    );

    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColdStartScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      _dobController.text = '$day/$month/$year';

      setState(() {
        _dobError = Validators.validateDOB(_dobController.text.trim());
      });
    }
  }
}
