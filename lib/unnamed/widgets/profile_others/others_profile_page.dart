import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/profile/follows_page.dart';
import 'package:prototype25/unnamed/widgets/profile/likes_overlay.dart';
import 'package:prototype25/unnamed/widgets/profile/media_grid.dart';
import 'package:prototype25/unnamed/widgets/profile_others/follow_options_overlay.dart';
import 'package:prototype25/unnamed/widgets/profile_others/suggested_accounts_pane.dart';
import 'package:prototype25/utils/mock_api/mock_profile_api.dart';
import '../../../utils/mock_api/pexels_api_service.dart';

class OthersProfilePage extends StatefulWidget {
  final String username;

  const OthersProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  State<OthersProfilePage> createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
  
  int _selectedTab = 0;

  
  bool _isProfileLoading = true;
  bool _isStatsLoading = true;
  bool _isPostsLoading = true;

  String _profilePicture = "";
  String _followers = "...";
  String _following = "...";
  String _likes = "...";
  bool _isFollowing = false;
  bool _showSuggestedAccounts = false;
  final String _bio =
      "SB LIX CHAMPS: EAGLES 🦅\nhttps://linktr.ee/nfl and 1 more";
  List<Map<String, dynamic>> _publicPosts = [];
  List<Map<String, dynamic>> _reposts = [];

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
      final rePostsFuture = PexelsApiService.getReposts();

      
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
        rePostsFuture,
      ]).then((results) {
        setState(() {
          _publicPosts = results[0];
          _reposts = results[1];
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
    return Scaffold(
      backgroundColor: Colors.white,
      
      
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.username,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              
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
              '@${widget.username}',
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
                _buildStatItem(
                    context,
                    _likes,
                    'Likes',
                    LikesOverlay(
                      likes: _likes,
                    )),
              ],
            ),
            const SizedBox(height: 16),

            
            
            
            
            
            
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isFollowing)
                  SizedBox(
                    width: 120, 
                    height: 40, 
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isFollowing =
                              true; 
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              15, 
                        ),
                      ),
                    ),
                  ),
                if (!_isFollowing)
                  const SizedBox(width: 6), 
                SizedBox(
                  width: 130, 
                  height: 40, 
                  child: ElevatedButton.icon(
                    onPressed: () {
                      
                    },
                    label: const Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 6), 
                if (_isFollowing)
                  SizedBox(
                    width: 40, 
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) => FollowOptionsOverlay(
                            onUnfollow: () {
                              setState(() {
                                _isFollowing =
                                    false; 
                              });
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero, 
                      ),
                      child: const Icon(Icons.settings,
                          color: Colors.black, size: 22),
                    ),
                  ),
                const SizedBox(
                    width: 6), 
                
                SizedBox(
                  width: 40, 
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showSuggestedAccounts =
                            !_showSuggestedAccounts; 
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero, 
                    ),
                    child: Icon(
                        _showSuggestedAccounts
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 22),
                  ),
                ),
              ],
            ),

            if (_showSuggestedAccounts) ...[
              const SizedBox(height: 8),
              SuggestedAccountsPane(),
            ],
            const SizedBox(height: 8),

            
            
            
            Text(
              _bio,
              style: const TextStyle(
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem(Icons.grid_view, 0),
                _buildTabItem(Icons.repeat, 1)
              ],
            ),
            
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.only(top: 8),
            ),
            const SizedBox(height: 8),

            
            
            
            if (_selectedTab == 0) _buildPublicPosts(),
            if (_selectedTab == 1) _buildReposts(),
          ],
        ),
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

  Widget _buildPublicPosts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _publicPosts, onTap: _openUrl);
  }

  Widget _buildReposts() {
    return _isPostsLoading
        ? const CustomLoader() 
        : MediaGrid(data: _reposts, onTap: _openUrl);
  }

  
  
  
  Widget _buildPlaceholderContent(String label) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Text(
        'No $label yet.',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
