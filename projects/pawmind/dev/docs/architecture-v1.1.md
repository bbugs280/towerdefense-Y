# 🐾 PawMind — Technical Architecture (v1.1)

**File:** `architecture-v1.1.md`  
**Version:** 1.1  
**Previous:** `architecture-v1.md` (deprecated, renamed 2026-03-28)  
**Next Review:** After iOS Native POC validation (target: 2026-04-05)

---

## Architecture Decision: Hybrid Model (Updated 2026-03-28)

**Decision:** MVP uses **Hybrid Architecture** (Vision on-device + Cloud Reasoning + Cloud TTS) for faster time-to-market and smaller app size. On-device reasoning can be added in v2.0 if needed.

**Status Update (2026-03-28):**
- ✅ Architecture validated via gap analysis
- ⚠️ iOS Native POC not yet started — Flutter code exists locally but not in repo
- ⚠️ Server-based architecture (FastAPI + WebSocket) exists but will be archived for hybrid POC
- 📋 Next: Scaffold iOS Native POC (see GAP-ANALYSIS.md for action plan)

| Layer | Location | Tech | Why | Constraints |
|-------|----------|------|-----|-------------|
| **Vision** | On-device | MediaPipe Holistic + custom ViT (quantized) | Privacy, low latency, zero API cost | <15MB model size; ≥12 FPS on iPhone 14 |
| **Reasoning** | Cloud | qwen-vl-plus (DashScope) | Better quality, smaller app, easier updates | HK$0.000756/thought; requires internet |
| **Voice** | Cloud | cosyvoice-v3.5-flash or plus (DashScope) | Best-in-class expressive TTS, character voices | HK$0.00432-0.00810/thought; ~600-1000ms latency |
| **Orchestration** | On-device | Flutter + WebSocket | Cross-platform, real-time streaming | Handle offline gracefully, cache thoughts |

---

## Implementation Status (2026-03-28)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| **Flutter App** | ⚠️ Local only | `mobile_flutter/` | Code exists locally, NOT in GitHub repo |
| **FastAPI Server** | ✅ In repo | `server/` | WebSocket-based, will be archived for hybrid POC |
| **iOS Native POC** | ❌ Not started | — | Priority: Week 1 deliverable |
| **MediaPipe Vision** | ❌ Not integrated | — | Will be added to iOS Native app |
| **DashScope Integration** | ✅ Tested | `server/main.py` | Working via server; needs direct iOS integration |
| **Cost Tracking** | ❌ Not implemented | — | To be built in iOS Native app |

**Repo State:** https://github.com/bbugs280/paw-mind (main branch, last updated 2026-03-24)

**Critical Gap:** `mobile_flutter/lib/` directory is NOT committed to GitHub — only test files exist. Decision needed: commit Flutter code for archive OR abandon entirely for iOS Native pivot.

---

## Stack Overview (Original: All On-Device)

*Note: This was the original vision. Hybrid model chosen for MVP to reduce app size and accelerate launch.*

| Layer | Tech | Why | Constraints |
|-------|------|-----|-------------|
| **Vision** | MediaPipe Holistic + custom ViT (quantized) | Proven iOS/Android performance; detects 17+ micro-expressions (lip licks, whale eye, tail wag speed) | <15MB model size; ≥12 FPS on iPhone 14 |
| **Reasoning** | Phi-3-vision (4-bit quantized) via MLX | Lightweight, multimodal, runs locally on iOS/Android; interprets pose + context → "thought" text | ≤1GB RAM usage; ≤300ms inference time |
| **Voice** | Coqui XTTS v2 + LoRA adapter | Best-in-class expressive TTS; supports fine-tuning per prompt in <30 sec | ≤500MB RAM; voice latency <800ms |
| **Orchestration** | Swift (iOS), MLX + Swift bindings | Full control over memory, latency, and privacy | All models loaded into app bundle; no dynamic downloads |

---

## Cost Analysis (Verified via DashScope API 2026-03-27)

### Unit Economics

| Component | Model | Price | Cost per Thought |
|-----------|-------|-------|------------------|
| Vision | MediaPipe + ViT | — | HK$0.00 |
| Reasoning | qwen-vl-plus | ¥0.8/1M in, ¥2/1M out | HK$0.000756 |
| TTS (Flash) | cosyvoice-v3.5-flash | ¥0.8/10K chars | HK$0.004320 |
| TTS (Plus) | cosyvoice-v3.5-plus | ¥1.5/10K chars | HK$0.008100 |

**Total per Thought:**
- **Flash:** HK$0.0051
- **Plus:** HK$0.0089

### Token/Character Usage per Thought

| Component | Usage | Notes |
|-----------|-------|-------|
| Vision input | ~500 tokens | Image embedding + prompt |
| Reasoning output | ~150 tokens | JSON + thought text |
| TTS input | ~50 characters | Spoken thought text |

### Monthly Cost per User (100 thoughts)

| TTS Tier | Cost/User/Month |
|----------|-----------------|
| **Flash** | HK$0.51 |
| **Plus** | HK$0.89 |

### Business Impact

| Metric | Value |
|--------|-------|
| Break-even | ~50 users (tiered subscription) |
| Margin | 97.7% (Flash) / 96.3% (Plus) |
| 18-month profit | ~HK$586K (Flash) / ~HK$581K (Plus) |
| API cost risk | Negligible (10x increase still profitable) |

**Recommendation:** Start with **CosyVoice-Flash** for MVP. Upgrade to Plus later if voice quality feedback warrants it — the HK$8K profit difference over 18 months is negligible (<1.5%).

---

## Privacy & Compliance

