// singleton
import 'package:abacus_simple_anzan/src/settings/prefs/calculation_mode_pref.dart';
import 'package:abacus_simple_anzan/src/settings/prefs/digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/prefs/speed.dart';
import 'package:abacus_simple_anzan/src/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  // member
  late SharedPreferences _prefs;
  late CalculationModePref _calculationModePref;
  late SpeedPref _speedPref;
  late DigitPref _digitPref;
  late NumOfProblemsPref _numOfProblemsPref;

  // constructor
  static final SettingsManager _instance = SettingsManager._constructor();
  SettingsManager._constructor() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    refreshPrefValues(_prefs);
    setThemeSelector(_prefs);
  }

  void refreshPrefValues(SharedPreferences prefs) {
    _calculationModePref = CalculationModePref(prefs);
    _speedPref = SpeedPref(prefs);
    _digitPref = DigitPref(prefs);
    _numOfProblemsPref = NumOfProblemsPref(prefs);
  }

  // returns _instance when it is called.
  //, which is already initialized in pivate constructor.
  factory SettingsManager() => _instance;

  // fields methods.
  // calculation mode.
  T getCurrentEnum<T>() {
    switch (T) {
      case CalculationMode:
        return _calculationModePref.getValue() as T;
      case Speed:
        return _speedPref.getValue() as T;
      case Digit:
        return _digitPref.getValue() as T;
      case NumOfProblems:
        return _numOfProblemsPref.getValue() as T;
      default:
        throw Error();
    }
  }

  T valueToEnum<V, T>(V value) {
    switch (T) {
      case CalculationMode:
        return _calculationModePref.valueToEnum(value as bool) as T;
      case Speed:
        return _speedPref.valueToEnum(value as Duration) as T;
      case Digit:
        return _digitPref.valueToEnum(value as int) as T;
      case NumOfProblems:
        return _numOfProblemsPref.valueToEnum(value as int) as T;
      default:
        throw Error();
    }
  }

  V enumToValue<T, V>(T enumValue) {
    switch (T) {
      case CalculationMode:
        return _calculationModePref.enumToValue(enumValue as CalculationMode)
            as V;
      case Speed:
        return _speedPref.enumToValue(enumValue as Speed) as V;
      case Digit:
        return _digitPref.enumToValue(enumValue as Digit) as V;
      case NumOfProblems:
        return _numOfProblemsPref.enumToValue(enumValue as NumOfProblems) as V;
      default:
        throw Error();
    }
  }

  V getCurrentValue<T, V>() {
    switch (T) {
      case Speed:
        return _speedPref.enumToValue(getCurrentEnum<Speed>()) as V;
      case Digit:
        return _digitPref.enumToValue(getCurrentEnum<Digit>()) as V;
      case NumOfProblems:
        return _numOfProblemsPref.enumToValue(getCurrentEnum<NumOfProblems>())
            as V;
      default:
        throw Error();
    }
  }

  T itemStrToEnum<T>(String str) {
    switch (T) {
      case Speed:
        return _speedPref.itemStrToValue(str) as T;
      case Digit:
        return _digitPref.itemStrToValue(str) as T;
      case NumOfProblems:
        return _numOfProblemsPref.itemStrToValue(str) as T;
      default:
        throw Error();
    }
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case CalculationMode:
        _calculationModePref.saveSetting(_prefs, value);
        break;
      case Speed:
        _speedPref.saveSetting(_prefs, value);
        break;
      case Digit:
        _digitPref.saveSetting(_prefs, value);
        break;
      case NumOfProblems:
        _numOfProblemsPref.saveSetting(_prefs, value);
        break;
      default:
        throw Error();
    }

    refreshPrefValues(_prefs);
  }

  void saveCustomSpeedSetting(int value) {
    _speedPref.saveCustomValue(_prefs, value);
    refreshPrefValues(_prefs);
  }

  // enum to list of items
  List<String> getItemsListOfEnum<T>() {
    switch (T) {
      case NumOfProblems:
        return _numOfProblemsPref.getItemsListofEnum();
      case Speed:
        return _speedPref.getItemsListofEnum();
      case Digit:
        return _digitPref.getItemsListofEnum();
      default:
        throw Error();
    }
  }

  String getItemStr<T>(String enumName) {
    switch (T) {
      case NumOfProblems:
        return _numOfProblemsPref.enumNameToItemString(enumName);
      case Speed:
        return _speedPref.enumNameToItemString(enumName);
      case Digit:
        return _digitPref.enumNameToItemString(enumName);
      default:
        throw Error();
    }
  }

  void setThemeSelector(SharedPreferences prefs) {
    ThemeSelector(prefs);
    ThemeSelector.isDarkStream.add(ThemeSelector.isDark);
  }

  setThemeBool(bool value) {
    ThemeSelector.isDark = value;
    _saveTheme(value);
    ThemeSelector.isDarkStream.add(value);
  }

  void _saveTheme(bool value) => _prefs.setBool(ThemeSelector.themeKey, value);

  bool getCurrentDarkThemeFlag() => ThemeSelector.isDark;
}
