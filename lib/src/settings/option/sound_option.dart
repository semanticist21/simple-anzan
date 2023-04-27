import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:just_audio/just_audio.dart' as just;

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  static final audioplayer = AudioPlayer();
  static final countplayer = AudioPlayer();

  static final audioAndroidPlayer = just.AudioPlayer();

  static final _audioAsset = AssetSource('beep_short_two.wav');
  static final _countDownAsset = AssetSource('count.wav');

  static final _androidAsset =
      just.AudioSource.asset('assets/beep_short_out_amplified.wav');
  static final _emptyAsset = just.AudioSource.asset('assets/empty.wav');
  static final _countDownAndroidAsset =
      just.AudioSource.asset('assets/count.wav');

  SoundOptionHandler(SharedPreferences pref);

  Future<void> initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);
  }

  Future<void> initPlaySound() async {
    if (!Platform.isWindows) {
      await audioAndroidPlayer.setAudioSource(_emptyAsset);
      await audioAndroidPlayer.load();
      await audioAndroidPlayer.play();
      await audioAndroidPlayer.stop();

      await audioAndroidPlayer.setAudioSource(_androidAsset);
      await audioAndroidPlayer.load();
    } else {
      await countplayer.setVolume(1);
      await audioplayer.setVolume(1);
    }
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      if (!Platform.isWindows) {
        await audioAndroidPlayer.pause();
        await audioAndroidPlayer.seek(Duration.zero);
        await audioAndroidPlayer.play();
      } else {
        await audioplayer.seek(Duration.zero);
        await audioplayer.play(_audioAsset);
      }
    }
  }

  Future<void> stopAudio() async {
    await audioplayer.stop();
  }

  Future<void> playCountSound() async {
    if (isSoundOn) {
      if (!Platform.isWindows) {
        await audioAndroidPlayer.stop();

        await audioAndroidPlayer.setAudioSource(_countDownAndroidAsset);
        await audioAndroidPlayer.seek(Duration.zero);
        await audioAndroidPlayer.play();

        await Future.delayed(
            audioAndroidPlayer.duration! + const Duration(milliseconds: 100));
      } else {
        await audioplayer.seek(Duration.zero);
        await audioplayer.play(_countDownAsset);
      }
    }
  }

  Future<void> resetSource() async {
    if (!Platform.isWindows) {
      await audioAndroidPlayer.stop();
      await audioAndroidPlayer.setAudioSource(_androidAsset);
      await audioAndroidPlayer.load();
    }
  }

  Future<void> stopCountAudio() async {
    await countplayer.stop();
  }
}
