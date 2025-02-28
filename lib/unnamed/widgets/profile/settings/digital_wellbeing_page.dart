import 'package:flutter/material.dart';

class DigitalWellbeingPage extends StatelessWidget {
  const DigitalWellbeingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Digital Wellbeing',
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
      body: Center(
        child: Text(
          'Track screen time, set usage limits, etc.',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
