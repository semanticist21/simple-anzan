import 'package:abacus_simple_anzan/src/components/flashing_container.dart';
import 'package:flutter/material.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';

import '../functions/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

class StateMultiplyProvider extends ChangeNotifier {
  var state = ButtonMultiplyState.iterationNotStarted;
  FlashingContainer? flashingContainer;

  var isButtonVisible = true;
  var isQuestionListButtonVisible = false;

  String get buttonText => getButtonStr(state);
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
      return 'buttons.start'.tr();
    case ButtonMultiplyState.iterationStarted:
      // Check if burning mode is enabled
      BurningModeMultiply mode = SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
      if (mode == BurningModeMultiply.on) {
        return 'other.onBurning'.tr();
      }
      return ' ';
    case ButtonMultiplyState.iterationCompleted:
      return 'buttons.check'.tr();
    default:
      return 'buttons.start'.tr();
  }
}

bool getButtonVisibility(ButtonMultiplyState state) {
  switch (state) {
    case ButtonMultiplyState.iterationNotStarted:
      return true;
    case ButtonMultiplyState.iterationStarted:
      // Check if burning mode is enabled - keep button visible if it is
      BurningModeMultiply mode = SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
      if (mode == BurningModeMultiply.on) {
        return true;
      }
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
