// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface_items.dart';

class NumOfProblemsMultiplyPref
    implements PreferenceInterfaceItems<NumOfMultiplyProblems, int> {
  final String _saveKey = 'multiplyNumprops';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late NumOfMultiplyProblems _currentValue;

  NumOfProblemsMultiplyPref(SharedPreferencesWithCache prefs) {
    // Warning !!!!!
    // change this option when implementing!!
    // always default 0.
    prefs.setInt(_saveKey, _defaultIndex);

    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(NumOfMultiplyProblems enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = NumOfMultiplyProblems.values[_currentIndex];
  }

  NumOfMultiplyProblems getValue() => _currentValue;
  int getIndex() => _currentIndex;

  NumOfMultiplyProblems valueToEnum(int num) {
    for (var value in NumOfMultiplyProblems.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(NumOfMultiplyProblems enumType) =>
      int.parse(enumNameToItemString(enumType.name));

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as NumOfMultiplyProblems).index);

  NumOfMultiplyProblems itemStrToValue(String str) {
    for (var value in NumOfMultiplyProblems.values) {
      if (enumNameToItemString(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in NumOfMultiplyProblems.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }
}

enum NumOfMultiplyProblems {
  n_1,
  n_2,
  n_3,
  n_4,
  n_5,
  n_10,
  n_15,
  n_20,
  n_25,
  n_30,
  n_35,
  n_40,
  n_45,
  n_50,
}
