// ignore_for_file: annotate_overrides

import 'package:shared_preferences/shared_preferences.dart';
import 'Interface/preference_interface_items.dart';

class SpeedPref implements PreferenceInterfaceItems<Speed, Duration> {
  final String _saveKey = 'interval';
  final int _defaultIndex = 2;

  late int _currentIndex;
  late Speed _currentValue;

  SpeedPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(Speed enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = Speed.values[index];
  }

  Speed getValue() => _currentValue;
  int getIndex() => _currentIndex;

  Speed valueToEnum(Duration duration) {
    for (var value in Speed.values) {
      if (enumToValue(value) == duration) {
        return value;
      }
    }

    throw Error();
  }

  Duration enumToValue(Speed enumType) {
    var milisecDuration = _getDurationInt(enumType.name) * 100;

    return Duration(milliseconds: milisecDuration);
  }

  Speed itemStrToValue(String str) {
    for (var value in Speed.values) {
      if (enumNameToItemString(value.name) == str) {
        return value;
      }
    }
    throw Error();
  }

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in Speed.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferences prefs, value) =>
      prefs.setInt(_saveKey, (value as Speed).index);

  int _getDurationInt(String str) => int.parse(str.split('_')[1]);
  String enumNameToItemString(String name) => name.split('_')[0];
}

enum Speed {
  verySlow_10,
  slow_07,
  normal_05,
  fast_03,
  veryFast_02,
}
