import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final Image asset = Image.asset('assets/icon_512.png');
  var _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: Visibility(
              visible: _visible,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    asset,
                    const SizedBox(height: 20),
                    FittedBox(
                        child: Text(LocalizationChecker.appName,
                            style: const TextStyle(
                                color: Colors.black87,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Future<void> loadImage() async {
    await precacheImage(asset.image, context);
    if (context.mounted) {
      setState(() {
        _visible = true;
      });
    }
  }
}
