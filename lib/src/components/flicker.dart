import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_anzan/src/provider/state_provider.dart';

import '../const/const.dart';
import '../functions/functions.dart';
import '../settings/settings.dart';
import '../settings/settings_manager.dart';

class Flicker extends StatefulWidget {
  const Flicker({super.key});

  @override
  State<Flicker> createState() => _FlickerState();
}

class _FlickerState extends State<Flicker> {
  late StateProvider _stateProvider;
  final SettingsManager manager = SettingsManager();
  bool isIterationGoing = false;

  String _number = '';
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.addListener(_callbackOnButtonClick);

    return Text(
      _number,
      style: _getMainNumberTextStyle(),
    );
  }

  // start iteration.
  void _callbackOnButtonClick() async {
    switch (_stateProvider.state) {
      case ButtonState.iterationNotStarted:
        showAnswer();
        break;
      case ButtonState.iterationStarted:
        _initiateIteration(manager);
        break;
      default:
        return;
    }
  }

  Future<void> _initiateIteration(SettingsManager manager) async {
    switch (manager.mode()) {
      case CalculationMode.onlyPlus:
        _runAdd(manager);
        break;
      case CalculationMode.plusMinus:
        _runAddMinus(manager);
        break;
      case CalculationMode.multiply:
        _runMultiply(manager);
        break;
      case CalculationMode.divide:
        _runDivide(manager);
        break;
    }
  }

  Future<void> _runAdd(SettingsManager manager) async =>
      await doProcess(getAddNums, manager);

  Future<void> _runAddMinus(SettingsManager manager) async =>
      await doProcess(getAddMinusNums, manager);

  Future<void> doProcess(
      Function(int, int) func, SettingsManager manager) async {
    var nums = func(manager.digit(), manager.numOfProblemsInt());
    var len = nums.length;

    var questions = nums.sublist(0, len - 1);
    _answer = nums.last.toString();

    await iterNums(manager, questions);
    _stateProvider.changeState();
  }

  void _runMultiply(SettingsManager manager) {}
  void _runDivide(SettingsManager manager) {}

  Future<void> iterNums(SettingsManager manager, List<int> questions) async {
    var duration = manager.speedDuration();
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
}

// styles.
TextStyle _getMainNumberTextStyle() {
  return const TextStyle(
    fontSize: 150,
    fontWeight: FontWeight.w900,
    fontFamily: defaultFontFamily,
    letterSpacing: 3,
    color: Color.fromARGB(255, 113, 150, 67),
  );
}
