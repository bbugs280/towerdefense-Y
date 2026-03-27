# PawMind — Planning Update (iOS Native + Hybrid Pivot)

**Date:** 2026-03-27  
**Previous Architecture:** Server-Based (Flutter + FastAPI + WebSocket)  
**New Architecture:** iOS Native + Hybrid (Vision on-device, API direct)  
**Status:** POC Phase (1 week) → MVP Phase (4 weeks)

---

## 📊 Current Repo State (GitHub: bbugs280/paw-mind)

### What Exists

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| **Server** | ✅ Active | `server/` | FastAPI WebSocket server (Python) |
| **Mobile (Flutter)** | ⚠️ Local only | `mobile_flutter/` | Lib code NOT in repo (tests only) |
| **Mobile (Expo)** | ⚠️ Legacy | `mobile/` | TypeScript, deprecated |
| **iOS Native** | ❌ Not started | — | POC scaffold needed |
| **Docs** | ⚠️ Outdated | `*.md` | Describe server-based arch |

### What's Missing

| Needed For | Missing Files | Priority |
|------------|---------------|----------|
| iOS POC | `ios-poc/PawMind/` (Xcode project) | 🔴 CRITICAL |
| iOS POC | `DashScopeService.swift` | 🔴 CRITICAL |
| iOS POC | `CameraView.swift` | 🔴 CRITICAL |
| iOS POC | `DogThought.swift` | 🟡 MEDIUM |
| iOS POC | `CostTracker.swift` | 🟡 MEDIUM |
| Docs | Updated README.md | 🟡 MEDIUM |
| Docs | iOS setup guide | 🟡 MEDIUM |

---

## 🎯 Architecture Decision: Why Hybrid?

### Previous Plan (Server-Based)

```
Flutter App → WebSocket → FastAPI Server → DashScope API
```

**Problems:**
- Server infrastructure required (deployment, scaling, cost)
- Additional latency (app → server → API → server → app)
- Single point of failure (server down = app broken)
- Flutter lib code not in repo (local-only)

### New Plan (Hybrid)

```
iOS App → On-device Vision (MediaPipe)
     → Direct API (DashScope: Qwen-VL-Plus + CosyVoice)
```

**Benefits:**
- ✅ No server required (direct API from app)
- ✅ Lower latency (1.5-2.5s vs. 2-3s)
- ✅ Smaller app (<50 MB vs. 1.5-2.3 GB on-device)
- ✅ Better voice quality (CosyVoice API vs. Piper/Coqui bundled)
- ✅ Offline fallback (native TTS)
- ✅ Faster development (Swift only, no Python + Dart)

**Trade-offs:**
- ⚠️ API cost (HK$0.0051/thought — negligible, 97.7% margin)
- ⚠️ iOS-only initially (Android in Phase 2)

---

## 📋 Updated Development Plan

### Phase 0: POC (Week 1) — CURRENT

| Day | Task | Deliverable | Owner |
|-----|------|-------------|-------|
| **Mon** | Scaffold iOS app | `ios-poc/PawMind/` + basic files | Builder |
| **Tue** | Test 1: Latency | `poc-results/latency.md` | You + Builder |
| **Wed** | Test 2: TTS Quality | `poc-results/tts-quality.md` | You + Wayne |
| **Thu** | Test 3-4: Voice + Cost | `poc-results/*.md` | You + Builder |
| **Fri** | Test 5: Offline + Decision | `poc-results/decision.md` | You + Wayne + Builder |

**Success Criteria:** ≥0.8 weighted score → Proceed to MVP

### Phase 1: MVP (Weeks 2-5)

| Week | Focus | Deliverable |
|------|-------|-------------|
| **Week 2** | Core features | Camera, vision, TTS, 3 character voices |
| **Week 3** | UX polish | Onboarding, settings, multi-dog profiles |
| **Week 4** | Testing | TestFlight beta, bug fixes |
| **Week 5** | Launch prep | App Store submission, marketing assets |

**Target Launch:** Early May 2026 (6 weeks from POC start)

### Phase 2: Android + Advanced (Weeks 6-12)

| Feature | Platform | ETA |
|---------|----------|-----|
| Android app | Kotlin/SwiftUI Multiplatform | Week 8-10 |
| Multi-dog support | iOS + Android | Week 7 |
| Social sharing | iOS + Android | Week 8 |
| Journal/mood timeline | iOS + Android | Week 9 |
| On-device migration (optional) | iOS | Week 10-12 |

---

## 💰 Updated Business Case

