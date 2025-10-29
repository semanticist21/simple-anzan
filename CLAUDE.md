# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Simple Anzan App - A Flutter-based mental math training application for practicing addition and multiplication calculations (abacus-style). The app supports multiple platforms: Android, iOS, Windows, macOS, Linux, and Web.

Current version: 4.1.7+75

## Development Commands

### Flutter Development

- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in development mode
- `flutter run -d <device>` - Run on specific device (chrome, macos, windows, android, etc.)
- `flutter build apk` - Build Android APK
- `flutter build appbundle` - Build Android App Bundle (AAB) for Play Store
- `flutter build ios` - Build iOS app (requires macOS and Xcode)
- `flutter build web` - Build web version
- `flutter build windows` - Build Windows executable
- `flutter build macos` - Build macOS app
- `flutter build linux` - Build Linux executable

### Code Quality

- `flutter analyze` - Run static analysis (uses analysis_options.yaml with flutter_lints)
- `flutter test` - Run all unit tests
- `flutter test test/functions_test.dart` - Run specific test file

### Asset Management

- `flutter pub run flutter_launcher_icons:main` - Generate app icons from assets/icon.png

## Architecture

### Dual-Mode Parallel Structure

The app implements a complete parallel architecture for two calculation modes (addition and multiplication). Each mode has:
- Dedicated home page (HomePage / HomeMultiplyPage)
- Dedicated settings page (SettingsPage / SettingsMultiplyPage)
- Dedicated state provider (StateProvider / StateProviderMultiply)
- Dedicated settings manager (SettingsManager / SettingsMultiplyManager)
- Dedicated flicker component (Flicker / FlickerMultiply)

This parallel structure means modifications to one mode often require corresponding changes to the other mode to maintain feature parity.

### Core Application Structure

Four-tab navigation managed through bottom navigation bar:

1. Addition mode (`/` - HomePage) - tab index 0
2. Addition settings (`/settings` - SettingsPage) - tab index 1
3. Multiplication mode (`/multiply` - HomeMultiplyPage) - tab index 2
4. Multiplication settings (`/settings/multiply` - SettingsMultiplyPage) - tab index 3

Navigation is handled by `router.dart` using custom routes with state-aware navigation that **blocks tab switching during active iterations** (iterationStarted state).

### State Management Architecture

Uses Provider pattern with parallel state providers:

- `StateProvider` - Addition mode state with `ButtonState` enum
- `StateProviderMultiply` - Multiplication mode state with `ButtonMultiplyState` enum

**State Machine**: Both use identical finite state machines:
```
iterationNotStarted → iterationStarted → iterationCompleted → iterationNotStarted
```

**State Controls**:
- Button visibility and text based on current state
- Problem list generation and storage
- Integration with "burning mode" for infinite iterations
- Tab switching lockout during `iterationStarted`
- Automatic state reset to `iterationNotStarted` after 500ms tab switch delay

**Important State Behaviors**:
- Burning mode keeps button visible during `iterationStarted` with special text
- Stop iteration button (X icon) visible only during addition mode iteration
- State checking in `_onTap` prevents mid-calculation tab switches

### Settings Architecture Pattern

Implements a sophisticated generic preference interface system:

**Interface Layer** (`lib/src/settings/Interface/`):

`PreferenceInterface<T, V>` - Abstract base class providing:
- Type-safe preference management with generic enum type `T` and value type `V`
- Automatic SharedPreferences persistence via `_saveKey` and `_defaultIndex`
- Bidirectional conversion: `valueToEnum(V)` and `enumToValue(T)`
- Synchronized `setValue(T)` and `setIndex(int)` methods

**Implementation Pattern**:
```dart
class DigitPref extends PreferenceInterface<Digit, int> {
  @override
  void setValue(Digit enumValue) {
    _currentValue = enumValue;
    _currentIndex = enumValue.index;
  }

  @override
  int enumToValue(Digit enumType) {
    // Extract number from enum name (e.g., n_3 → 3)
  }
}
```

**Manager Layer**:
- `SettingsManager` - Manages all addition mode preferences (digit, speed, questions, burning mode, etc.)
- `SettingsMultiplyManager` - Manages all multiplication mode preferences
- `OptionManager` - Manages global app options (theme, sound, color palette)

