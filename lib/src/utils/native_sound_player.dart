import 'package:flutter/services.dart';

/// A lightweight native sound player for Android
/// This class provides a similar interface to Soundpool but uses native Android MediaPlayer
class NativeSoundPlayer {
  static const MethodChannel _channel =
      MethodChannel('com.kobbokkom.abacus_simple_anzan/sound_player');

  /// Loads a sound asset and returns a sound ID
  Future<int> load(ByteData data, {String assetName = ''}) async {
    try {
      if (assetName.isEmpty) {
        throw Exception('Asset name must be provided');
      }
      
      final int soundId = await _channel.invokeMethod('load', {
        'assetName': assetName,
      });
      return soundId;
    } catch (e) {
      print('Error loading sound: $e');
      return -1;
    }
  }

  /// Plays a previously loaded sound
  Future<int> play(int soundId, {double rate = 1.0}) async {
    try {
      await _channel.invokeMethod('play', {
        'soundId': soundId,
        'rate': rate,
      });
      return 0; // Success
    } catch (e) {
      print('Error playing sound: $e');
      return -1;
    }
  }

  /// Sets volume for a sound
  Future<void> setVolume({
    required int soundId,
    required double volume,
  }) async {
    try {
      await _channel.invokeMethod('setVolume', {
        'soundId': soundId,
        'volume': volume,
      });
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Releases a specific sound
  Future<void> release(int soundId) async {
    try {
      await _channel.invokeMethod('release', {
        'soundId': soundId,
      });
    } catch (e) {
      print('Error releasing sound: $e');
    }
  }

  /// Releases all sounds
  Future<void> releaseAll() async {
    try {
      await _channel.invokeMethod('releaseAll');
    } catch (e) {
      print('Error releasing all sounds: $e');
    }
  }
}
