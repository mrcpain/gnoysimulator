# Narrative Delivery

> **Foundational design rule:** narrative delivery must respect Pillar 2 — *"every playthrough is unique. The awakening path is available, never mandatory."* This means delivery methods must support both 5-hour Sleep runs and 80-hour Public Reckoning runs without breaking the texture of either. Narrative is *available*, not *imposed*.

---

## Cutscenes

**Cutscene philosophy:** *Minimal, in-engine, real-time-rendered, always skippable, never QTE-driven.* Cutscenes exist for the small set of authored beats that genuinely cannot be conveyed through systems and gameplay. **Every cutscene is a confession that systems failed to deliver the moment** — so the bar for a cutscene is high.

| Cutscene | Type | Length | Style | Skippable | Notes |
|---|---|---|---|---|---|
| **The Doctored Feed Segment (Beat 2)** | Diegetic in-engine | ~60-90s | TV-on-screen, player watches in apartment | First time: no. Subsequent NG+ playthroughs: yes. | Inciting incident. The TV plays a doctored news segment. The player's only interactivity is whether to keep watching or turn away. |
| **Awakening Level 1 cinematic (Beat 3)** | Internal-monologue style | ~30s | First-person POV through player character's eyes; Inner Voices speak for the first time | Yes | The crack. The first inner voice speaks. |
| **Awakening Level 5 cinematic (Beat 4)** | Internal-monologue style | ~45s | Same POV style, expanded voice chorus | Yes | The AntiXyonetic label canonized. |
| **Awakening Level 10 cinematic (Beat 6)** | Internal-monologue style | ~90s | Full Inner Voice chorus; the player's accumulated build is reflected back | Yes | The emotional climax. Music deterioration at peak. The world the player started in is unrecognizable. |
| **The Inner Ring Betrayal Reveal (Beat 5)** | Dialogue-scene-cinematic | ~3-5 min | Dialogue tree with cinematic camera; the only "long" cutscene | First time: no. Replay: yes. | The Kishōtenketsu twist. Player can interrupt with dialogue choices. Dossier UI surfaces in real-time during the reveal. |
| **The Five Endings (Beat 7)** | Per-ending coda + credits sequence | 4-8 min each | Mixed in-engine + montage; ending-specific style | Always skippable | Each ending gets the same compositional care. Sleep ending coda is structurally co-equal. |
| **Awakening cinematic missed-beats (per Step 3 Threshold Jump Behavior)** | Flashback-frame style | ~15-20s | Brief retroactive memory cue when player jumps past an Awakening cinematic threshold | Yes | Preserves authored beat integrity for skip-threshold edge cases. |

**Style:**

- **In-engine, real-time-rendered.** No pre-rendered FMV. Cutscenes use the same art assets and palette logic as gameplay, including the Awakening Filter — *the cutscenes themselves visually deteriorate as Awakening rises.*
- **No QTEs. No interactive cutscene puzzles.** Interactivity in cutscenes is limited to dialogue choice in the Betrayal Reveal scene and skip-input.
- **Always skippable** (with the two locked exceptions: first-play Doctored Feed Segment and first-play Betrayal Reveal). Skip preserves player agency. Replay-skip respects time on NG+ runs.
- **Music deterioration applies inside cutscenes.** A player at Awake 8 watching the Awakening Level 1 cinematic flashback will hear the L1 cinematic's music in its degraded state — a moment of retroactive horror.

**Total authored cutscene minutes (estimate):** ~25-40 minutes across the entire campaign, ending sequences inclusive. **Disco Elysium has approximately zero traditional cutscene minutes; this is more, but still tight by RPG standards.**

---

## In-Game Storytelling

> Comprehensive coverage in **Step 6 (Dialogue Framework)** and **Step 7 (Environmental Storytelling)**. This section captures the *delivery balance* and *interruption philosophy*, not the methods themselves.

### Primary Methods (cross-reference)

- **Dialogue with NPCs** (Step 6) — branching, skill-gated, conversation-log weaponized.
- **Inner Voices** (Step 6) — internal monologue chorus, scaling with Awakening + Fatigue + Cope.
- **Environmental visual storytelling** (Step 7) — set dressing, props, color/lighting, character-design tells.
- **Audio storytelling** (Step 7) — ambient design, music deterioration, sound-as-gameplay.
- **Found documents** (Step 7) — forum posts, news segments, faction documents, anonymous tips, personal artifacts.
- **The Investigation UI** (Investigation Layers 1-3 from GDD) — Physical Board / Dossier Interface / Thought Cabinet. *The investigation interface IS storytelling.* Cross-referencing two pieces of evidence with a string is a narrative beat.
- **Politburo Simulation events** — surfaced via news segments, NPC dialogue, environmental tells. The world's narrative motion *is* gameplay.
- **Reputation Web ripples** — gossip propagation across NPCs is a slow narrative mechanic.