Each manager holds instances of specific preference classes and provides type-safe getters via generic `getCurrentEnum<T>()`.

### Theme System Architecture

**Color Palette System** (`lib/src/settings/option/`):

Six shadcn-inspired themes with separate light/dark variants:
- Blue (default) - Material blue
- Green - shadcn green-500/600
- Sky - shadcn sky-400/500
- Yellow - shadcn yellow-400/500
- Violet - shadcn violet-400/500
- Slate - shadcn slate-400/500 (grey tone)

**Theme Management**:
- `ThemeSelector` - Manages theme state with reactive stream-based updates
- Light/dark mode switching via `isDark` boolean and `isDarkStream`
- Color palette switching via `currentPalette` and `colorPaletteStream`
- System theme detection on first launch (respects OS dark mode preference)
- `getFlickerTextColor(BuildContext)` - Returns black text for default theme in light mode, primary color otherwise (special handling for number display readability)

**Theme Integration Points** (must stay synchronized):
1. Color definitions in `ThemeSelector.getPrimaryColor()` with separate light/dark values
2. Theme picker colors in `theme_color_picker.dart` availableColors array
3. Color-to-palette mapping in `main.dart` `_updateThemeColor()` method
4. Flicker text color logic via `ThemeSelector.getFlickerTextColor()`

### Flicker Component Architecture

`Flicker` and `FlickerMultiply` are the core number display widgets:

**Responsibilities**:
- Display numbers during iteration with timed intervals based on speed setting
- Handle countdown notifications (3-2-1) before starting if countdown mode enabled
- Manage burning mode cycles (infinite iteration): 2s answer display → 3s delay → next problem
- Apply dynamic font sizing: static for 1-5 digits, scaled for 6-9 digits to prevent overflow
- Integrate with sound system for audio feedback on each number

**State Integration**:
- Listens to StateProvider/StateProviderMultiply for button state changes
- Uses Timer for burning mode scheduling and iteration control
- Properly cleans up listeners and timers in dispose() to prevent memory leaks

**Styling**:
- Google Fonts "Gamja Flower" for handwritten aesthetic (bundled in `assets/google_fonts/GamjaFlower-Regular.ttf` for release builds)
- Dynamic font sizing based on digit count
- Theme-aware text color via `ThemeSelector.getFlickerTextColor()`
- Number alignment handling with pre-calculated sign width to prevent layout shift

### Internationalization Architecture

- Uses easy_localization with JSON translation files in `assets/translations/`
- Supports 9 languages: English (en), Korean (ko), Japanese (ja), Uzbek (uz), Burmese (my), French (fr), Arabic (ar), Indonesian (id), Chinese (zh)
- Fallback locale is English
- Translation keys follow hierarchical structure (e.g., `settings.speed`, `buttons.start`, `themePicker.default`)
- Language selector available in settings pages (tabs 1 and 3) with flag emoji icons

**CRITICAL**: When adding or modifying UI text, ALL 9 language translations must be updated simultaneously. The Korean note at the end of this file emphasizes this requirement: 문구 수정 시 반드시 모든 언어 번역에 대해 진행할 것.

### Audio System Architecture

- Uses flutter_soloud for high-performance, low-latency audio playback
- Managed through `SoundOptionHandler` with reactive `isSoundOnStream` stream
- Platform-optimized audio formats:
  - Desktop/iOS: `beep_new.wav`
  - Android: `beep_new.ogg`
  - Countdown: `notify_compress.mp3`
- Global sound toggle with persistence via `OptionManager.setSoundBool()`
- Audio players automatically disposed on app exit

### Platform-Specific Features

**Windows Platform**:

- Window management via window_manager (minimum 1024×768, default 400×600)
- Custom error logging to `errors.txt` in current directory via FlutterError.onError handler
- ExitWatcher wrapper for proper app lifecycle management
- Windows-specific toolbar options (preset management, fast settings dialogs)
- SQLite database initialization required (sqflite_common_ffi) in `main.dart` `_init()`

**Android Platform**:

- Targets Android 15 (API 35, compileSDK 36) with 16KB page size compliance
- Package: com.kobbokkom.abacus_simple_anzan
- Kotlin-based MainActivity integration (Java 11 target)
- ProGuard enabled for release builds with resource shrinking
- MultiDex enabled
- Debug symbols: FULL level for Play Console crash diagnostics
- NDK filters: armeabi-v7a, arm64-v8a, x86_64

