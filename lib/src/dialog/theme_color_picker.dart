import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../settings/option/theme_selector.dart';

class ThemeColorPicker extends StatefulWidget {
  final Color currentColor;
  final Function(Color) onColorSelected;

  const ThemeColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  State<ThemeColorPicker> createState() => _ThemeColorPickerState();
}

class _ThemeColorPickerState extends State<ThemeColorPicker> {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeSelector.isDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.palette,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'themePicker.title'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Color Picker Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'themePicker.description'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  BlockPicker(
                    pickerColor: widget.currentColor,
                    onColorChanged: (color) {
                      widget.onColorSelected(color);
                      Navigator.of(context).pop();
                    },
                    availableColors: const [
                      Color(0xFF2196F3), // Blue - default
                      Color(0xFF16A34A), // Green (shadcn green-600)
                      Color(0xFF0EA5E9), // Sky (shadcn sky-500)
                      Color(0xFFEAB308), // Yellow (shadcn yellow-500)
                      Color(0xFF8B5CF6), // Violet (shadcn violet-500)
                      Color(0xFF64748B), // Slate (shadcn slate-500)
                    ],
                    layoutBuilder: (context, colors, child) {
                      return GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (Color color in colors) child(color)
                        ],
                      );
                    },
                    itemBuilder: (color, isCurrentColor, changeColor) {
                      final isDefaultBlue = color == const Color(0xFF2196F3);

                      return Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrentColor
                                ? (isDark ? Colors.white70 : Colors.grey.shade400)
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: changeColor,
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                // "기본" badge for default blue - covers entire block (behind check icon)
                                if (isDefaultBlue)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'themePicker.default'.tr(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Check icon for selected color (always show on top)
                                if (isCurrentColor)
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
