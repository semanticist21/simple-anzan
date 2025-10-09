import 'package:abacus_simple_anzan/src/settings/option/option_manager.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:abacus_simple_anzan/src/settings/option/theme_selector.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/separator.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/shuffle.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

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
      _cancelBurningModeTimer();
      setState(() {
        _number = '';
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

  // Calculate "-" sign width using TextPainter before rendering
  double _calculateSignWidth(TextStyle style, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: '-', style: style),
      textDirection: Directionality.of(context),
    );
    textPainter.layout();
    return textPainter.width;
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

    // Split number into sign and digits for alignment
    String displayNumber = _number.trim();
    bool isNegative = displayNumber.startsWith('-');
    String numberText = isNegative ? displayNumber.substring(1) : displayNumber;

    // Pre-calculate sign width to avoid layout shift
    final textStyle = _getMainNumberTextStyle();
    final signWidth = _calculateSignWidth(textStyle, context);

    // Calculate offset dynamically based on calculated sign width
    double offsetX = -signWidth / 2;

    Widget numberWidget = Transform.translate(
      offset: Offset(offsetX, 0), // Move left by half of sign width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Always render "-" sign, hide with opacity for positive numbers
          Opacity(
            opacity: isNegative ? 1.0 : 0.0,
            child: Text(
              '-',
              style: textStyle,
            ),
          ),
          // Number text (without sign)
          Text(
            numberText,
            style: textStyle,
          ),
        ],
      ),
    );

    return _number.length > 5
        ? FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: numberWidget,
            ))
        : Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: numberWidget,
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

    _handleProblemCompletion(manager);
  }

  void _handleProblemCompletion(SettingsManager manager) {
    if (_isBurningModeActive() && _isIterationActive()) {
      _startBurningModeCycle(manager);
    } else {
      _stateProvider.changeState(desiredState: ButtonState.iterationCompleted);
    }
  }

  bool _isBurningModeActive() {
    return _manager.getCurrentEnum<BurningMode>() == BurningMode.on;
  }

  bool _isIterationActive() {
    return _stateProvider.state != ButtonState.iterationCompleted;
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

    bool isSeparator = manager.getCurrentValue<SeparatorMode, bool>();

    for (int i = 0; i < len; i++) {
      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = '';
        });
        break;
      }

      var str = questions[i].toString();

      _optManager.soundOption.playSound();
      if (_stateProvider.state == ButtonState.iterationCompleted) {
        break;
      }
      setState(() {
        _number = isSeparator ? formatter.format(int.parse(str)) : str;
      });

      await Future.delayed(duration);

      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = '';
        });
        break;
      }

      setState(() {
        _number = '';
      });

      // if it is the last iteration, then don't await.
      if (i == len - 1) {
        break;
      }

      if (_stateProvider.state == ButtonState.iterationCompleted) {
        setState(() {
          _number = '';
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
      _number = _answer == '' ? '' : formatter.format(int.parse(_answer));
    });
  }

  void _startBurningModeCycle(SettingsManager manager) {
    _cancelBurningModeTimer();

    _scheduleAnswerDisplay(() => _scheduleNextProblem(manager));
  }

  void _cancelBurningModeTimer() {
    _burningModeTimer?.cancel();
  }

  void _scheduleAnswerDisplay(VoidCallback onAnswerShown) {
    const answerDisplayDelay = Duration(seconds: 2);

    _burningModeTimer = Timer(answerDisplayDelay, () {
      if (_shouldContinueBurningMode()) {
        _showAnswer();
        onAnswerShown();
      }
    });
  }

  void _scheduleNextProblem(SettingsManager manager) {
    const nextProblemDelay = Duration(seconds: 3);

    _burningModeTimer = Timer(nextProblemDelay, () {
      if (_shouldContinueBurningMode()) {
        _clearDisplay();
        _initiateIteration(manager);
      }
    });
  }

  bool _shouldContinueBurningMode() {
    return _stateProvider.state == ButtonState.iterationStarted && mounted;
  }

  void _clearDisplay() {
    setState(() {
      _number = '';
    });
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    _stateProvider.removeListener(_handleResetText);
    _cancelBurningModeTimer();
    super.dispose();
  }

// styles.
  TextStyle _getMainNumberTextStyle() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var digits = _manager.getCurrentValue<Digit, int>();
    var fontSize = 10.0;

    // Static font size for 1-5 digits, dynamic for 6-9 digits
    if (digits <= 5) {
      // Static font size for 1-5 digits
      if (Platform.isWindows) {
        fontSize = height * 0.085 + width * 0.085;
      } else {
        fontSize = height * 0.085 + width * 0.085;
      }
    } else {
      // Dynamic font size for 6-9 digits to prevent overflow
      var baseFontSize = height * 0.085 + width * 0.085;
      // Scale down font size based on digit count (6-9 digits)
      // Maximum 9 digits as specified
      var scaleFactor = 5.0 / digits.clamp(6, 9);
      fontSize = baseFontSize * scaleFactor;
    }

    // Use flicker text color - black for default theme in light mode, primary otherwise
    var color = ThemeSelector.getFlickerTextColor(context);

    // Use Gamja Flower font for natural handwritten feel
    return GoogleFonts.gamjaFlower(
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
