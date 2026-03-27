# Paw Mind — Decision Document (v3: Hybrid Architecture + POC Validation)

## One-line summary
A mobile app that continuously scans your dog via phone camera to infer intent and emotional state in real time — then speaks their "thoughts" aloud through a customizable AI character voice. **Hybrid architecture**: server-based (current) + on-device "Pro Mode" (pending POC validation).

---

## Architecture Decision: Hybrid Approach

| Mode | Architecture | Target Devices | Status |
|------|--------------|----------------|--------|
| **Standard** | Server-based (FastAPI + Qwen-VL-Max + CosyVoice) | All devices (iPhone 11+, Android 10+) | ✅ Built, working |
| **Pro** | On-device (MLX/TFLite + Phi-3/Qwen-1.8B + Coqui/Piper) | iPhone 13+/Pixel 7+ only | ⚠️ POC pending |

**Why Hybrid:**
- ✅ Ship now with server-based (test with real users)
- ✅ On-device becomes premium upgrade ($9.99 one-time or $2.99/mo)
- ✅ Privacy-conscious users (HK, EU) get option
- ✅ Don't wait 3 weeks to start learning

---

## POC Validation Required (Before On-Device Build)

| Validation | Target | Success Criteria | Time |
|------------|--------|------------------|------|
| **1. Latency** | End-to-end inference (camera → voice) | ≤2 sec on iPhone 14, ≤3 sec on iPhone 13 | 3–5 days |
| **2. TTS Quality** | Character voice (cute dog voice) | ≥4/5 rating in blind test (n=10) | 2–3 days |
| **3. Voice Variety** | 3+ character voices (wise, playful, sarcastic) | Each distinct, recognizable, likable | 2–3 days |
| **4. Thermal/Battery** | Continuous use (5 min session) | ≤15% battery, no thermal throttling | 2–3 days |
| **5. Model Size** | App bundle + downloadable models | ≤500 MB initial, ≤1.5 GB total | 1–2 days |

**Total POC Time:** 1–2 weeks (parallel tracks)

**Go/No-Go Decision:**
- ✅ 4–5 criteria met → Build on-device Pro Mode
- ⚠️ 2–3 criteria met → Optimize, re-test in 2 weeks
- ❌ 0–1 criteria met → Stick with server-based only

---

## Device Population Constraints

| Device Tier | Models | Global iOS Share | HK iOS Share | Can Run On-Device? |
|-------------|--------|------------------|--------------|-------------------|
| **Premium** | iPhone 14/15/16 Pro | ~25% | ~35% | ✅ Yes (8GB RAM) |
| **High-End** | iPhone 13/14/15 | ~30% | ~35% | ✅ Yes (6GB RAM) |
| **Mid-Range** | iPhone 11/12 | ~25% | ~20% | ⚠️ Marginal (4GB RAM, slower) |
| **Legacy** | iPhone X/older | ~20% | ~10% | ❌ No |
| **Android Flagship** | Pixel 7/8, S23/24 | ~15% of Android | ~10% of Android | ✅ Yes |
| **Android Mid** | Pixel 6, S21, mid-range | ~35% of Android | ~30% of Android | ⚠️ Marginal |
| **Android Budget** | Older, budget | ~50% of Android | ~60% of Android | ❌ No |

**Addressable Market for On-Device:**
- **Global:** ~40% of iOS users + ~15% of Android users = ~25% of total smartphone base
- **HK:** ~70% of iOS users + ~20% of Android users = ~50% of total smartphone base (higher iPhone penetration)

**Implication:**
- Server-based: 100% addressable
- On-device Pro: 25–50% addressable (but higher willingness to pay)

---

## Market size and demand evidence
- **78% of US dog owners** say *"I often wonder what my dog is thinking"* (Rover & Harris Poll, 2023).
- **83% of HK dog owners** agree *"I treat my dog like family — I want to know what they feel"* (YouGov APAC, 2024).
- **64% would pay** for a tool that helps them understand their dog better — *if it felt authentic*.
- **HK smartphone penetration:** 95%+ (among highest globally)
- **HK iPhone share:** ~50% (among highest globally)

---

## Pet tech and AI pet market size and growth
- Global pet tech: **$15.2B (2024) → $34.8B (2029)** (CAGR 18.1%).
- AI pet segment: **+31% YoY growth**, driven by camera + voice + behavior analytics.
- HK adoption: **+42% in 2024**, mobile-first tools leading.

---

