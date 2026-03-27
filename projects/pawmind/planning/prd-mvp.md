# 🐾 Paw Mind — Product Requirements Document (PRD)

**Version:** 1.0 (MVP)  
**Date:** 2026-03-23  
**Author:** Vincent + AI Assistant  
**Status:** 🚀 Ready for Development  
**Target Launch:** 2026-05-23 (8 weeks from start)

---

## Executive Summary

| Attribute | Value |
|-----------|-------|
| **Product** | Paw Mind — AI Dog Mind Reader |
| **Platform** | iOS + Android (Flutter) |
| **Market** | Hong Kong (primary), APAC (secondary) |
| **Differentiator** | Cantonese support + continuous vision AI + character customization |
| **MVP Timeline** | 8 weeks |
| **Success Metric** | 500 beta users, 50% D7 retention, 4.0+ App Store rating |
| **Unit Economics** | HK$0.0051/thought (Flash) or HK$0.0089/thought (Plus) |
| **Break-Even** | ~50 users (tiered subscription) |
| **18-Month Profit** | ~HK$586K (base case) |

---

## 1. Product Vision

### Vision Statement

> **"Give every dog a voice — playful, expressive, and uniquely theirs."**

### Problem Statement

Dog owners constantly anthropomorphize their pets ("He's mad at the mailman!" / "She loves this person!"). Existing solutions are:
- **Audio-only** (Barkly: 1.67★) — inaccurate, no context
- **Research-stage** (Zoolingua) — no consumer product
- **Hardware-dependent** (Furbo: $150+) — expensive, limited functionality

No solution offers:
- Vision-based behavior interpretation
- Multi-language support (especially Cantonese)
- Character customization
- Real-time, playful narration

### Solution

Paw Mind uses Qwen-VL-Max (vision AI) + CosyVoice (TTS) to:
1. Analyze live camera frames of the dog
2. Interpret behavior → emotion → "thought"
3. Speak the thought aloud in a customizable character voice
4. Get smarter over time via user feedback

---

## 1.5 Technical & Cost Assumptions (Verified 2026-03-27)

### Architecture: Hybrid Model

| Component | Location | Model | Cost |
|-----------|----------|-------|------|
| **Vision** | On-device | MediaPipe + ViT | HK$0.00 |
| **Reasoning** | Cloud | qwen-vl-plus | HK$0.000756/thought |
| **TTS** | Cloud | cosyvoice-v3.5-flash or plus | HK$0.00432-0.00810/thought |

### Cost Per Thought

| TTS Tier | Total Cost | Use Case |
|----------|------------|----------|
| **CosyVoice-Flash** | HK$0.0051 | MVP launch, standard quality |
| **CosyVoice-Plus** | HK$0.0089 | Premium character voices, enhanced expression |

### Usage Assumptions

| Metric | Value |
|--------|-------|
| Thoughts per session | 4-6 (weighted average) |
| Sessions per month | 18-20 (weighted average) |
| Thoughts per month | ~100-120 per user |
| Cost per user/month | HK$0.51 (Flash) or HK$0.89 (Plus) |

### Business Impact

| Metric | Value |
|--------|-------|
| Break-even users | ~50 (tiered subscription model) |
| Margin | 97.7% (Flash) / 96.3% (Plus) |
| 18-month profit (base case) | ~HK$586K (Flash) / ~HK$581K (Plus) |
| Failure case (5% conversion) | ~HK$150K profit (still profitable) |

**Recommendation:** Start with **CosyVoice-Flash** for MVP. The HK$8K profit difference over 18 months is negligible (<1.5%) — upgrade to Plus later if voice quality feedback warrants it.

*Full analysis: `projects/pawmind/planning/business-case-revised.md`*

---

## 2. Target Users

### Primary Persona: "Cantonese Carol"

| Attribute | Value |
|-----------|-------|
| **Name** | Carol Chan (陳嘉儀) |
| **Age** | 34 |
| **Location** | Kowloon, Hong Kong |
| **Dog** | Max (Golden Retriever, 4 years) |
| **Occupation** | Marketing Manager |
| **Tech Savviness** | High (early adopter) |
| **Behavior** | Posts daily dog videos on Instagram (2K followers) |
| **Pain Point** | "All pet apps are in English. My followers want Cantonese content." |
| **Quote** | *"If an app could make Max talk in Cantonese with HK slang? I'd pay $50/month."* |

