import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();
  static bool _flag = false;

  final _audioplayer = AudioPlayer();
  final _audioplayer2 = AudioPlayer();

  final audioAsset = AudioSource.file('assets/beep_short.mp3');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    await _audioplayer.setAudioSource(audioAsset);
    await _audioplayer2.setAudioSource(audioAsset);

    await _audioplayer.setVolume(1);
    await _audioplayer2.setVolume(1);

    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      if (_flag) {
        _flag = false;
        await _audioplayer.stop();
        await _audioplayer.seek(Duration.zero);
        await _audioplayer.play();
      } else {
        _flag = true;
        await _audioplayer2.stop();
        await _audioplayer2.seek(Duration.zero);
        await _audioplayer2.play();
      }
    }
  }
}
