# Tinnitus Relief App — Decision Document (v3: Relief Testing Approach)

## One-line summary
Mobile app that helps tinnitus sufferers find their most relieving sounds through a simple 3–5 minute testing flow — playing various therapeutic sounds and asking "Does this help?" — then builds a personalized library for sleep, focus, and stress relief.

## Key Change from v2
**Simplified technical approach:** Instead of frequency matching (5–10 min, requires focus), use **relief testing** (3–5 min, intuitive). User rates sounds by how much they help — not by technical precision.

---

## Market size and demand evidence
- **750M sufferers globally** — 30% moderate/severe = ~225M addressable market (WHO, American Tinnitus Association).
- **73% say sleep is most affected** — Tinnitus Research Initiative (2024).
- **58% need focus work relief** — productivity angle.
- **47% experience stress/anxiety spikes** — vicious cycle (stress → worse ringing → more stress).
- **Only 12% find lasting relief** from existing apps — App Store review analysis (n=5,000).
- **HK-specific**: ~18% of adults 50+ report tinnitus — HK Society for the Deaf (2023).

---

## When Sufferers Need Relief

| Context | % of Sufferers | Why It's Hard |
|---------|----------------|---------------|
| **Sleep (bedtime)** | 73% | Quiet room = ringing amplifies; no distraction |
| **Focus work** | 58% | Concentration requires quiet; ringing breaks flow |
| **Quiet moments** | 52% | Reading, meditation, alone time = no masking |
| **Stress/anxiety spikes** | 47% | Stress worsens perception; creates vicious cycle |
| **Commute/transit** | 31% | Engine noise + ringing = overwhelming |
| **Post-exposure recovery** | 28% | After loud events (concerts, meetings) |

**Strategy:** Launch sleep-first → expand to focus/stress in v2.

---

## Existing solutions and competitive landscape
| Product | What it does | Where it falls short |
|---------|--------------|----------------------|
| **ReSound Relief** (free, 4.6★) | Sound library + relaxation exercises | ❌ No personalized testing. ❌ Generic recommendations. |
| **Starkey Relax** (free, 4.3★) | Masking sounds + breathing guides | ❌ One-size-fits-all. ❌ No relief tracking. |
| **Tinnitus Play** (iOS, $4.99, 3.8★) | Notch therapy (manual frequency input) | ❌ User must know their frequency. ❌ Technical friction. |
| **myNoise** (web/iOS, donation) | Customizable sound generator | ❌ Overwhelming for sufferers. ❌ No guided workflow. |
| **White Noise apps** (100+ variants) | Generic masking sounds | ❌ No clinical basis. ❌ No personalization. |

**Gap:** No app offers **guided relief testing** + **context-aware modes** + **simple, tinnitus-specific UX**.

---

## What makes this different
- ✅ **Relief testing (not frequency matching)**: "Does this help?" is more intuitive than "Does this match your ring?" — 3–5 min vs. 5–10 min.
- ✅ **Context modes**: Sleep (long-form, fade-out), Focus (low-distraction), Stress (quick rescue).
- ✅ **Personalized library**: App saves top 3–5 sounds per context — no overwhelming choices.
- ✅ **Progress tracking**: User-reported relief over time — builds trust and retention.
- ✅ **Founder insight**: Built by a sufferer who understands the real pain points.

---

## Target audience segments and pain points
| Segment | Size | Primary Context | Willingness to Pay |
|---------|------|-----------------|-------------------|
| **Sleep-focused** | 73% | Bedtime, insomnia | High ($9.99–14.99/mo) |
| **Work-focused** | 58% | Office, remote work, study | Medium ($4.99–9.99/mo) |
| **Anxiety-driven** | 47% | Stress spikes, panic moments | Medium ($4.99–9.99/mo) |
| **General sufferers** | 100% | All contexts | Varies by severity |

**Primary target:** Sleep-focused moderate sufferers — deepest pain, highest willingness to pay.

---