**iOS Platform**:

- Bundle ID: com.kobbokkom.abacussimpleanzan

## Key Directories

### Core Structure

- `lib/main.dart` - App entry point with platform-specific initialization, theme management, navigation
- `lib/router.dart` - Centralized routing configuration (5 routes)
- `lib/client.dart` - Database client and data management for presets (Windows only)
- `lib/custom_route.dart` - Custom route animations

### Source Organization

- `lib/src/pages/` - Main UI pages (4 primary screens: 2 home + 2 settings)
- `lib/src/provider/` - State management providers (StateProvider, StateProviderMultiply)
- `lib/src/settings/` - Settings management system
  - `Interface/` - Generic preference interface base classes
  - `plus_pref/` - Addition mode preferences (digit, speed, questions, burning mode, countdown, shuffle, separator, calculation mode)
  - `multiply_prefs/` - Multiplication mode preferences (big digit, small digit, speed, questions, burning mode, countdown, separator, calculation mode)
  - `option/` - Global app options (theme selector, sound, color palette)
- `lib/src/components/` - Reusable UI components (Flicker, FlickerMultiply, FlashingContainer)
- `lib/src/dialog/` - Modal dialogs (problem list, presets, fast settings, theme/color pickers, alerts)
- `lib/src/model/` - Data models (PresetAddModel, PresetMultiplyModel, SaveInfo)
- `lib/src/functions/` - Utility functions and business logic
- `lib/src/const/` - Constants and styling definitions

## Important Files

### Configuration

- `pubspec.yaml` - Dependencies and app metadata (version 4.1.7+75)
- `analysis_options.yaml` - Flutter linting configuration using flutter_lints
- `android/app/build.gradle` - Android build settings (API 35, 16KB page support, ProGuard config)

### Assets & Localization

- `assets/icon.png` - Source icon for multi-platform generation
- `assets/icon_48.png` - Windows-specific icon (48×48)
- `assets/translations/` - JSON translation files (9 languages: en/ko/ja/uz/my/fr/ar/id/zh)
- `assets/beep_new.wav` - Desktop/iOS beep sound
- `assets/beep_new.ogg` - Android beep sound
- `assets/notify_compress.mp3` - Countdown notification sound

### Database

- SQLite database via sqflite_common_ffi for cross-platform preset storage (Windows only)
- Two tables: `add_presets` for addition, `multiply_presets` for multiplication
- Preset models with JSON serialization for configuration export/import

## Release Notes Management

### Release Notes Files

- `release_notes-ios.xml` - iOS App Store release notes (supports 5 languages)
- `release_notes.xml` - Android Play Store release notes (supports 57 languages)
- `keywords-ios.xml` - iOS App Store keywords/search terms (supports 5 languages: en-US, ko-KR, ja-JP, zh-CN, zh-TW)

### iOS App Store Languages (release_notes-ios.xml)

When updating iOS release notes, translations must be provided for these 5 languages:
1. 영어 (English)
2. 한국어 (Korean)
3. 일본어 (Japanese)
4. 중국어(간체) (Chinese Simplified)
5. 중국어(번체) (Chinese Traditional)

### Android Play Store Languages (release_notes.xml)

When updating Android release notes, translations must be provided for ALL 57 supported languages:

**Primary Languages**:
- en-US (English US), en-GB (English GB)
- ko-KR (Korean)
- ja-JP (Japanese)
- zh-CN (Chinese Simplified), zh-HK (Chinese Hong Kong), zh-TW (Chinese Traditional)

**European Languages**:
- de-DE (German), fr-FR (French), fr-CA (French Canada)
- es-ES (Spanish Spain), es-419 (Spanish Latin America)
- it-IT (Italian), pt-PT (Portuguese Portugal), pt-BR (Portuguese Brazil)
- nl-NL (Dutch), pl-PL (Polish), ru-RU (Russian), uk (Ukrainian)
- cs-CZ (Czech), sk (Slovak), sl (Slovenian), hr (Croatian), sr (Serbian)
- bg (Bulgarian), ro (Romanian), hu-HU (Hungarian)
- da-DK (Danish), no-NO (Norwegian), sv-SE (Swedish), fi-FI (Finnish)
- el-GR (Greek), et (Estonian), lt (Lithuanian), lv (Latvian)

