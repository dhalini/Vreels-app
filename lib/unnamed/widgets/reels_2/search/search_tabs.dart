import 'package:flutter/material.dart';

class SearchTabs extends StatelessWidget {
  final int selectedIndex;       
  final ValueChanged<int> onTabChanged; 

  const SearchTabs({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  final List<String> _tabs = const ["Top", "Users", "Photos", "Videos"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final bool isActive = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              onTabChanged(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 24,
                    color: Colors.black,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
