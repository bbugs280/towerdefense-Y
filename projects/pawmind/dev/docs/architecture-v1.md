# 🐾 PawMind — Technical Architecture (v1)

## Architecture Decision: Hybrid Model (Updated 2026-03-27)

**Decision:** MVP uses **Hybrid Architecture** (Vision on-device + Cloud Reasoning + Cloud TTS) for faster time-to-market and smaller app size. On-device reasoning can be added in v2.0 if needed.

| Layer | Location | Tech | Why | Constraints |
|-------|----------|------|-----|-------------|
| **Vision** | On-device | MediaPipe Holistic + custom ViT (quantized) | Privacy, low latency, zero API cost | <15MB model size; ≥12 FPS on iPhone 14 |
| **Reasoning** | Cloud | qwen-vl-plus (DashScope) | Better quality, smaller app, easier updates | HK$0.000756/thought; requires internet |
| **Voice** | Cloud | cosyvoice-v3.5-flash or plus (DashScope) | Best-in-class expressive TTS, character voices | HK$0.00432-0.00810/thought; ~600-1000ms latency |
| **Orchestration** | On-device | Flutter + WebSocket | Cross-platform, real-time streaming | Handle offline gracefully, cache thoughts |

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

### MVP (Hybrid)
- **Platform:** iOS 17.4+ + Android 14+ (Flutter)
- **API Integration:** DashScope SDK (China endpoint)
- **Fallback:** flutter_tts for offline mode
- **Latency Target:** <2 seconds per thought (vision + reasoning + TTS)

### v2.0 (All On-Device — Optional)
- iOS 17.4+, iPhone 14+ only
- Swift Package Manager integration for MLX + Coqui
- Xcode project scaffolded with model bundling script
- App size target: <200MB (with models)

---

## API Integration Details

### DashScope Endpoints (China Region)

```dart
// Reasoning: Qwen-VL-Plus
POST https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation
Model: qwen-vl-plus
Input: image (base64) + prompt
Output: JSON { emotion, intent, confidence, thought }

// TTS: CosyVoice
POST https://dashscope.aliyuncs.com/api/v1/services/aigc/tts/speech
Model: cosyvoice-v3.5-flash (or cosyvoice-v3.5-plus)
Input: text (50 chars avg)
Output: audio stream (mp3/wav)
```

### Cost Tracking

Implement API cost tracking in app analytics:
- Track thoughts generated per user session
- Monitor API response times (target: <2s total)
- Alert if cost/user/month exceeds HK$1.00 (indicates abnormal usage)

---

*Full business case: `projects/pawmind/planning/business-case-revised.md`*