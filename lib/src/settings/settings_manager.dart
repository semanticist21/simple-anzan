// singleton
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

class SettingsManager {
  // member
  late SharedPreferences _prefs;

  // constructor
  static final SettingsManager _instance = SettingsManager._constructor();
  SettingsManager._constructor() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    Settings(_prefs);
  }

  // returns _instance when it is called
  //, which is already initialized in pivate constructor.
  factory SettingsManager() => _instance;

  // fields methods
  CalculationMode mode() =>
      CalculationMode.values[Settings.currentCalculationModeIndex];

  CalculationMode boolToCalculationMode(bool flag) {
    if (flag) {
      return CalculationMode.onlyPlus;
    } else {
      return CalculationMode.plusMinus;
    }
  }

  bool calculationModeToBool(CalculationMode mode) {
    switch (mode) {
      case CalculationMode.onlyPlus:
        return true;
      case CalculationMode.plusMinus:
        return false;
    }
  }

  // num of problems.
  NumOfProblems numOfProblems() =>
      NumOfProblems.values[Settings.currentNumOfProblems];

  int numOfProblemsInt() => sliceNumOfProblems(numOfProblems().name);
  int sliceNumOfProblems(String str) => int.parse(str.split('_')[1]);

  NumOfProblems strToNumOfProblems(String str) {
    for (var value in NumOfProblems.values) {
      if (getNumOfProblemsStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  // speed
  Speed speed() => Speed.values[Settings.currentSpeedIndex];
  Duration speedDuration() => sliceSpeed(speed().name);

  Speed strToSpeed(String str) {
    for (var value in Speed.values) {
      if (getSpeedStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  Duration sliceSpeed(String str) {
    var milisecDuration = getDurationInt(str) * 100;

    return Duration(milliseconds: milisecDuration);
  }

  int getDurationInt(String str) => int.parse(str.split('_')[1]);

  // digit
  Digit digit() => Digit.values[Settings.currentDigit];
  int digitInt() => int.parse(getDigitStr(digit().name));

  Digit strToDigit(String str) {
    for (var value in Digit.values) {
      if (getDigitStr(value.name) == str) {
        return value;
      }
    }

    throw Error();
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case CalculationMode:
        _prefs.setInt(
            Settings.calculationModeKey, (value as CalculationMode).index);
        break;

      case Speed:
        _prefs.setInt(Settings.speedKey, (value as Speed).index);
        break;

      case Digit:
        _prefs.setInt(Settings.digitKey, (value as Digit).index);
        break;

      case NumOfProblems:
        _prefs.setInt(
            Settings.numOfProblemsKey, (value as NumOfProblems).index);
        break;

      default:
        throw Error();
    }

    Settings(_prefs);
  }

  // enum to list of items
  List<String> getItemsListOfEnum<T>() {
    List<String> result = List.empty(growable: true);

    switch (T) {
      case NumOfProblems:
        for (var element in NumOfProblems.values) {
          var str = getNumOfProblemsStr(element.name);
          result.add(str);
        }
        break;

      case Speed:
        for (var element in Speed.values) {
          var str = getSpeedStr(element.name);
          result.add(str);
        }
        break;

      case Digit:
        for (var element in Digit.values) {
          var str = getDigitStr(element.name);
          result.add(str);
        }
        break;
    }

    return result;
  }

  String getNumOfProblemsStr(String name) {
    return name.split('_')[1];
  }

  String getSpeedStr(String name) {
    return name.split('_')[0];
  }

  String getDigitStr(String name) {
    return name.split('_')[1];
  }
}
