# Dialogue Framework

## Dialogue Style

**Overall Voice:** Sharp, satirical, willing to be funny. **Disco Elysium DNA + Fallout dark humor + Cruelty Squad tonal fearlessness, modernized for a media-literate audience.** The dialogue's job is to make the player *feel the texture of compliance and the cost of clarity* — not to explain the plot. **No exposition dumps. The world is the information; the dialogue is the friction.**

**Style Elements:**

| Aspect | Setting | Notes |
|---|---|---|
| **Formality** | Variable per faction/character | Vault speaks corporate-formal, Slopside Gnoym speak casual, Cage speaks bureaucratic-precise, Pulpit varies by ideological lineage. |
| **Period** | Modern alt-Earth | Recognizable contemporary speech with brand names changed. No archaic registers, no period idiom. |
| **Verbosity** | Deep but not bloated | Disco-Elysium-tier word count overall (~300k+) but individual dialogue lines stay tight. Long where it earns its length (boss confrontations, internal monologues at high Awakening), terse where it doesn't (routine NPC interactions, NPC Mode passes). |
| **Humor** | Satirical-comedic baseline with deadpan dark register | Fallout-tradition dark comedy. Most jokes land at the expense of *systems*, not characters. The funniest moments are when characters describe horrors as if they're routine. |
| **Profanity** | Moderate, situational | Authentic to character. Slopside Gnoym swear casually; Vault executives don't. Profanity is a register marker, not a flavor decoration. |

**Character Voice Distinctions:**

- **Faction speech registers:** Each faction has its own dialogue grammar (per Step 4 boss tonal-register table). The Trough is cheerful TED-talk; the Feed is broadcast-polished; the Pulpit varies by lineage; the Cage is bureaucratic-fluent; the Vault is avuncular-charm-with-spreadsheet-precision.
- **Gnoym speech registers:** Gnoym from different districts have different casual-speech patterns. Slopside Gnoym are warmer and more cynical; Cubicle Belt Gnoym are more clipped and more anxious; Garden Gnoym (rare for the player to interact with) are formally polite in a way that conceals contempt.
- **The protagonist has no voiced dialogue.** The player's choices are written in author-tone selection text (per Disco Elysium convention) — what the protagonist *would* say, picked from a menu, but never delivered as voiced lines. This preserves the customizable-protagonist design from Step 4 (no fixed voice).
- **Inner Voices (24) each have a distinct speech personality.** Full roster below.

---

## The Inner Voices (24-Voice Internal Cast)

> Disco-Elysium-style internal monologue chorus. **Production confirmed: text-only delivery (per Step 4 production note from Indie).** Each voice scales activity and tone with **Awakening + Fatigue + Cope**. Low Awakening / Low Fatigue / High Cope = quiet, infrequent, deferential. High Awakening / High Fatigue / Low Cope = overwhelming, contradictory, sometimes hostile chorus.

| Attribute | Voice | Personality | Function in Dialogue |
|---|---|---|---|
| **MIND** | **Rabbit Hole** | The compulsive forum-poster. Tireless, dangerous. | Wants the player to follow more leads, even when the trail is cold. |
| MIND | **[X] Fatigue** | The pattern-recognition demon. Speaks louder the more tired the player is. | Surfaces hidden connections; will not let things go. |
| MIND | **Doxcraft** | Precise, methodical, slightly inhuman. | Names names. Identifies people by metadata. |
| MIND | **Edit Farm** | Sardonic. Sees the cuts before they happen. | Identifies how a media artifact was constructed/manipulated. |
| **SOUL** | **Glowie Sense** | The paranoid friend. Sometimes wrong, sometimes the only one right. | Flags Cage assets, planted evidence, and infiltrators. |
| SOUL | **Yap Game** | Warm, social, observational. | Reads NPC body language and emotional state. |
| SOUL | **Lore Depth** | The historian. Always has context the player didn't ask for. | Provides historical/factional background to current moment. |
| SOUL | **Based Talk** | Direct, unvarnished, occasionally inflammatory. | Cuts through euphemism. Names what's actually happening. |
| **MOUTH** | **Rizz** | The charm. Loves the sound of its own voice. | Smooth-talking options; gets the player into trouble it can't get out of. |
| MOUTH | **NPC Mode** | Quiet, almost monotone. | Activates compliant-Gnoy speech patterns. Lets the player pass as fully Gnoy. |
| MOUTH | **Ratio** | Sharp, dismissive, internet-fluent. | Demolishes weak arguments in conversation. |
| MOUTH | **Clout** | Performative, theatrical, reads-the-room. | Plays to crowds, shifts dialogue for audience effect. |
| **GHOST** | **Ghost Mode** | The voice of caution. Wants the player to leave the room. | Risk-aversion options; finds the exit. |
| GHOST | **Normie Cosplay** | Mild, agreeable, deeply suspicious of being seen. | Helps the player blend in, dress down, fake routine. |
| GHOST | **Receipts** | Methodical, evidence-focused, paranoid-about-paper-trail. | Surfaces evidentiary risk in current scene. |
| GHOST | **OPSEC** | Quiet, professional, military-precise. | Identifies surveillance vectors and operational risk. |
| **BODY** | **Gymmaxx** | Confident, simple, dependable. | The voice that just wants to do something physical. |
| BODY | **Hands** | Direct, lethal, unafraid of escalation. | Surfaces violent options. The voice of "this could be a fight." |
| BODY | **Anti-Slop** | Disgusted, tired of compromise. | Refuses to eat the slop. Tracks bodily compromise. |
| BODY | **IRL Build** | Practical, grounded, weight-room-honest. | Surfaces physical-reality reads (this person is bigger than you think; this lock is weaker than it looks). |
| **SIGNAL** | **Web** | Networked, distributed-thinking, pattern-aware across cells. | Connects current moment to broader resistance network state. |
| SIGNAL | **Ghost Protocol** | Quiet, technical, signal-aware. | Surfaces digital-surveillance risk and counter-options. |
| SIGNAL | **Sneaky Links** | Conspiratorial, gossip-fluent. | Surfaces who-knows-whom across the underground network. |
| SIGNAL | **Signal Hijack** | Aggressive, broadcast-aware. | Surfaces opportunities to inject into Xyoner channels. |

