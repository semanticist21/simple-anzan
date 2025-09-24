import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String initialValue;
  final List<DropdownMenuItem<dynamic>> items;
  final Function(dynamic) onChanged;
  final double width;
  final double height;

  const CustomDropdown({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.width = 120,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: DropdownButtonFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: isDark
              ? const Color(0xFF2A2A2A)
              : Colors.grey.shade100,
        ),
        items: items,
        onChanged: onChanged,
        isDense: true,
        isExpanded: true,
        dropdownColor: isDark
            ? const Color(0xFF2A2A2A)
            : Colors.grey.shade50,
        elevation: 8,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          size: 18.0,
        ),
      ),
    );
  }
}