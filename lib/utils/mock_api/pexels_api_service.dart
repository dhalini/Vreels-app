import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class PexelsApiService {
  static const String _apiKey = ApiConstants.pexelsApiKey;

  static Future<List<Map<String, dynamic>>> fetchPhotos(String query) async {
    final String photosUrl =
        'https://api.pexels.com/v1/search?query=$query&per_page=50';

    try {
      final photosResponse = await http
          .get(Uri.parse(photosUrl), headers: {'Authorization': _apiKey});
      if (photosResponse.statusCode == 200) {
        final photosData = json.decode(photosResponse.body)['photos'];

        List<Map<String, dynamic>> photos = List<Map<String, dynamic>>.from(
          photosData.map((photo) => {
                'id': photo['id'],
                'type': 'photo',
                'photographer': photo['photographer'],
                'photographer_url': photo['photographer_url'],
                'url': photo['url'],
                'image': photo['src']['medium'],
                'alt': photo['alt'],
              }),
        );

        return photos.toList();
      } else {
        throw Exception('Failed to load media content');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  
  static Future<List<Map<String, dynamic>>> fetchVideos(String query) async {
    final String videosUrl =
        'https://api.pexels.com/videos/search?query=$query&per_page=50';

    try {
      final videosResponse = await http
          .get(Uri.parse(videosUrl), headers: {'Authorization': _apiKey});

      if (videosResponse.statusCode == 200) {
        final videosData = json.decode(videosResponse.body)['videos'];

        List<Map<String, dynamic>> videos = List<Map<String, dynamic>>.from(
          videosData.map((video) => {
                'id': video['id'],
                'type': 'video',
                'user': video['user']['name'],
                'user_url': video['user']['url'],
                'video_url': video['video_files'][0]['link'],
                'image': video['image'], 
                'duration': video['duration'],
              }),
        );

        return videos.toList();
      } else {
        throw Exception('Failed to load media content');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  
  
  static Future<List<Map<String, dynamic>>> _fetchMixedPosts({
    required String query,
    int minCount = 15,
    int maxCount = 30,
  }) async {
    final String photosUrl =
        'https://api.pexels.com/v1/search?query=$query&per_page=50';
    final String videosUrl =
        'https://api.pexels.com/videos/search?query=$query&per_page=50';

    try {
      final photosResponse = await http
          .get(Uri.parse(photosUrl), headers: {'Authorization': _apiKey});
      final videosResponse = await http
          .get(Uri.parse(videosUrl), headers: {'Authorization': _apiKey});

      if (photosResponse.statusCode == 200 &&
          videosResponse.statusCode == 200) {
        final photosData = json.decode(photosResponse.body)['photos'];
        final videosData = json.decode(videosResponse.body)['videos'];

        List<Map<String, dynamic>> photos = List<Map<String, dynamic>>.from(
          photosData.map((photo) => {
                'id': photo['id'],
                'type': 'photo',
                'photographer': photo['photographer'],
                'photographer_url': photo['photographer_url'],
                'url': photo['url'],
                'image': photo['src']['medium'],
                'alt': photo['alt'],
              }),
        );

        List<Map<String, dynamic>> videos = List<Map<String, dynamic>>.from(
          videosData.map((video) => {
                'id': video['id'],
                'type': 'video',
                'user': video['user']['name'],
                'user_url': video['user']['url'],
                'video_url': video['video_files'][0]['link'],
                'image': video['image'], 
                'duration': video['duration'],
              }),
        );

        List<Map<String, dynamic>> mixedPosts = [...photos, ...videos];
        mixedPosts.shuffle(); 

        
        final random = Random();
        int count = minCount + random.nextInt(maxCount - minCount + 1);

        return mixedPosts.take(count).toList();
      } else {
        throw Exception('Failed to load media content');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  
  static Future<List<Map<String, dynamic>>> getPublicPosts(
      {String query = "nature"}) async {
    return await _fetchMixedPosts(query: query);
  }

  
  static Future<List<Map<String, dynamic>>> getPrivatePosts(
      {String query = "architecture"}) async {
    return await _fetchMixedPosts(query: query);
  }

  
  static Future<List<Map<String, dynamic>>> getCollectionPosts(
      {String query = "travel"}) async {
    return await _fetchMixedPosts(query: query);
  }

  
  static Future<List<Map<String, dynamic>>> getLikedPosts(
      {String query = "fashion"}) async {
    return await _fetchMixedPosts(query: query);
  }

  
  static Future<List<Map<String, dynamic>>> getReposts(
      {String query = "technology"}) async {
    return await _fetchMixedPosts(query: query);
  }
}
