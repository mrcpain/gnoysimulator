---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
inputDocuments:
  - "_bmad-output/game-brief.md"
  - "_bmad-output/brainstorming-session-2026-05-03.md"
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 1
  projectDocs: 0
workflowType: "gdd"
lastStep: 14
project_name: "goySimulator"
user_name: "Cpain"
date: "2026-05-03"
game_type: "Top-Down 2D Investigation/Simulator/Action RPG"
game_name: "Gnoy Simulator"
status: "GDD v1.0 — Source for Architecture & Epics"
source: "Built from locked Game Brief + Brainstorming session — no re-elicitation per user directive"
---

# Gnoy Simulator — Game Design Document

**Author:** Cpain
**Game Type:** Top-Down 2D Investigation / Simulator / Action RPG
**Target Platform(s):** PC (Steam) — Windows / Linux primary; Steam Deck / macOS / Switch likely secondary; PS5 / Xbox tertiary
**Document Status:** v1.0 — source-of-truth for Architecture and Epics phases
**Source Inputs:** [Game Brief](game-brief.md) · [Brainstorming Session](brainstorming-session-2026-05-03.md)

---

## Executive Summary

### Core Concept

**Gnoy Simulator** is a satirical top-down 2D RPG set in an alt-Earth present-day dystopia controlled by a malignant oligarch class — the Xyoners — whose grip is maintained through fast food, social media addiction, wage slavery, religious extremism, debt, and surveillance. The player begins as a fully-compliant **Gnoy Wageworker** — eating slop, doom-scrolling the feed, clocking into a job at a company that does nothing — until a staged news event cracks their reality open. From there, the game becomes a freeform investigation-simulator-action hybrid: document the Xyoner network, recruit the awakening, survive Heat, and decide what to do with the truth.

The game fuses three genres on a single RPG skeleton:

- **Investigation Layer** (Disco Elysium × Return of the Obra Dinn): Three-layer evidence UI, skill-checked deductions, publication framing, internal monologue.
- **Simulator Layer** (Persona × Stardew Valley): Day cycle, finite action slots, monthly bills, homebase progression, recruit relationships.
- **Action Layer** (Hotline Miami × Deus Ex): Real-time top-down combat with extreme lethality, capture-vs-yield, signature satirical weapons.

The signature design innovation is the **Truth Paradox** — the more correct your evidence, the more dangerous and discredited you become simultaneously. Three interacting meters (NPC Trust / Credibility / Heat) make *framing* the core skill expression. The **Dossier / Politburo Simulation / Reputation Web triad** creates a living, adaptive enemy faction system that is structurally distinct from Warner Bros' Nemesis patent (US 10,926,179). The **Music Deterioration Mechanic** has corporate jingles in Xyoner spaces audibly corrupt as the player's Awakening Level rises — by Level 7, McXyon's brand music sounds like a damaged file.

### Target Audience

**Primary:** The Disco Elysium / Obra Dinn / Papers Please / Pentiment / Citizen Sleeper CRPG-investigation crowd (ages ~22–40). Players who want deep dialogue with real consequence, reading-heavy lore-dense gameplay, politically literate satire that bites, investigation as a core mechanic, permadeath/Ironman-friendly replay, and signature mechanics they can describe to friends.

**Secondary:** The Hotline Miami / Katana Zero action audience (drawn by the combat layer); the Stardew / Persona / Spiritfarer rhythm audience (drawn by the day-cycle); and the Cruelty Squad / LISA / Disco-adjacent edgy-indie meme audience (drawn by tone and the cultural hook).

