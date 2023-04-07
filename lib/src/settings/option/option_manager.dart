import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_selector.dart';

class OptionManager {
  late SharedPreferences _prefs;
  late SoundOptionHandler soundOption;

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
    soundOption = SoundOptionHandler(prefs);
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);
  }

  void setThemeSelector(SharedPreferences prefs) {
    ThemeSelector(prefs);
    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  setSoundBool(bool value) {
    SoundOptionHandler.isSoundOn = value;
    _saveSound(value);
    SoundOptionHandler.isSoundOnStream.add(value);
  }

  setThemeBool(bool value) {
    ThemeSelector.isDark = value;
    _saveTheme(value);
    ThemeSelector.isDarkStream.add(value);
  }

  void _saveSound(bool value) =>
      _prefs.setBool(SoundOptionHandler.soundKey, value);
  void _saveTheme(bool value) => _prefs.setBool(ThemeSelector.themeKey, value);

  bool getCurrentSoundFlag() => SoundOptionHandler.isSoundOn;
  bool getCurrentDarkThemeFlag() => ThemeSelector.isDark;
}
