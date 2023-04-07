import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../const/const.dart';

class StateProvider extends ChangeNotifier {
  var state = ButtonState.iterationNotStarted;

  var isButtonVisible = true;
  var isQuestionListButtonVisible = false;
  var buttonText = LocalizationChecker.start;
  var nums = List<int>.empty(growable: true);

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
    isQuestionListButtonVisible = getQuestionListButtonVisibility(state);
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
      return LocalizationChecker.start;
    case ButtonState.iterationStarted:
      return hidden;
    case ButtonState.iterationCompleted:
      return LocalizationChecker.check;
    default:
      return LocalizationChecker.start;
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

bool getQuestionListButtonVisibility(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return true;
    case ButtonState.iterationStarted:
      return false;
    case ButtonState.iterationCompleted:
      return true;
    default:
      return false;
  }
}
