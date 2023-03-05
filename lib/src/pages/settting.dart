import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        alignment: Alignment.center,
        color: const ColorScheme.dark().background,
        child: Center(
          child: FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(158, 158, 158, 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromRGBO(96, 125, 139, 0.1))),
            ),
          ),
        ),
      ),
    );
  }
}
