import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import '../functions/tuple.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../functions/functions.dart';

class FlickerMultiply extends StatefulWidget {
  const FlickerMultiply({super.key});

  @override
  State<FlickerMultiply> createState() => _FlickerMultiplyState();
}

class _FlickerMultiplyState extends State<FlickerMultiply> {
  late StateMultiplyProvider _stateProvider;
  final SettingsMultiplyManager _manager = SettingsMultiplyManager();

  String _number = '';

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.addListener(_callbackOnButtonClick);

    return _number.length > 4
        ? FittedBox(
            fit: BoxFit.contain,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  _number,
                  style: _getMainNumberTextStyle(),
                  textAlign: TextAlign.left,
                )))
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              _number,
              style: _getMainNumberTextStyle(),
              textAlign: TextAlign.left,
            ));
  }

  // start iteration.
  Future<void> _callbackOnButtonClick() async {
    switch (_stateProvider.state) {
      case ButtonMultiplyState.iterationNotStarted:
        break;
      case ButtonMultiplyState.iterationStarted:
        await _initiateIteration(_manager);
        break;
      default:
        return;
    }
  }

  Future<void> _initiateIteration(SettingsMultiplyManager manager) async {
    switch (manager.getCurrentEnum<CalCulationMultiplyMode>()) {
      case CalCulationMultiplyMode.multiply:
        _runMultiply(_manager);
        break;
      case CalCulationMultiplyMode.divide:
        _runDivide(_manager);
        break;
    }
  }

  Future<void> _runMultiply(SettingsMultiplyManager manager) async =>
      await doProcess(getMultiplyNums, manager);

  Future<void> _runDivide(SettingsMultiplyManager manager) async =>
      await doProcess(getDivdieNums, manager);

  Future<void> doProcess(List<Tuple<int, int>> Function(int, int, int) func,
      SettingsMultiplyManager manager) async {
    var questions = func(
        manager.getCurrentValue<SmallDigit, int>(),
        manager.getCurrentValue<BigDigit, int>(),
        manager.getCurrentValue<NumOfMultiplyProblems, int>());

    _stateProvider.nums.clear();
    for (var element in questions) {
      _stateProvider.nums.add(element);
    }

    await iterNums(manager, questions);
    _stateProvider.changeState(
        desiredState: ButtonMultiplyState.iterationNotStarted);
  }

  Future<void> iterNums(
    SettingsMultiplyManager manager,
    List<Tuple<int, int>> questions,
  ) async {
    var duration = manager.getCurrentValue<SpeedMultiply, Duration>();
    var isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
    var length = questions.length;

    if (isMultiply == CalCulationMultiplyMode.multiply) {
      for (var i = 0; i < length; i++) {
        var item = questions[i];

        setState(() {
          _number = '${item.item1} × ${item.item2}';
        });
        await Future.delayed(duration);

        setState(() {
          _number = '';
        });

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 2000)) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          await Future.delayed(duration);
        }

        //show answer
        setState(() {
          _number = '${item.item1 * item.item2}';
        });
        if (i == length - 1) {
          break;
        }

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 2500)) {
          await Future.delayed(const Duration(milliseconds: 2500));
        } else {
          await Future.delayed(duration);
        }

        setState(() {
          _number = '';
        });

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 1500)) {
          await Future.delayed(const Duration(milliseconds: 1500));
        } else {
          await Future.delayed(duration);
        }
      }
    } else {
      for (var i = 0; i < length; i++) {
        var item = questions[i];

        setState(() {
          _number = '${item.item1} ÷ ${item.item2}';
        });
        await Future.delayed(duration);

        setState(() {
          _number = '';
        });

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 2000)) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          await Future.delayed(duration);
        }

        //show answer
        setState(() {
          _number = '${item.item1 / item.item2}';
        });
        if (i == length - 1) {
          break;
        }

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 2500)) {
          await Future.delayed(const Duration(milliseconds: 2500));
        } else {
          await Future.delayed(duration);
        }

        setState(() {
          _number = '';
        });

        // make not to wait too long
        if (duration >= const Duration(milliseconds: 1500)) {
          await Future.delayed(const Duration(milliseconds: 1500));
        } else {
          await Future.delayed(duration);
        }
      }
    }
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    super.dispose();
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    return Platform.isWindows
        ? Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: (MediaQuery.of(context).size.height * 0.7 +
                    MediaQuery.of(context).size.width * 0.6) *
                0.17)
        : Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: (MediaQuery.of(context).size.height * 0.7 +
                    MediaQuery.of(context).size.width * 0.6) *
                0.11);
  }
}
