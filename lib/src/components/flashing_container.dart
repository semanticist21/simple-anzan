import 'package:abacus_simple_anzan/src/settings/option/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class FlashingContainer extends StatefulWidget {
  FlashingContainer({super.key});

  final containerState = FlashingContainerState();

  @override
  // ignore: no_logic_in_create_state
  State<FlashingContainer> createState() => containerState;
}

class FlashingContainerState extends State<FlashingContainer> {
  bool _isFlashing = false;

  Future<void> startFlashing() async {
    setState(() {
      _isFlashing = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isFlashing = false;
      });
    });

    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
          color: _isFlashing
              ? ThemeSelector.isDark
                  ? Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.15)
                  : Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.3)
              : Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.shadow)),
    );
  }
}
