# PawMind — POC Plan (Deprecated: Flutter On-Device)

**Status:** ❌ DEPRECATED (2026-03-27)  
**Replaced By:** `poc-plan-v2-ios-hybrid.md` (iOS Native + Hybrid Architecture)

**Original Goal:** Validate on-device inference feasibility (latency, TTS quality, voice variety, battery, app size) by extending existing Flutter app.

**Original Duration:** 1–2 weeks (parallel tracks)

**Why Deprecated:**
- Pivot from Flutter → iOS Native (faster development, better performance)
- Pivot from On-Device → Hybrid Architecture (lower latency, smaller app, better voice quality)
- DashScope API costs verified at HK$0.0051/thought (negligible, 97.7% margin)

**See:** `poc-plan-v2-ios-hybrid.md` for current POC plan.

---

## Historical Context

This plan was created when we assumed:
- On-device LLM (Phi-3) was necessary for privacy/cost
- Flutter was needed for cross-platform launch
- API costs would be high (HK$0.06-0.12/thought estimated)

**Updated Understanding (2026-03-27):**
- Hybrid architecture (vision on-device, reasoning+TTS via API) is superior
- iOS Native is faster to build than Flutter + platform channels
- API costs are 91.5% lower than estimated (HK$0.0051/thought verified)

**Preserved for:** Historical reference, lessons learned.


---

## 📋 POC Overview

| Test | What We're Validating | Success Criteria | Time |
|------|----------------------|------------------|------|
| **1. Latency** | End-to-end inference (camera → voice) | ≤2 sec (iPhone 14), ≤3 sec (iPhone 13) | 3–5 days |
| **2. TTS Quality** | "Cute dog voice" quality | ≥4/5 rating in blind test (n=10) | 2–3 days |
| **3. Voice Variety** | 3+ distinct character voices | Users can identify each without labels | 2–3 days |
| **4. Battery/Thermal** | Continuous use (5 min session) | ≤15% battery, no thermal throttling | 2–3 days |
| **5. App Size** | Bundle + downloadable models | ≤500 MB initial, ≤1.5 GB total | 1–2 days |

---

## 🧪 Test 1: Latency (End-to-End Inference)

### What We're Testing
Time from camera capture → vision analysis → LLM reasoning → TTS audio playback.

### Hardware Required
- iPhone 14 Pro (8GB RAM) — target device
- iPhone 13 (6GB RAM) — minimum viable device
- iPhone 12 (4GB RAM) — stress test (expected to fail)

### Models to Test
| Component | Model | Size (Quantized) | Source |
|-----------|-------|------------------|--------|
| Vision | MediaPipe Holistic | 15 MB | Google |
| Vision (expression) | MobileViT-xx-small | 8 MB | Apple ML |
| LLM | Phi-3-mini (3.8B, 4-bit) | 2.3 GB | Microsoft |
| LLM (alt) | Qwen-1.8B (4-bit) | 1.1 GB | Alibaba |
| TTS | Piper (fast) | 100 MB | Mozilla |
| TTS (alt) | Coqui XTTS v2 (8-bit) | 500 MB | Coqui |

### Test Script (Flutter + Platform Channels)

```dart
// mobile_flutter/lib/services/on_device_service.dart

class OnDeviceService {
  static const platform = MethodChannel('pawmind/ml');
  
  Future<InferenceResult> infer(Uint8List imageBytes) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    
    // Call native MLX module
    final result = await platform.invokeMethod('infer', {
      'image': imageBytes,
      'width': 640,
      'height': 480,
    });
    
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final latency = (endTime - startTime) / 1000.0;
    
    print('End-to-end latency: $latency seconds');
    return InferenceResult.fromJson(result);
  }
}
```

```swift
// mobile_flutter/ios/Runner/NativeML/PawMindML.swift

@objc(PawMindML)
class PawMindML: NSObject {
  private let visionModel = try! MediaPipeHolistic()
  private let llm = try! MLXModel("phi-3-mini-4bit")
  private let tts = try! PiperVoice("en_US-lessac-medium")
  
  @objc func infer(_: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String: Any]
    let imageBytes = args["image"] as! FlutterStandardTypedData
    let startTime = CFAbsoluteTimeGetCurrent()
    
    // Vision inference
    let pose = try! visionModel.infer(imageBytes.data)
    
    // LLM reasoning
    let thought = try! llm.generate("Dog pose: \(pose)...", maxTokens: 50)
    
    // TTS synthesis
    let audio = try! tts.synthesize(thought)
    
    let endTime = CFAbsoluteTimeGetCurrent()
    let latency = endTime - startTime
    
    result([
      "thought": thought,
      "latency": latency,
      "audio": audio,
    ])
  }
}
```

