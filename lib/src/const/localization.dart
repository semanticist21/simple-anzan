import 'package:abacus_simple_anzan/src/const/const.dart';
import 'package:universal_io/io.dart';

class LocalizationChecker {
  static String appName = appNameEn;

  static String defaultLocale = Platform.localeName;
  static bool isKr = false;

  // bottom navigation
  static String homePlusLabel = homePlusLabelEn;
  static String settingPlusLabel = settingPlusLabelEn;
  static String homeMultiplyLabel = homeMultiplyLabelEn;
  static String settingMultiplyLabel = settingMultiplyLabelEn;

  // theme str
  static String mode = modeEn;
  static String soundOn = soundEn;

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
  static String bigDigitMultiply = bigDigitMultiplyEn;
  static String smallDigitMultiply = smallDigitMultiplyEn;
  static String numOfProblemsMultiply = numOfProblemsMultiplyEn;

  static String rangeMultiplyWord = rangeMultiplyWordEn;
  static String shulffleDesc = shuffleDescEn;

  static String insertBigger = insertBiggerEn;

  // prob list
  static String noProbExecuted = noProbExecutedEn;
  static String checkProb = checkProbEn;
  static String checkProbQ = checkProbQEn;

  static String problem = problemEn;
  static String answer = answerEn;

  // other
  static String warning = warningEn;

  LocalizationChecker() {
    if (defaultLocale == 'ko_KR') {
      appName = appNameKr;

      mode = modeKr;
      soundOn = soundKr;
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
      bigDigitMultiply = bigDigitMultiplyKr;
      smallDigitMultiply = smallDigitMultiplyKr;
      numOfProblemsMultiply = numOfProblemsMultiplyKr;

      insertBigger = insertBiggerKr;

      shulffleDesc = shuffleDescKr;
      rangeMultiplyWord = rangeMultiplyWordKr;

      noProbExecuted = noProbExecutedKr;
      checkProb = checkProbKr;
      checkProbQ = checkProbKr;

      problem = problemKr;
      answer = answerKr;

      warning = warningKr;
    }
  }
}
