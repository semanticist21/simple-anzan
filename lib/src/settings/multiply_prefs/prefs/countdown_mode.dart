// ignore_for_file: annotate_overrides

import '../../Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownModeMultiplyPref
    implements PreferenceInterface<CountDownMultiplyMode, bool> {
  final String _saveKey = 'countdownMultiply';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late CountDownMultiplyMode _currentValue;

  CountDownModeMultiplyPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(CountDownMultiplyMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = CountDownMultiplyMode.values[index];
  }

  CountDownMultiplyMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  CountDownMultiplyMode valueToEnum(bool flag) {
    if (flag) {
      return CountDownMultiplyMode.on;
    } else {
      return CountDownMultiplyMode.off;
    }
  }

  bool enumToValue(CountDownMultiplyMode mode) {
    switch (mode) {
      case CountDownMultiplyMode.on:
        return true;
      case CountDownMultiplyMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as CountDownMultiplyMode).index);
}

enum CountDownMultiplyMode {
  off,
  on,
}
