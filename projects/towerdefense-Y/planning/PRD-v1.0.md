# Tower Defense Y — Product Requirements Document

**File:** PRD-v1.0.md
**Version:** 1.0
**Created:** 2026-01-06
**Status:** DRAFT
**Project:** Tower Defense Y
**Author:** Planner (AI Agent)

---

## Executive Summary

Tower Defense Y is a mobile co-op tower defense game where couples work together to beat levels as fast as possible. The unique twist: towers can merge to create stronger versions, adding strategic depth and natural co-op roles.

**Target:** iOS + Android
**Timeline:** MVP in 8-10 weeks
**Team:** 1-2 developers (Wayne + Vincent)

---

## Core Gameplay Loop

1. **Start Level** — Enemies spawn from entry points, move toward exit
2. **Place Towers** — Both players place basic towers on grid
3. **Merge Towers** — Combine 3 same-level towers → 1 higher-level tower
4. **Defend** — Towers auto-attack enemies; players optimize placement
5. **Win Condition** — Defeat all waves before timer expires (speed matters)
6. **Lose Condition** — Shared lives reach 0 (both lose together)

---

## Key Features (MVP Scope)

### 1. Tower System
- **5 Tower Types** (MVP):
  - Arrow Tower (basic damage)
  - Cannon Tower (splash damage)
  - Ice Tower (slow effect)
  - Lightning Tower (chain damage)
  - Heal Tower (support)
  
- **5 Merge Tiers** per tower type:
  - Tier 1 (base) → Tier 2 → Tier 3 → Tier 4 → Tier 5 (ultimate)
  - Visual upgrade at each tier
  - Damage/scaling: +50% per tier

- **Merge Rules:**
  - 3 identical towers (same type + same tier) = 1 merged tower
  - Merge can happen anywhere on grid (no adjacency required)
  - Merged tower appears at location of first selected tower

### 2. Co-op Mechanics
- **Shared Lives:** Start with 10 lives (both players share)
- **Simultaneous Play:** Both players can place/merge at same time
- **Role Flexibility:** 
  - Option A: Both build + merge equally
  - Option B: One focuses on building basics, other on merging
- **Speed Bonus:** Faster clears = higher score, bonus currency

### 3. Level Design (MVP)
- **5 Levels** with increasing difficulty
- **3 Enemy Types:**
  - Basic (slow, low HP)
  - Armored (slow, high HP)
  - Fast (quick, low HP)
- **Boss Wave** at end of each level

### 4. Progression
- **Currency:** Earn coins from completing levels
- **Unlockables:**
  - New tower types (beyond MVP 5)
  - Tower skins (cosmetic)
  - New levels
- **Leaderboards:** Fastest clear times per level

### 5. Multiplayer
- **Local Co-op:** Same device (pass-and-play or split controls)
- **Online Co-op:** Remote play via internet (Firebase backend)
- **Matchmaking:** Quick join or invite friends

---

## User Stories

### As a player, I want to:
1. Place towers strategically to stop enemies
2. Merge 3 towers to create a stronger one
3. Play with my spouse on the same device or remotely
4. Beat levels as fast as possible for high scores
5. See my towers visually upgrade when merged
6. Unlock new tower types as I progress
7. Compete on leaderboards for fastest clears

### As a couple, we want to:
1. Coordinate our tower placement strategy
2. Divide roles (one builds, one merges) if we choose
3. Share victory or defeat together
4. Play quick 10-15 minute sessions
5. Improve our time together on replay

---

## Acceptance Criteria (MVP)

### Tower Mechanics
- [ ] Can place 5 tower types on grid
- [ ] Can select 3 identical towers and merge them
- [ ] Merged tower shows visual upgrade + stat increase
- [ ] Merge animation is smooth (< 0.5 seconds)
- [ ] Tower stats scale correctly per tier (documented in design doc)

