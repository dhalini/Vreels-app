import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/reels/search_filter.dart';
import 'package:prototype25/unnamed/widgets/reels/search_results.dart';

AppBar reelsAppbar(BuildContext context) {
  final TextEditingController searchController = TextEditingController();

  void _onSearch() {
    if (searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResults(query: searchController.text),
        ),
      );
    }
  }

  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search, 
        onSubmitted: (value) => _onSearch(), 
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: const SearchFilter(),
          hintText: 'Search videos, hashtags, links...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.grey.shade900,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
      ),
    ),
  );
}
