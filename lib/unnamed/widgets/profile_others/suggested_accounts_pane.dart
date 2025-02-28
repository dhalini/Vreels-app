import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/profile/media_grid.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prototype25/unnamed/widgets/profile/follows_page.dart';
import 'package:prototype25/unnamed/widgets/profile_others/others_profile_page.dart';
import '../../../utils/mock_api/mock_suggested_profiles.dart';

class SuggestedAccountsPane extends StatelessWidget {
  const SuggestedAccountsPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Suggested accounts",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FollowsPage(defaultTab: 2)));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("View all", style: TextStyle(fontSize: 15)),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, size: 13),
                  ],
                ),
              ),
            ],
          ),
        ),

        
        
        
        SizedBox(
          height: 140,
          child: FutureBuilder<List<Map<String, String>>>(
            future: MockSuggestedProfiles.getSuggestedProfiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                return const ShimmerSuggestedAccounts(); 
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No suggested accounts found"));
              }

              final profiles = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return _buildSuggestedAccount(
                    context: context,
                    imagePath: profile["profile_pic"] ?? 'assets/default.jpg',
                    name: profile["username"] ?? "Unknown",
                    followers: profile["followers"] ?? "0 followers",
                    buttonText: "Follow",
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  
  
  
  Widget _buildSuggestedAccount({
    required BuildContext context,
    required String imagePath,
    required String name,
    required String followers,
    required String buttonText,
    bool isFindButton = false,
  }) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OthersProfilePage(username: name)));
            },
            child: ClipOval(
              child: Image.network(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; 

                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),

          
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          
          Text(
            followers,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),

          
          SizedBox(
            width: 70,
            height: 26,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isFindButton ? Colors.green : Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
