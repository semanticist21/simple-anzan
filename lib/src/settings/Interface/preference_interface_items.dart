import 'package:abacus_simple_anzan/src/settings/Interface/preference_interface.dart';

abstract class PreferenceInterfaceItems<T, V>
    extends PreferenceInterface<T, V> {
  PreferenceInterfaceItems(super.prefs);
  T itemStrToValue(String str);

  // enum name will be converted appropriate to Items.
  // for example, Slow_07 will be converted to Slow.
  // num_5 will be converted to 5.
  String enumNameToItemString(String name);
  // example
  // List<String> result = List.empty(growable: true);

  //   for (var element in Speed.values) {
  //     var str = enumToString(element.name);
  //     result.add(str);
  //   }

  //   return result;
  List<String> getItemsListofEnum();
}
