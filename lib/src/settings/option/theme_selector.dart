import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/const.dart';

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
                  // background color
                  background: const ColorScheme.dark().background,

                  // secondary background like ..dropdown button / scaffold background
                  onBackground: Colors.white,

                  // not selected Color
                  onInverseSurface: Colors.grey[400],

                  // flicker background (option background)
                  // flicker border color
                  // flicker border
                  onSecondaryContainer:
                      const Color.fromRGBO(158, 158, 158, 0.1),
                  shadow: const Color.fromRGBO(96, 125, 139, 0.1),

                  // setting page
                  // setting page drop down background
                  // setting page border
                  onTertiaryContainer: const Color.fromRGBO(158, 158, 158, 0.1),
                  tertiaryContainer: Colors.white,
                  outlineVariant: const Color.fromRGBO(96, 125, 139, 0.1),

                  // option title color
                  secondaryContainer: Colors.grey,

                  // option primary text color
                  primaryContainer: Colors.grey[400],

                  // button form text color
                  onPrimaryContainer: Colors.grey[800],

                  // divider Color
                  outline: const Color.fromARGB(255, 60, 60, 60),

                  // toggle track, active color
                  onPrimary: Colors.grey,
                  onSecondary: Colors.blueGrey,

                  // button color
                  onSurface: Colors.green,
                  onSurfaceVariant: Colors.greenAccent,

                  surfaceTint: const Color.fromRGBO(112, 128, 250, 1),
                  surfaceVariant: const Color.fromRGBO(99, 116, 244, 1),
                ),
            textTheme: const TextTheme(
              // option style

              // button text style
              bodyLarge: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: defaultFontFamily,
                letterSpacing: 2.5,
              ),

              // flicker style
              titleLarge: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: defaultFontFamily,
                letterSpacing: 3,
                color: Color.fromARGB(255, 113, 150, 67),
              ),
            ))
        .copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
                thumbColor: MaterialStateProperty.all(Colors.transparent)));
  }

  // name tangled strangely...
  static ThemeData getWhiteTheme() {
    return ThemeData.from(
            // toggle active color
            colorScheme: ThemeData().colorScheme.copyWith(
                  // background color
                  background: const Color.fromRGBO(250, 250, 250, 1),

                  // secondary background like ..dropdown button / scaffold background
                  onBackground: Colors.grey[600],

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
                  onSurface: Colors.blue,
                  onSurfaceVariant: Colors.blueAccent,

                  surfaceTint: Colors.orange,
                  surfaceVariant: Colors.orangeAccent,
                ),
            textTheme: const TextTheme(
              // option style

              // button text style
              bodyLarge: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: defaultFontFamily,
                letterSpacing: 2.5,
              ),

              // flicker style
              titleLarge: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: defaultFontFamily,
                letterSpacing: 3,
                color: Colors.black87,
              ),
            ))
        .copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
                thumbColor: MaterialStateProperty.all(Colors.transparent)));
  }
}
