// ignore_for_file: annotate_overrides

import '../Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorPalettePref
    implements PreferenceInterface<ColorPalette, String> {
  final String _saveKey = 'colorPalette';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late ColorPalette _currentValue;

  ColorPalettePref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(ColorPalette enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = ColorPalette.values[index];
  }

  ColorPalette getValue() => _currentValue;
  int getIndex() => _currentIndex;

  ColorPalette valueToEnum(String value) {
    switch (value.toLowerCase()) {
      case 'blue':
        return ColorPalette.blue;
      case 'green':
        return ColorPalette.green;
      case 'sky':
        return ColorPalette.sky;
      case 'yellow':
        return ColorPalette.yellow;
      case 'violet':
        return ColorPalette.violet;
      case 'slate':
        return ColorPalette.slate;
      default:
        return ColorPalette.blue;
    }
  }

  String enumToValue(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.blue:
        return 'blue';
      case ColorPalette.green:
        return 'green';
      case ColorPalette.sky:
        return 'sky';
      case ColorPalette.yellow:
        return 'yellow';
      case ColorPalette.violet:
        return 'violet';
      case ColorPalette.slate:
        return 'slate';
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as ColorPalette).index);
}

enum ColorPalette {
  blue,
  green,
  sky,
  yellow,
  violet,
  slate,
}
