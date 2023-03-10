import 'package:abacus_simple_anzan/src/settings/settings_manager.dart';
import 'package:abacus_simple_anzan/src/words/localization.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Simple Anzan',
      home: ChangeNotifierProvider(
          create: (context) {
            return StateProvider();
          },
          child: const Home()),
      themeMode: ThemeMode.dark,
    );
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

  @override
  void initState() {
    SettingsManager();
    super.initState();
  }

  Future<void> _onTap(int newIndex) async {
    if (_currentIndex == newIndex) {
      return;
    }

    if (_stateProvider.state == ButtonState.iterationStarted) {
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
    _stateProvider = Provider.of(context);

    return Scaffold(
      body: Navigator(
        key: navigationKey,
        onGenerateRoute: generateRoutes,
        onUnknownRoute: generateErrorPages,
        initialRoute: mainPageAddress,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: homeLabel,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: settingLabel)
        ],
        onTap: _onTap,
        currentIndex: _currentIndex,
      ),
    );
  }
}
