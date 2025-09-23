// ignore_for_file: annotate_overrides

import 'package:abacus_simple_anzan/src/settings/Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeperatorModePref implements PreferenceInterface<SeperatorMode, bool> {
  final String _saveKey = 'seperator';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late SeperatorMode _currentValue;

  SeperatorModePref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(SeperatorMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = SeperatorMode.values[index];
  }

  SeperatorMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  SeperatorMode valueToEnum(bool flag) {
    if (flag) {
      return SeperatorMode.on;
    } else {
      return SeperatorMode.off;
    }
  }

  bool enumToValue(SeperatorMode mode) {
    switch (mode) {
      case SeperatorMode.on:
        return true;
      case SeperatorMode.off:
        return false;
    }
  }

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as SeperatorMode).index);
}

enum SeperatorMode {
  off,
  on,
}
