

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype25/EntryScreen/entry.dart';
import '../utils/cold_start_options.dart';

class ColdStartScreen extends StatefulWidget {
  const ColdStartScreen({super.key});

  @override
  State<ColdStartScreen> createState() => _ColdStartScreenState();
}

class _ColdStartScreenState extends State<ColdStartScreen> {
  
  final Set<String> _selectedOptions = {};

  void _toggleSelection(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        title: Title(
            color: Colors.black,
            child: const Text(
              "Choose what interests you",
              style: TextStyle(fontSize: 18),
            )),
        centerTitle: true,
      ),
      
      backgroundColor: Colors.white,

      
      
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
                    color: Colors.blue[100],
                  ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: options.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisExtent: 60,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = _selectedOptions.contains(option);

                    return GestureDetector(
                      onTap: () => _toggleSelection(option),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          
                          color: isSelected
                              ? const Color.fromARGB(255, 96, 166, 223)
                              : const Color.fromARGB(
                                  255, 255, 255, 255), 
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 240, 236, 233)
                                : Colors.blue[200]!,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12, 
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              option,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black, 
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(85, 194, 218, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () {
                  if (_selectedOptions.isNotEmpty) {
                    
                    saveToFireStore();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntryWidget()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one option.'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void saveToFireStore() {
    print('User selected: $_selectedOptions');
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'selected_options': _selectedOptions, 
      }).then((_) {
        print("Field updated successfully!");
      }).catchError((error) {
        print("Failed to update field: $error");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No authenticated user found.')),
      );
    }
  }
}
