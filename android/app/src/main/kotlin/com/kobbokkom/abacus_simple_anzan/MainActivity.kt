package com.kobbokkom.abacus_simple_anzan

import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge display for Android 15+ (SDK 35+)
        // This ensures proper inset handling and wider screen display
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // NativeSoundPlayer registration removed as requested
    }
}
