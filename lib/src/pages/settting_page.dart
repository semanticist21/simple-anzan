import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/seperator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';
import 'package:universal_io/io.dart';

import '../dialog/add_dialog.dart';
import '../settings/plus_pref/prefs/calculation_mode_pref.dart';
import '../settings/plus_pref/prefs/digit_pref.dart';
import '../settings/plus_pref/prefs/num_of_problems_pref.dart';
import '../settings/plus_pref/prefs/shuffle.dart';
import '../settings/plus_pref/prefs/speed.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _manager = SettingsManager();

  late CalculationMode _isOnlyPlus;
  late ShuffleMode _isShuffle;
  late Speed _speed;
  late Digit _digit;
  late NumOfProblems _numOfProblems;
  late CountDownMode _countDownMode;
  late SeperatorMode _seperatorMode;

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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
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
                                  width: MediaQuery.of(context).size.width *
                                      0.015),
                              Text(
                                LocalizationChecker.settings,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.023,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                              )
                            ],
                          ),
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
                                        LocalizationChecker.onlyPluses,
                                        Icons.calculate,
                                        _manager.enumToValue<CalculationMode,
                                            bool>(_isOnlyPlus),
                                        togglePlusModeCallback),
                                    Tooltip(
                                        message:
                                            LocalizationChecker.shulffleDesc,
                                        child: buildToggleOption(
                                            LocalizationChecker.shuffle,
                                            Icons.shuffle,
                                            _manager.enumToValue<ShuffleMode,
                                                bool>(_isShuffle),
                                            toggleShuffleModeCallback)),
                                    // speed.
                                    buildDropdownButton(
                                        LocalizationChecker.speed,
                                        Icon(
                                          Icons.speed,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<Speed>(_speed.name),
                                        getDropdownMenuItemList<Speed>(
                                            _manager),
                                        changeOptionCallback<Speed>),
                                    // digit.
                                    buildDropdownButton(
                                        LocalizationChecker.digit,
                                        Icon(
                                          Icons.onetwothree,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<Digit>(_digit.name),
                                        getDropdownMenuItemList<Digit>(
                                            _manager),
                                        changeOptionCallback<Digit>),
                                    // num of problems.
                                    buildDropdownButton(
                                        LocalizationChecker.numOfProblems,
                                        Icon(
                                          Icons.check,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<NumOfProblems>(
                                            _numOfProblems.name),
                                        getDropdownMenuItemList<NumOfProblems>(
                                            _manager),
                                        changeOptionCallback<NumOfProblems>),
                                    Tooltip(
                                      message: LocalizationChecker.seperator,
                                      child: buildToggleOption(
                                          LocalizationChecker.seperator,
                                          Icons.one_k,
                                          _manager.enumToValue<SeperatorMode,
                                              bool>(_seperatorMode),
                                          toggleSepartorModeCallback),
                                    ),
                                    Tooltip(
                                      message:
                                          LocalizationChecker.shouldSoundOnDesc,
                                      child: buildToggleOption(
                                          LocalizationChecker.notify,
                                          Icons.notifications,
                                          _manager.enumToValue<CountDownMode,
                                              bool>(_countDownMode),
                                          toggleCounterModeCallback),
                                    ),
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
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Icon(iconData, color: Theme.of(context).colorScheme.primaryContainer),
          const SizedBox(width: 10),
          Text(title,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0185,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primaryContainer))
        ]),
      ),
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

  togglePlusModeCallback(bool newValue) {
    setState(() {
      _isOnlyPlus = _manager.valueToEnum<bool, CalculationMode>(newValue);
    });

    _manager.saveSetting(_isOnlyPlus);
    initializeValues(_manager);
  }

  toggleShuffleModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, ShuffleMode>(newValue);
      _isShuffle = valueToEnum;
    });

    _manager.saveSetting(_isShuffle);
    initializeValues(_manager);
  }

  toggleSepartorModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, SeperatorMode>(newValue);
      _seperatorMode = valueToEnum;
    });

    _manager.saveSetting(_seperatorMode);
    initializeValues(_manager);
  }

  toggleCounterModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, CountDownMode>(newValue);
      _countDownMode = valueToEnum;
    });

    _manager.saveSetting(_countDownMode);
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
            ),
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
      case Speed:
        if (value == 'custom') {
          showDialog(
              context: context,
              builder: (context) => AddDialog(
                  defaultValue: _manager
                      .getCurrentValue<Speed, Duration>()
                      .inMilliseconds
                      .toString())).then(
              (value) => _manager.saveCustomSpeedSetting(int.parse(value)));
        }

        _speed = _manager.itemStrToEnum<Speed>(value);
        _manager.saveSetting(_speed);
        break;
      case Digit:
        _digit = _manager.itemStrToEnum<Digit>(value);
        _manager.saveSetting(_digit);
        break;
      case NumOfProblems:
        _numOfProblems = _manager.itemStrToEnum<NumOfProblems>(value);
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
                height: Platform.isWindows
                    ? MediaQuery.of(context).size.height * 0.00135
                    : MediaQuery.of(context).size.height * 0.0017 > 1
                        ? MediaQuery.of(context).size.height * 0.0017
                        : 1,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Platform.isWindows
                    ? MediaQuery.of(context).size.height * 0.0175
                    : MediaQuery.of(context).size.height * 0.0185,
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

  void initializeValues(SettingsManager manager) {
    setState(() {
      _isOnlyPlus = manager.getCurrentEnum<CalculationMode>();
      _isShuffle = manager.getCurrentEnum<ShuffleMode>();
      _speed = manager.getCurrentEnum<Speed>();
      _digit = manager.getCurrentEnum<Digit>();
      _numOfProblems = manager.getCurrentEnum<NumOfProblems>();
      _countDownMode = manager.getCurrentEnum<CountDownMode>();
      _seperatorMode = manager.getCurrentEnum<SeperatorMode>();
    });
  }
}
