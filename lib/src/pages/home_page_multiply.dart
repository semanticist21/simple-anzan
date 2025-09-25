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
          color: Theme.of(context).colorScheme.surface,
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
                                      .onSurface
                                      .withValues(alpha: 0.7),
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
                                      .onSurface
                                      .withValues(alpha: 0.7),
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
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(children: [
                  flashingContainer,
                  Center(
                    child: FractionallySizedBox(
                        widthFactor: 0.95,
                        heightFactor: 0.95,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: _flicker),
                        )),
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
                            child: _FlatButton(
                              onPressed: _onPressed,
                              backgroundColor: _isBurningModeActive(value)
                                  ? Colors.red.shade500
                                  : Theme.of(context).colorScheme.primary,
                              child: _isBurningModeActive(value)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.flame_fill,
                                          color: Colors.white,
                                          size: MediaQuery.of(context).size.height * 0.035,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            value.buttonText,
                                            style: _getBurningModeTextStyle(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      value.buttonText,
                                      style: _getMainButtonTextStyle(),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
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

class _FlatButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;

  const _FlatButton({
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  });

  @override
  State<_FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<_FlatButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.backgroundColor.withValues(alpha: 0.8)
              : widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
