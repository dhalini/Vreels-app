import 'dart:math';
import 'mock_profile_api.dart'; 

class MockSuggestedProfiles {
  static final List<String> _randomUsernames = [
    "funny_dog", "lovepets_", "tech_geek", "travel_explorer", "foodie_lover",
    "fashionista", "gaming_addict", "sports_fan", "nature_lover", "music_junkie",
    "artist_vibes", "coding_nerd", "car_enthusiast", "fitness_freak", "bookworm",
    "movie_buff", "adventure_junkie", "astro_nerd", "cat_lover", "dog_lover",
  ];

  static Future<List<Map<String, String>>> getSuggestedProfiles() async {

    final random = Random();
    int profileCount = 15 + random.nextInt(16); 

    List<Map<String, String>> suggestedProfiles = [];

    for (int i = 0; i < profileCount; i++) {
      String username = _randomUsernames[random.nextInt(_randomUsernames.length)];
      String followers = "${random.nextInt(900) + 100}K"; 

      String profilePic = await MockProfileApi.getProfilePicture();

      suggestedProfiles.add({
        "username": username,
        "followers": "$followers followers",
        "profile_pic": profilePic,
      });
    } 

    print(suggestedProfiles);

    return suggestedProfiles;
  }
}
