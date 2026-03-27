# PawMind — POC Plan (iOS Native + Hybrid Architecture)

**Date:** 2026-03-27 (Updated)  
**Platform:** iOS Native (Swift) + Hybrid Architecture  
**Architecture Decision:** Vision on-device, Reasoning + TTS via DashScope API (China endpoint)  
**Goal:** Validate hybrid approach feasibility (latency, cost, UX, offline handling)  
**Duration:** 1 week (accelerated from 2 weeks due to simpler architecture)  

---

## 🔄 Architecture Pivot: Why Hybrid?

**Previous Plan:** Flutter + On-Device (MLX + Phi-3 + Piper)  
**New Plan:** iOS Native + Hybrid (Vision on-device, Reasoning + TTS via API)

### Why the Change?

| Factor | On-Device (Old) | Hybrid (New) | Winner |
|--------|-----------------|--------------|--------|
| **App Size** | 1.5–2.3 GB (with models) | <50 MB (no bundled LLM) | ✅ Hybrid |
| **Latency** | 4–6 seconds (LLM bottleneck) | 1–2 seconds (API) | ✅ Hybrid |
| **Voice Quality** | Piper/Coqui (good) | CosyVoice (excellent, Cantonese) | ✅ Hybrid |
| **Battery** | High (continuous inference) | Low (mostly network calls) | ✅ Hybrid |
| **Offline Mode** | Full functionality | Limited (native TTS fallback) | ⚠️ On-Device |
| **Cost** | HK$0.00 (no API) | HK$0.0051/thought | ⚠️ Hybrid (but negligible) |
| **Development Time** | 2–3 weeks POC | 1 week POC | ✅ Hybrid |
| **Privacy** | All on-device | Vision on-device, text to cloud | ⚠️ Tie |

**Decision:** Hybrid wins on **latency**, **app size**, **voice quality**, and **development speed**. Cost is negligible (HK$0.51/user/month). Offline mode is the only trade-off — mitigated with native TTS fallback.

---

## 📋 POC Overview

| Test | What We're Validating | Success Criteria | Time |
|------|----------------------|------------------|------|
| **1. Latency** | End-to-end (camera → API → voice) | ≤2 sec (WiFi), ≤3 sec (4G/5G) | 2–3 days |
| **2. TTS Quality** | CosyVoice Cantonese quality | ≥4/5 rating (n=10 dog owners) | 2 days |
| **3. Voice Variety** | 3+ character voices (Flash vs. Plus) | Users can identify each without labels | 2 days |
| **4. API Cost Tracking** | Verify actual vs. estimated cost | Match HK$0.0051/thought estimate | 1 day |
| **5. Offline Fallback** | Native TTS when no internet | Graceful degradation, <5 sec latency | 2 days |

**Decision Rule:**
- ✅ 4–5 tests pass → Proceed to MVP build (4 weeks)
- ⚠️ 2–3 tests pass → Optimize, re-test (1 week)
- ❌ 0–1 tests pass → Reconsider on-device or server-based only

---

## 🧪 Test 1: Latency (End-to-End via API)

### What We're Testing
Time from camera capture → vision (on-device) → API call (Qwen-VL-Plus) → TTS (CosyVoice) → audio playback.

### Hardware Required
- iPhone 14 Pro (target device)
- iPhone 13 (minimum viable)
- iPhone 12 (stress test)

### Network Requirements
- WiFi (baseline)
- 5G (realistic mobile)
- 4G (edge case)

### API Endpoints (DashScope China)

```swift
// PawMind/Sources/App/Services/DashScopeService.swift

struct DashScopeService {
    private let apiKey: String
    private let session: URLSession
    
    // Vision + Reasoning
    func analyze(image: UIImage) async throws -> DogThought {
        let request = URLRequest(url: URL(string: "https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation")!)
        // ... POST with image (base64) + prompt
        // Model: qwen-vl-plus
        // Expected latency: 800–1200ms from HK
    }
    
    // TTS
    func synthesize(text: String, model: String = "cosyvoice-v3.5-flash") async throws -> Data {
        let request = URLRequest(url: URL(string: "https://dashscope.aliyuncs.com/api/v1/services/aigc/tts/speech")!)
        // ... POST with text
        // Expected latency: 500–800ms from HK
    }
}
```

