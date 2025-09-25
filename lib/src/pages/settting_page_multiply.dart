import 'package:abacus_simple_anzan/src/dialog/custom_alert_dialog.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/seperator_multiply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import '../dialog/add_dialog_multiply.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../settings/multiply_prefs/prefs/countdown_mode.dart';
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
  late BigDigit _bigDigit;
  late SmallDigit _smallDigit;
  late NumOfMultiplyProblems _numOfProblems;
  late CountDownMultiplyMode _countDownMode;
  late SeperatorMultiplyMode _seperatorMode;

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
                                'settingsMultiply.title'.tr(),
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
                                        'settingsMultiply.isMultiply'.tr(),
                                        Icons.calculate,
                                        _manager.enumToValue<
                                            CalCulationMultiplyMode,
                                            bool>(_isMultiply),
                                        toggleMultiplyModeCallback),
                                    // speed.
                                    buildDropdownButton(
                                        'settingsMultiply.speed'.tr(),
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
                                        'settingsMultiply.smallDigit'.tr(),
                                        Icon(
                                          CupertinoIcons.number_square,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<SmallDigit>(
                                            _smallDigit.name),
                                        getDropdownMenuItemList<SmallDigit>(
                                            _manager),
                                        changeOptionCallback<SmallDigit>),
                                    buildDropdownButton(
                                        'settingsMultiply.bigDigit'.tr(),
                                        Icon(
                                          CupertinoIcons.number_square_fill,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        _manager.getItemStr<BigDigit>(
                                            _bigDigit.name),
                                        getDropdownMenuItemList<BigDigit>(
                                            _manager),
                                        changeOptionCallback<BigDigit>),
                                    Tooltip(
                                      message: 'settings.separator'.tr(),
                                      child: buildToggleOption(
                                          'settings.separator'.tr(),
                                          Icons.one_k,
                                          _manager.enumToValue<
                                              SeperatorMultiplyMode,
                                              bool>(_seperatorMode),
                                          toggleSeperatorModoeCallback),
                                    ),
                                    Tooltip(
                                      message:
                                          'customOptions.shouldSoundOnDesc'.tr(),
                                      child: buildToggleOption(
                                          'settings.notify'.tr(),
                                          Icons.notifications,
                                          _manager.enumToValue<
                                              CountDownMultiplyMode,
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
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
              value: value,
              onChanged: (bool newValue) => onChangeMethod(newValue))),
    ]));
  }

  void toggleMultiplyModeCallback(bool newValue) {
    setState(() {
      _isMultiply =
          _manager.valueToEnum<bool, CalCulationMultiplyMode>(newValue);
    });

    _manager.saveSetting(_isMultiply);
    initializeValues(_manager);
  }

  void toggleSeperatorModoeCallback(bool newValue) {
    setState(() {
      _seperatorMode =
          _manager.valueToEnum<bool, SeperatorMultiplyMode>(newValue);
    });

    _manager.saveSetting(_seperatorMode);
    initializeValues(_manager);
  }

  void toggleCounterModeCallback(bool newValue) {
    setState(() {
      var valueToEnum =
          _manager.valueToEnum<bool, CountDownMultiplyMode>(newValue);
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
          flex: 19,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.024,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primaryContainer))
              ],
            ),
          )),
      Flexible(
          flex: 20,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: DropdownButtonFormField(
                  dropdownColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  elevation: 0,
                  isDense: true,
                  itemHeight: 54,
                  initialValue: initialValue,
                  iconSize: 25,
                  isExpanded: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
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
      case const (SpeedMultiply):
        if (value == 'custom') {
          // When custom is selected, show the dialog and handle the result
          showDialog(
              context: context,
              builder: (context) => AddDialogMultiply(
                  defaultValue: _manager
                      .getCurrentValue<SpeedMultiply, Duration>()
                      .inMilliseconds
                      .toString())).then((dialogValue) {
            if (dialogValue != null) {
              // Only save the custom speed setting if a value was returned
              _manager.saveCustomSpeedSetting(int.parse(dialogValue));
              _manager.saveSetting(SpeedMultiply.custom);
            }
          });
        } else {
          // Only set and save the speed if a non-custom value was selected
          _speed = _manager.itemStrToEnum<SpeedMultiply>(value);
          _manager.saveSetting(_speed);
        }
        break;
      case const (BigDigit):
        _manager.getCurrentValue<SmallDigit, int>();
        if (int.parse(value) < _manager.getCurrentValue<SmallDigit, int>()) {
          showDialog(
              context: context,
              builder: (context) => getAlertWarningDialog(context));
          return;
        }

        _bigDigit = _manager.itemStrToEnum<BigDigit>(value);
        _manager.saveSetting(_bigDigit);
        break;
      case const (SmallDigit):
        if (int.parse(value) > _manager.getCurrentValue<BigDigit, int>()) {
          showDialog(
              context: context,
              builder: (context) => getAlertWarningDialog(context));
          return;
        }

        _smallDigit = _manager.itemStrToEnum<SmallDigit>(value);
        _manager.saveSetting(_smallDigit);
        break;
      case const (NumOfMultiplyProblems):
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
                    ? MediaQuery.of(context).size.height * 0.00135
                    : MediaQuery.of(context).size.height * 0.0017 > 1
                        ? MediaQuery.of(context).size.height * 0.0017
                        : 1,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Platform.isWindows
                    ? MediaQuery.of(context).size.height * 0.020
                    : MediaQuery.of(context).size.height * 0.018,
                fontWeight: FontWeight.w500),
          ));
      itemList.add(item);
    }

    return itemList;
  }

  Padding getPadding(Widget? widget) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.015,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: widget,
    );
  }

  void initializeValues(SettingsMultiplyManager manager) {
    setState(() {
      _isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
      _speed = manager.getCurrentEnum<SpeedMultiply>();
      _bigDigit = manager.getCurrentEnum<BigDigit>();
      _smallDigit = manager.getCurrentEnum<SmallDigit>();
      _numOfProblems = manager.getCurrentEnum<NumOfMultiplyProblems>();
      _countDownMode = manager.getCurrentEnum<CountDownMultiplyMode>();
      _seperatorMode = manager.getCurrentEnum<SeperatorMultiplyMode>();
    });
  }

  Widget getAlertWarningDialog(BuildContext context) {
    return CustomAlert(
        content: 'customOptions.insertBigger'.tr(),
        title: 'other.warning'.tr());
  }
}
