import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:prototype25/unnamed/widgets/profile/follows_page.dart';
import 'package:prototype25/unnamed/widgets/profile/likes_overlay.dart';
import 'package:prototype25/unnamed/widgets/profile/media_grid.dart';
import 'package:prototype25/unnamed/widgets/profile/settings/share_profile_page.dart';
import 'package:prototype25/unnamed/widgets/profile/viewer_history_page.dart';
import '../../../blocs/app/app_bloc.dart';
import 'profile_menu_overlay.dart';
import '../../../utils/mock_api/pexels_api_service.dart';
import '../../../utils/mock_api/mock_profile_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  int _selectedTab = 0;

  List<Map<String, dynamic>> _publicPosts = [];
  List<Map<String, dynamic>> _privatePosts = [];
  List<Map<String, dynamic>> _collectionPosts = [];
  List<Map<String, dynamic>> _likedPosts = [];
  bool _isProfileLoading = true;
  bool _isStatsLoading = true;
  bool _isPostsLoading = true;

  String _profilePicture = "";
  String _followers = "...";
  String _following = "...";
  String _likes = "...";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      
      final profileFuture = MockProfileApi.getProfilePicture();
      final statsFuture = MockProfileApi.getUserStats();
      final publicPostsFuture = PexelsApiService.getPublicPosts();
      final privatePostsFuture = PexelsApiService.getPrivatePosts();
      final collectionPostsFuture = PexelsApiService.getCollectionPosts();
      final likedPostsFuture = PexelsApiService.getLikedPosts();

      
      profileFuture.then((profilePic) {
        setState(() {
          _profilePicture = profilePic;
          _isProfileLoading = false; 
        });
      });

      
      statsFuture.then((stats) {
        setState(() {
          _followers = stats['followers']!;
          _following = stats['following']!;
          _likes = stats['likes']!;
          _isStatsLoading = false; 
        });
      });

      
      Future.wait([
        publicPostsFuture,
        privatePostsFuture,
        collectionPostsFuture,
        likedPostsFuture
      ]).then((results) {
        setState(() {
          _publicPosts = results[0];
          _privatePosts = results[1];
          _collectionPosts = results[2];
          _likedPosts = results[3];
          _isPostsLoading = false; 
        });
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isProfileLoading = false;
        _isStatsLoading = false;
        _isPostsLoading = false;
      });
    }
  }

  void _openUrl(String url) {
    print('Opening URL: $url');
    
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.person_add_alt_1, color: Colors.black),
          onPressed: () {
            
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              
              appState.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined), 
            color: Colors.black,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ViewerHistoryPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const ProfileMenuOverlay(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            
            
            ShimmerProfilePicture(
              imageUrl: _profilePicture,
              isLoading: _isProfileLoading,
            ),
            const SizedBox(height: 12),

            
            
            
            Text(
              '@${appState.username}', 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            
            
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem(context, _following, 'Following',
                    const FollowsPage(defaultTab: 0)),
                _buildStatItem(context, _followers, 'Followers',
                    const FollowsPage(defaultTab: 1)),
                _buildStatItem(context, _likes, 'Likes', LikesOverlay(likes: _likes,)),
              ],
            ),

            const SizedBox(height: 16),

            
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey.shade200, 
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), 
                      ),
                      elevation: 0, 
                      padding: const EdgeInsets.symmetric(
                          vertical: 12), 
                    ),
                    child: const Text(
                      'Edit profile',
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShareProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey.shade200, 
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), 
                      ),
                      elevation: 0, 
                      padding: const EdgeInsets.symmetric(
                          vertical: 12), 
                    ),
                    child: const Text(
                      'Share Profile',
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            
            
            
            Text(
              appState.about.isEmpty ? 'Tap to add bio' : appState.about,
              style: TextStyle(
                color: appState.about.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            
            
            
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, 
              children: [
                _buildTabItem(Icons.grid_view, 0), 
                _buildTabItem(Icons.lock_outline, 1), 
                _buildTabItem(Icons.bookmark_border, 2), 
                _buildTabItem(Icons.favorite_border, 3), 
              ],
            ),

            
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.only(top: 8),
            ),
            const SizedBox(height: 8),

            
            
            
            if (_selectedTab == 0)
              _buildPublicPosts()
            else if (_selectedTab == 1)
              _buildPrivatePosts()
            else if (_selectedTab == 2)
              _buildCollectionPosts()
            else if (_selectedTab == 3)
              _buildLikedPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: _selectedTab == index ? Colors.black : Colors.grey.shade400,
          ),
          if (_selectedTab == index) _buildSelectedIndicator(),
        ],
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    return Container(
      width: 25,
      height: 3,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String value, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        if (label == "Likes") {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => page,
            transitionBuilder: (_, anim, __, child) {
              return FadeTransition(
                opacity: anim,
                child: child,
              );
            },
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicPosts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _publicPosts, onTap: _openUrl);
  }

  Widget _buildPrivatePosts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _privatePosts, onTap: _openUrl);
  }

  Widget _buildCollectionPosts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _collectionPosts, onTap: _openUrl);
  }

  Widget _buildLikedPosts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _likedPosts, onTap: _openUrl);
  }
}
