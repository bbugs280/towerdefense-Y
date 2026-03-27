# 🐾 PawMind iOS POC

**Platform:** iOS Native (Swift, iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, Reasoning + TTS via DashScope API)  
**Timeline:** 1 week POC → 4 weeks MVP

---

## 📁 Project Structure

```
ios-poc/
├── PawMind/
│   ├── Sources/App/
│   │   ├── App.swift              # SwiftUI entry point
│   │   ├── Config/
│   │   │   └── AppConfig.swift    # .env configuration loader
│   │   ├── Models/
│   │   │   ├── DogThought.swift   # Thought data model
│   │   │   ├── DogProfile.swift   # Dog profile (from Flutter)
│   │   │   └── CosyVoiceConfig.swift  # TTS voice settings
│   │   ├── Services/
│   │   │   ├── DashScopeService.swift  # API integration
│   │   │   └── CostTracker.swift     # Cost tracking
│   │   └── Views/
│   │       └── CameraView.swift   # Camera + UI (Flutter-matching)
│   ├── .env.example              # Environment template
│   └── Package.swift             # Swift Package Manager
├── poc-results/                   # POC test results
│   ├── latency.md
│   ├── tts-quality.md
│   ├── voice-variety.md
│   ├── api-cost.md
│   ├── offline-fallback.md
│   └── decision.md
└── .gitignore
```

---

## 🚀 Quick Start

### 1. Clone & Setup

```bash
cd ios-poc/PawMind
cp .env.example .env
# Edit .env and add your DashScope API key
```

### 2. Open in Xcode

```bash
open PawMind.xcodeproj
```

### 3. Build & Run

1. Select target device (iPhone 14/13)
2. Product → Build (Cmd+B)
3. Product → Run (Cmd+R)

---

## 🧪 POC Tests

See `../../poc-docs/POC-EXECUTION-GUIDE.md` for detailed test scripts.

| Test | Success Criteria | Status |
|------|------------------|--------|
| Latency (WiFi) | ≤2.0s | ⏳ Pending |
| Latency (5G) | ≤2.5s | ⏳ Pending |
| TTS Quality | ≥4/5 rating | ⏳ Pending |
| Voice Variety | ≥75% accuracy | ⏳ Pending |
| API Cost | Match HK$0.0051/thought | ⏳ Pending |
| Offline Fallback | <5s latency | ⏳ Pending |

---

## 📋 Configuration

### .env File

```bash
# Required: DashScope API Key
DASHSCOPE_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# TTS Provider: cosyvoice or native
TTS_PROVIDER=cosyvoice

# TTS Model: cosyvoice-v3.5-flash (recommended)
TTS_MODEL=cosyvoice-v3.5-flash

# Default Language: en, zh, yue, ja
DEFAULT_LANGUAGE=yue

# Default Gender: boy, girl
DEFAULT_GENDER=girl
```

### CosyVoice Voice Settings (from Flutter)

| Language | Gender | Voice Model | Pitch | Rate |
|----------|--------|-------------|-------|------|
| English | Girl | longpaopao_v3 | 2.0 | 0.90 |
| English | Boy | longjielidou_v3 | 0.0 | 0.90 |
| Cantonese | Girl | longjiayi_v3 | 3.0 | 0.90 |
| Cantonese | Boy | longanyue_v3 | 6.0 | 0.90 |

---

## 📊 POC Results

After running tests, results will be saved to `poc-results/`:

- `latency.md` — End-to-end latency measurements
- `tts-quality.md` — Blind test results (n=10)
- `voice-variety.md` — Character voice accuracy
- `api-cost.md` — Actual vs. estimated cost
- `offline-fallback.md` — Offline mode testing
- `decision.md` — Go/No-Go recommendation

---

## 🎯 Success Criteria

**POC Pass (≥0.8 weighted score):**
- ✅ Latency ≤2.0s (WiFi), ≤2.5s (5G)
- ✅ TTS quality ≥4/5
- ✅ Voice variety ≥75% accuracy
- ✅ API cost matches HK$0.0051/thought (±20%)
- ✅ Offline fallback works (<5s)

**Next Phase:** MVP build (4 weeks)

---

## 📞 Support

- **POC Plan:** `../../poc-docs/poc-plan-v2-ios-hybrid.md`
- **Execution Guide:** `../../poc-docs/POC-EXECUTION-GUIDE.md`
- **Scaffold Guide:** `../../poc-docs/poc-scaffold-v2-ios-hybrid.md`

---

**POC Status:** 🏗️ Scaffold Complete  
**Next Step:** Create Swift files (see POC-EXECUTION-GUIDE.md)