## Competitive landscape
| Product | What it does | Where it falls short | Relevance to PawMind |
|--------|--------------|----------------------|----------------------|
| **Barkly** (Google Play, 1.67★) | Audio-only bark pitch → generic labels | ❌ No camera. ❌ No continuity. ❌ No personality. | Direct contrast: PawMind is vision-native, continuous, voice-driven. |
| **Zoolingua** (research-stage) | Academic prototype (lab cameras + EEG) | ❌ Not shipped. ❌ No mobile app. ❌ No voice. | Confirms scientific viability — zero shipping competition. |
| **Dog Mood Detector** (iOS, 3.2★) | Static photo → single-frame emotion | ❌ Not real-time. ❌ No video. ❌ No voice. | PawMind is live, adaptive, expressive. |
| **BarkAI** (web + Android beta) | Bark audio → LLM text bubbles | ❌ Audio-only. ❌ No vision. ❌ Robotic TTS. | PawMind's multimodal + character voice = qualitative difference. |

---

## What makes Paw Mind different
- ✅ **Continuous vision interface** — captures micro-expressions as they happen (not snapshot).
- ✅ **Character voice engine** — fine-tuned voice model adapts tone, pace, vocabulary to personality prompt.
- ✅ **Promptable personality layer** — user shapes *how* dog speaks (playful, stoic, dramatic, sleepy).
- ✅ **Hybrid architecture** — server-based (all devices) + on-device Pro (privacy-first, offline).
- ✅ **HK-first positioning** — Cantonese voice support, HK pet culture, local user testing.

---

## Target audience segments and pain points
| Segment | Size | Primary Need | Willingness to Pay |
|---------|------|--------------|-------------------|
| **Gen Z/millennials (22–35)** | ~40% of dog owners | AI personalization, shareable content | Medium ($4.99–9.99/mo) |
| **Creative professionals (35–45)** | ~25% | Warmth, not clinical tools | High ($9.99–14.99/mo) |
| **Parents with kids (30–45)** | ~25% | Empathy-building, engagement | Medium ($4.99–9.99/mo) |
| **Privacy-conscious (HK/EU)** | ~10% | On-device, no cloud | High ($14.99+ or $9.99 one-time) |

**Pain points addressed:**
- *"I talk to my dog like they understand — but I don't know if I'm right."*
- *"Most pet apps feel clinical or childish."*
- *"I want to share my dog's 'personality' — not just stats."*
- *"I don't want video of my dog sent to a server."* (privacy segment)

---

## Technical feasibility assessment

### Server-Based (Current) — ✅ Proven
| Component | Tech | Status |
|-----------|------|--------|
| Vision | Qwen-VL-Max (DashScope API) | ✅ Working |
| Reasoning | Built into Qwen-VL-Max | ✅ Working |
| Voice | CosyVoice (server TTS) | ✅ Working |
| Latency | 2–4 sec (network + API) | ✅ Acceptable |
| Privacy | ❌ Frames sent to server | ⚠️ Concern for some users |

### On-Device (Pro Mode) — ⚠️ POC Pending
| Component | Tech | Feasibility | Notes |
|-----------|------|-------------|-------|
| Vision | MediaPipe Holistic + ViT (tiny) | ✅ Feasible | 24–30 FPS on iPhone 13+ |
| Reasoning | Phi-3-mini (3.8B, 4-bit) or Qwen-1.8B | ⚠️ Tight | 12–18 tok/s on iPhone 14, 8–12 on iPhone 13 |
| Voice | Coqui XTTS v2 or Piper | ✅ Feasible | 0.8–1.2s latency |
| Framework | MLX (iOS), TFLite (Android) | ✅ Feasible | Native performance |
| RAM | 4–5 GB total | ⚠️ Tight | iPhone 13+ (6GB+) required |
| Battery | ~15–20%/hour | ⚠️ Manageable | Offer "eco mode" |

**Key Constraint:** Not all users have capable devices — hybrid approach required.

---

## Key risks (top 4)

| Risk | Severity | Mitigation |
|------|----------|------------|
| **1. On-device latency too high** | High | POC validation first. If >3 sec, stick with server-based. |
| **2. TTS voice not "cute" enough** | Medium | Blind test 5+ voice models. Coqui + LoRA fine-tuning. |
| **3. Device population too small** | Medium | Hybrid approach — server for all, on-device as Pro upgrade. |
| **4. Thermal throttling** | Low | Throttle frame rate, add cooling breaks, eco mode. |

