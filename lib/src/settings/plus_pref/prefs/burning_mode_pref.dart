// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';

import '../../Interface/preference_interface.dart';

class BurningModePref implements PreferenceInterface<BurningMode, bool> {
  final String _saveKey = 'isBurningMode';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late BurningMode _currentValue;

  BurningModePref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(BurningMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = BurningMode.values[index];
  }

  BurningMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  BurningMode valueToEnum(bool flag) {
    if (flag) {
      return BurningMode.on;
    } else {
      return BurningMode.off;
    }
  }

  bool enumToValue(BurningMode mode) {
    switch (mode) {
      case BurningMode.on:
        return true;
      case BurningMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as BurningMode).index);
}

enum BurningMode {
  off,
  on,
}