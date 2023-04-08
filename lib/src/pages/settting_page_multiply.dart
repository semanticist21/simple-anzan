import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import '../dialog/add_dialog_multiply.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import '../settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import '../settings/multiply_prefs/settings_manager_multiply.dart';
import '../settings/multiply_prefs/prefs/speed_multiply.dart';

class SettingsMultiplyPage extends StatefulWidget {
  const SettingsMultiplyPage({super.key});

  @override
  State<SettingsMultiplyPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsMultiplyPage> {
  final _manager = SettingsMultiplyManager();

  late CalCulationMultiplyMode _isMultiply;
  late SpeedMultiply _speed;
  late BigDigit _startDigit;
  late SmallDigit _endDigit;
  late NumOfMultiplyProblems _numOfProblems;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeValues(_manager);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.9,
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant)),
              child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.9,
                  child: ListView(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        SizedBox(
                            height: Platform.isIOS || Platform.isAndroid
                                ? 0
                                : MediaQuery.of(context).size.height * 0.015),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.015),
                            Text(
                              LocalizationChecker.settingsMultiply,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.023,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Divider(
                          height: 20,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        // plus & minus mode.
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    buildToggleOption(
                                        LocalizationChecker.isMultiply,
                                        Icons.calculate,
                                        _manager.enumToValue<
                                            CalCulationMultiplyMode,
                                            bool>(_isMultiply),
                                        toggleMultiplyModeCallback),
                                    // speed.
                                    buildDropdownButton(
                                        LocalizationChecker.speedMultiply,
                                        Icon(
                                          Icons.speed,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<SpeedMultiply>(
                                            _speed.name),
                                        getDropdownMenuItemList<SpeedMultiply>(
                                            _manager),
                                        changeOptionCallback<SpeedMultiply>),
                                    // digit.
                                    buildDropdownButton(
                                        LocalizationChecker.smallDigitMultiply,
                                        Icon(
                                          CupertinoIcons.number_square,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<SmallDigit>(
                                            _endDigit.name),
                                        getDropdownMenuItemList<SmallDigit>(
                                            _manager),
                                        changeOptionCallback<SmallDigit>),
                                    buildDropdownButton(
                                        LocalizationChecker.bigDigitMultiply,
                                        Icon(
                                          CupertinoIcons.number_square_fill,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<BigDigit>(
                                            _startDigit.name),
                                        getDropdownMenuItemList<BigDigit>(
                                            _manager),
                                        changeOptionCallback<BigDigit>),
                                    // num of problems.
                                    buildDropdownButton(
                                        LocalizationChecker
                                            .numOfProblemsMultiply,
                                        Icon(
                                          Icons.check,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager
                                            .getItemStr<NumOfMultiplyProblems>(
                                                _numOfProblems.name),
                                        getDropdownMenuItemList<
                                            NumOfMultiplyProblems>(_manager),
                                        changeOptionCallback<
                                            NumOfMultiplyProblems>),
                                    const SizedBox(height: 50),
                                  ])),
                        )
                      ]))),
        ),
      ),
    ));
  }

  Padding buildToggleOption(String title, IconData iconData, bool value,
      Function(bool) onChangeMethod) {
    return getPadding(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Icon(iconData, color: Theme.of(context).colorScheme.primaryContainer),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.0185,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primaryContainer))
      ]),
      Transform.scale(
          scale: 0.9,
          filterQuality: FilterQuality.high,
          child: CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.onSecondary,
              trackColor: Theme.of(context).colorScheme.onPrimary,
              value: value,
              onChanged: (bool newValue) => onChangeMethod(newValue))),
    ]));
  }

  toggleMultiplyModeCallback(bool newValue) {
    setState(() {
      _isMultiply =
          _manager.valueToEnum<bool, CalCulationMultiplyMode>(newValue);
    });

    _manager.saveSetting(_isMultiply);
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
          flex: 10,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primaryContainer))
            ],
          )),
      Flexible(
          flex: 10,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: DropdownButtonFormField(
                  dropdownColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  elevation: 0,
                  isDense: true,
                  itemHeight: 50,
                  value: initialValue,
                  iconSize: 25,
                  isExpanded: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(),
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      floatingLabelAlignment: FloatingLabelAlignment.center),
                  items: dropdownMenuItemList,
                  onChanged: onChangeMethod,
                ),
              )))
    ]));
  }

  void changeOptionCallback<T>(dynamic value) {
    switch (T) {
      case SpeedMultiply:
        if (value == 'custom') {
          showDialog(
              context: context,
              builder: (context) => AddDialogMultiply(
                  defaultValue: _manager
                      .getCurrentValue<SpeedMultiply, Duration>()
                      .inMilliseconds
                      .toString())).then(
              (value) => _manager.saveCustomSpeedSetting(int.parse(value)));
        }

        _speed = _manager.itemStrToEnum<SpeedMultiply>(value);
        _manager.saveSetting(_speed);
        break;
      case BigDigit:
        _startDigit = _manager.itemStrToEnum<BigDigit>(value);
        _manager.saveSetting(_startDigit);
        break;
      case SmallDigit:
        if (int.parse(value) > _manager.getCurrentValue<BigDigit, int>()) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    LocalizationChecker.warning,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  content: Text(LocalizationChecker.insertBigger,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Theme.of(context).colorScheme.onBackground)),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              LocalizationChecker.ok,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            )))
                  ],
                );
              });

          return;
        }

        _endDigit = _manager.itemStrToEnum<SmallDigit>(value);
        _manager.saveSetting(_endDigit);
        break;
      case NumOfMultiplyProblems:
        _numOfProblems = _manager.itemStrToEnum<NumOfMultiplyProblems>(value);
        _manager.saveSetting(_numOfProblems);
        break;
    }
  }

  List<DropdownMenuItem<String>> getDropdownMenuItemList<T>(
      SettingsMultiplyManager manager) {
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
                height: Platform.isWindows
                    ? MediaQuery.of(context).size.height * 0.0035
                    : MediaQuery.of(context).size.height * 0.0017,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: MediaQuery.of(context).size.height * 0.0185,
                fontWeight: FontWeight.w500),
          ));
      itemList.add(item);
    }

    return itemList;
  }

  Padding getPadding(Widget? widget) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: widget,
    );
  }

  void initializeValues(SettingsMultiplyManager manager) {
    setState(() {
      _isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
      _speed = manager.getCurrentEnum<SpeedMultiply>();
      _startDigit = manager.getCurrentEnum<BigDigit>();
      _endDigit = manager.getCurrentEnum<SmallDigit>();
      _numOfProblems = manager.getCurrentEnum<NumOfMultiplyProblems>();
    });
  }
}
