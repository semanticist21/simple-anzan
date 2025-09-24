import 'package:abacus_simple_anzan/client.dart';
import 'package:abacus_simple_anzan/src/model/preset_add_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import 'package:easy_localization/easy_localization.dart';
import '../functions/hash.dart';
import '../model/save_info.dart';
import '../settings/plus_pref/prefs/calculation_mode_pref.dart';
import '../settings/plus_pref/prefs/countdown.dart';
import '../settings/plus_pref/prefs/digit_pref.dart';
import '../settings/plus_pref/prefs/num_of_problems_pref.dart';
import '../settings/plus_pref/prefs/shuffle.dart';
import '../settings/plus_pref/prefs/speed.dart';
import '../settings/plus_pref/settings_manager.dart';
import 'add_dialog.dart';
import 'custom_alert_dialog.dart';
import 'custom_preset_form_dialog.dart';

class WindowsAddOptionDialog extends StatefulWidget {
  const WindowsAddOptionDialog({super.key});

  @override
  State<WindowsAddOptionDialog> createState() => _WindowsAddOptionDialogState();
}

class _WindowsAddOptionDialogState extends State<WindowsAddOptionDialog> {
  final _manager = SettingsManager();

  late CalculationMode _isOnlyPlus;
  late ShuffleMode _isShuffle;
  late Speed _speed;
  late Digit _digit;
  late NumOfProblems _numOfProblems;
  late CountDownMode _countDownMode;

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
                                        buildToggleOption(
                                            'settings.onlyPluses'.tr(),
                                            Icons.calculate,
                                            _manager.enumToValue<
                                                CalculationMode,
                                                bool>(_isOnlyPlus),
                                            togglePlusModeCallback),
                                        Tooltip(
                                            message: 'customOptions.shuffleDesc'.tr(),
                                            child: buildToggleOption(
                                                'settings.shuffle'.tr(),
                                                Icons.shuffle,
                                                _manager.enumToValue<
                                                    ShuffleMode,
                                                    bool>(_isShuffle),
                                                toggleShuffleModeCallback)),
                                        // speed.
                                        buildDropdownButton(
                                            'settings.speed'.tr(),
                                            Icon(
                                              Icons.speed,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            _manager
                                                .getItemStr<Speed>(_speed.name),
                                            getDropdownMenuItemList<Speed>(
                                                _manager),
                                            changeOptionCallback<Speed>),
                                        // digit.
                                        buildDropdownButton(
                                            'settings.digit'.tr(),
                                            Icon(
                                              Icons.onetwothree,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            _manager
                                                .getItemStr<Digit>(_digit.name),
                                            getDropdownMenuItemList<Digit>(
                                                _manager),
                                            changeOptionCallback<Digit>),
                                        // num of problems.
                                        buildDropdownButton(
                                            'settings.questions'.tr(),
                                            Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            _manager.getItemStr<NumOfProblems>(
                                                _numOfProblems.name),
                                            getDropdownMenuItemList<
                                                NumOfProblems>(_manager),
                                            changeOptionCallback<
                                                NumOfProblems>),
                                        buildToggleOption(
                                            'settings.notify'.tr(),
                                            Icons.notifications,
                                            _manager.enumToValue<CountDownMode,
                                                bool>(_countDownMode),
                                            toggleCounterModeCallback),
                                        const SizedBox(height: 50),
                                      ])
                                ]),
                              )),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                Divider(
                                  color: Theme.of(context).colorScheme.outline,
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
                                              var newItem = PresetAddModel(
                                                  id: getHashId(),
                                                  name: value.name,
                                                  colorCode: value.colorCode,
                                                  textColorCode:
                                                      value.textColorCode,
                                                  onlyPlusesIndex: _manager
                                                      .getCurrentEnum<
                                                          CalculationMode>()
                                                      .index,
                                                  shuffleIndex: _manager
                                                      .getCurrentEnum<
                                                          ShuffleMode>()
                                                      .index,
                                                  speedIndex: _manager
                                                      .getCurrentEnum<Speed>()
                                                      .index,
                                                  digitIndex: _manager
                                                      .getCurrentEnum<Digit>()
                                                      .index,
                                                  numOfProblemIndex: _manager
                                                      .getCurrentEnum<
                                                          NumOfProblems>()
                                                      .index,
                                                  notifyIndex: _manager
                                                      .getCurrentEnum<
                                                          CountDownMode>()
                                                      .index);
                                              setState(() {
                                                _indicatorVisible = true;
                                              });
                                              await DbClient.saveAddPreset(
                                                  newItem);
                                              setState(() {
                                                _indicatorVisible = false;
                                              });

                                              await DbClient.getAddPresets();

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
      ),
    );
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
      case const (Speed):
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
      case const (Digit):
        _digit = _manager.itemStrToEnum<Digit>(value);
        _manager.saveSetting(_digit);
        break;
      case const (NumOfProblems):
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
    });
  }
}
