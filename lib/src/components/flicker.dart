import 'package:abacus_simple_anzan/src/settings/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/prefs/speed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';

import '../words/const.dart';
import '../functions/functions.dart';
import '../settings/prefs/calculation_mode_pref.dart';
import '../settings/prefs/digit_pref.dart';
import '../settings/settings_manager.dart';

class Flicker extends StatefulWidget {
  const Flicker({super.key});

  @override
  State<Flicker> createState() => _FlickerState();
}

class _FlickerState extends State<Flicker> {
  late StateProvider _stateProvider;
  final SettingsManager manager = SettingsManager();

  String _number = '';
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.addListener(_callbackOnButtonClick);

    return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          _number,
          style: _getMainNumberTextStyle(),
        ));
  }

  // start iteration.
  Future<void> _callbackOnButtonClick() async {
    switch (_stateProvider.state) {
      case ButtonState.iterationNotStarted:
        showAnswer();
        break;
      case ButtonState.iterationStarted:
        await _initiateIteration(manager);
        break;
      case ButtonState.iterationCompleted:
        break;
      default:
        return;
    }
  }

  Future<void> _initiateIteration(SettingsManager manager) async {
    _answer = '';

    switch (manager.getCurrentEnum<CalculationMode>()) {
      case CalculationMode.onlyPlus:
        _runAdd(manager);
        break;
      case CalculationMode.plusMinus:
        _runAddMinus(manager);
        break;
    }
  }

  Future<void> _runAdd(SettingsManager manager) async =>
      await doProcess(getPlusNums, manager);

  Future<void> _runAddMinus(SettingsManager manager) async =>
      await doProcess(getPlusMinusNums, manager);

  Future<void> doProcess(
      Function(int, int) func, SettingsManager manager) async {
    var nums = func(manager.getCurrentValue<Digit, int>(),
        manager.getCurrentValue<NumOfProblems, int>());
    var len = nums.length;

    var questions = nums.sublist(0, len - 1);
    _answer = nums.last.toString();

    await iterNums(manager, questions);
    _stateProvider.changeState(desiredState: ButtonState.iterationCompleted);
  }

  Future<void> iterNums(SettingsManager manager, List<int> questions) async {
    var duration = manager.getCurrentValue<Speed, Duration>();
    var len = questions.length;

    for (int i = 0; i < len; i++) {
      setState(() {
        _number = questions[i].toString();
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

  void showAnswer() {
    setState(() {
      _number = _answer;
    });
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    super.dispose();
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    return Theme.of(context).textTheme.titleLarge!;
  }
}
