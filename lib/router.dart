import 'package:flutter/material.dart';
import 'package:simple_anzan/src/const.dart';
import 'package:simple_anzan/src/settting.dart';

import 'src/error.dart';
import 'src/main.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case mainPageAddress:
      return MaterialPageRoute(builder: (_) => const MainPage());

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
