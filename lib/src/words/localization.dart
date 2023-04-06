import 'package:abacus_simple_anzan/src/words/const.dart';
import 'package:universal_io/io.dart';

class LocalizationChecker {
  static String defaultLocale = Platform.localeName;
  static bool isKr = false;

  // button str
  static String start = startEn;
  static String check = checkEn;

  // options(settings)
  static String settings = settingsEn;
  static String onlyPluses = onlyPlusesEn;
  static String speed = speedEn;
  static String digit = digitEn;
  static String numOfProblems = numOfProblemsEn;

  static String setSpeedTitle = setSpeedTitleEn;
  static String rangeWord = rangeWordEn;
  static String pleaseInsertValue = pleaseInsertValueEn;
  static String pleaseTooBigValue = pleaseTooBigValueEn;
  static String pleaseTooSmallValue = pleaseTooSmallValueEn;

  LocalizationChecker() {
    if (defaultLocale == 'ko_KR') {
      isKr = true;

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
    }
  }
}
