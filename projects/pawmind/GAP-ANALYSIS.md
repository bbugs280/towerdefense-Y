# PawMind — Gap Analysis: Current Repo vs. iOS Native + Hybrid POC

**Date:** 2026-03-27  
**Repo:** https://github.com/bbugs280/paw-mind  
**Branch:** main  
**Last Updated:** 2026-03-24

---

## 📊 Current State (GitHub Repo)

### Architecture: Server-Based (WebSocket)

```
┌──────────────┐         WebSocket          ┌─────────────────┐
│  Flutter App │◄──────────────────────────►│  FastAPI Server  │
│  (iOS/Android)│   JPEG frames / tokens     │  (uvicorn)       │
│               │                            │                  │
│ camera       │   ◄─ token (streamed)      │  Qwen-VL-Max     │
│ web_socket   │  ◄─ speak_local {text}     │  (DashScope API) │
│ just_audio   │  ◄─ speak_cosyvoice {url}  │  CosyVoice TTS   │
└──────────────┘   ◄─ done {state}          └─────────────────┘
```

### Codebase Summary

| Component | Status | Location | Language |
|-----------|--------|----------|----------|
| **Mobile (Primary)** | ✅ Active | `mobile_flutter/` | Dart (Flutter) |
| **Mobile (Legacy)** | ⚠️ Deprecated | `mobile/` | TypeScript (Expo) |
| **Server** | ✅ Active | `server/` | Python (FastAPI) |
| **iOS Native** | ❌ Not started | — | — |
| **On-Device ML** | ❌ Not started | — | — |

### Key Files in Repo

```
paw-mind/
├── server/
│   ├── main.py              # FastAPI WebSocket server
│   ├── requirements.txt     # Python deps
│   └── test_api.py          # API tests
├── mobile_flutter/
│   ├── lib/                 # ❌ NOT in repo (only tests exist)
│   ├── test/                # ✅ Unit tests (config, dog_profile, etc.)
│   ├── ios/                 # ✅ iOS scaffold (Runner, Podfile)
│   └── android/             # ✅ Android scaffold
├── mobile/                  # Legacy Expo app (TypeScript)
│   ├── app/index.tsx        # Main screen
│   ├── hooks/useDogSim.ts   # Dog sim logic
│   └── components/          # UI components
└── README.md                # Server-based architecture docs
```

**Critical Finding:** `mobile_flutter/lib/` directory is **NOT in the repo** — only test files exist. The Flutter app code is local-only.

---

## 🎯 Target State: iOS Native + Hybrid POC

### Architecture: Hybrid (Vision On-Device, API Direct)

```
┌─────────────────────────────────┐
│      iOS Native App (Swift)     │
│                                 │
│  ┌─────────────────────────┐   │
│  │  CameraView (SwiftUI)   │   │
│  │  - AVCaptureSession     │   │
│  │  - MediaPipe Holistic   │   │
│  └──────────┬──────────────┘   │
│             │                   │
│  ┌──────────▼──────────────┐   │
│  │  DashScopeService       │   │
│  │  - qwen-vl-plus (API)   │   │
│  │  - cosyvoice-v3.5 (API) │   │
│  └──────────┬──────────────┘   │
│             │                   │
│  ┌──────────▼──────────────┐   │
│  │  AVFoundation           │   │
│  │  - Audio playback       │   │
│  │  - Native TTS fallback  │   │
│  └─────────────────────────┘   │
└─────────────────────────────────┘
           │
           │ HTTPS (Direct to DashScope)
           ▼
┌─────────────────────────────────┐
│   DashScope API (China)         │
│   - qwen-vl-plus               │
│   - cosyvoice-v3.5-flash/plus  │
└─────────────────────────────────┘
```

### Key Differences

| Aspect | Current (Server-Based) | Target (Hybrid) |
|--------|------------------------|-----------------|
| **Platform** | Flutter (cross-platform) | iOS Native (Swift, SwiftUI) |
| **Vision** | Server-side (Qwen-VL-Max via server) | On-device (MediaPipe) + API (Qwen-VL-Plus) |
| **TTS** | Server-side CosyVoice | Direct API (CosyVoice) + Native fallback |
| **Latency** | ~2-3s (WiFi, via server) | ~1.5-2.5s (direct API) |
| **Server Required** | ✅ Yes (FastAPI) | ❌ No (direct API from app) |
| **App Size** | ~50 MB (Flutter) | <50 MB (Native) |
| **Offline Mode** | ❌ No (server required) | ✅ Yes (native TTS fallback) |
| **Development** | Python + Dart | Swift only |

