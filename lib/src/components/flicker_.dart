import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_anzan/src/provider/state_provider.dart';

class FlickerText extends StatefulWidget {
  final String text = '';
  final Duration interval = const Duration(milliseconds: 1000);

  // TODO
  FlickerText({super.key});

  @override
  State<FlickerText> createState() => _FlickerTextState();
}

class _FlickerTextState extends State<FlickerText>
    with SingleTickerProviderStateMixin {
  final key = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.interval,
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 24),
          ),
        );
      },
    ));
  }

  // TODO
  bool _initiateNumberIteration() {
    return true;
  }

  // styles.
  TextStyle getMainNumberTextStyle() {
    return const TextStyle(
      fontSize: 100,
      fontWeight: FontWeight.w900,
      fontFamily: 'consolas',
      letterSpacing: 3,
      color: Color.fromARGB(255, 113, 150, 67),
    );
  }
}
