---
title: "Game Architecture"
project: "goySimulator"
game_name: "Gnoy Simulator"
date: "2026-05-03"
author: "Cpain"
version: "1.0"
status: "complete"
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9]
engine: "Godot 4.x"
language_primary: "GDScript"
language_escape_valve: "GDExtension (C++/Rust) for hot-loop subsystems if profiling demands"

# Source Documents
gdd: "_bmad-output/gdd.md"
brief: "_bmad-output/game-brief.md"
narrative: "_bmad-output/narrative-design/index.md"
ux: "_bmad-output/planning-artifacts/ux-design-specification.md"
brainstorming: "_bmad-output/brainstorming-session-2026-05-03.md"
epics: null

# Workflow Metadata
workflow: "gds-game-architecture"
nextStep: null
---

# Game Architecture — Gnoy Simulator

## Document Status

This architecture document is the technical contract for AI agents and human collaborators implementing **Gnoy Simulator**. It is built on top of the locked GDD, Game Brief, Narrative Design, and UX Specification — none of those locked decisions are revisited here. The architecture's job is to choose **how** the locked design is realized in code, not whether.

**Audience:** future Game Dev / Solo Dev agents (`gds-agent-game-dev`, `gds-agent-game-solo-dev`), the Game Architect, the Tech Writer, and Cpain.

**Read order convention.** Section numbers are stable. When a future agent is told "see §4.3 — Music Deterioration Pipeline," that reference will not move.

**Steps Completed:** 9 of 9. Document is complete and ready for Epics breakdown (`/gds-create-epics-and-stories`).

---

## 1. Project Context

### 1.1 Game Overview

**Gnoy Simulator** is a satirical top-down 2D RPG. Pokémon/Zelda camera. Alt-Earth present-day. Three interlocking gameplay layers — Investigation (Disco Elysium × Obra Dinn), Simulator (Persona × Stardew), Action (Hotline Miami × Deus Ex) — share a single 7-attribute / 24-skill / 40-talent RPG skeleton. Single-player, offline-capable, no live-service.

### 1.2 Technical Scope at a Glance

| Dimension | Decision |
|---|---|
| **Genre** | Investigation-CRPG / Simulator / Real-time top-down action — hybrid |
| **Perspective** | 2D top-down (Pokémon / Zelda camera) |
| **Art format** | Pixel art **or** hand-drawn 2D sprites — not 3D. Pipeline finalized at art-direction phase |
| **World structure** | District-based, 12 districts (5 Tier-1 multi-sub / 6 Tier-2 specialty / 1 Tier-3 endgame). **Not open-world.** Streamed transitions, loading screens acceptable |
| **Networking** | None. Single-player only. No multiplayer. No live-service |
| **Save model** | Autosave at day-boundary + key events. No manual save. Optional Ironman (one file, permadeath) |
| **Primary platform** | PC Steam (Windows + Linux native) |
| **Verified secondary** | Steam Deck Verified (target from day 1) |
| **Likely post-launch** | macOS, Nintendo Switch |
| **Possible tertiary** | PS5 / Xbox if controller-first UX work is funded |
| **Frame rate** | 60fps stable on 5-year-old mid-range PC |
| **Localization** | English at launch. Localization-readiness designed in from day 1 (string externalization, UI flex). 300k+ word translation budget = launch-language decision is a future scope call |
| **Modding** | Not in launch scope. Architecture should not foreclose it (see §7.4 — Mod Hooks) |
| **Team posture (locked 2026-05-03)** | **Solo dev + vibe-coding.** Architecture decisions optimize for iteration speed, AI-agent legibility, and content tooling — not for headcount scaling |

### 1.3 Core Systems Requiring Architecture

The 14 epics in the GDD reduce to seven **subsystem clusters** that the architecture must explicitly own. The cluster, not the epic, is the unit of architectural responsibility.

| # | Subsystem Cluster | Complexity | Drivers |
|---|---|---|---|
| **A** | **RPG Core** — attributes, derived stats, skills, talents, dispositions, Awakening Track, skill-check engine | Medium | 7 attrs × 24 skills × 40 talents × 2 disposition axes × 10-level Awakening; consumed by every other cluster |
| **B** | **Day-Cycle / Survival** — slot calendar, snooze, subscriptions, bills, sleep tick, Cope, Fatigue | Medium | Slot rules drive Politburo tick; subscription cancel = cross-system event (Awakening + Feed dossier flag) |
| **C** | **Combat (Hotline-Miami)** — real-time top-down, encounter restart with world-state persistence, capture, faction counter-system | High | Stat-modulated parameters; instant restart inside encounter; faction Build Classifier reads from this layer |
| **D** | **Dialogue Runtime** — visible-DC / hidden-consequence skill checks, internal voice chorus, item-drop, multi-path, **dialogue-as-combat** (Composure HP for Trusted Anchor / Debt Dealer), Conversation Log | **Highest content risk** | 300k+ words; 24-voice typography chorus; conversation log is a first-class subsystem |
| **E** | **Investigation UI (3 layers)** — Physical Board (drag-and-connect), Dossier Interface (publication × framing × audience × Credibility/Heat preview), Thought Cabinet (Awakening-driven reinterpretation), War Room (Stage 3+) | High | Three custom UI surfaces with persistent state; the Connection Draw + Publication Commit is the operational thesis of the game (per UX §2.1) |
| **F** | **Three Tracking Systems** — Player Dossier (shared faction file) + Politburo Simulation (independent weekly tick) + Reputation Web (per-Gnoym memory + gossip propagation + Interrogation Bridge to Dossier) | High + **legal-distinctness gate** | Architecture must enforce code-level distinction from US 10,926,179 |
| **G** | **Audio Pipeline + Music Deterioration** — 5-tier deterioration on every Xyoner-space track, smooth crossfade, sound-as-gameplay (footsteps, signal quality, homebase ambient growth), Awakening filter visual + audio coupling | High | Under-budgeted line item per Brief; 5 tiers × every Xyoner track = explicit scope multiplier |

Cross-cutting: a **token-driven UI theme system** with two themes (Xyoner corporate-app / Resistance handmade) sharing one component grammar, plus diegetic-scene exception list (Apartment Laptop, War Room, Compound, Endgame Trigger). UX §1.1 mandates this and rules out third-party UI libraries.

### 1.4 Performance Constraints (the hard numbers)

These are pulled directly from the GDD's Success Metrics and are treated as architectural acceptance criteria.

| Metric | Budget | Source |
|---|---|---|
| Frame rate | 60fps stable on 5-yr-old mid-range PC | GDD §Technical Specifications |
| **Politburo weekly tick** | <500ms in worst-case 100-week-deep save | GDD §Success Metrics |
| **Conversation Log retrieval** | <50ms for any past conversation lookup | GDD §Success Metrics |
| **Gossip propagation tick** | <2s for 200+ Gnoym in Reputation Web | GDD §Success Metrics |
| Day-boundary autosave | <3s on minimum spec | GDD §Success Metrics |
| Load from save | <5s | GDD §Success Metrics |
| Memory footprint | Moderate; not 3D-asset-budget constrained | GDD §Performance Requirements |

**Architectural implication:** the Conversation Log and Reputation Web are the only subsystems whose data-shape decisions are performance-sensitive enough to gate a vertical-slice ship. Everything else is comfortably within indie-2D budget.

### 1.5 Complexity Drivers (where the architecture earns its rent)

**1. The Three Tracking Systems must be code-distinct, not just doc-distinct.** The legal differentiation from US 10,926,179 is enforced at code level: the Politburo Simulation may not read from per-NPC memory; the faction Dossier may not own personal-NPC memory; only the Interrogation Bridge moves data from Reputation Web → Dossier, and that bridge is a single explicit call site. This is the most legally sensitive code constraint in the project (see §6.1).

**2. The Politburo Simulation must remain coherent across hundreds of in-game weeks even when the player does nothing.** It is **not** a player-action graph. It runs whether the player exists or not. Determinism + saveability + auditability matter more here than performance — the weekly tick budget (500ms) is generous, but the simulation must be reproducible from a save seed for debugging and modding. (See §6.2.)

**3. The Music Deterioration Mechanic is a content + runtime hybrid problem.** 5 tiers × every Xyoner-space track is the asset side. The runtime side is a smooth tier-crossfade tied to Awakening Level — never jarring, never mid-encounter discontinuity. (See §4.3.)

