import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'like_button.dart';

class ActionButtons extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final AnimationController rotationController;
  final double heartOpacity;
  final bool showSparkle;
  final bool isBouncing;

  const ActionButtons({
    Key? key,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.rotationController,
    required this.heartOpacity,
    required this.showSparkle,
    required this.isBouncing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LikeButton(
          isLiked: isLiked,
          onLike: onLike,
          rotationController: rotationController,
          heartOpacity: heartOpacity,
          showSparkle: showSparkle,
          isBouncing: isBouncing,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.mode_comment_outlined, color: Colors.white),
          onPressed: onComment,
          iconSize: 30,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {
            Share.share('Check out this reel!');
          },
          iconSize: 28,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reel saved to favorites!')),
            );
          },
          iconSize: 28,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