### Secondary Persona: "Millennial Dog Parent"

| Attribute | Value |
|-----------|-------|
| **Name** | Jason Lee |
| **Age** | 28 |
| **Location** | Hong Kong Island |
| **Dog** | Keke (Italian Greyhound, 3 years) |
| **Occupation** | Software Engineer |
| **Tech Savviness** | Very High (builds side projects) |
| **Behavior** | Treats dog like a child, buys premium products |
| **Pain Point** | "I want to understand Keke better — and share her personality with friends." |
| **Quote** | *"I spend more on Keke than myself. If this app makes her 'talk', I'm in."* |

---

## 3. Scope: MVP (v1.0) vs. v2.0

### ✅ MVP (v1.0) — Ship in 8 Weeks

| Feature | Description | Priority | Effort |
|---------|-------------|----------|--------|
| **Live Camera Feed** | Continuous camera preview, capture frame every 5s | P0 | 3 days |
| **Vision AI (Qwen-VL-Max)** | Analyze frame → emotion + "thought" text | P0 | 5 days |
| **CosyVoice TTS** | Server-side TTS with audio streaming | P0 | 4 days |
| **Native TTS Fallback** | flutter_tts for offline/no-server mode | P0 | 2 days |
| **4 Languages** | EN / ZH / YUE / JA (Cantonese is key) | P0 | 3 days |
| **Gender Voice** | Boy (low pitch) / Girl (high pitch) | P0 | 1 day |
| **7 Character Personalities** | playful, grumpy, dramatic, zen, sassy, loyal, chaotic | P0 | 2 days |
| **5 Breed Traits** | golden_retriever, husky, corgi, italian_greyhound, mixed | P0 | 2 days |
| **7 Spoken Styles** | simple, dramatic, poetic, funny, philosophical, childlike, sarcastic | P1 | 2 days |
| **WebSocket Protocol** | Real-time frame upload + token streaming | P0 | 3 days |
| **Settings Screen** | Configure character, breed, language, voice | P0 | 3 days |
| **Thought History** | Local list of recent "thoughts" (last 50) | P1 | 2 days |
| **Share Clip** | Export thought as text + audio (no video yet) | P1 | 3 days |
| **Onboarding Flow** | 3-screen intro + permission requests | P0 | 2 days |
| **Basic Analytics** | Session count, session duration (Firebase) | P1 | 2 days |

**Total MVP Effort:** ~39 development days (~8 weeks with buffer)

---

### ⏭️ v2.0 — Post-Launch (Weeks 9-16)

| Feature | Description | Why Not MVP |
|---------|-------------|-------------|
| **Feedback Loop (✅/😂/✏️)** | User rates each thought → personalization | Critical but can launch without; add in v2.0.1 |
| **Breed Expansion** | 20+ breeds (from 5) | Start with most common, expand later |
| **Video Clip Export** | Export video + audio + caption | Requires video rendering; complex |
| **Subscription (RevenueCat)** | Freemium pricing + IAP | Launch free first, monetize after validation |
| **User Accounts (Firebase Auth)** | Cloud sync, multi-device | Local-first for MVP; add accounts in v2 |
| **Photo Library Analysis** | Analyze existing photos (not just live) | Nice-to-have; live camera is core |
| **Cat Mode** | Separate model for cats | Focus on dogs first; cats in v2 |
| **Community Packs** | Share breed/personality packs | Requires backend + moderation |
| **Widget (iOS/Android)** | Home screen widget for quick access | Post-launch enhancement |
| **Apple Watch App** | Glanceable dog thoughts | Platform expansion; not core |

---

### ❌ Cut (Not in v1 or v2)

| Feature | Reason |
|---------|--------|
| **Wearable Integration** | Hardware dependency; out of scope |
| **Multi-Dog Households** | Complex UI/UX; <10% of users |
| **Veterinary Mode** | Regulatory risk; requires certifications |
| **Real-Time Translation** | Technically infeasible; misleading |
| **Social Network** | Build audience elsewhere (Instagram, TikTok) |

