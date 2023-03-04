import 'package:flutter/material.dart';
import 'package:simple_anzan/src/const.dart';
import 'package:simple_anzan/router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Simple Anzan',
      home: Home(),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
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

  void _onTap(int index) {
    switch (index) {
      case 0:
        navigationKey.currentState?.pushReplacementNamed(mainPageAddress);
        break;
      case 1:
        navigationKey.currentState?.pushReplacementNamed(settingsPageAddress);
        break;
      default:
        navigationKey.currentState?.pushReplacementNamed(errorPageAddress);
        break;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigationKey,
        onGenerateRoute: generateRoutes,
        onUnknownRoute: generateErrorPages,
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

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