**Voice scaling rules:**

- **Awakening Level 1-2:** Inner Voices speak in occasional 1-line interjections. Maximum 1 voice per dialogue beat. Low frequency.
- **Awakening Level 3-5:** Voices begin disagreeing visibly. Up to 2-3 voices per dialogue beat at major moments. Player can sometimes choose which voice to act on.
- **Awakening Level 6-8:** Voices form a chorus. Up to 4-5 voices per major moment. Some voices begin contradicting each other openly. **Cope drops here become noticeable** — low-Cope players see the chorus go aggressive.
- **Awakening Level 9-10:** Full chorus available. The player has trained the voices through years of action. Voices the player trusted speak with authority; voices the player ignored speak with resentment. **The Inner Voices' final state IS a player-built character.**
- **High Fatigue at any level:** [X] Fatigue, Rabbit Hole, and Glowie Sense get amplified; NPC Mode and Cope get suppressed. **The price of clarity is the inability to perform compliance.**

---

## Branching Dialogue System

**System Type:** Skill-gated branching with visible DCs, hidden consequences, and convergent-with-divergent-flavor structure.

**Branch Triggers:**

- **Skill checks** with visible DC (e.g., "Rabbit Hole 12") — player sees the difficulty, doesn't see what success or failure produces.
- **Build state** — disposition axes (GNOY↔AWAKE, PASSIVE↔REBEL), current Awakening Level, Fatigue, and Cope all gate or modify available lines.
- **Item drops in dialogue** — if the player has a specific evidence item, dossier entry, or signature weapon in inventory, additional dialogue lines unlock that wouldn't otherwise exist.
- **Reputation Web state** — what specific NPCs (and the gossip from them) have heard about the player.
- **Faction Standing** — current standing with the relevant faction modifies available approaches.
- **Past dialogue choices** — the conversation log is weaponized: NPCs quote the player back, the Cage references prior interrogations, the Feed edits prior soundbites.

**Branch Scope:**

- **3–5+ paths per dialogue goal**, gated by different skill builds. A goal that a Rabbit-Hole+MIND build solves through evidence presentation should also be solvable by a Rizz+MOUTH build through social manipulation, by a Hands+BODY build through implicit threat, and by a Ghost+GHOST build through never having the conversation in the first place.
- **Convergence with divergent flavor:** Most dialogue trees converge on the same handful of mechanical outcomes (information learned, faction standing changed, recruit gained/lost). The *flavor* of how the player got there persists in the conversation log and is referenced by future NPCs.
- **Unique content estimate:** ~30-40% of dialogue lines are build-specific (only fire for specific skill thresholds, items, or disposition states). Boss confrontations have higher unique-content density (~50-60%). Routine NPC interactions are more convergent (~15-20%).

**Consequence System:**

- **Visible DC, hidden consequence.** This is the central design rule: the player sees the difficulty, never the outcome of the alternative. Kills save-scumming. Preserves build expression. Forces the player to commit to who they are.
- **Conversation log weaponization (per Brief, locked).** Every spoken line enters the log. Cage interrogation of Gnoym the player has spoken to lifts conversation log content verbatim into the player's dossier. Feed editorial selects and edits soundbites for narrative weaponization. NPCs quote the player back at later moments. **The player's words are the slowest-acting weapon in the game, used against them.**
- **Item-drop unlocks** are persistent — finding the right evidence item retroactively unlocks lines in repeatable dialogues. The player can revisit conversations with new items and find new options.
- **Reputation Web ripples** — gossip spreads through Slopside-tier NPC networks. A conversation with one Gnoym can change available openings with another Gnoym three districts away. The player feels this as new dialogue options appearing in unexpected places.

---