### Expected Results
| Device | Vision | LLM (50 tokens) | TTS | Total |
|--------|--------|-----------------|-----|-------|
| iPhone 14 Pro | 0.04s | 3–4s | 0.8s | **4–5s** ⚠️ |
| iPhone 13 | 0.05s | 4–5s | 1.0s | **5–6s** ⚠️ |
| iPhone 12 | 0.08s | 8–10s | 1.5s | **10–12s** ❌ |

**Reality Check:** LLM is the bottleneck — 50 tokens at 12 tok/s = 4+ seconds.

### Mitigation Strategies (If Latency Too High)
1. **Reduce token count:** Limit to 20–30 tokens (shorter thoughts)
2. **Smaller LLM:** Use Qwen-1.8B instead of Phi-3 (faster, less capable)
3. **Streaming TTS:** Start speaking after 10 tokens (overlap inference + playback)
4. **Hybrid:** Vision on-device, LLM server-side (compromise)

### Success Criteria
| Rating | Latency (iPhone 14) | Latency (iPhone 13) | Decision |
|--------|---------------------|---------------------|----------|
| ✅ Pass | ≤2 sec | ≤3 sec | Build Pro Mode |
| ⚠️ Marginal | 2–4 sec | 3–5 sec | Optimize (streaming, smaller LLM) |
| ❌ Fail | >4 sec | >5 sec | Server-based only |

### How to Run
1. Extend existing `mobile_flutter/` with platform channel (iOS/Runner/NativeML/)
2. Add MLX + MediaPipe + Piper pods to `ios/Podfile`
3. Run test 10 times per device (iPhone 14/13/12)
4. Record average, min, max latency
5. Save results to `poc-results/latency.md`

---

## 🎤 Test 2: TTS Quality (Cute Dog Voice)

### What We're Testing
Does the TTS voice sound like a "cute dog" — not robotic, not human, emotionally expressive?

### Voice Models to Test
| Model | Language | Style | Size |
|-------|----------|-------|------|
| **Piper (en_US-lessac-medium)** | English | Warm, friendly | 100 MB |
| **Piper (en_GB-alan-medium)** | British | Slightly posh | 100 MB |
| **Coqui XTTS v2** | Multi | Expressive, emotional | 500 MB |
| **Apple AVFoundation (Samantha)** | English | Native iOS | Built-in |
| **ElevenLabs API** (baseline) | English | Best-in-class (cloud) | N/A |

### Test Script (Blind Test, n=10)

1. Generate 5 audio clips (same text, different voices):
   - Text: *"BALL!! BALL!! THROW IT!!"* (excited)
   - Text: *"I'm a good boy... yes I am..."* (proud)
   - Text: *"Treat? Treat? Did you say treat?"* (hopeful)

2. Play for 10 testers (blind — no model names revealed)

3. Ask testers to rate each (1–5):
   - *"How cute/warm does this sound?"*
   - *"Does this sound like a dog personality?"*
   - *"Would you want to hear this from your dog?"*

4. Calculate average rating per voice

### Success Criteria
| Rating | Average Score | Decision |
|--------|---------------|----------|
| ✅ Pass | ≥4.0/5 | Use this voice |
| ⚠️ Marginal | 3.0–3.9/5 | Fine-tune with LoRA |
| ❌ Fail | <3.0/5 | Try different model |

### How to Run
1. Extend existing `mobile_flutter/lib/config/app_config.dart` with Piper/Coqui options
2. Generate audio clips (5 models × 3 texts = 15 clips)
3. Recruit 10 testers (friends, family, dog owners)
4. Run blind test (30 min session)
5. Save results to `poc-results/tts-quality.md`

---

## 🎭 Test 3: Voice Variety (3+ Characters)

### What We're Testing
Can we create 3+ distinct character voices that users can recognize without labels?

