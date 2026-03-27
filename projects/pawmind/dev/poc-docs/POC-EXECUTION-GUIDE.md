# PawMind — POC Execution Guide (iOS Native + Hybrid)

**Platform:** iOS Native (Swift, iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, Reasoning + TTS via DashScope API)  
**Timeline:** 1 week  
**Repo:** https://github.com/bbugs280/paw-mind  
**POC Folder:** `poc-docs/`  
**IDE:** VSCode (primary) + Xcode (build only)

---

## 🎯 Goal

Create a working iOS POC app that:
1. Captures camera frames
2. Calls DashScope API (Qwen-VL-Plus + CosyVoice)
3. Plays audio output
4. Tracks latency and cost
5. Handles offline fallback

**Design Reference:** Match existing Flutter/Expo UI (90% confirmed) — see `mobile/app/index.tsx` and `mobile/constants/config.ts`

---

## 📁 Step 1: Create iOS POC Folder Structure

### In Terminal (run these commands):

```bash
# Navigate to repo
cd ~/path/to/paw-mind

# Create iOS POC directory
mkdir -p ios-poc/PawMind/Sources/App/{Views,Services,Models,Config}
mkdir -p ios-poc/poc-results

# Create .env.example
cat > ios-poc/PawMind/.env.example << EOF
# DashScope API Key
# Get from: https://dashscope.console.aliyun.com/
DASHSCOPE_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# TTS Provider: cosyvoice or native
TTS_PROVIDER=cosyvoice

# Default TTS Model
TTS_MODEL=cosyvoice-v3.5-flash
EOF

# Create .gitignore for iOS POC
cat > ios-poc/.gitignore << EOF
# Xcode
.DS_Store
*.xcworkspace
!*.xcworkspace/contents.xcworkspacedata
*.xcodeproj
!*.xcodeproj/project.pbxproj

# Build
build/
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Secrets
.env
*.key
*.p12
EOF

# Commit structure
git add ios-poc/
git commit -m "Add iOS POC scaffold structure"
git push origin main
```

---

## 🛠️ Step 2: Create Xcode Project (via VSCode)

### Option A: Manual (Recommended)

1. **Open Xcode 15.4+**
2. **File → New → Project**
3. **Choose:** iOS → App
4. **Configure:**
   - Product Name: `PawMind`
   - Team: Your Apple Developer Team
   - Organization Identifier: `com.pawmind`
   - Interface: SwiftUI
   - Language: Swift
   - Storage: Core Data (unchecked)
   - Include Tests: unchecked
5. **Save to:** `paw-mind/ios-poc/PawMind/`
6. **Close Xcode**
7. **Open VSCode** in `paw-mind/ios-poc/PawMind/`

### Option B: VSCode Copilot-Assisted

Open VSCode in `paw-mind/ios-poc/PawMind/` and use this prompt:

```@workspace
Create a minimal Xcode project structure for PawMind iOS app:

Requirements:
- iOS 17.4+
- SwiftUI
- Swift 5.9
- Single view app

Create these files:
1. PawMind.xcodeproj/project.pbxproj (minimal, just enough to open in Xcode)
2. PawMind/Sources/App/App.swift
3. PawMind/Package.swift (SPM for dependencies)

App.swift should:
- Import SwiftUI
- @main struct PawMindApp: App
- Body: WindowGroup { CameraView() }
- Set accent color and asset catalog

Package.swift should:
- Name: PawMind
- Platforms: iOS 17.4
- Products: library + executable
- Dependencies: None (DashScope via URLSession)
- Targets: PawMindApp

After creating, I'll open in Xcode to finalize project settings.
```

---

## 🔌 Step 3: Create DashScope Service (with .env Config)

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Services/` and create `DashScopeService.swift`:

```@workspace /new
Create DashScopeService.swift for PawMind iOS app:

## Requirements

**Configuration (.env file):**
- Load API key from .env file (DASHSCOPE_API_KEY)
- Load TTS provider from .env (TTS_PROVIDER: cosyvoice or native)
- Load TTS model from .env (TTS_MODEL: cosyvoice-v3.5-flash)
- Use SwiftDotEnv or manual .env parsing

**API Integration:**
- Use URLSession for HTTP requests
- Two main methods:
  1. `analyze(image: UIImage) async throws -> DogThought`
  2. `synthesize(text: String, model: String) async throws -> Data`

