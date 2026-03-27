# PawMind — POC Scaffold (Deprecated: Flutter On-Device)

**Status:** ❌ DEPRECATED (2026-03-27)  
**Replaced By:** `poc-scaffold-v2-ios-hybrid.md` (iOS Native + Hybrid)

**Original Created:** 2026-03-24  
**Original Platform:** Flutter + Platform Channels (iOS first)  
**Original Goal:** Extend existing `mobile_flutter/` with on-device Pro Mode

**Why Deprecated:**
- Pivot from Flutter → iOS Native (faster, simpler)
- Pivot from On-Device → Hybrid Architecture (better latency, voice quality, app size)
- DashScope API costs verified at HK$0.0051/thought (negligible)

**See:** `poc-scaffold-v2-ios-hybrid.md` for current iOS Native + Hybrid scaffold.

---

## Historical Context

This scaffold was created for the Flutter + On-Device approach. Files created:
- `mobile_flutter/ios/Runner/NativeML/PawMindML.swift` — MLX wrapper (no longer needed)
- `mobile_flutter/lib/services/on_device_service.dart` — Platform channel (no longer needed)
- `mobile_flutter/ios/Podfile` — MLX + MediaPipe pods (no longer needed)

**These files are preserved** for reference but are not part of the current iOS Native + Hybrid POC.

**New scaffold creates:**
- `PawMind.xcodeproj` — iOS Native project (SwiftUI)
- `DashScopeService.swift` — API integration (Qwen-VL-Plus + CosyVoice)
- `CameraView.swift` — Camera + vision pipeline
- `CostTracker.swift` — API cost tracking

---


---

## 📁 Files Created

| File | Purpose | Lines |
|------|---------|-------|
| `mobile_flutter/ios/Runner/NativeML/PawMindML.swift` | Native iOS ML wrapper (MLX + MediaPipe + Piper) | ~150 |
| `mobile_flutter/ios/Runner/NativeML/paw_mind_ml.podspec` | CocoaPods integration | ~30 |
| `mobile_flutter/lib/services/on_device_service.dart` | Dart platform channel service | ~80 |
| `mobile_flutter/lib/config/app_config.dart` | Updated with Pro Mode settings | ~50 (modified) |
| `mobile_flutter/lib/widgets/pro_mode_toggle.dart` | UI toggle (Server vs. Pro) | ~60 |
| `mobile_flutter/ios/Podfile` | Modified: Add MLX + MediaPipe pods | ~10 (modified) |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Flutter App (Dart)              │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  OnDeviceService                │   │
│  │  - infer(image) → Thought       │   │
│  │  - synthesize(text) → Audio     │   │
│  └──────────────┬──────────────────┘   │
│                 │ Platform Channel     │
└─────────────────┼─────────────────────┘
                  │
┌─────────────────▼─────────────────────┐
│    iOS Native (Swift + MLX)           │
│                                       │
│  ┌─────────────────────────────────┐ │
│  │  PawMindML                      │ │
│  │  - MediaPipe Holistic (vision)  │ │
│  │  - Phi-3-mini (LLM)             │ │
│  │  - Piper (TTS)                  │ │
│  └─────────────────────────────────┘ │
└───────────────────────────────────────┘
```

---

## 🔧 How to Run POC

### Step 1: Install CocoaPods Dependencies
```bash
cd mobile_flutter/ios
pod install
```

### Step 2: Download ML Models (One-Time)
```bash
# Create models directory
mkdir -p mobile_flutter/ios/Runner/Models

# Download Phi-3-mini (4-bit quantized)
# Link: https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf
# Size: ~2.3 GB

# Download Piper voice model
# Link: https://github.com/rhasspy/piper-models
# Size: ~100 MB
```

### Step 3: Build & Run
```bash
cd mobile_flutter
flutter run --device-id=<your-iphone-13-or-14>
```

### Step 4: Enable Pro Mode
1. Open app on device
2. Go to Settings
3. Toggle **"On-Device Pro Mode"**
4. Point camera at dog
5. Measure latency (shown in debug overlay)

---

## 🧪 POC Tests to Run

| Test | How to Measure | Success Criteria |
|------|----------------|------------------|
| **Latency** | Debug overlay shows ms | ≤2s (iPhone 14), ≤3s (iPhone 13) |
| **TTS Quality** | Blind test (n=10) | ≥4/5 rating |
| **Voice Variety** | 3+ characters, blind test | ≥75% accuracy |
| **Battery/Thermal** | 5 min continuous session | ≤15% battery drain |
| **App Size** | `flutter build ipa` → measure | ≤500 MB initial |

---

## 📊 Results Tracker

After running tests, save results to:
- `poc-results/latency.md`
- `poc-results/tts-quality.md`
- `poc-results/voice-variety.md`
- `poc-results/battery-thermal.md`
- `poc-results/app-size.md`
- `poc-results/decision.md` (Go/No-Go)

---

## 🚨 Troubleshooting

| Issue | Fix |
|-------|-----|
| `MLX not found` | Run `pod install` in `ios/` directory |
| `Platform channel not registered` | Ensure `PawMindMLPlugin.register()` is called in `AppDelegate.swift` |
| `Model not loading` | Check model path in `PawMindML.swift` (should be `Bundle.main.path(forResource:)`) |
| `Latency too high` | Reduce LLM token count (default: 50 → try 20–30) |
| `App too large` | Move models to download-on-demand (not bundled) |

---

## 🎯 Next Steps After Scaffold

1. ✅ Review scaffolded files — confirm structure makes sense
2. ✅ Run `pod install` — install MLX + MediaPipe + Piper
3. ✅ Download models — Phi-3-mini + Piper voice
4. ✅ Build & run — test on iPhone 13/14
5. ✅ Run POC tests — follow test scripts in `poc-plan.md`
6. ✅ Save results — document findings in `poc-results/`
7. ✅ Go/No-Go decision — review results, decide next phase

---

## 📞 Support

If you hit issues:
1. Check `poc-plan.md` for detailed test scripts
2. Review error messages — share with Builder for debugging
3. Compare against server-based flow (working) to isolate issues

---

**Scaffold Status:** ✅ Complete  
**Ready to Build:** Yes  
**Estimated POC Time:** 1–2 weeks

🐾