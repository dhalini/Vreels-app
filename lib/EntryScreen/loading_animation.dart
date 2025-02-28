import 'package:flutter/material.dart';

class LoadingPlaceholder extends StatefulWidget {
  const LoadingPlaceholder({super.key});

  @override
  _LoadingPlaceholderState createState() => _LoadingPlaceholderState();
}

class _LoadingPlaceholderState extends State<LoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), 
    )..repeat(reverse: true); 

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.grey.shade200,
        ),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value, 
              child: child,
            );
          },
          child: Image.asset(
            'assets/logo_new.png',
            width: 75,
            height: 75,
          ),
        ),
      ],
    );
  }
}