**Vision API (Qwen-VL-Plus):**
- Endpoint: POST https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation
- Headers: 
  - Authorization: Bearer \(apiKey)
  - Content-Type: application/json
- Body:
  ```json
  {
    "model": "qwen-vl-plus",
    "input": {
      "messages": [{
        "role": "user",
        "content": [
          {"image": "data:image/jpeg;base64,\(base64Image)"},
          {"text": "Analyze this dog's body language. Output JSON: {emotion, intent, confidence, thought}"}
        ]
      }]
    }
  }
  ```
- Parse response to extract thought text

**TTS API (CosyVoice):**
- Endpoint: POST https://dashscope.aliyuncs.com/api/v1/services/aigc/tts/speech
- Headers: Same as above
- Body:
  ```json
  {
    "model": "cosyvoice-v3.5-flash",
    "input": {"text": "\(text)"},
    "parameters": {"format": "mp3"}
  }
  ```
- Return raw audio data

**Voice Configuration (from Flutter/Expo reference):**
Use COSYVOICE_CONFIG from mobile/constants/config.ts:

```swift
struct CosyVoiceConfig {
    static let voiceChoices: [String: [String: String]] = [
        "en": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"],
        "zh": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"],
        "yue": ["girl": "longjiayi_v3", "boy": "longanyue_v3"],
        "ja": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"]
    ]
    
    static let pitchSettings: [String: [String: Double]] = [
        "en": ["girl": 2.0, "boy": 0.0],
        "zh": ["girl": 2.0, "boy": 0.0],
        "yue": ["girl": 3.0, "boy": 6.0],
        "ja": ["girl": 2.0, "boy": 0.0]
    ]
    
    static let rateSettings: Double = 0.90  // All languages
}
```

**Error Handling:**
- Timeout: 10 seconds
- Network errors: Retry once
- API errors (4xx, 5xx): Throw descriptive error

**Timing Instrumentation:**
- Use os_signpost for latency tracking
- Track: vision_time, api_time, tts_time, total_time

**Cost Tracking:**
- Track input_tokens, output_tokens, tts_characters
- Calculate cost in HKD (use rates: ¥0.8/1M in, ¥2/1M out, ¥0.8/10K chars)

Save to: Services/DashScopeService.swift
```

### .env File Setup

After creating the service, create `.env` file:

```bash
cd ios-poc/PawMind
cat > .env << EOF
# DashScope API Key
# Get from: https://dashscope.console.aliyun.com/
DASHSCOPE_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# TTS Provider: cosyvoice or native
TTS_PROVIDER=cosyvoice

# Default TTS Model
TTS_MODEL=cosyvoice-v3.5-flash

# Default Language (en, zh, yue, ja)
DEFAULT_LANGUAGE=yue

# Default Gender (boy, girl)
DEFAULT_GENDER=girl
EOF
```

---

## 📷 Step 4: Create Camera View (Match Flutter UI)

### UI Reference (from Flutter/Expo)

**Layout Structure:**
```
┌─────────────────────────────┐
│  [header: status + profile] │
│                             │
│       Camera preview        │
│                             │
│   ┌──────────────────────┐  │
│   │  Dog thought bubble  │  │
│   └──────────────────────┘  │
└─────────────────────────────┘
```

**Key Components from Flutter:**
- Full-screen camera preview (`CameraView` in Flutter)
- Gradient overlay top (dark to transparent)
- Dog thought bubble (centered, rounded corners)
- Emotion badge (emoji + state)
- Profile selector (top bar)
- Manual snap button (optional)

**State Machine from Flutter:**
```swift
enum SimState: String {
    case idle = "🐾 Paw Mind"
    case connecting = "⏳ Connecting…"
    case ready = "🐶 Ready – snap!"
    case streaming = "💭 Reading mind…"
    case speaking = "🔊 Dog is speaking…"
    case error = "⚠️ Connection lost"
}
```

**Frame Interval:** 5000ms (5 seconds) — from `FRAME_INTERVAL_MS`

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Views/` and create `CameraView.swift`:

