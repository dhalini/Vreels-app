import 'package:flutter/material.dart';

class PictureUpload extends StatelessWidget {
  const PictureUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 14,
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          )
        ],
      ),
    );
  }
}
