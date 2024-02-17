import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({required super.builder});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