```@workspace /new
Create CameraView.swift for PawMind iOS app using SwiftUI + AVFoundation:

## UI Requirements (Match Flutter/Expo Design)

**Layout:**
- Full-screen camera preview (back camera)
- Gradient overlay top (rgba(0,0,0,0.6) to transparent)
- Dog thought bubble (centered, rounded corners, white background)
- Emotion badge overlay (top-right corner, emoji + text)
- Status header (top-left, shows SimState)
- Profile selector (top bar, language/gender)

**State Machine:**
enum SimState: String {
    case idle = "🐾 Paw Mind"
    case connecting = "⏳ Connecting…"
    case ready = "🐶 Ready – snap!"
    case streaming = "💭 Reading mind…"
    case speaking = "🔊 Dog is speaking…"
    case error = "⚠️ Connection lost"
}

**Camera Setup:**
- Use AVCaptureSession for camera access
- Request camera permission in onAppear
- Capture photo every 5 seconds (FRAME_INTERVAL_MS)
- Resolution: 480x360 (optimized for speed)
- JPEG quality: 0.6

**State Management:**
- @Observable class CameraViewModel
- Properties:
  - currentThought: DogThought?
  - simState: SimState
  - errorMessage: String?
  - latency: TimeInterval?
  - isOffline: Bool
  - profile: DogProfile (language, gender, character)

**Flow:**
1. Camera starts on appear
2. Every 5 seconds: capture frame → convert to UIImage
3. Call DashScopeService.analyze(image:)
4. Update simState to .streaming → .speaking
5. Display thought bubble + emotion emoji
6. Call DashScopeService.synthesize(text:)
7. Play audio via AVAudioPlayer
8. Track latency throughout

**Error Handling:**
- Permission denied: Show alert with settings link
- Network error: Show offline indicator, use native TTS fallback
- API error: Show toast message, set simState to .error

**Audio Playback:**
- Use AVAudioPlayer for MP3 playback
- Handle interruptions (phone calls, etc.)
- Stop current speech when new frame captured

Save to: Views/CameraView.swift
```

---

## 📊 Step 5: Create Data Models (Match Flutter Structures)

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Models/` and create these files:

### 5.1: DogThought.swift

```@workspace /new
Create DogThought.swift model for PawMind:

## Requirements

**Struct Definition:**
```swift
struct DogThought: Codable, Identifiable {
    let id: UUID
    let emotion: String          // "happy", "excited", "hungry", etc.
    let intent: String           // "wants to play", "wants food"
    let confidence: Double       // 0.0-1.0
    let thought: String          // First-person monologue
    let timestamp: Date
    
    // Cost tracking
    let inputTokens: Int
    let outputTokens: Int
    let ttsCharacters: Int
    
    // Computed
    var costHKD: Double { calculate }
    var latency: TimeInterval?
}
```

**Methods:**
- `init(from response: JSON)` — Parse API response
- `calculateCost()` — HKD based on DashScope pricing
- `debugDescription` — For logging

**Pricing (Hardcoded):**
- Input: ¥0.8/1M tokens → HK$0.000864/1K (×1.08 for CNY→HKD)
- Output: ¥2/1M tokens → HK$0.00216/1K
- TTS: ¥0.8/10K chars → HK$0.000864/100 chars

Save to: Models/DogThought.swift
```

### 5.2: DogProfile.swift (Match Flutter)

```@workspace /new
Create DogProfile.swift matching Flutter/Expo structure:

## Requirements

**From Flutter (mobile/constants/config.ts):**
```swift
struct DogProfile: Codable {
    let id: String
    let name: String           // e.g., "🐶 My Dog"
    let language: String       // "en", "zh", "yue", "ja"
    let gender: String         // "boy" or "girl"
    let character: String      // System prompt
}

// Default profile (from Flutter)
let DEFAULT_DOG_PROFILE = DogProfile(
    id: "default",
    name: "🐶 My Dog",
    language: "yue",  // Cantonese default
    gender: "girl",
    character: "You are a friendly, curious dog looking at a photo. Analyze what the dog in the photo is thinking or feeling. Be playful and enthusiastic in your response. Keep your response under 2 sentences."
)
```

**Languages (from Flutter):**
```swift
let LANGUAGES = [
    (label: "🇺🇸 EN", lang: "en"),
    (label: "🇨🇳 中文", lang: "zh"),
    (label: "🇭🇰 廣東話", lang: "yue"),
    (label: "🇯🇵 日本語", lang: "ja")
]
```

Save to: Models/DogProfile.swift
```

### 5.3: CosyVoiceConfig.swift (from Flutter)

```@workspace /new
Create CosyVoiceConfig.swift matching Flutter/Expo configuration:

## Requirements

