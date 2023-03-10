import 'dart:math';

List<int> getPlusNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (pow(10, digit - 1)).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);
    list[i] = randomNum;
    sum += randomNum;
  }

  list.last = sum;

  return list;
}

List<int> getPlusMinusNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (-pow(10, digit) + 1).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 1; i++) {
    int randomNum = min + Random().nextInt(max - min);

    // num should not be zero.
    while (randomNum == 0) {
      randomNum = min + Random().nextInt(max - min);
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
