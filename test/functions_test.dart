import 'package:abacus_simple_anzan/src/functions/functions.dart';
import 'package:abacus_simple_anzan/src/functions/tuple.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test get multiply nums', () {
    var tuple = Tuple(-1, -1);

    for (var i = 0; i < 10000; i++) {
      getMultiplyNums(2, 3, 1, tuple);
    }
    for (var i = 0; i < 10000; i++) {
      getDivdieNums(1, 3, 1, tuple);
    }
  }, timeout: const Timeout(Duration(seconds: 5)));
}
