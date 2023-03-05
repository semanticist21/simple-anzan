import 'package:flutter/material.dart';
import 'package:simple_anzan/src/const/const.dart';
import 'package:simple_anzan/src/pages/settting.dart';

import 'src/pages/error.dart';
import 'src/pages/home.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case mainPageAddress:
      return MaterialPageRoute(builder: (_) => const HomePage());

    case settingsPageAddress:
      return MaterialPageRoute(builder: (_) => const SettingsPage());

    case errorPageAddress:
      return MaterialPageRoute(builder: (_) => const ErrorPage());

    default:
      return MaterialPageRoute(builder: (_) => const ErrorPage());
  }
}

Route<dynamic> generateErrorPages(RouteSettings settings) {
  return MaterialPageRoute(builder: (_) => const ErrorPage());
}

void onTapNavi(GlobalKey<NavigatorState> navigationKey, int index) {
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
}
