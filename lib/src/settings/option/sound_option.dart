import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SoundOption {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  SoundOption(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
  }
}
