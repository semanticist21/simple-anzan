import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_anzan/src/const/const.dart';
import 'package:simple_anzan/router.dart';
import 'package:simple_anzan/src/provider/state_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Anzan',
      home: ChangeNotifierProvider(
          create: (context) {
            return StateProvider();
          },
          child: const Home()),
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
    onTapNavi(navigationKey, index);
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
