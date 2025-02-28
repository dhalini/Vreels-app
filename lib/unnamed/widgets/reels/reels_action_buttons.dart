

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'action_button.dart';

class ReelsActionButtons extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final bool isBouncing;
  final double heartOpacity;
  final bool showSparkle;
  final AnimationController rotationController;

  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onSaveTap;

  const ReelsActionButtons({
    Key? key,
    required this.isLiked,
    required this.onLike,
    required this.isBouncing,
    required this.heartOpacity,
    required this.showSparkle,
    required this.rotationController,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onSaveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        
        
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: onLike,
              child: AnimatedBuilder(
                animation: rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotationController.value * 2 * math.pi,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: heartOpacity,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: (isBouncing && isLiked) ? 1.2 : 1.0,
                        child: Icon(
                          Icons.favorite_border_outlined,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showSparkle)
              Positioned(
                top: -10,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.yellow.shade400,
                  size: 20,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          isLiked ? 'Liked' : 'Like',
          style: TextStyle(
            color: isLiked ? Colors.red : Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        
        
        
        ActionButton(
          icon: Icons.mode_comment_outlined,
          label: 'Comments',
          onTap: onCommentTap,
        ),
        const SizedBox(height: 16),

        
        
        
        ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShareTap,
        ),
        const SizedBox(height: 16),

        
        
        
        ActionButton(
          icon: Icons.bookmark_outline,
          label: 'Save',
          onTap: onSaveTap,
        ),
      ],
    );
  }
}