**From Flutter (mobile/constants/config.ts COSYVOICE_CONFIG):**
```swift
struct CosyVoiceConfig {
    // Voice choices by language and gender
    static let voiceChoices: [String: [String: String]] = [
        "en": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"],
        "zh": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"],
        "yue": ["girl": "longjiayi_v3", "boy": "longanyue_v3"],
        "ja": ["girl": "longpaopao_v3", "boy": "longjielidou_v3"]
    ]
    
    // Pitch settings (-20 to +20)
    static let pitchSettings: [String: [String: Double]] = [
        "en": ["girl": 2.0, "boy": 0.0],
        "zh": ["girl": 2.0, "boy": 0.0],
        "yue": ["girl": 3.0, "boy": 6.0],
        "ja": ["girl": 2.0, "boy": 0.0]
    ]
    
    // Rate settings (0.5 to 2.0)
    static let rateSettings: Double = 0.90  // All languages
    
    // Get voice for language + gender
    static func getVoice(language: String, gender: String) -> String {
        return voiceChoices[language]?[gender] ?? "longpaopao_v3"
    }
    
    // Get pitch for language + gender
    static func getPitch(language: String, gender: String) -> Double {
        return pitchSettings[language]?[gender] ?? 2.0
    }
}
```

**State Emoji (from Flutter STATE_EMOJI):**
```swift
let STATE_EMOJI: [String: String] = [
    "happy": "😄",
    "excited": "🤩",
    "hungry": "🍗",
    "sleepy": "😴",
    "curious": "🤔",
    "playful": "🎾",
    "anxious": "😰",
    "unknown": "🐾"
]
```

Save to: Models/CosyVoiceConfig.swift
```

---

## 🧪 Step 6: Run POC Tests

### Test 1: Latency

**Copilot Prompt** (add to `CameraView.swift`):

```@workspace
Add latency tracking to CameraView:

- Use os_signpost to measure:
  1. Frame capture time
  2. API call time (vision + TTS)
  3. Audio playback time
  4. Total end-to-end time

- Display latency overlay in debug mode (toggle with triple-tap)
- Log each measurement to console
- Save average of 10 runs to poc-results/latency.md

Success criteria:
- WiFi: ≤2.0 seconds total
- 5G: ≤2.5 seconds total
```

### Test 2: TTS Quality

**Voice Choices (from Flutter COSYVOICE_CONFIG):**

Use these exact voice models:
```swift
let models = [
    "cosyvoice-v3.5-flash",  // Default, recommended
    "cosyvoice-v3.5-plus",   // Premium quality
    "cosyvoice-v2"           // Legacy
]

// Cantonese test texts
let texts = [
    "波兒！波兒！掉佢啦！",  // BALL! BALL! THROW IT!
    "我係好男孩... 係呀..."  // I'm a good boy... yes I am...
]

// Voice settings for Cantonese (from Flutter)
// Girl: longjiayi_v3, pitch: 3.0, rate: 0.90
// Boy: longanyue_v3, pitch: 6.0, rate: 0.90
```

**Manual Test** (no code needed):

1. Generate 6 audio clips (3 models × 2 texts) using voice settings above
2. Play for 10 testers (blind test)
3. Rate each (1-5):
   - Naturalness
   - Dog personality fit
   - Would you want to hear this?
4. Save results to `poc-results/tts-quality.md`

### Test 3: Voice Variety

**Character Presets (Match Flutter Character System):**

```swift
struct CharacterPreset {
    let name: String
    let prompt: String
    let voiceModifier: String
}

let characterPresets = [
    CharacterPreset(
        name: "Wise Old Dog",
        prompt: "你係一隻聰明、有經驗嘅老狗，語氣平靜、慢",
        voiceModifier: "calm, experienced, slower pace"
    ),
    CharacterPreset(
        name: "Energetic Puppy",
        prompt: "你係一隻興奮、好玩嘅小狗，語氣高、快",
        voiceModifier: "excited, playful, higher pitch, faster"
    ),
    CharacterPreset(
        name: "Sarcastic Terrier",
        prompt: "你係一隻諷刺、幽默嘅狗，語氣平淡、帶諷刺",
        voiceModifier: "dry, witty, flat tone with sarcasm"
    )
]
```

**Copilot Prompt**:

```@workspace
Add character voice support to DashScopeService:

Use characterPresets array above. For each character:
1. Modify system prompt with character personality
2. Adjust pitch/rate based on character traits
3. Generate audio with CosyVoice API