**4. Real-time Hotline-Miami combat + Disco-Elysium dialogue runtime + 3-layer Investigation UI in one build.** Few engines do all three equally well; the choice is real (see §3).

**5. Dialogue-as-Combat (Trusted Anchor / Debt Dealer) demands the dialogue runtime support stat-driven multi-stage encounters with Composure HP, evidence + skill combos, and failure costs (blown cover + lost evidence + Heat spike).** This rules out a pure dialogue-tree authoring tool with no runtime hooks; we need a dialogue VM with mid-conversation system effects.

**6. The Conversation Log is weaponized by the world.** It's not just a UI feature — NPCs quote the player back, the Cage interrogates Gnoym whose remembered quotes flow verbatim into the Dossier, the Feed edits soundbites. The log is the highest-risk performance/storage area and must be prototype-validated at vertical slice (per Brief Risk Assessment).

**7. Build-gated world access.** Sneak routes only render at Ghost Mode threshold; internal voices scale with Awakening + Fatigue; Xyoner symbols become readable as Awakening rises; HUD changes with Awakening. The world is a function of character state — the architecture must make character state queryable cheaply from rendering, audio, dialogue, and UI layers (see §6.3).

### 1.6 Novel Systems Without Standard Patterns (custom design needed)

These have no off-the-shelf engine subsystem and require explicit architecture in this document:

- **Three Tracking Systems triad** (Dossier / Politburo / Reputation Web) — §6.1, §6.2
- **Music Deterioration tier system** — §4.3
- **Awakening Filter** (visual + audio + UI theme + dialogue coupling) — §6.3
- **Connection Draw skill-check on Physical Board** — §6.4
- **Publication Commit framing matrix with live Credibility/Heat preview** — §6.4
- **Conversation Log as live system** (recordable, retrievable, weaponizable, Feed-editable) — §6.5
- **Schrödinger's NPC system (Dave)** — first-encounter-locked future NPC role — §6.6
- **Subscription cancellation as cross-system event** (Awakening Track moment + Feed dossier flag + Slop Damage decay) — §6.7
- **Diegetic UI scenes** (Apartment Laptop, War Room, Compound entry, Endgame Trigger) — §5.6

### 1.7 Technical Risks (architectural, not design)

The Brief and GDD already enumerate scope/tone/writing-volume/legal risks; the **engineering** risks specific to this architecture are:

| Risk | Severity | Owned by |
|---|---|---|
| Conversation Log data model misjudged → late-stage rewrite under content load | **High** | §6.5 |
| Politburo Simulation accumulates non-determinism → unreproducible bugs, unmoddable | High | §6.2 |
| Music Deterioration crossfade quality fails at runtime → signature mechanic feels broken | High | §4.3 |
| Combat encounter restart mishandles world-state persistence → broken loop in vertical slice | Medium | §4.5 |
| Token theme system can't represent Awakening filter cleanly → per-component patches everywhere | Medium | §5.4 |
| Dialogue runtime can't host Composure-HP boss encounters cleanly → boss-fight dialogue special-cased | Medium | §6.5 |
| Save format brittle to schema evolution → mid-EA save breakage | Medium | §7.1 |
| Localization-readiness deferred → 300k-word retrofit | Medium | §7.5 |

---

---

## 2. Engine & Starter Selection

### 2.1 Engine: Godot 4.x

**Decision (locked 2026-05-03 by Cpain):** Godot 4.x is the engine of record.

**Why this engine, given the locked design:**

- **Solo-dev / vibe-coding posture.** Godot's per-feature complexity tax is materially lower than Unity's; the scene-tree-and-script idiom is small enough that AI agents (this one and successors) can produce coherent, reviewable diffs. The complexity tax is paid daily; the per-feature ceiling is rarely hit on 2D top-down indie work.
- **2D-first.** Native pixel-perfect 2D, lightweight scenes, top-down rendering ergonomics, `Camera2D` with smoothing and limits is one node.
- **UI Tooling exact-fit.** UX §1.1 specified Godot's Control nodes + theme resources as the direct fit for the two-personality (Xyoner / Resistance) split. Theme overrides are first-class and live-editable.
- **Audio Architecture.** The `AudioStreamPlayer` + `AudioBus` + `AudioEffect` stack supports the 5-tier deterioration crossfade cleanly without third-party middleware (see §4.3).
- **Open-source + zero-royalty.** Eliminates platform-vendor policy risk on a satirical-political-content title. Engine source is auditable, which matters for legal-distinctness review of the Three Tracking Systems against US 10,926,179.
- **Steam Deck Verified.** Linux-native exports work out of the box. Steam Deck is a primary target.
- **Save system shape.** `Resource` + `ResourceSaver` with versioned custom resources is solo-dev-shaped and round-trips cleanly to disk.

**Trade-offs accepted:**

- **Console certification path** is third-party (W4 Games or porting partners) when post-launch console ports happen. The Brief defers consoles past launch — this cost is paid later, not now.
- **No proven Hotline-Miami-feel reference** in Godot at full scale; combat-feel will require hand-tuning. Mitigated by the encounter-restart loop being short-cycle and tunable in isolation (see §4.5).
- **Smaller dialogue-tooling ecosystem** than Unity. Mitigated by rolling a custom GDScript dialogue VM (see §4.8) — Dialogic 2 is good for tree-shaped CRPG dialogue but is a poor fit for Dialogue-as-Combat encounters with Composure HP and item-drop mid-conversation.

### 2.2 Engine Version Pin

**Pin: Godot 4.3 (or latest stable 4.x at vertical-slice start, whichever is newer at start date).** Once pinned, the version is locked for the duration of the vertical slice. Upgrades within the 4.x line are evaluated only at major milestones (vertical slice → EA, EA → full). Never upgrade mid-content-push.

### 2.3 Language Choice

| Layer | Language | Rationale |
|---|---|---|
| Game logic, UI, dialogue, save/load, RPG core, day cycle | **GDScript** | Engine-native; AI-agent-legible; fastest iteration; no compile cycle; integrates with editor and resources without friction |
| Hot-loop subsystems _if_ profiling demands | **GDExtension (C++ or Rust)** | Escape valve. Likely candidates: gossip propagation tick, Conversation Log search index. Not implemented unless a profiler-validated hotspot demands it |
| Build tools, asset pipeline scripts | Python or shell | Run outside the engine |

**Forbidden:** mixing C# Mono builds with GDScript builds in the same project. Pick one runtime; we picked GDScript. (Future contributors: do not propose adding Mono.)

### 2.4 Starter Project / Template

**Decision: build from an empty Godot project.** No third-party CRPG starter exists for this design. The custom scaffolding is small enough that a starter would constrain more than it would help.

**Initial scaffolding deliverable** (Story 0 of Epic 1):

- `project.godot` configured: window 1920×1080, viewport stretch mode `canvas_items`, default texture filter `nearest` (pixel-art-safe; flip per asset if hand-drawn art chosen), physics tick 60, audio mix rate 44100, default audio bus layout with the 9 buses listed in §4.3.
- The 12 autoload singletons listed in §5.5.
- Folder skeleton per §5.1.
- `.gitignore` for Godot + OS clutter.
- An initial Resource schema for `SaveGameV1` (§7.1) with version stamp and round-trip test.
- A Steam Deck Verified-ready export preset for Linux.

### 2.5 Third-Party Addons / Dependencies

**Default posture: avoid.** Each addon is a future-pinned dependency, and a satirical-political-content title cannot afford a load-bearing addon that goes unmaintained or licenses-pivot.

**Approved addons (none required at vertical slice; evaluate at EA):**

| Addon | Purpose | When to add | Risk |
|---|---|---|---|
| **Godot Steam** (gdnative/gdextension binding) | Steam achievements, cloud save, controller config | EA prep, when achievements list is finalized | Low — well-maintained, narrow surface |
| **Phantom Camera** | Smooth Camera2D control / Cinemachine-equivalent | If hand-rolled camera proves insufficient at vertical slice | Low — pure GDScript |
| **GUT** (Godot Unit Test) | Unit tests for RPG core math + Politburo determinism | Story 0 if writing tests up-front; otherwise EA prep | Very low |

**Explicitly rejected addons:**

