//
// app_config.dart
// PawMind Flutter Configuration
//
// Runtime configuration for Server Mode and On-Device Pro Mode
//

import 'package:flutter/foundation.dart';

/// App-wide configuration
class AppConfig {
  // MARK: - Server Mode (Existing)

  /// WebSocket URL for server-based inference
  ///
  /// Set via --dart-define=PAWS_WS_URL or runtime detection
  static String pawsWsUrl = const String.fromEnvironment(
    'PAWS_WS_URL',
    defaultValue: 'ws://localhost:5680',
  );

  /// Default TTS provider for Server Mode
  static const TtsProvider kDefaultTtsProvider = TtsProvider.cosyvoice;

  /// Frame capture interval (milliseconds)
  static const int kFrameIntervalMs = 5000;

  /// JPEG quality (0–100)
  static const int kJpegQuality = 85;

  /// Frame dimensions (resized before sending to server)
  static const int kFrameWidth = 640;
  static const int kFrameHeight = 480;

  // MARK: - On-Device Pro Mode (NEW for POC)

  /// Enable On-Device Pro Mode toggle in UI
  ///
  /// Set to false during POC development, true when ready for beta
  static bool onDeviceEnabled = false;

  /// Default Pro Mode state (user can toggle in settings)
  static const bool kDefaultOnDeviceEnabled = false;

  /// On-device LLM max tokens (reduced for latency)
  static const int kOnDeviceMaxTokens = 30;

  /// On-device frame dimensions (may differ from server mode)
  static const int kOnDeviceFrameWidth = 640;
  static const int kOnDeviceFrameHeight = 480;

  /// Model download URLs (for production - download on-demand)
  static const String kPhi3ModelUrl =
      'https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4_0.gguf';
  static const String kPiperVoiceUrl =
      'https://github.com/rhasspy/piper-models/releases/download/v1.0.0/en_US-lessac-medium.tar.gz';

  // MARK: - Feature Flags

  /// Enable debug overlay (latency, model status)
  static const bool kShowDebugOverlay = true;

  /// Enable latency logging
  static const bool kLogLatency = true;

  /// Enable model download on-demand (vs. bundled)
  static const bool kDownloadModelsOnDemand = true;

  // MARK: - Device Requirements

  /// Minimum iOS version for Pro Mode
  static const String kMinIosVersion = '15.0';

  /// Minimum RAM for Pro Mode (GB)
  static const int kMinRamGb = 6;

  /// Recommended devices for Pro Mode
  static const List<String> kRecommendedDevices = [
    'iPhone 14',
    'iPhone 14 Pro',
    'iPhone 15',
    'iPhone 15 Pro',
    'Pixel 7',
    'Pixel 8',
  ];
}

/// TTS Provider Enum
enum TtsProvider {
  cosyvoice,  // Server-based (existing)
  native,     // Device TTS (existing fallback)
  piper,      // On-device Piper (NEW for POC)
  coqui,      // On-device Coqui XTTS (future)
}

/// Inference Mode
enum InferenceMode {
  server,     // Cloud-based (existing)
  onDevice,   // Local ML (NEW for POC)
}

// MARK: - Runtime Helpers

/// Get current inference mode based on config
InferenceMode get currentInferenceMode {
  return AppConfig.onDeviceEnabled
      ? InferenceMode.onDevice
      : InferenceMode.server;
}

/// Get current TTS provider based on mode
TtsProvider get currentTtsProvider {
  if (AppConfig.onDeviceEnabled) {
    return TtsProvider.piper;  // On-device uses Piper
  }
  return AppConfig.kDefaultTtsProvider;  // Server uses CosyVoice
}

/// Log configuration (debug only)
void logConfig() {
  if (!kDebugMode) return;

  debugPrint('📦 PawMind Configuration:');
  debugPrint('  - Server WS: ${AppConfig.pawsWsUrl}');
  debugPrint('  - Default TTS: ${AppConfig.kDefaultTtsProvider}');
  debugPrint('  - Pro Mode Enabled: ${AppConfig.onDeviceEnabled}');
  debugPrint('  - Debug Overlay: ${AppConfig.kShowDebugOverlay}');
  debugPrint('  - Inference Mode: ${currentInferenceMode}');
  debugPrint('  - TTS Provider: ${currentTtsProvider}');
}
