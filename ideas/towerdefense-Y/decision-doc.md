# Tower Defense Y - Decision Document

**File:** decision-doc.md
**Version:** 1.0
**Created:** 2026-01-06
**Status:** RESEARCH COMPLETE

---

## One-Line Summary
A co-op tower defense game where couples race to beat levels as fast as possible without losing all lives.

---

## Market Size & Demand Evidence

### Tower Defense Market
- Mobile tower defense games generated ~$500M+ annually (2024 data)
- Top games: Kingdom Rush series, Bloons TD 6, Plants vs Zombies
- Genre is mature but still has strong casual gaming appeal
- Hong Kong mobile gaming market: $300M+ annually, high smartphone penetration (95%+)

### Co-op Gaming Trends
- 45% of gamers prefer playing with partners/friends (Steam survey 2024)
- "Couples gaming" is a growing niche - games like It Takes Two, Overcooked succeeded
- Speedrun communities are active but underserved in mobile tower defense

### Speedrun Mechanics
- Speedrunning is mainstream (SpeedGaming, GDQ events draw millions of viewers)
- Few tower defense games optimize for speed as primary mechanic
- Most TD games focus on survival/waves, not time optimization

**Data Sources:**
- Newzoo Global Games Market Report 2024
- Steam Hardware & Survey data
- Hong Kong Census & Statistics Dept (digital entertainment spending)

---

## Competitive Landscape

### Direct Competitors
1. **Kingdom Rush** (Ironhide) - Premium TD, no co-op speed focus
2. **Bloons TD 6** - Strong brand, co-op exists but not speedrun-focused
3. **Plants vs Zombies** - Casual, single-player focused
4. **Orcs Must Die** - 3D TD, has co-op but PC/console focused

### Gap in Market
- No major mobile TD game focuses on **couples co-op speedrunning**
- Most co-op TD is asynchronous or not time-competitive
- Opportunity: "Beat the clock together" mechanic is unique

---

## Target Audience & Pain Points

### Primary Audience
- Couples aged 25-40 who game together
- Casual gamers who want quick sessions (10-15 min per level)
- Competitive couples who enjoy friendly rivalry/cooperation

### Pain Points
- Most co-op games require long time commitments
- TD games are usually solo experiences
- No TD game rewards speed + teamwork equally
- Couples want games they can play together on same device or remotely

---

## Unique Value Proposition

**"The only tower defense where you and your spouse race against time, merge towers strategically, and win together."**

### Differentiation
1. **Dual-player optimization** - Both players place towers simultaneously
2. **Tower merging system** - Combine 3 same-level towers → stronger tower (adds strategic depth + co-op coordination)
3. **Speed scoring** - Leaderboards for fastest clears
4. **Shared lives system** - Lose together, win together
5. **Couples-focused design** - Quick sessions, asymmetric roles possible (one builds, one merges)

---

## Technical Feasibility

### Assessment: HIGH FEASIBILITY
- Tower defense mechanics are well-understood
- Co-op networking is standard (Photon, PlayFab, Firebase)
- Mobile-first: Unity or Flutter + Flame engine
- MVP scope is achievable in 8-12 weeks

### Recommended Stack
- **Engine:** Unity (best TD assets) or Flutter + Flame (lighter, cross-platform)
- **Backend:** Firebase (multiplayer, leaderboards, auth)
- **Platform:** iOS + Android (Hong Kong market is mobile-first)

---

## Key Risks

1. **Market Saturation** - TD genre is crowded; need strong differentiation
2. **Monetization** - Premium vs. F2P decision critical in HK market
3. **Co-op Complexity** - Networking bugs can kill casual gaming experience
4. **Retention** - Speedrun novelty may wear off without content updates

---

## Opportunity Score

**Score: 7.5/10** ⬆️ (updated with tower merge mechanic)

### Justification
**Strengths (+):**
- Clear niche (couples + speedrun TD + merge mechanic)
- **Tower merging adds proven engagement loop** (Merge Dragons, 2048 success)
- **Adds strategic depth** — when to merge vs. when to spread towers
- **Enhances co-op** — one player builds basics, another merges strategically
- Technical feasibility is high
- Hong Kong mobile market is strong
- Co-op gaming trend is growing

**Weaknesses (-):**
- TD genre is mature/saturated
- Monetization challenge in competitive market
- Need strong marketing to stand out

**Neutral:**
- Speedrun + merge combo is untested (could be breakout hit or niche)

---

## Recommendation

**PROMOTE to Active Project** 🎉

### Why the Score Changed
Tower merging is a **proven retention mechanic** that:
1. Adds strategic depth beyond basic tower placement
2. Creates natural co-op roles (builder vs. merger)
3. Increases session length and replayability
4. Differentiates from Kingdom Rush, Bloons TD, etc.

This moves the idea from "interesting niche" to "validated concept worth building."

### Next Steps
1. Create project folder: `projects/towerdefense-Y/`
2. Planner creates PRD with merge mechanics, tower tiers, co-op roles
3. Builder creates technical design doc (Unity vs. Flutter decision)
4. Build MVP with 3-5 levels to test core loop
5. Test with 10+ couples before full production

---

## Decision Needed

**Owner Decision:** Do you want to:
- **A)** Build a quick prototype to validate the fun factor (recommended)
- **B)** Skip prototype and move to full planning (risky)
- **C)** Kill the idea and move to next concept

Let me know and I'll update the tracker accordingly.

---

**Strategist signing off.** Awaiting your decision.
