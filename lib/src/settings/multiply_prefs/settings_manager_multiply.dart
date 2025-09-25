// singleton
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/countdown_mode.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/separator_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMultiplyManager {
  // member
  late SharedPreferencesWithCache _prefs;

  late BurningModeMultiplyPref _burningModePref;
  late CalculationModeMultiplyPref _calculationModePref;
  late CountDownModeMultiplyPref _countDownModePref;
  late SpeedMultiplyPref _speedPref;
  late BigDigitPref _bigDigitPref;
  late SmallDigitPref _smallDigitPref;
  late NumOfProblemsMultiplyPref _numOfProblemsPref;
  late SeparatorModeMultiplyPref _separatorModePref;

  // constructor
  static final SettingsMultiplyManager _instance =
      SettingsMultiplyManager._constructor();
  SettingsMultiplyManager._constructor();

  Future<void> initSettings() async {
    _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions());
    refreshPrefValues(_prefs);
  }

  void refreshPrefValues(SharedPreferencesWithCache prefs) {
    _burningModePref = BurningModeMultiplyPref(prefs);
    _calculationModePref = CalculationModeMultiplyPref(prefs);
    _countDownModePref = CountDownModeMultiplyPref(prefs);
    _speedPref = SpeedMultiplyPref(prefs);
    _bigDigitPref = BigDigitPref(prefs);
    _smallDigitPref = SmallDigitPref(prefs);
    _numOfProblemsPref = NumOfProblemsMultiplyPref(prefs);
    _separatorModePref =
        SeparatorModeMultiplyPref.separatorModeMultiplyPref(prefs);
  }

  // returns _instance when it is called.
  //, which is already initialized in private constructor.
  factory SettingsMultiplyManager() => _instance;

  // fields methods.
  // calculation mode.
  T getCurrentEnum<T>() {
    switch (T) {
      case const (BurningModeMultiply):
        return _burningModePref.getValue() as T;
      case const (CalCulationMultiplyMode):
        return _calculationModePref.getValue() as T;
      case const (CountDownMultiplyMode):
        return _countDownModePref.getValue() as T;
      case const (SpeedMultiply):
        return _speedPref.getValue() as T;
      case const (BigDigit):
        return _bigDigitPref.getValue() as T;
      case const (SmallDigit):
        return _smallDigitPref.getValue() as T;
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref.getValue() as T;
      case const (SeparatorMultiplyMode):
        return _separatorModePref.getValue() as T;
      default:
        throw Error();
    }
  }

  T valueToEnum<V, T>(V value) {
    switch (T) {
      case const (BurningModeMultiply):
        return _burningModePref.valueToEnum(value as bool) as T;
      case const (CalCulationMultiplyMode):
        return _calculationModePref.valueToEnum(value as bool) as T;
      case const (CountDownMultiplyMode):
        return _countDownModePref.valueToEnum(value as bool) as T;
      case const (SpeedMultiply):
        return _speedPref.valueToEnum(value as Duration) as T;
      case const (BigDigit):
        return _bigDigitPref.valueToEnum(value as int) as T;
      case const (SmallDigit):
        return _smallDigitPref.valueToEnum(value as int) as T;
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref.valueToEnum(value as int) as T;
      case const (SeparatorMultiplyMode):
        return _separatorModePref.valueToEnum(value as bool) as T;
      default:
        throw Error();
    }
  }

  V enumToValue<T, V>(T enumValue) {
    switch (T) {
      case const (CalCulationMultiplyMode):
        return _calculationModePref
            .enumToValue(enumValue as CalCulationMultiplyMode) as V;
      case const (CountDownMultiplyMode):
        return _countDownModePref
            .enumToValue(enumValue as CountDownMultiplyMode) as V;
      case const (SpeedMultiply):
        return _speedPref.enumToValue(enumValue as SpeedMultiply) as V;
      case const (BigDigit):
        return _bigDigitPref.enumToValue(enumValue as BigDigit) as V;
      case const (SmallDigit):
        return _smallDigitPref.enumToValue(enumValue as SmallDigit) as V;
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref
            .enumToValue(enumValue as NumOfMultiplyProblems) as V;
      case const (SeparatorMultiplyMode):
        return _separatorModePref
            .enumToValue(enumValue as SeparatorMultiplyMode) as V;
      default:
        throw Error();
    }
  }

  V getCurrentValue<T, V>() {
    switch (T) {
      case const (CountDownMultiplyMode):
        return _countDownModePref
            .enumToValue(getCurrentEnum<CountDownMultiplyMode>()) as V;
      case const (SpeedMultiply):
        return _speedPref.enumToValue(getCurrentEnum<SpeedMultiply>()) as V;
      case const (BigDigit):
        return _bigDigitPref.enumToValue(getCurrentEnum<BigDigit>()) as V;
      case const (SmallDigit):
        return _smallDigitPref.enumToValue(getCurrentEnum<SmallDigit>()) as V;
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref
            .enumToValue(getCurrentEnum<NumOfMultiplyProblems>()) as V;
      case const (SeparatorMultiplyMode):
        return _separatorModePref
            .enumToValue(getCurrentEnum<SeparatorMultiplyMode>()) as V;
      default:
        throw Error();
    }
  }

  T itemStrToEnum<T>(String str) {
    switch (T) {
      case const (SpeedMultiply):
        return _speedPref.itemStrToValue(str) as T;
      case const (BigDigit):
        return _bigDigitPref.itemStrToValue(str) as T;
      case const (SmallDigit):
        return _smallDigitPref.itemStrToValue(str) as T;
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref.itemStrToValue(str) as T;
      default:
        throw Error();
    }
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case const (BurningModeMultiply):
        _burningModePref.saveSetting(_prefs, value);
        break;
      case const (CalCulationMultiplyMode):
        _calculationModePref.saveSetting(_prefs, value);
        break;
      case const (CountDownMultiplyMode):
        _countDownModePref.saveSetting(_prefs, value);
        break;
      case const (SpeedMultiply):
        _speedPref.saveSetting(_prefs, value);
        break;
      case const (BigDigit):
        _bigDigitPref.saveSetting(_prefs, value);
        break;
      case const (SmallDigit):
        _smallDigitPref.saveSetting(_prefs, value);
        break;
      case const (NumOfMultiplyProblems):
        _numOfProblemsPref.saveSetting(_prefs, value);
        break;
      case const (SeparatorMultiplyMode):
        _separatorModePref.saveSetting(_prefs, value);
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
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref.getItemsListOfEnum();
      case const (SpeedMultiply):
        return _speedPref.getItemsListOfEnum();
      case const (BigDigit):
        return _bigDigitPref.getItemsListOfEnum();
      case const (SmallDigit):
        return _smallDigitPref.getItemsListOfEnum();
      default:
        throw Error();
    }
  }

  String getItemStr<T>(String enumName) {
    switch (T) {
      case const (NumOfMultiplyProblems):
        return _numOfProblemsPref.enumNameToItemString(enumName);
      case const (SpeedMultiply):
        return _speedPref.enumNameToItemString(enumName);
      case const (BigDigit):
        return _bigDigitPref.enumNameToItemString(enumName);
      case const (SmallDigit):
        return _smallDigitPref.enumNameToItemString(enumName);
      default:
        throw Error();
    }
  }
}
