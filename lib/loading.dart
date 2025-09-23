import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  static Image image = Image.asset('assets/icon_512.png');

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: loadImage(),
          builder: (context, snapshot) {
            var out = snapshot.data;
            if (out == null || !out) {
              return const SizedBox();
            } else {
              return FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: FittedBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Loading.image,
                        ),
                        const SizedBox(height: 20),
                        FittedBox(
                            child: Text('app.name'.tr(),
                                style: const TextStyle(
                                    color: Colors.black87,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal)))
                      ])));
            }
          }),
    );
  }

  Future<bool> loadImage() async {
    await precacheImage(Loading.image.image, context);
    return Future.value(true);
  }
}
