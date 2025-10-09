import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette_pref.dart';


class ThemeSelector {
  static var themeKey = 'isDark';
  static var isDark = false;
  static StreamController<bool> isDarkStream = StreamController();

  static ColorPalette currentPalette = ColorPalette.blue;
  static StreamController<ColorPalette> colorPaletteStream = StreamController();

  SharedPreferencesWithCache prefs;

  ThemeSelector({required this.prefs});

  Future<void> initSettings() async {
    // Check if we have a saved preference first
    bool? savedTheme = prefs.getBool(themeKey);

    if (savedTheme != null) {
      // Use saved preference if available
      isDark = savedTheme;
    } else {
      // No saved preference, use system preference
      isDark = _getSystemThemePreference();
    }

    // Load color palette preference
    ColorPalettePref palettePref = ColorPalettePref(prefs);
    currentPalette = palettePref.getValue();

    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
    ThemeSelector.colorPaletteStream.add(ThemeSelector.currentPalette);
  }

  /// Get the system's current theme preference
  /// Returns true if system is in dark mode, false for light mode
  bool _getSystemThemePreference() {
    // Get the current platform brightness from the system
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Get primary colors for each palette (shadcn-inspired)
  static Color getPrimaryColor(ColorPalette palette, bool isDark) {
    switch (palette) {
      case ColorPalette.blue:
        return isDark ? const Color(0xFF6DB4FF) : const Color(0xFF2196F3);
      case ColorPalette.green:
        return isDark ? const Color(0xFF22C55E) : const Color(0xFF16A34A); // green-500/600
      case ColorPalette.sky:
        return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0EA5E9); // sky-400/500
      case ColorPalette.yellow:
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFFEAB308); // yellow-400/500
      case ColorPalette.violet:
        return isDark ? const Color(0xFFA78BFA) : const Color(0xFF8B5CF6); // violet-400/500
      case ColorPalette.slate:
        return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B); // slate-400/500
    }
  }

  /// Get surface tint colors for each palette
  static Color getSurfaceTint(ColorPalette palette, bool isDark) {
    return getPrimaryColor(palette, isDark);
  }

  /// Get flicker text color - black for default theme in light mode, primary otherwise
  static Color getFlickerTextColor(BuildContext context) {
    final isDark = ThemeSelector.isDark;
    final isDefaultTheme = currentPalette == ColorPalette.blue;

    // Default theme + light mode = black text
    if (isDefaultTheme && !isDark) {
      return Colors.black87;
    }

    // All other cases = primary color
    return Theme.of(context).colorScheme.primary;
  }

  static ThemeData getBlackTheme() {
    final primaryColor = getPrimaryColor(currentPalette, true);

    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // surface color (was background) - softer dark instead of pure black
                  surface: const Color(0xFF121212),
                  primary: primaryColor, // dynamic primary color based on palette

                  // secondary surface like ..dropdown button / scaffold background
                  surfaceContainer: const Color(0xFF1E1E1E), // elevated surface

                  // not selected Color
                  onInverseSurface: const Color(0xFF9E9E9E), // slightly brighter muted grey

                  // flicker background (option background)
                  // flicker border color
                  // flicker border
                  onSecondaryContainer: Colors.transparent,
                  shadow: Colors.transparent,

                  // setting page
                  // setting page drop down background
                  // setting page border
                  onTertiaryContainer: const Color.fromRGBO(158, 158, 158, 0.12),
                  tertiaryContainer: const Color(0xFFF0F0F0),
                  outlineVariant: const Color.fromRGBO(255, 255, 255, 0.12),

                  // option title color
                  secondaryContainer: const Color(0xFFB0B0B0),

                  // option primary text color
                  primaryContainer: const Color(0xFFF0F0F0),

                  // button form text color
                  onPrimaryContainer: const Color(0xFFB0B0B0),

                  // divider Color
                  outline: const Color.fromRGBO(255, 255, 255, 0.12),

                  // toggle track, active color (for switches)
                  onPrimary: const Color(0xFF404040), // inactive track
                  onSecondary: primaryColor, // active track with opacity (dynamic)

                  // button color and text
                  onSurface: const Color(0xFFF0F0F0), // brighter warm white for better readability
                  onSurfaceVariant: const Color(0xFF4AE54A), // brighter iOS green

                  surfaceTint: primaryColor, // dynamic surface tint
                  surfaceContainerHighest: const Color(0xFF2A2A2A),
                ),
            textTheme: GoogleFonts.openSansTextTheme(
              TextTheme(
                // option style

                // button text style
                bodyLarge: const TextStyle(
                  color: Color(0xFFF0F0F0), // brighter warm white for better readability
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),

                // flicker style
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: primaryColor, // dynamic primary color for consistency
                ),
              ),
            ))
        .copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
                thumbColor: WidgetStateProperty.all(Colors.transparent)));
  }

  // name tangled strangely...
  static ThemeData getWhiteTheme() {
    final primaryColor = getPrimaryColor(currentPalette, false);

    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // surface color (was background)
                  surface: const Color(0xFFFAFAFA),
                  primary: primaryColor, // dynamic primary color based on palette

                  // secondary surface like ..dropdown button / scaffold background
                  surfaceContainer: const Color(0xFFF5F5F5),

                  // not selected Color
                  onInverseSurface: Colors.grey[400],

                  // flicker background (option background)
                  // flicker border color
                  // flicker border
                  onSecondaryContainer:
                      const Color.fromRGBO(158, 158, 158, 0.2),
                  shadow: Colors.white,

                  // setting page background
                  // setting page drop down background
                  // setting page border
                  onTertiaryContainer: Colors.white70,
                  tertiaryContainer: Colors.grey[200],
                  outlineVariant: Colors.black,

                  // option title color
                  secondaryContainer: Colors.black,
                  secondary: Colors.white,

                  // option primary text color
                  primaryContainer: Colors.black,

                  // button form text color
                  onPrimaryContainer: Colors.grey[800],

                  // divider Color
                  outline: const Color.fromARGB(255, 60, 60, 60),

                  // toggle track, active color
                  onPrimary: const Color.fromRGBO(240, 240, 240, 1),
                  onSecondary: Colors.black87,

                  // button color
                  onSurface: Colors.grey[700],
                  onSurfaceVariant: primaryColor.withValues(alpha: 0.7), // dynamic accent color

                  surfaceTint: primaryColor, // dynamic surface tint
                  surfaceContainerHighest: primaryColor.withValues(alpha: 0.1), // dynamic light container
                ),
            textTheme: GoogleFonts.openSansTextTheme(
              const TextTheme(
                // option style

                // button text style
                bodyLarge: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),

                // flicker style
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.black87,
                ),
              ),
            ))
        .copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
                thumbColor: WidgetStateProperty.all(Colors.transparent)));
  }
}
