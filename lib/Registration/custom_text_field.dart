

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? errorText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final int maxLines;
  final bool hasDatePickerIcon;
  final VoidCallback? onDateIconTap;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength = 1,
    this.maxLines = 1,
    this.hasDatePickerIcon = false,
    this.onDateIconTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            if (maxLength > 1) LengthLimitingTextInputFormatter(maxLength),
            if (inputFormatters != null) ...?inputFormatters,
          ],
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.normal,
            ),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: hasDatePickerIcon
                ? IconButton(
                    onPressed: onDateIconTap,
                    icon: const Icon(Icons.calendar_today_outlined),
                  )
                : null,
            errorText: null, 
          ),
        ),

        
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }
}