---

## 🔍 Gap Analysis

### 1. iOS Native App — ❌ NOT STARTED

| Required File | Status | Action |
|---------------|--------|--------|
| `PawMind.xcodeproj` | ❌ Missing | Create new Xcode project (iOS 17.4+) |
| `PawMind/Sources/App/App.swift` | ❌ Missing | SwiftUI app entry |
| `PawMind/Sources/App/Views/CameraView.swift` | ❌ Missing | Camera + vision pipeline |
| `PawMind/Sources/App/Services/DashScopeService.swift` | ❌ Missing | API integration |
| `PawMind/Sources/App/Services/CostTracker.swift` | ❌ Missing | Cost tracking |
| `PawMind/Sources/App/Models/DogThought.swift` | ❌ Missing | Data models |

**Priority:** 🔴 **CRITICAL** — This is the core POC deliverable.

---

### 2. Flutter App — ⚠️ LOCAL ONLY (Not in Repo)

| Issue | Impact | Action |
|-------|--------|--------|
| `mobile_flutter/lib/` not in repo | Code is local-only, not backed up | Decide: commit Flutter code OR abandon for iOS Native |
| Flutter being pivoted away from | Investment may be wasted | Archive Flutter work, focus on iOS Native |

**Recommendation:** 
- **Option A:** Commit existing Flutter code to repo for historical reference (tag as `flutter-archive`)
- **Option B:** Abandon Flutter entirely, focus on iOS Native (recommended)

---

### 3. Server — ✅ EXISTS (But Not Needed for Hybrid)

| File | Status | Future |
|------|--------|--------|
| `server/main.py` | ✅ Active | Archive (not needed for hybrid POC) |
| `server/requirements.txt` | ✅ Active | Archive |
| `server/test_api.py` | ✅ Active | Keep tests, adapt for iOS POC |

**Recommendation:** 
- Keep server code in repo (tag as `server-archive`)
- Server may be useful for future features (multi-dog, social sharing)
- Not needed for POC — iOS app calls DashScope API directly

---

### 4. Documentation — ⚠️ OUTDATED

| Doc | Status | Action |
|-----|--------|--------|
| `README.md` | ⚠️ Describes server-based arch | Update with hybrid architecture |
| `DEV_PROD_SETUP.md` | ⚠️ Flutter + Server setup | Update with iOS Native setup |
| `DEPLOYMENT.md` | ⚠️ Server deployment | Archive (not needed for POC) |
| `VOICE_CONFIG_GUIDE.md` | ⚠️ Server TTS config | Update with CosyVoice API config |

**Priority:** 🟡 **MEDIUM** — Update after POC scaffold is complete.

---

## 📋 Action Plan

### Phase 1: iOS Native POC Scaffold (Week 1)

| Task | Owner | Deliverable | ETA |
|------|-------|-------------|-----|
| **1.1** Create Xcode project | Builder | `PawMind.xcodeproj` | Day 1 |
| **1.2** Implement `DashScopeService.swift` | Builder | API integration | Day 1-2 |
| **1.3** Implement `CameraView.swift` | Builder | Camera + vision | Day 2-3 |
| **1.4** Add cost tracking | Builder | `CostTracker.swift` | Day 3 |
| **1.5** Run POC tests | You + Builder | `poc-results/*.md` | Day 4-5 |
| **1.6** Go/No-Go decision | You + Wayne | `poc-results/decision.md` | Day 5 |

### Phase 2: Repo Reorganization (Week 2)

| Task | Owner | Deliverable | ETA |
|------|-------|-------------|-----|
| **2.1** Commit iOS POC code | You | `ios-poc/` directory | Day 1 |
| **2.2** Archive Flutter code | You | Tag `flutter-archive` | Day 2 |
| **2.3** Archive server code | You | Tag `server-archive` | Day 2 |
| **2.4** Update README.md | Builder | Hybrid architecture docs | Day 3 |
| **2.5** Update setup docs | Builder | iOS Native setup guide | Day 3-4 |

---

## 🚀 Immediate Next Steps

### For You (VSCode + Copilot)

1. **Create iOS POC directory** in repo:
   ```bash
   cd paw-mind
   mkdir -p ios-poc/PawMind/Sources/App/{Views,Services,Models}
   ```

