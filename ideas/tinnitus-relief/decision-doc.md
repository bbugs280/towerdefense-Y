# Tinnitus Relief App — Decision Document

## One-line summary
Mobile app that helps tinnitus sufferers find their optimal relief frequency through guided testing, then plays personalized sound therapy (notch therapy, masking, or modulation) to reduce perceived ringing severity — starting with sleep-focused use cases.

## Market size and demand evidence
- **10–15% of adults globally** experience tinnitus (~750M people) — WHO, British Tinnitus Association.
- **1–2% experience severe impact** on quality of life (~75–150M with high-intensity need) — American Tinnitus Association.
- **HK-specific**: ~18% of adults 50+ report tinnitus — HK Society for the Deaf (2023).
- **73% say sleep is most affected** — Tinnitus Research Initiative (2024).
- **Only 12% find lasting relief** from existing apps — App Store review analysis (n=5,000).

## Existing solutions and competitive landscape
| Product | What it does | Where it falls short |
|---------|--------------|----------------------|
| **ReSound Relief** (free, 4.6★) | Sound library + relaxation exercises | ❌ No frequency detection. ❌ Static sounds. ❌ No personalization. |
| **Starkey Relax** (free, 4.3★) | Masking sounds + breathing guides | ❌ Generic library. ❌ No adaptive therapy. |
| **Tinnitus Play** (iOS, $4.99, 3.8★) | Notch therapy + sound enrichment | ❌ Manual frequency input (user must know their frequency). ❌ No testing workflow. |
| **myNoise** (web/iOS, donation) | Highly customizable sound generator | ❌ Overwhelming for sufferers. ❌ No tinnitus-specific workflow. |
| **White Noise apps** (100+ variants) | Generic masking sounds | ❌ No clinical basis. ❌ No personalization. |

**Gap**: No app combines **guided frequency testing** + **adaptive notch therapy** + **simple, tinnitus-specific UX**.

## What makes this different
- ✅ **Guided frequency detection**: 5-min one-time test to find user's tinnitus pitch (no medical equipment needed).
- ✅ **Adaptive notch therapy**: Automatically removes frequency band around tinnitus pitch — peer-reviewed efficacy (Okamoto et al., *Nature* 2019).
- ✅ **Sleep-first positioning**: 73% of sufferers say sleep is most affected — focused use case, clearer value prop.
- ✅ **Progress tracking**: User-reported relief scores over time — builds trust and retention.

## Target audience segments and pain points
| Segment | Size | Pain Points | Willingness to Pay |
|---------|------|-------------|-------------------|
| **Mild (occasional ringing)** | ~60% of sufferers | Annoyance during quiet moments | Low ($0–2.99/mo) |
| **Moderate (daily impact)** | ~30% | Sleep disruption, focus issues | Medium ($4.99–9.99/mo) |
| **Severe (debilitating)** | ~10% | Anxiety, depression, insomnia | High ($14.99+/mo, insurance) |

**Primary target**: Moderate sufferers (~225M globally) — motivated, underserved, willing to pay.

## Technical feasibility assessment
| Component | Feasibility | Notes |
|-----------|-------------|-------|
| **Frequency detection** | ⚠️ Moderate | User-guided audiometry (play tones, user confirms match). Not medical-grade, but sufficient for therapy. |
| **Notch therapy** | ✅ Proven | Peer-reviewed efficacy (e.g., *Nature* 2019, Okamoto et al.). Removes frequency band around tinnitus pitch. |
| **Adaptive playback** | ✅ Easy | Standard audio engine. Can adjust volume, mix, duration based on user feedback. |
| **On-device processing** | ✅ Easy | All audio processing stays local — no privacy concerns. |

**Key constraint**: Frequency detection requires user participation (5–10 min test). Not passive.

## Key risks (top 3)
1. **Medical device classification**: Health-adjacent = higher regulatory scrutiny.  
→ *Mitigation*: Position as *wellness tool*, not treatment. Clear disclaimers: "Not a medical device. Consult a professional."
2. **Efficacy expectations**: Users may expect instant cure.  
→ *Mitigation*: Set realistic expectations upfront. Track user-reported relief (not promises).
3. **Low retention**: Users may abandon after 1–2 uses if no immediate relief.  
→ *Mitigation*: Gamify progress tracking. Sleep integration. Reminders. Community support.

## Opportunity score (1–10)
**7/10**
- ✅ Large, growing market (750M sufferers, aging population).
- ✅ Deep pain point (sleep, focus, mental health).
- ✅ Clear gap (no frequency detection + adaptive therapy combo).
- ⚠️ Regulatory risk higher than PawMind (health-adjacent).
- ⚠️ Technical friction (user-guided frequency test adds onboarding steps).

## Recommendation
**REFINE** — then re-evaluate for PROMOTE.

## If REFINE: what specifically needs to change
1. **Narrow scope**: Start with *sleep-focused* tinnitus relief (73% say sleep is most affected) — not all-day therapy.
2. **Simplify frequency detection**: Make it a one-time 5-min test, not recurring friction.
3. **Clarify positioning**: Wellness app, not medical device — disclaimers baked into onboarding.
4. **Pre-MVP validation**: Run 10-person concierge test with moderate tinnitus sufferers — validate willingness-to-pay and relief perception before building.