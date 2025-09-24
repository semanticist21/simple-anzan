// ignore_for_file: annotate_overrides

import 'package:abacus_simple_anzan/src/settings/Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeperatorModePref implements PreferenceInterface<SeparatorMode, bool> {
  final String _saveKey = 'seperator';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late SeparatorMode _currentValue;

  SeperatorModePref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(SeparatorMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = SeparatorMode.values[index];
  }

  SeparatorMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  SeparatorMode valueToEnum(bool flag) {
    if (flag) {
      return SeparatorMode.on;
    } else {
      return SeparatorMode.off;
    }
  }

  bool enumToValue(SeparatorMode mode) {
    switch (mode) {
      case SeparatorMode.on:
        return true;
      case SeparatorMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as SeparatorMode).index);
}

enum SeparatorMode {
  off,
  on,
}
