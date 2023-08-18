import 'package:abacus_simple_anzan/src/components/flashing_container.dart';
import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import '../components/flicker_multiply.dart';
import '../dialog/prob_list_multiply.dart';

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
                          Text(LocalizationChecker.checkProb,
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
                width: MediaQuery.of(context).size.width * 0.7,
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
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
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

  // styles
  Color _getButtonColorProp(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Theme.of(context).colorScheme.surfaceVariant;
    } else {
      return Theme.of(context).colorScheme.surfaceTint;
    }
  }

  TextStyle _getMainButtonTextStyle() {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: MediaQuery.of(context).size.height * 0.04);
  }
}