- **Dialogic 2** — beautiful for tree-shaped CRPG dialogue. Fights us on Composure-HP boss encounters, mid-conversation system effects, item-drop into dialogue, and the Conversation Log as a first-class subsystem. We need a runtime VM (§4.8), not an authoring tool over a runtime we don't own.
- **NoesisGUI / Coherent UI / web-tech-in-engine wrappers** — UX §1.1 explicitly rejects these.
- **Any "RPG framework" addon** — none of them match this design's specifics (7 attrs / 24 skills / 40 talents / 2 disposition axes / Awakening Track / dispositions / dossier / faction simulation). Generic frameworks force us to fight their assumptions.

---

## 3. Architectural Decisions

This section is the catalog of **how** each subsystem cluster from §1.3 is realized. Decisions are recorded as **D-#** with a rationale; future agents who think a decision is wrong must propose a successor decision (D-#-rev1), not a silent change.

### 3.1 Rendering — D-RENDER-01

**Decision:** 2D Canvas-only rendering, top-down camera (`Camera2D`), pixel-perfect with `Viewport`-based virtual resolution, post-processing via a single full-screen `ColorRect` with shader for the Awakening Filter.

- **Camera:** one `Camera2D` per gameplay scene, smoothed, limited to district bounds. Combat scenes share the same camera type with tighter zoom.
- **Awakening Filter:** a single fragment shader on a `CanvasLayer`-mounted `ColorRect` consuming a `awakening_level` uniform (0–10) and a `xyoner_space_intensity` uniform (0–1, set per district / building entry). Filter parameters: saturation curve, color-channel offset, grain density, vignette. Shader is the **only** code path that reads Awakening directly for visuals — every other visual reads "current theme tokens" which are state-derived (see §5.4).
- **Lighting:** baked 2D lights for atmosphere only; no dynamic lighting required. Hotline-Miami palette discipline > engine effects.
- **No 3D pipeline used.** `Forward+` renderer not enabled. Mobile renderer is the export target on Steam Deck for power efficiency; verify equivalent visuals at vertical slice.

### 3.2 Physics — D-PHYS-01

**Decision:** Godot 2D physics, `CharacterBody2D` for player + NPCs, `StaticBody2D` for walls/cover, `Area2D` for triggers. **No** rigid-body simulation. Hotline-Miami movement is kinematic with hand-tuned acceleration curves.

- Combat hits resolve through `Area2D` overlap + `move_and_slide()` displacement, not impulse-based physics.
- Bullets are scripted projectiles (`Area2D` with travel script); never `RigidBody2D`. Reason: deterministic, debuggable, 60fps-safe.
- Pathfinding for NPC routines uses Godot's `NavigationAgent2D` with baked navigation regions per district. Routine-following NPCs do not need real-time replanning except on player-driven blockers.

### 3.3 Audio Pipeline + Music Deterioration — D-AUDIO-01 _(Locked Fork)_

**Decision: pre-rendered 5-tier multi-version recordings + runtime crossfade between tier players. Not DSP-on-stems.**

This was flagged as a fork; the GDD explicitly mandates multi-version recordings ("Composer pipeline must support multi-version recordings of every Xyoner-space track"). This is **not actually a fork** — it is locked by GDD §Music Deterioration. What this section locks is the **runtime architecture** for delivering it.

**Runtime architecture:**

- **9 audio buses:** `Master`, `Music`, `Music_Stinger`, `SFX_World`, `SFX_Combat`, `SFX_UI`, `Voice_Internal`, `Voice_Dialogue`, `Ambient`. Each bus has named effect slots; effects are added/removed by code, not by editor magic.
- **Music subsystem:** a `MusicDirector` autoload (§5.5) owns the active context (e.g., `xyoner_corporate_lobby`, `slopside_ambient`). Each Xyoner-space context resolves to a `MusicContextResource` listing 5 `AudioStream` paths (tiers 1–5).
- **Tier crossfade:** the `MusicDirector` runs **two `AudioStreamPlayer` instances per Xyoner-space context** (tier-N and tier-N+1) and crossfades between them as Awakening Level crosses tier thresholds. Crossfade duration is per-context-tunable (default 4 seconds), reaches the new tier's volume curve, and never produces a discontinuity mid-loop. Awakening Level is sampled at scene-load and again every 30 seconds; threshold crossings during play are **deferred to scene transitions or natural loop boundaries** unless the boundary is more than 60 seconds away (anti-jarring rule).
- **Slopside / Hollow / non-Xyoner contexts** have a single tier and do not deteriorate (deterioration is a Xyoner-space-only mechanic, per GDD).
- **Crossfade safety:** the `MusicDirector` exposes a hard cut for narrative moments (Awakening cinematic at 1/5/10) but crossfade is the default everywhere else.

**Asset pipeline:**

