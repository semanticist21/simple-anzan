import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_anzan/src/provider/state_provider.dart';

import '../const/const.dart';
import '../settings/settings.dart';

class Flicker extends StatefulWidget {
  const Flicker({super.key});

  @override
  State<Flicker> createState() => _FlickerState();
}

class _FlickerState extends State<Flicker> {
  String _number = '';
  late StateProvider _stateProvider;
  late SettingsManager manager;

  @override
  void initState() {
    super.initState();
    manager = SettingsManager();
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of(context, listen: false);
    _stateProvider.addListener(_callbackOnButtonClick);

    return Text(
      _number,
      style: getMainNumberTextStyle(),
    );
  }

  // start iteration.
  void _callbackOnButtonClick() {
    switch (_stateProvider.state) {
      case ButtonState.iterationNotStarted:
        return;
      case ButtonState.iterationStarted:
        initiateIteration();
        break;
      case ButtonState.iterationCompleted:
        return;
    }
  }

  Future<void> initiateIteration() async {}

  @override
  void dispose() {
    _stateProvider.removeListener(_callbackOnButtonClick);
    super.dispose();
  }
}

// styles.
TextStyle getMainNumberTextStyle() {
  return const TextStyle(
    fontSize: 100,
    fontWeight: FontWeight.w900,
    fontFamily: defaultFontFamily,
    letterSpacing: 3,
    color: Color.fromARGB(255, 113, 150, 67),
  );
}