**Middle Eastern & Asian Languages**:
- ar (Arabic), iw-IL (Hebrew), fa (Persian), tr-TR (Turkish)
- hi-IN (Hindi), th (Thai), vi (Vietnamese), id (Indonesian), ms (Malay)

**African Languages**:
- af (Afrikaans), am (Amharic), sw (Swahili), zu (Zulu)

**CRITICAL**: When modifying release notes or keywords for either platform:
1. **iOS Release Notes**: Update ALL 5 language tags in `release_notes-ios.xml`
2. **iOS Keywords**: Update ALL 5 language tags in `keywords-ios.xml` (max 100 characters per language)
3. **Android Release Notes**: Update ALL 57 language tags in `release_notes.xml`
4. Never publish with missing or incomplete translations
5. Maintain consistent messaging across all language variants
6. Test XML validity before committing changes

This requirement is emphasized in the Korean note at the end of this file: "문구 수정 시 반드시 모든 언어 번역에 대해 진행할 것" (When modifying text, translations must be updated for ALL languages).

## Key Dependencies

### Core Framework

- `provider: ^6.1.5` - State management
- `shared_preferences: ^2.5.3` - Local storage with caching for preferences
- `easy_localization: ^3.0.8` - Internationalization framework

### Audio & UI

- `flutter_soloud: ^3.3.6` - High-performance audio system
- `animated_toggle_switch: ^0.8.3` - Custom toggle controls (theme, sound)
- `flutter_colorpicker: ^1.1.0` - Color selection widgets (BlockPicker for theme picker)
- `google_fonts: ^6.2.1` - Typography system (uses "Gamja Flower" for numbers)

### Platform Support

- `window_manager: ^0.5.1` - Desktop window management
- `universal_io: ^2.2.2` - Cross-platform IO operations
- `sqflite_common_ffi: ^2.3.6` - Cross-platform SQLite

## Development Patterns

### State Transitions

Both calculation modes use identical finite state machines:

```
iterationNotStarted → iterationStarted → iterationCompleted → iterationNotStarted
```

State changes trigger UI updates for:
- Button visibility and text
- Available actions (tab switching lockout)
- Problem list generation

### Burning Mode Integration

Special infinite iteration mode with distinct behavior:
- Bypasses normal `iterationCompleted` state
- Mode-specific implementation in both StateProvider classes
- Automatic cycling: 2s answer display → 3s delay → next problem
- Visual indicators (fire icon with color change when active)
- Different button text during iteration: "연소 중..." / "On Burning" (localized)
- Separate burning mode preference for each calculation mode

### Preset System

- JSON serialization for preset configurations (digit settings, speed, question count, etc.)
- Cross-mode preset management with dedicated list dialogs
- Platform-specific fast-setting dialogs for quick configuration (Windows only)
- SQLite storage for Windows platform (`preset.db` in `save/` directory)
- Two separate tables with mode-specific models
- Preset application through settings managers: `PresetAddModel.saveItem()` and `PresetMultiplyModel.saveItem()`

### Navigation State Management

- Tab switching **blocked** during active iterations (`iterationStarted` state)
- Automatic state reset to `iterationNotStarted` when switching tabs after completion
- 500ms delay after tab navigation for smooth transitions
- State checking in `_onTap` method prevents mid-calculation interruptions
- Independent state management for each mode (addition/multiplication)

### Theme Color Integration

When modifying theme-related features, these four points must stay synchronized:

1. Color definitions in `ThemeSelector.getPrimaryColor()` with separate light/dark values
2. Theme picker colors in `theme_color_picker.dart` availableColors array must match exactly
3. Color-to-palette mapping in `main.dart` `_updateThemeColor()` must be synchronized
4. Special text color handling for flicker components uses `ThemeSelector.getFlickerTextColor()`

Color palette changes trigger stream updates that rebuild the entire app with new colors.

### Parallel Mode Pattern

When adding features, consider whether both addition and multiplication modes need the same feature:
- If yes, implement in both parallel structures (StateProvider + StateProviderMultiply, etc.)
- Settings preferences require separate enums and preference classes for each mode
- Dialogs and UI components may need mode-specific variants
- Always test both modes to ensure feature parity

문구 수정 시 반드시 모든 언어 번역에 대해 진행할 것.