## Key Conversations

> Listed by narrative weight, not chronology. Full dialogue tree authoring belongs to per-conversation production sub-docs at writing time.

### Tier S — Structurally Load-Bearing

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **The Schrödinger's Dialogue with Dave (Beat 8)** | Player + Dave | First voluntary dialogue at Greystone | Permanently locks Dave's three-state arc. *The single most important dialogue in the game.* High unique-content density across the three branches. |
| **"Goodbye, Dave" (Beat 13 force-trigger)** | Player + Dave | Quitting the Greystone job, if Beat 8 unfired | Force-resolution of Dave's arc based on accumulated state. State-conditional dialogue tree. |
| **The Trusted Anchor Confrontation** | Player + Trusted Anchor | Boss investigation completion | **Dialogue boss with multi-stage composure HP.** Anchor begins polished, cracks into raw exhaustion under skill-check pressure. Sympathetic resolution available. |
| **The Debt Dealer Confrontation** | Player + Debt Dealer | Boss investigation completion | **Dialogue boss with multi-stage composure HP.** Dealer knows player's file before sitting down. Multiple resolution states including potential informant conversion. |
| **The Inner Ring Betrayal Reveal (Beat 5)** | Player + The Mole | Endgame approach | The Kishōtenketsu twist. Mole identity TBD per Step 4. Recontextualizes entire campaign. **Production-correctness constraint:** dialogue must pull from the Dossier UI's anonymous-tip log. |
| **The "We Don't Know" Refusal (per Step 5)** | Player + a defected Inner Ring member | Awakening 9+, Compound approach | The in-character refusal of the deepest world question. Single-scene, high-impact. |
| **The Endgame Trigger Commitment** | Player + Inner Voice chorus | Player-decided endgame entry | The protagonist's irreversible commitment. Inner Voices form full chorus. State-conditional dialogue branches into one of 5 endings. |

### Tier A — Major Dramatic Moments

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **First Underground Forum Post Reply (Beat 10)** | Player + anonymous forum contact | First voluntary forum post | Player's first network contact. Forum chat dialogue tree. Establishes the Forum as a relationship, not a UI. |
| **First Boss Investigation Publication Decision (Beat 12)** | Player + Inner Voices | Dossier Interface publication moment | The first concrete encounter with the Truth Paradox. The voices argue. The player commits. |
| **Each Recruit's Initial Recruitment Dialogue** | Player + prospective recruit | Recruit personal quest completion | High-stakes branching dialogue. Wrong tone permanently loses the recruit. |
| **Each Recruit's Erosion Dialogues** | Player + named recruit | Loyalty-degradation moments | The relationship is in the conversation. Loyalty resolution paths gate here. |
| **Cage Interrogation (if captured)** | Player + Cage interrogator | YIELD outcome from combat | GUT check limits dossier damage. Branching tree of admissions vs. silences. |
| **Each Faction's COMPROMISED→OWNED Confessional** | Player + faction-internal contact | Faction Standing maxed | Sympathetic late-faction-life dialogue. Source of Inner Ring inference dialogue (Beat 21 trigger). |

### Tier B — Recurring System Dialogues

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **Glowie Honeypot Dialogues** | Player + Glowie-archetype NPC | Recurring, multiple instances | Replayable detection-or-fail-detection scenarios. Glowie Sense voice gets first read. |
| **Forum Chat Threads** | Player + named forum contacts | Apartment laptop interactions | Background lore + side quest hooks + Hidden Secret discovery paths. |
| **GnoyNews Encounter Reactions** | Player + Inner Voices | Watching daily news segment | Internal monologue reaction to Feed content. Awakening + Fatigue scaling. |
| **Routine NPC Interactions** | Player + Gnoym Reputation Web NPCs | District-based, recurring | Reputation Web maintenance. Most convergent dialogue tier. NPC Mode voice can suppress for full pass. |

---

## Production Notes (carried forward to Step 10)

- **Dialogue volume estimate:** Disco-Elysium-tier (~300k+ words) — confirmed from Brief. Largest single content cost line item.
- **VO scope:** **Text-only for Inner Voices (confirmed).** Voice acting recommended only for boss dialogue (13 bosses, weighted heavily toward dialogue bosses Trusted Anchor and Debt Dealer) and key NPCs (Dave, named recruits, defected Inner Ring member). All other dialogue text-only.
- **Tooling requirements:** Dialogue authoring tool must support visible-DC tagging, hidden-consequence linking, item-drop conditionals, conversation-log weaponization (each line tagged for later quote-back retrieval), Reputation Web ripple triggers, and Inner Voice scaling rules. **This is significant tooling investment — must be locked before scaling content.**
- **Writing pipeline:** Tier-S dialogues authored in vertical slice. Tier-A dialogues authored at EA launch. Tier-B dialogues populated at full launch with template-and-fill workflow.
- **Localization scope:** 300k+ words drives translation cost decisively. Decision deferred to Step 10. **English-only at launch is the realistic bias.**

---
