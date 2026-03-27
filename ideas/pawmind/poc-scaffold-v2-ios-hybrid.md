# PawMind — POC Scaffold (iOS Native + Hybrid)

**Created:** 2026-03-27 (Updated for iOS Native + Hybrid)  
**Platform:** iOS Native (Swift, iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, Reasoning + TTS via DashScope API)  
**Goal:** Rapid POC to validate hybrid approach before MVP build  

---

## 📁 Files to Create

| File | Purpose | Lines | Status |
|------|---------|-------|--------|
| `PawMind.xcodeproj` | Xcode project (iOS 17.4+) | — | ⏳ Pending |
| `PawMind/Sources/App/App.swift` | SwiftUI app entry | ~30 | ⏳ Pending |
| `PawMind/Sources/App/Views/CameraView.swift` | Camera preview + capture | ~100 | ⏳ Pending |
| `PawMind/Sources/App/Services/DashScopeService.swift` | API integration (VL + TTS) | ~150 | ⏳ Pending |
| `PawMind/Sources/App/Services/CostTracker.swift` | API cost tracking | ~80 | ⏳ Pending |
| `PawMind/Sources/App/Models/DogThought.swift` | Data models | ~50 | ⏳ Pending |
| `PawMind/Package.swift` | Swift Package Manager | ~20 | ⏳ Pending |
| `poc-results/` | Test results directory | — | ⏳ Pending |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         iOS App (SwiftUI)               │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  CameraView                     │   │
│  │  - AVCaptureSession             │   │
│  │  - Vision (MediaPipe)           │   │
│  │  - Display Thought + Play Audio │   │
│  └──────────────┬──────────────────┘   │
│                 │                       │
└─────────────────┼───────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
┌────────▼────────┐ ┌─────▼──────────────┐
│ On-Device       │ │ DashScope API      │
│ (MediaPipe)     │ │ (China Endpoint)   │
│                 │ │                    │
│ - Pose detect   │ │ - qwen-vl-plus     │
│ - Expression    │ │ - cosyvoice-v3.5   │
│ - 50-100ms      │ │ - ~1-2 sec total   │
└─────────────────┘ └────────────────────┘
```

---

## 🔧 How to Run POC

### Step 1: Create Xcode Project
```bash
# I'll scaffold this for you — run:
mkdir -p PawMind/Sources/App/{Views,Services,Models}
cd PawMind
# Open in Xcode 15.4+
open PawMind.xcodeproj
```

### Step 2: Add DashScope API Key
```bash
# Create .env file (not committed to git)
cat > PawMind/.env << EOF
DASHSCOPE_API_KEY=your_api_key_here
EOF

# Add to Xcode project as build setting
```

### Step 3: Build & Run
```bash
# In Xcode:
# 1. Select target device (iPhone 14/13)
# 2. Product → Build (Cmd+B)
# 3. Product → Run (Cmd+R)
```

### Step 4: Run POC Tests
1. **Latency:** Open app, point camera → measure time to audio playback
2. **TTS Quality:** Generate 6 clips (3 models × 2 texts), blind test with 10 users
3. **Voice Variety:** Generate 3 character voices, blind test
4. **API Cost:** Run 100 thoughts, verify HK$0.0051/thought
5. **Offline:** Enable airplane mode, verify native TTS fallback

---

## 🧪 POC Tests Overview

| Test | How to Measure | Success Criteria |
|------|----------------|------------------|
| **Latency** | os_signpost instrumentation | ≤2s (WiFi), ≤2.5s (5G) |
| **TTS Quality** | Blind test (n=10 dog owners) | ≥4/5 rating |
| **Voice Variety** | 3 characters, blind test | ≥75% accuracy |
| **API Cost** | CostTracker.swift (100 thoughts) | Match HK$0.0051 estimate |
| **Offline** | Airplane mode test | Graceful fallback, <5s |

---

## 📊 Results Tracker

After running tests, save results to:
- `poc-results/latency.md`
- `poc-results/tts-quality.md`
- `poc-results/voice-variety.md`
- `poc-results/api-cost.md`
- `poc-results/offline-fallback.md`
- `poc-results/decision.md` (Go/No-Go)

---

## 🚨 Troubleshooting

| Issue | Fix |
|-------|-----|
| `DashScope API timeout` | Check network, verify API key, increase timeout (default: 5s) |
| `Camera permission denied` | Add `NSCameraUsageDescription` to Info.plist |
| `Audio not playing` | Check AVAudioSession category, ensure not muted |
| `Latency too high` | Check network (HK → China), reduce image resolution, enable caching |
| `TTS sounds robotic` | Try CosyVoice-Plus instead of Flash, adjust prompt |

---

## 🎯 Next Steps After Scaffold

1. ✅ Review scaffolded files — confirm structure makes sense
2. ✅ Add DashScope API key — get from DashScope console
3. ✅ Build & run — test on iPhone 13/14
4. ✅ Run POC tests — follow test scripts in `poc-plan-v2-ios-hybrid.md`
5. ✅ Save results — document findings in `poc-results/`
6. ✅ Go/No-Go decision — review results, decide MVP build

---

## 📞 Support

If you hit issues:
1. Check `poc-plan-v2-ios-hybrid.md` for detailed test scripts
2. Review error messages — share with Builder for debugging
3. Compare against business case (`projects/pawmind/planning/business-case-revised.md`) for cost/latency targets

---

**Scaffold Status:** ⏳ Ready to Create  
**Platform:** iOS Native (Swift, iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, API for Reasoning + TTS)  
**Estimated POC Time:** 1 week  

---

## 🚀 Ready to Scaffold?

| Option | What I'll Create |
|--------|------------------|
| **"Scaffold POC"** | Full Xcode project + all Swift files + test harness |
| **"Start with DashScope"** | Just `DashScopeService.swift` + API integration |
| **"Start with Camera"** | Just `CameraView.swift` + vision pipeline |
| **"Questions first"** | Clarify any unclear parts before scaffolding |

**Your call.** I'm ready when you are. 🐾
