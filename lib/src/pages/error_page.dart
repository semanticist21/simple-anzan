import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'The page you requested does not exist.',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    ));
  }
}
