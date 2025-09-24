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
    isDark = prefs.getBool(themeKey) ?? false;
    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  static ThemeData getBlackTheme() {
    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // surface color (was background) - pure black for OLED
                  surface: const Color(0xFF000000),
                  primary: const Color(0xFF64AFFF), // softer blue for natural dark mode

                  // secondary surface like ..dropdown button / scaffold background
                  surfaceContainer: const Color(0xFF1C1C1E), // elevated surface

                  // not selected Color
                  onInverseSurface: const Color(0xFF8E8E93), // muted grey

                  // flicker background (option background)
                  // flicker border color
                  // flicker border
                  onSecondaryContainer: Colors.transparent,
                  shadow: Colors.transparent,

                  // setting page
                  // setting page drop down background
                  // setting page border
                  onTertiaryContainer: const Color.fromRGBO(158, 158, 158, 0.08),
                  tertiaryContainer: const Color(0xFFE5E5E7),
                  outlineVariant: const Color.fromRGBO(255, 255, 255, 0.08),

                  // option title color
                  secondaryContainer: const Color(0xFF8E8E93),

                  // option primary text color
                  primaryContainer: const Color(0xFFE5E5E7),

                  // button form text color
                  onPrimaryContainer: const Color(0xFF8E8E93),

                  // divider Color
                  outline: const Color.fromRGBO(255, 255, 255, 0.08),

                  // toggle track, active color (for switches)
                  onPrimary: const Color(0xFF3A3A3C), // inactive track
                  onSecondary: const Color(0xFF64AFFF), // active track with opacity

                  // button color and text
                  onSurface: const Color(0xFFE5E5E7), // warm white instead of pure white
                  onSurfaceVariant: const Color(0xFF32D74B), // iOS green

                  surfaceTint: const Color(0xFF64AFFF),
                  surfaceContainerHighest: const Color(0xFF1C1C1E),
                ),
            textTheme: GoogleFonts.openSansTextTheme(
              const TextTheme(
                // option style

                // button text style
                bodyLarge: TextStyle(
                  color: Color(0xFFE5E5E7), // warm white for natural dark mode
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),

                // flicker style
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Color(0xFF64AFFF), // use primary blue for better consistency
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
                  surfaceContainer: Colors.grey[600],

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

                  surfaceTint: Colors.orange,
                  surfaceContainerHighest: Colors.orangeAccent,
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