- Beatoven.ai generates the tier-1 (clean) `.ogg` loop per Xyoner-space context from a text prompt. Tiers 2–5 are derived **offline** from tier 1 via a per-context DSP recipe (bitcrush curves, EQ rolloff, stutter rate, dropout density, pitch wobble — tuned to match FR85's tier mapping). All 5 files are baked, loop-clean, and committed to source. (See Story 13.4a.)
- File format: `.ogg` Vorbis at 128–192 kbps for music; `.wav` for short SFX. (Steam Deck and PC handle this comfortably; mobile-grade compression unnecessary.)
- **Anti-pattern (forbidden):** never apply runtime DSP to a tier-1 stream to fake higher tiers. The recipe is offline pre-production; runtime DSP causes quality/timing variance and defeats the satire.

**Combat music** uses a separate stem-and-layer system (combat intensity adds layers) because combat music does not deteriorate with Awakening — it is mood, not satire surface. Combat music is one pipeline; deterioration music is another; they share the bus architecture but not the director logic.

### 3.4 Networking — D-NET-01

**Decision:** No networking. Single-player only. Offline-capable by default. Steam cloud save is the only network surface, integrated through Godot Steam at EA, opt-in (per Brief: live-service explicitly out of scope).

### 3.5 Combat Tick + Encounter Restart — D-COMBAT-01

**Decision:** combat encounters are scoped sub-states with a **snapshot taken at encounter entry**; encounter restart restores the snapshot, **the broader world state is unaffected by encounter restarts**.

- An encounter starts when the player enters a triggered area or initiates combat dialogue. The `EncounterDirector` autoload takes a snapshot: player health/position, NPC participants, room state, ammo.
- Death within encounter → fade to black → restore snapshot → resume. World clock does **not** advance during encounter restarts; the broader save is untouched. (This matches the GDD's "encounter restart in combat is in-encounter only — separate from save state" rule.)
- Encounter resolution (success / capture / yield / escape) **commits**: snapshot is discarded, world state advances, dossier updates schedule per OPSEC delay, combat outcomes feed the Politburo Simulation as inputs at next weekly tick.
- **Capture state** is a save-eligible substate so the player can sleep / quit during a capture without losing the option to attempt escape later. Implemented as a `CaptureGame` scene that persists via the same save format as the main game.

### 3.6 Day Cycle / World Clock — D-CLOCK-01

**Decision:** a single `WorldClock` autoload owns in-game time. Time is integer minutes since campaign start; UI derives day/slot/date from this. Politburo ticks are scheduled at week boundaries (`minutes % MINUTES_PER_WEEK == 0` after a sleep advance). Slot consumption is a function of `WorldClock`, not of real-time.

- Slot rules (Morning/Afternoon/Evening/Night) are config tables driven by `DayCycleConfig` resource.
- Snooze button consumes the morning slot silently. Subscription bills auto-deduct on month-roll. Sleep advances clock by player-selected hours (default 8h, options 4h–10h with consequences).
- **Sleep is the only player-driven time-jump.** Background time does not advance unless the player sleeps. (NPCs route on per-slot schedules but the world clock does not creep.)

### 3.7 Save Format — D-SAVE-01

**Decision:** custom `SaveGameV{N}` Godot Resources, serialized via `ResourceSaver` to a binary `.tres` file (`.tres` text format used in dev for diffing, binary `.res` in release). Schema version is the first field. Loader migrates older versions forward; **never** silently drops fields.

- One save file per slot. Default slot pattern: `user://saves/save_{slot}.res`.
- Day-boundary autosave runs at midnight in-game (or at any forced sleep-advance commit). Key-event saves run at: faction-standing transitions, ending triggers, capture/escape resolution, district transitions.
- **Save schema versioning is mandatory.** Every shippable build that changes the schema bumps `SaveGameV{N}` and adds a migration. Save corruption from a missing migration is a release-blocker bug.
- **Save format is human-debuggable in dev.** A `--dump-save` CLI flag exports any save to JSON for diffing.

### 3.8 Dialogue Runtime — D-DIALOG-01

**Decision: custom GDScript dialogue VM.** Not Dialogic. Not Yarn. Not Ink.

- Dialogues are authored as data — a `.dialog.tres` resource (or YAML compiled to one) per scene. Each dialogue is a graph of nodes; node types include `Line`, `Choice`, `SkillCheck`, `InternalVoice`, `ItemDrop`, `Branch`, `SystemEffect` (mid-conversation Composure-HP damage, Heat tick, dossier flag, etc.), `Commit` (locks in a consequence), `End`.
- The **dialogue VM** is an autoload (`DialogueRunner`) that walks the graph, resolves skill checks against the RPG core (§4.1), surfaces internal voices via the `InternalVoiceChorus` (§5.6), pushes lines to the active dialogue UI, and emits the conversation log entry on commit.
- **Conversation Log** is a first-class output of the VM. Every committed line writes a `ConversationLogEntry` (speaker, text, surface-form quoted-back hash, dialogue id, NPC id, in-game timestamp, faction-relevance tags) to a per-NPC log and a global indexed log. (Detailed in §6.5.)
- **Dialogue-as-Combat (Trusted Anchor / Debt Dealer)** is the same VM with an additional `EncounterContext` subscribed to it: Composure HP is a stat in the encounter context, `SystemEffect` nodes can damage it, failure routes (Composure → 0) jump to a designated graph node. **No special-case code path for boss dialogue.** This is the architecturally important property — dialogue-as-combat is not a separate runtime.
- **Internal voices** scale frequency by `awakening_level + fatigue_level`, capped per dialogue to avoid noise. Per-voice typography (24 voices) is data: `VoiceProfile` resources own font / color / animation / VO bank.
- **Item-drop in dialogue:** the player can drag an inventory item onto an NPC during conversation; the VM checks the active dialogue node for an `ItemAccepted` edge keyed to that item id and routes accordingly. NPC reaction is a `Line` node; the dropped item may or may not be consumed (per node config).

**Authoring tooling:** at vertical slice, hand-authored `.tres` resources are acceptable. Before EA, a YAML-to-resource importer is mandatory (writers should not edit `.tres` files in production).

### 3.9 Data Storage — D-DATA-01

| Data class | Storage | Examples |
|---|---|---|
| **Static config** (immutable per build) | `Resource` files committed to source | Skill definitions, talent definitions, dialogue graphs, music context tables, district layouts, faction templates, boss templates |
| **Live world state** (mutable, saved) | In-memory `Resource` instances, serialized to save | Player state, day clock, dossier, politburo state, reputation web, conversation log, district heat, recruit roster |
| **Per-session ephemeral** (not saved) | In-memory only, dropped on quit | Combat encounter snapshots, dialogue VM cursor, audio crossfade state, UI animation state |
| **User settings** (cross-save, per-machine) | `user://settings.cfg` (Godot ConfigFile) | Audio levels, key rebinds, accessibility toggles, Markers Mode default |

**Constants:** all magic numbers (DC tables, threshold values, week tick budget) live in `core/balance/balance.tres` not in code. Tuning is a designer activity, not a code activity.

### 3.10 Politburo Tick Model — D-POLITBURO-01 _(Locked Fork)_

**Decision: deterministic seeded simulation + explicit event log.** The flagged "deterministic vs. event-driven" fork is resolved in favor of deterministic, for the reasons below. (If you want to override this, override before §6.2 implementation begins.)

- The Politburo Simulation runs as a **pure function** of: previous state + RNG seed + recent player-action inputs. Same inputs + same seed = identical next state. Reproducible from any save.
- Within the tick, the simulation **emits an ordered event log** (`PoliticalEvent` records: promotions, betrayals, blackmail moves, scandals). The event log is what the War Room UI and the Quest System consume.
- **Why deterministic over event-driven-everywhere:**
  1. **Bug reproducibility.** A player reports "the Innovation Czar got promoted twice in week 47" → we replay from save seed and reproduce the bug deterministically.
  2. **Save robustness.** State is reconstructable from seed + input log if the binary state somehow breaks.
  3. **Modding hooks.** A modder can swap a faction policy function and run the same seed to compare outcomes.
  4. **Tractable testing.** Unit tests assert "seed X + input Y → state Z." Event-driven sims are non-trivial to test without an integration harness.
- **Tick budget:** 500ms worst case at 100-week-deep save (per GDD §Success Metrics). Profile at vertical slice with synthetic 100-week saves; if budget breached, the gossip-propagation pass within the tick is the first GDExtension candidate.
- **Cross-tick player input commits between ticks** — the player cannot interleave inputs into a running tick. Conceptually: tick is a discrete weekly step, inputs queue, tick consumes the queue at week-roll.

### 3.11 Localization Architecture — D-LOC-01

**Decision:** Godot's built-in CSV-based translation with PO export for translator workflows.

- **All player-visible strings** live in CSV translation tables, not in code. Hardcoded English strings outside translation tables are a build-time lint error (custom tool, added at EA prep).
- **String IDs are stable.** Renaming an ID requires a migration entry. Translators key off IDs, not text.
- **Length-flex UI.** Every UI component must layout-test against 1.5× English width (German benchmark) without clipping. Token-driven layout (§5.4) supports this.
- **Internal voices are localized** like normal dialogue. Per-voice VO is a future commit; text-only ships at launch.

---

## 4. Project Structure & Code Organization

### 4.1 Folder Layout

```
goySimulator/
├── project.godot
├── icon.svg
├── .gitignore
├── _bmad/                         # BMad workflow files (existing)
├── _bmad-output/                  # Planning artifacts (existing)
├── docs/                          # Hand-written devdocs (existing)
├── art/
│   ├── characters/                # Sprites: player, named NPCs, crowd Gnoym
│   ├── environments/              # District tilesets, props, backgrounds
│   ├── ui/
│   │   ├── xyoner/                # Corporate-app theme assets
│   │   └── resistance/            # Handmade theme assets
│   └── effects/                   # Awakening filter samples, particle textures
├── audio/
│   ├── music/
│   │   ├── xyoner_spaces/         # *_t1..t5.ogg per track
│   │   ├── slopside_hollow/
│   │   ├── investigation/
│   │   ├── combat/
│   │   └── awakening_stingers/
│   ├── sfx/
│   ├── voice/
│   │   ├── internal/              # Per-voice VO banks
│   │   └── npc/
│   └── ambient/
├── src/
│   ├── core/                      # No game-domain knowledge here
│   │   ├── autoloads/             # Singletons (see §5.5)
│   │   ├── save/                  # SaveGameV{N}, migrations, serializer
│   │   ├── balance/               # balance.tres + tuning resources
│   │   ├── config/                # ProjectConfig, runtime feature flags
│   │   └── util/                  # Math, RNG seeding, debug logging
│   ├── rpg/                       # Cluster A — RPG Core
│   │   ├── attributes.gd
│   │   ├── derived_stats.gd
│   │   ├── skills.gd
│   │   ├── talents.gd
│   │   ├── dispositions.gd
│   │   ├── awakening_track.gd
│   │   ├── skill_check.gd         # The dice/DC engine
│   │   └── data/                  # Skill defs, talent defs as Resources
│   ├── day_cycle/                 # Cluster B — Day & Survival
│   │   ├── world_clock.gd
│   │   ├── slot_manager.gd
│   │   ├── subscription.gd
│   │   ├── bills.gd
│   │   ├── cope.gd
│   │   └── fatigue.gd
│   ├── combat/                    # Cluster C — Hotline Miami combat
│   │   ├── encounter_director.gd
│   │   ├── combat_actor.gd
│   │   ├── projectile.gd
│   │   ├── capture.gd
│   │   ├── build_classifier.gd    # Reads patterns; output goes to dossier (§6.1)
│   │   └── weapons/
│   ├── dialogue/                  # Cluster D — Dialogue runtime
│   │   ├── dialogue_runner.gd     # The VM
│   │   ├── nodes/                 # Node types: Line, Choice, SkillCheck, etc.
│   │   ├── voice_chorus.gd
│   │   ├── conversation_log.gd
│   │   └── dialogue_as_combat.gd  # Composure HP encounter context
│   ├── investigation/             # Cluster E — 3-layer investigation UI
│   │   ├── physical_board.gd
│   │   ├── connection_draw.gd
│   │   ├── dossier_interface.gd   # Player's evidence dossier (NOT the faction Dossier; see §6.1)
│   │   ├── publication_commit.gd
│   │   ├── thought_cabinet.gd
│   │   └── war_room.gd
│   ├── tracking/                  # Cluster F — Three Tracking Systems
│   │   ├── player_dossier.gd      # Faction file. NO per-NPC memory here.
│   │   ├── politburo/
│   │   │   ├── politburo_sim.gd   # Deterministic tick
│   │   │   ├── operatives.gd
│   │   │   ├── factions.gd
│   │   │   └── political_event.gd
│   │   ├── reputation_web/
│   │   │   ├── gnoym_memory.gd    # Per-NPC. NO faction-hierarchy linkage here.
│   │   │   ├── gossip.gd
│   │   │   └── interrogation_bridge.gd  # The ONLY bridge to player_dossier
│   │   └── README.md              # Legal-distinctness contract (see §6.1)
│   ├── audio/                     # Cluster G — Audio + Music Deterioration
│   │   ├── music_director.gd
│   │   ├── tier_crossfade.gd
│   │   ├── combat_music.gd
│   │   ├── sfx_router.gd
│   │   └── data/                  # MusicContextResource per context
│   ├── world/
│   │   ├── district_loader.gd
│   │   ├── heat_tracker.gd
│   │   ├── traversal.gd
│   │   └── districts/             # One subfolder per district
│   ├── npcs/
│   │   ├── routine.gd
│   │   ├── named_npc.gd
│   │   └── schrodinger.gd         # Dave system (§6.6)
│   ├── ui/
│   │   ├── theme/
│   │   │   ├── tokens.gd          # Token registry
│   │   │   ├── xyoner_theme.tres
│   │   │   ├── resistance_theme.tres
│   │   │   └── awakening_overrides.gd
│   │   ├── components/            # Foundation primitives
│   │   ├── hud/                   # Persistent HUD
│   │   ├── menus/                 # Pause, settings, save menus
│   │   └── diegetic/              # Apartment Laptop, War Room, Compound, Endgame
│   ├── opening/                   # Cluster — Opening Sequence (Epic 12)
│   │   └── perfectly_normal_morning.gd
│   ├── quest/
│   │   ├── quest_journal.gd
│   │   ├── quest_discovery.gd
│   │   └── markers_mode.gd
│   ├── recruitment/
│   │   ├── recruit.gd
│   │   ├── loyalty.gd
│   │   └── homebase_stage.gd
│   └── localization/
│       ├── translations.csv       # Source of truth, exported to .translation files
│       └── lint.gd                # Build-time string-literal lint
├── tests/                         # GUT tests
│   ├── unit/
│   ├── integration/
│   └── determinism/               # Politburo seed reproducibility tests
└── tools/                         # Editor tools, asset processors
    ├── dialogue_yaml_to_tres.gd
    ├── balance_validator.gd
    └── save_dump.gd
```

### 4.2 Naming Conventions

| Kind | Convention | Example |
|---|---|---|
| GDScript files | `snake_case.gd` | `politburo_sim.gd` |
| Resource files | `snake_case.tres` (text in dev) / `.res` (binary in release) | `balance.tres` |
| Scenes | `snake_case.tscn` | `physical_board.tscn` |
| Class names (when declared) | `PascalCase` | `class_name PoliticalEvent` |
| Signals | `snake_case` past-tense verb | `awakening_level_changed` |
| Constants | `SCREAMING_SNAKE_CASE` | `MAX_AWAKENING_LEVEL` |
| Autoload (singleton) names | `PascalCase`, registered globally | `WorldClock`, `MusicDirector` |
| Folder names | `snake_case`, plural for collections | `districts/`, `nodes/` |
| Translation keys | `domain.subdomain.identifier`, lowercase | `dialog.greystone.dave_first_meeting.greeting` |

### 4.3 Scene Composition Rules

- **One scene per logical concern.** A district map is one scene. The HUD is one scene. The dialogue UI is one scene. Scenes compose by instantiation, not by inheritance.
- **No "god scenes."** A scene that owns >1 unrelated subsystem is split. The Apartment scene owns the Apartment; it does not own the day cycle, audio, or save system (those are autoloads).
- **Scenes communicate via signals or autoload calls, never via parent-pointer chains.** Direct sibling-reference is a code smell; use a signal or an autoload mediator.
- **Diegetic scenes (Apartment Laptop, War Room, Compound entry, Endgame Trigger)** are first-class scenes, **not** menus. They appear in `src/ui/diegetic/` and are documented per scene with their custom component grammar.

### 4.4 Theme Token System — D-THEME-01

Per UX §1.1, the UI is two themes (Xyoner / Resistance) sharing one component grammar, plus diegetic exceptions.

- **Tokens** (color, type size, spacing, border radius, animation duration) live in `src/ui/theme/tokens.gd` as a typed dictionary. Tokens never appear as literals in component code.
- **Awakening-aware tokens.** Each token has up to 11 variants (one per Awakening level 0–10) plus an "off" variant (hidden / non-applicable). The `ThemeManager` autoload swaps token values at threshold crossings; components rebind on a `theme_tokens_changed` signal.
- **Awakening Filter is a token state**, not a per-component patch. Changing the filter is a single `ThemeManager.set_awakening(level)` call.
- **Music-deterioration-equivalent UI glitching** (subtle UI artifacts at high Awakening in Xyoner-themed UI) is a token state too.
- **Diegetic-scene exception list:** documented per scene, allowed to ignore tokens for bespoke art. Not allowed to leak bespoke patterns back into shared components.

### 4.5 Autoload (Singleton) Registry

Twelve autoloads. Each is registered in `project.godot`. Order matters: earlier autoloads cannot depend on later ones.

| # | Name | Owns |
|---|---|---|
| 1 | `Logger` | Structured logging, debug levels, ring buffer |
| 2 | `ProjectConfig` | Build flags, runtime feature toggles |
| 3 | `Balance` | Loaded `balance.tres` exposed read-only |
| 4 | `RNG` | Seeded RNG instances per subsystem (rpg / politburo / dialogue / combat) |
| 5 | `SaveSystem` | Save/load, schema version, migrations |
| 6 | `WorldClock` | In-game time, slot, day, week |
| 7 | `RPGCore` | Player attributes, derived stats, skills, talents, dispositions, Awakening Track |
| 8 | `ThemeManager` | Token resolution + Awakening-aware swap |
| 9 | `MusicDirector` | Music context + tier crossfade |
| 10 | `DialogueRunner` | The dialogue VM |
| 11 | `EncounterDirector` | Combat encounter snapshots + restart |
| 12 | `EventBus` | Project-wide signal hub for cross-cluster messages (subscription_cancelled, awakening_level_changed, day_advanced, faction_standing_changed, etc.) |

The Three Tracking Systems are **not** autoloads — they are members of a single `WorldState` object owned by `SaveSystem`, because their lifecycle is the save's lifecycle. Treating them as autoloads would conflate "lives across saves" (true for `WorldClock` config) with "is the save" (true for tracking).

### 4.6 Signal / Event Bus Conventions

`EventBus` autoload is the signal hub for cross-cluster events. Cluster-internal signals stay inside the cluster's nodes; cross-cluster signals route through `EventBus` so subscribers don't need direct references.

- **Event names are past-tense:** `subscription_cancelled`, `connection_drawn`, `evidence_published`, `awakening_level_changed`, `day_advanced`, `gnoym_interrogated`.
- **Event payloads are typed** (`SubscriptionEvent`, `PublicationEvent` resource types), not bare dictionaries. Type churn is easier than dict-shape drift.
- **Subscribers handle their own concerns.** When a subscription is cancelled, the Awakening cluster ticks the track; the Tracking cluster flags the dossier; the Audio cluster *might* play a stinger if Awakening crosses a tier. Each subscriber knows nothing about the others.

---

## 5. Implementation Patterns

This section documents the **novel systems** identified in §1.6. Each pattern has a contract that AI agents must respect.

### 5.1 Three Tracking Systems Triad — Legal-Distinctness Enforcement

**The single most important code-level constraint in this project.**

The Brief and GDD spell out that the Dossier / Politburo / Reputation Web triad must be structurally distinct from US 10,926,179 (WB Nemesis). The architecture enforces this at code level via three rules. Each rule maps to a specific module and is enforced by code review (and ideally, lint at EA).

#### Rule 1: The Player Dossier MUST NOT contain per-NPC memory.

- `src/tracking/player_dossier.gd` owns: threat axes, build classifier, known associates (recruit ids), known operations, warrants, suspected aliases, plant flags, last-update timestamp, OPSEC delay-debt.
- It does **not** contain: a Gnoym's specific memory of a specific conversation, a Gnoym's name keyed to a quote, a Gnoym's personal grievance.
- Quotes that enter the Dossier come **only via the Interrogation Bridge** (Rule 3), and they enter as faction-intel records (`InterrogationReport`) — keyed by report id, not by the originating Gnoym's identity-as-an-individual. The Gnoym is the *source*, not the *owner*, of the memory once it crosses the bridge.

#### Rule 2: The Politburo Simulation MUST NOT read the player-action graph directly.

- `src/tracking/politburo/politburo_sim.gd` reads: previous Politburo state, RNG seed, the queued **input list** for this tick.
- It does **not** read: the Player Dossier directly, the Reputation Web directly, the player's action history.
- The input list is constructed by `EventBus` subscribers that *summarize* relevant player actions for the tick (e.g., `OperativeEliminated(boss_id)`, `EvidencePublished(faction_id, framing_strength)`). These summaries are the only player-input vector. The simulation rules then determine outcomes per its own logic — promotions, succession, betrayals — none of which are scripted off player actions.
- **Why this matters legally:** the patent claim hinges on player actions causing hierarchy changes. In our architecture, the player provides inputs; the simulation determines hierarchy per its own independent rules. The hierarchy would still update if the player did nothing (succession from old age, internal politics, blackmail-debt cycles).

#### Rule 3: Interrogation Bridge is the ONLY data path from Reputation Web to Player Dossier.

- `src/tracking/reputation_web/interrogation_bridge.gd` is the single function. It is called explicitly when an interrogation event resolves. It writes an `InterrogationReport` to the Dossier with the source Gnoym's quoted-back surface form.
- No other code may import from `reputation_web/` into `player_dossier.gd`. This is enforced by:
  1. A `# DISTINCTNESS CONTRACT — see §6.1` comment header in `player_dossier.gd` listing the only allowed import.
  2. A code-review checklist item.
  3. (Future, EA prep) a static analysis check.
- **Reputation Web is self-contained.** Gnoym remember the player. They gossip. They quote the player. None of this enters the faction system except via interrogation.

#### Rule 4: A standing legal-distinctness README in `src/tracking/README.md`.

This file is the documented contract. Any code change in `src/tracking/` that AI agents propose must be reviewed against this README before merge. The README quotes GDD §Three Tracking Systems verbatim and points back to this section.

### 5.2 Politburo Simulation — Determinism + Event Log

Per §3.10 the simulation is deterministic, seeded, and emits an ordered event log per tick. The pattern:

```
PoliticalState.tick(prev_state, input_list, rng_seed) -> (new_state, event_list)
```

- Pure function. No autoload reads inside. No file I/O. No randomness outside the seeded RNG.
- `event_list` is consumed by the Quest System (which materializes `Emergent Politburo Events` quests), the War Room UI (which renders the events on the Network Graph), and the EventBus (which broadcasts `politburo_event` for any other listener).
- **Tick scheduling.** The world clock fires `week_advanced` on Sunday midnight in-game. `politburo_sim.gd` consumes the queued input list for the past week and produces the next state.
- **Inputs are summaries, not actions.** Constructed by upstream subscribers as outlined in Rule 2.
- **State snapshot is saveable.** A 100-week-deep save is a 100-element history of `PoliticalState` plus the next tick's input queue. (Practical: most plays don't care about historical states; we save current state + last-N event log for War Room display, not the full history.)
- **Replay debugging.** `tools/replay_politburo.gd` accepts a save and replays from week 0 forward, asserting state equality at each tick. Catches non-determinism early.

Inner Ring is a slow-burn substate: an "Inner Ring Confidence" rolling number per faction the simulation increments based on player intel quality. Endgame trigger when player's accumulated confidence crosses a threshold *and* the player commits to a Final Move. (Per locked design: the player decides when endgame fires.)

### 5.3 Awakening Filter — Cross-Cluster Coupling Without Coupling

Awakening Level (0–10) is read by visuals, audio, dialogue, UI, and gameplay. The architecture avoids each subsystem reading `RPGCore.awakening_level` directly:

- `RPGCore` exposes Awakening Level.
- `EventBus` emits `awakening_level_changed(old, new)` on transition.
- `ThemeManager` subscribes → swaps token state.
- `MusicDirector` subscribes → schedules tier crossfade per active context.
- `InternalVoiceChorus` subscribes → adjusts voice frequency multiplier.
- The post-processing shader reads a uniform set by `ThemeManager`.
- Build-gated content (sneak routes, readable Xyoner symbols) reads via per-scene gate scripts that subscribe to the event.

**Architectural property:** raising Awakening is a single state change. Everything else falls out of subscriptions. No subsystem reaches into another. AI agents adding new Awakening-coupled behavior add a subscriber, never a direct read into another cluster.

### 5.4 Investigation UI — Connection Draw + Publication Commit

These two interactions are the **operational thesis of the game** (UX §2.1). They earn dedicated implementation attention.

#### Connection Draw

- The Physical Board is a `PhysicalBoard` scene with `EvidenceCard` instances pinned to a `Corkboard` background.
- `connection_draw.gd` listens for click-drag from one card to another. On release:
  1. Determine which `SkillCheck` to fire (depends on the evidence types involved — Rabbit Hole / Lore Depth / Glowie Sense / [X] Fatigue per GDD).
  2. Fire `RPGCore.skill_check(skill, dc)` → returns `Critical / Standard / Fail` within 200ms.
  3. Render the appropriate string variant (locked solid red / dashed red / thin uncertain) plus stamp animation.
  4. On Critical, fire an `InternalVoice` interjection with hidden context (a `Line` from the dialogue VM with no graph attached).
  5. Persist the connection (with outcome) to the player's evidence dossier (the **player's own** dossier, not the faction Dossier — see §5.1 caveat below).
