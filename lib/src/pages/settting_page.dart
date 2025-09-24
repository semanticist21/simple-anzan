import 'package:easy_localization/easy_localization.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/countdown.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/seperator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';

import '../components/custom_dropdown.dart';
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
  late SeparatorMode _seperatorMode;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeValues(_manager);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: 24),

                // Settings List
                Expanded(
                  child: ListView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildSettingsSection(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.tune,
          size: 28.0,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 16.0),
        Text(
          'settings.title'.tr(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleListTile(
          'settings.onlyPluses'.tr(),
          Icons.functions,
          _manager.enumToValue<CalculationMode, bool>(_isOnlyPlus),
          togglePlusModeCallback,
        ),
        Tooltip(
          message: 'customOptions.shuffleDesc'.tr(),
          child: _buildToggleListTile(
            'settings.shuffle'.tr(),
            Icons.casino_outlined,
            _manager.enumToValue<ShuffleMode, bool>(_isShuffle),
            toggleShuffleModeCallback,
          ),
        ),
        _buildDropdownListTile(
          'settings.speed'.tr(),
          Icons.timer_outlined,
          _manager.getItemStr<Speed>(_speed.name),
          getDropdownMenuItemList<Speed>(_manager),
          changeOptionCallback<Speed>,
        ),
        _buildDropdownListTile(
          'settings.digit'.tr(),
          Icons.pin,
          _manager.getItemStr<Digit>(_digit.name),
          getDropdownMenuItemList<Digit>(_manager),
          changeOptionCallback<Digit>,
        ),
        _buildDropdownListTile(
          'settings.questions'.tr(),
          Icons.quiz_outlined,
          _manager.getItemStr<NumOfProblems>(_numOfProblems.name),
          getDropdownMenuItemList<NumOfProblems>(_manager),
          changeOptionCallback<NumOfProblems>,
        ),
        Tooltip(
          message: 'settings.separator'.tr(),
          child: _buildToggleListTile(
            'settings.separator'.tr(),
            Icons.looks_one,
            _manager.enumToValue<SeparatorMode, bool>(_seperatorMode),
            toggleSepartorModeCallback,
          ),
        ),
        Tooltip(
          message: 'customOptions.shouldSoundOnDesc'.tr(),
          child: _buildToggleListTile(
            'settings.notify'.tr(),
            Icons.volume_up_outlined,
            _manager.enumToValue<CountDownMode, bool>(_countDownMode),
            toggleCounterModeCallback,
          ),
        ),
      ],
    );
  }


  Widget _buildToggleListTile(String title, IconData iconData, bool value,
      Function(bool) onChangeMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: Icon(
          iconData,
          size: 24.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChangeMethod,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700.withValues(alpha: 0.5)
              : Colors.grey.shade300.withValues(alpha: 0.7),
          thumbColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade200
              : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  void togglePlusModeCallback(bool newValue) {
    setState(() {
      _isOnlyPlus = _manager.valueToEnum<bool, CalculationMode>(newValue);
    });

    _manager.saveSetting(_isOnlyPlus);
    initializeValues(_manager);
  }

  void toggleShuffleModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, ShuffleMode>(newValue);
      _isShuffle = valueToEnum;
    });

    _manager.saveSetting(_isShuffle);
    initializeValues(_manager);
  }

  void toggleSepartorModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, SeparatorMode>(newValue);
      _seperatorMode = valueToEnum;
    });

    _manager.saveSetting(_seperatorMode);
    initializeValues(_manager);
  }

  void toggleCounterModeCallback(bool newValue) {
    setState(() {
      var valueToEnum = _manager.valueToEnum<bool, CountDownMode>(newValue);
      _countDownMode = valueToEnum;
    });

    _manager.saveSetting(_countDownMode);
    initializeValues(_manager);
  }

  Widget _buildDropdownListTile(
      String title,
      IconData iconData,
      String initialValue,
      List<DropdownMenuItem<dynamic>> dropdownMenuItemList,
      Function(dynamic) onChangeMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: Icon(
          iconData,
          size: 24.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: CustomDropdown(
          initialValue: initialValue,
          items: dropdownMenuItemList,
          onChanged: onChangeMethod,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  void changeOptionCallback<T>(dynamic value) {
    switch (T) {
      case const (Speed):
        if (value == 'custom') {
          // When custom is selected, show the dialog and handle the result
          showDialog(
              context: context,
              builder: (context) => AddDialog(
                  defaultValue: _manager
                      .getCurrentValue<Speed, Duration>()
                      .inMilliseconds
                      .toString())).then((dialogValue) {
            if (dialogValue != null) {
              // Save both the custom value and update the speed enum
              _manager.saveCustomSpeedSetting(int.parse(dialogValue));
              _manager.saveSetting(Speed.custom);
            }
          });
        } else {
          // Only set and save the speed if a non-custom value was selected
          _speed = _manager.itemStrToEnum<Speed>(value);
          _manager.saveSetting(_speed);
        }
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
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              height: 1.0,
            ),
            textAlign: isNumber ? TextAlign.center : TextAlign.left,
          ));
      itemList.add(item);
    }

    return itemList;
  }

  void initializeValues(SettingsManager manager) {
    setState(() {
      _isOnlyPlus = manager.getCurrentEnum<CalculationMode>();
      _isShuffle = manager.getCurrentEnum<ShuffleMode>();
      _speed = manager.getCurrentEnum<Speed>();
      _digit = manager.getCurrentEnum<Digit>();
      _numOfProblems = manager.getCurrentEnum<NumOfProblems>();
      _countDownMode = manager.getCurrentEnum<CountDownMode>();
      _seperatorMode = manager.getCurrentEnum<SeparatorMode>();
    });
  }
}
