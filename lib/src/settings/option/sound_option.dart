import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:universal_io/io.dart';

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

  int _beepSoundId = 0;
  int _countDownSoundId = 0;

  // windows source
  static final windowsPlayer = AudioPlayer();

  final AssetSource _windowBeepSource = AssetSource('beep_new.wav');
  final AssetSource _windowCountDownSource = AssetSource('notify.mp3');

  Future<void> initSettings(SharedPreferences pref) async {
    var prefs = await SharedPreferences.getInstance();
    isSoundOn = prefs.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);

    if (Platform.isWindows) {
      await initWindowsSettings();
    } else {
      await initMobileSettings();
    }
  }

  Future<void> initWindowsSettings() async {
    await windowsPlayer.setVolume(1);
    await windowsPlayer.setReleaseMode(ReleaseMode.release);
    await windowsPlayer.release();
  }

  Future<void> initMobileSettings() async {
    ByteData value = await rootBundle.load('assets/beep_new.wav');
    _beepSoundId = await pool.load(value);

    value = await rootBundle.load('assets/notify.mp3');
    _countDownSoundId = await pool.load(value);

    await pool.setVolume(soundId: _beepSoundId, volume: 1);
    await pool.setVolume(soundId: _countDownSoundId, volume: 1);
  }

  Future<void> playSound() async {
    if (Platform.isWindows) {
      await playWindowsSound();
    } else {
      await playMobileSound();
    }
  }

  Future<void> playWindowsSound() async {
    if (!isSoundOn) return;

    await windowsPlayer.seek(Duration.zero);
    await windowsPlayer.play(_windowBeepSource);
  }

  Future<void> playMobileSound() async {
    // 사운드 체크
    if (!isSoundOn) return;

    // 사운드 재생
    await pool.play(_beepSoundId, rate: 1.0);
  }

  Future<void> playCountSound() async {
    if (Platform.isWindows) {
      await playWindowsCountSound();
    } else {
      await playMobileCountSound();
    }
  }

  Future<void> playWindowsCountSound() async {
    if (!isSoundOn) return;

    await windowsPlayer.seek(Duration.zero);
    await windowsPlayer.play(_windowCountDownSource);
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> playMobileCountSound() async {
    // 사운드 체크
    if (!isSoundOn) return;

    // 사운드 재생
    await pool.play(_countDownSoundId);
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