- **Failed connections stay placeable.** A failed connection persists as `uncertain`, can be referenced in publication commits at a Credibility penalty, and may have been planted by The Cage (`cage_plant_flag` set).

#### Publication Commit

- The Dossier Interface is a desk scene with cross-reference panels. The player selects evidence + selects framing × platform × audience.
- A **live preview** shows current Credibility delta and Heat delta as the player adjusts the matrix. The preview is computed by the same function that will commit, so what the player sees is what they get.
- The commit button is two-step: `Frame` → `Commit`. The second click is irreversible.
- On commit:
  - `EventBus.evidence_published(framing, platform, audience, evidence_set)` fires.
  - The Faction Dossier ingests it (auto-update with framing-driven impact).
  - Credibility ticks (per audience reach × framing strength).
  - Heat ticks (per faction-relevance × framing aggression).
  - World ripple within one in-game hour: a Feed segment is queued, NPCs in the Reputation Web learn the publication (gossip propagation), faction standing updates.

**Naming clarification (legal-distinctness adjacent):** the **player's own** evidence dossier (`src/investigation/dossier_interface.gd`) is the player's notes — what the player has gathered and can publish. It is NOT the same thing as the **Faction Dossier** (`src/tracking/player_dossier.gd`), which is what the Xyoners know about the player. The naming in this document distinguishes them as **Evidence Dossier** (player-side, investigation cluster) vs. **Faction Dossier** (Xyoner-side, tracking cluster). Future AI agents must not conflate these.