### Co-op
- [ ] Two players can play simultaneously on same device
- [ ] Two players can play remotely (online)
- [ ] Lives are shared (both see same life counter)
- [ ] Both players can place/merge at same time without conflicts

### Levels
- [ ] 5 levels with distinct layouts
- [ ] 3 enemy types with different behaviors
- [ ] Boss wave at end of each level
- [ ] Timer tracks completion time
- [ ] Win/lose conditions work correctly

### Progression
- [ ] Earn coins after winning levels
- [ ] Coins can unlock new tower types
- [ ] Leaderboards show fastest times
- [ ] Progress saves between sessions

### Performance
- [ ] 60 FPS on mid-range devices (iPhone 11+, equivalent Android)
- [ ] Match starts in < 5 seconds
- [ ] No desync in co-op play

---

## Technical Requirements

### Platform
- **Primary:** iOS 14+, Android 10+
- **Secondary:** Consider iPad/tablet optimization

### Backend
- **Authentication:** Firebase Auth (anonymous + optional accounts)
- **Multiplayer:** Firebase Realtime Database or Photon
- **Leaderboards:** Firebase or PlayFab
- **Analytics:** Firebase Analytics

### Engine Options (Builder will recommend)
- **Option A: Unity**
  - Pros: Best TD assets, proven multiplayer, cross-platform
  - Cons: Larger build size, heavier engine
  
- **Option B: Flutter + Flame Engine**
  - Pros: Lightweight, single codebase, fast iteration
  - Cons: Less TD-specific assets, newer engine

**Decision:** Builder to evaluate and recommend by [date]

---

## Monetization (TBD)

**Recommended Model:** Hybrid F2P
- **Free:** Base game with 5 levels, 5 towers
- **IAP:** 
  - Unlock tower skins ($0.99-$2.99)
  - Extra levels ($1.99 per pack)
  - No pay-to-win (all towers earnable through play)
- **Optional:** Remove ads ($2.99 one-time)

**Final decision:** Owner to confirm after MVP testing

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Co-op desync ruins experience | High | Extensive testing, rollback system |
| Merge mechanic feels clunky | High | Prototype early, iterate on UX |
| Levels too easy/hard | Medium | Playtest with 10+ couples, adjust |
| Monetization feels predatory | Medium | Keep cosmetic-only, no pay-to-win |
| Performance issues on older devices | Medium | Target iPhone 11+ as minimum |

---

## Timeline (MVP)

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| **Week 1-2:** Design | 2 weeks | Tech stack decision, tower stats, level layouts |
| **Week 3-6:** Core Dev | 4 weeks | Tower system, merge mechanic, 1 playable level |
| **Week 7-8:** Co-op + Content | 2 weeks | Multiplayer, 4 more levels, progression |
| **Week 9-10:** Polish + Test | 2 weeks | Bug fixes, playtesting, performance |

**MVP Launch Target:** Week 10 (soft launch with 20-30 testers)

---

## Success Metrics (Post-Launch)

- **Retention:** 40% D1, 20% D7, 10% D30
- **Session Length:** 10-15 minutes average
- **Co-op Rate:** 70%+ of sessions are 2-player
- **Rating:** 4.5+ stars on App Store / Play Store
- **Revenue:** $2-5 ARPPU (if F2P model)

---

## Open Questions

1. **Engine:** Unity vs. Flutter? (Builder to recommend)
2. **Art Style:** Pixel art, low-poly 3D, or 2D cartoon?
3. **Audio:** Original music or royalty-free assets?
4. **Online Co-op:** Required for MVP or can launch with local-only first?
5. **Pricing:** F2P, premium ($4.99), or hybrid?

---

## Next Steps

1. **Builder:** Create technical design doc (engine recommendation, architecture)
2. **Builder:** Set up GitHub repo, create issues from this PRD
3. **Owner:** Approve PRD, confirm engine choice, art style
4. **Builder:** Start core tower system prototype

---

**Planner signing off.** Ready to hand off to Builder for technical design.