- ✅ **HPB (HK Dept of Health) alignment path**: Position as *wellness companion*, not diagnostic tool — disclaimers drafted per HK guidance.
- ✅ **No telemetry by default**: Opt-in requires explicit 2-tap confirmation + anonymized payload review.
- ✅ **Data residency**: Vision processing stays on-device; cloud API calls only for reasoning + TTS (no raw video/images stored).
- ✅ **Offline mode**: Native TTS fallback when no internet connection (reduced quality, no character voices).

---

## Model Sourcing

### Hybrid Model (MVP)
- **Vision:** MediaPipe Holistic + custom ViT on [Canine Ethogram Dataset](https://github.com/helsinki-canine/canine-ethogram) + community-sourced HK clips
- **Reasoning:** qwen-vl-plus via DashScope API (China endpoint, HK-region low latency)
- **Voice:** cosyvoice-v3.5-flash or plus via DashScope API; character prompts for personality shaping

### All On-Device (v2.0 Option)
- **Vision:** Fine-tune MediaPipe + ViT on Canine Ethogram Dataset + community-sourced HK clips
- **Voice:** XTTS v2 base + LoRA adapters trained on 5s HK dog-owner voice samples (e.g., *"Good boy!"*, *"Let's go!"*)
- **Reasoning:** Phi-3-vision, distilled for pet behavior (prompt: *"You are a calm, wise, slightly sarcastic dog. Interpret these cues and speak plainly."*)

---

## First Build Target

### MVP (Hybrid) — iOS Native POC
- **Platform:** iOS 17.4+ (Swift, SwiftUI) — Flutter pivoted away
- **API Integration:** DashScope API direct from app (no server proxy)
- **Fallback:** AVFoundation + speech synthesis for offline mode
- **Latency Target:** <2.5 seconds per thought (vision + reasoning + TTS)
- **POC Deliverables:**
  - `ios-poc/PawMind.xcodeproj`
  - `ios-poc/PawMind/Sources/App/Views/CameraView.swift`
  - `ios-poc/PawMind/Sources/App/Services/DashScopeService.swift`
  - `ios-poc/PawMind/Sources/App/Services/CostTracker.swift`
  - `ios-poc/PawMind/Sources/App/Models/DogThought.swift`

### v2.0 (All On-Device — Optional)
- iOS 17.4+, iPhone 14+ only
- Swift Package Manager integration for MLX + Coqui
- Xcode project scaffolded with model bundling script
- App size target: <200MB (with models)

### Android Consideration
- Deferred until iOS POC validated
- If iOS succeeds: evaluate Flutter revival vs. Kotlin Native
- Decision criteria: iOS user acquisition cost, HK market iOS penetration (~60%)

---

## API Integration Details

### DashScope Endpoints (China Region)

```swift
// Reasoning: Qwen-VL-Plus (iOS Native)
POST https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation
Model: qwen-vl-plus
Input: image (base64) + prompt
Output: JSON { emotion, intent, confidence, thought }

// TTS: CosyVoice (iOS Native)
POST https://dashscope.aliyuncs.com/api/v1/services/aigc/tts/speech
Model: cosyvoice-v3.5-flash (or cosyvoice-v3.5-plus)
Input: text (50 chars avg)
Output: audio data (mp3)
```

### Swift Implementation Notes

```swift
// DashScopeService.swift structure
class DashScopeService {
    private let apiKey: String
    private let session: URLSession
    
    func analyze(image: UIImage) async throws -> DogThought
    func synthesize(text: String, model: String) async throws -> Data
    
    // Cost tracking built into each call
    // Latency instrumentation via os_signpost
}
```

### Cost Tracking

Implement API cost tracking in app analytics:
- Track thoughts generated per user session
- Monitor API response times (target: <2.5s total)
- Alert if cost/user/month exceeds HK$1.00 (indicates abnormal usage)
- Store daily cost totals in UserDefaults for user visibility

### Latency Budget (Updated)

| Stage | Target | Measurement Point |
|-------|--------|-------------------|
| Camera capture | <100ms | Frame captured → UIImage |
| Vision encoding | <200ms | UIImage → base64 |
| API round-trip (reasoning) | <1500ms | POST → JSON response |
| TTS generation | <800ms | Text → audio data |
| Audio playback start | <200ms | Audio data → first sample |
| **Total** | **<2800ms** | Frame → speech out |

**Note:** Server-based architecture (FastAPI + WebSocket) achieved ~2-3s latency. Direct API calls from iOS should reduce this by 300-500ms (no server proxy overhead).

---

*Full business case: `projects/pawmind/planning/business-case-revised.md`*

---

## Open Decisions & Risks

### Decisions Pending

| Decision | Options | Owner | Deadline |
|----------|---------|-------|----------|
| **Flutter code in repo?** | Commit for archive vs. abandon | You | 2026-04-01 |
| **Server archive strategy** | Tag `server-archive` vs. delete | You | 2026-04-01 |
| **iOS POC branch** | `ios-poc` feature branch vs. `main` | You | 2026-03-29 |
| **TTS tier for POC** | Flash (HK$0.00432) vs. Plus (HK$0.00810) | You + Wayne | 2026-03-29 |

### Technical Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| **DashScope API latency from HK** | Medium | Test on 5G + WiFi; fallback to native TTS if >3s |
| **MediaPipe performance on older iPhones** | Medium | Target iPhone 13+; test on iPhone 12 for baseline |
| **API key security in iOS app** | Low | Obfuscate + use App Attest; rotate keys quarterly |
| **CosyVoice character consistency** | Low | Pre-test 10 prompts; create prompt library if needed |
| **Flutter pivot morale** | Low | Frame as strategic focus, not failure; preserve learnings |

### Next Milestone

**iOS Native POC Scaffold** — Week of 2026-03-29  
See `GAP-ANALYSIS.md` for detailed action plan and Copilot prompts.

---

*Last updated: 2026-03-28 08:47 GMT+8*