import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SoundOptionHandler {
  static var soundKey = 'isSoundOn';
  static var isSoundOn = false;
  static StreamController<bool> isSoundOnStream = StreamController();

  SoundOptionHandler(SharedPreferencesWithCache pref);

  // SoLoud instance
  static final _soloud = SoLoud.instance;

  // Audio sources
  AudioSource? _beepSource;
  AudioSource? _countDownSource;

  Future<void> initSettings(SharedPreferencesWithCache pref) async {
    isSoundOn = pref.getBool(soundKey) ?? true;
    SoundOptionHandler.isSoundOnStream.add(SoundOptionHandler.isSoundOn);

    // Initialize SoLoud
    await _soloud.init();

    // Load platform-specific audio sources
    try {
      String beepAsset;
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Desktop platforms use WAV files
        beepAsset = 'assets/beep_new.wav';
      } else if (Platform.isAndroid) {
        // Android uses OGG files
        beepAsset = 'assets/beep_new.ogg';
      } else if (Platform.isIOS) {
        // iOS uses M4A files
        beepAsset = 'assets/beep_new.m4a';
      } else {
        // Fallback to WAV
        beepAsset = 'assets/beep_new.wav';
      }

      _beepSource = await _soloud.loadAsset(beepAsset);
      _countDownSource = await _soloud.loadAsset('assets/notify_compress.mp3');
    } catch (e) {
      // Audio loading failed silently
    }
  }

  Future<void> playSound() async {
    if (!isSoundOn || _beepSource == null) return;

    try {
      await _soloud.play(_beepSource!);
    } catch (e) {
      // Sound playback failed silently
    }
  }

  Future<void> playCountSound() async {
    if (!isSoundOn || _countDownSource == null) return;

    try {
      await _soloud.play(_countDownSource!);
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      // Countdown sound playback failed silently
    }
  }

  // Dispose method to clean up resources
  Future<void> dispose() async {
    if (_beepSource != null) {
      await _soloud.disposeSource(_beepSource!);
    }
    if (_countDownSource != null) {
      await _soloud.disposeSource(_countDownSource!);
    }
  }
}
