import 'package:flutter/material.dart';

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
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: _isFlashing
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
