// T : enum type.
// V : return value type.
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceInterface<T, V> {
  final String _saveKey = '';
  final int _defaultIndex = 0;

  late int _currentIndex;
  late T _currentValue;

  PreferenceInterface(SharedPreferencesWithCache prefs) {
    var index = prefs.getInt(_saveKey) ?? _defaultIndex;
    setIndex(index);
  }

  // when implemented, it should be synchronized for each other.
  void setValue(T enumValue);
  void setIndex(int index);

  T getValue() => _currentValue;
  int getIndex() => _currentIndex;

  // it is vice versa of enumToValue.
  // it may uses enumToValue() to check its type.
  T valueToEnum(V value);
  // it extracts useful information from enum name.
  // generally for item
  // like n_10, It will extract 10.
  // like Slow_07, It will extract duration 7000ms.
  V enumToValue(T enumType);

  void saveSetting(SharedPreferencesWithCache prefs, dynamic value);
}
