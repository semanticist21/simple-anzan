import 'package:abacus_simple_anzan/src/settings/option/option_manager.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/seperator.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/shuffle.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:async';

import '../const/const.dart';
import '../functions/functions.dart';
import '../settings/plus_pref/prefs/calculation_mode_pref.dart';
import '../settings/plus_pref/prefs/digit_pref.dart';
import '../settings/plus_pref/prefs/burning_mode_pref.dart';
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

  var formatter = NumberFormat('#,##0');

  var _number = '';
  var _answer = '';
  Timer? _burningModeTimer;

  void _handleResetText() {
    if (_stateProvider.state == ButtonState.iterationCompleted) {
      // Cancel burning mode timer when iteration is completed
      _burningModeTimer?.cancel();
      setState(() {
        _number = empty;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stateProvider.removeListener(_callbackOnButtonClick);
      _stateProvider.removeListener(_handleResetText);
      _stateProvider.addListener(_callbackOnButtonClick);
      _stateProvider.addListener(_handleResetText);
    });
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: true);

    if (_number.isEmpty) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return _number.length > 6
        ? FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _number,
              style: _getMainNumberTextStyle(),
              textAlign: TextAlign.left,
            ))
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

    await iterNums(manager, questions, _stateProvider);

    // Check if burning mode is enabled for automatic cycling
    BurningMode burningMode = manager.getCurrentEnum<BurningMode>();
    if (burningMode == BurningMode.on && _stateProvider.state != ButtonState.iterationCompleted) {
      // Start automatic cycling in burning mode - don't change to completed state
      _startBurningModeCycle(manager);
    } else {
      _stateProvider.changeState(desiredState: ButtonState.iterationCompleted);
    }
  }

  Future<void> iterNums(SettingsManager manager, List<int> questions,
      StateProvider stateProvider) async {
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

    bool isSeperator = manager.getCurrentValue<SeperatorMode, bool>();

    for (int i = 0; i < len; i++) {
      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = empty;
        });
        break;
      }

      var str = '';

      if (questions[i] > 0) {
        var parsedStr = questions[i].toString();
        str = '\t$parsedStr\t';
      } else {
        str = '${questions[i].toString()}\t';
      }

      _optManager.soundOption.playSound();
      if (_stateProvider.state == ButtonState.iterationCompleted) {
        break;
      }
      setState(() {
        _number = isSeperator ? formatter.format(int.parse(str)) : str;
      });

      await Future.delayed(duration);

      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = empty;
        });
        break;
      }

      setState(() {
        _number = empty;
      });

      // if it is the last iteration, then don't await.
      if (i == len - 1) {
        break;
      }

      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = empty;
        });
        break;
      }

      if (duration < const Duration(milliseconds: 200)) {
        await Future.delayed(duration);
      } else {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  void _showAnswer() {
    setState(() {
      _number =
          _answer == '' ? '' : '\t${formatter.format(int.parse(_answer))}\t';
    });
  }

  void _startBurningModeCycle(SettingsManager manager) {
    // Cancel any existing timer
    _burningModeTimer?.cancel();

    // Show answer after 2 seconds
    _burningModeTimer = Timer(const Duration(seconds: 2), () {
      if (_stateProvider.state == ButtonState.iterationStarted && mounted) {
        _showAnswer();

        // Start new problem cycle after 3 more seconds (total 5 seconds)
        _burningModeTimer = Timer(const Duration(seconds: 3), () {
          if (_stateProvider.state == ButtonState.iterationStarted && mounted) {
            // Clear answer display and start a new problem cycle
            setState(() {
              _number = '';
            });
            // Start a new problem cycle
            _initiateIteration(manager);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.removeListener(_handleResetText);
    _burningModeTimer?.cancel();
    super.dispose();
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var fontsize = 10.0;

    if (Platform.isWindows) {
      fontsize = height * 0.085 + width * 0.085;
    } else {
      fontsize = height * 0.085 + width * 0.085;
    }

    var titleLarge = Theme.of(context).textTheme.titleLarge;

    if (titleLarge == null) {
      return TextStyle(fontSize: fontsize, fontStyle: FontStyle.italic);
    }

    return Platform.isWindows
        ? titleLarge.copyWith(fontStyle: FontStyle.italic, fontSize: fontsize)
        : titleLarge.copyWith(fontStyle: FontStyle.italic, fontSize: fontsize);
  }

  Future<void> _doCountDown() async {
    if (!SoundOptionHandler.isSoundOn) {
      await _stateProvider.flashingContainer?.containerState.startFlashing();
    }
    await _optManager.soundOption.playCountSound();

    if (!SoundOptionHandler.isSoundOn) {
      await _stateProvider.flashingContainer?.containerState.startFlashing();
    }
    await _optManager.soundOption.playCountSound();
  }
}
