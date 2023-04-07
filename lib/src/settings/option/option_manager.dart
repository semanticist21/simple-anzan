import 'package:shared_preferences/shared_preferences.dart';

import 'theme_selector.dart';

class OptionManager {
  late SharedPreferences _prefs;

  // constructor
  static final OptionManager _instance = OptionManager._constructor();
  OptionManager._constructor() {
    _initSettings();
  }

  factory OptionManager() {
    return _instance;
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setThemeSelector(_prefs);
  }

  void setThemeSelector(SharedPreferences prefs) {
    ThemeSelector(prefs);
    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  setThemeBool(bool value) {
    ThemeSelector.isDark = value;
    _saveTheme(value);
    ThemeSelector.isDarkStream.add(value);
  }

  void _saveTheme(bool value) => _prefs.setBool(ThemeSelector.themeKey, value);

  bool getCurrentDarkThemeFlag() => ThemeSelector.isDark;
}
