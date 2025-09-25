import 'package:abacus_simple_anzan/src/dialog/custom_alert_dialog.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/separator_multiply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late SeparatorMultiplyMode _separatorMode;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 0.0),
          child: Icon(
            Icons.tune,
            size: 24.0,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            'settingsMultiply.title'.tr(),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Tooltip(
          message: 'settingsMultiply.explanationTooltip'.tr(),
          child: GestureDetector(
            onTap: () => _showSettingsExplanationModal(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.help_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
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
          'settingsMultiply.isMultiply'.tr(),
          Icons.calculate,
          _manager.enumToValue<CalCulationMultiplyMode, bool>(_isMultiply),
          toggleMultiplyModeCallback,
        ),
        _buildDropdownListTile(
          'settingsMultiply.speed'.tr(),
          Icons.timer_outlined,
          _manager.getItemStr<SpeedMultiply>(_speed.name),
          getDropdownMenuItemList<SpeedMultiply>(_manager),
          changeOptionCallback<SpeedMultiply>,
        ),
        _buildDropdownListTile(
          'settingsMultiply.smallDigit'.tr(),
          Icons.pin,
          _manager.getItemStr<SmallDigit>(_smallDigit.name),
          getDropdownMenuItemList<SmallDigit>(_manager),
          changeOptionCallback<SmallDigit>,
        ),
        _buildDropdownListTile(
          'settingsMultiply.bigDigit'.tr(),
          Icons.pin_outlined,
          _manager.getItemStr<BigDigit>(_bigDigit.name),
          getDropdownMenuItemList<BigDigit>(_manager),
          changeOptionCallback<BigDigit>,
        ),
        Tooltip(
          message: 'settings.separator'.tr(),
          child: _buildToggleListTile(
            'settings.separator'.tr(),
            Icons.looks_one,
            _manager.enumToValue<SeparatorMultiplyMode, bool>(_separatorMode),
            toggleSeparatorModeCallback,
          ),
        ),
        Tooltip(
          message: 'customOptions.shouldSoundOnDesc'.tr(),
          child: _buildToggleListTile(
            'settings.notify'.tr(),
            Icons.volume_up_outlined,
            _manager.enumToValue<CountDownMultiplyMode, bool>(_countDownMode),
            toggleCounterModeCallback,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleListTile(String title, IconData iconData, bool value,
      Function(bool) onChangeMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        leading: Icon(
          iconData,
          size: 24.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
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

  Widget _buildDropdownListTile(
      String title,
      IconData iconData,
      String initialValue,
      List<DropdownMenuItem<dynamic>> dropdownMenuItemList,
      Function(dynamic) onChangeMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        leading: Icon(
          iconData,
          size: 24.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: SizedBox(
            width: 140,
            child: DropdownButtonFormField(
              dropdownColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.surface,
              elevation: 0,
              isDense: true,
              itemHeight: 54,
              initialValue: initialValue,
              iconSize: 25,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF6B7280) // Lighter gray for dark theme
                        : const Color(
                            0xFF9CA3AF), // Darker gray for light theme
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF6B7280) // Lighter gray for dark theme
                        : const Color(
                            0xFF9CA3AF), // Darker gray for light theme
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.surfaceContainer,
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
              items: dropdownMenuItemList,
              onChanged: onChangeMethod,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Padding buildToggleOption(String title, IconData iconData, bool value,
      Function(bool) onChangeMethod) {
    return getPadding(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Icon(iconData, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(title,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0185,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface))
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

  void toggleSeparatorModeCallback(bool newValue) {
    setState(() {
      _separatorMode =
          _manager.valueToEnum<bool, SeparatorMultiplyMode>(newValue);
    });

    _manager.saveSetting(_separatorMode);
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
                        color: Theme.of(context).colorScheme.onSurface))
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
                  dropdownColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  isDense: true,
                  itemHeight: 54,
                  initialValue: initialValue,
                  iconSize: 25,
                  isExpanded: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                          : Theme.of(context).colorScheme.surfaceContainer,
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
            textAlign: isNumber ? TextAlign.center : TextAlign.left,
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
      _separatorMode = manager.getCurrentEnum<SeparatorMultiplyMode>();
    });
  }

  void _showSettingsExplanationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 550),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Fixed Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'settingsMultiply.explanationTitle'.tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                CupertinoIcons.xmark,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'settingsMultiply.explanationDesc'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildExplanationItem(
                        context,
                        'settingsMultiply.isMultiply'.tr(),
                        'settingsMultiply.isMultiplyExplanation'.tr(),
                        Icons.calculate,
                      ),
                      _buildExplanationItem(
                        context,
                        'settingsMultiply.speed'.tr(),
                        'settingsMultiply.speedExplanation'.tr(),
                        Icons.timer_outlined,
                      ),
                      _buildExplanationItem(
                        context,
                        'settingsMultiply.smallDigit'.tr(),
                        'settingsMultiply.smallDigitExplanation'.tr(),
                        Icons.pin,
                      ),
                      _buildExplanationItem(
                        context,
                        'settingsMultiply.bigDigit'.tr(),
                        'settingsMultiply.bigDigitExplanation'.tr(),
                        Icons.pin_outlined,
                      ),
                      _buildExplanationItem(
                        context,
                        'settings.separator'.tr(),
                        'settings.separatorExplanation'.tr(),
                        Icons.looks_one,
                      ),
                      _buildExplanationItem(
                        context,
                        'settings.notify'.tr(),
                        'settings.notifyExplanation'.tr(),
                        Icons.volume_up_outlined,
                      ),
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

  Widget _buildExplanationItem(
    BuildContext context,
    String title,
    String explanation,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getAlertWarningDialog(BuildContext context) {
    return CustomAlert(
        content: 'customOptions.insertBigger'.tr(),
        title: 'other.warning'.tr());
  }
}
