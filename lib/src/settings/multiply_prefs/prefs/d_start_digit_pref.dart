// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface_items.dart';

class StartDigitPref implements PreferenceInterfaceItems<StartDigit, int> {
  final String _saveKey = 'startDigit';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late StartDigit _currentValue;

  StartDigitPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(StartDigit enumValue) {
    _currentValue = enumValue;
    _currentIndex = enumValue.index;
  }

  void setIndex(int index) {
    if (index > StartDigit.values.length - 1) {
      index = StartDigit.values.length - 1;
    }

    _currentIndex = index;
    _currentValue = StartDigit.values[_currentIndex];
  }

  StartDigit getValue() => _currentValue;
  int getIndex() => _currentIndex;

  StartDigit valueToEnum(int num) {
    for (var value in StartDigit.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(StartDigit enumType) =>
      int.parse(_getDigitStr(enumType.name));

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in StartDigit.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferences prefs, value) =>
      prefs.setInt(_saveKey, (value as StartDigit).index);

  StartDigit itemStrToValue(String str) {
    for (var value in StartDigit.values) {
      if (_getDigitStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String _getDigitStr(String name) => name.split('_')[1];
}

enum StartDigit {
  one_1,
  two_2,
  three_3,
  four_4,
  five_5,
  six_6,
  seven_7,
}