### Expected Latency Breakdown

| Component | Expected Time | Notes |
|-----------|---------------|-------|
| Vision (on-device) | 50–100ms | MediaPipe Holistic |
| Network (HK → China) | 50–100ms | DashScope endpoint |
| Qwen-VL-Plus inference | 800–1200ms | ~150 tokens output |
| CosyVoice TTS | 500–800ms | ~50 characters |
| Audio playback | 200–300ms | AVFoundation |
| **Total** | **1.6–2.5 sec** | ✅ Target met |

### Test Script

1. Build iOS app with DashScope integration
2. Run 10 inference sessions per device (WiFi + 5G + 4G)
3. Record latency for each component (use os_signpost)
4. Calculate average, min, max

### Success Criteria

| Rating | WiFi Latency | 5G Latency | Decision |
|--------|--------------|------------|----------|
| ✅ Pass | ≤2 sec | ≤2.5 sec | Proceed to MVP |
| ⚠️ Marginal | 2–3 sec | 2.5–4 sec | Optimize (caching, streaming) |
| ❌ Fail | >3 sec | >4 sec | Reconsider architecture |

### How to Run
1. Create `PawMind/` Xcode project (iOS 17.4+)
2. Add DashScope SDK (Swift Package Manager)
3. Implement `DashScopeService.swift` with timing instrumentation
4. Run tests on iPhone 14/13/12
5. Save results to `poc-results/latency.md`

---

## 🎤 Test 2: TTS Quality (CosyVoice Cantonese)

### What We're Testing
Does CosyVoice Cantonese sound natural, expressive, and emotionally appropriate for a dog's "thoughts"?

### Voice Models to Test

| Model | Language | Style | Cost |
|-------|----------|-------|------|
| **cosyvoice-v3.5-flash** | Cantonese (YUE) | Natural, fast | HK$0.00432/thought |
| **cosyvoice-v3.5-plus** | Cantonese (YUE) | More expressive | HK$0.00810/thought |
| **cosyvoice-v2** | Cantonese (YUE) | Legacy, slower | HK$0.0108/thought |

### Test Script (Blind Test, n=10)

