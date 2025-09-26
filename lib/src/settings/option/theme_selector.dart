import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';


class ThemeSelector {
  static var themeKey = 'isDark';
  static var isDark = false;
  static StreamController<bool> isDarkStream = StreamController();
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

    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  /// Get the system's current theme preference
  /// Returns true if system is in dark mode, false for light mode
  bool _getSystemThemePreference() {
    // Get the current platform brightness from the system
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  static ThemeData getBlackTheme() {
    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // surface color (was background) - softer dark instead of pure black
                  surface: const Color(0xFF121212),
                  primary: const Color(0xFF6DB4FF), // brighter blue for better contrast

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
                  onSecondary: const Color(0xFF6DB4FF), // active track with opacity

                  // button color and text
                  onSurface: const Color(0xFFF0F0F0), // brighter warm white for better readability
                  onSurfaceVariant: const Color(0xFF4AE54A), // brighter iOS green

                  surfaceTint: const Color(0xFF6DB4FF),
                  surfaceContainerHighest: const Color(0xFF2A2A2A),
                ),
            textTheme: GoogleFonts.openSansTextTheme(
              const TextTheme(
                // option style

                // button text style
                bodyLarge: TextStyle(
                  color: Color(0xFFF0F0F0), // brighter warm white for better readability
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),

                // flicker style
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Color(0xFF6DB4FF), // use brighter primary blue for better consistency
                ),
              ),
            ))
        .copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
                thumbColor: WidgetStateProperty.all(Colors.transparent)));
  }

  // name tangled strangely...
  static ThemeData getWhiteTheme() {
    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // surface color (was background)
                  surface: const Color(0xFFFAFAFA),
                  primary: const Color(0xFF2196F3),

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
                  onSurfaceVariant: Colors.blueAccent,

                  surfaceTint: const Color(0xFF2196F3), // Use primary blue instead of orange
                  surfaceContainerHighest: const Color(0xFFE3F2FD), // Light blue container
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
