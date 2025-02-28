import 'dart:async';
import 'dart:io'; 
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/profile_others/others_profile_page.dart';
import 'package:prototype25/utils/mock_api/pexels_api_service.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';



class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  
  final List<Map<String, dynamic>> _reelFiles = [];

  
  final List<VideoPlayerController> _videoControllers = [];
  final List<ChewieController> _chewieControllers = [];

  int _currentPageIndex = 0;

  
  final Set<int> _likedReels = {};
  bool _isBouncing = false;
  bool _showBigHeart = false;
  Timer? _heartTimer;
  double _heartOpacity = 1.0;
  bool _showSparkle = false;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 1,
    );

    _loadMedia();
  }

  @override
  void dispose() {
    for (final chewie in _chewieControllers) {
      chewie.dispose();
    }
    for (final video in _videoControllers) {
      video.dispose();
    }
    _pageController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  
  Future<void> _loadMedia() async {
    try {
      
      final mediaList =
          await PexelsApiService.getPublicPosts(query: "trending");

      
      for (final media in mediaList.take(5)) {
        if (media['type'] == 'video') {
          final videoController =
              VideoPlayerController.network(media['video_url']);
          await videoController.initialize();

          final chewieController = ChewieController(
            videoPlayerController: videoController,
            autoPlay: false,
            looping: true,
            showControls: false,
          );

          _videoControllers.add(videoController);
          _chewieControllers.add(chewieController);
        }
        _reelFiles.add(media);
      }
      setState(() {});
    } catch (e) {
      debugPrint('Error loading media: $e');
    }
  }

  
  int _getVideoControllerIndex(int reelIndex) {
    int count = 0;
    for (int i = 0; i <= reelIndex; i++) {
      if (_reelFiles[i]['type'] == 'video') {
        count++;
      }
    }
    return count - 1; 
  }

  
  void _onLikeReel(int index, {bool doubleTap = false}) {
    setState(() {
      if (_likedReels.contains(index)) {
        _likedReels.remove(index);
        _heartOpacity = 1.0;
        _showSparkle = false;
      } else {
        _likedReels.add(index);
        _isBouncing = true;
        _heartOpacity = 1.0;
        _showSparkle = true;
        _rotationController.forward(from: 0);

        if (doubleTap) {
          _showBigHeart = true;
          _heartTimer?.cancel();
          _heartTimer = Timer(const Duration(milliseconds: 500), () {
            setState(() => _showBigHeart = false);
          });
        }

        Timer(const Duration(milliseconds: 300), () {
          setState(() => _isBouncing = false);
        });

        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _heartOpacity = 0.7;
            _showSparkle = false;
          });
        });
      }
    });
  }

  
  void _onVideoTap(int index) {
    final media = _reelFiles[index];
    if (media['type'] == 'video') {
      final videoIndex = _getVideoControllerIndex(index);
      final videoController = _videoControllers[videoIndex];
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
      setState(() {});
    }
  }

  
  void _onPageChanged(int newIndex) {
    
    if (_reelFiles[_currentPageIndex]['type'] == 'video') {
      final prevIndex = _getVideoControllerIndex(_currentPageIndex);
      _videoControllers[prevIndex].pause();
    }
    
    if (_reelFiles[newIndex]['type'] == 'video') {
      final newVideoIndex = _getVideoControllerIndex(newIndex);
      _videoControllers[newVideoIndex].play();
    }
    _currentPageIndex = newIndex;
  }

  
  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: 15,
                itemBuilder: (c, i) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('User $i'),
                  subtitle: const Text('Nice reel!'),
                ),
              ),
            );
          },
        );
      },
    );
  }
  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      scrolledUnderElevation:0,
      backgroundColor: Colors.black.withOpacity(0.0), 
      elevation: 0, 
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Explore',
              style: TextStyle(color: Colors.white54, fontSize: 16)),
          SizedBox(width: 14),
          Text('Following',
              style: TextStyle(color: Colors.white54, fontSize: 16)),
          SizedBox(width: 14),
          Text('For You',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  
  Widget _buildVideoWidget(ChewieController chewieController) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final videoWidth =
            chewieController.videoPlayerController.value.size.width;
        final videoHeight =
            chewieController.videoPlayerController.value.size.height;
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

  
  Widget _buildReelItem(int index) {
    final media = _reelFiles[index];
    final isLiked = _likedReels.contains(index);

    return GestureDetector(
      onTap: () => _onVideoTap(index),
      onDoubleTap: () => _onLikeReel(index, doubleTap: true),
      child: Stack(
        children: [
          
          Positioned.fill(
            child: media['type'] == 'photo'
                ? Image.network(media['image'], fit: BoxFit.cover)
                : _buildVideoWidget(
                    _chewieControllers[_getVideoControllerIndex(index)]),
          ),
          
          if (_showBigHeart && isLiked)
            const Center(
                child: Icon(Icons.favorite, size: 100, color: Colors.white70)),
          
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          Positioned(
            left: 16,
            bottom: 60,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OthersProfilePage(
                          username: media['photographer'] ?? "PexelsUser",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '@${media['photographer'] ?? "pexels_user"}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  media['alt'] ?? 'Check out this amazing shot!',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          
          Positioned(
            right: 10,
            bottom: 60,
            child: _buildActionButtons(
              isLiked: isLiked,
              onLike: () => _onLikeReel(index),
              onComment: () => _showCommentsSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildActionButtons({
    required bool isLiked,
    required VoidCallback onLike,
    required VoidCallback onComment,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildLikeButton(isLiked, onLike),
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

  
  Widget _buildLikeButton(bool isLiked, VoidCallback onLike) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final scale = _isBouncing ? 1.2 : 1.0;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: _heartOpacity,
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 35,
                  ),
                  if (_showSparkle)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: _buildTopAppBar(),
      body: _reelFiles.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              scrollDirection: Axis.vertical,
              itemCount: _reelFiles.length,
              itemBuilder: (ctx, index) => _buildReelItem(index),
            ),
    );
  }
}
