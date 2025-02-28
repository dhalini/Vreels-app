import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoWidget extends StatelessWidget {
  final ChewieController chewieController;

  const VideoWidget({Key? key, required this.chewieController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final videoWidth = chewieController.videoPlayerController.value.size.width;
        final videoHeight = chewieController.videoPlayerController.value.size.height;
        final scale = screenWidth / videoWidth;
        final scaledHeight = videoHeight * scale;

        return Center(
          child: ClipRect(
            child: OverflowBox(
              minWidth: screenWidth,
              maxWidth: screenWidth,
              minHeight: scaledHeight,
              maxHeight: scaledHeight,
              child: SizedBox(
                width: screenWidth,
                height: scaledHeight,
                child: Chewie(controller: chewieController),
              ),
            ),
          ),
        );
      },
    );
  }
}
