// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import 'Interface/preference_interface_items.dart';

class DigitPref implements PreferenceInterfaceItems<Digit, int> {
  final String _saveKey = 'digit';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late Digit _currentValue;

  DigitPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(Digit enumValue) {
    _currentValue = enumValue;
    _currentIndex = enumValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = Digit.values[_currentIndex];
  }

  Digit getValue() => _currentValue;
  int getIndex() => _currentIndex;

  Digit valueToEnum(int num) {
    for (var value in Digit.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(Digit enumType) => int.parse(_getDigitStr(enumType.name));

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in Digit.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferences prefs, value) =>
      prefs.setInt(_saveKey, (value as Digit).index);

  Digit itemStrToValue(String str) {
    for (var value in Digit.values) {
      if (_getDigitStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String _getDigitStr(String name) => name.split('_')[1];
}

enum Digit {
  one_1,
  two_2,
  three_3,
  four_4,
  five_5,
}
