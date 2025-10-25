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
import 'package:abacus_simple_anzan/src/settings/option/color_palette_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/router.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:async';

// import 'loading.dart';
import 'src/dialog/prob_list.dart';
import 'src/dialog/prob_list_multiply.dart';
import 'src/dialog/windows_add_option.dart';
import 'src/dialog/theme_color_picker.dart';
import 'src/dialog/app_info_dialog.dart';

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

  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(800, 600));
    await windowManager.setMaximizable(true);
    await windowManager.setMinimizable(true);
    await windowManager.setSize(const Size(1280, 800)); // App Store screenshot size
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
        Locale('ja'),
        Locale('uz'),
        Locale('my'),
        Locale('fr'),
        Locale('ar'),
        Locale('id'),
        Locale('zh')
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

    // Listen to both theme mode and color palette changes
    return StreamBuilder<bool>(
        initialData: true,
        stream: ThemeSelector.isDarkStream.stream,
        builder: (context, themeSnapshot) => StreamBuilder(
              stream: ThemeSelector.colorPaletteStream.stream,
              builder: (context, paletteSnapshot) => AnimatedTheme(
                data: ThemeSelector.isDark
                    ? ThemeSelector.getBlackTheme()
                    : ThemeSelector.getWhiteTheme(),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: MaterialApp(
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    EasyLocalization.of(context)!.delegate,
                  ],
                  supportedLocales:
                      EasyLocalization.of(context)!.supportedLocales,
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
                ),
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

    onTapNav(navigationKey, newIndex);
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
                return Container(
                  margin: const EdgeInsets.only(right: 22.0),
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(children: [
                    Visibility(
                      visible: !(_currentIndex != 0 && _currentIndex != 2),
                      child: Container(
                        width: 40,
                        margin: const EdgeInsets.only(right: 16),
                        child: Tooltip(
                            message: 'problemList.burningMode'.tr(),
                            child: _FlatCircularButton(
                              onPressed: _toggleBurningMode,
                              backgroundColor:
                                  _getBurningModeBackgroundColor(context),
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
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
                                showProbDialog(
                                    _currentIndex == 0 ? true : false);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSurface,
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
                    // Info button - only visible on settings pages
                    Visibility(
                      visible: _currentIndex == 1 || _currentIndex == 3,
                      child: Tooltip(
                        message: 'appInfo.tooltip'.tr(),
                        child: GestureDetector(
                          onTap: () => _showAppInfoDialog(context),
                          child: Container(
                            width: 40,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: ThemeSelector.isDark
                                    ? const Color(0xFF4B5563)
                                    : const Color(0xFFD1D5DB),
                                width: 1.0,
                              ),
                              color: ThemeSelector.isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFF3F4F6),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              size: 18,
                              color: ThemeSelector.isDark
                                  ? const Color(0xFFF9FAFB)
                                  : const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Color palette picker - only visible on settings pages
                    Visibility(
                      visible: _currentIndex == 1 || _currentIndex == 3,
                      child: Tooltip(
                        message: 'themePicker.tooltip'.tr(),
                        child: GestureDetector(
                          onTap: () => _showThemeColorPicker(context),
                          child: Container(
                            width: 40,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: ThemeSelector.isDark
                                    ? const Color(0xFF4B5563)
                                    : const Color(0xFFD1D5DB),
                                width: 1.0,
                              ),
                              color: ThemeSelector.isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFF3F4F6),
                            ),
                            child: Icon(
                              Icons.palette_outlined,
                              size: 18,
                              color: ThemeSelector.isDark
                                  ? const Color(0xFFF9FAFB)
                                  : const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            _currentIndex == 1 || _currentIndex == 3 ? 8 : 0),
                    // Language selector - only visible on settings pages
                    Visibility(
                      visible: _currentIndex == 1 || _currentIndex == 3,
                      child: Tooltip(
                        message: 'theme.language'.tr(),
                        child: Container(
                          height: 32.0,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: ThemeSelector.isDark
                                  ? const Color(0xFF4B5563)
                                  : const Color(0xFFD1D5DB),
                              width: 1.0,
                            ),
                            color: ThemeSelector.isDark
                                ? const Color(0xFF1F2937)
                                : const Color(0xFFF3F4F6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: EasyLocalization.of(context)!
                                  .locale
                                  .languageCode,
                              isDense: true,
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeSelector.isDark
                                    ? const Color(0xFFF9FAFB)
                                    : const Color(0xFF111827),
                              ),
                              dropdownColor: ThemeSelector.isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFFFFFFF),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: ThemeSelector.isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇺🇸',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('EN',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ko',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇰🇷',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('KO',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ja',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇯🇵',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('JA',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'uz',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇺🇿',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('UZ',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'my',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇲🇲',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('MY',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'fr',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇫🇷',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('FR',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ar',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇪🇬',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('AR',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'id',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇮🇩',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('ID',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'zh',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🇨🇳',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Text('ZH',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  EasyLocalization.of(context)!
                                      .setLocale(Locale(newValue));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            _currentIndex == 1 || _currentIndex == 3 ? 8 : 0),
                    Tooltip(
                      message: 'theme.sound'.tr(),
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: SoundOptionHandler.isSoundOn,
                        first: false,
                        second: true,
                        onChanged: (value) {
                          OptionManager().setSoundBool(value);
                          setState(() {});
                        },
                        spacing: 2.0,
                        height: 32.0,
                        borderWidth: 1.0,
                        indicatorSize: const Size.fromWidth(26.0),
                        animationDuration: const Duration(milliseconds: 300),
                        animationCurve: Curves.easeInOut,
                        style: ToggleStyle(
                          borderColor: Colors.grey.shade300,
                          backgroundColor: Colors.grey.shade100,
                          indicatorColor: Colors.white,
                        ),
                        styleBuilder: (value) => ToggleStyle(
                          backgroundColor: value
                              ? ThemeSelector.isDark
                                  ? const Color(
                                      0xFF1F2937) // Dark background for sound on
                                  : const Color(
                                      0xFFF3F4F6) // Light background for sound on
                              : ThemeSelector.isDark
                                  ? const Color(
                                      0xFF374151) // Dark background for sound off
                                  : const Color(
                                      0xFFE5E7EB), // Light background for sound off
                          borderColor: value
                              ? ThemeSelector.isDark
                                  ? const Color(
                                      0xFF4B5563) // Darker border when on (dark mode)
                                  : const Color(
                                      0xFFD1D5DB) // Lighter border when on (light mode)
                              : ThemeSelector.isDark
                                  ? const Color(
                                      0xFF6B7280) // Border when off (dark mode)
                                  : const Color(
                                      0xFF9CA3AF), // Border when off (light mode)
                          indicatorColor: value
                              ? ThemeSelector.isDark
                                  ? const Color(
                                      0xFF111827) // Dark indicator when on
                                  : const Color(
                                      0xFFFFFFFF) // White indicator when on
                              : ThemeSelector.isDark
                                  ? const Color(
                                      0xFF1F2937) // Dark indicator when off
                                  : const Color(
                                      0xFFF9FAFB), // Light indicator when off
                        ),
                        iconBuilder: (value) => value
                            ? _buildToggleIcon(
                                icon: Icons.volume_up_rounded,
                                gradientColors: ThemeSelector.isDark
                                    ? const [
                                        Color(0xFF111827),
                                        Color(0xFF111827)
                                      ] // Match dark indicator when on
                                    : const [
                                        Color(0xFFFFFFFF),
                                        Color(0xFFFFFFFF)
                                      ], // Match white indicator when on
                                iconColor: ThemeSelector.isDark
                                    ? const Color(
                                        0xFFFFFFFF) // White icon on dark background
                                    : const Color(
                                        0xFF374151), // Dark icon on light background
                              )
                            : _buildToggleIcon(
                                icon: Icons.volume_off_rounded,
                                gradientColors: ThemeSelector.isDark
                                    ? const [
                                        Color(0xFF1F2937),
                                        Color(0xFF1F2937)
                                      ] // Match dark indicator when off
                                    : const [
                                        Color(0xFFF9FAFB),
                                        Color(0xFFF9FAFB)
                                      ], // Match light indicator when off
                                iconColor: ThemeSelector.isDark
                                    ? const Color(
                                        0xFF9CA3AF) // Gray icon on dark background
                                    : const Color(
                                        0xFF6B7280), // Darker gray icon on light background
                              ),
                        textBuilder: (value) => const SizedBox.shrink(),
                      ),
                    ),
                    // Only show theme switch on settings pages (index 1 and 3)
                    if (_currentIndex == 1 || _currentIndex == 3) ...[
                      const SizedBox(width: 8),
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
                                ? const Color(
                                    0xFF374151) // More distinct border for night
                                : const Color(
                                    0xFFD97706), // Distinct amber border for day
                            indicatorColor: value
                                ? const Color(
                                    0xFF1E2B3C) // Dark indicator for night
                                : const Color(
                                    0xFFFFFAF0), // Pure warm white indicator for day
                          ),
                          iconBuilder: (value) => value
                              ? _buildToggleIcon(
                                  icon: Icons.nightlight_round,
                                  gradientColors: const [
                                    Color(0xFF64748B),
                                    Color(0xFF94A3B8)
                                  ],
                                  iconColor: const Color(0xFFF1F5F9),
                                )
                              : _buildToggleIcon(
                                  icon: Icons.light_mode,
                                  gradientColors: const [
                                    Color(0xFFFCD34D),
                                    Color(0xFFF59E0B)
                                  ],
                                  iconColor: const Color(0xFFFFFFFF),
                                  isRadial: true,
                                ),
                          textBuilder: (value) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ]),
                );
              }),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Navigator(
        key: navigationKey,
        onGenerateRoute: generateRoutes,
        onUnknownRoute: generateErrorPages,
        initialRoute: '/',
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: ThemeSelector.isDark
              ? Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest // elevated dark surface
              : Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: ThemeSelector.isDark
              ? Theme.of(context)
                  .colorScheme
                  .onInverseSurface // muted grey for dark mode
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    try {
      if (_currentIndex == 0) {
        BurningMode mode = SettingsManager().getCurrentEnum<BurningMode>();
        return mode == BurningMode.on
            ? (isDark
                ? const Color(0xFF8B4513)
                : Colors.orange.shade300) // Dark: saddle brown, Light: orange
            : (isDark ? const Color(0xFF4A4A4A) : Colors.grey);
      } else if (_currentIndex == 2) {
        BurningModeMultiply mode =
            SettingsMultiplyManager().getCurrentEnum<BurningModeMultiply>();
        return mode == BurningModeMultiply.on
            ? (isDark
                ? const Color(0xFF8B4513)
                : Colors.orange.shade300) // Dark: saddle brown, Light: orange
            : (isDark ? const Color(0xFF4A4A4A) : Colors.grey);
      }
    } catch (e) {
      return isDark ? const Color(0xFF4A4A4A) : Colors.grey;
    }
    return isDark ? const Color(0xFF4A4A4A) : Colors.grey;
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

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AppInfoDialog(),
    );
  }

  void _showThemeColorPicker(BuildContext context) {
    final isDark = ThemeSelector.isDark;
    final currentPrimaryColor = ThemeSelector.getPrimaryColor(
      ThemeSelector.currentPalette,
      isDark,
    );

    showDialog(
      context: context,
      builder: (context) => ThemeColorPicker(
        currentColor: currentPrimaryColor,
        onColorSelected: (color) {
          // Find closest matching palette or update current palette
          _updateThemeColor(color);
        },
      ),
    );
  }

  void _updateThemeColor(Color color) {
    // Map selected color to palette (shadcn-inspired)
    final colorMap = {
      const Color(0xFF2196F3): ColorPalette.blue,
      const Color(0xFF16A34A): ColorPalette.green,
      const Color(0xFF0EA5E9): ColorPalette.sky,
      const Color(0xFFEAB308): ColorPalette.yellow,
      const Color(0xFF8B5CF6): ColorPalette.violet,
      const Color(0xFF64748B): ColorPalette.slate,
    };

    final newPalette = colorMap[color] ?? ThemeSelector.currentPalette;

    // Save to SharedPreferences through ColorPalettePref
    final prefs = OptionManager();
    prefs.setColorPalette(newPalette);

    setState(() {});
  }

  Widget _buildToggleIcon({
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconColor,
    bool isRadial = false,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isRadial
            ? RadialGradient(
                colors: gradientColors,
                center: Alignment.center,
              )
            : LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 20.0,
      ),
    );
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
          color:
              _isPressed ? widget.color.withValues(alpha: 0.7) : widget.color,
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
