// ignore_for_file: annotate_overrides

import 'package:abacus_simple_anzan/src/settings/Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeperatorModeMultiplyPref
    implements PreferenceInterface<SeperatorMultiplyMode, bool> {
  final String _saveKey = 'seperatorMultiply';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late SeperatorMultiplyMode _currentValue;

  SeperatorModeMultiplyPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(SeperatorMultiplyMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = SeperatorMultiplyMode.values[index];
  }

  SeperatorMultiplyMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  SeperatorMultiplyMode valueToEnum(bool flag) {
    if (flag) {
      return SeperatorMultiplyMode.on;
    } else {
      return SeperatorMultiplyMode.off;
    }
  }

  bool enumToValue(SeperatorMultiplyMode mode) {
    switch (mode) {
      case SeperatorMultiplyMode.on:
        return true;
      case SeperatorMultiplyMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as SeperatorMultiplyMode).index);
}

enum SeperatorMultiplyMode {
  off,
  on,
}
