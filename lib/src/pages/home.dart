import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_anzan/src/provider/state_provider.dart';

import '../components/flicker.dart';
import '../const/const.dart';

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
          color: const ColorScheme.dark().background,
          alignment: Alignment.topCenter,
          child: Column(children: [
            Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Center(
                      child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(158, 158, 158, 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromRGBO(96, 125, 139, 0.1))),
                      child: Center(child: _flicker),
                    ),
                  )),
                )),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
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
                                              getButtonColorProp),
                                    ),
                                    onPressed: onPressed,
                                    child: Text(
                                      value.buttonText,
                                      style: getMainButtonTextStyle(),
                                    )));
                          })))),
            ),
          ] // children ends
              ),
        ));
  }

  // event triggered
  void onPressed() {
    setState(() {
      _stateProvider.changeState();
    });
  }

  // styles
  Color getButtonColorProp(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.greenAccent;
    } else {
      return Colors.green;
    }
  }

  TextStyle getMainButtonTextStyle() {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      fontFamily: defaultFontFamily,
      letterSpacing: 2.5,
    );
  }
}
