import 'package:flutter/material.dart';

void showCommentsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 15,
              itemBuilder: (c, i) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('User $i'),
                subtitle: const Text('Nice reel!'),
              ),
            ),
          );
        },
      );
    },
  );
}
