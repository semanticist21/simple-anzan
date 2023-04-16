import 'package:abacus_simple_anzan/src/settings/option/option_manager.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/shuffle.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';
import 'package:universal_io/io.dart';

import '../const/const.dart';
import '../functions/functions.dart';
import '../settings/plus_pref/prefs/calculation_mode_pref.dart';
import '../settings/plus_pref/prefs/digit_pref.dart';
import '../settings/plus_pref/settings_manager.dart';

class Flicker extends StatefulWidget {
  const Flicker({super.key});

  @override
  State<Flicker> createState() => _FlickerState();
}

class _FlickerState extends State<Flicker> {
  late StateProvider _stateProvider;
  final _manager = SettingsManager();
  final _optManager = OptionManager();

  var formattter = NumberFormat('#,##0');

  var _number = '';
  var _answer = '';

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.addListener(_callbackOnButtonClick);

    return _number.length > 6
        ? FittedBox(
            fit: BoxFit.contain,
            child: Padding(
                padding: Platform.isWindows
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  _number,
                  style: _getMainNumberTextStyle(),
                  textAlign: TextAlign.left,
                )))
        : Padding(
            padding: Platform.isWindows
                ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              _number,
              style: _getMainNumberTextStyle(),
              textAlign: TextAlign.left,
            ));
  }

  // start iteration.
  Future<void> _callbackOnButtonClick() async {
    switch (_stateProvider.state) {
      case ButtonState.iterationNotStarted:
        _showAnswer();
        break;
      case ButtonState.iterationStarted:
        await _initiateIteration(_manager);
        break;
      case ButtonState.iterationCompleted:
        break;
      default:
        return;
    }
  }

  Future<void> _initiateIteration(SettingsManager manager) async {
    if (_isInit) {
      await _optManager.soundOption.initPlaySound();
      _isInit = false;
    }
    _answer = '';

    switch (manager.getCurrentEnum<CalculationMode>()) {
      case CalculationMode.onlyPlus:
        var isShuffle = manager.getCurrentValue<ShuffleMode, bool>();
        if (isShuffle) {
          _runShuffleAdd(manager);
        } else {
          _runAdd(manager);
        }

        break;
      case CalculationMode.plusMinus:
        var isShuffle = manager.getCurrentValue<ShuffleMode, bool>();
        if (isShuffle) {
          _runShuffleAddMinus(manager);
        } else {
          _runAddMinus(manager);
        }
        break;
    }
  }

  Future<void> _runAdd(SettingsManager manager) async =>
      await doProcess(getPlusNums, manager);

  Future<void> _runAddMinus(SettingsManager manager) async =>
      await doProcess(getPlusMinusNums, manager);

  Future<void> _runShuffleAdd(SettingsManager manager) async =>
      await doProcess(getPlusShuffleNums, manager);

  Future<void> _runShuffleAddMinus(SettingsManager manager) async =>
      await doProcess(getPlusMinusShuffleNums, manager);

  Future<void> doProcess(
      List<int> Function(int, int) func, SettingsManager manager) async {
    var nums = func(manager.getCurrentValue<Digit, int>(),
        manager.getCurrentValue<NumOfProblems, int>());

    _stateProvider.nums.clear();
    for (var element in nums) {
      _stateProvider.nums.add(element);
    }

    var len = nums.length;

    var questions = nums.sublist(0, len - 1);
    _answer = nums.last.toString();

    await iterNums(manager, questions);
    _stateProvider.changeState(desiredState: ButtonState.iterationCompleted);
  }

  Future<void> iterNums(SettingsManager manager, List<int> questions) async {
    var duration = manager.getCurrentValue<Speed, Duration>();
    var len = questions.length;

    setState(() {
      _number = '';
    });

    // wait before start
    var isNotify = manager.getCurrentValue<CountDownMode, bool>();
    if (isNotify) {
      await _doCountDown();
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    for (int i = 0; i < len; i++) {
      var str = '';

      if (questions[i] > 0) {
        var parsedStr = questions[i].toString();
        str = '\t$parsedStr\t';
      } else {
        str = '${questions[i].toString()}\t';
      }

      _optManager.soundOption.playSound();
      setState(() {
        _number = str;
      });
      await Future.delayed(duration);

      setState(() {
        _number = empty;
      });

      // if it is the last iteration, then don't await.
      if (i == len - 1) {
        break;
      }

      await Future.delayed(duration);
    }
  }

  void _showAnswer() {
    setState(() {
      _number = '\t${formattter.format(int.parse(_answer))}\t';
    });
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    super.dispose();
    _optManager.soundOption.stopAudio();
    _optManager.soundOption.stopCountAudio();
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    return Platform.isWindows
        ? Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: (MediaQuery.of(context).size.width * 0.7 +
                    MediaQuery.of(context).size.height * 1) *
                0.09)
        : Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: (MediaQuery.of(context).size.width * 0.7 +
                    MediaQuery.of(context).size.height * 1) *
                0.07);
  }

  Future<void> _doCountDown() async {
    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    await _optManager.soundOption.playCountSound();

    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    await _optManager.soundOption.playCountSound();

    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    await _optManager.soundOption.resetSource();
  }
}
