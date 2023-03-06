import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abacus_simple_anzan/src/const/const.dart';
import 'package:abacus_simple_anzan/src/settings/settings_manager.dart';

import '../settings/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _manager = SettingsManager();

  late CalculationMode _isOnlyPlus;
  late Speed _speed;
  late Digit _digit;
  late NumOfProblems _numOfProblems;

  @override
  void initState() {
    super.initState();
    initializeValues(_manager);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Container(
      color: const ColorScheme.dark().background,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.6,
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(158, 158, 158, 0.1),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: const Color.fromRGBO(96, 125, 139, 0.1))),
            child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 1,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var isBiggerSize = false;
                    if (constraints.maxHeight > 420) {
                      isBiggerSize = true;
                    }

                    return ListView(children: [
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            settings,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: defaultFontFamily,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        color: Color.fromARGB(255, 60, 60, 60),
                      ),
                      const SizedBox(height: 5),
                      // plus & minus mode.
                      SizedBox(
                          height:
                              isBiggerSize ? constraints.maxHeight * 0.7 : null,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildToggleOption(
                                    onlyPluses,
                                    _manager.calculationModeToBool(_isOnlyPlus),
                                    togglePlusModeCallback),

                                // speed.
                                buildDropdownButton(
                                    speed,
                                    const Icon(
                                      Icons.speed,
                                      color: Colors.grey,
                                    ),
                                    _manager.getSpeedStr(_speed.name),
                                    getDropdownMenuItemList<Speed>(_manager),
                                    changeOptionCallback<Speed>),
                                // digit.
                                buildDropdownButton(
                                    digit,
                                    const Icon(
                                      Icons.onetwothree,
                                      color: Colors.grey,
                                    ),
                                    _manager.getDigitStr(_digit.name),
                                    getDropdownMenuItemList<Digit>(_manager),
                                    changeOptionCallback<Digit>),
                                // num of problems.
                                buildDropdownButton(
                                    numOfProblems,
                                    const Icon(
                                      Icons.check,
                                      color: Colors.grey,
                                    ),
                                    _manager.getNumOfProblemsStr(
                                        _numOfProblems.name),
                                    getDropdownMenuItemList<NumOfProblems>(
                                        _manager),
                                    changeOptionCallback<NumOfProblems>)
                              ])),
                    ]);
                  },
                )),
          ),
        ),
      ),
    ));
  }

  Padding buildToggleOption(
      String title, bool value, Function(bool) onChangeMethod) {
    return getPadding(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const Icon(Icons.calculate, color: Colors.grey),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]))
      ]),
      Transform.scale(
          scale: 0.7,
          filterQuality: FilterQuality.high,
          child: CupertinoSwitch(
              activeColor: Colors.blueGrey,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) => onChangeMethod(newValue))),
    ]));
  }

  togglePlusModeCallback(bool newValue) {
    setState(() {
      _isOnlyPlus = _manager.boolToCalculationMode(newValue);
    });

    _manager.saveSetting(_isOnlyPlus);
    initializeValues(_manager);
  }

  Padding buildDropdownButton(
      String title,
      Icon icon,
      String initialValue,
      List<DropdownMenuItem<dynamic>> dropdownMenuItemList,
      Function(dynamic) onChangeMethod) {
    return getPadding(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 8,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]))
            ],
          )),
      Flexible(
          flex: 10,
          child: FractionallySizedBox(
              widthFactor: 1,
              child: Transform.scale(
                scaleX: 0.8,
                scaleY: 0.8,
                alignment: Alignment.centerRight,
                child: DropdownButtonFormField(
                  isDense: true,
                  value: initialValue,
                  iconSize: 25,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(),
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      floatingLabelAlignment: FloatingLabelAlignment.center),
                  items: dropdownMenuItemList,
                  onChanged: onChangeMethod,
                ),
              )))
    ]));
  }

  void changeOptionCallback<T>(dynamic value) {
    switch (T) {
      case Speed:
        _speed = _manager.strToSpeed(value);
        _manager.saveSetting(_speed);
        break;
      case Digit:
        _digit = _manager.strToDigit(value);
        _manager.saveSetting(_digit);
        break;
      case NumOfProblems:
        _numOfProblems = _manager.strToNumOfProblems(value);
        _manager.saveSetting(_numOfProblems);
        break;
    }
  }

  List<DropdownMenuItem<String>> getDropdownMenuItemList<T>(
      SettingsManager manager) {
    var list = manager.getItemsListOfEnum<T>();
    List<DropdownMenuItem<String>> itemList = List.empty(growable: true);

    bool isNumber = false;
    if (int.tryParse(list.first) != null) {
      isNumber = true;
    }

    for (var element in list) {
      var item = DropdownMenuItem<String>(
          alignment: isNumber ? Alignment.center : Alignment.centerLeft,
          value: element,
          child: Text(
            element,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ));
      itemList.add(item);
    }

    return itemList;
  }

  Padding getPadding(Widget? widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: widget,
    );
  }

  void initializeValues(SettingsManager manager) {
    setState(() {
      _isOnlyPlus = manager.mode();
      _speed = manager.speed();
      _digit = manager.digit();
      _numOfProblems = manager.numOfProblems();
    });
  }
}
