import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:prototype25/EntryScreen/entry.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'widgets/header_section.dart';
import 'widgets/phone_input.dart';
import 'widgets/otp_input.dart';
import 'widgets/language_selector.dart';
import '../Registration/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state.isSuccess) {
                  
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    try {
                      final docSnap = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .get();

                      if (docSnap.exists) {
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntryWidget(),
                          ),
                        );
                      } else {
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompleteProfileScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint('Error checking user in Firestore: $e');
                      
                    }
                  } else {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompleteProfileScreen(),
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                final authBloc = context
                    .read<AuthBloc>(); 
                final authState = context.watch<AuthBloc>().state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 3),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    PhoneInputSection(
                        countryCode: state.countryCode,
                        otpSending: state.otpSending,
                        otpFailure: state.isWrongPhone,
                        onCountryCodeChanged: (code) {
                          authBloc.add(CountryCodeChanged(
                              code)); 
                        },
                        onPhoneNumberChanged: (phone) {
                          authBloc.add(PhoneNumberChanged(
                              phone)); 
                        },
                        onPhoneNumberComplete: (fullPhoneNumber) {
                          authBloc.add(RequestOTP(
                              fullPhoneNumber)); 
                        },
                        onBackSpace: (id) {
                          authBloc.add(SetVerificatioID(id));
                        }),
                    if (authState.isWrongPhone)
                      const Text(
                        'Invalid PhoneNumber. Please try again.',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 30),
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    OtpInputSection(onOtpChanged: (otp) {
                      authBloc
                          .add(OtpChanged(otp)); 
                    }),
                    const SizedBox(height: 30),
                    
                    ElevatedButton(
                      onPressed: state.isSubmitting | state.otpSending
                          ? null
                          : () {
                              authBloc.add(
                                  AuthSubmitted()); 
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.otpSending? Colors.grey :  Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    if (state.isFailure)
                      const Text(
                        'Invalid OTP. Please try again.',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (state.isSuccess)
                      const Text(
                        'Login Successful!',
                        style: TextStyle(color: Colors.green),
                      ),
                    const SizedBox(height: 100),
                    const Text(
                      'Language Selector',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LanguageSelector(
                      selectedLanguage: state.language,
                      onLanguageChanged: (language) {
                        
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildSocialIcons(),
                    
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Privacy Policy | Terms of Service | Help',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
        const SizedBox(width: 10),
        IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
        const SizedBox(width: 10),
        IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
      ],
    );
  }
}