2. **Run scaffold commands** (I'll provide exact Copilot prompts below)

3. **Test on device** (iPhone 13/14)

4. **Commit results** to `ios-poc/` branch

### For Me (Builder Persona)

I'll create:
1. **Scaffold files** — Ready for you to copy into `ios-poc/`
2. **Copilot prompts** — Exact prompts to execute in VSCode
3. **Test scripts** — Step-by-step POC test instructions

---

## 📝 VSCode Copilot Execution Prompts

### Prompt 1: Create Xcode Project Structure
```
Create a new iOS app project structure for PawMind:
- Platform: iOS 17.4+
- Language: Swift 5.9
- UI: SwiftUI
- Directory: ios-poc/PawMind/

Create these files:
1. PawMind.xcodeproj/project.pbxproj (minimal Xcode project)
2. PawMind/Sources/App/App.swift (SwiftUI @main entry)
3. PawMind/Package.swift (Swift Package Manager)

App.swift should:
- Import SwiftUI
- Create @main struct PawMindApp
- Launch CameraView as initial screen
- Set up accent color and assets
```

### Prompt 2: Create DashScope Service
```
Create DashScopeService.swift for PawMind iOS app:

Requirements:
- Use URLSession for API calls
- Two methods: 
  1. analyze(image: UIImage) async throws -> DogThought
  2. synthesize(text: String, model: String) async throws -> Data

API Endpoints:
- Vision: POST https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation
  Model: qwen-vl-plus
  Input: image (base64) + prompt
  Output: JSON { emotion, intent, confidence, thought }

- TTS: POST https://dashscope.aliyuncs.com/api/v1/services/aigc/tts/speech
  Model: cosyvoice-v3.5-flash (or cosyvoice-v3.5-plus)
  Input: text (50 chars avg)
  Output: audio data (mp3)

Include:
- API key from environment variable
- Error handling (timeout, network errors)
- Timing instrumentation (os_signpost for latency tracking)
- Cost tracking (input tokens, output tokens, TTS characters)

Save to: ios-poc/PawMind/Sources/App/Services/DashScopeService.swift
```

### Prompt 3: Create Camera View
```
Create CameraView.swift for PawMind iOS app:

Requirements:
- Use SwiftUI + AVFoundation (AVCaptureSession)
- Request camera permission on appear
- Capture frame every 5 seconds
- Display camera preview with overlay (emotion badge, thought text)
- Play audio when TTS completes
- Show latency overlay (debug mode)

Include:
- @Observable class CameraViewModel
- AVCaptureSession setup (photo output, 480x360 resolution)
- Frame capture → convert to UIImage → send to DashScopeService
- Audio playback using AVAudioPlayer
- Error handling (permission denied, camera unavailable)

Save to: ios-poc/PawMind/Sources/App/Views/CameraView.swift
```

### Prompt 4: Create Data Models
```
Create DogThought.swift model for PawMind:

Requirements:
- Struct DogThought with properties:
  - emotion: String (e.g., "happy", "excited", "hungry")
  - intent: String (e.g., "wants to play", "wants food")
  - confidence: Double (0.0-1.0)
  - thought: String (first-person monologue)
  - inputTokens: Int (for cost tracking)
  - outputTokens: Int (for cost tracking)
  - ttsCharacters: Int (for cost tracking)

- Add computed property: costHKD (calculate based on DashScope pricing)
- Add Codable conformance
- Add debug description

Save to: ios-poc/PawMind/Sources/App/Models/DogThought.swift
```

---

## ✅ Success Criteria

POC is complete when:
- [ ] iOS app builds and runs on iPhone 13/14
- [ ] Camera captures frames successfully
- [ ] DashScope API calls work (vision + TTS)
- [ ] Latency ≤2.5s (WiFi), ≤3s (5G)
- [ ] TTS quality ≥4/5 (blind test, n=10)
- [ ] Offline fallback works (native TTS)
- [ ] Cost tracking matches HK$0.0051/thought estimate

---

## 📞 Support

If you hit issues:
1. Check `poc-plan-v2-ios-hybrid.md` for test scripts
2. Share error messages — I'll debug with you
3. Compare against business case for cost/latency targets

---

**Ready to scaffold?** Say **"Scaffold POC"** and I'll create all the files for you to copy into the repo. 🐾
