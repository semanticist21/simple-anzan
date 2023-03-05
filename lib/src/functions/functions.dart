import 'dart:math';

List<int> getAddNums(int digit, int numOfNums) {
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

List<int> getAddMinusNums(int digit, int numOfNums) {
  var list = List.filled(numOfNums + 1, 0);

  int min = (pow(10, digit) + 1).toInt();
  int max = (pow(10, digit) - 1).toInt();

  int len = list.length;
  int sum = 0;

  for (int i = 0; i < len - 2; i++) {
    int randomNum = min + Random().nextInt(max - min);
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

  var lastNum = 0;

  if (sum < 0) {
    int min = sum;
    int max = (pow(10, digit) - 1).toInt();
    lastNum = min + Random().nextInt(max - min);
    list[len - 2] = lastNum;
  } else {
    lastNum = min + Random().nextInt(max - min);
    list[len - 2] = lastNum;
  }

  list.last = sum;

  return list;
}
