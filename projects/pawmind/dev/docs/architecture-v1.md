# 🐾 PawMind — Technical Architecture (v1)

## Stack Overview
All components run **on-device**. No cloud inference, no API calls to external LLMs.

| Layer | Tech | Why | Constraints |
|-------|------|-----|-------------|
| **Vision** | MediaPipe Holistic + custom ViT (quantized) | Proven iOS/Android performance; detects 17+ micro-expressions (lip licks, whale eye, tail wag speed) | <15MB model size; ≥12 FPS on iPhone 14 |
| **Reasoning** | Phi-3-vision (4-bit quantized) via MLX | Lightweight, multimodal, runs locally on iOS/Android; interprets pose + context → "thought" text | ≤1GB RAM usage; ≤300ms inference time |
| **Voice** | Coqui XTTS v2 + LoRA adapter | Best-in-class expressive TTS; supports fine-tuning per prompt in <30 sec | ≤500MB RAM; voice latency <800ms |
| **Orchestration** | Swift (iOS), MLX + Swift bindings | Full control over memory, latency, and privacy | All models loaded into app bundle; no dynamic downloads |

## Privacy & Compliance
- ✅ **HPB (HK Dept of Health) alignment path**: Position as *wellness companion*, not diagnostic tool — disclaimers drafted per HK guidance.
- ✅ **No telemetry by default**: Opt-in requires explicit 2-tap confirmation + anonymized payload review.
- ✅ **Data residency**: All processing stays on device; no export to cloud unless user manually shares voice clip/journal.

## Model Sourcing
- Vision: Fine-tune MediaPipe + ViT on [Canine Ethogram Dataset](https://github.com/helsinki-canine/canine-ethogram) + community-sourced HK clips
- Voice: XTTS v2 base + LoRA adapters trained on 5s HK dog-owner voice samples (e.g., *"Good boy!"*, *"Let’s go!"*)
- Reasoning: Phi-3-vision, distilled for pet behavior (prompt: *"You are a calm, wise, slightly sarcastic dog. Interpret these cues and speak plainly."*)

## First Build Target
- iOS 17.4+, iPhone 14+ only
- Swift Package Manager integration for MLX + Coqui
- Xcode project scaffolded with model bundling script