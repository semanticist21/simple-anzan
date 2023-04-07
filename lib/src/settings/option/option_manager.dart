import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
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
    setSoundOption(_prefs);
  }

  void setSoundOption(SharedPreferences prefs) {
    SoundOption(prefs);
    SoundOption.isSoundOnStream.add(SoundOption.isSoundOn);
  }

  void setThemeSelector(SharedPreferences prefs) {
    ThemeSelector(prefs);
    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  setSoundBool(bool value) {
    SoundOption.isSoundOn = value;
    _saveSound(value);
    SoundOption.isSoundOnStream.add(value);
  }

  setThemeBool(bool value) {
    ThemeSelector.isDark = value;
    _saveTheme(value);
    ThemeSelector.isDarkStream.add(value);
  }

  void _saveSound(bool value) => _prefs.setBool(SoundOption.soundKey, value);
  void _saveTheme(bool value) => _prefs.setBool(ThemeSelector.themeKey, value);

  bool getCurrentSoundFlag() => SoundOption.isSoundOn;
  bool getCurrentDarkThemeFlag() => ThemeSelector.isDark;
}
