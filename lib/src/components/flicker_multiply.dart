import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/seperator_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
import 'dart:async';

import '../functions/tuple.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../functions/functions.dart';
import '../settings/multiply_prefs/prefs/countdown_mode.dart';
import '../settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
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

  var formatter = NumberFormat('#,##0');
  var _lastTuple = Tuple(-1, -1);

  var _number = '';
  var _answer = '';
  Timer? _burningModeTimer;

  @override
  void initState() {
    super.initState();
  }

  void _handleStateChange() {
    if (_stateProvider.state == ButtonMultiplyState.iterationCompleted) {
      // Cancel burning mode timer when iteration is completed
      _burningModeTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.removeListener(_handleStateChange);
    _burningModeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.removeListener(_handleStateChange);
    _stateProvider.addListener(_callbackOnButtonClick);
    _stateProvider.addListener(_handleStateChange);

    if (_number.isEmpty) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

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
          break;
        case CalCulationMultiplyMode.divide:
          _stateProvider.isMultiplies.add(false);
          break;
      }
    }

    await iterNums(manager, questions);

    // Check if burning mode is enabled for automatic cycling
    BurningModeMultiply burningMode = manager.getCurrentEnum<BurningModeMultiply>();
    if (burningMode == BurningModeMultiply.on && _stateProvider.state != ButtonMultiplyState.iterationCompleted) {
      // Start automatic cycling in burning mode - don't change to completed state
      _startBurningModeCycle(manager);
    } else {
      _stateProvider.changeState(
          desiredState: ButtonMultiplyState.iterationCompleted);
    }
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

      bool isSeperator = manager.getCurrentValue<SeperatorMultiplyMode, bool>();

      for (var i = 0; i < length; i++) {
        var item = questions[i];

        _optManager.soundOption.playSound();
        setState(() {
          _number =
              '${isSeperator ? formatter.format(item.item1) : item.item1} × ${isSeperator ? formatter.format(item.item2) : item.item2}';
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
        _answer = formatter.format(item.item1 * item.item2);
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

      bool isSeperator = manager.getCurrentValue<SeperatorMultiplyMode, bool>();

      for (var i = 0; i < length; i++) {
        var item = questions[i];

        _optManager.soundOption.playSound();
        setState(() {
          _number =
              '${isSeperator ? formatter.format(item.item1) : item.item1} ÷ ${isSeperator ? formatter.format(item.item2) : item.item2}';
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
        _answer = formatter.format(item.item1 ~/ item.item2);

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

  void _startBurningModeCycle(SettingsMultiplyManager manager) {
    // Cancel any existing timer
    _burningModeTimer?.cancel();

    // Show answer after 2 seconds
    _burningModeTimer = Timer(const Duration(seconds: 2), () {
      if (_stateProvider.state == ButtonMultiplyState.iterationStarted && mounted) {
        _showAnswer();

        // Start new problem cycle after 3 more seconds (total 5 seconds)
        _burningModeTimer = Timer(const Duration(seconds: 3), () {
          if (_stateProvider.state == ButtonMultiplyState.iterationStarted && mounted) {
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

    var titleLarge = Theme.of(context).textTheme.titleLarge;

    if (titleLarge == null) {
      return TextStyle(fontSize: fontsize, fontStyle: FontStyle.italic);
    }

    return Platform.isWindows
        ? titleLarge.copyWith(fontStyle: FontStyle.italic, fontSize: fontsize)
        : titleLarge.copyWith(
            fontSize: fontsize,
            fontStyle: FontStyle.italic,
          );
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
