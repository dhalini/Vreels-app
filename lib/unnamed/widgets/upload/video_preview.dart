import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/five_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatefulWidget {
  final String videoPath;

  const VideoPreviewPage({super.key, required this.videoPath});

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  String _visibility = 'Public';
  bool _panelVisible = true;
  bool _showAdvancedSettings = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    _controller.addListener(() {
      if (_controller.value.isPlaying && _panelVisible) {
        setState(() {
          _panelVisible = false;
        });
        _animationController.forward(from: 0);
      } else if (!_controller.value.isPlaying && !_panelVisible) {
        setState(() {
          _panelVisible = true;
        });
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _captionController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  bool get isVideoPlaying => _controller.value.isPlaying;

  void _togglePlayPause() {
    setState(() {
      if (isVideoPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _applyFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter applied (placeholder)')),
    );
  }

  void _uploadVideo() {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Caption is required before upload.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        
        SnackBar(content: Text('Uploading video')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    
    
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCCDCE8),
            Color(0xFFE3EDF4),
            Color(0xFFF2F7FA),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center, 
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: _controller.value.isInitialized
                              ? _controller.value.aspectRatio
                              : 16 / 9,
                          child: Container(
                            color: Colors.black12,
                            child: _controller.value.isInitialized
                                ? GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: VideoPlayer(_controller),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ),
                    if (!_controller
                        .value.isPlaying) 
                      GestureDetector(
                        onTap: _togglePlayPause, 
                        child: Container(
                          color: Colors
                              .transparent, 
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 80,
                            color: const Color.fromARGB(255, 88, 115, 127).withOpacity(0.8),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Preview Only',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Visibility(
                    visible: _panelVisible,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildEditingButton(Icons.filter_alt, 'Filter', _applyFilter),
                              _buildEditingButton(Icons.tune, 'Adjust', () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Adjust clicked (placeholder)')),
                                );
                              }),
                              _buildEditingButton(Icons.content_cut, 'Trim', () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Trim clicked (placeholder)')),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                            'Caption', 'Write a caption...', _captionController, 2),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                            'Hashtags', 'Add hashtags...', _hashtagsController, 1),
                        const SizedBox(height: 16),
                        _buildVisibilityDropdown(),
                        const SizedBox(height: 16),
                        
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAdvancedSettings = !_showAdvancedSettings;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _showAdvancedSettings
                                    ? 'Hide Advanced Settings'
                                    : 'Show Advanced Settings',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _showAdvancedSettings
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        if (_showAdvancedSettings)
                          Column(
                            children: [
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Text(
                                  'Extra Settings Placeholder\n- Location\n- Tag People\n- ...',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        _buildUploadButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditingButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.all(16),
              
              overlayColor: Colors.blueAccent.withOpacity(0.2),

              elevation: 0,
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(
      String label, String hint, TextEditingController controller, int lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, height: 1.5),
            filled: true,
            fillColor: Colors.white.withOpacity(0.95),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.black26, width: 1.2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityDropdown() {
    return DropdownButtonFormField<String>(
      value: _visibility,
      items: const [
        DropdownMenuItem(value: 'Public', child: Text('Public')),
        DropdownMenuItem(value: 'Private', child: Text('Private')),
        DropdownMenuItem(value: 'Friends Only', child: Text('Friends Only')),
      ],
      onChanged: (value) {
        setState(() {
          _visibility = value ?? 'Public';
        });
      },
      decoration: InputDecoration(
        labelText: 'Visibility',
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black26, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      hint: const Text('Public'),
    );
  }

  Widget _buildUploadButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.black, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: _uploadVideo,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Upload Video',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
