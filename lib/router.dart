import 'package:abacus_simple_anzan/src/pages/home_page_multiply.dart';
import 'package:abacus_simple_anzan/src/pages/settting_page_multiply.dart';
import 'package:flutter/material.dart';
import 'package:abacus_simple_anzan/src/pages/settting_page.dart';

import 'custom_route.dart';
import 'src/pages/error_page.dart';
import 'src/pages/home_page.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return CustomRoute(
        builder: (_) => const HomePage(),
      );

    case '/settings':
      return CustomRoute(builder: (_) => const SettingsPage());

    case '/error':
      return CustomRoute(builder: (_) => const ErrorPage());

    case '/multiply':
      return CustomRoute(builder: (_) => const HomeMultiplyPage());

    case '/settings/multiply':
      return CustomRoute(builder: (_) => const SettingsMultiplyPage());

    default:
      return CustomRoute(builder: (_) => const ErrorPage());
  }
}

Route<dynamic> generateErrorPages(RouteSettings settings) {
  return CustomRoute(builder: (_) => const ErrorPage());
}

void onTapNav(GlobalKey<NavigatorState> navigationKey, int index) {
  switch (index) {
    case 0:
      navigationKey.currentState?.pushReplacementNamed('/');
      break;
    case 1:
      navigationKey.currentState?.pushReplacementNamed('/settings');
      break;
    case 2:
      navigationKey.currentState?.pushReplacementNamed('/multiply');
      break;
    case 3:
      navigationKey.currentState?.pushReplacementNamed('/settings/multiply');
      break;
    default:
      navigationKey.currentState?.pushReplacementNamed('/error');
      break;
  }
}
