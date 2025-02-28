

import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/reels/reels_appbar.dart';
import 'package:prototype25/unnamed/widgets/reels/user_info.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';


import 'reels_action_buttons.dart';
import 'comment_fade_in_sheet.dart';
import 'reels_video_item.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage>
    with SingleTickerProviderStateMixin {
  
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  
  List<FileSystemEntity> _reels = [];
  final List<VideoPlayerController> _controllers = [];

  
  final Set<int> _likedReels = {};
  bool _isBouncing = false;
  bool _showBigHeart = false;
  Timer? _heartTimer;
  double _heartOpacity = 1.0;
  bool _showSparkle = false;
  late AnimationController _rotationController;
  

  
  double _swipeOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 1,
    );
    _pageController.addListener(_handleScroll);

    
    _loadVideos();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pageController.removeListener(_handleScroll);

    
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  
  
  
  void _handleScroll() {
    final pageOffset = _pageController.page ?? 0;
    final distance = (pageOffset - _currentPageIndex).abs();
    setState(() {
      
      _swipeOpacity = 1 - (distance.clamp(0, 1));
    });
  }

  
  
  
  Future<void> _loadVideos() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final String folderPath = '${dir.path}/Videos';
      final folder = Directory(folderPath);

      if (await folder.exists()) {
        final files = folder
            .listSync()
            .where((file) => file is File) 
            .toList();
        _createControllers(files);

        setState(() {
          _reels = files;
        });
      } else {
        debugPrint('Videos folder does not exist.');
      }
    } catch (e) {
      debugPrint('Error listing files: $e');
    }
  }

  void _createControllers(List<FileSystemEntity> files) {
    
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();

    for (final file in files) {
      final filePath = file.path;
      final controller = VideoPlayerController.file(File(filePath))
        ..initialize().then((_) {
          setState(() {}); 
        });
      _controllers.add(controller);
    }
  }

  
  
  
  void _onLikeReel(int index, {bool isDoubleTap = false}) {
    setState(() {
      final alreadyLiked = _likedReels.contains(index);
      if (!alreadyLiked) {
        _likedReels.add(index);
        _isBouncing = true;
        _heartOpacity = 1.0;
        _showSparkle = true;
        _rotationController.forward(from: 0);

        if (isDoubleTap) {
          _showBigHeart = true;
          _heartTimer?.cancel();
          _heartTimer = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _showBigHeart = false;
            });
          });
        }

        Timer(const Duration(milliseconds: 300), () {
          setState(() {
            _isBouncing = false;
          });
        });

        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _heartOpacity = 0.7;
            _showSparkle = false;
          });
        });
      } else {
        _likedReels.remove(index);
        _heartOpacity = 1.0;
        _showSparkle = false;
      }
    });
  }

  
  
  
  void _togglePlayPause(int index) {
    final controller = _controllers[index];
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  
  
  
  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        
        return const CommentFadeInSheet();
      },
    );
  }

  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: reelsAppbar(context),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        onPageChanged: (index) {
          setState(() {
            if (_controllers[_currentPageIndex].value.isPlaying) {
              _togglePlayPause(_currentPageIndex);
            }
            _togglePlayPause(index);
            _currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final isLiked = _likedReels.contains(index);
          final videoController = _controllers[index];

          return Opacity(
            opacity: (index == _currentPageIndex) ? _swipeOpacity : 1.0,
            child: ReelsVideoItem(
              videoController: videoController,
              isLiked: isLiked,
              onLike: () => _onLikeReel(index),
              onDoubleTap: () => _onLikeReel(index, isDoubleTap: true),
              onTap: () => _togglePlayPause(index),
              isBouncing: _isBouncing && isLiked,
              heartOpacity: _heartOpacity,
              showSparkle: _showSparkle,
              rotationController: _rotationController,

              
              bottomActions: ReelsActionButtons(
                isLiked: isLiked,
                onLike: () => _onLikeReel(index),
                isBouncing: _isBouncing && isLiked,
                heartOpacity: _heartOpacity,
                showSparkle: _showSparkle,
                rotationController: _rotationController,
                onCommentTap: () => _showCommentsSheet(context),
                onShareTap: () => Share.share('Check out this reel link!'),
                onSaveTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reel saved to favorites.'),
                    ),
                  );
                },
              ),
              userInfoSection: const UserInfo(),
            ),
          );
        },
      ),
    );
  }
}
