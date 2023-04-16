import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_selector.dart';

class OptionManager {
  late SharedPreferences _prefs;
  late SoundOptionHandler soundOption;

  // constructor
  static final OptionManager _instance = OptionManager._constructor();
  OptionManager._constructor();

  factory OptionManager() {
    return _instance;
  }

  Future<void> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    await setSoundOption(_prefs);
    await setThemeSelector(_prefs);
  }

  Future<void> setSoundOption(SharedPreferences prefs) async {
    soundOption = SoundOptionHandler(prefs);
    await soundOption.initSettings(prefs);
  }

  Future<void> setThemeSelector(SharedPreferences prefs) async {
    await ThemeSelector(prefs: prefs).initSettings();
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
