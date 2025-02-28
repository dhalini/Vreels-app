import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'fullscreen_video_page.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({super.key, required this.query});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> with SingleTickerProviderStateMixin {
  List<File> _videoFiles = [];
  final List<VideoPlayerController> _controllers = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadVideos();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final folderPath = '${dir.path}/Videos';
    final folder = Directory(folderPath);

    if (await folder.exists()) {
      final files = folder
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp4'))
          .toList();

      setState(() {
        _videoFiles = files;
      });

      for (var file in _videoFiles) {
        final controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
          });
        _controllers.add(controller);
      }
    }
    _animationController.forward();
  }

  void _openFullscreenVideo(File videoFile) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FullscreenVideoPage(videoFile: videoFile),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildAnimatedThumbnail(int index) {
    final controller = _controllers[index];

    return FadeTransition(
      opacity: _animationController,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: controller.value.isInitialized
                  ? VideoPlayer(controller)
                  : Container(
                      color: Colors.white10,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
            ),
          ),
          Positioned(
            child: Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.8), size: 50),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.2),
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Results for "${widget.query}"',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        color: Colors.black,
        child: _videoFiles.isEmpty
            ? const Center(
                child: Text(
                  'No videos found.',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  itemCount: _videoFiles.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _openFullscreenVideo(_videoFiles[index]),
                      child: _buildAnimatedThumbnail(index),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
