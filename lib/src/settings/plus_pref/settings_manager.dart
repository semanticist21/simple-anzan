// singleton
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/burning_mode_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/calculation_mode_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/seperator.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/shuffle.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  // member
  late SharedPreferencesWithCache _prefs;

  late BurningModePref _burningModePref;
  late CalculationModePref _calculationModePref;
  late ShuffleModePref _shuffleModePref;
  late CountDownModePref _countDownModePref;
  late SpeedPref _speedPref;
  late DigitPref _digitPref;
  late NumOfProblemsPref _numOfProblemsPref;
  late SeperatorModePref _seperatorModePref;

  // constructor
  static final SettingsManager _instance = SettingsManager._constructor();
  SettingsManager._constructor();

  Future<void> initSettings() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    refreshPrefValues(_prefs);
  }

  void refreshPrefValues(SharedPreferencesWithCache prefs) {
    _burningModePref = BurningModePref(prefs);
    _calculationModePref = CalculationModePref(prefs);
    _shuffleModePref = ShuffleModePref(prefs);
    _countDownModePref = CountDownModePref(prefs);
    _speedPref = SpeedPref(prefs);
    _digitPref = DigitPref(prefs);
    _numOfProblemsPref = NumOfProblemsPref(prefs);
    _seperatorModePref = SeperatorModePref(prefs);
  }

  // returns _instance when it is called.
  //, which is already initialized in pivate constructor.
  factory SettingsManager() => _instance;

  // fields methods.
  // calculation mode.
  T getCurrentEnum<T>() {
    switch (T) {
      case const (BurningMode):
        return _burningModePref.getValue() as T;
      case const (CalculationMode):
        return _calculationModePref.getValue() as T;
      case const (ShuffleMode):
        return _shuffleModePref.getValue() as T;
      case const (CountDownMode):
        return _countDownModePref.getValue() as T;
      case const (Speed):
        return _speedPref.getValue() as T;
      case const (Digit):
        return _digitPref.getValue() as T;
      case const (NumOfProblems):
        return _numOfProblemsPref.getValue() as T;
      case const (SeperatorMode):
        return _seperatorModePref.getValue() as T;
      default:
        throw Error();
    }
  }

  T valueToEnum<V, T>(V value) {
    switch (T) {
      case const (BurningMode):
        return _burningModePref.valueToEnum(value as bool) as T;
      case const (CalculationMode):
        return _calculationModePref.valueToEnum(value as bool) as T;
      case const (ShuffleMode):
        return _shuffleModePref.valueToEnum(value as bool) as T;
      case const (CountDownMode):
        return _countDownModePref.valueToEnum(value as bool) as T;
      case const (Speed):
        return _speedPref.valueToEnum(value as Duration) as T;
      case const (Digit):
        return _digitPref.valueToEnum(value as int) as T;
      case const (NumOfProblems):
        return _numOfProblemsPref.valueToEnum(value as int) as T;
      case const (SeperatorMode):
        return _seperatorModePref.valueToEnum(value as bool) as T;
      default:
        throw Error();
    }
  }

  V enumToValue<T, V>(T enumValue) {
    switch (T) {
      case const (CalculationMode):
        return _calculationModePref.enumToValue(enumValue as CalculationMode)
            as V;
      case const (ShuffleMode):
        return _shuffleModePref.enumToValue(enumValue as ShuffleMode) as V;
      case const (CountDownMode):
        return _countDownModePref.enumToValue(enumValue as CountDownMode) as V;
      case const (Speed):
        return _speedPref.enumToValue(enumValue as Speed) as V;
      case const (Digit):
        return _digitPref.enumToValue(enumValue as Digit) as V;
      case const (NumOfProblems):
        return _numOfProblemsPref.enumToValue(enumValue as NumOfProblems) as V;
      case const (SeperatorMode):
        return _seperatorModePref.enumToValue(enumValue as SeperatorMode) as V;
      default:
        throw Error();
    }
  }

  V getCurrentValue<T, V>() {
    switch (T) {
      case const (ShuffleMode):
        return _shuffleModePref.enumToValue(getCurrentEnum<ShuffleMode>()) as V;
      case const (CountDownMode):
        return _countDownModePref.enumToValue(getCurrentEnum<CountDownMode>())
            as V;
      case const (Speed):
        return _speedPref.enumToValue(getCurrentEnum<Speed>()) as V;
      case const (Digit):
        return _digitPref.enumToValue(getCurrentEnum<Digit>()) as V;
      case const (NumOfProblems):
        return _numOfProblemsPref.enumToValue(getCurrentEnum<NumOfProblems>())
            as V;
      case const (SeperatorMode):
        return _seperatorModePref.enumToValue(getCurrentEnum<SeperatorMode>())
            as V;
      default:
        throw Error();
    }
  }

  T itemStrToEnum<T>(String str) {
    switch (T) {
      case const (Speed):
        return _speedPref.itemStrToValue(str) as T;
      case const (Digit):
        return _digitPref.itemStrToValue(str) as T;
      case const (NumOfProblems):
        return _numOfProblemsPref.itemStrToValue(str) as T;
      default:
        throw Error();
    }
  }

  // save methods
  void saveSetting(dynamic value) {
    switch (value.runtimeType) {
      case const (BurningMode):
        _burningModePref.saveSetting(_prefs, value);
        break;
      case const (CalculationMode):
        _calculationModePref.saveSetting(_prefs, value);
        break;
      case const (ShuffleMode):
        _shuffleModePref.saveSetting(_prefs, value);
        break;
      case const (CountDownMode):
        _countDownModePref.saveSetting(_prefs, value);
        break;
      case const (Speed):
        _speedPref.saveSetting(_prefs, value);
        break;
      case const (Digit):
        _digitPref.saveSetting(_prefs, value);
        break;
      case const (NumOfProblems):
        _numOfProblemsPref.saveSetting(_prefs, value);
        break;
      case const (SeperatorMode):
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
      case const (NumOfProblems):
        return _numOfProblemsPref.getItemsListofEnum();
      case const (Speed):
        return _speedPref.getItemsListofEnum();
      case const (Digit):
        return _digitPref.getItemsListofEnum();
      default:
        throw Error();
    }
  }

  String getItemStr<T>(String enumName) {
    switch (T) {
      case const (NumOfProblems):
        return _numOfProblemsPref.enumNameToItemString(enumName);
      case const (Speed):
        return _speedPref.enumNameToItemString(enumName);
      case const (Digit):
        return _digitPref.enumNameToItemString(enumName);
      default:
        throw Error();
    }
  }
}
