# PawMind — POC Execution Guide (iOS Native + Hybrid)

**Platform:** iOS Native (Swift, iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, Reasoning + TTS via DashScope API)  
**Timeline:** 1 week  
**Repo:** https://github.com/bbugs280/paw-mind  
**POC Folder:** `poc-docs/`

---

## 🎯 Goal

Create a working iOS POC app that:
1. Captures camera frames
2. Calls DashScope API (Qwen-VL-Plus + CosyVoice)
3. Plays audio output
4. Tracks latency and cost
5. Handles offline fallback

---

## 📁 Step 1: Create iOS POC Folder Structure

### In Terminal (run these commands):

```bash
# Navigate to repo
cd ~/path/to/paw-mind

# Create iOS POC directory
mkdir -p ios-poc/PawMind/Sources/App/{Views,Services,Models}
mkdir -p ios-poc/poc-results

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

## 🛠️ Step 2: Create Xcode Project

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

### Option B: Copilot-Assisted

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

## 🔌 Step 3: Create DashScope Service

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Services/` and create `DashScopeService.swift`:

```@workspace /new
Create DashScopeService.swift for PawMind iOS app:

## Requirements

**API Integration:**
- Use URLSession for HTTP requests
- API key from environment variable (DASHSCOPE_API_KEY)
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

---

## 📷 Step 4: Create Camera View

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Views/` and create `CameraView.swift`:

```@workspace /new
Create CameraView.swift for PawMind iOS app using SwiftUI + AVFoundation:

## Requirements

**Camera Setup:**
- Use AVCaptureSession for camera access
- Request camera permission in onAppear
- Capture photo every 5 seconds
- Resolution: 480x360 (optimized for speed)

**UI Components:**
- Camera preview (full screen)
- Emotion badge overlay (top-right corner)
- Thought text overlay (bottom, scrollable)
- Latency indicator (debug mode, top-left)
- Offline indicator (when no network)

**State Management:**
- @Observable class CameraViewModel
- Properties:
  - currentThought: DogThought?
  - isProcessing: Bool
  - errorMessage: String?
  - latency: TimeInterval?
  - isOffline: Bool

**Flow:**
1. Camera starts on appear
2. Every 5 seconds: capture frame → convert to UIImage
3. Call DashScopeService.analyze(image:)
4. Display thought + emotion
5. Call DashScopeService.synthesize(text:)
6. Play audio via AVAudioPlayer
7. Track latency throughout

**Error Handling:**
- Permission denied: Show alert with settings link
- Network error: Show offline indicator, use native TTS fallback
- API error: Show toast message

**Audio Playback:**
- Use AVAudioPlayer for MP3 playback
- Handle interruptions (phone calls, etc.)

Save to: Views/CameraView.swift
```

---

## 📊 Step 5: Create Data Models

### VSCode Copilot Prompt

Open `ios-poc/PawMind/Sources/App/Models/` and create `DogThought.swift`:

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

**Manual Test** (no code needed):

1. Generate 6 audio clips (3 models × 2 texts):
   ```swift
   let models = ["cosyvoice-v3.5-flash", "cosyvoice-v3.5-plus", "cosyvoice-v2"]
   let texts = [
       "波兒！波兒！掉佢啦！",  // BALL! BALL! THROW IT!
       "我係好男孩... 係呀..."  // I'm a good boy... yes I am...
   ]
   ```

2. Play for 10 testers (blind test)

3. Rate each (1-5):
   - Naturalness
   - Dog personality fit
   - Would you want to hear this?

4. Save results to `poc-results/tts-quality.md`

### Test 3: Voice Variety

**Copilot Prompt**:

```@workspace
Add character voice support to DashScopeService:

Create 3 character presets:
1. Wise Old Dog: "你係一隻聰明、有經驗嘅老狗，語氣平靜、慢"
2. Energetic Puppy: "你係一隻興奮、好玩嘅小狗，語氣高、快"
3. Sarcastic Terrier: "你係一隻諷刺、幽默嘅狗，語氣平淡、帶諷刺"

Add method:
func synthesizeWithCharacter(text: String, character: CharacterPreset) async throws -> Data

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
