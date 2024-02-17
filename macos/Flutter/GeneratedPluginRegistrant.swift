//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audioplayers_darwin
import path_provider_foundation
import screen_retriever
import shared_preferences_foundation
import soundpool_macos
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioplayersDarwinPlugin.register(with: registry.registrar(forPlugin: "AudioplayersDarwinPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SwiftSoundpoolPlugin.register(with: registry.registrar(forPlugin: "SwiftSoundpoolPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
