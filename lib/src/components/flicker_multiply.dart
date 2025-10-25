import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/separator_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:abacus_simple_anzan/src/settings/option/theme_selector.dart';
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

  // Iteration ID system to prevent race conditions
  int _currentIterationId = 0;
  bool _isIterating = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleStateChange() {
    if (_stateProvider.state == ButtonMultiplyState.iterationCompleted) {
      _cancelBurningModeTimer();

      // Cancel any ongoing iteration
      _currentIterationId++;
      _isIterating = false;

      if (mounted) {
        setState(() {
          _number = '';
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing iteration
    _currentIterationId++;
    _isIterating = false;

    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.removeListener(_handleStateChange);
    _cancelBurningModeTimer();
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
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  _number,
                  style: _getMainNumberTextStyle(),
                  textAlign: TextAlign.left,
                )))
        : FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                _number,
                style: _getMainNumberTextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
          );
  }

  // start iteration.
  Future<void> _callbackOnButtonClick() async {
    // Prevent multiple simultaneous iterations
    if (_isIterating) {
      return;
    }

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
    // Mark as iterating and increment iteration ID
    _isIterating = true;
    _currentIterationId++;
    final iterationId = _currentIterationId;

    try {
      switch (manager.getCurrentEnum<CalCulationMultiplyMode>()) {
        case CalCulationMultiplyMode.multiply:
          await _runMultiply(_manager, iterationId);
          break;
        case CalCulationMultiplyMode.divide:
          await _runDivide(_manager, iterationId);
          break;
      }
    } finally {
      // Only clear iterating flag if this is still the current iteration
      if (iterationId == _currentIterationId) {
        _isIterating = false;
      }
    }
  }

  Future<void> _runMultiply(SettingsMultiplyManager manager, int iterationId) async =>
      await doProcess(getMultiplyNums, manager, iterationId);

  Future<void> _runDivide(SettingsMultiplyManager manager, int iterationId) async =>
      await doProcess(getDivideNums, manager, iterationId);

  // initially code was written for handling a number of problems,
  // but now it takes only one. (removed option)
  Future<void> doProcess(
      List<Tuple<int, int>> Function(int, int, int, Tuple) func,
      SettingsMultiplyManager manager,
      int iterationId) async {
    // Check if this iteration is still valid
    if (iterationId != _currentIterationId || !mounted) {
      return;
    }

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

    await iterNums(manager, questions, iterationId);

    // Check again before handling completion
    if (iterationId != _currentIterationId || !mounted) {
      return;
    }

    // For burning mode, clear the flag before scheduling next cycle
    // This ensures the timer can start a new iteration
    if (_isBurningModeActive() && _isIterationActive()) {
      _isIterating = false;
    }

    _handleProblemCompletion(manager);
  }

  void _handleProblemCompletion(SettingsMultiplyManager manager) {
    if (_isBurningModeActive() && _isIterationActive()) {
      // In burning mode, keep _isIterating as false to allow next cycle
      // The flag will be set to true again when next iteration starts
      _startBurningModeCycle(manager);
    } else {
      _stateProvider.changeState(
          desiredState: ButtonMultiplyState.iterationCompleted);
    }
  }

  bool _isBurningModeActive() {
    return _manager.getCurrentEnum<BurningModeMultiply>() ==
        BurningModeMultiply.on;
  }

  bool _isIterationActive() {
    return _stateProvider.state != ButtonMultiplyState.iterationCompleted;
  }

  Future<void> iterNums(
    SettingsMultiplyManager manager,
    List<Tuple<int, int>> questions,
    int iterationId,
  ) async {
    var duration = manager.getCurrentValue<SpeedMultiply, Duration>();
    var isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
    var length = questions.length;

    if (!mounted || iterationId != _currentIterationId) return;

    if (isMultiply == CalCulationMultiplyMode.multiply) {
      if (mounted) {
        setState(() {
          _number = '';
        });
      }

      // wait before start
      var isNotify = manager.getCurrentValue<CountDownMultiplyMode, bool>();
      if (isNotify) {
        await _doCountDown();
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      // Check if iteration is still valid after delay
      if (!mounted || iterationId != _currentIterationId) return;

      bool isSeparator = manager.getCurrentValue<SeparatorMultiplyMode, bool>();

      for (var i = 0; i < length; i++) {
        // Check iteration validity
        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        var item = questions[i];

        _optManager.soundOption.playSound();

        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        if (mounted) {
          setState(() {
            _number =
                '${isSeparator ? formatter.format(item.item1) : item.item1} × ${isSeparator ? formatter.format(item.item2) : item.item2}';
          });
        }
        await Future.delayed(duration);

        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        if (mounted) {
          setState(() {
            _number = '';
          });
        }

        // make not to wait too long before answer
        if (duration >= const Duration(milliseconds: 500)) {
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          await Future.delayed(duration);
        }

        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        //set answer
        _answer = formatter.format(item.item1 * item.item2);
        if (i == length - 1) {
          break;
        }
      }
      //when divide
    } else {
      if (mounted) {
        setState(() {
          _number = '';
        });
      }

      // wait before start
      var isNotify = manager.getCurrentValue<CountDownMultiplyMode, bool>();
      if (isNotify) {
        await _doCountDown();
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      // Check if iteration is still valid after delay
      if (!mounted || iterationId != _currentIterationId) return;

      bool isSeparator = manager.getCurrentValue<SeparatorMultiplyMode, bool>();

      for (var i = 0; i < length; i++) {
        // Check iteration validity
        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        var item = questions[i];

        _optManager.soundOption.playSound();

        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        if (mounted) {
          setState(() {
            _number =
                '${isSeparator ? formatter.format(item.item1) : item.item1} ÷ ${isSeparator ? formatter.format(item.item2) : item.item2}';
          });
        }
        await Future.delayed(duration);

        if (!mounted || iterationId != _currentIterationId) {
          break;
        }

        if (mounted) {
          setState(() {
            _number = '';
          });
        }

        // make not to wait too long before answer
        if (duration >= const Duration(milliseconds: 500)) {
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          await Future.delayed(duration);
        }

        if (!mounted || iterationId != _currentIterationId) {
          break;
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
    if (!mounted) return;

    setState(() {
      _number = _answer;
    });
  }

  void _startBurningModeCycle(SettingsMultiplyManager manager) {
    _cancelBurningModeTimer();

    _scheduleAnswerDisplay(() => _scheduleNextProblem(manager));
  }

  void _cancelBurningModeTimer() {
    _burningModeTimer?.cancel();
  }

  void _scheduleAnswerDisplay(VoidCallback onAnswerShown) {
    const answerDisplayDelay = Duration(seconds: 2);

    _burningModeTimer = Timer(answerDisplayDelay, () {
      if (!mounted) return;

      if (_shouldContinueBurningMode()) {
        _showAnswer();
        onAnswerShown();
      }
    });
  }

  void _scheduleNextProblem(SettingsMultiplyManager manager) {
    const nextProblemDelay = Duration(seconds: 3);

    _burningModeTimer = Timer(nextProblemDelay, () {
      if (!mounted) return;

      if (_shouldContinueBurningMode()) {
        _clearDisplay();
        // Flag was already cleared in doProcess for burning mode
        _initiateIteration(manager);
      }
    });
  }

  bool _shouldContinueBurningMode() {
    return _stateProvider.state == ButtonMultiplyState.iterationStarted &&
        mounted;
  }

  void _clearDisplay() {
    if (!mounted) return;

    setState(() {
      _number = '';
    });
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var fontSize = 10.0;

    if (Platform.isWindows) {
      fontSize = height * 0.075 + width * 0.075;
    } else {
      fontSize = height * 0.075 + width * 0.075;
    }

    // Use flicker text color - black for default theme in light mode, primary otherwise
    var color = ThemeSelector.getFlickerTextColor(context);

    // Use Gamja Flower font for natural handwritten feel
    return TextStyle(
      fontFamily: 'GamjaFlower',
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: color,
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
