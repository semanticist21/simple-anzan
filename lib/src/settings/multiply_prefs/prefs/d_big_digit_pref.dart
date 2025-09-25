// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface_items.dart';

class BigDigitPref implements PreferenceInterfaceItems<BigDigit, int> {
  final String _saveKey = 'startDigit';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late BigDigit _currentValue;

  BigDigitPref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(BigDigit enumValue) {
    _currentValue = enumValue;
    _currentIndex = enumValue.index;
  }

  void setIndex(int index) {
    if (index > BigDigit.values.length - 1) {
      index = BigDigit.values.length - 1;
    }

    _currentIndex = index;
    _currentValue = BigDigit.values[_currentIndex];
  }

  BigDigit getValue() => _currentValue;
  int getIndex() => _currentIndex;

  BigDigit valueToEnum(int num) {
    for (var value in BigDigit.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(BigDigit enumType) => int.parse(_getDigitStr(enumType.name));

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListOfEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in BigDigit.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferencesWithCache prefs, value) =>
      prefs.setInt(_saveKey, (value as BigDigit).index);

  BigDigit itemStrToValue(String str) {
    for (var value in BigDigit.values) {
      if (_getDigitStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String _getDigitStr(String name) => name.split('_')[1];
}

enum BigDigit {
  one_1,
  two_2,
  three_3,
  four_4,
  five_5,
  six_6,
  seven_7,
  eight_8,
}
