import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/flicker.dart';
import '../provider/state_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Flicker _flicker = const Flicker();
  late StateProvider _stateProvider;

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of<StateProvider>(context, listen: false);

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Expanded(
              flex: 3,
              child: Center(
                  child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: FractionallySizedBox(
                          widthFactor: 0.7,
                          heightFactor: 0.5,
                          child: Consumer<StateProvider>(
                              builder: (context, value, child) {
                            return Visibility(
                                visible: value.isButtonVisible,
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
                                      textAlign: TextAlign.left,
                                    )));
                          })))),
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
