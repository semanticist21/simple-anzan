// ignore_for_file: annotate_overrides

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import '../../Interface/preference_interface_items.dart';

class SpeedMultiplyPref
    implements PreferenceInterfaceItems<SpeedMultiply, Duration> {
  final String _saveKey = 'multiplyInterval';
  final String _saveCustomKey = 'multiplyIntervalCustom';

  final int _defaultIndex = 2;
  final int _defaultCustomValue = 1000;

  late int _currentIndex;
  late SpeedMultiply _currentValue;

  late int _currentCustomValue;

  SpeedMultiplyPref(SharedPreferences prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);

    var customVal = prefs.getInt(_saveCustomKey) ?? _defaultCustomValue;
    setCustomValue(customVal);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(SpeedMultiply enumValue) {
    _currentValue = enumValue;
    _currentIndex = _currentValue.index;
  }

  void setIndex(int index) {
    _currentIndex = index;
    _currentValue = SpeedMultiply.values[index];
  }

  void setCustomValue(int value) {
    _currentCustomValue = value;
  }

  SpeedMultiply getValue() => _currentValue;
  int getIndex() => _currentIndex;

  SpeedMultiply valueToEnum(Duration duration) {
    for (var value in SpeedMultiply.values) {
      if (enumToValue(value) == duration) {
        return value;
      }
    }

    throw Error();
  }

  Duration enumToValue(SpeedMultiply enumType) {
    var milisecDuration = 0;

    if (enumType != SpeedMultiply.custom) {
      milisecDuration = _getDurationInt(enumType.name) * 100;
    } else {
      milisecDuration = _getDurationInt(enumType.name);
    }

    return Duration(milliseconds: milisecDuration);
  }

  SpeedMultiply itemStrToValue(String str) {
    for (var value in SpeedMultiply.values) {
      if (enumNameToItemString(value.name) == str) {
        return value;
      }
    }

    return SpeedMultiply.custom;
  }

  List<String> getItemsListofEnum() {
    List<String> result = List.empty(growable: true);

    for (var element in SpeedMultiply.values) {
      var str = enumNameToItemString(element.name);
      result.add(str);
    }

    return result;
  }

  void saveSetting(SharedPreferences prefs, value) =>
      prefs.setInt(_saveKey, (value as SpeedMultiply).index);

  void saveCustomValue(SharedPreferences prefs, int value) =>
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

enum SpeedMultiply {
  verySlow_50,
  slow_40,
  normal_30,
  fast_20,
  veryFast_10,
  custom,
}
