// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';

import 'Interface/preference_interface.dart';

class ShuffleModePref implements PreferenceInterface<ShuffleMode, bool> {
  final String _saveKey = 'isShuffle';
  final int _defaultIndex = 1;

  late int _currentIndex;
  late ShuffleMode _currentValue;

  ShuffleModePref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(ShuffleMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = ShuffleMode.values[index];
  }

  ShuffleMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  ShuffleMode valueToEnum(bool flag) {
    if (flag) {
      return ShuffleMode.shuffle;
    } else {
      return ShuffleMode.notSuffle;
    }
  }

  bool enumToValue(ShuffleMode mode) {
    switch (mode) {
      case ShuffleMode.shuffle:
        return true;
      case ShuffleMode.notSuffle:
        return false;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as ShuffleMode).index);
}

enum ShuffleMode {
  shuffle,
  notSuffle,
}
