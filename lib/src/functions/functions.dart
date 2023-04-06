import 'dart:math';

List<int> getPlusShuffleNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = 1;
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);
    while (randomNum % 10 == 0) {
      randomNum = min + Random().nextInt(max - min);
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
    int randomNum = Random().nextInt(max - min) - min;

    // num should not be zero.
    // randomNum % 10 == 0 not to make easy.
    while (randomNum == 0 || randomNum % 10 == 0) {
      randomNum = Random().nextInt(max - min) - min;
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

    while (randomNum % 10 == 0) {
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
    while (randomNum == 0 || randomNum % 10 == 0) {
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
