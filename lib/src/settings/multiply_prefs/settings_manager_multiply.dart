// singleton
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_end_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_start_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMultiplyManager {
  // member
  late SharedPreferences _prefs;

  late CalculationModeMultiplyPref _calculationModePref;
  late SpeedMultiplyPref _speedPref;
  late StartDigitPref _startDigitPref;
  late EndDigitPref _endDigitPref;
  late NumOfProblemsMultiplyPref _numOfProblemsPref;

  // constructor
  static final SettingsMultiplyManager _instance =
      SettingsMultiplyManager._constructor();
  SettingsMultiplyManager._constructor() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    refreshPrefValues(_prefs);
  }

  void refreshPrefValues(SharedPreferences prefs) {
    _calculationModePref = CalculationModeMultiplyPref(prefs);
    _speedPref = SpeedMultiplyPref(prefs);
    _startDigitPref = StartDigitPref(prefs);
    _endDigitPref = EndDigitPref(prefs);
    _numOfProblemsPref = NumOfProblemsMultiplyPref(prefs);
  }

  // returns _instance when it is called.
  //, which is already initialized in pivate constructor.
  factory SettingsMultiplyManager() => _instance;

  // fields methods.
  // calculation mode.
  T getCurrentEnum<T>() {
    switch (T) {
      case CalCulationMultiplyMode:
        return _calculationModePref.getValue() as T;
      case SpeedMultiply:
        return _speedPref.getValue() as T;
      case StartDigit:
        return _startDigitPref.getValue() as T;
      case EndDigit:
        return _endDigitPref.getValue() as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.getValue() as T;
      default:
        throw Error();
    }
  }

  T valueToEnum<V, T>(V value) {
    switch (T) {
      case CalCulationMultiplyMode:
        return _calculationModePref.valueToEnum(value as bool) as T;
      case SpeedMultiply:
        return _speedPref.valueToEnum(value as Duration) as T;
      case StartDigit:
        return _startDigitPref.valueToEnum(value as int) as T;
      case EndDigit:
        return _endDigitPref.valueToEnum(value as int) as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.valueToEnum(value as int) as T;
      default:
        throw Error();
    }
  }

  V enumToValue<T, V>(T enumValue) {
    switch (T) {
      case CalCulationMultiplyMode:
        return _calculationModePref
            .enumToValue(enumValue as CalCulationMultiplyMode) as V;
      case SpeedMultiply:
        return _speedPref.enumToValue(enumValue as SpeedMultiply) as V;
      case StartDigit:
        return _startDigitPref.enumToValue(enumValue as StartDigit) as V;
      case EndDigit:
        return _endDigitPref.enumToValue(enumValue as EndDigit) as V;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref
            .enumToValue(enumValue as NumOfMultiplyProblems) as V;
      default:
        throw Error();
    }
  }

  V getCurrentValue<T, V>() {
    switch (T) {
      case SpeedMultiply:
        return _speedPref.enumToValue(getCurrentEnum<SpeedMultiply>()) as V;
      case StartDigit:
        return _startDigitPref.enumToValue(getCurrentEnum<StartDigit>()) as V;
      case EndDigit:
        return _endDigitPref.enumToValue(getCurrentEnum<EndDigit>()) as V;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref
            .enumToValue(getCurrentEnum<NumOfMultiplyProblems>()) as V;
      default:
        throw Error();
    }
  }

  T itemStrToEnum<T>(String str) {
    switch (T) {
      case SpeedMultiply:
        return _speedPref.itemStrToValue(str) as T;
      case StartDigit:
        return _startDigitPref.itemStrToValue(str) as T;
      case EndDigit:
        return _endDigitPref.itemStrToValue(str) as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.itemStrToValue(str) as T;
      default:
        throw Error();
    }
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case CalCulationMultiplyMode:
        _calculationModePref.saveSetting(_prefs, value);
        break;
      case SpeedMultiply:
        _speedPref.saveSetting(_prefs, value);
        break;
      case StartDigit:
        _startDigitPref.saveSetting(_prefs, value);
      case EndDigit:
        _endDigitPref.saveSetting(_prefs, value);
        break;
      case NumOfMultiplyProblems:
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
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.getItemsListofEnum();
      case SpeedMultiply:
        return _speedPref.getItemsListofEnum();
      case StartDigit:
        return _startDigitPref.getItemsListofEnum();
      case EndDigit:
        return _endDigitPref.getItemsListofEnum();
      default:
        throw Error();
    }
  }

  String getItemStr<T>(String enumName) {
    switch (T) {
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.enumNameToItemString(enumName);
      case SpeedMultiply:
        return _speedPref.enumNameToItemString(enumName);
      case StartDigit:
        return _startDigitPref.enumNameToItemString(enumName);
      case EndDigit:
        return _endDigitPref.enumNameToItemString(enumName);
      default:
        throw Error();
    }
  }
}
