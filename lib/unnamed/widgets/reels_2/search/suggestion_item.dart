import 'package:flutter/material.dart';

class SuggestionItem {
  final String text;
  final Color? bulletColor;
  final Color textColor;
  final bool isBold;
  final bool justWatched;

  SuggestionItem({
    required this.text,
    this.bulletColor,
    Color? textColor,
    this.isBold = false,
    this.justWatched = false,
  }) : textColor = textColor ?? Colors.black;
}
