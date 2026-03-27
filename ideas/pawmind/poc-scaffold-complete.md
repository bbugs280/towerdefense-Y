# ✅ POC Scaffold Complete

**Created:** 2026-03-24 17:30 HKT  
**Status:** Ready to Build  
**Next Step:** Run `pod install` + download models

---

## 📁 Files Created

| File | Lines | Purpose |
|------|-------|---------|
| `mobile_flutter/ios/Runner/NativeML/PawMindML.swift` | ~250 | Native iOS ML wrapper (MLX + MediaPipe + Piper) |
| `mobile_flutter/ios/Runner/NativeML/paw_mind_ml.podspec` | ~40 | CocoaPods integration |
| `mobile_flutter/lib/services/on_device_service.dart` | ~200 | Dart platform channel service |
| `mobile_flutter/lib/widgets/pro_mode_toggle.dart` | ~220 | UI toggle (Server vs. Pro Mode) |
| `mobile_flutter/lib/config/app_config.dart` | ~120 | Config (Pro Mode settings, feature flags) |
| `ideas/pawmind/poc-scaffold.md` | ~150 | POC documentation |
| `ideas/pawmind/poc-scaffold-complete.md` | ~150 | This summary |

**Total:** ~1,130 lines of code

---

## 🏗️ Architecture Added

```
mobile_flutter/
├── ios/
│   └── Runner/
│       ├── NativeML/              ← NEW
│       │   ├── PawMindML.swift    ← Native iOS ML handler
│       │   └── paw_mind_ml.podspec ← CocoaPods spec
│       └── Podfile                ← MODIFY (add paw_mind_ml)
│
├── lib/
│   ├── config/
│   │   └── app_config.dart        ← UPDATED (Pro Mode settings)
│   ├── services/
│   │   ├── dog_sim_service.dart   ← EXISTING (server-based)
│   │   └── on_device_service.dart ← NEW (on-device Pro Mode)
│   └── widgets/
│       └── pro_mode_toggle.dart   ← NEW (settings UI)
│
└── poc-results/                   ← CREATE (for test results)
    ├── latency.md
    ├── tts-quality.md
    ├── voice-variety.md
    ├── battery-thermal.md
    ├── app-size.md
    └── decision.md
```

---

## 🚀 How to Build POC

### Step 1: Update Podfile
Add to `mobile_flutter/ios/Podfile`:

```ruby
# Add at bottom, after existing pods
pod 'paw_mind_ml', :path => 'Runner/NativeML'

# Dependencies
pod 'MLX'
pod 'MediaPipeHolistic'
pod 'PiperTTS'
```

### Step 2: Install CocoaPods
```bash
cd mobile_flutter/ios
pod install
```

### Step 3: Download ML Models (One-Time)
```bash
# Create models directory
mkdir -p mobile_flutter/ios/Runner/Models

# Download Phi-3-mini (4-bit quantized, ~2.3 GB)
cd mobile_flutter/ios/Runner/Models
curl -L -o phi-3-mini-4bit.mlx \
  https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4_0.gguf

# Download Piper voice (~100 MB)
curl -L -o en_US-lessac-medium.piper \
  https://github.com/rhasspy/piper-models/releases/download/v1.0.0/en_US-lessac-medium.tar.gz
tar -xzf en_US-lessac-medium.piper
```

### Step 4: Update AppDelegate.swift
Add to `mobile_flutter/ios/Runner/AppDelegate.swift`:

```swift
import paw_mind_ml  // ADD THIS

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ADD THIS: Register PawMindML plugin
    PawMindMLPlugin.register(with: self.registrar(forPlugin: "PawMindML")!)
    
    // Existing registration...
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Step 5: Add Pro Mode Toggle to Settings
In your existing settings screen, add:

```dart
import 'package:paw_mind/widgets/pro_mode_toggle.dart';

