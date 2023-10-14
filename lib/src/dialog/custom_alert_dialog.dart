import 'package:flutter/material.dart';

import '../const/localization.dart';

class CustomAlert extends StatefulWidget {
  const CustomAlert({super.key, required this.content, required this.title});
  final String title;
  final String content;

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
            color: Theme.of(context).colorScheme.primaryContainer),
      ),
      content: Text(widget.content,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Theme.of(context).colorScheme.primaryContainer)),
      actions: [
        Padding(
            padding: const EdgeInsets.all(5),
            child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  LocalizationChecker.ok,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Theme.of(context).colorScheme.primaryContainer),
                )))
      ],
    );
  }
}
