// ignore_for_file: annotate_overrides

import 'package:abacus_simple_anzan/src/settings/Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeparatorModeMultiplyPref
    implements PreferenceInterface<SeparatorMultiplyMode, bool> {
  final String _saveKey = 'separatorMultiply';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late SeparatorMultiplyMode _currentValue;

  SeparatorModeMultiplyPref.separatorModeMultiplyPref(
      SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(SeparatorMultiplyMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = SeparatorMultiplyMode.values[index];
  }

  SeparatorMultiplyMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  SeparatorMultiplyMode valueToEnum(bool flag) {
    if (flag) {
      return SeparatorMultiplyMode.on;
    } else {
      return SeparatorMultiplyMode.off;
    }
  }

  bool enumToValue(SeparatorMultiplyMode mode) {
    switch (mode) {
      case SeparatorMultiplyMode.on:
        return true;
      case SeparatorMultiplyMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as SeparatorMultiplyMode).index);
}

enum SeparatorMultiplyMode {
  off,
  on,
}
