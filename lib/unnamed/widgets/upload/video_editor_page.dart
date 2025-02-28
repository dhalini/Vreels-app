import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'dart:io';

class VideoEditorPage extends StatefulWidget {
  final String videoPath;

  const VideoEditorPage({super.key, required this.videoPath});

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    await _trimmer.loadVideo(videoFile: File(widget.videoPath));
  }

  void _saveTrimmedVideo() async {
    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video saved at $outputPath')),
        );
        Navigator.pop(context, outputPath);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Video'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white, 
        child: Column(
          children: [
            
            Expanded(
              child: VideoViewer(trimmer: _trimmer),
            ),
            const SizedBox(height: 10),
            
            TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 50.0,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 30),
              onChangeStart: (value) {
                setState(() {
                  _startValue = value;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _endValue = value;
                });
              },
              onChangePlaybackState: (isPlaying) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTrimmedVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Save Trimmed Video'),
            ),
          ],
        ),
      ),
    );
  }
}
