import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of<StateMultiplyProvider>(context, listen: true);

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Expanded(
              flex: 3,
              child: Stack(children: [
                Visibility(
                    visible: _stateProvider.isQuestionListButtonVisible,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('문제 & 정답 확인',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                  fontSize: (MediaQuery.of(context).size.width *
                                              0.75 +
                                          MediaQuery.of(context).size.height *
                                              0.58) *
                                      0.015)),
                          IconButton(
                              onPressed: () {
                                if (_stateProvider.state ==
                                    ButtonMultiplyState.iterationStarted) {
                                  return;
                                }
//TODO
                                showDialog(
                                    context: context,
                                    builder: (context) => ProbMultiplyList(
                                          numList: _stateProvider.nums,
                                          mode: SettingsMultiplyManager()
                                              .getCurrentEnum<
                                                  CalCulationMultiplyMode>(),
                                        ));
                              },
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.7),
                                size:
                                    (MediaQuery.of(context).size.width * 0.75 +
                                            MediaQuery.of(context).size.height *
                                                0.58) *
                                        0.02,
                              ),
                              splashRadius: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.16,
                            height: MediaQuery.of(context).size.height * 0.195,
                          )
                        ])),
                Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.shadow)),
                    child: Center(
                      child: FractionallySizedBox(
                          widthFactor: 0.9,
                          heightFactor: 0.9,
                          child: Center(child: _flicker)),
                    ),
                  ),
                )),
              ]),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Consumer<StateMultiplyProvider>(
                          builder: (context, value, child) {
                        return Visibility(
                          visible: value.isButtonVisible,
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            heightFactor: 0.65,
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
      return Theme.of(context).colorScheme.onSurfaceVariant;
    } else {
      return Theme.of(context).colorScheme.onSurface;
    }
  }

  TextStyle _getMainButtonTextStyle() {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: MediaQuery.of(context).size.height * 0.04);
  }
}