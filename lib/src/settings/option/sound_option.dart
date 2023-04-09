import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();
  static bool _flag = false;

  final _audioplayer = AudioPlayer();
  final _audioplayer2 = AudioPlayer();

  final audioAsset = AudioSource.asset('assets/beep_short_out.wav');
  final emptyAsset = AudioSource.asset('assets/empty.wav');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    if (Platform.isAndroid) {
      await _audioplayer.setAudioSource(emptyAsset);
      await _audioplayer2.setAudioSource(emptyAsset);

      await _audioplayer.play();
      await _audioplayer2.play();

      await _audioplayer.load();
      await _audioplayer2.load();

      await _audioplayer.stop();
      await _audioplayer2.stop();
    }

    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);
  }

  Future<void> initPlaySound() async {
    await _audioplayer.setVolume(0.5);
    await _audioplayer2.setVolume(0.5);

    await _audioplayer.setAudioSource(audioAsset);
    await _audioplayer2.setAudioSource(audioAsset);

    await _audioplayer.load();
    await _audioplayer2.load();
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      if (_flag) {
        _flag = false;
        if (Platform.isWindows) {
          await _audioplayer.pause();
        }
        await _audioplayer.seek(Duration.zero);
        await _audioplayer.play();
      } else {
        _flag = true;
        if (Platform.isWindows) {
          await _audioplayer2.pause();
        }
        await _audioplayer2.seek(Duration.zero);
        await _audioplayer2.play();
      }
    }
  }

  Future<void> stopAudio() async {
    await _audioplayer.stop();
    await _audioplayer2.stop();
  }
}
