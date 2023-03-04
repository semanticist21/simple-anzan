import 'const.dart';

enum ButtonState {
  iterationNotStarted,
  iterationStarted,
}

enum CalculationMode {
  onlyPlus,
  plusMinus,
  multiply,
  divide,
}

enum NumberOfNumber {
  n_5,
  n_10,
  n_15,
  n_20,
}

enum Speed {
  slow,
  normal,
  fast,
}

// ButtonState
String defaultButtonStr() {
  return start;
}

String getButtonStr(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return start;
    case ButtonState.iterationStarted:
      return hidden;
  }
}

bool getButtonVisibility(ButtonState state) {
  switch (state) {
    case ButtonState.iterationNotStarted:
      return true;
    case ButtonState.iterationStarted:
      return false;
  }
}
