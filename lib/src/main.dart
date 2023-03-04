import 'package:flutter/material.dart';

import 'const.dart';
import 'enum.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _numberText = empty;

  bool _isVisible = true;

  ButtonState _buttonState = ButtonState.iterationNotStarted;
  String _buttonText = defaultButtonStr();

  @override
  Widget build(BuildContext context) {
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
                      child: Center(
                          child: Text(_numberText,
                              style: getMainNumberTextStyle())),
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
                    child: Visibility(
                        visible: _isVisible,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  getButtonColorProp),
                            ),
                            onPressed: onPressed,
                            child: Text(
                              _buttonText,
                              style: getMainButtonTextStyle(),
                            ))),
                  )),
                )),
          ] // children ends
              ),
        ));
  }

  // event triggered
  void onPressed() {}

  // styles

  Color getButtonColorProp(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.greenAccent;
    } else {
      return Colors.green;
    }
  }

  TextStyle getMainNumberTextStyle() {
    return const TextStyle(
      fontSize: 100,
      fontWeight: FontWeight.w900,
      fontFamily: 'consolas',
      letterSpacing: 3,
      color: Color.fromARGB(255, 113, 150, 67),
    );
  }

  TextStyle getMainButtonTextStyle() {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      fontFamily: 'consolas',
      letterSpacing: 2.5,
    );
  }
}
