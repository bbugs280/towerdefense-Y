# Tower Defense Y — Technical Design Document

**File:** tech-design-v1.0.md
**Version:** 1.0
**Created:** 2026-01-06
**Status:** DRAFT — Awaiting Owner Decision
**Project:** Tower Defense Y
**Author:** Builder (AI Agent)

---

## Executive Summary

**Recommendation: Flutter + Flame Engine**

For Tower Defense Y (2D cartoon, co-op, 8-10 week MVP), Flutter offers:
- Faster iteration for 2D games
- Single codebase for iOS + Android
- Easier UI for co-op controls
- Smaller build size
- Wayne's existing Flutter experience (if any)

**Unity is better if:** You plan 3D expansion, need asset store TD templates, or want console ports later.

---

## Engine Comparison: Unity vs. Flutter + Flame

### 1. Development Effort

| Task | Unity | Flutter + Flame | Winner |
|------|-------|-----------------|--------|
| **Setup Time** | 2-3 days (Unity Hub, licenses, platform setup) | 1 day (Flutter SDK + packages) | Flutter |
| **Learning Curve** | Medium (C#, Unity editor, component system) | Low-Medium (Dart, Flutter widgets) | Flutter |
| **2D Sprite Rendering** | Excellent (SpriteRenderer, Animation system) | Excellent (Flame SpriteComponent) | Tie |
| **UI System** | Unity UI (Canvas, anchors, can be clunky) | Flutter UI (declarative, fast, beautiful) | Flutter |
| **Touch/Input Handling** | Good (Input System package) | Excellent (native Flutter gestures) | Flutter |
| **Animation (2D)** | Excellent (Animator, timeline, blend trees) | Good (Flame animations, simpler) | Unity |
| **Particle Effects** | Excellent (built-in particle system) | Medium (need custom or package) | Unity |
| **Audio** | Good (AudioSource, mixer) | Good (audioplayers package) | Tie |

**Effort Winner: Flutter** (20-30% faster for 2D mobile games)

---

### 2. Multiplayer/Co-op Implementation

| Feature | Unity | Flutter + Flame | Notes |
|---------|-------|-----------------|-------|
| **Local Co-op** | Easy (multiple input sources) | Easy (Flutter gesture detectors) | Tie |
| **Online Co-op** | Photon, Mirror, Netcode (mature) | Firebase Realtime DB (simple) | Unity more mature |
| **State Sync** | Built-in networking primitives | Manual (but simpler for TD) | Flutter simpler for TD |
| **Latency Handling** | Advanced (interpolation, prediction) | Basic (TD is turn-based enough) | Flutter sufficient |
| **Backend Integration** | PlayFab, Firebase, custom | Firebase (native Dart SDK) | Flutter easier |

**Multiplayer Winner: Tie** (Unity more powerful, Flutter simpler for TD needs)

---

### 3. Asset Pipeline (2D Cartoon)

| Task | Unity | Flutter + Flame | Notes |
|------|-------|-----------------|-------|
| **Sprite Import** | Drag-drop, auto-slice | Manual (assets folder) | Unity easier |
| **Sprite Atlas** | Automatic (Atlas Packer) | Manual (package or custom) | Unity easier |
| **Animation Workflow** | Animator window, timeline | Code-based or Aseprite import | Unity more visual |
| **Asset Store** | 10,000+ TD assets, templates | Limited (mostly code packages) | Unity wins |
| **Custom Art Pipeline** | Good (Prefab system) | Good (Flutter widgets) | Tie |

**Asset Winner: Unity** (if using asset store templates)

**But:** If creating custom 2D cartoon art (Aseprite, Photoshop), both handle sprites equally well.

---

### 4. Performance

| Metric | Unity | Flutter + Flame | Notes |
|--------|-------|-----------------|-------|
| **Build Size (empty)** | ~100-150 MB | ~20-30 MB | Flutter much smaller |
| **Startup Time** | 3-5 seconds | 1-2 seconds | Flutter faster |
| **FPS (2D sprites)** | 60+ FPS (excellent) | 60+ FPS (excellent) | Tie for 2D |
| **Memory Usage** | Higher (Unity runtime) | Lower (Flutter engine) | Flutter better |
| **Old Device Support** | iPhone 6s+, Android 6+ | iPhone 6s+, Android 8+ | Similar |

**Performance Winner: Flutter** (smaller, faster startup)

---

### 5. Development Velocity (MVP Focus)

| Factor | Unity | Flutter + Flame |
|--------|-------|-----------------|
| **Hot Reload** | Yes (but slower, sometimes buggy) | Yes (instant, reliable) |
| **UI Iteration** | Slow (enter play mode, test) | Fast (hot reload UI instantly) |
| **Debugging** | Good (Unity debugger, logs) | Excellent (Flutter DevTools) |
| **Testing** | Unity Test Framework | Flutter test + integration_test |
| **CI/CD** | Unity Cloud Build, custom | Codemagic, GitHub Actions |
| **Platform Build** | Complex (Xcode + Gradle management) | Simpler (Flutter build commands) |

**Velocity Winner: Flutter** (faster iteration for MVP)

---

### 6. Long-Term Considerations

| Goal | Unity | Flutter + Flame |
|------|-------|-----------------|
| **3D Expansion** | ✅ Excellent (3D native) | ❌ Not recommended |
| **Console Ports** | ✅ Switch, PS, Xbox support | ❌ No console support |
| **PC/Mac Desktop** | ✅ Excellent | ✅ Good (Flutter desktop) |
| **Web Build** | ✅ Unity WebGL (heavy) | ✅ Flutter Web (lighter) |
| **Asset Store Reuse** | ✅ Huge ecosystem | ❌ Limited |
| **Hiring Developers** | ✅ Many Unity devs | ⚠️ Fewer Flutter game devs |
| **Monetization SDKs** | ✅ All ad/IAP SDKs | ✅ Most ad/IAP SDKs |

**Long-Term Winner: Unity** (if planning beyond mobile 2D)

---

## Recommendation

### Choose **Flutter + Flame** if:
- ✅ You want MVP in 8-10 weeks (faster iteration)
- ✅ 2D cartoon style is final (no 3D plans)
- ✅ Mobile-only (iOS + Android)
- ✅ Small team (1-2 developers)
- ✅ You value hot reload and fast UI iteration
- ✅ Smaller app size matters (download conversion)

### Choose **Unity** if:
- ✅ You plan 3D expansion or console ports
- ✅ You want to use asset store TD templates
- ✅ You need advanced particle effects
- ✅ You might hire Unity developers later
- ✅ You want visual animation editor (Animator)

---

## My Recommendation for Tower Defense Y

**Flutter + Flame Engine** 🏆

**Reasoning:**
1. **2D cartoon style** — No need for Unity's 3D power
2. **8-10 week MVP** — Flutter's hot reload saves 20-30% dev time
3. **Co-op UI** — Flutter's declarative UI is easier for dual-player controls
4. **Mobile-first** — No console/3D plans mentioned
5. **Small team** — Wayne + Vincent can iterate faster with Flutter
6. **Smaller build** — 30 MB vs. 150 MB = better download conversion

**Trade-offs:**
- Fewer TD assets available (but you're making custom 2D art anyway)
- Less mature game networking (but TD doesn't need frame-perfect sync)
- Harder to hire game devs later (but not a concern for MVP)

---

## Proposed Tech Stack (Flutter)

### Core
- **Engine:** Flutter 3.x + Flame 1.x
- **Language:** Dart
- **State Management:** Riverpod or Bloc
- **Backend:** Firebase (Auth, Realtime DB, Analytics)

### Packages
- `flame` — Game engine
- `flame_audio` — Audio playback
- `firebase_core`, `firebase_auth`, `firebase_database` — Backend
- `riverpod` — State management
- `shared_preferences` — Local save data
- `in_app_purchase` — IAP (if monetizing)
- `gameanalytics` or `firebase_analytics` — Analytics

### Art Pipeline
- **Tool:** Aseprite or Photoshop for 2D cartoon sprites
- **Format:** PNG sprite sheets
- **Animation:** Frame-based (Flame SpriteAnimation)

### Development Environment
- **IDE:** VS Code (Flutter extension) or Android Studio
- **Version Control:** GitHub
- **CI/CD:** GitHub Actions + Codemagic (optional)
- **Testing:** Flutter test + manual co-op testing

---

## Architecture Overview

```
lib/
├── main.dart                 # App entry point
├── game/
│   ├── tower_defense_game.dart   # Flame Game class
│   ├── components/
│   │   ├── tower.dart            # Tower component (base class)
│   │   ├── enemy.dart            # Enemy component
│   │   ├── projectile.dart       # Projectile component
│   │   ├── grid.dart             # Placement grid
│   │   └── ui/                   # Game UI components
│   ├── systems/
│   │   ├── wave_system.dart      # Enemy wave management
│   │   ├── merge_system.dart     # Tower merge logic
│   │   ├── pathfinding.dart      # Enemy pathfinding
│   │   └── collision.dart        # Collision detection
│   └── levels/
│       ├── level_1.dart
│       ├── level_2.dart
│       └── ...
├── services/
│   ├── firebase_service.dart     # Firebase integration
│   ├── multiplayer_service.dart  # Co-op sync
│   ├── leaderboard_service.dart  # Speedrun rankings
│   └── save_service.dart         # Local/cloud save
├── models/
│   ├── tower_model.dart          # Tower data structures
│   ├── enemy_model.dart          # Enemy data structures
│   ├── player_model.dart         # Player progress
│   └── game_state.dart           # Game state management
└── ui/
    ├── main_menu.dart            # Main menu screen
    ├── level_select.dart         # Level selection
    ├── co-op_lobby.dart          # Multiplayer lobby
    └── settings.dart             # Settings screen
```

---

## Tower Merge System Design

### Data Structure
```dart
enum TowerType { arrow, cannon, ice, lightning, heal }

class Tower {
  final TowerType type;
  final int tier; // 1-5
  final Vector2 position;
  final double damage;
  final double attackSpeed;
  final double range;
  
  Tower mergeWith(List<Tower> others) {
    // Requires 3 towers of same type + tier
    // Returns new tower with tier + 1
  }
}
```

### Merge Rules
- 3x Tier 1 → 1x Tier 2
- 3x Tier 2 → 1x Tier 3
- 3x Tier 3 → 1x Tier 4
- 3x Tier 4 → 1x Tier 5 (max)

### Visual Feedback
- Merge animation (0.3s glow + scale up)
- Particle burst on merge complete
- Number popup showing new tier

---

## Co-op Sync Design

### Local Co-op (Same Device)
- Two touch input streams
- Shared game state (no network needed)
- Split UI or shared UI (both can tap anywhere)

### Online Co-op (Remote)
```
Player 1 ←→ Firebase Realtime DB ←→ Player 2

Synced State:
- Tower positions + types + tiers
- Enemy positions + HP
- Shared lives counter
- Timer

Not Synced (local only):
- Camera shake
- Particle effects
- Audio (each player hears their own)
```

**Sync Frequency:** 10-20 updates/second (TD doesn't need 60 FPS sync)

---

## Development Phases

### Phase 1: Core Prototype (Week 1-3)
- [ ] Flutter + Flame setup
- [ ] Basic grid system
- [ ] 1 tower type (Arrow)
- [ ] 1 enemy type (Basic)
- [ ] Tower placement
- [ ] Tower shooting
- [ ] Enemy pathfinding
- [ ] Win/lose condition

### Phase 2: Merge Mechanic (Week 4-5)
- [ ] Tower selection UI
- [ ] Merge logic (3→1)
- [ ] Visual merge animation
- [ ] 5 tower tiers
- [ ] Stats scaling per tier
- [ ] All 5 tower types

### Phase 3: Co-op + Content (Week 6-8)
- [ ] Local co-op (2 players, 1 device)
- [ ] Online co-op (Firebase)
- [ ] 5 levels designed
- [ ] 3 enemy types
- [ ] Boss waves
- [ ] Progression system (coins, unlocks)

### Phase 4: Polish + Test (Week 9-10)
- [ ] UI polish (menus, HUD)
- [ ] Audio (SFX + music)
- [ ] Performance optimization
- [ ] Playtest with 10 couples
- [ ] Bug fixes
- [ ] Soft launch (TestFlight + Play Beta)

---

## Risks + Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Flame engine too limited | Medium | Prototype Week 1, pivot to Unity if blocked |
| Co-op desync | High | Simple state sync, server-authoritative |
| 2D art takes too long | Medium | Use placeholder art, iterate later |
| Firebase costs scale | Low | Free tier sufficient for MVP + testing |
| Performance on old devices | Medium | Target iPhone 6s+, test early |

---

## GitHub Repo Setup (Once Approved)

**Repo:** `github.com/bbugs280/towerdefense-Y`

**Initial Issues to Create:**
1. Setup Flutter + Flame project structure
2. Implement basic grid system
3. Create Tower base class + Arrow Tower
4. Implement enemy pathfinding (A* or predefined paths)
5. Implement tower merge system
6. Design level 1 layout
7. Setup Firebase backend
8. Implement local co-op input
9. Implement online co-op sync
10. Create main menu UI

---

## Decision Needed

**Owner Decision:**
- **A)** Approve Flutter + Flame (recommended)
- **B)** Choose Unity instead
- **C)** Want to discuss further before deciding

Once confirmed, I'll:
1. Create GitHub repo
2. Create issues from the phase breakdown
3. Start Phase 1 prototype

---

**Builder signing off.** Awaiting your engine decision.