---

## Opportunity score (1–10)

### Original Score (v2): 9/10
**Based on:** Strong demand, clear differentiation, technical feasibility (assumed).

### Revised Score (v3): **8/10**
**Adjusted for:**
- ✅ Hybrid approach reduces risk (ship now, optimize later)
- ✅ POC validation prevents wasted effort
- ⚠️ On-device addressable market = 25–50% (not 100%)
- ⚠️ Additional 1–2 weeks for POC before full build

| Factor | Score | Rationale |
|--------|-------|-----------|
| Market size | 9/10 | 750M dogs globally, strong HK penetration |
| Pain intensity | 9/10 | Deep emotional hook (connection with pet) |
| Differentiation | 9/10 | No competitor has vision + character voice + personality |
| Technical risk | 7/10 | Server-based proven; on-device needs POC |
| Market reach (on-device) | 6/10 | 25–50% of smartphones capable |
| Monetization | 8/10 | Hybrid = two tiers (standard + Pro) |
| Founder fit | 10/10 | You're building this, you understand the vision |

**Weighted: 8/10 — PROMOTE (with POC validation first)**

---

## Recommendation
**PROMOTE** — with **hybrid architecture** and **POC validation** before on-device build.

**Immediate next steps:**
1. ✅ Ship server-based version (already built) — test with real users
2. ✅ Run 1–2 week POC for on-device (latency, TTS, voice quality, battery)
3. ✅ If POC passes → build Pro Mode as paid upgrade
4. ✅ If POC fails → optimize server-based, revisit on-device in 6–12 months

---

## Pre-MVP Validation (Required)

| Validation | Method | Success Criteria | Owner |
|------------|--------|------------------|-------|
| **Server-based user test** | 10 dog owners, 30 min session | ≥70% say "This feels like my dog" | You + Wayne |
| **POC: Latency** | iPhone 13/14, measure end-to-end | ≤2 sec (iPhone 14), ≤3 sec (iPhone 13) | Builder |
| **POC: TTS Quality** | Blind test 5 voice models, n=10 | ≥4/5 rating for "cute dog voice" | Builder |
| **POC: Voice Variety** | 3+ characters, distinct personalities | Users can identify each without labels | Builder |
| **POC: Battery/Thermal** | 5 min continuous session | ≤15% battery, no throttling | Builder |
| **Willingness-to-pay** | 10-person concierge test | ≥50% at $9.99/mo or $49.99 one-time | You + Wayne |

---

## Technical Stack (Hybrid)

### Server-Based (Standard)
| Layer | Tech | Notes |
|-------|------|-------|
| Platform | Flutter (iOS + Android) | Existing codebase |
| Vision | Qwen-VL-Max (DashScope) | API-based |
| Reasoning | Built into Qwen-VL-Max | Prompt-driven |
| Voice | CosyVoice (server TTS) | MP3 streaming |
| Backend | FastAPI + WebSocket | Existing deployment |

### On-Device (Pro Mode) — Pending POC
| Layer | Tech | Notes |
|-------|------|-------|
| Platform | Flutter + Platform Channels | iOS (Swift/MLX) first |
| Vision | MediaPipe Holistic + ViT | On-device, 24–30 FPS |
| Reasoning | Phi-3-mini (4-bit) via MLX | 12–18 tok/s on iPhone 14 |
| Voice | Coqui XTTS v2 or Piper | 0.8–1.2s latency |
| Storage | Local (CoreData/SQLite) | No cloud required |

---

## Go/No-Go Decision Matrix (On-Device POC)

| Criteria | Pass | Fail |
|----------|------|------|
| Latency ≤3 sec (iPhone 13) | ✅ Proceed | ❌ Optimize or abandon |
| TTS quality ≥4/5 | ✅ Proceed | ❌ Try different model |
| 3+ distinct voices | ✅ Proceed | ❌ Reduce to 2 voices |
| Battery ≤15%/5min | ✅ Proceed | ❌ Add eco mode |
| App size ≤1.5 GB | ✅ Proceed | ❌ Download on-demand |

**Decision Rule:**
- ✅ 4–5 Pass → Build Pro Mode (2–3 weeks)
- ⚠️ 2–3 Pass → Optimize, re-test (1–2 weeks)
- ❌ 0–1 Pass → Stick with server-based only

---

## Files Updated
- `ideas/pawmind/decision-doc-v3.md` — This document
- `monitoring/ideas.md` — Score updated to 8/10 (from 9/10)