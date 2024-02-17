// ignore_for_file: annotate_overrides

import '../../Interface/preference_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculationModePref
    implements PreferenceInterface<CalculationMode, bool> {
  final String _saveKey = 'modes';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late CalculationMode _currentValue;

  CalculationModePref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(CalculationMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = CalculationMode.values[index];
  }

  CalculationMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  CalculationMode valueToEnum(bool flag) {
    if (flag) {
      return CalculationMode.onlyPlus;
    } else {
      return CalculationMode.plusMinus;
    }
  }

  bool enumToValue(CalculationMode mode) {
    switch (mode) {
      case CalculationMode.onlyPlus:
        return true;
      case CalculationMode.plusMinus:
        return false;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as CalculationMode).index);
}

enum CalculationMode {
  onlyPlus,
  plusMinus,
}
