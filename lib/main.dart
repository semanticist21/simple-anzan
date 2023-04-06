import 'package:abacus_simple_anzan/src/provider/state_provider_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';
import 'package:abacus_simple_anzan/src/theme/theme.dart';
import 'package:abacus_simple_anzan/src/words/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abacus_simple_anzan/src/words/const.dart';
import 'package:abacus_simple_anzan/router.dart';
import 'package:abacus_simple_anzan/src/provider/state_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    LocalizationChecker();
    SettingsManager();
    SettingsMultiplyManager();

    return StreamBuilder<bool>(
        initialData: true,
        stream: ThemeSelector.isDarkStream.stream,
        builder: (context, snapshot) => MaterialApp(
              theme: ThemeSelector.isDark
                  ? ThemeSelector.getBlackTheme()
                  : ThemeSelector.getWhiteTheme(),
              title: 'Simple Anzan',
              home: MultiProvider(providers: [
                ChangeNotifierProvider<StateProvider>(
                    create: (_) => StateProvider()),
                ChangeNotifierProvider<StateMultiplyProvider>(
                    create: (_) => StateMultiplyProvider())
              ], child: const Home()),
            ));
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
  }

  @override
  Widget build(BuildContext context) {
    _stateProvider = Provider.of<StateProvider>(context);
    _stateMultiplyProvider = Provider.of<StateMultiplyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Tooltip(
              message: LocalizationChecker.mode,
              child: Icon(
                ThemeSelector.isDark ? Icons.nightlight : Icons.sunny,
                color: Theme.of(context).colorScheme.onBackground,
              )),
          Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: Theme.of(context).colorScheme.onSecondary,
                trackColor: Theme.of(context).colorScheme.onPrimary,
                onChanged: (value) {
                  SettingsManager().setThemeBool(!ThemeSelector.isDark);
                  setState(() {});
                },
                value: ThemeSelector.isDark,
              )),
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
}
