import 'package:abacus_simple_anzan/client.dart';
import 'package:abacus_simple_anzan/src/dialog/custom_alert_dialog.dart';
import 'package:abacus_simple_anzan/src/dialog/custom_preset_form_dialog.dart';
import 'package:abacus_simple_anzan/src/functions/hash.dart';
import 'package:abacus_simple_anzan/src/model/preset_multiply_model.dart';
import 'package:abacus_simple_anzan/src/model/save_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import 'package:easy_localization/easy_localization.dart';
import '../settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import '../settings/multiply_prefs/prefs/countdown_mode.dart';
import '../settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import '../settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import '../settings/multiply_prefs/prefs/num_of_problems_pref_multiply.dart';
import '../settings/multiply_prefs/prefs/speed_multiply.dart';
import '../settings/multiply_prefs/settings_manager_multiply.dart';
import 'add_dialog_multiply.dart';

class WindowsAddOptionMultiplyDialog extends StatefulWidget {
  const WindowsAddOptionMultiplyDialog({super.key});

  @override
  State<WindowsAddOptionMultiplyDialog> createState() =>
      _WindowsAddOptionMultiplyDialogState();
}

class _WindowsAddOptionMultiplyDialogState
    extends State<WindowsAddOptionMultiplyDialog> {
  final _manager = SettingsMultiplyManager();
  final GlobalKey<FormFieldState> _bigDigitKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _smallDigitKey = GlobalKey<FormFieldState>();

  late CalCulationMultiplyMode _isMultiply;
  late SpeedMultiply _speed;
  late BigDigit _bigDigit;
  late SmallDigit _smallDigit;
  late NumOfMultiplyProblems _numOfProblems;
  late CountDownMultiplyMode _countDownMode;

  final _controller = ScrollController();
  var _indicatorVisible = false;

  @override
  void initState() {
    super.initState();
    initializeValues(_manager);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        content: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 600, maxWidth: 800, maxHeight: 800),
              child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                      child: Scaffold(
                          appBar: AppBar(
                            leading: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                size: MediaQuery.of(context).size.height * 0.03,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              splashRadius: 10,
                            ),
                            automaticallyImplyLeading: false,
                            title: Text('settings.title'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer)),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          body: Column(children: [
                            Expanded(
                              flex: 6,
                              child: SingleChildScrollView(
                                controller: _controller,
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                child: Column(children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005),
                                  // plus & minus mode.
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // plus & minus mode.
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
                                            getDropdownMenuItemList<
                                                SpeedMultiply>(_manager),
                                            changeOptionCallback<
                                                SpeedMultiply>),
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
                                            changeOptionCallback<SmallDigit>,
                                            formKey: _smallDigitKey),
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
                                            changeOptionCallback<BigDigit>,
                                            formKey: _bigDigitKey),
                                        buildToggleOption(
                                            'settings.notify'.tr(),
                                            Icons.notifications,
                                            _manager.enumToValue<
                                                CountDownMultiplyMode,
                                                bool>(_countDownMode),
                                            toggleCounterModeCallback),
                                        const SizedBox(height: 50),
                                      ]),
                                ]),
                              ),
                            ),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                  Divider(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                            child: Visibility(
                                                visible: _indicatorVisible,
                                                child:
                                                    const CircularProgressIndicator())),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const CustomPresetFormDialog(
                                                      title: '프리셋 저장 (현재 값 기준)',
                                                      hintWord:
                                                          '저장할 아이템 이름을 입력하세요.',
                                                    )).then((value) async {
                                              if (value is SaveInfo) {
                                                var newItem = PresetMultiplyModel(
                                                    id: getHashId(),
                                                    name: value.name,
                                                    colorCode: value.colorCode,
                                                    textColorCode:
                                                        value.textColorCode,
                                                    calculationMode: _manager
                                                        .getCurrentEnum<
                                                            CalCulationMultiplyMode>()
                                                        .index,
                                                    speedIndex: _manager
                                                        .getCurrentEnum<
                                                            SpeedMultiply>()
                                                        .index,
                                                    smallDigitIndex: _manager
                                                        .getCurrentEnum<
                                                            SmallDigit>()
                                                        .index,
                                                    bigDigitIndex: _manager
                                                        .getCurrentEnum<
                                                            BigDigit>()
                                                        .index,
                                                    notifyIndex: _manager
                                                        .getCurrentEnum<
                                                            CountDownMultiplyMode>()
                                                        .index);
                                                setState(() {
                                                  _indicatorVisible = true;
                                                });
                                                await DbClient
                                                    .saveMultiplyPreset(
                                                        newItem);
                                                setState(() {
                                                  _indicatorVisible = false;
                                                });

                                                await DbClient
                                                    .getMultiplyPresets();

                                                if (context.mounted) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return const CustomAlert(
                                                          title: '알림',
                                                          content: '저장 완료!',
                                                        );
                                                      });
                                                }
                                              }
                                            });
                                          },
                                          child: Text(
                                            'theme.presetSave'.tr(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'buttons.ok'.tr(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                      ]),
                                  const Divider(
                                    color: Colors.transparent,
                                  ),
                                ]))
                          ]))))),
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
      Function(dynamic) onChangeMethod,
      {GlobalKey<FormFieldState>? formKey}) {
    return getPadding(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 19,
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
          flex: 20,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: DropdownButtonFormField(
                  key: formKey,
                  dropdownColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  elevation: 0,
                  isDense: true,
                  itemHeight: 50,
                  initialValue: initialValue,
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
      case const (SpeedMultiply):
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
      case const (BigDigit):
        _manager.getCurrentValue<SmallDigit, int>();
        if (int.parse(value) < _manager.getCurrentValue<SmallDigit, int>()) {
          showDialog(
              context: context,
              builder: (context) {
                return getAlertWarningDialog(context);
              });
          // Reset dropdown to original value using FormField key
          _bigDigitKey.currentState?.reset();
          return;
        }

        _bigDigit = _manager.itemStrToEnum<BigDigit>(value);
        _manager.saveSetting(_bigDigit);
        break;
      case const (SmallDigit):
        if (int.parse(value) > _manager.getCurrentValue<BigDigit, int>()) {
          showDialog(
              context: context,
              builder: (context) {
                return getAlertWarningDialog(context);
              });
          // Reset dropdown to original value using FormField key
          _smallDigitKey.currentState?.reset();
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

  void initializeValues(SettingsMultiplyManager manager) {
    setState(() {
      _isMultiply = manager.getCurrentEnum<CalCulationMultiplyMode>();
      _speed = manager.getCurrentEnum<SpeedMultiply>();
      _bigDigit = manager.getCurrentEnum<BigDigit>();
      _smallDigit = manager.getCurrentEnum<SmallDigit>();
      _numOfProblems = manager.getCurrentEnum<NumOfMultiplyProblems>();
      _countDownMode = manager.getCurrentEnum<CountDownMultiplyMode>();
    });
  }

  AlertDialog getAlertWarningDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'other.warning'.tr(),
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
            color: Theme.of(context).colorScheme.onSurface),
      ),
      content: Text('customOptions.insertBigger'.tr(),
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Theme.of(context).colorScheme.onSurface)),
      actions: [
        Padding(
            padding: const EdgeInsets.all(5),
            child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'buttons.ok'.tr(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Theme.of(context).colorScheme.onSurface),
                )))
      ],
    );
  }
}
