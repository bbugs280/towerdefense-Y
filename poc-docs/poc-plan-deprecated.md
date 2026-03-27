# PawMind — POC Plan (Deprecated: Flutter On-Device)

**Status:** ❌ DEPRECATED (2026-03-27)  
**Replaced By:** `poc-plan-v2-ios-hybrid.md` (iOS Native + Hybrid Architecture)

**Original Goal:** Validate on-device inference feasibility (latency, TTS quality, voice variety, battery, app size) by extending existing Flutter app.

**Original Duration:** 1–2 weeks (parallel tracks)

**Why Deprecated:**
- Pivot from Flutter → iOS Native (faster development, better performance)
- Pivot from On-Device → Hybrid Architecture (lower latency, smaller app, better voice quality)
- DashScope API costs verified at HK$0.0051/thought (negligible, 97.7% margin)

**See:** `poc-plan-v2-ios-hybrid.md` for current POC plan.

---

## Historical Context

This plan was created when we assumed:
- On-device LLM (Phi-3) was necessary for privacy/cost
- Flutter was needed for cross-platform launch
- API costs would be high (HK$0.06-0.12/thought estimated)

**Updated Understanding (2026-03-27):**
- Hybrid architecture (vision on-device, reasoning+TTS via API) is superior
- iOS Native is faster to build than Flutter + platform channels
- API costs are 91.5% lower than estimated (HK$0.0051/thought verified)

**Preserved for:** Historical reference, lessons learned.

---

## Original Plan Summary (For Reference)

### Architecture (Deprecated)
```
Flutter App → Platform Channel → iOS Native (MLX + Phi-3 + Piper)
```

### Tests (Original)
1. Latency (on-device LLM)
2. TTS Quality (Piper/Coqui)
3. Voice Variety (LoRA adapters)
4. Battery/Thermal (continuous inference)
5. App Size (2.3 GB models)

### Why It Changed
| Factor | On-Device | Hybrid | Winner |
|--------|-----------|--------|--------|
| App Size | 1.5–2.3 GB | <50 MB | Hybrid |
| Latency | 4–6 sec | 1–2 sec | Hybrid |
| Voice Quality | Good | Excellent (Cantonese) | Hybrid |
| Dev Time | 2–3 weeks | 1 week | Hybrid |
| Cost | HK$0.00 | HK$0.0051/thought | Hybrid (negligible) |

---

## Current Plan

**See:** `poc-plan-v2-ios-hybrid.md` for:
- iOS Native + Hybrid architecture
- 1-week POC timeline
- 5 tests (latency, TTS quality, voice variety, API cost, offline fallback)
- Go/No-Go decision matrix

---

**Document Status:** Archived for historical reference  
**Active Plan:** `poc-plan-v2-ios-hybrid.md`
