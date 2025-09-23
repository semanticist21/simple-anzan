// ignore_for_file: annotate_overrides

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import '../../Interface/preference_interface_items.dart';

class SpeedPref implements PreferenceInterfaceItems<Speed, Duration> {
  final String _saveKey = 'interval';
  final String _saveCustomKey = 'intervalCustom';

  final int _defaultIndex = 2;
  final int _defaultCustomValue = 500;

  late int _currentIndex;
  late Speed _currentValue;

  late int _currentCustomValue;

  SpeedPref(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    print(index);
    setIndex(index);

    var customVal = prefs.getInt(_saveCustomKey) ?? _defaultCustomValue;
    setCustomValue(customVal);
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

  void setCustomValue(int value) {
    _currentCustomValue = value;
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
    var milisecDuration = 0;

    if (enumType != Speed.custom) {
      milisecDuration = _getDurationInt(enumType.name) * 100;
    } else {
      milisecDuration = _getDurationInt(enumType.name);
    }

    return Duration(milliseconds: milisecDuration);
  }

  Speed itemStrToValue(String str) {
    for (var value in Speed.values) {
      if (enumNameToItemString(value.name) == str) {
        return value;
      }
    }

    return Speed.custom;
  }

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in Speed.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferencesWithCache prefs, value) =>
      prefs.setInt(_saveKey, (value as Speed).index);

  void saveCustomValue(SharedPreferencesWithCache prefs, int value) =>
      prefs.setInt(_saveCustomKey, value);

  int _getDurationInt(String str) {
    if (str.split('_').length != 2) {
      return _currentCustomValue;
    }

    return int.parse(str.split('_')[1]);
  }

  String enumNameToItemString(String name) {
    var split = name.split('_');
    if (split.length != 2) {
      return 'custom';
    }

    var first = split[0];
    var second = split[1].characters;

    var firstChar = second.first;
    var secondChar = second.last;
    var newStr = '$firstChar.$secondChar sec';

    return Platform.isWindows ? '$first ($newStr)' : '$first \n($newStr)';
  }
}

enum Speed {
  verySlow_10,
  slow_07,
  normal_05,
  fast_03,
  veryFast_02,
  custom,
}
