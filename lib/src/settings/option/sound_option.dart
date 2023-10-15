import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = false;
  static StreamController<bool> isSoundOnStream = StreamController();

  SoundOptionHandler(SharedPreferences pref);

  static SoundpoolOptions options = const SoundpoolOptions(
    maxStreams: 2,
    streamType: StreamType.ring,
  );

  static Soundpool pool = Soundpool.fromOptions(options: options);
  static Soundpool pool2 = Soundpool.fromOptions(options: options);

  int _beepSoundId = 0;
  int _beepSoundId2 = 0;
  bool _switch = false;

  int _countDownSoundId = 0;

  Future<void> initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);

    ByteData value = await rootBundle.load('assets/beep_new.wav');
    _beepSoundId = await pool.load(value);

    ByteData value2 = await rootBundle.load('assets/beep_new-spare.wav');
    _beepSoundId2 = await pool2.load(value2);

    value = await rootBundle.load('assets/notify.mp3');
    _countDownSoundId = await pool.load(value);
  }

  Future<void> playSound() async {
    // 사운드 체크
    if (isSoundOn) {
      await pool.setVolume(soundId: _beepSoundId, volume: 1);
      await pool2.setVolume(soundId: _beepSoundId2, volume: 0);
    } else {
      await pool.setVolume(soundId: _beepSoundId, volume: 0);
      await pool2.setVolume(soundId: _beepSoundId2, volume: 0);
    }

    // 사운드 재생
    await pool.play(_beepSoundId, rate: 1.0);
  }

  Future<void> playCountSound() async {
    // 사운드 체크
    if (isSoundOn) {
      await pool.setVolume(soundId: _countDownSoundId, volume: 1);
    } else {
      await pool.setVolume(soundId: _countDownSoundId, volume: 0);
    }

    // 사운드 재생
    await pool.play(_countDownSoundId);
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
