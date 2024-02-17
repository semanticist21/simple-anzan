import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/countdown_mode.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';

class PresetMultiplyModel {
  // notify => countdown mode
  PresetMultiplyModel(
      {required this.id,
      required this.name,
      required this.colorCode,
      required this.textColorCode,
      required this.calculationMode,
      required this.speedIndex,
      required this.smallDigitIndex,
      required this.bigDigitIndex,
      required this.notifyIndex});

  final String id;
  final String name;
  final String colorCode;
  final String textColorCode;

  final int calculationMode;
  final int speedIndex;
  final int smallDigitIndex;
  final int bigDigitIndex;
  final int notifyIndex;

  Map<String, Object> toValues() {
    return {
      'id': id,
      'name': name,
      'colorCode': colorCode,
      'textColorCode': textColorCode,
      'calculationMode': calculationMode,
      'speedIndex': speedIndex,
      'smallDigitIndex': smallDigitIndex,
      'bigDigitIndex': bigDigitIndex,
      'notifyIndex': notifyIndex,
    };
  }

  static PresetMultiplyModel fromValues(Map<String, Object?> map) {
    return PresetMultiplyModel(
      id: map['id']!.toString(),
      name: map['name'].toString(),
      colorCode: map['colorCode'].toString(),
      textColorCode: map['textColorCode'].toString(),
      calculationMode: map['calculationMode'] as int,
      speedIndex: map['speedIndex'] as int,
      smallDigitIndex: map['smallDigitIndex'] as int,
      bigDigitIndex: map['bigDigitIndex'] as int,
      notifyIndex: map['notifyIndex'] as int,
    );
  }

  static void saveItem(
      PresetMultiplyModel item, SettingsMultiplyManager manager) {
    var mode = CalCulationMultiplyMode.values[item.calculationMode];
    var speed = SpeedMultiply.values[item.speedIndex];
    var small = SmallDigit.values[item.smallDigitIndex];
    var big = BigDigit.values[item.bigDigitIndex];
    var notify = CountDownMultiplyMode.values[item.notifyIndex];

    manager.saveSetting(mode);
    manager.saveSetting(speed);
    manager.saveSetting(small);
    manager.saveSetting(big);
    manager.saveSetting(notify);
  }
}