1. Generate 6 audio clips (3 models × 2 texts):
   - Text (Cantonese): *"波兒！波兒！掉佢啦！"* (BALL! BALL! THROW IT!)
   - Text (Cantonese): *"我係好男孩... 係呀..."* (I'm a good boy... yes I am...)

2. Play for 10 testers (blind — no model names revealed)

3. Ask testers to rate each (1–5):
   - *"How natural does this sound?"*
   - *"Does this sound like a dog personality?"*
   - *"Would you want to hear this from your dog?"*

4. Calculate average rating per model

### Success Criteria

| Rating | Average Score | Decision |
|--------|---------------|----------|
| ✅ Pass | ≥4.0/5 | Use this model |
| ⚠️ Marginal | 3.0–3.9/5 | Fine-tune prompts |
| ❌ Fail | <3.0/5 | Try different model |

### How to Run
1. Generate clips via DashScope API (6 clips total)
2. Recruit 10 testers (HK dog owners, Cantonese speakers)
3. Run blind test (30 min session)
4. Save results to `poc-results/tts-quality.md`

---

## 🎭 Test 3: Voice Variety (3+ Characters)

### What We're Testing
Can we create 3+ distinct character voices using CosyVoice + prompt engineering?

### Character Profiles

| Character | Personality | Prompt Example | Voice Traits |
|-----------|-------------|----------------|--------------|
| **Wise Old Dog** | Calm, experienced | *"你係一隻聰明、有經驗嘅老狗，語氣平靜、慢"* | Lower pitch, slower pace |
| **Energetic Puppy** | Excited, playful | *"你係一隻興奮、好玩嘅小狗，語氣高、快"* | Higher pitch, faster pace |
| **Sarcastic Terrier** | Dry, witty | *"你係一隻諷刺、幽默嘅狗，語氣平淡、帶諷刺"* | Mid pitch, slight pause |

### Test Script (Blind Test, n=10)

1. Generate 3 audio clips (same model, different prompts)
2. Play for 10 testers (blind — no character names revealed)
3. Ask testers to match each clip to character:
   - *"Which character said this? (Wise / Puppy / Sarcastic)"*
   - *"How distinct do these sound? (1–5)"*
4. Calculate accuracy rate

### Success Criteria

| Rating | Accuracy | Decision |
|--------|----------|----------|
| ✅ Pass | ≥75% correct | 3 distinct voices viable |
| ⚠️ Marginal | 50–74% correct | Reduce to 2 voices |
| ❌ Fail | <50% correct | Voice variety not feasible |

### How to Run
1. Generate clips via DashScope API (3 characters × 2 models = 6 clips)
2. Run blind test (30 min session)
3. Save results to `poc-results/voice-variety.md`

---

## 💰 Test 4: API Cost Tracking

### What We're Testing
Verify actual API cost matches estimated HK$0.0051/thought.

### Tracking Implementation

```swift
// PawMind/Sources/App/Services/CostTracker.swift

struct CostTracker {
    private var thoughtCount: Int = 0
    private var totalInputTokens: Int = 0
    private var totalOutputTokens: Int = 0
    private var totalTTSChars: Int = 0
    
    func record(thought: DogThought) {
        thoughtCount += 1
        totalInputTokens += thought.inputTokens
        totalOutputTokens += thought.outputTokens
        totalTTSChars += thought.ttsCharacters
        
        // Calculate running cost
        let visionCost = 0.0 // On-device
        let reasoningCost = Double(totalInputTokens) / 1_000_000 * 0.8 * 1.08 // CNY → HKD
        let ttsCost = Double(totalTTSChars) / 10_000 * 0.8 * 1.08
        let totalCost = reasoningCost + ttsCost
        let costPerThought = totalCost / Double(thoughtCount)
        
        print("Cost per thought: HK$\(costPerThought)")
    }
}
```

### Expected vs. Actual

| Component | Estimated | Actual (POC) | Variance |
|-----------|-----------|--------------|----------|
| Vision | HK$0.00 | TBD | — |
| Reasoning (500 in + 150 out) | HK$0.000756 | TBD | TBD |
| TTS (50 chars) | HK$0.004320 | TBD | TBD |
| **Total per thought** | **HK$0.0051** | TBD | TBD |

### Success Criteria
- ✅ Variance <20% → Estimates validated
- ⚠️ Variance 20–50% → Adjust business model
- ❌ Variance >50% → Investigate cause (token usage, model choice)

### How to Run
1. Implement `CostTracker.swift` in POC app
2. Run 100 thoughts (simulated usage)
3. Compare actual vs. estimated
4. Save results to `poc-results/api-cost.md`

---

## 📴 Test 5: Offline Fallback

### What We're Testing
When no internet, does the app gracefully degrade to native TTS?

### Fallback Strategy

| Scenario | Behavior |
|----------|----------|
| **No internet** | Use AVFoundation native TTS (flutter_tts or AVSpeechSynthesizer) |
| **API timeout (>5s)** | Retry once, then fallback to native TTS |
| **API error (5xx)** | Show error toast, fallback to native TTS |
| **Low battery mode** | Disable camera, text-only mode with native TTS |

### Test Script

1. Enable airplane mode
2. Open app, point camera at dog
3. Verify:
   - App doesn't crash
   - Native TTS activates within 3 seconds
   - User sees "Offline mode" indicator
4. Re-enable internet
5. Verify: App automatically switches back to cloud TTS

### Success Criteria

| Rating | Behavior | Decision |
|--------|----------|----------|
| ✅ Pass | Graceful fallback, <5 sec latency | Build MVP |
| ⚠️ Marginal | Fallback works, but slow (>5 sec) | Optimize detection |
| ❌ Fail | Crash or no output | Fix before MVP |

### How to Run
1. Implement offline detection in `DashScopeService.swift`
2. Add AVFoundation fallback
3. Test airplane mode scenario (10 iterations)
4. Save results to `poc-results/offline-fallback.md`

---

## 📊 POC Results Tracker

| Test | Device/Network | Result | Rating | Notes |
|------|----------------|--------|--------|-------|
| Latency | iPhone 14 Pro (WiFi) | TBD | TBD | |
| Latency | iPhone 14 Pro (5G) | TBD | TBD | |
| Latency | iPhone 13 (WiFi) | TBD | TBD | |
| TTS Quality | n=10 testers | TBD | TBD | Flash vs. Plus |
| Voice Variety | n=10 testers | TBD | TBD | 3 characters |
| API Cost | 100 thoughts | TBD | TBD | vs. HK$0.0051 estimate |
| Offline Fallback | Airplane mode | TBD | TBD | Native TTS |

---

## 🗓️ POC Timeline (1 Week)

| Day | Task | Owner | Deliverable |
|-----|------|-------|-------------|
| **Mon** | Scaffold iOS app + DashScope integration | Builder | `PawMind/` Xcode project |
| **Tue** | Test 1: Latency (iPhone 14/13, WiFi + 5G) | Builder | `poc-results/latency.md` |
| **Wed** | Test 2: TTS Quality (generate clips, blind test) | Builder + Wayne | `poc-results/tts-quality.md` |
| **Thu** | Test 3: Voice Variety + Test 4: API Cost | Builder | `poc-results/voice-variety.md`, `poc-results/api-cost.md` |
| **Fri** | Test 5: Offline Fallback + **Go/No-Go Decision** | You + Wayne + Builder | `poc-results/decision.md` |

---

## 🎯 Go/No-Go Decision Matrix

| Criteria | Weight | Pass (✅) | Marginal (⚠️) | Fail (❌) |
|----------|--------|-----------|---------------|-----------|
| Latency (WiFi) | 30% | ≤2 sec | 2–3 sec | >3 sec |
| Latency (5G) | 15% | ≤2.5 sec | 2.5–4 sec | >4 sec |
| TTS Quality | 25% | ≥4.0/5 | 3.0–3.9/5 | <3.0/5 |
| Voice Variety | 15% | ≥75% accuracy | 50–74% | <50% |
| API Cost Accuracy | 10% | <20% variance | 20–50% | >50% |
| Offline Fallback | 5% | Graceful, <5 sec | Works, slow | Crash/fail |

**Scoring:**
- ✅ Pass = 1.0 point
- ⚠️ Marginal = 0.5 points
- ❌ Fail = 0 points

**Weighted Score:**
- ≥0.8 → ✅ Proceed to MVP (4 weeks)
- 0.5–0.7 → ⚠️ Optimize, re-test (1 week)
- <0.5 → ❌ Reconsider architecture

---

## 📁 Output Files

After POC completes:
- `poc-results/latency.md` — Test 1 results
- `poc-results/tts-quality.md` — Test 2 results
- `poc-results/voice-variety.md` — Test 3 results
- `poc-results/api-cost.md` — Test 4 results
- `poc-results/offline-fallback.md` — Test 5 results
- `poc-results/decision.md` — Go/No-Go recommendation

---

## 🚀 Next Steps

1. **Review this plan** — Confirm it covers what you need
2. **Scaffold iOS app** — I'll create `PawMind/` Xcode project with DashScope integration
3. **Run tests** — Follow the scripts above, record results
4. **Decision meeting** — Review results, decide: MVP build or pivot

---

### Your Move

| Option | What Happens |
|--------|--------------|
| **"Scaffold POC"** | I'll create `PawMind/` iOS project with DashScope SDK + test harness |
| **"Start with latency"** | I'll write the exact Swift code for Test 1 (API integration + timing) |
| **"Review timeline"** | We adjust the 1-week plan based on your availability |
| **"Questions first"** | I'll clarify any unclear parts of the POC plan |

**Note:** This pivot to iOS Native + Hybrid simplifies the POC significantly — no MLX, no model bundling, no 2GB downloads. You can focus on UX and API integration.

Ready when you are. 🐾
