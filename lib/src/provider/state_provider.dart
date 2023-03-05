import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../const/const.dart';

class StateProvider extends ChangeNotifier {
  ButtonState state = ButtonState.iterationNotStarted;

  bool isButtonVisible = true;
  String buttonText = start;

  void changeState() {
    switch (state) {
      case ButtonState.iterationNotStarted:
        state = ButtonState.iterationStarted;
        break;
      case ButtonState.iterationStarted:
        state = ButtonState.iterationCompleted;
        break;
      case ButtonState.iterationCompleted:
        state = ButtonState.iterationNotStarted;
        break;
    }

    buttonText = getButtonStr(state);
    isButtonVisible = getButtonVisibility(state);
    notifyListeners();
  }
}

enum ButtonState {
  iterationNotStarted,
  iterationStarted,
  iterationCompleted,
}

String getButtonStr(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return start;
    case ButtonState.iterationStarted:
      return hidden;
    case ButtonState.iterationCompleted:
      return check;
  }
}

bool getButtonVisibility(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return true;
    case ButtonState.iterationStarted:
      return false;
    case ButtonState.iterationCompleted:
      return true;
  }
}
