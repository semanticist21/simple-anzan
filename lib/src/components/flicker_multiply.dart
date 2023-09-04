import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import '../functions/tuple.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../functions/functions.dart';
import '../settings/multiply_prefs/prefs/countdown_mode.dart';
import '../settings/option/option_manager.dart';

class FlickerMultiply extends StatefulWidget {
  const FlickerMultiply({super.key});

  @override
  State<FlickerMultiply> createState() => _FlickerMultiplyState();
}

class _FlickerMultiplyState extends State<FlickerMultiply> {
  late StateMultiplyProvider _stateProvider;
  final SettingsMultiplyManager _manager = SettingsMultiplyManager();
  final _optManager = OptionManager();

  var formattter = NumberFormat('#,##0');
  var _lastTuple = Tuple(-1, -1);

  var _number = '';
  var _answer = '';

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    super.dispose();
    _optManager.soundOption.stopAudio();
    _optManager.soundOption.stopCountAudio();
  }

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
        : FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _number,
              style: _getMainNumberTextStyle(),
              textAlign: TextAlign.left,
            ),
          );
  }

  // start iteration.
  Future<void> _callbackOnButtonClick() async {
    switch (_stateProvider.state) {
      case ButtonMultiplyState.iterationNotStarted:
        _showAnswer();
        break;
      case ButtonMultiplyState.iterationStarted:
        await _initiateIteration(_manager);
        break;
      case ButtonMultiplyState.iterationCompleted:
        break;
      default:
        return;
    }
  }

  Future<void> _initiateIteration(SettingsMultiplyManager manager) async {
    if (_isInit) {
      await _optManager.soundOption.initPlaySound();
      _isInit = false;
    }

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

  // initially code was written for handling a number of problems,
  // but now it takes only one. (removed option)
  Future<void> doProcess(
      List<Tuple<int, int>> Function(int, int, int, Tuple) func,
      SettingsMultiplyManager manager) async {
    var questions = func(
        manager.getCurrentValue<SmallDigit, int>(),
        manager.getCurrentValue<BigDigit, int>(),
        manager.getCurrentValue<NumOfMultiplyProblems, int>(),
        _lastTuple);

    if (_stateProvider.nums.length > 20) {
      _stateProvider.nums.removeAt(0);
      _stateProvider.isMultiplies.removeAt(0);
    }

    _lastTuple = questions.first;

    for (var element in questions) {
      _stateProvider.nums.add(element);
      switch (manager.getCurrentEnum<CalCulationMultiplyMode>()) {
        case CalCulationMultiplyMode.multiply:
          _stateProvider.isMultiplies.add(true);
        case CalCulationMultiplyMode.divide:
          _stateProvider.isMultiplies.add(false);
      }
    }

    await iterNums(manager, questions);
    _stateProvider.changeState(
        desiredState: ButtonMultiplyState.iterationCompleted);
  }

  Future<void> iterNums(
    SettingsMultiplyManager manager,
    List<Tuple<int, int>> questions,
  ) async {
    var duration = manager.getCurrentValue<SpeedMultiply, Duration>();
    var isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
    var length = questions.length;

    if (isMultiply == CalCulationMultiplyMode.multiply) {
      setState(() {
        _number = '';
      });

      // wait before start
      var isNotify = manager.getCurrentValue<CountDownMultiplyMode, bool>();
      if (isNotify) {
        await _doCountDown();
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      for (var i = 0; i < length; i++) {
        var item = questions[i];

        _optManager.soundOption.playSound();
        setState(() {
          _number = '${item.item1} × ${item.item2}';
        });
        await Future.delayed(duration);

        setState(() {
          _number = '';
        });

        // make not to wait too long before answ
        if (duration >= const Duration(milliseconds: 500)) {
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          await Future.delayed(duration);
        }

        //set answer
        _answer = formattter.format(item.item1 * item.item2);
        if (i == length - 1) {
          break;
        }
      }
      //when divide
    } else {
      setState(() {
        _number = '';
      });

      // wait before start
      var isNotify = manager.getCurrentValue<CountDownMultiplyMode, bool>();
      if (isNotify) {
        await _doCountDown();
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      for (var i = 0; i < length; i++) {
        var item = questions[i];

        _optManager.soundOption.playSound();
        setState(() {
          _number = '${item.item1} ÷ ${item.item2}';
        });
        await Future.delayed(duration);

        setState(() {
          _number = '';
        });

        // make not to wait too long before answ
        if (duration >= const Duration(milliseconds: 500)) {
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          await Future.delayed(duration);
        }

        //set answer
        _answer = formattter.format(item.item1 ~/ item.item2);

        if (i == length - 1) {
          break;
        }
      }
    }
  }

  void _showAnswer() {
    setState(() {
      _number = _answer;
    });
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var fontsize = 10.0;

    if (Platform.isWindows) {
      fontsize = height * 0.075 + width * 0.075;
    } else {
      fontsize = height * 0.075 + width * 0.075;
    }

    return Platform.isWindows
        ? Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontStyle: FontStyle.italic, fontSize: fontsize)
        : Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: fontsize,
              fontStyle: FontStyle.italic,
            );
  }

  Future<void> _doCountDown() async {
    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (!SoundOptionHandler.isSoundOn) {
      _stateProvider.flashingContainer?.containerState.startFlashing();
    }
    await _optManager.soundOption.playCountSound();

    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (!SoundOptionHandler.isSoundOn) {
      _stateProvider.flashingContainer?.containerState.startFlashing();
    }
    await _optManager.soundOption.playCountSound();

    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    await _optManager.soundOption.resetSource();
  }
}
