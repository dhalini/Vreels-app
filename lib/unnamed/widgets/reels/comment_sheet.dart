import 'package:flutter/material.dart';

class CommentSheet extends StatelessWidget {
  const CommentSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        
        const SizedBox(height: 16),
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                title: Text(
                  'User $index',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'This is a comment. Great content!',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const Divider(color: Colors.grey),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
