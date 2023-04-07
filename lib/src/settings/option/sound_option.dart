import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  final audioPlayer = AudioPlayer();
  final audioAsset = AssetSource('beep_short.mp3');

  SoundOptionHandler(SharedPreferences pref) {
    audioPlayer.setVolume(1);
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
  }

  Future<void> playSound() async {
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
