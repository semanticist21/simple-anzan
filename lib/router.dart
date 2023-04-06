import 'package:abacus_simple_anzan/src/pages/home_page_multiply.dart';
import 'package:abacus_simple_anzan/src/pages/settting_page_multiply.dart';
import 'package:flutter/material.dart';
import 'package:abacus_simple_anzan/src/words/const.dart';
import 'package:abacus_simple_anzan/src/pages/settting_page.dart';

import 'custom_route.dart';
import 'src/pages/error_page.dart';
import 'src/pages/home_page.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case mainPageAddress:
      return CustomRoute(
        builder: (_) => const HomePage(),
      );

    case settingsPageAddress:
      return CustomRoute(builder: (_) => const SettingsPage());

    case errorPageAddress:
      return CustomRoute(builder: (_) => const ErrorPage());

    case multiplyPageAddress:
      return CustomRoute(builder: (_) => const HomeMultiplyPage());

    case settingsmultiplyPageAddress:
      return CustomRoute(builder: (_) => const SettingsMultiplyPage());

    default:
      return CustomRoute(builder: (_) => const ErrorPage());
  }
}

Route<dynamic> generateErrorPages(RouteSettings settings) {
  return CustomRoute(builder: (_) => const ErrorPage());
}

void onTapNavi(GlobalKey<NavigatorState> navigationKey, int index) {
  switch (index) {
    case 0:
      navigationKey.currentState?.pushReplacementNamed(mainPageAddress);
      break;
    case 1:
      navigationKey.currentState?.pushReplacementNamed(settingsPageAddress);
      break;
    case 2:
      navigationKey.currentState?.pushReplacementNamed(multiplyPageAddress);
      break;
    case 3:
      navigationKey.currentState
          ?.pushReplacementNamed(settingsmultiplyPageAddress);
      break;
    default:
      navigationKey.currentState?.pushReplacementNamed(errorPageAddress);
      break;
  }
}