Test by generating 3 clips and running blind test (n=10).
Save results to poc-results/voice-variety.md
```

### Test 4: API Cost

**Copilot Prompt**:

```@workspace
Add cost tracking to DashScopeService:

- Track per-request:
  - input_tokens (from API response)
  - output_tokens (from API response)
  - tts_characters (from input text)

- Calculate running cost:
  - vision_cost = 0 (on-device)
  - reasoning_cost = inputTokens / 1M * 0.8 * 1.08 (CNY→HKD)
  - tts_cost = ttsChars / 10K * 0.8 * 1.08
  - total = reasoning_cost + tts_cost

- Display in debug overlay
- After 100 thoughts, save to poc-results/api-cost.md
- Compare vs. estimate (HK$0.0051/thought)
```

### Test 5: Offline Fallback

**Copilot Prompt**:

```@workspace
Add offline fallback to CameraView:

- Detect network status (NWPathMonitor)
- When offline:
  - Show "Offline Mode" indicator
  - Use AVSpeechSynthesizer (native TTS) instead of CosyVoice
  - Skip vision API, show random thought from local list

- Test by enabling airplane mode
- Verify: app doesn't crash, native TTS works within 3s
- Save results to poc-results/offline-fallback.md
```

---

## 📝 Step 7: Document Results

### Create Result Files

For each test, create a markdown file in `ios-poc/poc-results/`:

**Template:** `poc-results/latency.md`
```markdown
# Latency Test Results

**Date:** 2026-03-27  
**Device:** iPhone 14 Pro  
**Network:** WiFi / 5G / 4G

## Results (10 runs each)

| Network | Avg | Min | Max | Pass? |
|---------|-----|-----|-----|-------|
| WiFi | 1.8s | 1.5s | 2.2s | ✅ |
| 5G | 2.3s | 2.0s | 2.8s | ⚠️ |
| 4G | 3.5s | 3.0s | 4.2s | ❌ |

## Breakdown

| Component | Time |
|-----------|------|
| Vision (on-device) | 80ms |
| Network (HK→CN) | 60ms |
| Qwen-VL-Plus | 1.1s |
| CosyVoice TTS | 600ms |
| Audio playback | 200ms |
| **Total** | **2.0s** |

## Conclusion

✅ Pass on WiFi, ⚠️ Marginal on 5G, ❌ Fail on 4G

**Recommendation:** Optimize for 5G (caching, streaming TTS)
```

---

## 🎯 Step 8: Go/No-Go Decision

After all tests complete, create `poc-results/decision.md`:

```markdown
# POC Go/No-Go Decision

**Date:** 2026-03-27  
**Participants:** Vincent, Wayne, Builder

## Test Results Summary

| Test | Result | Rating |
|------|--------|--------|
| Latency (WiFi) | 1.8s | ✅ |
| Latency (5G) | 2.3s | ⚠️ |
| TTS Quality | 4.2/5 | ✅ |
| Voice Variety | 80% accuracy | ✅ |
| API Cost | HK$0.0049/thought | ✅ |
| Offline Fallback | Works, 2.5s | ✅ |

## Weighted Score

**Score:** 0.88/1.0 (≥0.8 = Pass)

## Decision

✅ **PROCEED TO MVP** (4 weeks)

## Next Steps

1. Refine 5G latency (caching, streaming TTS)
2. Finalize 3 character voices
3. Add user onboarding
4. Prepare TestFlight beta
5. Recruit 100 beta users
```

---

## 🚀 Quick Start Commands

### Copy-Paste This Into VSCode Copilot Chat:

```
@workspace I'm building PawMind iOS POC. Create the following files:

1. App.swift — SwiftUI entry point, launches CameraView
2. DashScopeService.swift — API integration (Qwen-VL-Plus + CosyVoice)
3. CameraView.swift — Camera capture + UI overlay
4. DogThought.swift — Data model with cost tracking

Architecture: Hybrid (vision on-device via MediaPipe, reasoning+TTS via DashScope API)
Platform: iOS 17.4+, Swift 5.9, SwiftUI
Repo: paw-mind/ios-poc/PawMind/

Start with App.swift, then I'll review before continuing.
```

---

## 📞 Support

**If you get stuck:**
1. Share the error message — I'll debug with you
2. Check `poc-plan-v2-ios-hybrid.md` for detailed test scripts
3. Review `GAP-ANALYSIS.md` for architecture context

**Ready to start?** Say **"Scaffold POC"** and I'll create all files for you. 🐾
