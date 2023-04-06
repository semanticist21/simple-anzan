// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface_items.dart';

class EndDigitPref implements PreferenceInterfaceItems<EndDigit, int> {
  final String _saveKey = 'endDigit';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late EndDigit _currentValue;

  EndDigitPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(EndDigit enumValue) {
    _currentValue = enumValue;
    _currentIndex = enumValue.index;
  }

  void setIndex(int index) {
    if (index > EndDigit.values.length - 1) {
      index = EndDigit.values.length - 1;
    }

    _currentIndex = index;
    _currentValue = EndDigit.values[_currentIndex];
  }

  EndDigit getValue() => _currentValue;
  int getIndex() => _currentIndex;

  EndDigit valueToEnum(int num) {
    for (var value in EndDigit.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(EndDigit enumType) => int.parse(_getDigitStr(enumType.name));

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in EndDigit.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferences prefs, value) =>
      prefs.setInt(_saveKey, (value as EndDigit).index);

  EndDigit itemStrToValue(String str) {
    for (var value in EndDigit.values) {
      if (_getDigitStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String _getDigitStr(String name) => name.split('_')[1];
}

enum EndDigit {
  one_1,
  two_2,
  three_3,
  four_4,
  five_5,
  six_6,
  seven_7,
}
