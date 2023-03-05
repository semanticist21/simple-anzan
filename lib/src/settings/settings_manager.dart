// singleton
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

class SettingsManager {
  // member
  late SharedPreferences _prefs;
  late Settings _settings;

  // constructor
  static final SettingsManager _instance = SettingsManager._constructor();
  SettingsManager._constructor() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _settings = Settings(_prefs);
  }

  // returns _instance when it is called
  //, which is already initialized in pivate constructor.
  factory SettingsManager() {
    return _instance;
  }

  // fields methods
  CalculationMode mode() =>
      CalculationMode.values[Settings.currentCalculationModeIndex];

  NumOfProblems numOfProblems() =>
      NumOfProblems.values[Settings.currentNumOfProblems];

  int numOfProblemsInt() {
    switch (numOfProblems()) {
      case NumOfProblems.n_5:
        return sliceNumOfProblems(NumOfProblems.n_5.name);
      case NumOfProblems.n_10:
        return sliceNumOfProblems(NumOfProblems.n_10.name);
      case NumOfProblems.n_15:
        return sliceNumOfProblems(NumOfProblems.n_15.name);
      case NumOfProblems.n_20:
        return sliceNumOfProblems(NumOfProblems.n_20.name);
    }
  }

  int sliceNumOfProblems(String str) {
    return int.parse(str.split('_')[1]);
  }

  Speed speed() => Speed.values[Settings.currentSpeedIndex];

  Duration speedDuration() {
    switch (speed()) {
      case Speed.verySlow_10:
        return sliceSpeed(Speed.verySlow_10.name);
      case Speed.slow_07:
        return sliceSpeed(Speed.slow_07.name);
      case Speed.normal_05:
        return sliceSpeed(Speed.normal_05.name);
      case Speed.fast_03:
        return sliceSpeed(Speed.fast_03.name);
      case Speed.veryFast_02:
        return sliceSpeed(Speed.veryFast_02.name);
    }
  }

  Duration sliceSpeed(String str) {
    var durationNum = str.split('_')[1];
    var parsedDurationNum = int.parse(durationNum) * 100;

    return Duration(milliseconds: parsedDurationNum);
  }

  int digit() => Settings.currentDigit;

  bool mixedMode() => Settings.isMixedMode;

  // save methods
  void saveSetting() => _settings.saveSettings(_prefs);
}
