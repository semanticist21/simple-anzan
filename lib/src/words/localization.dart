import 'dart:io';
import 'package:abacus_simple_anzan/src/words/const.dart';

class LocalizationChecker {
  final String defaultLocale = Platform.localeName;
  // options(settings)
  static String settings = settingsEn;
  static String onlyPluses = onlyPlusesEn;
  static String speed = speedEn;
  static String digit = digitEn;
  static String numOfProblems = numOfProblemsEn;

  LocalizationChecker() {
    if (defaultLocale == 'ko_KR') {
      settings = settingsKr;
      onlyPluses = onlyPlusesKr;
      speed = speedKr;
      digit = digitKr;
      numOfProblems = numOfProblemsKr;
    }
  }
}
