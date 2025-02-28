import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final AnimationController rotationController;
  final double heartOpacity;
  final bool showSparkle;
  final bool isBouncing;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onLike,
    required this.rotationController,
    required this.heartOpacity,
    required this.showSparkle,
    required this.isBouncing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotationController,
      builder: (context, child) {
        final scale = isBouncing ? 1.2 : 1.0;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: heartOpacity,
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 35,
                  ),
                  if (showSparkle)
                    const Positioned(
                      top: 0,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.yellowAccent,
                        size: 14,
                      ),
                    ),
                ],
              ),
              onPressed: onLike,
              iconSize: 35,
            ),
          ),
        );
      },
    );
  }
}