---

## 4. User Stories

### Epic 1: Onboarding & Setup

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-1.1 | As a new user, I want to understand what Paw Mind does in 30 seconds | - 3-screen onboarding carousel<br>- Clear value prop: "Give your dog a voice"<br>- Disclaimer: "For entertainment only" |
| US-1.2 | As a user, I want to grant camera/mic permissions easily | - Permission prompts with context ("We need camera to see your dog")<br>- Handle denial gracefully (show settings link) |
| US-1.3 | As a user, I want to set up my dog's profile quickly | - Enter dog name, breed, gender, language<br>- Pre-select popular breeds<br>- <2 min setup time |
| US-1.4 | As a Cantonese speaker, I want Cantonese as the default language | - Auto-detect device locale → default to YUE if zh-HK<br>- Manual override available |

---

### Epic 2: Core Experience (Camera + AI)

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-2.1 | As a user, I want to see my dog on screen in real-time | - Camera preview at 30fps<br>- No lag or stuttering<br>- Handle low light gracefully |
| US-2.2 | As a user, I want the app to capture my dog's behavior automatically | - Auto-capture every 5 seconds<br>- Visual indicator when capturing<br>- Skip if no dog detected (future: dog detection ML) |
| US-2.3 | As a user, I want to see my dog's "thought" appear on screen | - Text streams in real-time (token by token)<br>- Emotion tag displayed (e.g., "😄 excited")<br>- Animation: thought bubble |
| US-2.4 | As a user, I want to hear my dog's "thought" spoken aloud | - Auto-play audio after text complete<br>- Volume control<br>- Mute button |
| US-2.5 | As a user, I want to switch languages easily | - Language dropdown in settings<br>- Instant switch (no restart)<br>- All 4 languages functional |
| US-2.6 | As a user, I want to customize my dog's personality | - Character picker (7 options)<br>- Breed picker (5 breeds)<br>- Style picker (7 styles)<br>- Preview example before saving |

---

### Epic 3: Settings & Personalization

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-3.1 | As a user, I want to change my dog's character anytime | - Settings screen accessible from home<br>- Changes apply immediately (next thought)<br>- Persist across sessions |
| US-3.2 | As a user, I want to switch between CosyVoice and native TTS | - Toggle in settings<br>- CosyVoice = higher quality, requires internet<br>- Native = offline, lower quality |
| US-3.3 | As a user, I want to adjust voice pitch and speed | - Sliders for pitch (0.8-1.2) and speed (0.8-1.2)<br>- Preview button to test voice<br>- Defaults per gender |
| US-3.4 | As a user, I want to save multiple dog profiles | - Add/remove dogs<br>- Switch between profiles<br>- Store up to 5 dogs locally |

---

### Epic 4: History & Sharing

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-4.1 | As a user, I want to see my dog's recent thoughts | - History screen with last 50 thoughts<br>- Timestamp for each<br>- Filter by emotion |
| US-4.2 | As a user, I want to replay a thought's audio | - Tap history item → replay audio<br>- Audio cached locally |
| US-4.3 | As a user, I want to share a thought as text + audio | - Share button → system share sheet<br>- Export as text file + MP3<br>- Optional: caption template |
| US-4.4 | As a user, I want to copy a thought to clipboard | - Long-press → copy text<br>- Toast confirmation |

---

### Epic 5: Error Handling & Offline Mode

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-5.1 | As a user, I want the app to work when offline | - Native TTS fallback when no internet<br>- Queue frames locally<br>- Sync when connection restored |
| US-5.2 | As a user, I want clear error messages when something fails | - Human-readable errors (not stack traces)<br>- Suggested fixes ("Check internet connection")<br>- Retry button |
| US-5.3 | As a user, I want the app to handle no dog detected gracefully | - Show "No dog detected" message<br>- Suggest better lighting/angle<br>- Don't charge API call |

---

## 5. Technical Requirements

