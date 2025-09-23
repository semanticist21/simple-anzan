// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import '../../Interface/preference_interface_items.dart';

class NumOfProblemsPref
    implements PreferenceInterfaceItems<NumOfProblems, int> {
  final String _saveKey = 'numprops';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late NumOfProblems _currentValue;

  NumOfProblemsPref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(NumOfProblems enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = NumOfProblems.values[_currentIndex];
  }

  NumOfProblems getValue() => _currentValue;
  int getIndex() => _currentIndex;

  NumOfProblems valueToEnum(int num) {
    for (var value in NumOfProblems.values) {
      if (enumToValue(value) == num) {
        return value;
      }
    }

    throw Error();
  }

  int enumToValue(NumOfProblems enumType) =>
      int.parse(enumNameToItemString(enumType.name));

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value) =>
      prefs.setInt(_saveKey, (value as NumOfProblems).index);

  NumOfProblems itemStrToValue(String str) {
    for (var value in NumOfProblems.values) {
      if (enumNameToItemString(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  String enumNameToItemString(String name) => name.split('_')[1];

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in NumOfProblems.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }
}

enum NumOfProblems {
  n_2,
  n_3,
  n_4,
  n_5,
  n_6,
  n_7,
  n_8,
  n_9,
  n_10,
  n_11,
  n_12,
  n_13,
  n_14,
  n_15,
  n_20,
  n_25,
  n_30,
  n_35,
  n_40,
  n_45,
  n_50,
  n_60,
  n_70,
  n_80,
  n_90,
  n_100,
  n_150,
  n_200,
}
