import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  final _audioplayer = AudioPlayer();
  final _countplayer = AudioPlayer();

  final _audioAsset = AssetSource('beep_short_two.wav');
  final _audioAndroidAsset = AssetSource('beep_short_out_amplified.wav');
  final _countDownAsset = AssetSource('count.wav');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);
  }

  Future<void> initPlaySound() async {
    await _audioplayer.setVolume(1);
    await _countplayer.setVolume(1);
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      if (!Platform.isWindows) {
        await _audioplayer.seek(Duration.zero);
        await _audioplayer.play(_audioAndroidAsset);
      } else {
        await _audioplayer.seek(Duration.zero);
        await _audioplayer.play(_audioAsset);
      }
    }
  }

  Future<void> stopAudio() async {
    await _audioplayer.stop();
  }

  Future<void> playCountSound() async {
    await _countplayer.seek(Duration.zero);
    await _countplayer.play(_countDownAsset);
  }

  Future<void> stopCountAudio() async {
    await _countplayer.stop();
  }
}
