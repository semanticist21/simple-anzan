// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface.dart';

class CalculationModeMultiplyPref
    implements PreferenceInterface<CalCulationMultiplyMode, bool> {
  final String _saveKey = 'multiplyModes';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late CalCulationMultiplyMode _currentValue;

  CalculationModeMultiplyPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(CalCulationMultiplyMode enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = CalCulationMultiplyMode.values[index];
  }

  CalCulationMultiplyMode getValue() => _currentValue;
  int getIndex() => _currentIndex;

  CalCulationMultiplyMode valueToEnum(bool flag) {
    if (!flag) {
      return CalCulationMultiplyMode.multiply;
    } else {
      return CalCulationMultiplyMode.divide;
    }
  }

  bool enumToValue(CalCulationMultiplyMode mode) {
    switch (mode) {
      case CalCulationMultiplyMode.multiply:
        return false;
      case CalCulationMultiplyMode.divide:
        return true;
    }
  }

  void saveSetting(SharedPreferences prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as CalCulationMultiplyMode).index);
}

enum CalCulationMultiplyMode { multiply, divide }
