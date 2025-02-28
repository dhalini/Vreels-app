import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsVideoItem extends StatefulWidget {
  final VideoPlayerController videoController;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onDoubleTap;
  final VoidCallback onTap;

  final bool isBouncing;
  final double heartOpacity;
  final bool showSparkle;
  final AnimationController rotationController;

  final Widget bottomActions;
  final Widget userInfoSection;

  const ReelsVideoItem({
    Key? key,
    required this.videoController,
    required this.isLiked,
    required this.onLike,
    required this.onDoubleTap,
    required this.onTap,
    required this.isBouncing,
    required this.heartOpacity,
    required this.showSparkle,
    required this.rotationController,
    required this.bottomActions,
    required this.userInfoSection,
  }) : super(key: key);

  @override
  State<ReelsVideoItem> createState() => _ReelsVideoItemState();
}

class _ReelsVideoItemState extends State<ReelsVideoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);

    widget.videoController.addListener(() {
      if (widget.videoController.value.isPlaying && _controlsVisible) {
        setState(() {
          _controlsVisible = false;
        });
        _fadeController.forward(from: 0);
      } else if (!widget.videoController.value.isPlaying && !_controlsVisible) {
        setState(() {
          _controlsVisible = true;
        });
        _fadeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            child: Container(
              color: Colors.black,
              child: widget.videoController.value.isInitialized
                  ? _buildCroppedVideo(context)
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),
        ),
        
        Positioned(
          right: 16,
          bottom: 120,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.bottomActions,
          ),
        ),
        
        Positioned(
          left: 16,
          bottom: 16,
          right: 120,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.userInfoSection,
          ),
        ),
        
        if (widget.showSparkle)
          Center(
            child: Icon(
              Icons.favorite,
              color: Colors.red.withOpacity(widget.heartOpacity),
              size: widget.isBouncing ? 120 : 80,
            ),
          ),
      ],
    );
  }

  
  Widget _buildCroppedVideo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    
    final videoAspectRatio = widget.videoController.value.aspectRatio;

    
    final videoWidth = screenWidth;
    
    final videoHeight = screenWidth / videoAspectRatio;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: ClipRect(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: FittedBox(
            fit: BoxFit.none,
            alignment: Alignment.center,
            child: SizedBox(
              width: videoWidth,
              height: videoHeight,
              child: VideoPlayer(widget.videoController),
            ),
          ),
        ),
      ),
    );
  }
}
