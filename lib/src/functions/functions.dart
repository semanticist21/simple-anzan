import 'dart:math';

import 'package:abacus_simple_anzan/src/functions/tuple.dart';

List<int> getPlusShuffleNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = 1;
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);
    while (randomNum % 100 == 0) {
      randomNum = min + Random().nextInt(max - min);
    }

    int digitNormalization = Random().nextInt(8);
    if (digitNormalization == 0 && randomNum ~/ 10 != 0) {
      randomNum = randomNum ~/ 10;
    }

    if (digitNormalization == 1 && randomNum ~/ 100 != 0) {
      randomNum = randomNum ~/ 100;
    }

    if (digitNormalization == 2 && randomNum ~/ 1000 != 0) {
      randomNum = randomNum ~/ 1000;
    }

    list[i] = randomNum;
    sum += randomNum;
  }

  list.last = sum;

  return list;
}

List<int> getPlusMinusShuffleNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (-pow(10, digit) + 1).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);

    // num should not be zero.
    // randomNum % 10 == 0 not to make easy.
    while (randomNum == 0 || randomNum % 100 == 0) {
      randomNum = min + Random().nextInt(max - min);
    }

    //
    int digitNormalization = Random().nextInt(6);
    if (digitNormalization == 0 && randomNum ~/ 10 != 0) {
      randomNum = randomNum ~/ 10;
    }

    if (digitNormalization == 1 && randomNum ~/ 100 != 0) {
      randomNum = randomNum ~/ 100;
    }

    if (digitNormalization == 2 && randomNum ~/ 1000 != 0) {
      randomNum = randomNum ~/ 1000;
    }

    list[i] = randomNum;
    sum += randomNum;

    // considering abacus, the number can't be under 0.
    // if the answer is low than 0, than give large number to compensate.
    if (sum < 0) {
      randomNum = -randomNum;
      list[i] = randomNum;
      sum += randomNum * 2;
    }
  }

  list.last = sum;

  return list;
}

List<int> getPlusNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (pow(10, digit - 1)).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);

    while (randomNum == 0 || randomNum % 100 == 0) {
      randomNum = min + Random().nextInt(max - min);
    }

    list[i] = randomNum;
    sum += randomNum;
  }

  list.last = sum;

  return list;
}

List<int> getPlusMinusNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (pow(10, digit - 1)).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);
    bool randomFlag = Random().nextBool();

    if (!randomFlag) {
      randomNum = -randomNum;
    }

    // num should not be zero.
    // randomNum % 10 == 0 not to make easy.
    while (randomNum == 0 || randomNum % 100 == 0) {
      randomNum = min + Random().nextInt(max - min);
      bool randomFlag = Random().nextBool();
      if (!randomFlag) {
        randomNum = -randomNum;
      }
    }

    list[i] = randomNum;
    sum += randomNum;

    // considering abacus, the number can't be under 0.
    // if the answer is low than 0, than give large number to compensate.
    if (sum < 0) {
      randomNum = -randomNum;
      list[i] = randomNum;
      sum += randomNum * 2;
    }
  }

  list.last = sum;

  return list;
}

// multiply zone
// always divideDigit is smaller than startDigit.
List<Tuple<int, int>> getMultiplyNums(
    int smallDigit, int bigDigit, int numOfNums) {
  var list = List<Tuple<int, int>>.empty(growable: true);

  var min = (pow(10, bigDigit - 1)).toInt();
  var max = (pow(10, bigDigit) - 1).toInt();

  var minSecond = (pow(10, smallDigit - 1)).toInt();
  var maxSecond = (pow(10, smallDigit) - 1).toInt();

  for (var i = 0; i < numOfNums; i++) {
    var firstGen = min + Random().nextInt(max - min);
    while (firstGen == 0 || firstGen % 10 == 0 || firstGen == 1) {
      firstGen = min + Random().nextInt(max - min);
    }

    var secondGen = minSecond + Random().nextInt(maxSecond - minSecond);
    while (secondGen == 0 || secondGen % 10 == 0 || secondGen == 1) {
      secondGen = minSecond + Random().nextInt(maxSecond - minSecond);
    }

    list.add(Tuple(secondGen, firstGen));
  }

  return list;
}

List<Tuple<int, int>> getDivdieNums(
    int divideDigit, int bigDigit, int numOfNums) {
  var list = List<Tuple<int, int>>.empty(growable: true);
  var max = pow(10, bigDigit) - 1;

  if (bigDigit == 1 && divideDigit == 1) {
    for (var i = 0; i < numOfNums; i++) {
      var minSame = pow(10, bigDigit - 1).toInt();
      var maxSame = ((pow(10, bigDigit) ~/ 2)).toInt();

      var divideNum = minSame + Random().nextInt(maxSame - minSame);
      var multiplier = Random().nextInt(10) + 1;

      while (multiplier * divideNum > max ||
          multiplier == 1 ||
          divideNum == 1 ||
          divideNum % 10 == 0 ||
          multiplier % 10 == 0) {
        divideNum = minSame + Random().nextInt(maxSame - minSame);
        multiplier = Random().nextInt(10) + 1;
      }

      list.add(Tuple(multiplier * divideNum, divideNum));
    }
  } else if (bigDigit == divideDigit) {
    for (var i = 0; i < numOfNums; i++) {
      var minSame = pow(10, bigDigit - 1).toInt();
      var maxSame = ((pow(10, bigDigit) ~/ 2) - 1).toInt();

      var divideNum = minSame + Random().nextInt(maxSame - minSame);
      var multiplier = Random().nextInt(10) + 1;

      while (multiplier * divideNum > max ||
          multiplier == 1 ||
          divideNum == 1 ||
          divideNum % 10 == 0 ||
          multiplier % 10 == 0) {
        divideNum = minSame + Random().nextInt(maxSame - minSame);
        multiplier = Random().nextInt(10) + 1;
      }

      list.add(Tuple(multiplier * divideNum, divideNum));
    }
  } else {
    for (var i = 0; i < numOfNums; i++) {
      var minDiff = pow(10, divideDigit - 1).toInt();
      var maxDiff = (pow(10, divideDigit) - 1).toInt();

      var multiplierDigit = bigDigit - divideDigit;
      var minMultiplier = pow(10, multiplierDigit - 1).toInt();
      var maxMultiplier = (pow(10, multiplierDigit) - 1).toInt();

      var divideNum = minDiff + Random().nextInt(maxDiff - minDiff);
      var multiplier =
          minMultiplier + Random().nextInt(maxMultiplier - minMultiplier);

      while (multiplier * divideNum > max ||
          multiplier == 1 ||
          divideNum == 1 ||
          divideNum % 10 == 0 ||
          multiplier % 10 == 0) {
        divideNum = minDiff + Random().nextInt(maxDiff - minDiff);
        multiplier =
            minMultiplier + Random().nextInt(maxMultiplier - minMultiplier);
      }

      list.add(Tuple(multiplier * divideNum, divideNum));
    }
  }
  return list;
}
