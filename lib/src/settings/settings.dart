import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  // constructor
  Settings(SharedPreferences prefs) {
    currentCalculationModeIndex = prefs.getInt(calculationModeKey) ?? 0;
    currentNumOfProblems = prefs.getInt(numOfProblemsKey) ?? 0;
    currentSpeedIndex = prefs.getInt(speedKey) ?? 3;

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

// very slow : 1 sec
// slow : 0.7 sec
// normal : 0.5 sec
// fast : 0.3 sec
enum Speed {
  verySlow_10,
  slow_07,
  normal_05,
  fast_03,
  veryFast_02,
}