**Tertiary overlap:** "Just want to be left alone" simulator players (Stardew, Story of Seasons), CRPG build-craft players (Pathfinder, Pillars of Eternity), and longform-content streamers and YouTubers (the Schrödinger's NPC, multiple endings, and music deterioration are clip-friendly).

### Unique Selling Points (USPs)

1. **The Truth Paradox** — no shipping game punishes correct evidence with discrediting. The single most defensible design innovation.
2. **The Dossier / Politburo / Reputation Web triad** — legally distinct nemesis-equivalent that is thematically superior (a surveillance bureaucracy, not a personal nemesis).
3. **The Music Deterioration Mechanic** — the player audibly hears manufactured consent corrupt as they wake up.
4. **Subscription cancellations as mechanical awakening** — shedding the slop economy *is* the awakening, mechanically represented.
5. **The Schrödinger's NPC system (Dave)** — the first dialogue choice with one NPC permanently determines that character's role across the entire campaign without the player knowing.
6. **The Sleep ending** — a major RPG that lets you give up, eat slop, watch the feed, and credits-roll years later asleep. Most RPGs cannot ship this; this one structurally requires it.
7. **Build-gated world geography** — sneak routes, internal voices, readable Xyoner symbols, and deeper map overlays all unlock with character growth. The Full Gnoy and the Awakened player are playing different games on the same map.
8. **The satire IS the mechanics** — not narrative satire over generic gameplay. The systems themselves are the critique.

---

## Goals and Context

### Project Goals

- **Ship a satirical RPG that makes the player viscerally feel the texture of modern manufactured consent** — the snooze button, the auto-deducted subscription, the Feed segment about "anti-Xyonetic extremists," the cheerful billboard. Then offer them a complete RPG with which to fight, document, exploit, or surrender to it.
- **Implement the Truth Paradox as a fully integrated game system**, not a narrative gesture: every meaningful publication should produce a visible, traceable Credibility-vs-Heat consequence in the world.
- **Implement the Dossier / Politburo / Reputation Web triad as distinct, owned engineering subsystems** that can be defended legally and balanced independently.
- **Hit Disco-Elysium-tier dialogue depth with skill voices, visible DCs, and weaponized conversation logs** while remaining tractable through tooling and tiered dialogue scope.
- **Deliver Hotline-Miami-grade combat feel inside an RPG context** — extreme lethality with stat modulation, capture as alternative to death, world-state persistence between encounter restarts.
- **Enable five distinct endings, including The Sleep**, all reachable through systemic play rather than scripted gating.

### Background and Rationale

The investigation-RPG niche (Disco Elysium, Obra Dinn, Pentiment, Citizen Sleeper) is established and underserved. The political-satire RPG slot has been largely vacant since Fallout: New Vegas (2010). The intersection of (a) modern media-criticism subject matter, (b) a full RPG simulator, (c) signature unique mechanics, and (d) Hotline-Miami-grade action-loop credibility positions this title in a genre intersection currently unoccupied.

The game's central premise — that the systems themselves enact the satire — is what differentiates it from a "satirical narrative on top of a generic RPG." Subscription cancellations *are* the awakening. Slop healing *is* the system rewarding compliance with long-term decay. NPC Mode degrading at high Fatigue *is* the cost of clarity. Mechanics don't illustrate the theme — they *are* the theme.

The setting is alt-Earth present-day. Recognizable but slightly wrong. Not sci-fi, not historical, not post-apocalyptic. The Xyoners are a fictional malignant ruling class — not tied to any real ethnic or religious group. Satire is **equal-opportunity**, ideology-targeted not religion-targeted: the Pulpit faction includes the Settlement Ideologue (Christian/Jewish-coded religious nationalism), the Jihadist Franchise Operator (Muslim-coded extremism), and the Prosperity Prophet (American megachurch grift) side by side, all funded by ecumenical Vault charity chains.

---

## Core Gameplay

### Game Pillars

1. **The Satire IS the Design.** Every mechanic must reinforce the thematic point or be cut. If a mechanic does not serve the satire, it does not ship.
2. **Simulator First, Story Second.** Every playthrough is unique. The awakening path is available, never mandatory. Living a full Gnoy life is a valid run. The systems generate the player's story; the player does not follow a scripted one.
3. **Build-Gated World Access.** More Awake = more map (sneak routes), more dialogue (internal voices), more world (readable Xyoner symbols, deeper map overlays). The character growing literally changes what game is being played.
4. **Truth Has a Cost.** The Truth Paradox is the spine. Mechanics that contradict it — that reward truth in conventional ways — get cut. Framing is the skill expression.
5. **The World Doesn't Revolve Around the Player.** The Politburo Simulation runs whether the player acts or not. NPCs have routines. Press cycles play whether the player tunes in or not. Missing things is possible — cold cases are harder, not impossible.

### Core Gameplay Loop

The loop runs on three nested timescales:

#### Micro Loop (Minutes)

> **Follow a thread → Find a piece → Decide what to do with it.**

Player encounters a lead (forum post, overheard dialogue, evidence drop, recruit tip). Player investigates the lead in real-time gameplay (talk, sneak, fight, deduce). Player obtains a piece of evidence or a connection. Player decides: stamp it, file it on the Physical Board, draw a connection (skill check), publish it (Dossier Interface), share it with a recruit, sit on it. Each decision feeds the macro state.

#### Meso Loop (One Session — One In-Game Day)

> **Day cycle (Morning / Afternoon / Evening / optional Night) + Heat drama + thread resolution.**

Player wakes. Snooze button costs the morning slot silently. Player allocates each slot to job, surveillance, investigation, recruitment, combat ops, broadcasting, recovery, or social. Heat per-district rises and falls based on actions. Sleep advances the world clock; the Politburo Simulation ticks; subscriptions auto-deduct on schedule. Quitting the job opens the day but spikes financial pressure until alternative income covers rent.

The session arc is **push-then-retreat**: pursue threads aggressively until Heat forces dark, then transition to maintenance, recovery, relationship tending, district rotation. The game's core breathing rhythm.

#### Macro Loop (Campaign — Full Run)

> **Awakening arc + faction destruction + Inner Ring endgame.**

Awakening Track 1 → 10. Faction Standing UNKNOWN → OWNED across five factions. Boss investigations resolved (or ignored). Recruits gained, lost, broken, defected. Districts liberated or surrendered. The Politburo's own evolution overlaps with player action. Endgame triggers when the player decides — no game-driven ending push. Five endings are reachable from systemic state, not scripted gating.

### Win/Loss Conditions

**Gnoy Simulator has no traditional win/loss state.** It has *endings*. The player chooses which ending they reach, and the game allows all of them.

**Five Endings:**

| Ending | Disposition Trigger | Mechanical Trigger | Tone |
|---|---|---|---|
| **The Public Reckoning** | AWAKE + REBEL, high Web | Coordinated mass exposure: high Reputation Web + Reach + awakened Gnoym network. Failure path = total destruction (saved dead-drop messages trigger posthumously). | Heroic-tragic |
| **The Shadow Replacement** | REBEL + PASSIVE | Player accumulates enough Inner Ring leverage to *replace* rather than expose. System continues with player at the top. | Bleak |
| **The Burn** | AWAKE + REBEL, low Web | Pure destruction. Sabotage every faction simultaneously. Outcome uncertain — the system collapses, what fills the vacuum is unknown. | Chaotic |
| **The Long Game** | High SOUL + high Web + Touch-Grass-leaning play | Player disappears. Sets up successors. Credits show a new character years later picking up elsewhere. | Hopeful, implicit sequel |
| **The Sleep** | GNOY + PASSIVE, sustained | Player gives up. Stops investigating. Eats slop. Watches the feed. Game allows this. Credits show character years later, completely asleep. | Most disturbing |

There is **no game-over from death** — combat death sends the player to the previous autosave (day boundary or key event). Permanent loss applies to **recruits** (Cage raids, broken under interrogation, defected to Glowie work, voluntary exit). Permanent loss applies to **operatives destroyed** (dead Xyoners stay dead; their *role* gets succession-filled). Permanent loss applies to **published evidence** (you cannot un-publish; the Feed has cached it).

The player can also reach an effective dead-end by collapsing every variable simultaneously: Credibility = 0, all recruits dead, all districts at max Heat, no funds. The game does not auto-end — the player must select the Sleep ending (or burn out trying to recover). This is a feature.

---

## Game Mechanics

### Primary Mechanics

This section lists the headline systems. Each system has an expanded definition section later in the document.

- **7 Attributes** + **6 Derived Stats** + **24 Skills** + **40 Talents** across 7 archetypes
- **2 Disposition Axes** (GNOY↔AWAKE, PASSIVE↔REBEL) and an **Awakening Track** (Levels 1–10)
- **Day Cycle** with finite action slots and monthly survival pressure (rent + slop subscriptions)
- **Heat System** tracked per-district
- **Hotline-Miami Combat** with capture mechanic and faction build counter-system
- **15-slot Equipment system** with set bonuses across 5 quality tiers
- **Three-Layer Investigation UI** — Physical Board, Dossier Interface, Thought Cabinet — plus War Room (HQ Stage 3+)
- **Connection Mechanic** — skill-checked evidence linking with three outcomes
- **Dialogue System** — visible-DC / hidden-consequence skill checks, internal voices, item-drop, dialogue-as-combat
- **Three Tracking Systems** — Player Dossier, Politburo Simulation, Reputation Web
- **7 Quest Types in Parallel** — markers off by default, journal as character notes
- **4-Stage Homebase Evolution** — Apartment → Office → Underground HQ → Distributed Network
- **Recruitment System** — organic + mission-based, 7 specialist roles, ongoing loyalty as a resource
- **Music Deterioration Mechanic** — corporate music in Xyoner spaces corrupts with Awakening Level

### Controls and Input

**Primary input target:** mouse + keyboard (PC, Steam Deck Verified pipeline). Controller support is a secondary but mandatory target for console viability.

**Default Mouse + Keyboard scheme:**

| Action | Input |
|---|---|
| Movement | WASD |
| Sprint | Shift (hold) |
| Sneak / Crouch | Ctrl (toggle) |
| Interact / Talk | E |
| Aim / Target | Mouse |
| Primary Attack / Use | Left Mouse Button |
| Secondary / Block / Special | Right Mouse Button |
| Quick-Throw (signature weapons) | Q |
| Reload / Pickup | R |
| Dodge / Roll | Space |
| Camera Phone (Receipts) | F |
| Inventory | I |
| Map / Navigation | M |
| Evidence Board | B |
| Dossier (what they know) | J |
| Character / Skills / Talents | C |
| Quest Journal (character notes) | L |
| Pause / System Menu | Esc |
| Quick-Save (key event only) | F5 |
| Day-End / Sleep (when at homebase) | T |

**Combat-mode bindings** (auto-engaged on Hotline-Miami encounter): WASD movement, mouse aim, LMB attack/fire, RMB heavy/throw, Space dodge, Q signature weapon, E pickup-weapon-from-floor, F YIELD prompt when downed, Shift ATTEMPT ESCAPE prompt when downed.

**Dialogue-mode bindings:** number keys 1–9 select skill-gated dialogue lines, mouse click works equivalently, skill-check overlay shows visible DC and required skill, hover reveals which skill is being checked.

**Investigation UI (mouse-first):** drag-and-drop pinning on the Physical Board; hold-to-draw-string for connection mechanic; click-to-stamp on Dossier Interface; click-to-process on Thought Cabinet threads.

**Controller scheme** (specified at architecture phase): full mappings provided post-prototype, but the design assumes radial menus for the stat-attribute screens, snap-targeting in combat (with stat-modulated assist strength tied to Hands), and a context-action button that adapts to investigation / combat / dialogue mode.

**Accessibility:**
- **Markers Mode** — optional objective pins on the map (off by default; on for accessibility)
- **Combat Difficulty Tuning** — Hotline-Miami lethality tunable (encounter-restart only / day-rewind / forgiving-mode); the locked design supports all three so the curve scales for players who bounce off the action layer
- **Text Sizing & High-Contrast Modes** — required for the heavy reading volume
- **Subtitle / Caption Toggle** — required for the audio-game stealth elements (so the visually-audio-dependent design has parity for hard-of-hearing players)
- **Hold vs. Toggle** — every hold input has a toggle alternative

---

## RPG Architecture

### Attributes (7 Core)

| Attribute | Gnoy Flavor | Covers | Range |
|---|---|---|---|
| `BODY` | How wrecked by slop | Physical capability, melee, endurance, hit threshold | 1–10 |
| `MIND` | Pattern recognition, research | Investigation, hacking, uncovering Xyoner trails | 1–10 |
| `SOUL` | Moral compass, intuition | Seeing through deception, resisting propaganda | 1–10 |
| `MOUTH` | Social power | Persuasion, rhetoric, broadcast quality | 1–10 |
| `GHOST` | Off-grid-ness | Stealth, evasion, digital footprint reduction | 1–10 |
| `GUT` | Resilience | Slop tolerance, mental endurance, resist manipulation, capture-resilience | 1–10 |
| `SIGNAL` | Underground connectivity | Network reach, resistance contacts, pirate broadcast range | 1–10 |

**Default Starting Distribution (Wageworker):** BODY 4, MIND 2, SOUL 2, MOUTH 3, GHOST 1, GUT 5, SIGNAL 0. Total 17 starting points (rest distributable). The "Full Gnoy" position — high physical compliance and stress tolerance, blind to patterns and the underground.

**Attribute Cap:** 10. Reached only via cumulative talent investment + endgame items. Starting cap (without items/talents) is 8.

### Derived Stats (7)

| Derived Stat | Formula | Gameplay Role |
|---|---|---|
| `Credibility` | (SOUL + MOUTH) + bonuses from successful publications | Public trust resource. Lost on weak/wrong publications. Required threshold for some endgames. |
| `Heat` | inverse(GHOST) per district + recent action footprint | Operative attention. Tracked per-district. Forces dark periods. |
| `Awareness` | MIND + SOUL | Floor for skill checks involving pattern recognition; gates some dialogue & internal voices. |
| `Slop Damage` | Cumulative — slow-tick from slop consumption, reduced by Anti-Slop / Gymmaxx | Long-term BODY/MIND degradation. Can be detoxed but not fully ignored. |
| `Reach` | SIGNAL + MOUTH | How far published content travels. Determines audience size for publications. |
| `Fatigue` | Passive accumulation per Xyoner-pattern confirmation; reduced by genuine rest | Tension stat (see Fatigue Tension System below). Rises over a run; resets on extended rest. |
| `Cope` | (GUT + SOUL) − recent overwork | Mental resilience. Drops from sustained ops without rest. Low Cope = penalties + voice flooding. |

**Cope rules** (MDA Gap Fix #1): Pushing too hard without rest drops Cope. At low Cope: internal voice frequency spikes to overwhelming, all skill checks get a −2 penalty, social interactions take additional Credibility risk on failure, NPC Mode rolls are at −3. **Recovery:** a *genuine* off-day at homebase (no investigation slot, no ops slot, no publication action). Eating slop does not restore Cope — it restores BODY and adds to Slop Damage. Rest is mechanically necessary, not flavor.

**Fatigue Tension System:**

| Fatigue Level | Upside | Downside |
|---|---|---|
| **Low (0–25)** | NPC Mode works fully, blend in cleanly | Slow pattern recognition, miss Xyoner tells, [X] Fatigue at base |
| **Medium (26–50)** | Solid pattern spotting, [X] Fatigue +1 | Cracks appearing in normie disguise; NPC Mode −1 |
| **High (51–75)** | Instant recognition, near-psychic Glowie Sense, [X] Fatigue +3 | NPC Mode −3; visibly jaded; Recruit small-talk awkward |
| **Max (76–100)** | See the whole system clearly, all pattern skills +5 | NPC Mode nearly unusable (−6); other Gnoym think YOU are unhinged; Reputation Web "talks crazy" tag spreads |

**Fatigue is a feature, not just a debuff.** A Maxed-Fatigue character is a *better investigator* and a *worse operator*. Recovery is intentional design — choose when to be sharp and when to be sociable.

### Skills (24)

Skills attach to attributes. Every skill has a 0–10 ladder. Most skill checks are `attribute + skill + situation modifier vs. visible DC`.

#### MIND Skills

| Skill | Description |
|---|---|
| `Rabbit Hole` | How deep you can go before losing the thread. Long-form research, nested document chains, all-night session yield. |
| `[X] Fatigue` | Trained leverage of cynical pattern recognition. Sees Xyoner tells in mundane phrasing. Scales with Fatigue. |
| `Doxcraft` | Digging up and exposing digital trails. The aggressive form of investigation: deanonymization, leaked records, address-from-photo. |
| `Edit Farm` | Fabricating convincing cover. Faking normie content, doctoring evidence to slip past the Feed, reverse-engineering Xyoner production. |

#### SOUL Skills

| Skill | Description |
|---|---|
| `Glowie Sense` | Detecting shills, fed posters, controlled opposition. Required to identify infiltration in your own network. |
| `Yap Game` | Quality of public argument and delivery. The skill behind a persuasive publication, broadcast, or speech. |
| `Lore Depth` | Understanding Xyoner theology, symbols, history. Reads encrypted documents, religious-extremist signaling, banker dog-whistles. |
| `Based Talk` | Waking up specific individuals through real conversation. Required for organic recruitment and Awakening-spreading dialogue. |

#### MOUTH Skills

| Skill | Description |
|---|---|
| `Rizz` | Raw social magnetism and one-on-one influence. Charm path, flirtation path, "make them like you" path. |
| `NPC Mode` | How convincingly you perform as a compliant Gnoy. Required for infiltrating Xyoner spaces and avoiding suspicion at high Fatigue. |
| `Ratio` | Publicly crushing someone's credibility or morale. Counter-narrative work, demolishing opposing publications, reducing target Composure in dialogue-as-combat. |
| `Clout` | How far your content travels and how hard it hits. Caps Reach, modifies Credibility delta on publication. |

#### GHOST Skills

| Skill | Description |
|---|---|
| `Ghost Mode` | Physical and digital invisibility. Stealth movement, sneak-route eligibility, dropped-camera evasion. |
| `Normie Cosplay` | Passing as compliant inside Xyoner-adjacent spaces. Different from NPC Mode in dialogue — this is the *visual* / *behavioral* skill. |
| `Receipts` | Gathering and storing undeniable evidence. Camera-phone work, document-secure storage, chain-of-custody. |
| `OPSEC` | Staying glowie-proof under active Xyoner pressure. Determines dossier-update *delay* — how long before the Cage realizes what you did. |

#### BODY Skills

| Skill | Description |
|---|---|
| `Gymmaxx` | Physical capability, counteracts Slop Damage. Combat speed/dodge, climbing routes, escape rolls. |
| `Hands` | When dialogue fails. Damage, disarm, finishing moves, implicit-threat dialogue paths. |
| `Anti-Slop` | Detoxing from Gnoy diet, recovering BODY/MIND stats. Required for Slop Damage reversal beyond minimum threshold. |
| `IRL Build` | Making physical tools, devices, gear. Crafting at homebase, signature-weapon assembly, repair. |

#### SIGNAL Skills

| Skill | Description |
|---|---|
| `Web` | Size and quality of underground contacts. Modifier on recruit-discovery rolls; gates introductions to specialists. |
| `Ghost Protocol` | Keeping communications invisible to Xyoners. Required for encrypted evidence backup; reduces evidence-seizure risk on capture. |
| `Sneaky Links` | Physical information handoffs, untraceable. Dead drops, courier work, off-grid finance routing. |
| `Signal Hijack` | Taking over Xyoner broadcast infrastructure. Gates pirate broadcast capability and Engagement Architect/Settlement Ideologue boss tactics. |

### Disposition Axes (2)

Player position is plotted on two orthogonal axes that emerge from action history, not direct selection. The axes gate ending eligibility.

- **Axis 1 — `GNOY ←——→ AWAKE`**: Asleep / compliant ↔ Eyes open / resistant. Movement: subscriptions cancelled, evidence published, Awakening Track levels, anti-Xyoner dialogue choices.
- **Axis 2 — `PASSIVE ←——→ REBEL`**: Documenting / hiding ↔ Active confrontation. Movement: combat ops vs. publication-only ops, capture vs. kill, broadcast vs. dead-drop.

A player can be `AWAKE + PASSIVE` (Disco-Elysium-style documentarian), `AWAKE + REBEL` (active resistance), `GNOY + PASSIVE` (Sleep-ending material), or `GNOY + REBEL` (rare, dangerous chaos profile — anti-system but unawakened, nihilist energy).

### Awakening Track (Secondary Progression — Mythic Equivalent)

Levels 1–10. Progression: in-world events and player choices grant Awakening Track ticks. Each level unlocks one or more world-state changes.

| Level | Trigger Class | What Unlocks |
|---|---|---|
| 1 | First witnessed staged event ("A Perfectly Normal Morning" → The Incident) | Cinematic moment. Sense staged events before they happen (subtle UI tell — Receipts auto-prompt at suspicious gatherings). |
| 2 | First subscription cancelled OR first publication made | In-world event + internal monologue. Voices begin to whisper (low frequency). |
| 3 | First Faction Standing reaches OBSERVED OR first recruit organic | In-world event + internal monologue. Xyoner propaganda has diminished effect on dialogue options (skill check DCs reduce on resist-propaganda paths). |
| 4 | First boss investigation completed | In-world event + internal monologue. Internal voices include skill-specific commentary in major dialogues. |
| 5 | Half of factions reach OBSERVED OR Stage 3 Homebase unlocked | **Cinematic moment.** Read Xyoner theological symbols and encrypted documents (Lore Depth threshold met passively — symbols become readable in environment). |
| 6 | First recruit lost / broken / defected OR first ASSET-tier faction standing | In-world event + internal monologue. Sneak Routes start appearing on map. |
| 7 | Second boss group completed OR Reputation Web > 30 named | In-world event + internal monologue. Gnoym who meet you have passive chance of partial awakening from conversation alone. **Music deterioration audibly severe in Xyoner spaces.** |
| 8 | Inner Ring Confidence reaches MEDIUM | In-world event + internal monologue. Stage 4 Homebase (Distributed Network) unlocks. |
| 9 | Inner Ring Confidence reaches HIGH OR all 5 factions reach ASSET+ | In-world event + internal monologue. Endgame paths visibly preview in War Room. |
| 10 | Endgame trigger | **Cinematic moment.** ??? — endgame revelation; ending-specific. |

**Music Deterioration mapping** (locked):
- Awakening 1–2: 100% clean original tracks
- Awakening 3–4: occasional wrong note (~1 per minute), slight pitch wobble in Xyoner spaces
- Awakening 5–6: jingles skip mid-loop, audible audio-compression artifacts, brand stings sound *off*
- Awakening 7: corrupted-file sound — dropouts, glitch artifacts, distorted McXyon's brand audio
- Awakening 8–9: tracks struggle to render; silence between glitches
- Awakening 10: corporate music collapses entirely — endgame audio takes over

**5 deterioration tiers** (1–2 / 3–4 / 5–6 / 7 / 8–10) — composer pipeline target. Smooth crossfade between tiers, never jarring.

### Talents (40 across 7 Archetypes)

Talents are **earned via levelling and unlocked via talent-point spend**. Each character pick gates more available picks; some are mutually exclusive. Talent details below are locked archetype + name; full balance numbers (rates, ranges, durations) finalize during architecture/balance pass.

#### Combat (9)

| Talent | Effect (locked design intent) |
|---|---|
| **Built Different** | BODY +1 effective for hit threshold; high-Slop Damage stops counting against melee bonus. |
| **Hands Like Bricks** | Hands skill +2; melee crits inflict bleed (DoT). |
| **Ghost Strike** | First strike from Ghost Mode counts as crit; if it kills, no alarm raised. |
| **No Hesitation** | Combat reaction window narrows: enemy aim-up time +20%, your aim-up time −20%. |
| **Improviser** | Every interactable object in combat scenes counts as a usable weapon (chair, fire extinguisher, bottle). |
| **Crowd Control** | Heavy attacks knock back grouped enemies; stuns 1.5s. |
| **Last Stand** | At 1 BODY, melee damage doubled until exit-or-down. |
| **Blood Rush** | Killing in melee restores 1 BODY and 5 Cope; capped per encounter. |
| **Weapon Juggler** | Weapon swap costs no time; can hold three "primary" rotation slots. |

#### Stealth / Infiltration (6)

| Talent | Effect |
|---|---|
| **Ghost in the Machine** | Cage cameras lose the player's signature for 20s after Ghost Mode break. |
| **Habitual Liar** | NPC Mode does not degrade with Fatigue at the same rate (offset by 25 Fatigue). |
| **Normie Supreme** | Full civilian outfit + Normie Cosplay = +3 to passing as a Gnoy in Xyoner spaces. |
| **Smoke and Mirrors** | Distraction objects (Slop Bag, Camera Flash) have 2× radius. |
| **Digital Ghost** | Per-district Heat decay rate +50% during downtime slots. |
| **No Footprint** | OPSEC dossier-update delay extended by 1 in-game day per qualifying action. |

#### Information Warfare (6)

| Talent | Effect |
|---|---|
| **Copium Immunity** | Internal voices cannot be silenced by Feed counter-propaganda (Feed segments mocking your work) — they keep speaking truthfully. |
| **Dead Man's Switch** | If captured at Stage 3+, queued evidence auto-publishes if you do not return within 48h. |
| **Viral Moment** | One publication per chapter qualifies for Reach +200%. Player chooses which. |
| **Algorithm Crack** | Signal Hijack output bypasses Feed throttling for 24 in-game hours. |
| **Fact Stack** | Connection Mechanic: chained successes (3+ in row) grant a free verified connection. |
| **Counter-Narrative** | Every Feed counter-publication against you costs *them* Credibility instead of you (mirror effect). |

#### Network / Social (6)

| Talent | Effect |
|---|---|
| **Touch Grass** | Cope recovery from rest doubled; Sleep-ending eligibility +1 weight. |
| **Paranoid** | Glowie Sense floor +2; one free Glowie-detection check per recruit per week. |
| **Trust Fall** | Recruit Loyalty decay rate halved when offline. |
| **Handler Instinct** | Handler specialist unlocks 2 awakened-but-not-recruited Gnoym slots additional. |
| **Six Degrees** | Web skill range extended — every recruit's Web counts toward yours at 25% rate. |
| **Open Source** | Receipts evidence is shareable to Reputation Web in batch — gossip propagation +50%. |

#### Awakening (5)

| Talent | Effect |
|---|---|
| **Slop Resistant** | Slop Damage tick rate halved. |
| **Pattern Lock** | Once a Xyoner pattern is confirmed once, future instances auto-flag (no [X] Fatigue check needed). |
| **Third Eye** | Awakening Track gains +1 from in-world events (faster awakening climb). |
| **Red Pill Dealer** | Based Talk dialogue path costs no Cope. |
| **Cannot Be Gaslit** | Internal voice: a permanent voice that contradicts Feed propaganda in real-time. |

#### Economy / Resources (5)

| Talent | Effect |
|---|---|
| **Off the Books** | Off-grid finance (Quartermaster routing) immune to Cage tracking. |
| **Evidence Hoarder** | Inventory evidence cap +50%; encrypted backup cost halved. |
| **Scavenger** | Improvised weapons in combat hit for +25% damage. |
| **Black Market Prince** | Underground-tier and Resistance-crafted gear cost 30% less. |
| **Seized Assets** | Defeating bosses converts a portion of their assets to player off-grid finance. |

#### Wildcard (3)

| Talent | Effect |
|---|---|
| **NPC Brain** | At any point, may temporarily convert a SOUL skill check to a MOUTH check (and vice-versa) once per day. |
| **Whistleblower's Luck** | One per chapter: a publication that would fail rolls a free "barely succeeds" instead. |
| **They Can't Kill the Truth** | If player dies in combat with unpublished evidence, on respawn that evidence remains and gains a Credibility-protection buff if published next. |

**Talent Acquisition rules:**
- Talent points awarded per Awakening Track level + per faction reaching OBSERVED + on every other Skill Level milestone.
- A player with focused investment can fully complete one archetype + dabble in two others in a single playthrough — radical specialization is supported and incentivized.
- Wildcard talents are unique each per-playthrough (3 picks total of 3 — they interact strangely; replay value).

---

## Investigation System (Three Layers)

The investigation system is a first-class subsystem with three distinct UIs operating in parallel.

### Layer 1 — The Physical Board (Homebase Wall, Always Visible)

A conspiracy board pinned to the wall of the player's current homebase. Pins, strings, photos, documents, sticky notes. Player physically (in-game) drags evidence onto the board, draws connections between items, scrawls margin notes. The board scales with homebase progression — a kitchen-table mess at Stage 1, a wall in Stage 2, a multi-wall war-room build at Stage 3. The board is the macro picture of the investigation.

The board is **diegetic UI** — the camera reframes when interacting with it; players see their character standing in front of it, gesturing.

**Capacity:** technically infinite items pinned, but visual real estate at each homebase stage is finite and signals scope. Stage 1 ≈ 30 items; Stage 4 (network) = distributed boards across cells with cell-specific subboards.

### Layer 2 — The Dossier Interface (Per Evidence Item)

A desk-style UI opened per piece of evidence. Documents can be opened side by side, cross-referenced, stamped (`Verified` / `Uncertain` / `Planted`). The interface is where formal case-file building happens.

**The publication interface lives here.** Player packages evidence into a publishable unit, choosing:

- **Platform** — forum / pirate broadcast / flyer / graffiti / direct-message-to-recruit / dead-drop-to-press / leak-to-rival-faction
- **Framing angle** — accusation / question / investigation / leak / personal testimony / parody
- **Target audience** — algorithmic Gnoym / disaffected workers / underground / Xyoner rivals

A **preview** shows predicted Credibility-vs-Heat delta before commit, modulated by the relevant skill (Yap Game / Clout / Receipts / [X] Fatigue) and the evidence's stamping. **Commit triggers in-world ripple effects** in real-time: NPC reactions, Dossier updates, Reputation Web shifts, possible Feed counter-narrative, possible Cage operative dispatch.

This is the workflow the **Truth Paradox** lives in: weak evidence → low Credibility loss but visible loss; strong evidence → high Credibility gain but spiked Heat. There is no "free truth-telling."

### Layer 3 — The Thought Cabinet (Character's MIND — Disco-Elysium Equivalent)

Mental "threads" the character is working on. New information unlocks new threads. Processing a thread costs **time** (an action slot) but yields **conclusions** that reframe existing evidence or unlock dialogue lines.

**Limited active threads simultaneously.** Stage 1 = 2 active. Stage 2 = 3. Stage 3+ = 5. Talents and high MIND can extend this.

**Awakening Track reveals new interpretations of existing evidence.** A document filed at Awakening 1 means something different at Awakening 7. The Thought Cabinet auto-flags evidence whose interpretation has shifted with the player's level. This is the system that makes the *act of awakening* literal — the world (and the player's understanding of it) materially changes as they grow.

### Connection Mechanic (Skill-Check Based)

Player draws a string between two evidence pieces on the Physical Board. A skill check fires using the most relevant skill:

| Connection type | Skill |
|---|---|
| Behavioral patterns | `[X] Fatigue` |
| Document / research chains | `Rabbit Hole` |
| Xyoner theology / symbols | `Lore Depth` |
| Detecting planted / false evidence | `Glowie Sense` |
| Generic floor | `MIND` (base attribute) |

**Three outcomes:**

| Roll | Outcome | Effect |
|---|---|---|
| Critical Success | **Confirmed + hidden context revealed** | Connection drawn; bonus reveal — third document, hidden name, unlocked date, side-thread spawned. |
| Standard Success | **Confirmed** | Connection drawn; verified on board; clean Credibility tick when published. |
| Fail | **Drawn but uncertain** | Visible as a dotted line; publishable but at Credibility penalty; the game does not tell you it's wrong. |

**Wrong connections stay ambiguous.** The Cage plants false evidence specifically to trigger this mechanic. Publishing a wrong connection = Feed weaponizes it against the player's Credibility (counter-publication).

**Investigation accuracy is a skill expression, not a guarantee.** A high-MIND player makes fewer mistakes; a high-Glowie-Sense player detects planted material; a low-stat player can still publish — they just risk weakening their Credibility.

### The War Room (HQ Stage 3+, Analyst-Managed)

A tabbed/paneled UI accessible only at Stage 3+ Underground HQ. Five panels in parallel:

- **Network Graph** — operative connections, faction relationships, current hierarchy state. Updated by Politburo ticks.
- **Map Overlay** — geographic distribution of active Xyoner operations, by district.
- **Live News Ticker** — what The Feed is pushing this cycle. Current narrative operations, including ones targeting the player.
- **Heat Map** — player's Heat distribution across districts, color-coded.
- **Dossier Panel** — what the Xyoner network currently knows about the player, classified on threat axes (Reach, Awareness, Heat, Embarrassment Caused).

**Inner Ring Confidence Indicator** (MDA Gap Fix #3): styled as an intelligence-report block — *"Based on current evidence, we believe we've identified [X] of the Inner Ring members with [low/medium/high] confidence."* The player decides when X is sufficient. No game prompt tells them to act. The indicator updates as evidence accumulates and as the Analyst processes connections in the background.

**The Analyst recruit (Stage 3+)** passively flags potential connections for the player to confirm. Introduces a *trust variable* — if the Analyst is a Glowie (gotten to by the Cage), some flags are misdirection. Glowie Sense checks on the Analyst are recommended periodically.

---

## Combat System (Hotline Miami DNA)

### Combat Feel

- **Real-time, top-down, ultra-fast, extreme lethality.**
- **Instant restart within an encounter** — death sends to encounter start, not save.
- **World state persists between encounter restarts** — which doors broken, which evidence found, which corpses generated all carry forward.
- **Sound design as a weapon** — enemy footsteps audible before visible; combat music palette signals threat tier.
- **Stats modify parameters, never invincibility.** BODY raises hit threshold (more shots-survived) but never makes the player a tank. Gymmaxx raises speed/dodge. Hands raises damage / disarm. Ghost Mode enables stealth first strike.

### Capture Mechanic

When BODY hits 0 in combat, the player enters **Downed State**. Two choices:

| Option | Resolution | Cost |
|---|---|---|
| **YIELD** | Guaranteed capture | A GUT check determines how much player intel feeds into Xyoner Dossier. High GUT = minimal damage; low GUT = significant intel leak. |
| **ATTEMPT ESCAPE** | GHOST + Gymmaxx check, context-modified DC | On success: escape, but with bonus per-district Heat. On fail: worse outcome — captured + extra dossier damage + possible recruit exposure if a recruit was in fight. Some gear (Smoke and Mirrors talent, smoke grenade) bypasses the check. |

**Captured player flow:** transferred to a Cage holding location (off-map). Player must escape via gameplay (sneak/dialogue/contact-broadcast/Dead-Man-Switch trigger). This is its own scenario type — typically one or two per Heat-cycle. Failure to escape = lose evidence and recruit-coordinates carried at time of capture.

### Faction Build Counter-System

The Xyoner Dossier reads player **build patterns** and dispatches counter-tactics. Examples (locked design):

| Player pattern | Faction response |
|---|---|
| Always ghost / stealth-only | The Cage deploys thermal sensors in high-Heat districts; thermal vision in some operatives. |
| Always broadcast / Signal Hijack heavy | The Feed builds counter-narrative faster (2× counter-publication speed); deploys Engagement Architect's "throttle" tactic. |
| Always melee / direct combat | The Cage deploys ranged-only operative squads in high-risk Heat scenarios. |
| Heavy publication / public exposure | The Feed pre-emptively floods topic with adjacent-but-misleading content (Information Warfare countermove). |
| Heavy recruit / network builds | The Cage runs a Glowie-conversion op against a randomly-flagged recruit. |

The counter-system is a **dossier classifier + tactical-response abstraction layer** in code. The classifier reads recent player actions (rolling window) and outputs a build-tag; the tactical-response layer maps build-tag → operative loadout / Feed campaign / Cage tactic. Documented architecture target: clean separation between classification and response so balance tuning is tractable.

### Goyslop Healing (Locked Tension)

Slop restores **BODY immediately, no in-moment penalty**. This is not a debuff in combat — it heals fast, like a real first-aid item.

The cost is **Slop Damage**, a separate slow-accumulation track that ticks long-term consequences: BODY/MIND attribute drift downward, Cope reduction, visible character art changes (skin, posture). Slop Damage can be reversed by Anti-Slop / Gymmaxx investment, but never to zero.

The player who heals with slop in every fight is *fine* mid-combat. They are not fine over the campaign. The system rewards short-term compliance with long-term decay. **The satire IS the mechanic.**

### Evidence as Combat Resource

Evidence is a **physical inventory item** — it can be seized on capture. Players who plan combat ops while carrying critical evidence are taking a real risk. The **Ghost Protocol** skill unlocks encrypted remote backup at homebase — capture loses the physical copy but the digital one survives. Investing in this skill is a strategic choice.

### Weapons

#### Melee (locked roster)

Pipe wrench, baseball bat, crowbar (dual-use lock/door break), combat knife, security baton, brass knuckles, chain, hammer, fire extinguisher, skateboard, shovel (dual-use evidence burial), broken bottle, heavy book.

#### Non-Lethal (locked roster)

Taser, tranq syringe (melee/silent), tranq dart gun, pepper spray, rubber bullet pistol, smoke grenade, flashbang, sleep gas canister, sedative-laced food (trap), net launcher.

#### Ranged Lethal — Massive Heat (locked roster)

Suppressed pistol, standard pistol, shotgun, submachine gun (only seized from Cage), sniper rifle, improvised zip gun. Ranged use spikes Heat dramatically — these are not for everyday encounters. They exist for boss runs and emergencies.

#### Thrown / Traps

Molotov, rock/brick, throwing knife, distraction objects.

#### Signature Weapons (Gnoy Simulator's Tonal Signature)

These are **not joke weapons** — they are tactically distinct and central to the satirical aesthetic. Each is craftable, throwable, and tied to specific encounter types.

| Weapon | Effect |
|---|---|
| **Evidence Brick** | USB / dossier thrown at targets. Gnoym stop to read it (stunned 4s; some turn; some flee). Cage radios it in (distracted 2s — used to interrupt a call-for-backup). |
| **Slop Bag** | Fast-food bag thrown as distraction. Gnoym break to eat it (stunned 6s; very high stun; absurd; perfect). Cage operatives ignore it. |
| **Megaphone** | Broadcasts truth at Gnoy-tier enemies. Chance to make them hesitate, defect, or flee. Useless vs. Cage. Scales with Yap Game + Clout. |
| **Signal Jammer (combat)** | Cuts Cage backup calls. Buys 30s window without reinforcements. Cage adapts (next encounter spawns with redundant comms). |
| **Camera Flash** | Blinding (4s blind in cone) + simultaneously captures Receipts evidence of confrontation. Dual-use. |
| **Fake ID Packet** | Thrown into a Cage encounter, causes identity-verification chaos. NPCs verify each other's IDs (~10s). Buys escape window. |

### Combat Engagement Tiers

| Tier | Encounter | Player Goal | Failure Cost |
|---|---|---|---|
| Routine | Drunk Gnoy, mugger, single Cage patrol | Survive / extract evidence | Day-rewind autosave |
| Operative | Cage squad on patrol, faction enforcer | Survive + minimal Heat | Bonus Heat in district |
| Capture-Op | Cage raid scenario | Escape + protect recruits | Recruit captured / killed |
| Boss Phase | Final encounter for combat-eligible boss | Defeat boss | Boss escapes; second-attempt window opens with higher difficulty |
| Endgame Set-Piece | Inner Ring confrontation | Ending-specific | Ending-specific |

---

## Equipment System (15 Slots, Set Bonuses)

### 15-Slot Layout (WoW-Style)

Head, Face, Neck, Shoulders, Chest, Wrist, Hands, Waist, Legs, Feet, Back, Accessory 1, Accessory 2, Main Hand, Off Hand.

### Quality Tiers

| Tier | Stat Profile | Heat Profile | Source |
|---|---|---|---|
| **Gnoy-grade** | Default starting clothing | None | Available at Stage 1 / starting outfit |
| **Standard** | Modest stat bumps | None | Purchased / found common |
| **Underground** | Solid stats, resistance-flavor | None | Underground market / recruit specialist craft |
| **Resistance-crafted** | High stats, custom set-bonus eligibility | None | Stage 2+ Crafter recruit |
| **Xyoner-seized** | Highest stats | **Raises Heat to carry** | Looted from boss / faction operations |

Xyoner-seized gear is a **design-intentional risk-reward tradeoff**. Wearing the dead Innovation Czar's tactical jacket grants the best stats in the game and a permanent Heat bump for the wearer. Worth it for some builds; ruinous for stealth-focused ones.

### Set Bonuses

Outfit combinations grant **set bonuses**. Locked design intent:

| Set | Composition | Bonus |
|---|---|---|
| Full Civilian | All visible slots Gnoy-grade or Standard | Normie Cosplay +3 / NPC Mode +2 / Heat decay +20% |
| Full Tactical | All combat slots Resistance-crafted or Xyoner-seized | Combat damage +20% / movement speed +15% / **all social skills −5** (zero social viability — visibly armed) |
| Hidden Operator | Civilian outer + tactical hidden | Combat +10% / NPC Mode −1 (some bulk shows) / unique skill: weapon-pull from concealment +1 turn |
| Press Cover | Camera + civilian + sturdy boots + dossier-bag | Receipts +3 / Doxcraft +2 / passes light Cage checkpoints |
| Underground Standard | Mix Underground tier across 8+ slots | Web +1 / underground-market discount +10% |

Sets are **discoverable** — the game does not list "set bonus available" until the first set bonus is achieved. Players experiment; recruits and forum lore hint.

### Equipment Slot Rules

- **Main Hand / Off Hand** — weapons or shield-equivalent (fire extinguisher, evidence dossier, dual-wield knives). One-handed combos enable simultaneous wield. Two-handed weapons (bat, sniper rifle) lock the off-hand.
- **Accessory 1 / Accessory 2** — burner phone, pirate radio receiver, voice recorder, jamming device, encrypted laptop, religious symbol (passes Pulpit Quarter checkpoints).
- **Back** — backpack tier (capacity), evidence bag (Receipts +1), tactical sling (signature-weapon quick-deploy), nothing.

### Stat Modifiers via Equipment

Equipment can grant flat attribute bonuses (`+1 BODY`), skill bonuses (`+2 Receipts`), Heat modifiers (`+5 / -5 Heat passive`), and unique abilities (`Camera Flash crafted into glasses → quick-deploy`).

---

## Day Cycle & Survival Pressure

### Day Structure

| Slot | Default Gnoy Use | Awake Player Use |
|---|---|---|
| Morning | Clock into job (mandatory pre-quit) | Surveillance before work, check overnight Dossier updates, brief recruit check-in |
| Afternoon | Work shift / lunch slop run | Skip out (risk: paycheck cut + flag), tail a target, attend Xyoner public events |
| Evening | Doom-scroll Feed, order delivery | Investigate, meet contacts, compile evidence, publish |
| **Night (optional, risky)** | Sleep (safe) | Break-ins, dead drops, pirate broadcasts — high reward, fast Heat |

**Snooze Button** — sets the alarm later. **Costs the morning slot silently.** First system lesson in the opening sequence.

**Sleeping** — ends the day. Restores Cope partially (a *genuine off-day* — no investigation/publication action all day — restores it more). Advances world clock. Politburo Simulation ticks. Subscriptions auto-deduct on schedule.

**Action Slots are Resource Slots.** A slot can be spent on:
- Investigation (follow a thread, work the Physical Board, process Thought Cabinet thread)
- Publication (Dossier Interface workflow)
- Combat / Op (Hotline-Miami encounter)
- Social (recruit relationship, Reputation Web maintenance, Based Talk)
- Maintenance (Anti-Slop detox, Gymmaxx training, gear crafting, homebase improvement)
- Cover (work shift / public Xyoner event attendance — reduces Heat decay debt)
- Rest (literal off-day — Cope recovery)

**Quitting the Job** — major milestone. Day fully opens but financial pressure spikes until alternative income covers rent. Alt income: network pays for intel, pirate broadcast monetizes, Xyoner money seized in operations.

### Survival Pressure (Light, Thematic)

**Monthly bills:**
- Rent — flat per homebase tier
- Slop subscriptions (each cancellable; each cancellation = Awakening Track moment + Feed dossier flag):
  - SloppFlix (streaming)
  - McXyon's DeliverEasy (food delivery)
  - FeedGram Premium (social media)
  - GnoyGym (unused gym; player has not visited since the prologue)
  - FeedBoost Supplements (auto-shipping wellness scam)
- Optional: vehicle insurance, debt servicing (Vault dossier weight if defaulted)

**Each subscription cancelled** = (a) Awakening Track tick, (b) Feed dossier flag ("possible radicalization"), (c) severance of one Feed-data input the algorithm uses to model the player.

**Full Gnoy player is bled dry monthly.** Most income consumed by subscriptions + slop + rent. Endgame Awakened player has near-zero recurring expenses. **Shedding the slop economy IS the awakening, mechanically.**

### Heat System

**Per-District Tracking.** Heat is tracked separately for each of the 12 districts. Color-coded HUD indicator (cool blue → orange → red → flashing red).

**Heat sources:**
- Public publication (per-district scaled by district faction dominance)
- Combat operations
- Subscription cancellations (small Feed-flag, district-of-residence)
- Recruit ops
- Tail-detection
- Boss investigation activity
- Dead-Man-Switch triggers

**Heat consequences (escalating):**

| Heat Level | District Effect |
|---|---|
| Cool | Standard NPC behavior; sneak routes available; civilian stops normal |
| Warm | More Cage patrols; civilian stops occasional; Reputation Web rumors increase |
| Hot | Cage checkpoints active; civilian stops with paper-checks; Receipts checks at exits |
| Burning | Cage operations active in district — combat encounters spawn; recruits in district at risk |
| Flashing Red | District lockdown; Player presence triggers events; recommended evacuation |

**Cooldown.** Heat decays during downtime slots (cover work, social slots, rest). District rotation is the core mature-gameplay strategy: hot ops in The Plaza, cool off in Slopside, Plaza Heat decays.

**Heat is the breathing rhythm of the campaign.** Push, retreat, push, retreat. Players who run constantly hot in one district collapse it; players who never run hot anywhere never advance.

---

## Three Tracking Systems (Legally Distinct from US 10,926,179)

The three systems together replace the WB Nemesis mechanic with a thematically superior — and structurally distinct — design. **All three must be implemented as separate engineering subsystems.** The legal-distinctness constraints apply at code level, not just narrative.

### System 1 — The Player Dossier

**Single shared file maintained by Xyoner network intelligence.** ALL operatives read the same dossier. There is no personal NPC memory inside the faction system.

**Dossier Contents (locked schema intent):**
- Threat axes: `Reach`, `Awareness`, `Heat`, `Embarrassment Caused` (each ranked numeric)
- Build classifier tag: `Ghost / Broadcast / Hands / Grifter / Mixed / Unknown`
- Known associates (recruits the dossier has flagged)
- Known operations (publications attributed, ops attributed)
- Open warrants / standing orders
- Suspected aliases / cover identities (NPC Mode work)
- Plant flags ("evidence planted, awaits ingestion")
- Last-update timestamp + delay-debt (OPSEC modifier)

**Dossier Updates:**
- Operative reports (combat ops, observed publications)
- Leaks (other-faction interference)
- Published evidence (auto-ingest with framing-driven impact)
- Informant reports (Glowies, broken recruits)
- Reputation Web ingestion (interrogated Gnoym → dossier gossip → dossier verbatim quotes)

**OPSEC delay** — the player's OPSEC skill / Stealth talents introduce *delay* between action and dossier update. A high-OPSEC player can complete an op and have it not register on the dossier for several in-game days.

### System 2 — The Politburo Simulation

**Independent political simulation that runs whether the player exists or not.**

**Tick rate:** weekly (in-game). Coarse-grained and tractable.

**Simulation contents:**
- 13 Boss Operatives, each with:
  - Power score
  - Faction position (rank)
  - Allies / rivals (intra-faction + cross-faction)
  - Blackmail debts (who owes who)
  - Current operations (each tied to public-visible activity)
  - Succession status (alive / eliminated → role in succession)
- 5 Faction Hierarchies (Trough / Feed / Pulpit / Cage / Vault) with internal politics
- Inner Ring (size locked endgame — to-be-finalized in narrative pass)
- Cross-faction relationships (locked: Vault never fully hostile; Cage-Feed pre-existing rivalry — useful for manipulation)

**Weekly Tick Outputs:**
- 0–3 Politburo events (auto-generated from current state — promotions, betrayals, blackmail moves, public scandals)
- Updated Network Graph in War Room
- New Emergent Politburo Quests (player can intervene / document / ignore / exploit)

**Player-as-Input:** the player's actions feed the Politburo as inputs. Eliminating the Innovation Czar opens an Innovation Czar succession event (next tick: Soil Baron's lieutenant promoted; rival lieutenant tries to derail; Cage may interfere). The player did not "promote" the lieutenant — the simulation did, given the input vacuum.

**Operative Permanent Loss (Player A confirmed):** boss operatives can be permanently destroyed. Their *role* gets succession-filled by the simulation. The individual is gone forever.

**Hidden-hand gameplay (Player B confirmed):** the player can manipulate internal politics indirectly. Plant false dossiers, leak to rivals, exploit Cage-Feed rivalry. The simulation responds per its own rules; outcomes are not scripted.

### System 3 — The Reputation Web

**Gnoym NPCs personally remember the player.** This is the layer where individual NPCs DO have personal memory — but it is **outside the faction hierarchy**, so it is legally distinct from the Nemesis patent. The faction system has no personal memory; the civilian population does.

**Reputation Web Contents (per Gnoym in-orbit):**
- Quotes from past conversations (verbatim or paraphrased, per dialogue weight)
- Rumors heard about the player (propagated by gossip)
- Trust level toward the player (per past dialogue choices)
- Recent shared events (witnessed publications, witnessed ops, etc.)

**Gossip propagation** — Gnoym talk to each other. Reputation spreads through the population at simulation tick rate. A rumor planted with one Gnoym in The Hollow can take weeks to reach a Gnoym in The Cubicle Belt.

**Interrogation Bridge** (the structurally significant linkage): when the Cage interrogates a Gnoym the player has spoken with, that Gnoym's personal memory of the player **flows verbatim into the Player Dossier**. The Reputation Web is the entry vector by which civilian observation becomes faction intel.

**Implications:**
- Player conversations have *real consequence*. NPCs quote you back weeks later.
- Cage interrogations matter. A Gnoym who saw you publish is a vector.
- Recruit Loyalty matters even pre-recruit — Gnoym you've talked to are part of the threat surface.
- The conversation log is a live system — every meaningful conversation is recorded, retrievable, weaponizable, editable by the Feed.

### Legal Differentiation Summary

| Patent Element | Shadow of Mordor (Nemesis) | Gnoy Simulator |
|---|---|---|
| Memory location | Individual enemy NPCs | Shared faction Dossier (no personal NPC memory in faction) |
| What's remembered | Personal player encounters | Network intel + Reputation Web gossip |
| Hierarchy driver | Player actions cause promotion | Independent Politburo Simulation determines hierarchy |
| NPC adaptation | Personal vendetta | Operative reads current dossier |
| Player centrality | Player is the universe | Player is one input to a self-running world |
| Civilian memory | N/A | Reputation Web — separate, non-hierarchical, individual memory |

**Legal review pre-launch is mandatory** (Risk #4 in Game Brief). Architecture documentation must demonstrate code-level enforcement of these distinctions. The IP-counsel deliverable is owned at architecture phase.

---

## Dialogue System (Disco × Owlcat × BG3 DNA)

### Skill Check Visibility — Hybrid

**DC and skill required visible. Outcome consequence hidden.** Removes save-scum incentive. Preserves build expression.

The player sees:
> *Yap Game (DC 14)* — "Push back on his framing about the Wellness Center."

The player does NOT see:
> *Outcome: success → +Credibility / fail → +Heat in district / crit fail → memory enters Web verbatim and Cage flags conversation*

The hidden consequence is a feature — players experience the dialogue as a real conversation, not a min-max optimization tree.

### Internal Voices (Skills Speaking Mid-Dialogue)

**Tier-based frequency.** Major moments get full multi-voice treatment. Routine dialogue has minimal voice interruption.

**Frequency scales with Awakening + Fatigue.** Low-Awakening / low-Fatigue character has rare voices; high-Awakening / high-Fatigue character has voices flooding in major scenes.

**Voice roster (locked):**

| Voice | Personality |
|---|---|
| `Glowie Sense` | Suspicious, low-trust, sometimes paranoid. "He keeps glancing at the door. Why is he glancing at the door?" |
| `[X] Fatigue` | Cynical, exhausted, accurate. "Everything he's saying is a Trough talking point from 2019." |
| `Lore Depth` | Scholarly, contextual. "The phrasing he just used — 'land stewardship' — is a Settlement Ideologue codeword." |
| `Rabbit Hole` | Compulsive, connection-finding. "His story doesn't match the GnoyNews timeline. The dates are off by three days." |
| `Yap Game` | Rhetorician, strategic. "Use his own framing against him. Echo, then twist." |
| `NPC Mode` | Performative, fake-cheerful. "Smile bigger. He needs to think you don't notice." |
| `Cope (passive Soul whisper)` | Low, exhausted, the character's own conscience. "You can't keep doing this every night." |

Each voice has a distinct color, font, and audio cue (whispered VO tier when funded). Voices fire context-aware — the system queries the scene's tags, the relevant character stats, and the player's recent dialogue choices.

### Dialogue Skills (Active — Player-Selectable Lines)

| Skill | Dialogue Function |
|---|---|
| `Rizz` | Charm path — disarm hostility, build rapport, flirtation |
| `Yap Game` | Rhetoric path — counter-frame, persuade audience, public argument |
| `Based Talk` | Awakening path — wake up specific Gnoym (long-form, requires SOUL) |
| `NPC Mode` | Lie path — pass as compliant, preserve cover |
| `Ratio` | Demolish path — break opponent's composure (key for dialogue-as-combat) |
| `Glowie Sense` | Detect path — catch lies, identify infiltration |
| `Lore Depth` | Doctrine path — counter Xyoner theology in conversation |
| `Hands` | Implicit threat path — menace, force compliance through physical presence |

Each skill gates dialogue lines — a Hands-3 player has more menace lines than a Hands-1 player. **3–5+ paths per dialogue goal**, gated by different builds. A Ghost build and a Grifter build can both pass the same conversation but get there differently.

### Dialogue-as-Combat (Boss Variant)

**Two pure-dialogue boss encounters (locked):**

- **The Trusted Anchor** — cable news anchor. Multi-stage Composure HP. Player wears him down via Yap Game / Ratio / Lore Depth + evidence drops (item-drop into dialogue). Failure stages = blown cover, Feed counter-publication ready, Cage operatives en route.
- **The Debt Dealer** — predatory lender. Multi-stage Composure HP. Yap Game + Credibility + evidence-of-debt-trap-architecture combos. Failure = Vault dossier weight + Heat spike.

**Composure HP** mechanic: 3–5 stages. Each stage requires a specific combo (skill check + evidence drop + framing choice). Failure on a stage = stage repeats with reduced player options ("you've shown your hand"). Total failure = blown cover + lost evidence + Heat spike.

### Conversation Log Weaponization

Every meaningful conversation is **recorded for the world** (not just for the player UI):

- NPCs quote your earlier words back weeks later — Reputation Web propagation
- Cage interrogates spoken-with Gnoym; their memory enters your Dossier verbatim
- Feed weaponizes soundbites at high Heat — edits real words into hit pieces ("today's segment: AntiXyonetic radical caught on tape advocating violence — *play clip out of context*")
- Recruits remember promises; broken promises = Trust crash and Loyalty hit
- Silence is a recorded choice — refusing to answer registers as evasion

**Engineering note:** the conversation log is identified as the **highest-risk performance/storage area** (per Game Brief Technical Challenges). Architecture phase must validate retrieval / propagation / editing performance for thousands of logged conversations across hundreds of in-game weeks.

### Item-Drop in Dialogue

The player can **drag inventory items into a conversation**. A photo placed on the desk; a dossier in front of them; a burner phone shown. **Unlocks dialogue lines that don't exist without the physical evidence.**

Item-drop is essential for boss dialogue encounters (Trusted Anchor / Debt Dealer) and is a major reward for Receipts-skill investment.

### Routine vs. Major Dialogue Tiering

Not every conversation is fully voiced. Per Game Brief Risk #3 (writing volume):

- **Boss Encounters** (13) — full Disco-Elysium-tier treatment, multi-voice, multi-path, item-drop, Composure HP where applicable.
- **Recruit Personal Quest dialogue** — full treatment for personal arcs, lighter for casual interaction.
- **Awakening Track Beats** (Levels 1, 5, 10 cinematic; 2-9 in-world events) — full treatment for cinematic levels, lighter framing for in-world events.
- **Reputation Web Side Quests** — pared trees, voice-light, focused.
- **Routine Gnoym** — minimal trees, environmental flavor, low writing cost.

Tiering is the primary mitigation for writing budget. Tooling for dialogue scope per encounter must be locked early.

---

## Quest Structure (7 Parallel Types, Markers Off by Default)

### Seven Quest Types

1. **Main Quest — "The Arrangement"**
   Loose Inner Ring investigation. No timer, no markers, no urgency. Player-driven. Endgame triggers when the player decides they have enough evidence.

2. **Faction Boss Investigations (13)**
   One per boss archetype. Multi-stage investigation + confrontation. Any order. Some prerequisites via Faction Standing or related-boss evidence. Full roster:
   - **Trough:** Innovation Czar / Soil Baron / Revolving Door
   - **Feed:** Engagement Architect / Trusted Anchor / Fact Checker
   - **Pulpit:** Prosperity Prophet / Think Tank Sage / Settlement Ideologue / Jihadist Franchise Operator
   - **Cage:** Intelligence Artisan / Glowie
   - **Vault:** Benevolent Billionaire / Debt Dealer / Number Go Up Guy

3. **Recruit Personal Quests**
   Each recruit has a personal storyline unlocked by trust-building. Backstory + unfinished business + specific Xyoner operation that hurt them. Deepens commitment, unlocks homebase benefits.

4. **Emergent Politburo Events**
   Auto-generated by Politburo Simulation tick. 0–3 per week. Player can intervene / document / ignore / exploit. Examples: "Engagement Architect under internal scrutiny — leak window open," "Prosperity Prophet's accountant gone missing," "Soil Baron renegotiating with rival Trough faction."

5. **Reputation Web Side Quests**
   Gnoym in social orbit ask for help. Meaningful or mundane. Range: "find my missing daughter (low-Awakening intro to The Hollow homeless network)" → "expose the supervisor at my Trough food-processing plant who's covering up an industrial accident." Web depth unlocks them organically.

6. **Awakening Track Story Beats**
   Tied to Awakening Level. Cinematic at Levels 1, 5, 10. In-world events + internal monologue at 2–9.

7. **District Liberation Goals**
   Macro-objectives per neighborhood. Long-term, requires exposing multiple bosses + reducing per-district Xyoner-operation indicators. Completion changes the world *visibly* — different NPCs, different stores, different Feed content per district. A liberated Cubicle Belt has different posters in the streets, different ambient music, and different Gnoym dialogue.

### Quest Discovery (No Markers Default)

- **Map empty of objective pins by default.**
- **Optional Markers Mode for accessibility.**
- **Default experience built for player-driven discovery.**

**Discovery methods (locked design):**
- Overheard dialogue in public spaces
- Forum posts (underground forum bookmarked from prologue)
- Recruit intelligence (specialists report findings)
- Evidence cross-reference (Connection Mechanic surfaces threads)
- Politburo event broadcasts (Live News Ticker / GnoyNews flashes)
- Random encounters (homeless Gnoy hands you a USB; passing rumor)
- Dead drops in The Hollow (player-driven check)

### The Quest Journal (Character Notes, Not a Task List)

The player's journal is **the character's own notes**. Player writes down what they noticed, marks things "promising," archives stale leads, draws their own conclusions. The game does not auto-log objectives.

**UI:** notebook-style, hand-written font, room for sketches/scribbles. Pages can be filed in tabs (per faction, per district, per recruit). Specific evidence pieces can be cross-linked but the journal itself is the *interpretive layer* — what the character thinks the evidence means.

### Endgame Trigger

Endgame is **player-decided**, not game-driven. Once the player feels Inner Ring Confidence is sufficient (visible in War Room) AND the disposition axes are stably positioned, the player can choose to act on the endgame. The Main Quest does not push.

The 5 endings (defined in Win/Loss Conditions above) trigger from disposition + evidence-state at the moment the player commits.

---

## Recruitment & Homebase System

### Recruitment

**Two paths:**

#### Organic Recruitment

Side quests + in-dialogue puzzles. Read the Gnoy, find the right awakening angle for their specific psychology, background, and resistance. **Different approaches work for different people.**

- **Failure = "not yet."** Try again later with more Credibility, new evidence, different approach.
- Repeated failure with same approach can flag the Gnoy ("you keep pushing this — I'm starting to wonder about you") — high-failure recruit attempts add to their Reputation Web entry, which can become a Cage-interrogation vector.

#### Mission-Based Recruitment

Need a specific specialist. Handler / Analyst recruit points the player to a contact. Complete a trust-building task to unlock them.

### Specialist Roles (7)

| Specialist | Function |
|---|---|
| **Researcher** | Passive Rabbit Hole work between sessions. Yields evidence pieces while player is out. |
| **Broadcaster** | Clout ops on player's published material. Extends Reach passively. |
| **Crafter** | Passive gear production at homebase. Unlocks Resistance-crafted tier. |
| **Medic** | Recovery. Speeds Cope return; handles BODY recovery from operations. |
| **Quartermaster** | Off-grid finance. Routes payments without Cage tracking. Unlocks Off-the-Books talent synergy. |
| **Analyst** | Xyoner comms processing in War Room. Flags potential connections; updates Inner Ring Confidence. *Trust variable — Glowie risk.* |
| **Handler** | Manages awakened-but-not-recruited Gnoym network. Extends Reputation Web to Touch-Grass-leaning players. |

### Recruit Properties (Per Recruit)

- **Background** — personal history, connection to Xyoner harm
- **Specialty** — which specialist role they fill
- **Trust Level** — current trust in player (0–100)
- **Loyalty** — ongoing resource (see Loyalty section)
- **Risk Profile** — already-flagged status; some recruits inherit player Heat
- **Breaking Point** — GUT stat-equivalent; determines what they give up if captured

### Recruit Loyalty (Ongoing Resource — MDA Gap Fix #2)

**Loyalty is not a one-time unlock.** It is an ongoing resource that **degrades** from:

- **Neglect** (not interacting for extended periods — Loyalty −2 per in-game week with no contact)
- **Broken promises** (player commits to a recruit goal, fails to deliver — variable −5 to −20)
- **Credibility collapse** (player's public Credibility crashes — recruits' faith shaken, all recruits −3)
- **Competing faction offer** (Cage-turn attempt, Vault buy-out attempt — variable based on recruit GUT)

**High-Loyalty recruits** are harder to turn by Cage. **Low-Loyalty recruits** may defect, feed information to The Cage, or simply walk out.

**Player must actively maintain relationships, not just build them.** Loyalty maintenance is a slot-cost during the day cycle. Recruit Personal Quests are major loyalty boosters.

### Permanent Loss

- **Cage raids** can capture or kill recruits — permanently.
- **Captured recruits may break depending on GUT stat** — feeds the player's Dossier verbatim.
- **Cell structure (Stage 4) limits damage** — captured members only know their cell.
- **Recruits can be turned into Glowies** — periodic Glowie Sense checks required.
- **OPSEC investment protects real people** the player has built real relationships with.

### Homebase Evolution (4 Stages)

| Stage | Awakening | Location | Capacity & Features |
|---|---|---|---|
| **1 — The Apartment** | 1–2 | Slopside Tenements | Solo. Evidence board (small). Underground forum laptop. Slop fridge. One locked evidence drawer. **Vulnerability:** Cage-pressured landlord. |
| **2 — The Office** | 3–4 | Front of cover business (often The Cubicle Belt or Slopside edge) | 2–3 recruits. Cover-business lease. Crafting station. Low-range pirate rig. Passive research/crafting while player is out. **Vulnerability:** paper trail. |
| **3 — The Underground HQ** | 5–7 | The Hollow | Full operation. Crafting wing, darknet server, broadcast tower, **war room (live Dossier board)**, medical bay. **Vulnerability:** single-location — one Cage raid can cripple. |
| **4 — The Network** | 8+ | Distributed across districts | Distributed safe-house cells. No single point of failure. Cells don't know each other. Player rotates by Heat level per district. **Vulnerability:** coordination complexity = new exposure surface. |

**Stage transitions are major milestones.** Each requires resources, recruits, narrative beats. Stage 3 to Stage 4 in particular is an awakening-arc tipping point — the player gives up location centralization for distributed resilience.

### Homebase Diegetic Evolution

- **Ambient sound** — empty-flat-echo (Stage 1) → low-traffic (Stage 2) → full-resistance-operation hum (Stage 3) → variable per cell (Stage 4)
- **Visual density** — sparse / personal (Stage 1) → semi-active (Stage 2) → war-room operational (Stage 3) → distributed dispersed (Stage 4)
- **Recruit presence** — cosmetic NPCs at homebase, going about specialist work, idle dialogue available

### Dave (Schrödinger's NPC)

**Greystone coworker. First dialogue choice (during opening sequence) permanently determines his arc.**

| Player Choice | Dave's Future |
|---|---|
| **Default (Full Gnoy answer)** — agree with the corporate sentiment | Dave stays Dave forever. Perfectly average Gnoy. The player will try to wake him up across the entire game — every method fails. He's the heartbreak of the resistance. Proof that some people just don't want to see. |
| **"Real" answer** — speak honestly about Greystone's emptiness | Dave's Trust Meter starts elevated. Organic conversations build relationship. Becomes natural first Recruit candidate — **Researcher specialist** ("has been quietly noting weird Greystone stuff for months"). |
| **"Too awakened too early"** — drop too much truth, too fast | Dave reports the conversation upward. Greystone is a Cage front company. **Dave becomes a Glowie even if he wasn't one before.** Player cannot detect this until much later. |

The Dave outcome is determined by player behavior, not pre-scripted. **Same first encounter, three radically different futures.** This is the Schrödinger's NPC system — replayability and social-content hook in one.

---

## Opening Sequence — "A Perfectly Normal Morning"

### Design Principle

**Contextual tutorial.** Systems revealed through play, never explained. Comedy and satire embedded environmentally throughout. Player learns by living.

**Approximate length:** 15 minutes.

### The Sequence (Locked Beats)

1. **The Alarm (6:47am)** — phone notifications: FeedGram, McXyon's promo, GnoyFlix guilt ping. **Snooze = morning slot vanishes silently. First slot system lesson.**

2. **The Fridge** — full of slop (McXyon's leftovers, NutriMax™ shake, XtraSoda™). Eat = **BODY restores + grey unlabeled number ticks up somewhere (Slop Damage, no UI explanation).** Players notice it without being told.

3. **The Feed** — GnoyNews segment: *"Xyoner Philanthropist Dov Xelberg pledged $400M to the Global Nutrition Initiative."* Mention of *"anti-Xyonetic extremists arrested."* Player can watch or mute. **Names, logos, locations seeded for later. No markers.**

4. **The Commute** — environmental satire. McXyon's logo everywhere. Billboard: *"You Deserve This™."* NPCs muttering FeedGram drama. A suited man with a briefcase bearing a logo the player has now seen twice (no marker). Homeless Gnoy with sign: *"THEY PUT SOMETHING IN THE FOOD."* — passersby laugh.

5. **The Job — Greystone Data Solutions** *(does not exist, processes nothing, 340 employees)*. **Coworker Dave — first dialogue choice.** Real vs. Gnoy response. **Dialogue system exposed without explanation.** Paycheck arrives, auto-deducts: SloppFlix, McXyon's DeliverEasy, FeedGram Premium, GnoyGym (last visit: 47 days). **Financial system exposed silently.**

6. **The Incident (Lunch)** — GnoyNews filming "spontaneous community celebration" at new Xyoner Wellness Center. Same anchor as morning. Crowd looks rehearsed. Cameraman gestures someone to reposition. **Player can ignore (valid Full Gnoy choice), watch, or pull out phone (camera opens — Receipts system silently introduced, photo saves to evidence board — also silently introduced).**

7. **The Evening** — Feed runs segment about the event. **Footage is doctored** — awkward cameraman gesture cut, sign-holder centered. **The Feed-vs-reality gap (the central premise of the game) just made itself visible without anyone narrating it.**

8. **The Forum** — laptop has an underground forum bookmarked. **Character had it before the game started** — they were *vaguely uneasy* before today. One post: *"Anyone else notice the Xelberg event was staged? Saw the same woman at three different events this month."* **The rabbit hole opens.**

**Day ends. World ticks. Politburo simulation advances. Player has no idea.**

### Systems Silently Introduced

- Time slot system (snooze loss)
- Slop Damage (unlabeled grey number)
- Financial pressure (auto-deductions)
- Dialogue consequences (Dave)
- Camera / Receipts (the photo)
- Evidence board (the pin)
- Feed-vs-reality (central premise demonstrated, not explained)
- Underground forum (already in player's life)

The opening is an **MVP requirement.** It must be shippable as part of the Vertical Slice (per Game Brief MVP Definition).

---

## World & Setting

### Alt-Earth, Present-Day

Recognizable but slightly wrong. Not sci-fi, not historical, not post-apocalyptic — just the world as it currently is, with the names changed, the satire dialed up, and the conspiracy real.

### The Xyoners

The malignant ruling oligarch class. Land theft, child killing, political blackmail, media capture, political purchase. Five operational arms (factions). An Inner Ring whose number, names, and identities are unknown until endgame. **The Xyoners are a fictional class, not tied to any real ethnic or religious group.**

### The Gnoym

The population. Most are fully compliant — eating slop, watching the feed, clocking in. Some are awakening. Some are already awake and underground. **The player begins as a Gnoy.**

### Faction Standing Ladder

```
UNKNOWN → FLAGGED → OBSERVED → ASSET → COMPROMISED → OWNED
```

| Standing | Description |
|---|---|
| UNKNOWN | Faction has no awareness of player |
| FLAGGED | First flag in dossier; minimal attention |
| OBSERVED | Active surveillance; faction-specific tactical responses begin |
| ASSET | Faction wants something *from* player; double-cross tests possible |
| COMPROMISED | Faction has significant leverage on player |
| OWNED | Faction effectively controls player route |

**Locked design constraints:**
- Double-cross tests at ASSET+
- Cross-faction interference (player can play factions against each other; Cage-Feed rivalry is a key mechanic)
- The Vault never fully hostile (financial threat, but not lethal — they want assets, not corpses)
- The Cage has pre-existing rivalry with The Feed (useful for manipulation)

### The Five Factions

#### THE TROUGH — Food, Agribusiness, Processed Consumption

Operational concerns: fast food chains (McXyon's), agribusiness consolidation, supplement scams, supply-chain control.

**Bosses:**
- **The Innovation Czar** — Fast food CEO. Engineers addiction formulas. Defeated by internal R&D docs + Cage rivalry exploit.
- **The Soil Baron** — Agribusiness land consolidator. Monsanto/Gates archetype. Defeated by deed records + displaced-farmer organizing.
- **The Revolving Door** — Ex-regulator turned industry consultant. Pure documentation defeat. Paper trail only.

#### THE FEED — Media, Algorithms, Narrative Control

Operational concerns: cable news, social media platforms, fact-checking apparatus, search-result manipulation.

**Bosses:**
- **The Engagement Architect** — Social media CEO. Designed the dopamine loop knowing the harm. Defeated by Signal Hijack broadcasting internal memos.
- **The Trusted Anchor** — Cable news anchor who knows he's lying. Has a dead man's switch. **Dialogue boss** — Based Talk + Rizz defeat.
- **The Fact Checker** — Feed-funded "independent" debunker. Specifically targets player content. Defeated by exposing the foundation funding chain via Doxcraft.

#### THE PULPIT — Religion, Ideology, NGOs, Wellness

Operational concerns: megachurches, religious extremism funding, think tanks, "wellness" pseudoscience, ideology laundering.

**Bosses:**
- **The Prosperity Prophet** — Megachurch pastor. Launders Trough money. Debt-traps congregation. Defeated by triple-channel exposure (forums + graffiti + pirate broadcast).
- **The Think Tank Sage** — Policy-laundering intellectual. Conclusion-first research. Defeated by leaking draft-before-research documents via Edit Farm.
- **The Settlement Ideologue** — Religious nationalist extremist. Theology as cover for land seizure and displacement. **Cross-faction link to Vault's Number Go Up Guy** — exposing both simultaneously collapses two bosses. Defeated by Doxcraft + timed Signal Hijack.
- **The Jihadist Franchise Operator** — Religious extremism as geopolitical tool. **Funded by Vault via charity chains.** Defeated by exposing the money trail.

> **Tone note:** the Pulpit roster is structurally balanced. Christian-coded (Prosperity Prophet), Jewish-coded (Settlement Ideologue), Muslim-coded (Jihadist Franchise Operator), and ecumenical/intellectual (Think Tank Sage) bosses all share faction. **Equal-opportunity satire targeting ideology and behavior, not faith.**

#### THE CAGE — Enforcement, Surveillance, Kompromat

Operational concerns: state and private security, surveillance infrastructure, intelligence apparatus, blackmail.

**Bosses:**
- **The Intelligence Artisan** — Retired spymaster. Runs the kompromat blackmail archive. Defeated by physical infiltration of dead drop to pull one file, then weaponize against other factions.
- **The Glowie** — Embedded resistance informant. **May have been in player's network whole playthrough.** Detected via Glowie Sense. Defeated by feeding false intel and tracking where it surfaces in dossier update.

#### THE VAULT — Finance, Debt, Capital

Operational concerns: hedge funds, predatory lending, philanthropic capital deployment, asset acquisition.

**Bosses:**
- **The Benevolent Billionaire** — Davos philanthropist. **Longest evidence chain in the game.** Defeated by Web + Rabbit Hole.
- **The Debt Dealer** — Predatory lending architect. Student loans, medical debt, payday networks. **Pure dialogue boss** — Yap Game + Credibility.
- **The Number Go Up Guy** — Hedge fund housing manipulator. **Only boss you can hand to The Cage** — they use it, take credit, add you to dossier.

#### THE INNER RING

- Unknown number, unknown identities throughout the game.
- Evidence referred to as "The Arrangement" in documents — names always redacted.
- Each Inner Ring figure owns pieces of multiple factions.
- Exposing one collapses multiple faction operations simultaneously.
- **Endgame reveal:** their number, names, **and that one of them fed you information all along — not to help you, but to eliminate rivals.**
- Inner Ring size and the identity of the manipulator — final narrative-pass decision (open question per Game Brief).

### 12 Districts

Three tiers, organized by complexity and unlock cadence.

#### Tier 1 — Major (Multi-Sub-Area)

| District | Sub-Areas | Faction Dominance | Bosses |
|---|---|---|---|
| **Slopside** | The Strip, Tenements (player apartment), The Yards (warehouses), The Free Clinic | Trough-saturated | None directly — all Trough operations feed here |
| **The Cubicle Belt** | Greystone Data Solutions, Tech Park, Convention Center, Coffee Row | Cage / mixed | Fact Checker, Revolving Door |
| **The Plaza** | Broadcast Row, Influencer Mile, Theater District, Press Square | Feed dominant | Engagement Architect, Trusted Anchor |
| **The Vault District** | Banker's Mile, Stock Exchange, Debt Court, Crypto Alley | Vault dominant | Debt Dealer, Number Go Up Guy |
| **The Garden** | Country Club, Private Schools, Operative Estates, Marina, Wellness Centers | Mixed | Most boss personal residences |

#### Tier 2 — Specialty

| District | Faction Dominance | Bosses |
|---|---|---|
| **The Pulpit Quarter** | Pulpit dominant | Prosperity Prophet, Settlement Ideologue (Annex sub-area: Jihadist Franchise Operator territory, locked behind quest) |
| **University Row** | Pulpit adjacent | Think Tank Sage |
| **The Slop Belt** | Trough dominant | Innovation Czar |
| **The Civic Center** | Cage dominant | Intelligence Artisan (cover identity) |
| **The Hollow** | Neutral / Resistance | Player HQ, safe houses, dead drops, no boss |
| **The Outskirts** | Trough dominant | Soil Baron + estate |

#### Tier 3 — Endgame

| District | Description |
|---|---|
| **The Compound** | Walled ultra-wealthy enclave. Inner Ring residences. Late-game access only. |

#### Hidden / Special

- **Cage Black Sites** — off-map, revealed by investigation. Player capture / rescue scenarios.
- **Inner Ring Private Locations** — mansions, yachts, retreats — endgame only.

### Per-District Heat & Rotation

Heat is tracked per district. **Rotation is core mature gameplay.** The player learns to run hot ops in The Plaza, then shift to Slopside while Plaza Heat decays. Different theaters with different faction profiles.

### Traversal Options

| Method | Speed | Tracking | Cost |
|---|---|---|---|
| Walking | Slow | Untracked | Free; observation-rich (NPC overheard dialogue, environmental detail) |
| Bicycle | Medium | Untracked | One-time purchase |
| Public Bus | Medium | Light (Trough-adjacent) | Cheap |
| Subway | Fast (select districts) | Cage cameras at stations | Cheap, checkpoint risk |
| SloppDrive (rideshare) | Fast | **Heavy — logs trips** | Moderate, ongoing cost (Vault/Feed data) |
| Personal Vehicle | Fast | Registered = Cage can track | Major purchase |
| **Sneak Routes** | Variable | Untracked | Free — **unlocks at Ghost Mode threshold** |

**Sneak Routes Mechanic** — alleys, rooftops, service tunnels visible on map only after Ghost Mode threshold is reached (Awakening 6 + Ghost Mode 4 baseline). High-Awakening players have **more map** than Full Gnoym. Traversal itself is a character build expression.

### Progressive Map UI

Richer as the player awakens. Full Gnoy sees a clean tourist map. High-Awakening player sees a battlefield with overlapping intel layers.

**Toggleable overlays:**
- Per-district Heat heatmap
- Cage surveillance points (revealed by Glowie Sense / Receipts work)
- Sneak routes (Ghost Mode gated)
- Recruit positions
- Faction operation indicators (Analyst-supported)
- Dead drop locations

---

## Narrative Approach

### Player-Authored, System-Generated

The Main Quest ("The Arrangement") is loose — an Inner Ring investigation with no timer, no markers, no urgency. Endgame triggers when *the player decides* they have enough.

### Tonal Benchmarks

- **Fallout** (dark humor, absurdist evil)
- **They Live** (normal until you see it)
- **American Beauty** (perfection over rot)
- **Don't Look Up** (deadpan satirical present)
- **Disco Elysium** (skills as voices, satire by detail)
- **Cruelty Squad** (the world is grotesque on purpose)

### Voice & Writing Register

Sharp, satirical, willing to be funny. Disco-Elysium / Fallout DNA, modernized for media-literate audience. **No exposition dumps — the world is the information.** Ambient signage, overheard dialogue, environmental detail, and Feed broadcasts carry the world-building.

### Equal-Opportunity Satire (Locked)

The satire targets **ideology and behavior, not faith or ethnicity.** The Pulpit faction includes the Settlement Ideologue and the Jihadist Franchise Operator side by side, both funded by Vault charity chains. The Prosperity Prophet (American megachurch grift) is included. The Think Tank Sage (secular policy-laundering intellectual) is included. The Vault and Cage are ecumenical.

The Xyoners are fictional. There are no real names, no real events. Tonal calibration via early playtests is mandatory pre-launch.

### Writing Volume

**Disco-Elysium-tier (300k+ words)** given dialogue depth + internal voices + conversation-log weaponization + 24-skill branching.

**Tiering strategy** (mitigation for writing budget):
- Boss encounters (13) — full treatment
- Recruit Personal Quests — full treatment for personal arcs, lighter for casual
- Awakening Track Beats (Levels 1, 5, 10) — full cinematic treatment
- Awakening Track Beats (2-9) — in-world events + internal monologue (lighter)
- Reputation Web Side Quests — pared trees
- Routine Gnoym — minimal, environmental flavor

---

## Progression and Balance

### Player Progression

**Two interleaved progression tracks:**

#### Track 1 — Skill Levelling (Standard)

- Skill check experience drives skill levels.
- Each skill: 0 → 10.
- Skill use awards skill XP; level-up awards talent points + skill bonus.
- Attribute growth: stat-point allocation at certain milestones; talents can also raise attributes.

#### Track 2 — Awakening Track (Mythic-Equivalent Secondary)

- Levels 1 → 10.
- Triggers from in-world events (subscription cancellations, evidence published, boss defeats, faction milestones) — not from grinding.
- **Each level reshapes what the player can perceive in the world** (sneak routes appearing, symbols becoming readable, NPCs starting to wake themselves).
- Cinematic moments at Levels 1, 5, 10.
- In-world events + internal monologue at 2–9.
- **The Awakening Track is the campaign spine.** It is what a player *experiences themselves doing*; the skill levels are what the character *knows how to do*.

### Difficulty Curve

#### Combat Curve

- **Vertical Slice / Early Game:** Encounters tuned for Awakening 1–3 builds. Hotline-Miami lethal but tractable; signature weapons in the player's hands provide solutions.
- **Mid Game:** Faction Build Counter-System kicks in — encounters adapt to the player's pattern. A pure-stealth player faces thermal sensors mid-game; a pure-broadcast player faces accelerated counter-narratives.
- **Late Game:** Boss encounters (13) and Inner Ring scenarios — multi-phase, multi-system, requiring full RPG investment.
- **Endgame:** ending-specific set-pieces.

#### Investigation Curve

- **Early:** Single-thread investigations, low-stakes evidence, forgiving Connection Mechanic DCs.
- **Mid:** Multi-thread cross-references, planted-evidence introductions (the Cage starts gaslighting), DC scaling with thread depth.
- **Late:** Multi-faction cross-cutting investigations, Inner Ring evidence (longest chains), Feed counter-narrative pressure on player publications.

#### Social / Recruitment Curve

- **Early:** Few Gnoym in orbit, Reputation Web small, Loyalty management low-load.
- **Mid:** 5–10 named recruits, Loyalty management becomes a slot-cost; Personal Quests unlock; first defection / loss possible.
- **Late:** Distributed cell network; coordination complexity; Glowie infiltration risk peaks.

### Economy and Resources

#### Money

| Source | Notes |
|---|---|
| Job paycheck | Shrinks if Afternoon slots are skipped; vanishes on Quit. |
| Underground market sales | Selling Receipts to forum subscribers, evidence packets to rivals. |
| Pirate broadcast monetization | Once Signal Hijack invested. |
| Network payments for intel | Recruits + Handler relationships unlock buyer tiers. |
| Xyoner money seized | Boss operations, Inner-Ring-adjacent ops. Heat penalty for spending. |

#### Bills

| Bill | Frequency | Notes |
|---|---|---|
| Rent | Monthly | Per homebase tier |
| SloppFlix | Monthly | Cancellable; Awakening tick on cancel |
| McXyon's DeliverEasy | Monthly | Cancellable |
| FeedGram Premium | Monthly | Cancellable |
| GnoyGym | Monthly | Cancellable |
| FeedBoost Supplements | Monthly | Cancellable |
| Vehicle insurance (if owned) | Monthly | Optional |
| Debt servicing (if in debt) | Monthly | Vault dossier weight if missed |

#### Materials & Crafting

- **IRL Build / Crafter recruit** unlock crafted gear and signature weapons.
- Materials sourced from the world (looted, scavenged, purchased, dead-dropped).
- Crafting cost-curve: Standard = trivial; Underground = real cost; Resistance-crafted = significant materials + Crafter skill.

#### Time as Resource

**Time is the scarcest resource.** A finite number of slots per day. The economy of *how the player spends their day* is the deepest balance question in the game and the primary lever for difficulty. A player who skips work to investigate trades money for evidence; a player who works then publishes nightly trades sleep for Cope debt.

---

## Save System

- **Default:** autosave at day boundaries + key events.
- **No manual save.** Consequences stick (recruits, dialogue, choices).
- **Optional Ironman mode:** one file, permanent death.
- **Day-boundary autosaves** mean the worst case is losing one in-game day — not cruel, but meaningful.
- **Encounter restart** in combat is in-encounter only — separate from save state.
- **Captured-state save** allows escape gameplay to be reattempted without losing the broader save.

---

## HUD & UI

### Minimal Default HUD

**Always visible:**
- **Top-left:** per-district Heat indicator (color-coded: cool blue → orange → red → flashing)
- **Top-right:** day / time slot + in-game date

**On-demand (button press):**
- Character stats (C)
- Evidence board (B)
- Map (M)
- Inventory (I)
- Dossier (J — what the Xyoners know about you)
- War Room (Stage 3+ HQ only)

**Contextual (appears when relevant):**
- Dialogue UI (bottom third when in conversation)
- Skill check prompts (visible DC + skill required)
- Internal voice overlays (each skill has distinct color/font)
- Combat BODY indicator (edge of screen, Hotline-Miami style — colored bars, not numbers)
- Brief evidence notifications (bottom corner, 2 seconds)
- Receipts photo capture indicator

### Philosophy

**The world is the information. Numbers live in menus.** The HUD does not narrate the game; the environment does.

### UI Duality

- **Xyoner-facing UI** — feed, map (default tourist mode), official city overlays. **Polished corporate app aesthetic.** Clean, branded, rounded corners, oversaturated palette.
- **Resistance-facing UI** — evidence board, forum, homebase, War Room. **Hand-made aesthetic.** Sticky notes, photos, red string, CRT terminal feel. Imperfect. Lived-in.

The duality is itself satire. The Xyoner UI looks like the marketing department designed it. The Resistance UI looks like the player's character actually built it.

---

## Art & Audio Direction

### Visual Style — Satirical Hyper-Realism

**Present-day alt-Earth.** Recognizable but slightly wrong.

- **Xyoner / corporate spaces:** colors oversaturated, too vibrant, too clean, too cheerful. **McXyon's red is *too* red.** NPCs move too uniformly. The artificial cheer is the satire.
- **Slopside / The Hollow:** desaturated, grey-yellow, authentically grimy. *Real* color. Lived-in, melancholic.
- **The contrast IS the art direction.** More Xyoner influence = more artificial vibrancy. Neighborhoods read by palette before they read by text.
- **As Awakening rises:** subtle visual filter shift. **What looked cheerful starts reading as *wrong*.** NPCs you walked past for 20 hours start looking off.

### Format

**Detailed pixel art OR hand-drawn 2D sprites — not 3D.**

- Top-down perspective (Pokémon / Zelda camera).
- Final pipeline choice (pixel vs. hand-drawn) deferred to architecture/art-direction phase.
- Character art and environments must support the cheerful-then-wrong filter shift across Awakening levels.

### References

- **They Live** (normal until you see it)
- **American Beauty** (perfection over rot)
- **Don't Look Up** (deadpan satirical present)
- **Disco Elysium** (color palette, environmental detail)

### Audio Style — Layered by Context

- **Gnoy daily life:** corporate jingles, hold music, upbeat pop slop (McDonald's-tier brand DNA, fictional)
- **Slopside / Hollow:** lo-fi, melancholic, authentic ambient city
- **Investigation:** slow tension, late-night paranoia (Burial / Arca DNA)
- **Combat:** aggressive electronic / synthwave (Perturbator / Carpenter Brut / Hotline Miami DNA)
- **Xyoner spaces:** slick corporate ambient — expensive and empty
- **Awakening moments:** something cracks in the music production
- **Endgame:** orchestral-electronic hybrid

### The Music Deterioration Mechanic (Signature)

**As Awakening Level rises, corporate music in Xyoner spaces audibly deteriorates.**

- Awakening 1–2: clean original tracks
- Awakening 3–4: occasional wrong note, slight pitch wobble in Xyoner spaces
- Awakening 5–6: jingles skip mid-loop, audible audio-compression artifacts, brand stings sound *off*
- Awakening 7: corrupted-file sound — dropouts, glitch artifacts, distorted McXyon's brand audio
- Awakening 8–9: tracks struggle to render; silence between glitches
- Awakening 10: corporate music collapses entirely — endgame audio takes over

**The player *hears* the manipulation become visible.** This is a signature mechanic. **5 deterioration tiers. Composer pipeline must support multi-version recordings of every Xyoner-space track.** Smooth crossfade between tiers — never jarring.

### Sound as Gameplay

- **Enemy footsteps audible before visible** — stealth is partly an audio game
- **Pirate broadcast signal quality represented by audio clarity** — Signal Hijack skill = audio fidelity (low Signal Hijack = static; high = clear)
- **Homebase ambient sound grows** from empty-flat-echo (Stage 1) to full-resistance-operation hum (Stage 3) and variable per-cell (Stage 4)
- **Internal voices have distinct VO** when funded — color/font + audio cue per skill

### Accessibility Pairings

- **Subtitles / captions** mandatory for the audio-game stealth design
- **Sound-cue visual indicators** option for hearing-impaired players (footstep direction shown as on-screen tells)

---

## Technical Specifications

### Performance Requirements

- **Top-down 2D, district-based (not open world).** Districts are detailed but bounded maps. Streamed transitions between districts (loading screens acceptable).
- **Target framerate:** 60fps minimum on minimum-spec PC (5-year-old mid-range hardware).
- **Steam Deck Verified target.**
- **Memory footprint:** moderate — not constrained by 3D asset budgets.
- **Politburo Simulation tick:** weekly, coarse-grained, off-thread acceptable.
- **Conversation Log retrieval:** must support thousands of logged conversations across hundreds of in-game weeks (highest performance risk per Game Brief).

### Platform-Specific Details

- **Primary:** PC Steam (Windows / Linux native).
- **Likely secondary post-launch:** Steam Deck Verified, macOS, Nintendo Switch.
- **Possible tertiary:** PS5 / Xbox if controller-first UX work is funded.
- **Engine:** decision deferred to architecture phase. Realistic candidates: **Unity** (broad 2D RPG tooling, Steam Deck verified pipeline), **Godot** (open-source, strong 2D, growing CRPG ecosystem), **Unreal** (only if 3D-adjacent ambitions arise — currently not warranted).

### Asset Requirements

#### Art Assets (locked scope intent)

- 12 districts of detailed environmental satire — interior + exterior coverage per district
- Sub-area diversity for Tier 1 districts (5 districts × 4 sub-areas each = 20 sub-areas of unique art)
- Tier 2 specialty districts (6) — more focused, single-purpose layouts
- Tier 3 (Compound) — 1 endgame district
- Hidden / special locations (Cage Black Sites, Inner Ring private — handful)
- Boss arenas / personal residences (13 bosses)
- Player homebase art for 4 stages (with diegetic evolution)
- Character sprites: player customization tier + named NPCs (recruits, bosses, reputation-web Gnoym) + crowd Gnoym
- UI dual-aesthetic — Xyoner corporate-app + Resistance hand-made
- Environmental Awakening filter: every Xyoner-space environment must support the visual shift across Awakening tiers

#### Audio Assets (locked scope intent)

- Layered context music: 7 contexts × multiple tracks
- **Music deterioration: every Xyoner-space track in 5 tiers** — *the under-budgeted line item*
- Sound effects: combat, footsteps, environmental, signature weapon
- Internal voice VO: 7+ voice roles, multi-line per voice, scaling frequency with Awakening + Fatigue
- Boss VO: 13 boss roles, full dialogue treatment
- Recruit VO: per recruit (locked count TBD per content scope)
- Routine NPC VO: minimal / none-by-default; tier decision at production scope

#### Writing Assets

- **300k+ words** target per Game Brief
- Writing tooling required before scaling word count
- Skill-voice templates for reuse
- Tiered dialogue depth (boss / recruit / awakening / web / routine)

### Architecture Constraints (Must Be Enforced in Code)

- **Three Tracking Systems must be code-distinct** for legal differentiation (US 10,926,179):
  - Player Dossier — single shared faction file, no per-NPC memory
  - Politburo Simulation — independent tick, separate from player-action graph
  - Reputation Web — per-NPC memory, but no faction hierarchy linkage from this layer
- **Build Classifier / Tactical Response abstraction** — clean separation between dossier classification (input pattern) and faction tactical response (output loadout).
- **Conversation Log is a first-class subsystem** — performance/storage validated at vertical slice.
- **Save System** boundaries — autosave at day-boundary + key event; Ironman as alternative.
- **Music Deterioration pipeline** — locked at vertical slice. 5-tier crossfade audio system. Multi-version recordings.
- **Skill check / dialogue branching infrastructure** — visible DC, hidden consequence, internal voice trigger, item-drop into dialogue. Robust dialogue tooling target.

### Localization

- **English at launch.**
- **Localization-readiness must be designed in from day 1** — string externalization, internal-voice localization-friendliness, UI flex for variable-length strings.
- **Languages-at-launch decision:** open question per Game Brief — Spanish / German / French / Russian / Mandarin tier (driven by 300k+ word translation cost).

---

## Development Epics

### Epic Structure (High-Level)

The Game Brief specifies a Vertical Slice → Early Access → Full Launch staging. The GDD organizes the development work into the following epics, ordered roughly in dependency sequence. **Detailed epic breakdowns and stories are produced by the `/gds-create-epics-and-stories` skill, not this GDD.** This section establishes the epic surface.

#### Epic 1 — Foundation & Core RPG Skeleton

- 7-attribute / 24-skill / 40-talent system
- Disposition axes
- Awakening Track infrastructure
- Skill check / dice / DC infrastructure
- Save system + Ironman mode

#### Epic 2 — Day Cycle & Survival Loop

- Action slot system
- Snooze button + slot consumption rules
- Monthly bills + subscription cancellation system
- Sleep / world-tick advancement
- Cope mechanic + rest recovery
- Fatigue accumulation + recovery

#### Epic 3 — Combat (Hotline Miami DNA)

- Real-time top-down combat encounter system
- Stat-modulated parameters (BODY, Gymmaxx, Hands, Ghost Mode)
- Capture mechanic (YIELD / ATTEMPT ESCAPE)
- Faction Build Counter-System
- Signature weapons (Evidence Brick, Slop Bag, Megaphone, Signal Jammer, Camera Flash, Fake ID Packet)
- Encounter restart with world-state persistence

#### Epic 4 — Equipment System

- 15-slot equipment
- 5 quality tiers
- Set bonuses + outfit detection
- Stat / skill / Heat modifiers from equipment
- IRL Build / Crafter integration

#### Epic 5 — Investigation UI (Three Layers)

- Physical Board (drag-and-drop, draw connections, scales with homebase)
- Dossier Interface (cross-reference + stamping + publication)
- Thought Cabinet (mental threads, time-cost processing, Awakening-driven reinterpretation)
- Connection Mechanic + skill checks + three outcomes
- Cage planted-evidence system

#### Epic 6 — Dialogue System

- Visible-DC / hidden-consequence skill checks
- Internal voices (frequency-scaled by Awakening + Fatigue)
- Multi-path dialogue (skill-gated)
- Item-drop in dialogue
- Dialogue-as-combat (Composure HP variant for Trusted Anchor / Debt Dealer)
- Conversation Log subsystem

#### Epic 7 — Three Tracking Systems

- Player Dossier (shared faction file, threat axes, classifier)
- Politburo Simulation (weekly tick, factions, bosses, succession, blackmail debts, cross-faction interference)
- Reputation Web (per-NPC memory, gossip propagation, interrogation-bridge)
- War Room UI (Stage 3+)

#### Epic 8 — Recruitment & Homebase

- Organic + mission-based recruit acquisition
- 7 specialist roles
- Recruit Loyalty (ongoing resource)
- Permanent loss + Cage raid scenarios
- Glowie Sense checks
- Homebase Stage 1 → 4 evolution
- Diegetic homebase art / sound progression

#### Epic 9 — World & Districts

- 12 district maps (5 Tier 1 multi-sub, 6 Tier 2 specialty, 1 Tier 3 endgame)
- Per-district Heat tracking
- District rotation gameplay
- Sneak routes (Ghost Mode unlocked)
- Progressive map UI overlays
- Traversal options

#### Epic 10 — Quest System

- 7 quest types in parallel
- Quest Discovery (overheard, forum, recruit, evidence, news)
- Quest Journal (character notes, not task list)
- Markers Mode toggle
- Endgame trigger + 5 endings

#### Epic 11 — Boss Investigations (13)

- Per-boss multi-stage investigation arc
- Boss-specific defeat conditions (documentation / dialogue / combat / cross-faction)
- Boss arena art + dialogue
- Inner Ring evidence assembly across bosses

#### Epic 12 — Opening Sequence

- "A Perfectly Normal Morning" — full 15-minute contextual tutorial
- Schrödinger's NPC (Dave) system
- Silent system introductions

#### Epic 13 — Art Pipeline & Music Deterioration

- Pixel / hand-drawn 2D sprite pipeline
- Awakening visual filter system
- Music deterioration audio pipeline (5 tiers, multi-version recordings, smooth crossfade)
- Sound-as-gameplay (footsteps, signal quality, homebase ambient)

#### Epic 14 — Three Endings + Polish

- Public Reckoning, Shadow Replacement, Burn ending implementations (Long Game and Sleep are late-stage handles)
- Endgame Set-Pieces
- Credits sequence variations
- Final balance pass + accessibility pass

> **Note:** Epic ordering above is dependency-aware but not a strict ship sequence. Vertical Slice (per Game Brief MVP) requires partial coverage of Epics 1, 2, 3, 5, 6, 7 (subset), 8 (Stage 1), 9 (one district), 10 (skeleton), 11 (one boss — recommended Fact Checker), 12 (full), 13 (one Xyoner-space track in deterioration prototype). Full epic decomposition into stories is the next planning artifact, produced by `/gds-create-epics-and-stories`.

---

## Success Metrics

### Technical Metrics

- **Frame rate:** 60fps stable on minimum spec; Steam Deck Verified.
- **Politburo Simulation tick performance:** weekly tick completes in <500ms in worst-case 100-week-deep save.
- **Conversation Log retrieval:** any past conversation lookup <50ms; gossip propagation tick <2s for 200+ Gnoym in Reputation Web.
- **Save / load:** day-boundary autosave <3s on minimum spec; load <5s.
- **Music deterioration crossfade:** unnoticeable to players (no jarring transitions).
- **Faction Build Counter-System:** classifier rolling-window evaluation <100ms; tactical response generation <500ms.
- **Architecture-level patent differentiation:** code review demonstrates Player Dossier / Politburo Simulation / Reputation Web are distinct subsystems with no shared faction-personal-memory linkage.

### Gameplay Metrics

- **Tutorial without text:** >80% of playtesters complete the opening sequence and identify all silently-introduced systems within 30 minutes of post-tutorial play, with no in-game system explanation.
- **Truth Paradox legibility:** >75% of post-Vertical-Slice playtesters describe the Truth Paradox unprompted within 30 minutes of investigation play.
- **Build differentiation:** >70% of playtesters report that two of their playthroughs felt like materially different games on the same map.
- **Schrödinger's NPC awareness:** community discussion of Dave outcomes within 30 days of Early Access release.
- **Music Deterioration moment:** >60% of playtesters cite the music deterioration as a memorable moment in post-EA reviews / forum threads.
- **Replay rate:** median player initiates 2+ playthroughs (Schrödinger's NPC + 5 endings + radically different builds support this design target).
- **Sleep ending engagement:** >5% of completionist players choose / reach the Sleep ending — the game must structurally support this without nudging the player away.

### Audience-Fit Metrics

- **Reviews aligned with the satirical-CRPG niche:** Disco Elysium / Pentiment / Citizen Sleeper review tier among receptive reviewers.
- **Cultural conversation:** Music Deterioration Mechanic and Schrödinger's NPC system spawn organic streamer / TikTok / forum content. Players *describe the game* unprompted using signature mechanics.

---

## Out of Scope

The following are explicitly **NOT in scope** for this GDD or any subsequent epic / story planning. Adding any of these requires a formal scope-change discussion and re-elicitation that supersedes this document.

- **3D rendering or 3D character models.** This is a top-down 2D game.
- **Open world.** District-based with bounded maps is the locked design.
- **Live service / always-online requirements.** Single-player, offline-capable.
- **Multiplayer / co-op.** No multiplayer in this title.
- **Romance system as a focus.** Recruit relationships exist (trust + loyalty); romance is not a designed feature. (One-off character beats may exist; system-level romance does not.)
- **Procedural district generation.** Districts are hand-authored.
- **Player customization at character-creation as a deep system.** Default starting background is Wageworker. Alternate starting backgrounds are deferred — a single canonical starting position is the locked design for v1.
- **Mod support / Steam Workshop at launch.** Open question per Game Brief; possible post-launch consideration; not in launch scope.
- **DLC / expansion design.** Not in scope; will be considered only post-launch.
- **Branching cinematic cutscene production at AAA scale.** Cinematic moments at Awakening 1, 5, 10 + 5 endings are the locked cinematic surface. No mid-game cinematic ambitions beyond that.
- **Real-name or real-event references.** All Xyoner figures, factions, brands, news segments, and events are fictional.
- **Voice acting beyond what is funded** — VO scope is a production decision; the design supports text-only delivery for unvoiced lines.
- **Mobile / tablet ports.** Not in scope.
- **Console launch in v1.** Steam Deck Verified at launch is the closest console-adjacent target. PS5 / Xbox is tertiary, not v1.

---

## Assumptions and Dependencies

### Design Assumptions (Locked)

- The Three Tracking Systems are code-distinct and legally defensible against US 10,926,179.
- The Truth Paradox is a *system*, not a narrative gesture — Credibility / Heat / NPC Trust are tracked numerically, every meaningful publication produces visible, traceable consequence.
- The Music Deterioration Mechanic ships at launch — not a post-launch addition. Composer pipeline locked at vertical slice.
- The Sleep ending ships at launch — not a post-launch addition. Marketing communications strategy includes briefing reviewers on it.
- Equal-opportunity satire is structurally enforced by the design (multi-faith Pulpit roster, ecumenical Vault and Cage, fictional Xyoner class). This is not a marketing-layer claim — it is in the design.
- The Schrödinger's NPC (Dave) is a launch feature.
- Combat difficulty is tunable (encounter restart / day rewind / forgiving mode) — Hotline-Miami lethality is the default but not the only profile.

### Dependencies

- **Engine selection** (Unity / Godot / Unreal) — gating decision for architecture phase.
- **Team scope confirmation** (solo / small team / publisher-backed) — gating decision for timeline and budget realism.
- **Legal review of the Three Tracking Systems** vs. US 10,926,179 — required pre-launch, ideally pre-vertical-slice ship.
- **Composer engagement** with capacity for multi-version music pipeline — required at vertical slice.
- **Writing tooling investment** — dialogue tooling, skill-check tooling, internal-voice tooling, conversation-log tooling — required before scaling word count past vertical slice.
- **IP-counsel relationship** for satirical-content edge cases (platform certification, region-specific risk).
- **Tone calibration playtests** for the satire — required external eyes before Early Access launch.
- **Inner Ring narrative finalization** — size of Inner Ring + identity of the manipulator — required before endgame implementation (Open Question per Game Brief).
- **Talent balance numbers** — locked names and archetypes; specific rates / ranges / durations finalize during architecture / balance pass.

### External Inputs Required

- **Architecture phase deliverable** — system architecture, engine choice, code-level legal-distinction documentation.
- **Epics & Stories breakdown** (`/gds-create-epics-and-stories`) — converts this GDD's Epic Structure into actionable stories.
- **UX Design** (`/gds-create-ux-design`) — detailed UI specifications for HUD, dual-aesthetic UI, three-layer investigation UI, War Room.
- **Narrative Design** (`/gds-create-narrative`) — comprehensive narrative documentation, character writing, boss arc detail, Awakening Track beat detail, ending writing.

---

## Appendices

### A. Source Document References

- **Primary inputs:**
  - [Game Brief](game-brief.md) — locked
  - [Brainstorming Session 2026-05-03](brainstorming-session-2026-05-03.md) — locked, 670 lines, 100+ design decisions
- **Workflow context:**
  - `docs/asset-generation.md`
  - `docs/my-workflow.md`

### B. Tonal & Mechanical References

| Reference | What we take | Where we depart |
|---|---|---|
| Disco Elysium (ZA/UM, 2019) | Skill voices, dialogue depth, internal monologue, thought cabinet, visible-DC skill checks, satirical tone | Real-time combat, living world, full RPG systems beneath dialogue |
| Return of the Obra Dinn (Lucas Pope, 2018) | Investigation as core mechanic, deduction-based progression, evidence cross-reference | Persistent world, ongoing time, social systems, multiple paths per truth |
| Papers Please (Lucas Pope, 2013) | Routine-as-gameplay, banal-evil tone, subtle moral pressure | Free movement, RPG depth, action layer, freedom to ignore |
| Hotline Miami (Dennaton, 2012) | Real-time top-down combat, lethality, instant restart, sound design as weapon, palette/tone cohesion | Stat-based modulation, capture as alternative to death, world-state persistence |
| Persona 5 / Stardew Valley | Day cycle, finite slots, social link / NPC progression, weekly rhythm | Politically dark satirical setting, no romance focus, day cycle is one layer of three |
| Fallout: New Vegas (Obsidian, 2010) | Faction reputation, dark satirical tone, branching consequences, multiple endings, build identity | 2D top-down, modern alt-Earth setting, no shooting-as-default |
| Shadow of Mordor / War (Monolith, 2014/17) | Adaptive enemy faction, recurring antagonists, faction that responds to YOU | Memory in dossier (not individuals); hierarchy in independent simulation (not player actions); legally distinct |
| Pathologic 2 (Ice-Pick Lodge, 2019) | Survival pressure as thematic device, consequences stick, no hand-holding | Satire over horror, action layer, larger world |
| Cruelty Squad / LISA | Edgy indie tonal fearlessness, satirical hostility, signature aesthetic choices | Production polish target, mainstream-CRPG legibility, longer playtime |
| Citizen Sleeper / Pentiment | Modern narrative-CRPG storytelling, time pressure, character-defined endings | Action layer, larger faction structure, longer arc |

### C. Patent Reference

- **US 10,926,179** — Warner Bros / Monolith "Nemesis System" patent. The Dossier / Politburo Simulation / Reputation Web triad is structurally distinct (memory in faction not individuals; hierarchy in independent simulation not player actions; individual NPC memory exists in non-hierarchical Reputation Web). **Legal review pre-launch required.**

### D. Open Questions Carried from Game Brief

These are unchanged from the Game Brief and remain open for the architecture / narrative / production phases. They do **not** require re-elicitation at GDD stage.

1. Engine choice — Unity / Godot / other.
2. Team scale and funding model — solo vs. small team; self-funded vs. Kickstarter vs. publisher.
3. Inner Ring size — number of members in "The Arrangement." Drives endgame structure and cinematic scope.
4. Talent balance — 40 talents named and archetyped, individual rates / ranges / durations TBD.
5. Localization at launch — English only, or include further-tier languages.
6. Ironman mode default-on or off — affects how day-boundary autosaves are felt.
7. Optional Markers Mode default state — accessibility decision.
8. Combat difficulty default — Hotline-Miami lethality / day-rewind / forgiving-mode.
9. Steam Workshop / modding support — extends community lifespan vs. engineering scope.
10. Inner Ring "one of them fed you info all along" — locked beat; *which one* and *why* needs writing now to avoid endgame inconsistency.

---

## Document Stewardship

**Status:** v1.0 — source-of-truth for Architecture and Epics phases.

**Source rule:** Where this GDD and the Game Brief disagree, the GDD is authoritative for design specification but does not override the Game Brief's locked scope or the Brainstorming Session's locked decisions. Any conflict that exists is a documentation error and should be resolved in favor of the locked-design source.

**Change rule:** Updates to this GDD require explicit user direction. The locked-design principle from the Game Brief carries forward — no re-scoping, no re-elicitation, no scope cuts proposed without user request.

**Next planning artifacts:**
1. `/gds-game-architecture` — system architecture + engine selection + code-level legal-distinction documentation.
2. `/gds-create-epics-and-stories` — breakdown of the 14 epics above into actionable stories.
3. `/gds-create-narrative` — comprehensive narrative documentation, boss arc detail, Awakening Track beat detail.
4. `/gds-create-ux-design` — detailed UI specifications.
5. `/gds-check-implementation-readiness` — pre-implementation gate before story execution begins.

---

_This GDD was produced from the locked Game Brief and Brainstorming Session per explicit user directive — no re-elicitation, no re-brainstorming, no scope cuts, no commercial / pricing / launch-model considerations. The design is locked. This document expands it into the GDD format._
