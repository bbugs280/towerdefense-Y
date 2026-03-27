//
//  PawMindML.swift
//  Runner
//
//  PawMind On-Device ML Module
//  Extends existing Flutter app with Pro Mode (on-device inference)
//

import Foundation
import Flutter
import UIKit
import MLX
import MediaPipe
import AVFoundation

// MARK: - Plugin Registration

public class PawMindMLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = PawMindML()
        let channel = FlutterMethodChannel(
            name: "pawmind/ml",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
}

// MARK: - Native ML Handler

@objc(PawMindML)
class PawMindML: NSObject {
    // Singleton for model loading (load once, reuse)
    private static var shared: PawMindML?
    private var visionModel: MediaPipeHolistic?
    private var llm: MLXModel?
    private var tts: PiperVoice?
    private var isLoaded = false
    
    // Configuration
    private let maxTokens = 30  // Reduced for latency (vs 50 in original plan)
    private let modelBundlePath = "Models"
    
    override init() {
        super.init()
        loadModels()
    }
    
    // MARK: - Model Loading
    
    private func loadModels() {
        guard !isLoaded else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // 1. Load Vision Model (MediaPipe Holistic)
                self.visionModel = try MediaPipeHolistic()
                print("✅ Vision model loaded")
                
                // 2. Load LLM (Phi-3-mini, 4-bit quantized)
                let llmPath = Bundle.main.path(
                    forResource: "phi-3-mini-4bit",
                    ofType: "mlx"
                )
                if let path = llmPath {
                    self.llm = try MLXModel(modelPath: path)
                    print("✅ LLM loaded from \(path)")
                } else {
                    print("⚠️ LLM model not found in bundle")
                }
                
                // 3. Load TTS (Piper voice)
                let ttsPath = Bundle.main.path(
                    forResource: "en_US-lessac-medium",
                    ofType: "piper"
                )
                if let path = ttsPath {
                    self.tts = try PiperVoice(modelPath: path)
                    print("✅ TTS loaded from \(path)")
                } else {
                    print("⚠️ TTS model not found in bundle")
                }
                
                self.isLoaded = true
                print("🎉 All models loaded successfully")
                
            } catch {
                print("❌ Model loading failed: \(error)")
            }
        }
    }
    
    // MARK: - Flutter Method Channel Handler
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "infer":
            handleInfer(call, result: result)
        case "synthesize":
            handleSynthesize(call, result: result)
        case "getModelStatus":
            handleGetModelStatus(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Inference (Camera → Thought → Audio)
    
    private func handleInfer(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let imageData = (args["image"] as? FlutterStandardTypedData)?.data,
              let width = args["width"] as? Int,
              let height = args["height"] as? Int else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Missing image, width, or height",
                details: nil
            ))
            return
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                result(FlutterError(
                    code: "UNAVAILABLE",
                    message: "ML handler not available",
                    details: nil
                ))
                return
            }
            
            do {
                // Step 1: Vision Inference (Pose + Expression)
                var visionResult: [String: Any] = [:]
                if let visionModel = self.visionModel {
                    let pose = try visionModel.infer(imageData)
                    visionResult = [
                        "pose": pose.toDictionary(),
                        "expression": pose.expressionLabel
                    ]
                }
                
                // Step 2: LLM Reasoning (Generate "Thought")
                var thoughtText = "Woof!"
                if let llm = self.llm {
                    let prompt = self.buildPrompt(from: visionResult)
                    thoughtText = try llm.generate(
                        prompt,
                        maxTokens: self.maxTokens
                    )
                }
                
                // Step 3: TTS Synthesis (Generate Audio)
                var audioData: Data?
                if let tts = self.tts {
                    audioData = try tts.synthesize(thoughtText)
                }
                
                let endTime = CFAbsoluteTimeGetCurrent()
                let latency = endTime - startTime
                
                print("⏱️ Latency: \(String(format: "%.2f", latency))s")
                
                // Return result to Flutter
                result([
                    "thought": thoughtText,
                    "vision": visionResult,
                    "latency": latency,
                    "audio": audioData != nil ? FlutterStandardTypedData(bytes: audioData!) : nil,
                    "success": true
                ])
                
            } catch {
                print("❌ Inference failed: \(error)")
                result(FlutterError(
                    code: "INFERENCE_FAILED",
                    message: error.localizedDescription,
                    details: nil
                ))
            }
        }
    }
    
    // MARK: - TTS Only (Separate Call)
    
    private func handleSynthesize(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let text = args["text"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Missing text",
                details: nil
            ))
            return
        }
        
        guard let tts = self.tts else {
            result(FlutterError(
                code: "UNAVAILABLE",
                message: "TTS model not loaded",
                details: nil
            ))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let audioData = try tts.synthesize(text)
                result([
                    "audio": FlutterStandardTypedData(bytes: audioData),
                    "success": true
                ])
            } catch {
                result(FlutterError(
                    code: "TTS_FAILED",
                    message: error.localizedDescription,
                    details: nil
                ))
            }
        }
    }
    
    // MARK: - Model Status
    
    private func handleGetModelStatus(result: @escaping FlutterResult) {
        result([
            "isLoaded": isLoaded,
            "visionLoaded": visionModel != nil,
            "llmLoaded": llm != nil,
            "ttsLoaded": tts != nil,
            "maxTokens": maxTokens
        ])
    }
    
    // MARK: - Helper Methods
    
    private func buildPrompt(from visionResult: [String: Any]) -> String {
        let expression = visionResult["expression"] as? String ?? "neutral"
        let pose = visionResult["pose"] as? [String: Any] ?? [:]
        
        // Personality prompt (can be customized per user preference)
        let personality = "playful"  // TODO: Load from user settings
        
        return """
        You are a \(personality) dog. Based on this body language:
        - Expression: \(expression)
        - Pose: \(pose.description)
        
        Speak your thoughts in 1-2 short sentences. Be expressive and cute.
        """
    }
}

// MARK: - MediaPipe Result Extensions

extension MediaPipeHolistic.Pose {
    func toDictionary() -> [String: Any] {
        return [
            "earAngle": earAngle,
            "tailWagSpeed": tailWagSpeed,
            "bodyPosture": bodyPostureLabel,
            "confidence": confidence
        ]
    }
}

// MARK: - Models Not Bundled (Download On-Demand)

/*
 NOTE: For POC, models are downloaded manually and placed in:
   mobile_flutter/ios/Runner/Models/
 
 Files needed:
   - phi-3-mini-4bit.mlx (~2.3 GB)
   - en_US-lessac-medium.piper (~100 MB)
 
 For production, implement download-on-demand:
   1. Check if models exist on first launch
   2. If not, show download UI (with progress)
   3. Store in app's documents directory
   4. Load from documents path (not bundle)
 
 This keeps initial app size <500 MB.
 */
