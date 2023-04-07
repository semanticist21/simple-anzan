import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  final audioAsset = AudioSource.file('assets/beep_short.mp3');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      AudioPlayer()
        ..setAudioSource(audioAsset)
        ..setVolume(1)
        ..play();
    }
  }
}
