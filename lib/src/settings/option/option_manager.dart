import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_selector.dart';

class OptionManager {
  late SharedPreferencesWithCache _prefs;
  late SoundOptionHandler soundOption;

  // constructor
  static final OptionManager _instance = OptionManager._constructor();
  OptionManager._constructor();

  factory OptionManager() {
    return _instance;
  }

  Future<void> initSettings() async {
    // Migrate from legacy SharedPreferences to SharedPreferencesWithCache
    final legacyPrefs = await SharedPreferences.getInstance();
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    // Migrate existing data if needed
    await _migrateFromLegacyPrefs(legacyPrefs, _prefs);

    await setSoundOption(_prefs);
    await setThemeSelector(_prefs);
  }

  Future<void> _migrateFromLegacyPrefs(SharedPreferences legacy, SharedPreferencesWithCache cache) async {
    // Only migrate if cache is empty and legacy has data
    final legacyKeys = legacy.getKeys();
    if (legacyKeys.isNotEmpty) {
      for (String key in legacyKeys) {
        final value = legacy.get(key);
        if (value != null) {
          switch (value.runtimeType) {
            case bool:
              await cache.setBool(key, value as bool);
              break;
            case int:
              await cache.setInt(key, value as int);
              break;
            case double:
              await cache.setDouble(key, value as double);
              break;
            case String:
              await cache.setString(key, value as String);
              break;
            case List<String>:
              await cache.setStringList(key, value as List<String>);
              break;
          }
        }
      }
    }
  }

  Future<void> setSoundOption(SharedPreferencesWithCache prefs) async {
    soundOption = SoundOptionHandler(prefs);
    await soundOption.initSettings(prefs);
  }

  Future<void> setThemeSelector(SharedPreferencesWithCache prefs) async {
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
