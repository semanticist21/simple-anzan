import 'package:shared_preferences/shared_preferences.dart';

// singleton
class SettingsManager {
  // member
  late SharedPreferences _prefs;
  late Settings _settings;

  // constructor
  static final SettingsManager _instance = SettingsManager._constructor();
  SettingsManager._constructor() {
    initSettings();
  }

  Future<void> initSettings() async {
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

  Speed speed() => Speed.values[Settings.currentSpeedIndex];

  int digit() => Settings.currentDigit;

  bool mixedMode() => Settings.isMixedMode;

  // save methods
  void saveSetting() => _settings.saveSettings(_prefs);
}

class Settings {
  // constructor
  Settings(SharedPreferences prefs) {
    currentCalculationModeIndex = prefs.getInt(calculationModeKey) ?? 0;
    currentNumOfProblems = prefs.getInt(numOfProblemsKey) ?? 0;
    currentSpeedIndex = prefs.getInt(speedKey) ?? 0;

    currentDigit = prefs.getInt(digitKey) ?? 2;
    isMixedMode = prefs.getBool(mixedModeKey) ?? false;
  }

  // keys
  static String calculationModeKey = "modes";
  static String numOfProblemsKey = "numprops";
  static String speedKey = "interval";

  static String digitKey = "digit";
  static String mixedModeKey = "mixed";

  // current mode states
  static int currentCalculationModeIndex = 0;
  static int currentNumOfProblems = 0;
  static int currentSpeedIndex = 0;

  static int currentDigit = 2;
  static bool isMixedMode = false;

  // methods
  void saveSettings(SharedPreferences prefs) {}
}

enum CalculationMode {
  onlyPlus,
  plusMinus,
  multiply,
  divide,
}

enum NumOfProblems {
  n_5,
  n_10,
  n_15,
  n_20,
}

enum Speed {
  slow,
  normal,
  fast,
}
