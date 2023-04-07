import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  final audioPlayer = AudioPlayer();
  final audioAsset = AssetSource('beep_short.wav');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
  }

  void playSound() {
    if (isSoundOn) {
      audioPlayer.play(audioAsset);
    }
  }

  void stopSound() {
    if (isSoundOn) {
      audioPlayer.stop();
    }
  }
}
