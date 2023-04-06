import 'package:abacus_simple_anzan/src/words/const.dart';
import 'package:universal_io/io.dart';

class LocalizationChecker {
  static String defaultLocale = Platform.localeName;
  static bool isKr = false;

  // bottom navigation
  static String homePlusLabel = homePlusLabelEn;
  static String settingPlusLabel = settingPlusLabelEn;
  static String homeMultiplyLabel = homeMultiplyLabelEn;
  static String settingMultiplyLabel = settingMultiplyLabelEn;

  // theme str
  static String mode = modeEn;

  // button str
  static String ok = okEn;
  static String start = startEn;
  static String check = checkEn;

  // options(settings)
  static String settings = settingsEn;
  static String shuffle = shuffleEn;
  static String onlyPluses = onlyPlusesEn;
  static String speed = speedEn;
  static String digit = digitEn;
  static String numOfProblems = numOfProblemsEn;

  static String setSpeedTitle = setSpeedTitleEn;
  static String rangeWord = rangeWordEn;
  static String pleaseInsertValue = pleaseInsertValueEn;
  static String pleaseTooBigValue = pleaseTooBigValueEn;
  static String pleaseTooSmallValue = pleaseTooSmallValueEn;

  // option(multiply)
  static String settingsMultiply = settingsMultiplyEn;
  static String isMultiply = isMultiplyEn;
  static String speedMultiply = speedMultiplyEn;
  static String startDigitMultiply = startDigitMultiplyEn;
  static String endDigitMultiply = endDigitMultiplyEn;
  static String numOfProblemsMultiply = numOfProblemsMultiplyEn;

  static String rangeMultiplyWord = rangeMultiplyWordEn;
  static String shulffleDesc = shuffleDescEn;

  LocalizationChecker() {
    if (defaultLocale == 'ko_KR') {
      mode = modeKr;
      isKr = true;

      homePlusLabel = homePlusLabelKr;
      settingPlusLabel = settingPlusLabelKr;
      homeMultiplyLabel = homeMultiplyLabelKr;
      settingMultiplyLabel = settingMultiplyLabelKr;

      ok = okKr;
      start = startKr;
      check = checkKr;

      settings = settingsKr;
      onlyPluses = onlyPlusesKr;
      speed = speedKr;
      digit = digitKr;
      numOfProblems = numOfProblemsKr;

      setSpeedTitle = setSpeedTitleKr;
      rangeWord = rangeWordKr;
      pleaseInsertValue = pleaseInsertValueKr;
      pleaseTooBigValue = pleaseTooBigValueKr;
      pleaseTooSmallValue = pleaseTooSmallValueKr;

      settingsMultiply = settingsMultiplyKr;
      isMultiply = isMultiplyKr;
      speedMultiply = speedMultiplyKr;
      startDigitMultiply = startDigitMultiplyKr;
      endDigitMultiply = endDigitMultiplyKr;
      numOfProblemsMultiply = numOfProblemsMultiplyKr;

      shulffleDesc = shuffleDescKr;
      rangeMultiplyWord = rangeMultiplyWordKr;
    }
  }
}
