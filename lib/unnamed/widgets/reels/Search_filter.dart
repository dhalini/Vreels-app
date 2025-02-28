import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});
  

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  String _selectedFilter = 'Trending';
    @override
    Widget build(BuildContext context) {

    return Theme(
      data: ThemeData.dark().copyWith(
        canvasColor: Colors.grey.shade900,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white),
          items: const [
            DropdownMenuItem(
              value: 'Trending',
              child: Text('Trending'),
            ),
            DropdownMenuItem(
              value: 'Recent',
              child: Text('Recent'),
            ),
            DropdownMenuItem(
              value: 'Popular',
              child: Text('Popular'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFilter = value ?? 'Trending';
            });
          },
        ),
      ),
    );
  }
  


}