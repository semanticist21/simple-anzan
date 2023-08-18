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
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';
import 'package:abacus_simple_anzan/src/settings/option/theme_selector.dart';
import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
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

  runApp(Platform.isWindows ? const ExitWatcher(item: MyApp()) : const MyApp());
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
              title: LocalizationChecker.appName,
              home: WillPopScope(
                onWillPop: () async {
                  await SoundOptionHandler.audioplayer.dispose();
                  await SoundOptionHandler.countplayer.dispose();
                  await SoundOptionHandler.audioAndroidPlayer.dispose();
                  return true;
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
    LocalizationChecker();
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

    return buildMainHome();

    // theme is first set true,
    // but shows loading page until saved data loads.
    // return StreamBuilder(
    //     initialData: true,
    //     stream: LoadingStream.isLoadingStream.stream,
    //     builder: (context, snapshot) {
    //       return snapshot.requireData ? const Loading() : buildMainHome();
    //     });
  }

  Widget buildMainHome() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          StreamBuilder(
              initialData: true,
              stream: SoundOptionHandler.isSoundOnStream.stream,
              builder: (context, snapshot) {
                return Row(children: [
                  Visibility(
                    visible: !(_currentIndex != 0 && _currentIndex != 2),
                    child: Tooltip(
                        message: LocalizationChecker.checkProb,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (_currentIndex != 0 && _currentIndex != 2) {
                              return;
                            }
                            showProbDialog(_currentIndex == 0 ? true : false);
                          },
                          elevation: 2.0,
                          fillColor: Theme.of(context).colorScheme.onBackground,
                          padding: const EdgeInsets.all(2),
                          shape: const CircleBorder(),
                          child: Icon(
                            CupertinoIcons.question,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )),
                  ),
                  Visibility(
                      visible: Platform.isWindows
                          ? _currentIndex == 0 || _currentIndex == 2
                              ? true
                              : false
                          : false,
                      child: Row(children: [
                        Tooltip(
                            message: LocalizationChecker.preset,
                            child: IconButton(
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
                              color: Theme.of(context).colorScheme.onBackground,
                              iconSize: Platform.isWindows
                                  ? MediaQuery.of(context).size.height * 0.038
                                  : null,
                              splashRadius: 15,
                            )),
                        Tooltip(
                            message: LocalizationChecker.fastSetting,
                            child: IconButton(
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
                              color: Theme.of(context).colorScheme.onBackground,
                              iconSize: Platform.isWindows
                                  ? MediaQuery.of(context).size.height * 0.038
                                  : null,
                              splashRadius: 15,
                            )),
                      ])),
                  const SizedBox(width: 10),
                  Tooltip(
                      message: LocalizationChecker.soundOn,
                      child: Icon(
                        SoundOptionHandler.isSoundOn
                            ? CupertinoIcons.speaker_2
                            : CupertinoIcons.speaker_slash,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: Platform.isWindows
                            ? MediaQuery.of(context).size.height * 0.038
                            : null,
                      )),
                  Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        trackColor: Theme.of(context).colorScheme.onPrimary,
                        onChanged: (value) {
                          OptionManager()
                              .setSoundBool(!SoundOptionHandler.isSoundOn);
                          setState(() {});
                        },
                        value: SoundOptionHandler.isSoundOn,
                      )),
                ]);
              }),
          const SizedBox(width: 10),
          Row(children: [
            Tooltip(
                message: LocalizationChecker.mode,
                child: Icon(
                  ThemeSelector.isDark ? Icons.nightlight : Icons.sunny,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: Platform.isWindows
                      ? MediaQuery.of(context).size.height * 0.038
                      : null,
                )),
            Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.onSecondary,
                  trackColor: Theme.of(context).colorScheme.onPrimary,
                  onChanged: (value) {
                    OptionManager().setThemeBool(!ThemeSelector.isDark);
                    setState(() {});
                  },
                  value: ThemeSelector.isDark,
                )),
          ]),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Navigator(
        key: navigationKey,
        onGenerateRoute: generateRoutes,
        onUnknownRoute: generateErrorPages,
        initialRoute: mainPageAddress,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        selectedItemColor: Theme.of(context).colorScheme.background,
        unselectedItemColor: Theme.of(context).colorScheme.onInverseSurface,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.add_to_photos_outlined,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.height * 0.023),
            icon: Icon(Icons.add_to_photos,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: MediaQuery.of(context).size.height * 0.023),
            label: LocalizationChecker.homePlusLabel,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings_outlined,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.height * 0.023),
            icon: Icon(Icons.settings,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: MediaQuery.of(context).size.height * 0.023),
            label: LocalizationChecker.settingPlusLabel,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.xmark_circle,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.height * 0.023),
            icon: Icon(CupertinoIcons.xmark_circle_fill,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: MediaQuery.of(context).size.height * 0.023),
            label: LocalizationChecker.homeMultiplyLabel,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.gear,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.height * 0.023),
            icon: Icon(CupertinoIcons.gear_alt_fill,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: MediaQuery.of(context).size.height * 0.023),
            label: LocalizationChecker.settingMultiplyLabel,
          )
        ],
        onTap: _onTap,
        currentIndex: _currentIndex,
      ),
    );
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