// In settings screen build method:
ProModeToggle(),  // Add this widget
```

### Step 6: Build & Run
```bash
cd mobile_flutter
flutter run --device-id=<your-iphone-13-or-14>
```

---

## 🧪 POC Tests to Run

See `poc-plan.md` for detailed test scripts. Summary:

| Test | Measure | Success = |
|------|---------|-----------|
| **1. Latency** | Debug overlay (ms) | ≤2s (iPhone 14), ≤3s (iPhone 13) |
| **2. TTS Quality** | Blind test (n=10) | ≥4/5 rating |
| **3. Voice Variety** | 3+ characters, blind | ≥75% accuracy |
| **4. Battery/Thermal** | 5 min continuous | ≤15% battery |
| **5. App Size** | `flutter build ipa` | ≤500 MB initial |

---

## 📊 Expected Results (Based on Benchmarks)

| Component | iPhone 14 Pro | iPhone 13 | iPhone 12 |
|-----------|---------------|-----------|-----------|
| Vision (MediaPipe) | 0.04s ✅ | 0.05s ✅ | 0.08s ✅ |
| LLM (30 tokens) | 2.5s ⚠️ | 3.5s ⚠️ | 6s ❌ |
| TTS (Piper) | 0.8s ✅ | 1.0s ✅ | 1.5s ✅ |
| **Total** | **~3.5s** ⚠️ | **~4.5s** ⚠️ | **~8s** ❌ |

**Reality Check:** LLM is the bottleneck. Mitigation:
- Reduce tokens (30 → 20) → ~2–3s total
- Streaming TTS (speak after 10 tokens) → overlap
- Smaller LLM (Qwen-1.8B) → faster, less capable

---

## 🎯 Go/No-Go Decision

After running tests, save results to `poc-results/` and calculate:

| Criteria | Weight | Pass (✅) | Marginal (⚠️) | Fail (❌) |
|----------|--------|-----------|---------------|-----------|
| Latency (iPhone 14) | 25% | ≤2 sec | 2–4 sec | >4 sec |
| Latency (iPhone 13) | 15% | ≤3 sec | 3–5 sec | >5 sec |
| TTS Quality | 20% | ≥4.0/5 | 3.0–3.9/5 | <3.0/5 |
| Voice Variety | 15% | ≥75% accuracy | 50–74% | <50% |
| Battery/Thermal | 15% | ≤15% drain | 15–20% | >20% |
| App Size | 10% | ≤1.5 GB total | 1.5–2 GB | >2 GB |

**Weighted Score:**
- ≥0.8 → ✅ Build Pro Mode (2–3 weeks)
- 0.5–0.7 → ⚠️ Optimize, re-test (1–2 weeks)
- <0.5 → ❌ Server-based only

---

## 🚨 Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| `MLX not found` | Run `pod install` in `ios/` directory |
| `PawMindMLPlugin not registered` | Add registration in `AppDelegate.swift` |
| `Model not loading` | Check model path in `PawMindML.swift` |
| `Latency too high` | Reduce `kOnDeviceMaxTokens` (30 → 20) |
| `App too large` | Enable `kDownloadModelsOnDemand = true` |
| `Platform channel failed` | Ensure `paw_mind_ml.podspec` is in Podfile |

---

## 📞 Next Steps

1. ✅ **Review scaffolded files** — Confirm structure makes sense
2. 🔲 **Update Podfile** — Add `paw_mind_ml` pod
3. 🔲 **Run `pod install`** — Install MLX + MediaPipe + Piper
4. 🔲 **Download models** — Phi-3-mini + Piper voice
5. 🔲 **Update AppDelegate** — Register PawMindML plugin
6. 🔲 **Add ProModeToggle to settings** — Import + use widget
7. 🔲 **Build & run** — Test on iPhone 13/14
8. 🔲 **Run POC tests** — Follow `poc-plan.md`
9. 🔲 **Save results** — Document in `poc-results/`
10. 🔲 **Go/No-Go decision** — Review, decide next phase

---

## 📁 Related Docs

- `poc-plan.md` — Detailed test scripts
- `poc-scaffold.md` — Scaffold overview
- `decision-doc-v3.md` — Hybrid architecture validation
- `monitoring/ideas.md` — Idea tracker (8/10 score)

---

**Scaffold Status:** ✅ Complete  
**Ready to Build:** Yes  
**Estimated POC Time:** 1–2 weeks

🐾