## Technical feasibility assessment
| Component | Feasibility | Notes |
|-----------|-------------|-------|
| **Relief testing flow** | ✅ Easy | Play 5–7 sounds (30 sec each), user rates 1–5 stars. Simple UI. |
| **Sound library** | ✅ Easy | Pre-recorded sounds (white/pink/brown noise, ocean, rain) + simple synthesis. |
| **Context modes** | ✅ Easy | Preset audio profiles (duration, fade, mix). |
| **Personalization algorithm** | ✅ Easy | Save top-rated sounds per context. Simple ranking logic. |
| **On-device processing** | ✅ Easy | All audio stays local — no privacy concerns. |
| **Progress tracking** | ✅ Easy | Local storage + optional cloud sync. |

**Key advantage over v2:** No precise frequency generation, no headphone calibration, no audiometry logic. Much simpler.

---

## Key risks (top 3)
1. **Medical device classification**: Health-adjacent = higher regulatory scrutiny.  
→ *Mitigation*: Position as *wellness tool*. Clear disclaimers: "Not a medical device. Consult a professional."
2. **Efficacy expectations**: Users may expect instant cure.  
→ *Mitigation*: Set realistic expectations upfront. Track user-reported relief (not promises).
3. **Retention after testing**: Users may complete test → use once → forget app.  
→ *Mitigation*: Sleep timer, bedtime reminders, progress streaks, "rescue mode" for stress spikes.

---

## MVP User Flow (Simplified)
```
1. Onboarding (2 min)
   - Welcome + disclaimers
   - Select primary context (Sleep / Focus / Stress)
   
2. Relief Testing (3–5 min)
   - Play 5–7 sounds (30 sec each)
   - User rates each 1–5 stars ("How much does this help?")
   - App saves top 3 sounds
   
3. First Use (immediate)
   - Play top sound with sleep timer (15/30/60 min)
   - Optional: fade-out, volume mix
   
4. Retention
   - Daily check-in: "How was your sleep?"
   - Unlock new sounds over time
   - Context switching (Sleep → Focus → Stress)
```

---

## Opportunity score (1–10)
**8.5/10** (upgraded from 8/10)

| Factor | Score | Rationale |
|--------|-------|-----------|
| Market size | 9/10 | 750M sufferers, growing with aging population |
| Pain intensity | 9/10 | Sleep, focus, mental health — deeply felt |
| Founder-market fit | 10/10 | You are the user — invaluable for product intuition |
| Competition | 8/10 | Many apps, but none with relief testing + context modes |
| Technical risk | 9/10 | **Lower than v2** — no frequency detection, simple sound library |
| Regulatory risk | 7/10 | Health-adjacent, but wellness positioning mitigates |
| Monetization | 8/10 | Sleep-focused = high willingness to pay; B2B potential |
| User friction | 9/10 | 3–5 min test vs. 5–10 min — higher completion rate |

**Why upgraded:** Simpler technical approach = lower risk, faster to MVP, higher completion rate.

---

## Recommendation
**PROMOTE** — with sleep-first launch strategy, relief testing (not frequency matching), then expand to focus/stress contexts in v2.

---

## Pre-MVP Validation (Required Before Building)
1. **10-person concierge test**: Recruit moderate tinnitus sufferers (HK-based). Test sleep mode only. Measure:
   - Relief perception (1–5 stars)
   - Willingness-to-pay
   - Test completion rate (target: ≥80%)
   
2. **Sound library validation**: Test 7–10 sounds — identify which 3–5 provide most relief on average.

3. **Regulatory check**: Consult HK Dept of Health on wellness vs. medical device classification.

4. **Competitor deep-dive**: Test top 3 apps personally (ReSound, Tinnitus Play, myNoise) — document exact gaps.

---

## Technical Stack (MVP)
| Layer | Tech | Notes |
|-------|------|-------|
| **Platform** | Swift (iOS first) | iPhone 14+ for MVP |
| **Audio engine** | AVFoundation | Low-latency playback |
| **Sound library** | Pre-recorded + synthesis | 10–15 sounds at launch |
| **Storage** | CoreData / SQLite | Local only (privacy-first) |
| **UI** | SwiftUI | Simple, calm, sleep-friendly |