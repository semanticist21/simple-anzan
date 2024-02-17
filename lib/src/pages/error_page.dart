import 'package:flutter/material.dart';
import '../const/const.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      error,
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    ));
  }
}