### 5.5 Conversation Log + Dialogue VM

The Conversation Log is a first-class, performance-sensitive subsystem. Per GDD §Success Metrics: <50ms retrieval for any past conversation lookup; <2s gossip propagation tick for 200+ Gnoym.

**Data model:**

- A single global indexed log: `ConversationLog` autoload (membered into `WorldState`, not a true autoload).
- Per-NPC indices: each named NPC's id maps to a list of log entry ids they participated in.
- Per-topic indices: a small set of high-relevance topics (Wellness Center, GnoyNews, named bosses, named recruits) are indexed for fast gossip traversal.
- Entries are append-only during normal play; the Feed editing soundbites *creates new entries* (annotated as `feed_edit_of: <original_id>`), never mutates originals.

**Storage:**

- In-memory: arrays + dictionaries, indexed at write time.
- Persisted: included in the save format (the largest serialized chunk).
- Performance: at 100-week-deep play with average 30 logged conversations per week and 200 Gnoym, the log is on the order of 3000 entries, each ~1KB. ~3MB save chunk. Comfortable.
- **Profiling gate at vertical slice:** synthesize a 6000-entry log, run the gossip tick, assert <2s. If not, GDExtension the indexing layer.

**Dialogue VM** (per §3.8) writes to this log on every committed line that has any of: `quotable`, `faction_relevant`, `incriminating` flag.