### Character Profiles
| Character | Personality | Voice Traits | Example Line |
|-----------|-------------|--------------|--------------|
| **Wise Old Dog** | Calm, experienced | Lower pitch, slower pace, deeper tone | *"Patience, young human. The ball will come."* |
| **Energetic Puppy** | Excited, playful | Higher pitch, faster pace, energetic | *"BALL!! NOW!! THROW!! YAY!!"* |
| **Sarcastic Terrier** | Dry, witty | Mid pitch, slight pause, sardonic | *"Oh great. Another meeting. How thrilling."* |
| **Sleepy Bulldog** | Lazy, content | Low pitch, slow, drawn-out vowels | *"Five... more... minutes..."* |

### Test Script (Blind Test, n=10)

1. Generate 4 audio clips (same voice model, different prompts):
   - Use Coqui XTTS + LoRA fine-tuning per character
   - OR use pitch/speed modulation on single model

2. Play for 10 testers (blind — no character names revealed)

3. Ask testers to match each clip to character:
   - *"Which character said this? (Wise / Puppy / Sarcastic / Sleepy)"*
   - *"How distinct do these sound? (1–5)"*

4. Calculate accuracy rate

### Success Criteria
| Rating | Accuracy | Decision |
|--------|----------|----------|
| ✅ Pass | ≥75% correct | 4 distinct voices viable |
| ⚠️ Marginal | 50–74% correct | Reduce to 2–3 voices |
| ❌ Fail | <50% correct | Voice variety not feasible |

### How to Run
1. Extend existing `mobile_flutter/lib/services/audio_service.dart` with character voice presets
2. Fine-tune Coqui XTTS with LoRA per character (or pitch modulation)
3. Generate 4 clips (one per character)
4. Run blind test (30 min session)
5. Save results to `poc-results/voice-variety.md`

---

## 🔋 Test 4: Battery & Thermal (5 Min Session)

### What We're Testing
Can the phone handle 5 minutes of continuous inference without overheating or draining battery?

### Test Script

1. Start with 100% battery, room temperature
2. Run continuous inference loop (camera → vision → LLM → TTS) for 5 minutes
3. Record:
   - Battery % after 5 min
   - Device temperature (use thermal sensor API)
   - Any throttling (frame rate drops, slower inference)

4. Repeat 3 times per device

### Expected Results
| Device | Battery Drain | Temperature | Throttling |
|--------|---------------|-------------|------------|
| iPhone 14 Pro | ~12–15% | Warm (not hot) | Minimal |
| iPhone 13 | ~15–18% | Warm | Moderate |
| iPhone 12 | ~20–25% | Hot | Significant |

### Success Criteria
| Rating | Battery (5 min) | Throttling | Decision |
|--------|-----------------|------------|----------|
| ✅ Pass | ≤15% | Minimal | Build Pro Mode |
| ⚠️ Marginal | 15–20% | Moderate | Add eco mode |
| ❌ Fail | >20% | Significant | Server-based only |

### How to Run
1. Extend existing `mobile_flutter/lib/screens/camera_screen.dart` with continuous inference loop
2. Run 3 sessions per device (5 min each)
3. Record battery, temperature, performance
4. Save results to `poc-results/battery-thermal.md`

---

## 📦 Test 5: App Size (Bundle + Downloads)

### What We're Testing
Can we keep app size reasonable (≤500 MB initial, ≤1.5 GB total)?

### Model Sizes (Quantized)
| Model | Size | Bundle or Download? |
|-------|------|---------------------|
| MediaPipe Holistic | 15 MB | ✅ Bundle |
| MobileViT-xx-small | 8 MB | ✅ Bundle |
| Phi-3-mini (4-bit) | 2.3 GB | ⬇️ Download (on-demand) |
| Qwen-1.8B (4-bit) | 1.1 GB | ⬇️ Download (on-demand) |
| Piper (en_US) | 100 MB | ✅ Bundle |
| Coqui XTTS v2 | 500 MB | ⬇️ Download (Pro only) |
| Character LoRA adapters | 50 MB each | ⬇️ Download (per character) |

### Recommended Strategy
| Tier | What's Included | Total Size |
|------|-----------------|------------|
| **Initial Download** | App + MediaPipe + MobileViT + Piper | ~150 MB |
| **Pro Mode (download)** | Phi-3 or Qwen-1.8B | +1.1–2.3 GB |
| **Character Pack (download)** | 4 LoRA adapters | +200 MB |

### Success Criteria
| Rating | Initial Size | Total Size | Decision |
|--------|--------------|------------|----------|
| ✅ Pass | ≤500 MB | ≤1.5 GB | Build Pro Mode |
| ⚠️ Marginal | 500 MB–1 GB | 1.5–2 GB | Download-on-demand required |
| ❌ Fail | >1 GB | >2 GB | Server-based only |

