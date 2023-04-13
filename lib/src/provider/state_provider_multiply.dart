import 'package:flutter/cupertino.dart';

import '../functions/tuple.dart';
import '../const/const.dart';
import '../const/localization.dart';

class StateMultiplyProvider extends ChangeNotifier {
  var state = ButtonMultiplyState.iterationNotStarted;

  var isButtonVisible = true;
  var isQuestionListButtonVisible = false;

  var buttonText = LocalizationChecker.start;
  var nums = List<Tuple<int, int>>.empty(growable: true);
  var isMultiplies = List<bool>.empty(growable: true);

  void changeState(
      {ButtonMultiplyState desiredState = ButtonMultiplyState.autoState}) {
    switch (desiredState) {
      case ButtonMultiplyState.autoState:
        break;
      default:
        state = desiredState;
        break;
    }

    if (desiredState == ButtonMultiplyState.autoState) {
      switch (state) {
        case ButtonMultiplyState.iterationNotStarted:
          state = ButtonMultiplyState.iterationStarted;
          break;
        case ButtonMultiplyState.iterationStarted:
          state = ButtonMultiplyState.iterationCompleted;
          break;
        case ButtonMultiplyState.iterationCompleted:
          state = ButtonMultiplyState.iterationNotStarted;
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

enum ButtonMultiplyState {
  iterationNotStarted,
  iterationStarted,
  iterationCompleted,
  autoState,
}

String getButtonStr(ButtonMultiplyState state) {
  switch (state) {
    case ButtonMultiplyState.iterationNotStarted:
      return LocalizationChecker.start;
    case ButtonMultiplyState.iterationStarted:
      return hidden;
    case ButtonMultiplyState.iterationCompleted:
      return LocalizationChecker.check;
    default:
      return LocalizationChecker.start;
  }
}

bool getButtonVisibility(ButtonMultiplyState state) {
  switch (state) {
    case ButtonMultiplyState.iterationNotStarted:
      return true;
    case ButtonMultiplyState.iterationStarted:
      return false;
    case ButtonMultiplyState.iterationCompleted:
      return true;
    default:
      return true;
  }
}

bool getQuestionListButtonVisibility(ButtonMultiplyState state) {
  switch (state) {
    case ButtonMultiplyState.iterationNotStarted:
      return true;
    case ButtonMultiplyState.iterationStarted:
      return false;
    case ButtonMultiplyState.iterationCompleted:
      return true;
    default:
      return false;
  }
}
