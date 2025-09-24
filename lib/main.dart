import 'dart:ui';

import 'package:abacus_simple_anzan/client.dart';
import 'package:abacus_simple_anzan/exit_watcher.dart';
import 'package:abacus_simple_anzan/loading_stream.dart';
import 'package:abacus_simple_anzan/src/dialog/preset_add_list.dart';
import 'package:abacus_simple_anzan/src/dialog/preset_multiply_list.dart';
import 'package:abacus_simple_anzan/src/dialog/windows_add_option_multiply.dart';
import 'package:abacus_simple_anzan/src/model/preset_add_model.dart';
import 'package:abacus_simple_anzan/src/model/preset_multiply_model.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/option/option_manager.dart';
import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/burning_mode_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/burning_mode_multiply_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';
import 'package:abacus_simple_anzan/src/settings/option/theme_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/const/const.dart';
import 'package:abacus_simple_anzan/router.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:async';

// import 'loading.dart';
import 'src/dialog/prob_list.dart';
import 'src/dialog/prob_list_multiply.dart';
import 'src/dialog/windows_add_option.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(1024, 768));
    await windowManager.setMaximizable(true);
    await windowManager.setMinimizable(true);
    await windowManager.setSize(const Size(400, 600));
  }

  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);
    if (Platform.isWindows) {
      String currentPath = Directory.current.path;
      var file = File('$currentPath\\errors.txt');

      // DateTime now = DateTime.now();
      // String formattedTime = DateFormat('yyyy.MM.dd HH:mm:ss').format(now);
      // var time = '[$formattedTime]';

      await file.writeAsString("\n", mode: FileMode.append);
      await file.writeAsString("\n", mode: FileMode.append);
      // await file.writeAsString(time, mode: FileMode.append);
      await file.writeAsString(details.exception.toString(),
          mode: FileMode.append);
      await file.writeAsString(details.stack.toString(), mode: FileMode.append);
    }
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('ja')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child:
          Platform.isWindows ? const ExitWatcher(item: MyApp()) : const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    _init();

    return StreamBuilder<bool>(
        initialData: true,
        stream: ThemeSelector.isDarkStream.stream,
        builder: (context, snapshot) => MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                EasyLocalization.of(context)!.delegate,
              ],
              supportedLocales: EasyLocalization.of(context)!.supportedLocales,
              locale: EasyLocalization.of(context)!.locale,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.unknown
                  },
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics())),
              debugShowCheckedModeBanner: false,
              theme: ThemeSelector.isDark
                  ? ThemeSelector.getBlackTheme()
                  : ThemeSelector.getWhiteTheme(),
              title: 'app.name'.tr(),
              home: PopScope(
                onPopInvokedWithResult: (didPop, result) async {
                  // Audio players are automatically disposed
                },
                child: MultiProvider(providers: [
                  ChangeNotifierProvider<StateProvider>(
                      create: (_) => StateProvider()),
                  ChangeNotifierProvider<StateMultiplyProvider>(
                      create: (_) => StateMultiplyProvider())
                ], child: const Home()),
              ),
            ));
  }

  Future<void> _init() async {
    await SettingsManager().initSettings();
    await SettingsMultiplyManager().initSettings();
    await OptionManager().initSettings();

    if (Platform.isWindows) {
      await DbClient().initData();
    }
    // await Future.delayed(const Duration(milliseconds: 500));

    LoadingStream.isLoadingStream.add(false);
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  late StateProvider _stateProvider;
  late StateMultiplyProvider _stateMultiplyProvider;

  Future<void> _onTap(int newIndex) async {
    if (_currentIndex == newIndex) {
      return;
    }

    if (_stateProvider.state == ButtonState.iterationStarted) {
      return;
    }

    if (_stateMultiplyProvider.state == ButtonMultiplyState.iterationStarted) {
      return;
    }

    onTapNavi(navigationKey, newIndex);
    setState(() {
      _currentIndex = newIndex;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_stateProvider.state == ButtonState.iterationCompleted) {
      _stateProvider.changeState();
    }
    if (_stateMultiplyProvider.state ==
        ButtonMultiplyState.iterationCompleted) {
      _stateMultiplyProvider.changeState();
    }
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of<StateProvider>(context);
    _stateMultiplyProvider = Provider.of<StateMultiplyProvider>(context);

    return buildMainHome(context);

    // theme is first set true,
    // but shows loading page until saved data loads.
    // return StreamBuilder(
    //     initialData: true,
    //     stream: LoadingStream.isLoadingStream.stream,
    //     builder: (context, snapshot) {
    //       return snapshot.requireData ? const Loading() : buildMainHome();
    //     });
  }

  Widget buildMainHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          StreamBuilder(
              initialData: true,
              stream: SoundOptionHandler.isSoundOnStream.stream,
              builder: (context, snapshot) {
                return Row(children: [
                  Visibility(
                    visible: !(_currentIndex != 0 && _currentIndex != 2),
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.only(right: 16),
                      child: Tooltip(
                          message: 'problemList.burningMode'.tr(),
                          child: _FlatCircularButton(
                            onPressed: _toggleBurningMode,
                            backgroundColor: _getBurningModeBackgroundColor(context),
                            child: Icon(
                              Icons.local_fire_department,
                              color: _getBurningModeColor(context),
                              size: Platform.isWindows
                                  ? MediaQuery.of(context).size.height * 0.03
                                  : 20,
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: _currentIndex == 0,
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.only(right: 16),
                      child: Tooltip(
                          message: 'problemList.stopIteration'.tr(),
                          child: _FlatCircularButton(
                            onPressed: requestButtonStopIteration,
                            backgroundColor: Theme.of(context).colorScheme.error,
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Colors.white70,
                              size: 20,
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: !(_currentIndex != 0 && _currentIndex != 2),
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.only(right: 16),
                      child: Tooltip(
                          message: 'problemList.checkProb'.tr(),
                          child: _FlatCircularButton(
                            onPressed: () {
                              if (_currentIndex != 0 && _currentIndex != 2) {
                                return;
                              }
                              showProbDialog(_currentIndex == 0 ? true : false);
                            },
                            backgroundColor: Theme.of(context).colorScheme.onSurface,
                            child: Icon(
                              CupertinoIcons.question,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                      visible: Platform.isWindows
                          ? _currentIndex == 0 || _currentIndex == 2
                              ? true
                              : false
                          : false,
                      child: Row(children: [
                        Tooltip(
                            message: 'theme.preset'.tr(),
                            child: _FlatIconButton(
                              onPressed: () {
                                if (_currentIndex == 0) {
                                  showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const PresetAddList())
                                      .then((value) => {
                                            if (value is PresetAddModel)
                                              {
                                                PresetAddModel.saveItem(
                                                    value, SettingsManager())
                                              }
                                          });
                                } else if (_currentIndex == 2) {
                                  showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const PresetMultiplyList())
                                      .then((value) => {
                                            if (value is PresetMultiplyModel)
                                              {
                                                PresetMultiplyModel.saveItem(
                                                    value,
                                                    SettingsMultiplyManager())
                                              }
                                          });
                                }
                              },
                              icon: const Icon(CupertinoIcons.collections),
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            )),
                        Tooltip(
                            message: 'theme.fastSetting'.tr(),
                            child: _FlatIconButton(
                              onPressed: () {
                                if (_currentIndex == 0) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const WindowsAddOptionDialog());
                                } else if (_currentIndex == 2) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const WindowsAddOptionMultiplyDialog());
                                }
                              },
                              icon: const Icon(CupertinoIcons.settings),
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            )),
                      ])),
                  const SizedBox(width: 12),
                  Tooltip(
                      message: 'theme.sound'.tr(),
                      child: Icon(
                        SoundOptionHandler.isSoundOn
                            ? CupertinoIcons.speaker_2_fill
                            : CupertinoIcons.speaker_slash_fill,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20, // consistent icon size
                      )),
                  const SizedBox(width: 8),
                  Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeTrackColor: ThemeSelector.isDark
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                            : Theme.of(context).colorScheme.onSecondary,
                        inactiveTrackColor: ThemeSelector.isDark
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onPrimary,
                        onChanged: (value) {
                          OptionManager()
                              .setSoundBool(!SoundOptionHandler.isSoundOn);
                          setState(() {});
                        },
                        value: SoundOptionHandler.isSoundOn,
                      )),
                ]);
              }),
          const SizedBox(width: 5),
          Tooltip(
            message: 'theme.mode'.tr(),
            child: AnimatedToggleSwitch<bool>.dual(
              current: ThemeSelector.isDark,
              first: false,
              second: true,
              onChanged: (value) {
                OptionManager().setThemeBool(value);
                setState(() {});
              },
              spacing: 2.0,
              height: 32.0,
              borderWidth: 1.0,
              indicatorSize: const Size.fromWidth(28.0),
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.easeInOut,
              style: ToggleStyle(
                borderColor: Colors.grey.shade300,
                backgroundColor: Colors.grey.shade100,
                indicatorColor: Colors.white,
              ),
              styleBuilder: (value) => ToggleStyle(
                backgroundColor: value
                    ? const Color(0xFF0F172A) // Deep midnight blue
                    : const Color(0xFFFFF8E7), // Warm cream for day
                borderColor: value
                    ? const Color(0xFF1E293B) // Darker border for night
                    : const Color(0xFFE5D5B7), // Warm beige border for day
                indicatorColor: value
                    ? const Color(0xFF1E2B3C) // Dark indicator for night
                    : const Color(0xFFFFFAF0), // Pure warm white indicator for day
              ),
              iconBuilder: (value) => value
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6B7280), Color(0xFFD1D5DB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.bedtime,
                        color: Color(0xFFF8FAFC),
                        size: 14.0,
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                          center: Alignment.center,
                        ),
                      ),
                      child: const Icon(
                        Icons.wb_sunny,
                        color: Color(0xFFFFFFFF),
                        size: 14.0,
                      ),
                    ),
              textBuilder: (value) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Navigator(
        key: navigationKey,
        onGenerateRoute: generateRoutes,
        onUnknownRoute: generateErrorPages,
        initialRoute: mainPageAddress,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: ThemeSelector.isDark
              ? Theme.of(context).colorScheme.surfaceContainerHighest // elevated dark surface
              : Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: ThemeSelector.isDark
              ? Theme.of(context).colorScheme.onInverseSurface // muted grey for dark mode
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          enableFeedback: false,
          mouseCursor: SystemMouseCursors.basic,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 24),
              label: 'navigation.homePlus'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune, size: 24),
              label: 'navigation.settingPlus'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.close, size: 24),
              label: 'navigation.homeMultiply'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 24),
              label: 'navigation.settingMultiply'.tr(),
            )
          ],
          onTap: _onTap,
          currentIndex: _currentIndex,
        ),
      ),
    );
  }

  Color _getBurningModeColor(BuildContext context) {
    try {
      if (_currentIndex == 0) {
        BurningMode mode = SettingsManager().getCurrentEnum<BurningMode>();
        return mode == BurningMode.on
            ? Colors.red
            : Theme.of(context).colorScheme.secondary;
      } else if (_currentIndex == 2) {
        BurningModeMultiply mode =
            SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
        return mode == BurningModeMultiply.on
            ? Colors.red
            : Theme.of(context).colorScheme.secondary;
      }
    } catch (e) {
      // Return default color if preferences not initialized yet
      return Theme.of(context).colorScheme.secondary;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color _getBurningModeBackgroundColor(BuildContext context) {
    try {
      if (_currentIndex == 0) {
        BurningMode mode = SettingsManager().getCurrentEnum<BurningMode>();
        return mode == BurningMode.on ? Colors.orange.shade300 : Colors.grey;
      } else if (_currentIndex == 2) {
        BurningModeMultiply mode =
            SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
        return mode == BurningModeMultiply.on
            ? Colors.orange.shade300
            : Colors.grey;
      }
    } catch (e) {
      return Colors.grey;
    }
    return Colors.grey;
  }

  void _toggleBurningMode() {
    try {
      String message = '';
      if (_currentIndex == 0) {
        // Addition mode
        BurningMode currentMode =
            SettingsManager().getCurrentEnum<BurningMode>();
        BurningMode newMode =
            currentMode == BurningMode.on ? BurningMode.off : BurningMode.on;
        SettingsManager().saveSetting(newMode);
        message = newMode == BurningMode.on
            ? 'problemList.burningModeEnabled'.tr()
            : 'problemList.burningModeDisabled'.tr();
      } else if (_currentIndex == 2) {
        // Multiplication mode
        BurningModeMultiply currentMode =
            SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
        BurningModeMultiply newMode = currentMode == BurningModeMultiply.on
            ? BurningModeMultiply.off
            : BurningModeMultiply.on;
        SettingsMultiplyManager().saveSetting(newMode);
        message = newMode == BurningModeMultiply.on
            ? 'problemList.burningModeEnabled'.tr()
            : 'problemList.burningModeDisabled'.tr();
      }

      // Show toast notification
      if (message.isNotEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      setState(() {});
    } catch (e) {
      // Do nothing if preferences not initialized yet
      // Burning mode preferences not initialized yet: $e
    }
  }

  void requestButtonStopIteration() {
    if (_stateProvider.state == ButtonState.iterationStarted) {
      _stateProvider.changeState(desiredState: ButtonState.iterationCompleted);
    }
  }

  void showProbDialog(bool isAddHome) {
    if (isAddHome) {
      if (_stateProvider.state == ButtonState.iterationStarted) {
        return;
      }

      showDialog(
          context: context,
          builder: (context) => ProbList(numList: _stateProvider.nums));
    } else {
      if (_stateMultiplyProvider.state ==
          ButtonMultiplyState.iterationStarted) {
        return;
      }

      showDialog(
          context: context,
          builder: (context) => ProbMultiplyList(
                numList: _stateMultiplyProvider.nums,
                mode: _stateMultiplyProvider.isMultiplies,
              ));
    }
  }
}

class _FlatIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;
  final double size;

  const _FlatIconButton({
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<_FlatIconButton> createState() => _FlatIconButtonState();
}

class _FlatIconButtonState extends State<_FlatIconButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isPressed
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          widget.icon.icon,
          color: _isPressed
              ? widget.color.withValues(alpha: 0.7)
              : widget.color,
          size: widget.size,
        ),
      ),
    );
  }
}

class _FlatCircularButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;

  const _FlatCircularButton({
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  });

  @override
  State<_FlatCircularButton> createState() => _FlatCircularButtonState();
}

class _FlatCircularButtonState extends State<_FlatCircularButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.backgroundColor.withValues(alpha: 0.8)
              : widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
