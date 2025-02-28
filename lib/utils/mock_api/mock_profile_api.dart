import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class MockProfileApi {
  static const String _apiKey =ApiConstants.pexelsApiKey;

  
  static Future<String> getProfilePicture({String query = "portrait"}) async {
    final String url =
        'https://api.pexels.com/v1/search?query=$query&per_page=10';

    try {
      final response =
          await http.get(Uri.parse(url), headers: {'Authorization': _apiKey});

      if (response.statusCode == 200) {
        final List photos = json.decode(response.body)['photos'];
        if (photos.isNotEmpty) {
          final randomIndex = Random().nextInt(photos.length);
          return photos[randomIndex]['src']
              ['large']; 
        }
      }
      throw Exception('No profile picture found.');
    } catch (e) {
      throw Exception('Error fetching profile picture: $e');
    }
  }

  
  static Future<Map<String, String>> getUserStats() async {
    final random = Random();
    return {
      'followers': (50 + random.nextInt(500)).toString(), 
      'following': (10 + random.nextInt(100)).toString(), 
      'likes': (20 + random.nextInt(1000)).toString(), 
    };
  }
}
