package com.kobbokkom.abacus_simple_anzan

import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Enable edge-to-edge display for Android 15+ (SDK 35+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeSoundPlayer.registerWith(flutterEngine, applicationContext)
    }
}
