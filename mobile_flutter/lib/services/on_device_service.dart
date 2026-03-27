//
// on_device_service.dart
// PawMind On-Device Service (Pro Mode)
//
// Calls native iOS/Android ML modules via platform channels
// Extends existing dog_sim_service.dart with on-device option
//

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Result from on-device inference
class InferenceResult {
  final String thought;
  final Map<String, dynamic> vision;
  final double latency;
  final Uint8List? audio;
  final bool success;

  InferenceResult({
    required this.thought,
    required this.vision,
    required this.latency,
    this.audio,
    required this.success,
  });

  factory InferenceResult.fromJson(Map<String, dynamic> json) {
    return InferenceResult(
      thought: json['thought'] as String? ?? '',
      vision: json['vision'] as Map<String, dynamic>? ?? {},
      latency: (json['latency'] as num?)?.toDouble() ?? 0.0,
      audio: (json['audio'] as FlutterStandardTypedData?)?.data,
      success: json['success'] as bool? ?? false,
    );
  }
}

/// Model loading status
class ModelStatus {
  final bool isLoaded;
  final bool visionLoaded;
  final bool llmLoaded;
  final bool ttsLoaded;
  final int maxTokens;

  ModelStatus({
    required this.isLoaded,
    required this.visionLoaded,
    required this.llmLoaded,
    required this.ttsLoaded,
    required this.maxTokens,
  });

  factory ModelStatus.fromJson(Map<String, dynamic> json) {
    return ModelStatus(
      isLoaded: json['isLoaded'] as bool? ?? false,
      visionLoaded: json['visionLoaded'] as bool? ?? false,
      llmLoaded: json['llmLoaded'] as bool? ?? false,
      ttsLoaded: json['ttsLoaded'] as bool? ?? false,
      maxTokens: json['maxTokens'] as int? ?? 30,
    );
  }
}

/// On-Device Service (Pro Mode)
///
/// Usage:
/// ```dart
/// final service = OnDeviceService();
/// final result = await service.infer(imageBytes);
/// print('Thought: ${result.thought}');
/// print('Latency: ${result.latency}s');
/// ```
class OnDeviceService {
  static const _platform = MethodChannel('pawmind/ml');
  
  static OnDeviceService? _instance;
  static OnDeviceService get instance {
    _instance ??= OnDeviceService._();
    return _instance!;
  }
  
  OnDeviceService._() {
    _setupMethodHandler();
  }

  // Stream controller for model loading status
  final _statusController = StreamController<ModelStatus>.broadcast();
  Stream<ModelStatus> get modelStatusStream => _statusController.stream;
  
  ModelStatus? _currentStatus;
  ModelStatus? get currentStatus => _currentStatus;

  // MARK: - Setup

  void _setupMethodHandler() {
    // Listen for native events (e.g., model loaded)
    _platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onModelLoaded':
        final status = ModelStatus.fromJson(call.arguments as Map<String, dynamic>);
        _currentStatus = status;
        _statusController.add(status);
        debugPrint('🎉 Models loaded: vision=${status.visionLoaded}, llm=${status.llmLoaded}, tts=${status.ttsLoaded}');
        break;
      case 'onError':
        final error = call.arguments as String;
        debugPrint('❌ Native error: $error');
        break;
    }
  }

  // MARK: - Public API

  /// Run full inference pipeline (camera → vision → LLM → TTS)
  ///
  /// [imageBytes] - JPEG/PNG image data from camera
  /// [width] - Image width (default: 640)
  /// [height] - Image height (default: 480)
  ///
  /// Returns [InferenceResult] with thought, latency, and optional audio
  Future<InferenceResult> infer(
    Uint8List imageBytes, {
    int width = 640,
    int height = 480,
  }) async {
    try {
      final result = await _platform.invokeMethod('infer', {
        'image': FlutterStandardTypedData(bytes: imageBytes),
        'width': width,
        'height': height,
      });

      final inferenceResult = InferenceResult.fromJson(result as Map<String, dynamic>);
      
      debugPrint('⏱️ Inference latency: ${inferenceResult.latency.toStringAsFixed(2)}s');
      debugPrint('💭 Thought: ${inferenceResult.thought}');
      
      return inferenceResult;
    } on PlatformException catch (e) {
      debugPrint('❌ Inference failed: ${e.code} - ${e.message}');
      return InferenceResult(
        thought: 'Error: ${e.message}',
        vision: {},
        latency: 0.0,
        success: false,
      );
    }
  }

  /// Synthesize speech from text (TTS only)
  ///
  /// [text] - Text to synthesize
  ///
  /// Returns audio data (WAV/MP3) or null if failed
  Future<Uint8List?> synthesize(String text) async {
    try {
      final result = await _platform.invokeMethod('synthesize', {
        'text': text,
      });

      final audio = (result as Map<String, dynamic>)['audio'] as FlutterStandardTypedData?;
      return audio?.data;
    } on PlatformException catch (e) {
      debugPrint('❌ TTS failed: ${e.code} - ${e.message}');
      return null;
    }
  }

  /// Get current model loading status
  ///
  /// Returns [ModelStatus] with loaded state for each component
  Future<ModelStatus> getModelStatus() async {
    try {
      final result = await _platform.invokeMethod('getModelStatus');
      final status = ModelStatus.fromJson(result as Map<String, dynamic>);
      _currentStatus = status;
      return status;
    } on PlatformException catch (e) {
      debugPrint('❌ Get status failed: ${e.code} - ${e.message}');
      return ModelStatus(
        isLoaded: false,
        visionLoaded: false,
        llmLoaded: false,
        ttsLoaded: false,
        maxTokens: 30,
      );
    }
  }

  /// Check if on-device mode is available
  ///
  /// Returns true if all required models are loaded
  bool get isAvailable {
    return _currentStatus?.isLoaded ?? false;
  }

  /// Check if device is capable (iPhone 13+ or Pixel 7+)
  ///
  /// TODO: Implement device capability check
  static bool isDeviceCapable() {
    // For iOS: Check device model
    // For Android: Check RAM + chipset
    // Placeholder - always return true for POC
    return true;
  }

  // MARK: - Cleanup

  void dispose() {
    _statusController.close();
  }
}

// MARK: - Integration with Existing App

/*
 HOW TO INTEGRATE WITH EXISTING dog_sim_service.dart:

 1. Add Pro Mode toggle in app_config.dart:
    ```dart
    class AppConfig {
      static bool onDeviceEnabled = false;  // NEW
      static const bool kDefaultOnDeviceEnabled = false;  // NEW
    }
    ```

 2. Modify dog_sim_service.dart to support both modes:
    ```dart
    class DogSimService {
      final _serverService = ServerService();  // Existing
      final _onDeviceService = OnDeviceService.instance;  // NEW
      
      Future<InferenceResult> infer(CameraImage image) async {
        if (AppConfig.onDeviceEnabled) {
          return await _onDeviceService.infer(image.bytes);
        } else {
          return await _serverService.infer(image);  // Existing
        }
      }
    }
    ```

 3. Add Pro Mode toggle in settings screen:
    ```dart
    SwitchListTile(
      title: Text('On-Device Pro Mode'),
      subtitle: Text('Privacy-first, works offline (iPhone 13+)'),
      value: AppConfig.onDeviceEnabled,
      onChanged: (value) {
        setState(() => AppConfig.onDeviceEnabled = value);
      },
    )
    ```

 4. Show latency in debug overlay:
    ```dart
    Text('Latency: ${result.latency.toStringAsFixed(2)}s'),
    ```
 */