### Show vs. Tell Balance

**~95% show, ~5% tell.** The 5% telling happens in:

- The 7 cutscenes above (locked authored beats).
- The Inner Voices (which are still "show" of the protagonist's inner state, but technically narration).
- The opening tutorial's contextual silent demonstrations ("A Perfectly Normal Morning," Beat 1) — show-by-doing, but with the lightest possible authorial framing.

**The remaining 95% is system-emergent**: dialogue the player initiates, environmental details the player notices, documents the player chooses to read, news segments the player chooses to watch, gossip the player chooses to listen to.

### Interruption Approach

**Minimal forced interruption.** The game does not stop the player to deliver story unless the locked authored beat absolutely requires it. Three interruption tiers:

| Tier | Interruption Type | Frequency |
|---|---|---|
| **Hard interrupt** | The 7 cutscenes (mostly skippable). Cage-raid forced encounters. Endgame Trigger commitment. | ~10-15 hard interruptions across a full Awakened playthrough. |
| **Soft interrupt** | NPC initiates dialogue (player can decline most). Politburo Simulation event surfaces in the Feed. Recruit personal-quest invitation. | Variable per playthrough; many are missable. |
| **Pull-only** | Player initiates: dialogue, document reading, evidence cross-reference, news segment viewing. | Player-controlled entirely. The dominant mode. |

**Sleep-run players experience near-zero interruption tier above pull-only.**

### Player Control

- **Skip:** Always available for cutscenes (with two first-play exceptions).
- **Speed:** Dialogue auto-advance toggleable. Reading speed configurable.
- **Markers Mode:** Optional accessibility setting that surfaces objective markers (off by default, per Brief).
- **Quest Journal:** Character's own notes, not auto-task list. Can be ignored entirely.

---

## Optional Content

> Per Brief: *"7 quest types running in parallel; no markers default."* Most narrative content in Gnoy Simulator is optional. The game's structural commitment is that *the awakening path is available, never mandatory*.

### Optional Content Categories

| Category | Source | Required? | Estimated Volume |
|---|---|---|---|
| **Faction Boss Investigations** | 13 boss arcs across 5 factions | All optional. The player can complete 0, 1, or all 13. Endgame can trigger at any number completed. | 13 distinct investigations, variable depth |
| **Recruit Personal Quests** | 7 specialist roles + named instances | Optional. Each recruit has a personal quest available; declining doesn't lose the recruit but caps loyalty ceiling. | ~10-20 recruit personal quests at full launch |
| **Emergent Politburo Events** | Politburo Simulation generated | Player chooses whether to engage with each surfaced event. | Variable per playthrough; ~50-100 surfaced events across a full campaign |
| **Reputation Web Side Quests** | Slopside-tier NPCs with personal Gnoy stories | All optional. Background depth. | ~30-60 side quests |
| **Awakening Track Story Beats** | Some authored, some triggered | The authored beats fire if the player crosses the threshold. The Sleep player crosses few thresholds. | 3 cinematics + multiple in-world events per level |
| **District Liberation Goals** | Per-district faction-pushback objectives | Optional. Liberation is a milestone, not a gate. | 12 districts × multiple goals each |
| **Forum Side Threads** | Underground forum, distributed across the campaign | Background lore + side quest hooks. | ~150-200 threads at full launch |
| **Cage Black Site infiltrations** | Late-game, GHOST-build favored | Optional even in Awakened playthroughs. Recruit rescue is the primary motivator. | ~5-10 distinct sites |
| **Sleep-Path Beats (Step 3)** | S1-S5 | The Sleep playthrough's authored beats. | 5 Sleep-specific beats |

### Notable Absences

- **No achievements / collectibles UI.** The Brief is explicit: no markers, no auto-log. The player who reads documents and cross-references evidence is rewarded by the gameplay opening up, not by external pop-ups.
- **No "true ending" hidden behind 100% completion.** All 5 endings are co-equal. The Public Reckoning isn't more "true" than the Sleep ending.
- **No NG+ unlocked story content.** NG+ exists (skip-cutscenes enabled, build-knowledge carries over conceptually). No content gated behind multiple playthroughs.
- **No DLC hooks built into the base game.** The Brief identifies post-launch as "possible secondary"; the NDD makes no promises that would constrain DLC scope.

---

## Ending Structure

> The 5 endings are locked from the Brief and elaborated across Steps 2-3 (act structure, transformation arcs). This section captures the *delivery mechanics* of how endings fire, branch, and credit-roll.

### Number of Endings

**5 distinct endings + 1 implicit "soft fail."**

| # | Ending | Trigger | Coda Style |
|---|---|---|---|
| 1 | **The Public Reckoning** | Endgame triggered with Awakening 8+, Multiple Factions COMPROMISED+, Credibility above-threshold despite high Heat | Bittersweet credits + epilogue: world acknowledges the truth at terrible personal cost. |
| 2 | **The Shadow Replacement** | Endgame triggered with Awakening 7+, Disposition skewed toward OPERATOR/REBEL, Inner Ring slot accepted | Morally compromised credits + epilogue: the player has *become* the system. |
| 3 | **The Burn** | Endgame triggered with Awakening 9+, Disposition heavily REBEL, Multiple recruits lost, low Cope | Destructive catharsis credits + epilogue: the player dissolves their own life into the act of destruction. |
| 4 | **The Long Game** | Endgame triggered with Awakening 8+, distributed cell network online, Heat managed, Cope sustained | Patient melancholy credits + epilogue: permanent underground network operation, decades-long resistance horizon. |
| 5 | **The Sleep** | Sustained low-Awakening, low-Heat, fully-subscribed lifestyle for an extended in-game duration (Beat S5) | Quiet defeat credits + epilogue: the world the player started in remains the world they end in. **Co-equal to the others.** |
| — | **Soft Fail (implicit)** | Player character dies permanently in Ironman mode, or accumulates max Slop Damage in any mode | Brief credits: "they ate the slop. they watched the feed. they did not survive long enough to do anything else." |

### Ending Triggers

**Endgame Trigger (Beat 23) is player-decided, not auto-fired.** The player declares "I'm doing this now" via an interaction at the Compound (or the Apartment, for Sleep ending). The 5-ending branch resolves from the player's accumulated state at the moment of trigger:

- **Awakening Level** — gates which endings are available
- **Faction Standing** (per faction) — affects Public Reckoning vs. Shadow Replacement vs. Long Game weighting
- **Disposition Axes** (GNOY↔AWAKE, PASSIVE↔REBEL) — affects Burn vs. Long Game weighting
- **Recruit count + Loyalty** — affects which credits epilogue specifics fire
- **Cope state** — affects Burn vs. Long Game eligibility
- **Specific late-game choices** (Inner Ring slot offered/accepted, Compound approach style) — final disambiguation

### Ending Variety

**Drastically different**, not minor variations. Each ending has:

- A unique credits sequence (~4-8 min)
- A unique epilogue structure showing the world post-trigger
- Per-character fate update (Dave, each named recruit, key bosses) — surfaces ending-conditional outcomes
- A unique audio register (per Step 7 audio direction — Sleep ending restores McXyon's jingle to undeteriorated form, etc.)

**The fate of every named NPC the player interacted with appears in their ending epilogue.** Dave's fate is shown. Each recruit's fate is shown. Each defeated boss's role-replacement is shown. The Sleep ending shows Dave growing older next to the player.

### True Ending? (No)

**No "true," "golden," or "canonical" ending.** This is structurally enforced:

- The Brief's tonal commitment ("the game judges nothing") forecloses a canonical correct ending.
- The Truth Paradox theme requires that even The Public Reckoning is morally compromised.
- The Sleep ending's structural co-equality (Step 3) forecloses framing it as "the bad ending."
- **Reviewers should be briefed** (per Brief Risk Assessment): Sleep is a *feature* of the design, not an "early-out" or a "joke" ending.

### Replayability

- **Schrödinger's NPC (Dave) alone gives 3 distinct first-encounter playthroughs.**
- **5 endings × build identity (~5 viable build archetypes) = ~25 meaningfully distinct runs.**
- **Playthrough length variance:** 5-10 hours (Sleep) to 100+ hours (completionist Awakened). The game supports both as primary play patterns, not "speedrun vs. main."
- **Mole identity choice (Step 4 open question) becomes most visible across multiple playthroughs.** A True Believer Mole player will see anonymous-tip evidence patterns differently on second playthrough; a Cynic Mole player will see the cold detachment land more sharply.
- **No content is locked behind multiple playthroughs.** Replayability is in the variation of identity, not in unlocking new content.

---

## Production Notes (carried forward to Step 10)

- **Cutscene budget:** ~25-40 authored minutes total, in-engine real-time-rendered. **No FMV / pre-rendered required.** This is a cost win versus typical AAA narrative-RPG cutscene scope.
- **Ending sequences:** 5 codas × ~4-8 min each = ~20-40 minutes of ending content. **The Sleep ending must receive the same compositional care as the others** — production scope must reflect this, not treat Sleep as a stub.
- **Per-ending epilogue authoring:** named-NPC fate updates require per-ending state-conditional writing. **This is the highest-density single-section writing in the game** outside boss dialogue. Estimate: 5-10k words per ending × 5 endings = 25-50k words just for endings.
- **Optional-content scope:** ~80% of total content volume is optional. **Vertical slice content priority should reflect this** — optional-content authoring patterns must be locked early, not treated as Phase 3 nice-to-haves.
- **No achievements UI / NG+ content scope:** **architecture/scope wins.** No achievement system to design, no NG+ content to author. Capture in scope estimates.

---
