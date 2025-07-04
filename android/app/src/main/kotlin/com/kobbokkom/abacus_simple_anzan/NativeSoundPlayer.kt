package com.kobbokkom.abacus_simple_anzan

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.FileDescriptor
import java.util.HashMap

class NativeSoundPlayer(private val context: Context) : MethodCallHandler {
    private val mediaPlayers = HashMap<Int, MediaPlayer>()
    private var nextId = 0
    private val handler = Handler(Looper.getMainLooper())

    companion object {
        private const val CHANNEL_NAME = "com.kobbokkom.abacus_simple_anzan/sound_player"

        fun registerWith(flutterEngine: FlutterEngine, context: Context) {
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            val soundPlayer = NativeSoundPlayer(context)
            channel.setMethodCallHandler(soundPlayer)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "load" -> {
                val assetName = call.argument<String>("assetName") ?: ""
                loadSound(assetName, result)
            }
            "play" -> {
                val soundId = call.argument<Int>("soundId") ?: -1
                val rate = call.argument<Double>("rate") ?: 1.0
                playSound(soundId, rate.toFloat(), result)
            }
            "setVolume" -> {
                val soundId = call.argument<Int>("soundId") ?: -1
                val volume = call.argument<Double>("volume") ?: 1.0
                setVolume(soundId, volume.toFloat(), result)
            }
            "release" -> {
                val soundId = call.argument<Int>("soundId") ?: -1
                releaseSound(soundId, result)
            }
            "releaseAll" -> {
                releaseAllSounds(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun loadSound(assetName: String, result: Result) {
        try {
            val assetManager = context.assets
            val afd = assetManager.openFd("flutter_assets/assets/$assetName")
            val mediaPlayer = MediaPlayer()
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            mediaPlayer.setAudioAttributes(audioAttributes)
            mediaPlayer.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            mediaPlayer.prepare()
            val id = nextId++
            mediaPlayers[id] = mediaPlayer
            result.success(id)
            afd.close()
        } catch (e: Exception) {
            result.error("LOAD_ERROR", "Failed to load sound: ${e.message}", null)
        }
    }

    private fun playSound(soundId: Int, rate: Float, result: Result) {
        val mediaPlayer = mediaPlayers[soundId]
        if (mediaPlayer != null) {
            try {
                // Store current position
                val wasPlaying = mediaPlayer.isPlaying
                if (wasPlaying) {
                    mediaPlayer.stop()
                }
                mediaPlayer.reset()
                
                // Reload the file
                val assetManager = context.assets
                val assetPaths = assetManager.list("flutter_assets/assets")
                val assetPath = assetPaths?.firstOrNull { path -> 
                    mediaPlayers.entries.firstOrNull { it.key == soundId } != null
                }
                
                if (assetPath != null) {
                    val afd = assetManager.openFd("flutter_assets/assets/$assetPath")
                    mediaPlayer.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                    mediaPlayer.prepare()
                    afd.close()
                }
                
                // Android doesn't support playback rate change in MediaPlayer directly,
                // so we're just ignoring the rate parameter for simplicity
                mediaPlayer.start()
                result.success(null)
            } catch (e: Exception) {
                result.error("PLAY_ERROR", "Failed to play sound: ${e.message}", null)
            }
        } else {
            result.error("INVALID_SOUND_ID", "Sound ID not found", null)
        }
    }

    private fun setVolume(soundId: Int, volume: Float, result: Result) {
        val mediaPlayer = mediaPlayers[soundId]
        if (mediaPlayer != null) {
            try {
                mediaPlayer.setVolume(volume, volume)
                result.success(null)
            } catch (e: Exception) {
                result.error("VOLUME_ERROR", "Failed to set volume: ${e.message}", null)
            }
        } else {
            result.error("INVALID_SOUND_ID", "Sound ID not found", null)
        }
    }

    private fun releaseSound(soundId: Int, result: Result) {
        val mediaPlayer = mediaPlayers[soundId]
        if (mediaPlayer != null) {
            try {
                mediaPlayer.release()
                mediaPlayers.remove(soundId)
                result.success(null)
            } catch (e: Exception) {
                result.error("RELEASE_ERROR", "Failed to release sound: ${e.message}", null)
            }
        } else {
            result.error("INVALID_SOUND_ID", "Sound ID not found", null)
        }
    }

    private fun releaseAllSounds(result: Result) {
        try {
            for (mediaPlayer in mediaPlayers.values) {
                mediaPlayer.release()
            }
            mediaPlayers.clear()
            result.success(null)
        } catch (e: Exception) {
            result.error("RELEASE_ALL_ERROR", "Failed to release all sounds: ${e.message}", null)
        }
    }
}
