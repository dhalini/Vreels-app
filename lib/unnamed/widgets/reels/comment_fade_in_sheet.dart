

import 'package:flutter/material.dart';
import 'comment_sheet.dart';

class CommentFadeInSheet extends StatefulWidget {
  const CommentFadeInSheet({Key? key}) : super(key: key);

  @override
  State<CommentFadeInSheet> createState() => _CommentFadeInSheetState();
}

class _CommentFadeInSheetState extends State<CommentFadeInSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _opacityAnim,
      child: Container(
        height: mediaQuery.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const CommentSheet(),
      ),
    );
  }
}