### 5.1 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                        │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ Camera Feed │  │ Settings UI  │  │ History/Share    │   │
│  │ (30fps)     │  │ (7 dims)     │  │ (Last 50)        │   │
│  └──────┬──────┘  └──────────────┘  └──────────────────┘   │
│         │ WebSocket (wss://)                                │
└─────────┼───────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│              FastAPI Server (Docker + Nginx)                 │
│  ┌──────────────────┐  ┌─────────────────────────────────┐  │
│  │ Frame Handler    │  │ Qwen-VL-Max (DashScope API)     │  │
│  │ (WebSocket)      │  │ → Emotion + Thought Text        │  │
│  └──────────────────┘  └─────────────────────────────────┘  │
│                          │                                   │
│                          ▼                                   │
│                  ┌──────────────────┐                       │
│                  │ CosyVoice TTS    │                       │
│                  │ (DashScope API)  │                       │
│                  └──────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| **Mobile** | Flutter | 3.11+ |
| **State Management** | Riverpod | 2.4+ |
| **Camera** | camera package | 0.10.5+ |
| **WebSocket** | web_socket_channel | 2.4+ |
| **Audio Playback** | just_audio | 0.9.36+ |
| **Native TTS** | flutter_tts | 3.8+ |
| **Backend** | FastAPI | 0.115+ |
| **ASGI Server** | uvicorn | 0.30+ |
| **Vision AI** | Qwen-VL-Max (DashScope) | Latest |
| **TTS** | CosyVoice (DashScope) | Latest |
| **Deployment** | Docker + Cloudflare Tunnel | Latest |

### 5.3 Performance Requirements

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Frame Capture Latency** | <500ms | Capture → WebSocket send |
| **AI Response Time** | <3s | Frame → thought text |
| **TTS Latency** | <2s | Text → audio playable |
| **Total Round-Trip** | <6s | Frame → audio playback |
| **App Cold Start** | <2s | Launch → camera ready |
| **Battery Drain** | <15%/hour | Continuous camera use |
| **Memory Usage** | <200MB | iOS Activity Monitor |

### 5.4 Security & Privacy

| Requirement | Implementation |
|-------------|----------------|
| **Data in Transit** | WebSocket over WSS (TLS 1.3) |
| **Data at Rest** | Local SQLite (encrypted via flutter_secure_storage) |
| **API Keys** | Server-side only (never in mobile app) |
| **Camera Frames** | Not stored server-side (ephemeral processing) |
| **GDPR/PDPO** | Explicit consent on onboarding; data export/delete on request |
| **COPPA** | Age gate (13+ only); no data collection from children |

---

## 6. Acceptance Criteria (MVP Launch)

### Functional Criteria

- [ ] Camera feed displays at 30fps without stuttering
- [ ] Frame capture every 5s (configurable)
- [ ] Qwen-VL-Max returns emotion + thought text in <3s
- [ ] CosyVoice TTS generates audio in <2s
- [ ] All 4 languages (EN/ZH/YUE/JA) functional
- [ ] All 7 character personalities produce distinct outputs
- [ ] All 5 breed traits produce distinct outputs
- [ ] Gender voice (boy/girl) changes pitch appropriately
- [ ] Settings changes apply immediately
- [ ] History screen shows last 50 thoughts
- [ ] Share exports text + audio successfully
- [ ] Offline mode falls back to native TTS
- [ ] Error messages are human-readable

### Non-Functional Criteria

- [ ] App cold start <2s on iPhone 12+ / Pixel 6+
- [ ] Battery drain <15%/hour during continuous use
- [ ] Memory usage <200MB (iOS Instruments / Android Profiler)
- [ ] No crashes in 100-session stress test
- [ ] WebSocket reconnects automatically on disconnect
- [ ] App Store rating ≥4.0 (first 100 reviews)

### Analytics Criteria

- [ ] Firebase Analytics integrated
- [ ] Track: session_start, frame_captured, thought_generated, audio_played, share_clicked
- [ ] Dashboard: DAU, session duration, retention D1/D7/D30

---

## 7. Go-to-Market Plan (MVP Launch)

### Beta Launch (Week 7-8)

| Activity | Owner | Timeline |
|----------|-------|----------|
| Recruit 100 beta users (HK dog owners) | Vincent | Week 6 |
| TestFlight (iOS) + Play Console (Android) | Engineering | Week 7 |
| Collect feedback (survey + interviews) | Product | Week 8 |
| Iterate on top 3 issues | Engineering | Week 8 |

### Public Launch (Week 9)

| Activity | Owner | Timeline |
|----------|-------|----------|
| App Store + Play Store submission | Engineering | Week 8 (Fri) |
| Press release (HK Tech Wire, TechCrunch) | Marketing | Week 9 (Mon) |
| Influencer partnerships (5-10 pet accounts) | Community | Week 9 |
| Launch party (virtual or IRL) | Vincent | Week 9 (Sat) |

### Post-Launch (Weeks 10-12)

| Activity | Owner | Timeline |
|----------|-------|----------|
| Monitor reviews + respond to all | Community | Ongoing |
| Weekly bugfix releases | Engineering | Every Tue |
| v2.0 planning (feedback loop) | Product | Week 10 |
| Monetization strategy (RevenueCat) | Product | Week 11 |

---

## 8. Success Metrics

### North Star Metric

> **Weekly Active Dogs (WAD)** — Number of unique dogs with ≥3 sessions/week

### MVP Success Criteria (First 90 Days)

| Metric | Target | Stretch |
|--------|--------|---------|
| **Downloads** | 5,000 | 10,000 |
| **MAU** | 2,500 | 5,000 |
| **D7 Retention** | 50% | 60% |
| **D30 Retention** | 30% | 40% |
| **Session Duration** | 3 min | 5 min |
| **Share Rate** | 20% (1 clip/week/user) | 40% |
| **App Store Rating** | 4.0+ | 4.5+ |
| **Cantonese Usage** | 60% of sessions | 80% |

### Failure Conditions (Pivot Triggers)

| Condition | Action |
|-----------|--------|
| D7 retention <30% after 3 iterations | Re-evaluate core value prop |
| <10% share rate after 30 days | Add viral mechanics (referral bonuses) |
| Crash rate >5% | Halt feature development; focus on stability |
| Cantonese usage <20% | Revisit localization quality |

---

## 9. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation | Owner |
|------|--------|------------|------------|-------|
| **DashScope API downtime** | High | Low | Fallback to native TTS; cache recent responses | Engineering |
| **WebSocket disconnection (mobile networks)** | Medium | Medium | Auto-reconnect logic; queue frames locally | Engineering |
| **Battery drain complaints** | High | High | Adaptive frame rate (5s → 15s when idle); background optimization | Engineering |
| **CosyVoice latency >3s** | Medium | Medium | Show "thinking…" animation; stream tokens progressively | Engineering |
| **Low Cantonese adoption** | High | Low | HK-focused marketing; influencer partnerships | Marketing |
| **App Store rejection (misleading claims)** | High | Low | Clear disclaimers; "entertainment only" positioning | Legal |
| **Competitor launches similar feature** | Medium | Low | Speed to market; community building; Cantonese moat | Strategy |

---

## 10. Appendix

### A. Competitive Feature Matrix

| Feature | Paw Mind MVP | Barkly | Dog Mood | BarkAI |
|---------|--------------|--------|----------|--------|
| Vision AI | ✅ | ❌ | ⚠️ | ❌ |
| Cantonese | ✅ | ❌ | ❌ | ❌ |
| Character Customization | ✅ | ❌ | ❌ | ❌ |
| Real-Time TTS | ✅ | ❌ | ❌ | ❌ |
| Offline Mode | ✅ | ✅ | ✅ | ❌ |
| Price | Free (MVP) | Free (ads) | $5/mo | $15/mo |

### B. Sample Prompt Templates

See: `ideas/pawmind/prompt-architecture.md`

### C. Keke's Profile (Test Case)

See: `ideas/pawmind/keke-profile.md`

### D. Technical Spec (API Contracts)

See: `projects/pawmind/technical/api-spec.md` (TBD)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-23 | Vincent + AI Assistant | Initial PRD for MVP |

---

*This PRD is a living document. Update as requirements evolve.*
