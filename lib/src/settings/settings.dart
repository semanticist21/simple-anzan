// import 'package:shared_preferences/shared_preferences.dart';

// class Settings {
//   // constructor
//   Settings(SharedPreferences prefs) {
//     currentCalculationModeIndex = prefs.getInt(calculationModeKey) ?? 0;
//     currentSpeedIndex = prefs.getInt(speedKey) ?? 3;
//     currentDigit = prefs.getInt(digitKey) ?? 2;
//     currentNumOfProblems = prefs.getInt(numOfProblemsKey) ?? 0;
//   }

//   // keys
//   static String calculationModeKey = "modes";
//   static String numOfProblemsKey = "numprops";
//   static String speedKey = "interval";
//   static String digitKey = "digit";

//   // current mode states
//   static int currentCalculationModeIndex = 0;
//   static int currentSpeedIndex = 2;
//   static int currentDigit = 2;
//   static int currentNumOfProblems = 0;

//   void setModeIndex(int index) {
//     currentCalculationModeIndex = index;
//   }

//   void setSpeed(int index) {
//     currentCalculationModeIndex = index;
//   }

//   void setDigit(int digit) {
//     currentDigit = digit;
//   }

//   void setNumOfProblems(int num) {
//     currentNumOfProblems = num;
//   }
// }

// // enum CalculationMode {
// //   onlyPlus,
// //   plusMinus,
// // }

// // enum Digit {
// //   one_1,
// //   two_2,
// //   three_3,
// //   four_4,
// //   five_5,
// // }

// // // insert number behind '_'
// // enum NumOfProblems {
// //   n_5,
// //   n_10,
// //   n_15,
// //   n_20,
// // }

// // // very slow : 1 sec
// // // slow : 0.7 sec
// // // normal : 0.5 sec
// // // fast : 0.3 sec
// // // insert interval behind '_'
// // enum Speed {
// //   verySlow_10,
// //   slow_07,
// //   normal_05,
// //   fast_03,
// //   veryFast_02,
// // }