### 5.6 Schrödinger's NPC — Dave System

The Schrödinger's NPC pattern (Dave at Greystone) is reusable architecture, not a special case.

- A `SchrodingerNPC` is an `NPC` subclass whose `role_resolved` flag starts `false`. The first qualifying dialogue choice the player makes resolves the role (e.g., `RECRUIT_RESEARCHER`, `IMMOVABLE_GNOY`, `GLOWIE_INFORMANT`).
- `dialogue_runner.gd` checks for `SchrodingerNPC` participants and emits `schrodinger_resolved(npc_id, role)` on the qualifying choice.
- Subsequent encounters with that NPC pull from the role's content table — different dialogue trees, different combat behavior, different role in the Recruit / Reputation / Faction subsystems.
- **The player is never told.** No "role locked!" toast.
- Architecturally cheap: this is just a dispatch on `npc.role`. The novelty is in the design, not the engineering.

### 5.7 Subscription Cancellation as Cross-System Event

Cancelling a subscription (UX Journey 5) is a satirical UX set piece *and* a cross-system event:

- `subscription_cancelled(subscription_id)` fires on `EventBus`.
- Subscribers:
  - `awakening_track.gd` — increments Awakening progress (per GDD: each subscription cancelled = an Awakening Track moment).
  - `player_dossier.gd` (faction side) — adds a `possible_radicalization` flag.
  - `bills.gd` — updates the next monthly deduction.
  - `slop_damage.gd` — schedules a long-term decay of Slop Damage accumulation rate.
  - `MusicDirector` (rarely) — if the cancellation pushes Awakening across a tier, it may schedule a tier-crossfade.
- **Architectural property:** the cancellation is a single user gesture with five system reactions, none of which require the cancellation flow to know about any of them. The EventBus mediates.

---

## 6. Cross-Cutting Concerns

### 6.1 Save System & Schema Versioning

(Augmenting §3.7.)

- **Schema version is a class:** `SaveGameV1`, `SaveGameV2`, etc. Each is a `Resource` with all save-relevant fields and a `migrate_from(prev)` static method.
- **Migrations are required for every schema change.** A build that bumps the schema without a migration is a release-blocker.
- **Save-load test in CI** (added at EA prep): for each historical schema version, a frozen reference save round-trips through current code without data loss.
- **In dev, save-as-text** (`.tres`) for diffability. Release builds use binary (`.res`) for size and minor obscurity.
- **Save-corruption handling.** If load fails: present player with "Recover from yesterday's autosave?" UI, fall back to the most recent valid file, log the failure with full save dump for bug filing.
- **Ironman mode:** exactly one save file, overwritten in-place, deletion on death. No recovery UI.

### 6.2 Logging + Debugging

- `Logger` autoload writes to an in-memory ring buffer (last 10k entries) + an on-disk rolling log (`user://logs/session_{date}.log`).
- Levels: `TRACE / DEBUG / INFO / WARN / ERROR`. `INFO` is shipped default; `DEBUG` enabled by `--debug-logging` CLI flag.
- **Subsystem tags** (`[politburo]`, `[dialogue]`, `[music]`, `[save]`) on every entry for filtering.
- **In-game debug overlay** (F12) at dev builds: shows current Awakening, Heat, Fatigue, day/slot, last 5 Politburo events, current music context + tier, recent EventBus traffic.
- **Crash reporter:** Godot's built-in crash dump + a manual `report_issue.gd` tool that bundles the most recent log file + the most recent save (with PII-free fields stripped if any are added later).

### 6.3 Performance Budgets

(See §1.4 for hard numbers.) Architectural budget allocation:

| Subsystem | Per-frame budget @ 60fps | Per-event budget |
|---|---|---|
| Rendering | ~8ms | — |
| Combat tick | ~4ms (only during encounters) | — |
| AI / NPC routine | ~2ms | — |
| Dialogue VM | <1ms | <50ms per node resolve |
| UI redraw (HUD only) | ~2ms | — |
| **Available headroom** | ~80% of frame | — |
| Politburo tick | — (not per-frame) | <500ms per weekly tick |
| Conversation log lookup | — | <50ms |
| Gossip propagation | — | <2s per weekly tick |
| Save / load | — | <3s save, <5s load |
| Music tier crossfade | — | 4s default fade |

**Profiling gates:**

- **Vertical slice gate:** all per-event budgets validated with synthetic worst-case inputs (100-week save, 200-Gnoym Reputation Web, 6000-entry log).
- **EA gate:** budgets re-validated on Steam Deck.
- **Full launch gate:** budgets re-validated with localization at the most-expanded language (German benchmark for UI; arbitrary for log).

### 6.4 Mod Hooks (forward-look only, not in launch)

Modding is post-launch; do not implement mod runtime in the vertical slice. **The architecture should not foreclose it:**

- All static config is in `Resource` files. A mod system can override resources via path priority (mods override built-in if mod path higher in priority list).
- Politburo simulation is a pure function with a seeded RNG. A mod can swap it cleanly.
- Dialogue is data. Mods can ship new dialogue resources.
- Save format is versioned. Mods can declare save-schema additions; mod-incompatible saves are flagged on load.
- **Forbidden in core code:** hardcoded references to specific dialogues / NPCs / districts / bosses where the reference would break if a mod renamed the asset. Reference by id, not by path-bound type.

This is a future commitment, not a launch promise.

### 6.5 Localization-Readiness

(See §3.11.) Architectural rules:

- All player-visible strings go through `tr()` (Godot's translation function). No raw English literals in UI / dialogue.
- Translation IDs are stable and namespaced. `dialog.greystone.dave_first_meeting.greeting` stays `dialog.greystone.dave_first_meeting.greeting` for the project's life.
- The translation file is the single source of truth; the dialogue YAML references IDs.
- **Lint pass at EA:** `tools/string_lint.gd` walks `src/` for raw English literals in UI/dialogue contexts and fails the build if any are found outside whitelist files (logger / debug / dev tools).
- **UI flex:** every UI component must layout-test against 1.5× English width without clipping. Token-driven layout supports this; a per-component `min_width` / `max_width` token is mandatory.

### 6.6 Accessibility

- **Subtitles on by default** (mandatory per GDD — stealth is partly an audio game; without subtitles, hearing-impaired players lose information).
- **Footstep visual indicators** as an option.
- **Markers Mode** as a settings toggle — surfaces quest markers for accessibility-minded players. Default off, opt-in.
- **Color-blind safe palettes** in HUD (Heat color-coding has shape/position redundancy too).
- **Text scale** option (1× / 1.25× / 1.5×).
- **Reduced motion** option (turns off Awakening filter shimmer, music-deterioration UI glitch, particle-heavy effects).
- **Rebindable input** — every action rebindable, including the irrevocable Publication Commit two-step (re-bindable but cannot be one-button-locked, to preserve the deliberate gesture).
- **Difficulty options** for combat: Hotline-Miami baseline + a "More Forgiving" tier (more BODY headroom, encounter restart preserves more state). Combat tuning is a post-vertical-slice concern.

### 6.7 Testing Strategy

- **Unit tests (GUT)** for: RPG core math (skill checks, derived stats, talent effects), save serialization round-trip, Politburo determinism (same seed + inputs → same state), dialogue VM node resolution, theme token resolution, music tier crossfade math.
- **Integration tests** for: subscription cancellation event chain, evidence publication ripple, encounter restart preserves world state, Schrödinger NPC role-lock.
- **Determinism tests** are mandatory and CI-gated. Politburo non-determinism is a release blocker.
- **Manual playtest plan** at vertical slice and EA gates (use `gds-playtest-plan` skill).
- **No tests required for** purely visual / audio polish; those are reviewed playtest-level.

### 6.8 Asset Pipeline

- **Sprites / character art:** generated via gpt-image-1 (PNG with transparent background). Style consistency relies entirely on a locked style-bible prompt prefix (version-controlled artifact; gpt-image-1 has no reference-image support). Environment backgrounds and tilesets use gpt-image-2 (reference images fed in for consistency). Import filter: `linear` for hand-drawn realistic art; revisit to `nearest` only if art direction locks in pixel style.
- **Audio:** Xyoner-space music — tier 1 via Beatoven.ai (looping instrumental); tiers 2–5 derived offline per per-context DSP recipe (see §3.3). SFX via ElevenLabs Sound Effects V2 as `.wav`. Loop points baked at production time or set via Godot Import settings.
- **Dialogue:** authored in YAML in `dialogue_source/`, compiled to `.tres` at import time by `tools/dialogue_yaml_to_tres.gd`. Writers never edit `.tres`.
- **Localization CSVs:** edited by translators externally, re-imported.
- **Asset budget tracking:** at EA prep, an automated tool reports total asset count + size per category against scope-tier budget targets.

---

## 7. AI Agent Guidance

This section is binding for AI agents (Game Dev, Solo Dev, code-review) implementing this game. Read this before touching code in `src/`.

### 7.1 Locked Architectural Rules

These rules are **architectural decisions of record**. Violating them in a PR is a review blocker. Successor decisions require a documented rev (e.g., `D-DIALOG-01-rev1`) in this document, not a silent change.

1. **Engine: Godot 4.x, GDScript primary.** No C# / Mono. No third-party "RPG framework" addons. Approved addons listed in §2.5.
2. **Three Tracking Systems are code-distinct.** §5.1 Rules 1–4 are non-negotiable. Any code in `src/tracking/` PR requires a re-read of `src/tracking/README.md`.
3. **Politburo Simulation is deterministic + seeded + pure-function.** No file I/O, no autoload reads inside the tick. (§5.2)
4. **Awakening Filter is event-driven via EventBus.** No subsystem reads `RPGCore.awakening_level` directly. Subscribe to `awakening_level_changed`. (§5.3)
5. **Conversation Log is append-only.** Feed edits create new annotated entries; they do not mutate originals. (§5.5)
6. **Dialogue VM is the only runtime for dialogue.** Composure-HP boss encounters use the same VM; no special-case code paths. (§3.8, §5.5)
7. **Music deterioration is multi-version files + crossfade.** Tiers 2–5 may be derived offline from tier 1 via a per-context DSP recipe; never apply runtime DSP. (§3.3)
8. **Save format is versioned with mandatory migrations.** Schema bump without migration = release blocker. (§6.1)
9. **Strings go through `tr()`.** Raw English literals in UI/dialogue contexts fail the EA-prep build lint. (§6.5)
10. **Theme tokens, not hardcoded styles.** UI components consume tokens; literals are a code smell. (§4.4)
11. **No per-cluster reach-around.** Cross-cluster communication routes through `EventBus` or autoload mediators. Direct sibling-reference is a smell. (§4.6)
12. **Player Evidence Dossier ≠ Faction Dossier.** Naming distinction is binding. (§5.4)

### 7.2 Forbidden Patterns

- Storing per-NPC personal memory inside `src/tracking/player_dossier.gd`.
- Importing from `src/tracking/reputation_web/` into `player_dossier.gd` outside `interrogation_bridge.gd`.
- Reading the player-action graph inside `politburo_sim.gd`.
- Mutating a `ConversationLog` entry after creation.
- Adding a third-party UI library or web-tech-in-engine wrapper.
- Mocking the Politburo simulation in unit tests (test the real function with synthetic inputs and seeds).
- Adding manual save support outside Ironman's existing semantics. (Day-boundary autosave is the design; a manual-save option would re-enable save-scumming the dialogue system.)
- Hardcoded magic numbers outside `core/balance/balance.tres`.
- `await` chains in the Dialogue VM that block the main thread for >16ms.
- Swallowing errors silently. Always log; surface to user only when user-actionable.

### 7.3 Code-Review Checklist (binding)

When reviewing a PR that touches `src/`:

- [ ] No new raw English string literals in UI / dialogue contexts.
- [ ] No new direct cross-cluster reads (look for imports across `src/<cluster_a>/` ↔ `src/<cluster_b>/` that aren't via `EventBus` or an autoload).
- [ ] If the PR touches `src/tracking/`, the PR description references §5.1 and confirms which Rule applies.
- [ ] If the PR adds a new subsystem state that affects play, save schema bump + migration is included.
- [ ] If the PR adds an autoload, it is justified in the PR description (autoload count ≤ 12 per §4.5; adding requires removing or merging).
- [ ] If the PR touches the dialogue VM or Conversation Log, performance is asserted (<50ms node resolve, <50ms log lookup).
- [ ] If the PR touches the Politburo, a determinism test is added or updated.
- [ ] Magic numbers route through `Balance`.
- [ ] Tests for any new pure logic (RPG math, save migrations, sim functions).

### 7.4 Files of Record

Future agents looking up canonical behavior should consult these files in order of precedence:

1. **This document** (`_bmad-output/game-architecture.md`) — architectural decisions of record.
2. **GDD** (`_bmad-output/gdd.md`) — locked design.
3. **UX Spec** (`_bmad-output/planning-artifacts/ux-design-specification.md`) — locked UX.
4. **Narrative Design** (`_bmad-output/narrative-design/index.md`) — locked narrative.
5. **Game Brief** (`_bmad-output/game-brief.md`) — locked vision and scope.
6. **`src/tracking/README.md`** (created at Story 0) — legal-distinctness contract for the Three Tracking Systems.

If two documents conflict, this document defers to the GDD/Brief/UX/Narrative for design intent and supersedes them only on **technical realization** decisions.

### 7.5 Open Architectural Questions

These are deferred; not blocking the start of implementation.

1. **GDExtension language for hot-loop escape valve** — C++ vs. Rust. Decide if/when a hotspot validates the need.
2. **Save file encryption / tamper resistance** — none at launch (single-player, no leaderboards). Revisit if competitive Ironman ladders ever appear.
3. **Mod runtime layer** — out of launch scope; revisit post-launch.
4. **VO pipeline at scale** — internal voice VO is post-vertical-slice; the pipeline (Wwise vs. Godot-native bus routing) is a content-volume question, not a launch-1 question.
5. **Console certification specifics** — deferred to porting partner (W4 Games or equivalent) when the time comes.
6. **Multiplayer / co-op modes** — out of scope, locked. Reopen requires a Brief revision.

---

## 8. Acceptance Criteria

This document is **complete and ready for use** when:

- [x] Engine and language are locked (§2.1, §2.3).
- [x] All seven subsystem clusters from §1.3 have an implementation pattern in §3 or §5.
- [x] The Three Tracking Systems legal-distinctness rules are explicit (§5.1).
- [x] Politburo determinism + tick model is locked (§3.10, §5.2).
- [x] Music deterioration runtime is locked (§3.3).
- [x] Folder layout, naming conventions, autoload registry, and event bus conventions are documented (§4).
- [x] AI Agent guidance with locked rules + forbidden patterns + review checklist is documented (§7).
- [x] Performance budgets per subsystem are listed (§6.3).
- [x] Open architectural questions are explicitly deferred (§7.5) — they do not block implementation.

**The architecture is implementation-ready.** Next planning artifact: `/gds-create-epics-and-stories` (epics already sketched in GDD §Development Epics — that section becomes the input).

---

## 9. Document Stewardship

- **Owner:** Cpain.
- **Reviewers:** future Game Architect agent on revisions; Game Dev / Solo Dev agents during implementation.
- **Revision protocol:** named decisions (`D-*`) are revised by appending `-rev1`, `-rev2`, etc. to a successor entry in the same section. The original is never silently overwritten.
- **Version history:**

| Version | Date | Author | Notes |
|---|---|---|---|
| 1.0 | 2026-05-03 | Cpain (with Game Architect agent) | Initial complete architecture. Engine: Godot 4.x. Nine sections complete. Implementation-ready. |

