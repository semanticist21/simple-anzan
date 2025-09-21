// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';

import '../../Interface/preference_interface.dart';

class BurningModeMultiplyPref implements PreferenceInterface<BurningModeMultiply, bool> {
  final String _saveKey = 'isBurningModeMultiply';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late BurningModeMultiply _currentValue;

  BurningModeMultiplyPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(BurningModeMultiply enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = BurningModeMultiply.values[index];
  }

  BurningModeMultiply getValue() => _currentValue;
  int getIndex() => _currentIndex;

  BurningModeMultiply valueToEnum(bool flag) {
    if (flag) {
      return BurningModeMultiply.on;
    } else {
      return BurningModeMultiply.off;
    }
  }

  bool enumToValue(BurningModeMultiply mode) {
    switch (mode) {
      case BurningModeMultiply.on:
        return true;
      case BurningModeMultiply.off:
        return false;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as BurningModeMultiply).index);
}

enum BurningModeMultiply {
  off,
  on,
}