### Unit Economics (Verified via DashScope API)

| Component | Cost (HKD) | Notes |
|-----------|------------|-------|
| Vision (on-device) | HK$0.00 | MediaPipe Holistic |
| Reasoning (Qwen-VL-Plus) | HK$0.000756 | 500 in + 150 out tokens |
| TTS (CosyVoice-Flash) | HK$0.004320 | 50 characters |
| **Total per thought** | **HK$0.0051** | |

### Per User Per Month (100 thoughts)

| TTS Tier | Cost | Recommendation |
|----------|------|----------------|
| **Flash** | HK$0.51 | ✅ Start here for MVP |
| **Plus** | HK$0.89 | Upgrade if quality needs improvement |

### Business Impact

| Metric | Value |
|--------|-------|
| Break-even users | ~50 (tiered subscription) |
| 18-month profit (base case) | ~HK$586K (Flash) / ~HK$581K (Plus) |
| Margin | 97.7% (Flash) / 96.3% (Plus) |
| Failure case (5% conversion) | ~HK$150K profit (still profitable!) |

**Conclusion:** API cost is negligible. TTS tier choice is a **product quality decision**, not a cost decision.

---

## 📁 Repo Reorganization Plan

### After POC Completes (Week 2)

```bash
# Tag current state
git tag flutter-archive    # Flutter code (local-only, for reference)
git tag server-archive     # Server code (not needed for hybrid)

# Create new structure
ios-poc/          # POC code (Week 1)
ios-mvp/          # MVP code (Weeks 2-5)
docs/             # Updated documentation
mobile/           # Archive (Expo, deprecated)
mobile_flutter/   # Archive (Flutter, deprecated)
server/           # Archive (FastAPI, not needed)
```

### README.md Update

**New structure:**
```markdown
# 🐾 Paw Mind — Dog Mind Reader

**Platform:** iOS Native (iOS 17.4+)  
**Architecture:** Hybrid (Vision on-device, API for Reasoning + TTS)  
**Status:** POC Phase (Week 1 of 6)

## Quick Start

### POC (Week 1)
1. Clone repo
2. Open `ios-poc/PawMind.xcodeproj` in Xcode
3. Add DashScope API key to `.env`
4. Build & run on iPhone 13/14

### MVP (Weeks 2-5)
[Coming after POC]

## Architecture

[Diagram: iOS App → MediaPipe + DashScope API]

## Business Case

- Cost per thought: HK$0.0051
- Break-even: ~50 users
- 18-month profit: ~HK$586K
- Margin: 97.7%

See: `projects/pawmind/planning/business-case-revised.md`
```

---

## 🚀 Immediate Next Steps

### For You (Today)

1. **Review this plan** — Confirm it makes sense
2. **Create `ios-poc/` directory** in repo
3. **Say "Scaffold POC"** — I'll create all Swift files
4. **Copy files to repo** — Commit and push
5. **Open in Xcode** — Build and test

### For Me (Builder)

Waiting for your command:
- **"Scaffold POC"** → I'll create all iOS files (App.swift, DashScopeService.swift, etc.)
- **"Review first"** → I'll wait while you read the docs
- **"Questions"** → I'll clarify anything unclear

---

## 📞 Key Files to Reference

| File | Purpose | Location |
|------|---------|----------|
| **POC Plan** | Test scripts, timeline | `ideas/pawmind/poc-plan-v2-ios-hybrid.md` |
| **POC Scaffold** | File structure guide | `ideas/pawmind/poc-scaffold-v2-ios-hybrid.md` |
| **Execution Guide** | VSCode Copilot prompts | `ideas/pawmind/POC-EXECUTION-GUIDE.md` |
| **Gap Analysis** | Current vs. target state | `projects/pawmind/GAP-ANALYSIS.md` |
| **Business Case** | Unit economics, projections | `projects/pawmind/planning/business-case-revised.md` |

---

## ✅ Success Criteria

POC is complete when:
- [ ] iOS app builds and runs on iPhone 13/14
- [ ] Camera captures frames successfully
- [ ] DashScope API calls work (vision + TTS)
- [ ] Latency ≤2.5s (WiFi), ≤3s (5G)
- [ ] TTS quality ≥4/5 (blind test, n=10)
- [ ] Offline fallback works (native TTS)
- [ ] Cost tracking matches HK$0.0051/thought estimate
- [ ] Go/No-Go decision documented

---

**Ready to scaffold?** Say **"Scaffold POC"** and I'll create all the files. 🐾
