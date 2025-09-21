// singleton
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/countdown_mode.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/seperator_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMultiplyManager {
  // member
  late SharedPreferences _prefs;

  late BurningModeMultiplyPref _burningModePref;
  late CalculationModeMultiplyPref _calculationModePref;
  late CountDownModeMultiplyPref _countDownModePref;
  late SpeedMultiplyPref _speedPref;
  late BigDigitPref _bigDigitPref;
  late SmallDigitPref _smallDigitPref;
  late NumOfProblemsMultiplyPref _numOfProblemsPref;
  late SeperatorModeMultiplyPref _seperatorModePref;

  // constructor
  static final SettingsMultiplyManager _instance =
      SettingsMultiplyManager._constructor();
  SettingsMultiplyManager._constructor();

  Future<void> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    refreshPrefValues(_prefs);
  }

  void refreshPrefValues(SharedPreferences prefs) {
    _burningModePref = BurningModeMultiplyPref(prefs);
    _calculationModePref = CalculationModeMultiplyPref(prefs);
    _countDownModePref = CountDownModeMultiplyPref(prefs);
    _speedPref = SpeedMultiplyPref(prefs);
    _bigDigitPref = BigDigitPref(prefs);
    _smallDigitPref = SmallDigitPref(prefs);
    _numOfProblemsPref = NumOfProblemsMultiplyPref(prefs);
    _seperatorModePref = SeperatorModeMultiplyPref(prefs);
  }

  // returns _instance when it is called.
  //, which is already initialized in pivate constructor.
  factory SettingsMultiplyManager() => _instance;

  // fields methods.
  // calculation mode.
  T getCurrentEnum<T>() {
    switch (T) {
      case BurningModeMultiply:
        return _burningModePref.getValue() as T;
      case CalCulationMultiplyMode:
        return _calculationModePref.getValue() as T;
      case CountDownMultiplyMode:
        return _countDownModePref.getValue() as T;
      case SpeedMultiply:
        return _speedPref.getValue() as T;
      case BigDigit:
        return _bigDigitPref.getValue() as T;
      case SmallDigit:
        return _smallDigitPref.getValue() as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.getValue() as T;
      case SeperatorMultiplyMode:
        return _seperatorModePref.getValue() as T;
      default:
        throw Error();
    }
  }

  T valueToEnum<V, T>(V value) {
    switch (T) {
      case BurningModeMultiply:
        return _burningModePref.valueToEnum(value as bool) as T;
      case CalCulationMultiplyMode:
        return _calculationModePref.valueToEnum(value as bool) as T;
      case CountDownMultiplyMode:
        return _countDownModePref.valueToEnum(value as bool) as T;
      case SpeedMultiply:
        return _speedPref.valueToEnum(value as Duration) as T;
      case BigDigit:
        return _bigDigitPref.valueToEnum(value as int) as T;
      case SmallDigit:
        return _smallDigitPref.valueToEnum(value as int) as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.valueToEnum(value as int) as T;
      case SeperatorMultiplyMode:
        return _seperatorModePref.valueToEnum(value as bool) as T;
      default:
        throw Error();
    }
  }

  V enumToValue<T, V>(T enumValue) {
    switch (T) {
      case CalCulationMultiplyMode:
        return _calculationModePref
            .enumToValue(enumValue as CalCulationMultiplyMode) as V;
      case CountDownMultiplyMode:
        return _countDownModePref
            .enumToValue(enumValue as CountDownMultiplyMode) as V;
      case SpeedMultiply:
        return _speedPref.enumToValue(enumValue as SpeedMultiply) as V;
      case BigDigit:
        return _bigDigitPref.enumToValue(enumValue as BigDigit) as V;
      case SmallDigit:
        return _smallDigitPref.enumToValue(enumValue as SmallDigit) as V;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref
            .enumToValue(enumValue as NumOfMultiplyProblems) as V;
      case SeperatorMultiplyMode:
        return _seperatorModePref
            .enumToValue(enumValue as SeperatorMultiplyMode) as V;
      default:
        throw Error();
    }
  }

  V getCurrentValue<T, V>() {
    switch (T) {
      case CountDownMultiplyMode:
        return _countDownModePref
            .enumToValue(getCurrentEnum<CountDownMultiplyMode>()) as V;
      case SpeedMultiply:
        return _speedPref.enumToValue(getCurrentEnum<SpeedMultiply>()) as V;
      case BigDigit:
        return _bigDigitPref.enumToValue(getCurrentEnum<BigDigit>()) as V;
      case SmallDigit:
        return _smallDigitPref.enumToValue(getCurrentEnum<SmallDigit>()) as V;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref
            .enumToValue(getCurrentEnum<NumOfMultiplyProblems>()) as V;
      case SeperatorMultiplyMode:
        return _seperatorModePref
            .enumToValue(getCurrentEnum<SeperatorMultiplyMode>()) as V;
      default:
        throw Error();
    }
  }

  T itemStrToEnum<T>(String str) {
    switch (T) {
      case SpeedMultiply:
        return _speedPref.itemStrToValue(str) as T;
      case BigDigit:
        return _bigDigitPref.itemStrToValue(str) as T;
      case SmallDigit:
        return _smallDigitPref.itemStrToValue(str) as T;
      case NumOfMultiplyProblems:
        return _numOfProblemsPref.itemStrToValue(str) as T;
      default:
        throw Error();
    }
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case BurningModeMultiply:
        _burningModePref.saveSetting(_prefs, value);
        break;
      case CalCulationMultiplyMode:
        _calculationModePref.saveSetting(_prefs, value);
        break;
      case CountDownMultiplyMode:
        _countDownModePref.saveSetting(_prefs, value);
        break;
      case SpeedMultiply:
        _speedPref.saveSetting(_prefs, value);
        break;
      case BigDigit:
        _bigDigitPref.saveSetting(_prefs, value);
        break;
      case SmallDigit:
        _smallDigitPref.saveSetting(_prefs, value);
        break;
      case NumOfMultiplyProblems:
        _numOfProblemsPref.saveSetting(_prefs, value);
        break;
      case SeperatorMultiplyMode:
        _seperatorModePref.saveSetting(_prefs, value);
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
      case BigDigit:
        return _bigDigitPref.getItemsListofEnum();
      case SmallDigit:
        return _smallDigitPref.getItemsListofEnum();
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
      case BigDigit:
        return _bigDigitPref.enumNameToItemString(enumName);
      case SmallDigit:
        return _smallDigitPref.enumNameToItemString(enumName);
      default:
        throw Error();
    }
  }
}
