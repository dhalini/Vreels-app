import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'video_preview.dart';
import 'package:path_provider/path_provider.dart';

class TrimmerView extends StatefulWidget {
  final String file;

  const TrimmerView({super.key, required this.file});

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: File(widget.file));
  }

  Future<void> _saveVideo() async {
    try {
      setState(() {
        _progressVisibility = true;
      });

      final String customDirectoryPath = await getCustomPath();
      
      

      
      
      

      
      
      final String customFileName =
          '${DateTime.now().millisecondsSinceEpoch}';

      await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        videoFolderName: customDirectoryPath,
        videoFileName: customFileName,
        onSave: (String? outputPath) {
          setState(() {
            _progressVisibility = false;
          });

          if (outputPath != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Video saved at $outputPath')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPreviewPage(videoPath: outputPath),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error saving video')),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _progressVisibility = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save video: $e')),
      );
    }
  }

  Future<String> getCustomPath() async {
  
    
    
    const String customPath= 'Videos';
    return customPath;
  }

  void _togglePlayback() async {
    bool playbackState = await _trimmer.videoPlaybackControl(
      startValue: _startValue,
      endValue: _endValue,
    );
    setState(() {
      _isPlaying = playbackState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFBAC8D9),
            Color(0xFFDEE8EF),
            Color(0xFFF2F7FA),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    if (_progressVisibility)
                      const LinearProgressIndicator(
                        backgroundColor: Colors.red,
                        minHeight: 4,
                      ),
                    const SizedBox(height: 16),
                    const Column(
                      children: [
                        Text(
                          'Trim your video',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select the best moment to share!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            color: Colors.black12,
                            child: VideoViewer(
                              trimmer: _trimmer,
                              borderColor: Colors.transparent,
                              borderWidth: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            IconButton(
                              onPressed: _togglePlayback,
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 50,
                                color: const Color.fromARGB(255, 56, 69, 73),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TrimViewer(
                            trimmer: _trimmer,
                            viewerHeight: 50.0,
                            maxVideoLength: const Duration(seconds: 120),
                            onChangeStart: (value) => _startValue = value,
                            onChangeEnd: (value) => _endValue = value,
                            durationTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)),
                            durationStyle: DurationStyle.FORMAT_MM_SS,
                            editorProperties: const TrimEditorProperties(
                                borderPaintColor:
                                    Color.fromARGB(255, 76, 122, 124),
                                borderWidth: 2),
                            onChangePlaybackState: (value) {
                              setState(() {
                                _isPlaying = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _progressVisibility ? null : _saveVideo,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 132, 165, 181),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
