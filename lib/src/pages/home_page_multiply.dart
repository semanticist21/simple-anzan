import 'package:abacus_simple_anzan/src/components/flashing_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import '../components/flicker_multiply.dart';
import '../dialog/prob_list_multiply.dart';
import '../settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
import '../settings/multiply_prefs/settings_manager_multiply.dart';

class HomeMultiplyPage extends StatefulWidget {
  const HomeMultiplyPage({super.key});

  @override
  State<HomeMultiplyPage> createState() => _HomeMultiplyPageState();
}

class _HomeMultiplyPageState extends State<HomeMultiplyPage> {
  final FlickerMultiply _flicker = const FlickerMultiply();
  late StateMultiplyProvider _stateProvider;
  FlashingContainer flashingContainer = FlashingContainer();

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of<StateMultiplyProvider>(context, listen: true);
    _stateProvider.flashingContainer = flashingContainer;

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Expanded(
                flex: 1,
                child: Visibility(
                    // visible: _stateProvider.isQuestionListButtonVisible,
                    visible: false,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('problemList.checkProb'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                  fontSize: Platform.isWindows
                                      ? MediaQuery.of(context).size.height *
                                          0.03
                                      : MediaQuery.of(context).size.height *
                                          0.015)),
                          IconButton(
                              onPressed: () {
                                if (_stateProvider.state ==
                                    ButtonMultiplyState.iterationStarted) {
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => ProbMultiplyList(
                                          numList: _stateProvider.nums,
                                          mode: _stateProvider.isMultiplies,
                                        ));
                              },
                              icon: Icon(Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                  size: Platform.isWindows
                                      ? MediaQuery.of(context).size.height *
                                          0.03
                                      : MediaQuery.of(context).size.height *
                                          0.015),
                              splashRadius: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.16,
                            // height: MediaQuery.of(context).size.height * 0.175,
                          ),
                        ]))),
            Expanded(
              flex: 8,
              child: Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 1,
                child: Stack(children: [
                  flashingContainer,
                  Center(
                    child: FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.9,
                        child: Center(child: _flicker)),
                  ),
                ]),
              )),
            ),
            Expanded(
              flex: 6,
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Consumer<StateMultiplyProvider>(
                          builder: (context, value, child) {
                        return Visibility(
                          visible: value.isButtonVisible,
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            heightFactor: 0.4,
                            child: _isBurningModeActive(value)
                                ? ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateColor.resolveWith(
                                              _getButtonColorProp),
                                    ),
                                    onPressed: _onPressed,
                                    icon: Icon(
                                      CupertinoIcons.flame_fill,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height * 0.05,
                                    ),
                                    label: Text(
                                      value.buttonText,
                                      style: _getBurningModeTextStyle(),
                                      textAlign: TextAlign.center,
                                    ))
                                : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateColor.resolveWith(
                                              _getButtonColorProp),
                                    ),
                                    onPressed: _onPressed,
                                    child: Text(
                                      value.buttonText,
                                      style: _getMainButtonTextStyle(),
                                      textAlign: TextAlign.center,
                                    )),
                          ),
                        );
                      }))),
            ),
          ] // children ends
              ),
        ));
  }

  // event triggered
  void _onPressed() {
    _stateProvider.changeState();
  }

  // helper method to check if burning mode is active and button is showing "On Burning"
  bool _isBurningModeActive(StateMultiplyProvider value) {
    if (value.state == ButtonMultiplyState.iterationStarted) {
      BurningModeMultiply mode = SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
      return mode == BurningModeMultiply.on;
    }
    return false;
  }

  // styles
  Color _getButtonColorProp(Set<WidgetState> states) {
    // Check if burning mode is active
    if (_stateProvider.state == ButtonMultiplyState.iterationStarted) {
      try {
        BurningModeMultiply mode = SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
        if (mode == BurningModeMultiply.on) {
          return states.contains(WidgetState.pressed)
              ? Colors.red.shade700
              : Colors.red;
        }
      } catch (e) {
        // If preferences not initialized, use default colors
      }
    }

    if (states.contains(WidgetState.pressed)) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    } else {
      return Theme.of(context).colorScheme.surfaceTint;
    }
  }

  TextStyle _getMainButtonTextStyle() {
    var titleBodyLarge = Theme.of(context).textTheme.bodyLarge;

    if (titleBodyLarge != null) {
      return titleBodyLarge.copyWith(
          fontSize: MediaQuery.of(context).size.height * 0.04);
    }

    return TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04);
  }

  TextStyle _getBurningModeTextStyle() {
    var titleBodyLarge = Theme.of(context).textTheme.bodyLarge;

    if (titleBodyLarge != null) {
      return titleBodyLarge.copyWith(
          fontSize: MediaQuery.of(context).size.height * 0.025,
          color: Colors.white);
    }

    return TextStyle(
        fontSize: MediaQuery.of(context).size.height * 0.025,
        color: Colors.white);
  }
}
