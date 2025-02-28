import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(
              value: 'English (US)',
              child: Text('English (US)'),
            ),
            DropdownMenuItem(
              value: 'Hindi',
              child: Text('Hindi'),
            ),
            
          ],
          onChanged: (value) => onLanguageChanged(value!),
        ),
      ),
    );
  }
}
