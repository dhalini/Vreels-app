import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> options; 
  final String? value;
  final String? hint;
  final String? errorText;
  final ValueChanged<String?>? onChanged;
  

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.options,
    this.value,
    this.hint,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    

    final listOfItems= options
              .map((option) => DropdownMenuItem(
                  
                    value: option,
                    child: Text(option),
                  ))
              .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        
        DropdownButtonFormField<String>(
          isExpanded: true, 
          value: value,
          onChanged: onChanged,
          items: listOfItems,
          hint: hint != null
              ? Text(
                  hint!,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal, 
                    color: Colors.grey,
                  ),
                )
              : null,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal, 
            ),
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
