// ignore_for_file: annotate_overrides

import '../../Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownModePref implements PreferenceInterface<CountDownMode, bool> {
  final String _saveKey = 'countdown';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late CountDownMode _currentValue;

  CountDownModePref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(CountDownMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = CountDownMode.values[index];
  }

  CountDownMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  CountDownMode valueToEnum(bool flag) {
    if (flag) {
      return CountDownMode.on;
    } else {
      return CountDownMode.off;
    }
  }

  bool enumToValue(CountDownMode mode) {
    switch (mode) {
      case CountDownMode.on:
        return true;
      case CountDownMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as CountDownMode).index);
}

enum CountDownMode {
  off,
  on,
}
