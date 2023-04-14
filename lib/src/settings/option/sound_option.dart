import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = true;
  static StreamController<bool> isSoundOnStream = StreamController();

  static final audioplayer = AudioPlayer();
  static final countplayer = AudioPlayer();

  static final _audioAsset = AssetSource('beep_short_two.wav');
  static final _audioAndroidAsset = AssetSource('beep_short_out_amplified.wav');
  static final _countDownAsset = AssetSource('count.wav');

  SoundOptionHandler(SharedPreferences pref) {
    _initSettings(pref);
  }

  Future<void> _initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);
  }

  Future<void> initPlaySound() async {
    await audioplayer.setVolume(1);
    await countplayer.setVolume(1);
  }

  Future<void> playSound() async {
    if (isSoundOn) {
      if (!Platform.isWindows) {
        await audioplayer.seek(Duration.zero);
        await audioplayer.play(_audioAndroidAsset);
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
      await countplayer.seek(Duration.zero);
      await countplayer.play(_countDownAsset);
    }
  }

  Future<void> stopCountAudio() async {
    await countplayer.stop();
  }
}
