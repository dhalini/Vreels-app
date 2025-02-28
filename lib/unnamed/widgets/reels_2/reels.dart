import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/reels_2/search/search.dart';
import 'package:prototype25/unnamed/widgets/reels_2/top_app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:prototype25/unnamed/widgets/profile_others/others_profile_page.dart';
import 'package:prototype25/utils/mock_api/pexels_api_service.dart';
import 'package:shimmer/shimmer.dart';

import 'video_widget.dart';
import 'action_buttons.dart';
import 'comments_sheet.dart';

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
  String _selectedCategory = "For You"; 

  
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

  void _onHashtagClicked(String hashtag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchPage(initialQuery: hashtag),
      ),
    );
  }

  Widget _buildHashtag(String hashtag) {
    return GestureDetector(
      onTap: () => _onHashtagClicked(hashtag),
      child: Text(
        hashtag,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  
  Future<void> _loadMedia() async {
    
    for (final video in _videoControllers) video.dispose();
    for (final chewie in _chewieControllers) chewie.dispose();
    _videoControllers.clear();
    _chewieControllers.clear();
    _reelFiles.clear();

    
    final query = _selectedCategory.toLowerCase();
    try {
      final mediaList = await PexelsApiService.getPublicPosts(query: query);
      
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
        Timer(const Duration(milliseconds: 300),
            () => setState(() => _isBouncing = false));
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

  
  void _showComments() => showCommentsSheet(context);

  
  void _onTabSelected(String tab) {
    if (_selectedCategory != tab) {
      setState(() {
        _selectedCategory = tab;
      });
      _loadMedia();
    }
  }

  
  Widget _buildShimmerItem() => Container(
        
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
      );

  
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
                : VideoWidget(
                    chewieController:
                        _chewieControllers[_getVideoControllerIndex(index)],
                  ),
          ),
          
          if (_showBigHeart && isLiked)
            const Center(
              child: Icon(Icons.favorite, size: 100, color: Colors.white70),
            ),
          
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OthersProfilePage(
                        username: media['photographer'] ?? "PexelsUser",
                      ),
                    ),
                  ),
                  child: Text(
                    '@${media['photographer'] ?? "pexels_user"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  media['alt'] ?? 'Check out this amazing shot!',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildHashtag("#funny"),
                    const SizedBox(width: 12),
                    _buildHashtag("#dog"),
                    const SizedBox(width: 12),
                    _buildHashtag("#puppy"),
                  ],
                ),
              ],
            ),
          ),
          
          Positioned(
            right: 10,
            bottom: 60,
            child: ActionButtons(
              isLiked: isLiked,
              onLike: () => _onLikeReel(index),
              onComment: _showComments,
              rotationController: _rotationController,
              heartOpacity: _heartOpacity,
              showSparkle: _showSparkle,
              isBouncing: _isBouncing,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = _reelFiles.isEmpty;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: CustomTopAppBar(
        selectedCategory: _selectedCategory,
        onTabSelected: _onTabSelected,
      ),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (ctx, index) => _buildShimmerItem(),
              ),
            )
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
