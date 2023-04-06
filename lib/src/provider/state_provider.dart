import 'package:abacus_simple_anzan/src/words/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../words/const.dart';

class StateProvider extends ChangeNotifier {
  ButtonState state = ButtonState.iterationNotStarted;

  bool isButtonVisible = true;
  String buttonText = LocalizationChecker.start;

  void changeState({ButtonState desiredState = ButtonState.autoState}) {
    switch (desiredState) {
      case ButtonState.autoState:
        break;
      default:
        state = desiredState;
        break;
    }

    if (desiredState == ButtonState.autoState) {
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
        default:
          return;
      }
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
  autoState,
}

String getButtonStr(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return startEn;
    case ButtonState.iterationStarted:
      return hidden;
    case ButtonState.iterationCompleted:
      return checkEn;
    default:
      return startEn;
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
    default:
      return true;
  }
}
