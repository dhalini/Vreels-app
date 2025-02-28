import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/reels_2/search/search.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedCategory;
  final Function(String) onTabSelected;

  const CustomTopAppBar({
    Key? key,
    required this.selectedCategory,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildTab(String title) {
    bool isSelected = title.toLowerCase() == selectedCategory.toLowerCase();
    return GestureDetector(
      onTap: () => onTabSelected(title),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.black.withOpacity(0.0),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTab("Explore"),
          const SizedBox(width: 14),
          _buildTab("Following"),
          const SizedBox(width: 14),
          _buildTab("For You"),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            );
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }
}