### How to Run
1. Extend existing `mobile_flutter/` with model bundling in `ios/Runner/`
2. Measure initial app size (`flutter build ipa` → measure .ipa)
3. Measure total size with all models downloaded
4. Save results to `poc-results/app-size.md`

---

## 📊 POC Results Tracker

| Test | Device | Result | Rating | Notes |
|------|--------|--------|--------|-------|
| Latency | iPhone 14 Pro | TBD | TBD | |
| Latency | iPhone 13 | TBD | TBD | |
| TTS Quality | n=10 testers | TBD | TBD | |
| Voice Variety | n=10 testers | TBD | TBD | |
| Battery/Thermal | iPhone 14 Pro | TBD | TBD | |
| Battery/Thermal | iPhone 13 | TBD | TBD | |
| App Size | Initial bundle | TBD | TBD | |
| App Size | Total (all models) | TBD | TBD | |

---

## 🗓️ POC Timeline

| Week | Day | Task | Owner |
|------|-----|------|-------|
| **Week 1** | Mon | Extend `mobile_flutter/` with platform channel + MLX podspec | Builder |
| | Tue | Test 1: Latency (iPhone 14/13/12) | Builder |
| | Wed | Test 1: Latency (continue) + analysis | Builder |
| | Thu | Test 2: TTS Quality (generate clips) | Builder |
| | Fri | Test 2: TTS Quality (blind test, n=10) | Builder + Wayne |
| **Week 2** | Mon | Test 3: Voice Variety (fine-tune LoRA) | Builder |
| | Tue | Test 3: Voice Variety (blind test) | Builder + Wayne |
| | Wed | Test 4: Battery/Thermal (3 sessions) | Builder |
| | Thu | Test 5: App Size (measure bundle) | Builder |
| | Fri | **Go/No-Go Decision** | You + Wayne + Builder |

---

## 🎯 Go/No-Go Decision Matrix

| Criteria | Weight | Pass (✅) | Marginal (⚠️) | Fail (❌) |
|----------|--------|-----------|---------------|-----------|
| Latency (iPhone 14) | 25% | ≤2 sec | 2–4 sec | >4 sec |
| Latency (iPhone 13) | 15% | ≤3 sec | 3–5 sec | >5 sec |
| TTS Quality | 20% | ≥4.0/5 | 3.0–3.9/5 | <3.0/5 |
| Voice Variety | 15% | ≥75% accuracy | 50–74% | <50% |
| Battery/Thermal | 15% | ≤15% drain | 15–20% | >20% |
| App Size | 10% | ≤1.5 GB total | 1.5–2 GB | >2 GB |

**Scoring:**
- ✅ Pass = 1.0 point
- ⚠️ Marginal = 0.5 points
- ❌ Fail = 0 points

**Weighted Score:**
- ≥0.8 → ✅ Build Pro Mode (2–3 weeks)
- 0.5–0.7 → ⚠️ Optimize, re-test (1–2 weeks)
- <0.5 → ❌ Server-based only

---

## 📁 Output Files

After POC completes, these files will exist:
- `poc-results/latency.md` — Test 1 results
- `poc-results/tts-quality.md` — Test 2 results
- `poc-results/voice-variety.md` — Test 3 results
- `poc-results/battery-thermal.md` — Test 4 results
- `poc-results/app-size.md` — Test 5 results
- `poc-results/decision.md` — Go/No-Go recommendation

---

## 🚀 Next Steps

1. **Review this plan** — Confirm it covers what you need
2. **Extend `mobile_flutter/`** — I can scaffold the platform channel + MLX integration
3. **Run tests** — Follow the scripts above, record results
4. **Decision meeting** — Review results, decide: Build Pro or Server-Only

---

### Your Move

| Option | What Happens |
|--------|--------------|
| **"Scaffold POC"** | I'll add platform channel + MLX podspec to existing `mobile_flutter/` |
| **"Start with latency"** | I'll write the exact Swift/Dart code for Test 1 |
| **"Review timeline"** | We adjust the 2-week plan based on your availability |
| **"Questions first"** | I'll clarify any unclear parts of the POC plan |

**Note:** All POC work extends your existing Flutter app — nothing thrown away.

Ready when you are. 🐾