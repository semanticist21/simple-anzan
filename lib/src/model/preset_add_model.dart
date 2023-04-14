import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/calculation_mode_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/shuffle.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';

class PresetAddModel {
  PresetAddModel({
    required this.id,
    required this.colorCode,
    required this.name,
    required this.textColorCode,
    required this.onlyPlusesIndex,
    required this.shuffleIndex,
    required this.speedIndex,
    required this.digitIndex,
    required this.numOfProblemIndex,
    required this.notifyIndex,
  });

  final String id;
  final String name;
  final String colorCode;
  final String textColorCode;

  final int onlyPlusesIndex;
  final int shuffleIndex;
  final int speedIndex;
  final int digitIndex;
  final int numOfProblemIndex;
  final int notifyIndex;

  Map<String, Object> toValues() {
    return {
      'id': id,
      'name': name,
      'colorCode': colorCode,
      'textColorCode': textColorCode,
      'onlyPlusesIndex': onlyPlusesIndex,
      'shuffleIndex': shuffleIndex,
      'speedIndex': speedIndex,
      'digitIndex': digitIndex,
      'numOfProblemIndex': numOfProblemIndex,
      'notifyIndex': notifyIndex,
    };
  }

  static PresetAddModel fromValues(Map<String, Object?> map) {
    return PresetAddModel(
      id: map['id']!.toString(),
      name: map['name'].toString(),
      colorCode: map['colorCode'].toString(),
      textColorCode: map['textColorCode'].toString(),
      onlyPlusesIndex: map['onlyPlusesIndex']! as int,
      shuffleIndex: map['shuffleIndex']! as int,
      speedIndex: map['speedIndex']! as int,
      digitIndex: map['digitIndex'] as int,
      numOfProblemIndex: map['numOfProblemIndex'] as int,
      notifyIndex: map['notifyIndex'] as int,
    );
  }

  static void saveItem(PresetAddModel item, SettingsManager manager) {
    var mode = CalculationMode.values[item.onlyPlusesIndex];
    var shuffle = ShuffleMode.values[item.shuffleIndex];
    var speed = Speed.values[item.speedIndex];
    var digit = Digit.values[item.digitIndex];
    var nums = NumOfProblems.values[item.numOfProblemIndex];
    var notify = CountDownMode.values[item.notifyIndex];

    manager.saveSetting(mode);
    manager.saveSetting(shuffle);
    manager.saveSetting(speed);
    manager.saveSetting(digit);
    manager.saveSetting(nums);
    manager.saveSetting(notify);
  }
}
