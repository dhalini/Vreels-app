import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MediaGrid extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Function(String url) onTap;

  const MediaGrid({Key? key, required this.data, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: data.length, 
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 9 / 16,
      ),
      itemBuilder: (context, index) {
        final item = data[index];

        return FutureBuilder(
          future: precacheImage(NetworkImage(item['image']), context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerLoading(
                itemCount: 1,
              ); 
            }

            return GestureDetector(
              onTap: () => onTap(item.containsKey('video_url')
                  ? item['video_url']
                  : item['url']),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      item['image'], 
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                  if (!item.containsKey('video_url'))
                    const Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(Icons.image_outlined,
                          color: Colors.white, size: 15),
                    ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${(index + 1) * 10}K', 
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final int itemCount;

  const ShimmerLoading({Key? key, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount, 
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 8), 
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.5, 
              decoration: BoxDecoration(
                color: Colors.white,
                
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 9, 
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 9 / 16, 
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class ShimmerProfilePicture extends StatefulWidget {
  final String imageUrl;
  final double size;
  final bool isLoading; 

  const ShimmerProfilePicture({
    Key? key,
    required this.imageUrl,
    required this.isLoading,
    this.size = 80, 
  }) : super(key: key);

  @override
  State<ShimmerProfilePicture> createState() => _ShimmerProfilePictureState();
}

class _ShimmerProfilePictureState extends State<ShimmerProfilePicture> {
  bool _isImageLoading = true; 

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipOval(
        child: widget.isLoading
            ? _buildShimmerEffect()
            : Image.network(
                widget.imageUrl,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _isImageLoading = false);
                      }
                    });
                    return child;
                  } else {
                    
                    return _buildShimmerEffect();
                  }
                },
              ),
      ),
    );
  }

  
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ClipOval(
        child: Container(
          width: widget.size,
          height: widget.size,
          color: Colors.white,
        ),
      ),
    );
  }
}


class ShimmerSuggestedAccounts extends StatelessWidget {
  final int itemCount;

  const ShimmerSuggestedAccounts({Key? key, this.itemCount = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                const CircleAvatar(radius: 30, backgroundColor: Colors.white),
                const SizedBox(height: 6),

                
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),

                
                Container(
                  height: 10,
                  width: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),

                
                Container(
                  width: 70,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

