# 🐾 PawMind — MVP Product Requirements Document (v1)

## Goal
Ship a privacy-first, on-device iOS app that lets dog owners point their phone camera at their dog and hear real-time, character-driven "thoughts" — e.g., *"I’m bored — throw the ball!"* — in a voice they designed.

## User Story
> As a dog owner, I want my dog to ‘say’ *‘I’m bored — throw the ball!’* in their chosen voice — so I can respond meaningfully within 3 seconds.

## Must-Have Features (MVP)
| Feature | Description | Acceptance Criteria |
|---------|-------------|-------------------|
| **Live Camera Feed** | Full-screen iOS camera view with real-time pose + micro-expression overlay | • Runs ≥12 FPS on iPhone 14<br>• Shows confidence score (0–100%) per inference |
| **3 Pre-Built Character Voices** | "Wise Old Dog", "Energetic Puppy", "Sarcastic Terrier" — each with distinct tone, pace, vocabulary | • Voice output matches prompt intent with ≥92% user agreement in blind HK test (n=10)<br>• All voices run locally, <800ms latency |
| **Prompt Field** | Text input where user writes personality traits: *"Make him sound like a grumpy Shiba who loves naps"* | • On-device LoRA adapter fine-tunes voice in <30 sec from 5s sample<br>• Supports Cantonese + English prompts |
| **Privacy-First Default** | Zero telemetry unless explicitly opted-in | • No data leaves device by default<br>• Opt-in anonymized logs require 2-tap confirmation |

## Should-Have (Post-MVP)
- Journal export (PDF/voice clip)
- Multi-dog profile switching
- "Explain why" mode (shows which cues triggered the thought)

## Won’t-Do (v1)
- Android support (iOS only for MVP)
- Cloud backup or sync
- Bark/audio-only mode

## Success Metrics
- ≥75% of HK beta testers say *"This feels like my dog"* (qualitative survey)
- ≤500ms end-to-end latency (camera → voice) on iPhone 14
- ≥4.7 App Store rating at launch