---
title: 'Narrative Design Document'
project: 'Gnoy Simulator'
date: '2026-05-03'
author: 'Cpain'
version: '1.0'
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
status: 'complete'
narrativeComplexity: 'Heavy'
gdd: '_bmad-output/gdd.md'
---

# Narrative Design Document

## Gnoy Simulator

### Document Status

**Narrative Complexity:** Heavy
**Status:** Complete (11 of 11 steps)
**Recommended scope path:** Solo + Vibe Coding Ship Target (~80-120k words)

---

## Story Foundation

### Narrative Premise

You wake up as a Full Gnoy Wageworker in an alt-Earth dystopia ruled by the Xyoners — a malignant oligarch class whose grip is maintained through fast food, social media, wage slavery, religious extremism, debt, and surveillance. One staged news event cracks your reality open. From that moment on, you decide — moment by moment, day by day — how much of the truth you can stand to see, document, broadcast, and act on. The conspiracy is real. The truth is punished. And living a fully compliant Gnoy life remains, until the credits roll, a valid ending.

### Core Themes

1. **Manufactured consent and the texture of compliance.** The snooze button, the auto-deducted subscription, the cheerful billboard. The game's claim is that the dystopia is felt before it is seen.
2. **The Truth Paradox.** Correctness and danger rise together. Credibility and Heat are zero-sum at the publication interface. Framing — not evidence — is the moral skill.
3. **Awakening as cost, not victory.** Clarity comes with Fatigue, Heat, social isolation, and the loss of NPC Mode. The Awakened player is playing a harder game on the same map, by choice.
4. **Equal-opportunity satire of ideology.** The target is documented extremist behavior across Christian, Muslim, and Jewish ideological lineages, plus the ecumenical Vault and Cage. The Xyoners are a fictional class. The satire targets behavior, not faith.
5. **The world doesn't revolve around you.** Politburo Simulation runs whether the player acts or not. Cold cases exist. Missing things is possible. The game judges nothing.

### Tone and Atmosphere

**Tone:** Satirical/comedic in the Fallout tradition — dark humor, absurdist corporate evil, deadpan banal-evil register. *They Live* meets *American Beauty* meets *Don't Look Up* meets *Disco Elysium*, with *Cruelty Squad* tonal fearlessness held back from the edge by mainstream-CRPG legibility.

**Atmosphere:** Two opposed visual/audio palettes that the player learns to read as a signal of Xyoner influence:

- **Xyoner / corporate spaces:** oversaturated, too vibrant, too clean, too cheerful. Slick corporate audio. The artificial cheer IS the satire.
- **Slopside / The Hollow:** desaturated, grey-yellow, authentically grimy. Lo-fi melancholic ambient. Real color, real life.

As the Awakening Track rises, the corporate palette and music audibly *deteriorate* — by Awakening 7, McXyon's brand jingle plays as a damaged file. The atmosphere itself is gameplay.

**Emotional Register:** Complicit → queasy → awake. The player should feel implicated before they feel righteous, and isolated before they feel powerful. No power-fantasy beats. No triumphant catharsis at the major endings — even The Public Reckoning leaves the player burned out and morally compromised. The Sleep ending is treated with the same compositional care as the others.

---

## Story Structure

### Structure Type

**Player-Authored Awakening Arc with Branching Resolution.** A custom hybrid: a 10-level Awakening Track provides a soft macro spine with fixed cinematic beats at Levels 1, 5, and 10, while the Main Quest ("The Arrangement") is loose, marker-free, and player-paced. Five distinct endings branch from the player's accumulated state at the moment they trigger endgame. There is no scripted three-act arc; the *systems* generate the act structure of any given playthrough.

### Act Breakdown (soft, system-generated, anchored to Awakening Track)

| Act | Awakening Track | Player State | Anchor Beat |
|---|---|---|---|
| **Prologue** | 0 (pre-awakening) | Full Gnoy Wageworker. Greystone job, slop subscriptions, no underground awareness. | "A Perfectly Normal Morning" — the 15-minute contextual tutorial. Ends with the doctored Feed segment. |
| **Act I — The Crack** | 1–2 | First red-pilling. Apartment homebase. Underground forum bookmarked. First subscription cancellation. The Schrödinger's NPC choice with Dave. | Awakening Level 1 cinematic. First Faction FLAGGED status. |
| **Act II — The Documentarian** | 3–5 | Office homebase. First 2–3 recruits. First boss investigation completed. First major publication (Credibility-vs-Heat moment). The truth-paradox loop becomes legible to the player. | Awakening Level 5 cinematic. AntiXyonetic label canonized in Feed dossiers. |
| **Act III — The Network** | 6–8 | Underground HQ + War Room. Multi-faction operations. Politburo events the player has *caused*. Inner Ring dossier first becomes inferable. Cage raids become a real threat. | Inner Ring "one of them fed you info" first hints — Analyst flag in War Room. |
| **Act IV — The Arrangement** | 9–10 | Distributed cell network. Inner Ring identification (or active misidentification). The Compound is approachable. Endgame trigger is player-decided. | Awakening Level 10 cinematic. The 5-ending branch point. |
| **Coda** | n/a | One of: The Public Reckoning / The Shadow Replacement / The Burn / The Long Game / The Sleep. Each is a credits sequence + epilogue, not a victory screen. | Ending-specific. |

**Key structural notes:**

- **The Sleep ending is structurally co-equal.** The player can credits-roll from Act I onward by simply continuing to live a Gnoy life until the financial pressure resolves into a steady state. This ending receives the same compositional treatment as the others.
- **Acts are descriptive, not gated.** The player can spend 30 in-game weeks in Act II if they want. The Awakening Track does not auto-advance — it advances on player action.
- **The Inner Ring "one of them fed you" reveal is the structural twist** in the Kishōtenketsu sense — re-frames the entire prior arc at the moment of reveal.
- **No urgency timer on the Main Quest.** The world drifts via the Politburo Simulation, but the player is never on a clock.

---

## Story Beats

### Major Story Beats

A Heavy-narrative game with system-generated pacing has three beat tiers:

- **Authored beats** — fixed moments that always happen at roughly the same Awakening point (cinematic or scripted).
- **Triggered beats** — major moments the *systems* fire when the player crosses a threshold. Order and timing vary per playthrough.
- **Sleep-path beats** — authored beats specific to the playthrough that *refuses* awakening. Co-equal to the Awakened-path beat list.

#### Authored Beats (fixed cinematic / scripted moments)

| # | Beat | Type | Anchor |
|---|---|---|---|
| 1 | **A Perfectly Normal Morning** | Authored — opening sequence | Prologue, ~15 min contextual tutorial |
| 2 | **The Doctored Feed Segment** | Authored — inciting incident | End of Prologue. The first time the central premise is *demonstrated* rather than narrated. |
| 3 | **Awakening Level 1 cinematic** | Authored — cinematic | Crossing into Act I |
| 4 | **Awakening Level 5 cinematic** | Authored — cinematic | Crossing Act II→III boundary; AntiXyonetic label canonized |
| 5 | **The Inner Ring "Betrayal" Reveal** | Authored — structural twist (Kishōtenketsu) | Endgame approach. One Inner Ring member fed the player info all along to eliminate rivals. |
| 6 | **Awakening Level 10 cinematic** | Authored — cinematic | Final cinematic. The 5-ending branch point. |
| 7 | **The Coda (one of 5 endings)** | Authored — credits + epilogue | Public Reckoning / Shadow Replacement / Burn / Long Game / Sleep |

> **Threshold Jump Behavior:** When the player crosses multiple Awakening levels in a single action (e.g., a god-tier publication that jumps Awake 4 → 8), missed cinematic-anchored levels (1, 5) play first as a brief flashback-frame reflection before the higher state takes effect. The cinematic beat is never skipped — only re-framed as memory if it fires retroactively. This preserves authored beat integrity under skip-threshold edge cases.

#### Triggered Beats (system-generated milestone moments)

| # | Beat | Trigger | Significance | Solo/no-HQ fallback |
|---|---|---|---|---|
| 8 | **The Schrödinger's NPC Choice (Dave)** | First voluntary dialogue with Dave at Greystone | Permanently locks Dave's arc. Player is unaware of the stakes. | If the player avoids Dave for the entire Greystone tenure, **quitting the job force-triggers a "Goodbye, Dave" dialogue that resolves him to one of three states based on accumulated Awakening / Disposition at quit-time.** No Dave-in-limbo state exists. |
| 9 | **First Subscription Cancellation** | Player cancels any recurring slop subscription | First mechanical Awakening Track tick. First Feed dossier "possible radicalization" flag. | n/a |
| 10 | **First Underground Forum Post** | Player posts to the forum bookmarked on the apartment laptop | First voluntary act of awakening community-building | n/a |
| 11 | **First Faction FLAGGED** | Any faction reaches FLAGGED standing | First confirmation the Xyoner network sees the player | n/a |
| 12 | **First Boss Investigation Closed** | Any of the 13 boss investigations resolved | First major Truth Paradox publication choice (Credibility-vs-Heat). The loop becomes legible. | n/a |
| 13 | **Quitting the Greystone Job** | Player quits the cover job | Major life threshold. Spikes financial pressure but opens daily slot capacity. **Force-triggers Beat 8 if unfired.** | n/a |
| 14 | **First Recruit Joined** | First specialist recruited to homebase | Shifts game from solo to network. | Solo builds skip this beat permanently — its narrative weight transfers to Beat 10 (Forum Post) as the player's primary "I am not alone" moment. |
| 15 | **Move to Office Homebase** | Recruit count + Awakening threshold | Stage 2 homebase. Bigger operation, paper-trail vulnerability. | Solo builds skip — the apartment is permanent home. |
| 16 | **First Recruit Lost** | Cage raid OR defection OR voluntary break | First permanent cost paid. The price of the network becomes real. | Solo builds: replaced by **First Forum Contact Lost** (an awakening-forum acquaintance vanishes — implied disappeared/Glowified). |
| 17 | **Underground HQ + War Room Online** | Stage 3 homebase unlock | Full operation begins. Analyst can build live dossier board. | Solo builds skip — see Beat 21 fallback. |
| 18 | **First Player-Caused Politburo Event** | Analyst surfaces explicit causal call in War Room | Feedback loop visible. The world responded to the player. | Solo builds: fires when an in-game news segment reports an event the player can connect to their action via Thought Cabinet thread completion. Same emotional payoff, different surface. |
| 19 | **First Faction COMPROMISED → OWNED** | Faction Standing maxed | First faction effectively run by the player | n/a |
| 20 | **First Cage Raid Survived (or HQ Lost)** | Heat threshold + player exposure | Survival moment. Possible permanent recruit / equipment / homebase loss. | Solo builds: a Cage stakeout/snatch attempt on the apartment, GHOST + Gymmaxx check to escape. Same beat, no recruit losses available. |
| 21 | **First Inner Ring Inference** | Analyst confidence threshold reached in War Room | Inner Ring stops being abstract. Player sees the dossier graph fill. | Solo builds: fires via Thought Cabinet thread completion — the lone investigator's mental model substitutes for the War Room dossier graph. Same narrative significance. |
| 22 | **Distributed Cell Network Online** | Stage 4 homebase unlock | No single point of failure. The Network beat. | Solo builds skip — replaced by **Anonymous Network Established** (the player has built a distributed forum/dead-drop network of awakened contacts they've never met in person). |
| 23 | **Endgame Trigger** | Player-decided | Player declares they're ready. The 5-ending branch resolves from accumulated state. | n/a |

#### Sleep-Path Beats (authored — for the playthrough that refuses awakening)

| # | Beat | Trigger | Significance |
|---|---|---|---|
| S1 | **The Forum Bookmark Deletion** | Player deletes the underground forum bookmark from the apartment laptop without ever posting | Active rejection of the awakening invitation. Mirror-image of Beat 10. |
| S2 | **The Subscription Renewal** | Player re-subscribes to a previously cancelled slop subscription | Active mechanical re-compliance. Mirror-image of Beat 9. The Awakening Track ticks *down*. |
| S3 | **"Dave Stays a Friend"** | Player picks Default-Gnoy answer in Beat 8 AND maintains the friendship across multiple workplace dialogues | The full payoff of the Default Schrödinger's branch. Shared lunches at the slop court. The texture of compliance as warmth. |
| S4 | **The Promotion Offer** | Player demonstrates sustained Greystone-job loyalty + Low Awakening across several months | Greystone offers a meaningless promotion (more pay, more meaningless work). Accepting locks Sleep ending trajectory. |
| S5 | **The Quiet Years** | Triggered by sustained low-Awakening, low-Heat, fully-subscribed lifestyle for an extended in-game duration | Final Sleep-ending beat. Credit-sequence montage of routine. Dave grows older. The Feed plays in the background. The world the player started in remains the world they end in. **Same compositional care as the other 4 endings' codas.** |

### Beat Placement by Act

**Prologue:** 1 (Morning), 2 (Doctored Feed)

**Act I — The Crack:** 3 (Awake L1), 8 (Dave choice), 9 (First sub cancel), 10 (Forum post), 11 (First FLAGGED)

**Act II — The Documentarian:** 12 (First boss), 13 (Quit job — also force-resolves Dave if needed), 14 (First recruit), 15 (Office homebase), 4 (Awake L5), 16 (First recruit lost)

**Act III — The Network:** 17 (HQ + War Room), 18 (First Politburo event), 19 (Faction OWNED), 20 (Cage raid), 21 (Inner Ring inference)

**Act IV — The Arrangement:** 22 (Distributed network), 5 (Inner Ring Betrayal Reveal), 6 (Awake L10), 23 (Endgame trigger)

**Coda:** 7 (One of 5 endings)

**Sleep Path (parallel structure):** S1, S2, S3, S4, S5 — fires across Prologue → Act I and then resolves directly to Coda 7 (Sleep ending). Sleep-path playthroughs may also fire any Awakened-path triggered beat that fits (e.g., a player can post to the forum once and then delete it later — beats 10 and S1 both fire). The two paths are not mutually exclusive until the player commits.

---

## Pacing and Flow

### Narrative Tempo

**Slow burn, system-paced.** The game does not enforce tempo on the player. A Sleep-ending playthrough can be 5–10 hours of low-tension daily routine. A Public Reckoning playthrough can be 60+ hours of accelerating pressure. The *systems* generate tempo:

- **The Day Cycle** enforces rhythmic pacing — finite morning/afternoon/evening slots create natural pause points and recovery beats.
- **Heat** generates ratcheting pressure — push, force-dark, recover, push again.
- **Awakening Track** is the long-arc tempo spine — each level shifts the felt-stakes upward without altering the moment-to-moment loop.
- **Politburo Simulation drift** provides background tempo independent of player action — the world is moving even when the player is sleeping.

### Tension Curve

**Ratcheting pressure on a rising baseline.** Within a session: tension rises during a thread, peaks at a publication or combat encounter, releases at sleep. Across the campaign: each ratchet's baseline floor and ceiling rise as Awakening rises. By Act III, "low tension" feels like Act I peak tension. The Day Cycle's slot discretization and the sleep-cycle reset produce a rising-baseline rhythm of escalating crisis-and-cooldown beats — not waveform-smooth, but stair-stepped and punctuated.

- **Local peaks:** Boss confrontations (especially dialogue bosses — Trusted Anchor, Debt Dealer), Cage raids on homebase, publication moments at the Dossier Interface, Schrödinger's NPC dialogue choices.
- **Mid-campaign valleys:** Settled office homebase periods, recruit personal quest dialogue scenes, slop-subscription audit montages.
- **Endgame plateau:** Act IV holds sustained high tension — no real valleys — until the Endgame Trigger releases into the Coda.

### Story Density

| Section | Density | Notes |
|---|---|---|
| **Prologue** | Very high — heavy authored beats | 15 minutes of pure scripted contextual tutorial. Highest written-content-per-minute ratio of the game. |
| **Act I** | Medium — guided exploration | Player learning systems. Authored Awake L1 cinematic + Dave choice are the heavy moments. |
| **Act II** | Variable — first heavy player-driven section | Density depends on which boss the player chases. Recruit personal quests add density spikes. |
| **Act III** | Heavy — most simultaneous threads | War Room, multiple factions in play, Inner Ring inference. Maximum surface area. |
| **Act IV** | Heavy — convergence | All Inner Ring, Compound, faction-owned playstates resolve. The Betrayal Reveal is the highest single-scene density of the game. |
| **Coda** | Very high — authored ending | Each ending is a fully-authored credits + epilogue sequence. |

### Key Moments

- **Highest tension:** **Endgame Trigger (beat 23)** — the player's irreversible commitment moment. Knowing one of 5 endings will fire from current state, with no take-backs. The breath held before the result.
- **Highest dramatic pivot:** **The Inner Ring Betrayal Reveal (beat 5)** — the Kishōtenketsu twist that recontextualizes the entire prior arc. Highest single-scene density.
- **Emotional climax:** **Awakening Level 10 cinematic (beat 6)** — the player's last moment alone before the ending choice. Music deterioration is at its peak; the world the player started in is unrecognizable.
- **Resolution beat:** **The Coda (beat 7)**. Each of the 5 endings has its own resolution register — Public Reckoning is bittersweet, Shadow Replacement is morally compromised, Burn is destructive catharsis, Long Game is patient melancholy, Sleep is quiet defeat. **No ending is triumphant.**
- **Lowest-key but designed-to-haunt:** **The Schrödinger's NPC Choice (beat 8)** — the player won't realize for 20+ hours that this was a beat at all.

---

## Characters

### The Player Character

#### Default Starting State: Full Gnoy Wageworker

**Description:** A nameable, customizable character who begins as one of the Greystone Data Solutions employees — fully compliant, fully subscribed, fully fed. Generic Gnoy starting kit: low MIND, low SOUL, high GUT, zero SIGNAL. Body type, gender presentation, name, and starting cosmetic items are player-defined. The character has no fixed face, no fixed voice, no fixed backstory beyond the locked Gnoy starting state — the player fills those in by play.

**Background:** Lives in a Slopside-tier apartment (~Cubicle Belt commute). Works at Greystone, a 340-employee company that processes nothing. Has the underground forum bookmarked on the laptop without remembering why. Watches GnoyNews. Eats slop. Nothing in their backstory is dramatic. Their alleged life is the satire's premise: the texture of a manufactured ordinary life.

**Motivation:** *Determined by play.* The default-state Gnoy has no motivation beyond compliance and slop. The character's actual motivation emerges from the player's response to the Doctored Feed Segment (Beat 2). Possible drives the systems support:

- **The Documentarian:** truth must be recorded
- **The Wrecker:** the system must be hurt
- **The Survivor:** the goal is to live with eyes open
- **The Operator:** the goal is to *use* the awakening for personal advantage
- **The Refuser:** the goal is to go back to sleep (Sleep ending)

**Strengths:** *Determined by build.* The 7-attribute, 24-skill, 40-talent system means the player chooses what the protagonist is good at. There is no Chosen One trait. There is no special bloodline. There is no destiny. The character is a normal person who happened to witness one staged event and chose to do something about it (or not).

**Flaws:** Built into the design — the protagonist is *always* compromised. They started as a Gnoy. They participated in the system. They ate the slop. They watched the Feed. Even at maximum Awakening, they cannot un-eat the slop or un-watch the years of Feed conditioning. The Slop Damage stat literally tracks the body's accumulated record of past compliance.

**Conflicts:**

- **Internal:** The Truth Paradox. The more correct your evidence, the more dangerous and discredited you become. The character cannot honor both safety and truth simultaneously.
- **Internal #2:** Cope vs. Awakening. Clarity costs mental resilience. Sustained Awakening drops Cope; low Cope amplifies internal voices into overwhelming chorus. The character must learn when *not* to look.
- **Internal #3 (build-conditional):** The protagonist's Disposition Axes (GNOY↔AWAKE, PASSIVE↔REBEL) shift with player choices. The character's *internal sense of who they are* is in active flux throughout the campaign.
- **External:** The Xyoner network — five factions, 13 boss archetypes, Inner Ring of unknown size, the entire surveillance and propaganda apparatus of the alt-Earth dystopia.
- **External #2:** Survival pressure. Rent. Slop subscriptions. The job at Greystone. Awakening costs money the protagonist doesn't have.

---

### Antagonists

#### The Xyoners (Collective Antagonist)

**Description:** A fictional malignant ruling oligarch class. Not a race. Not a religion. Not a real ethnic group. A made-up oligarchy whose grip on the alt-Earth is maintained through fast food, social media, wage slavery, religious extremism, debt, and surveillance. The Xyoners operate through Five Factions and an Inner Ring of unknown size called "The Arrangement."

**Background (lore-level):** Origin is intentionally vague. Some forum posts call them an ancient bloodline. Some call them a recent corporate consortium. Some call them a metaphor. The game does not resolve which is true — the answer is irrelevant to whether they are doing what they are doing. The point is *the behavior*, not the genealogy.

**Goals:** Continued grip. Stability of the Arrangement. Accumulation. Suppression of pattern recognition. The Xyoners do not have a single coherent end-state goal — they are a class, not a person, and their factions sometimes work against each other (the Cage-vs-Feed rivalry is exploitable).

**Methods:** The five faction operational arms — Trough, Feed, Pulpit, Cage, Vault. (Detail per faction in the boss archetype profiles below.)

**Relationship to Protagonist:** The protagonist is, by default, fully embedded in the Xyoner system as a productive Gnoy. The antagonism only becomes explicit once the player begins documenting. The Xyoners do not personally hate the protagonist — they pattern-match the protagonist as a threat, classify, and dispatch. The contempt is bureaucratic, not personal.

**Sympathetic Elements:** Each individual boss has them. The class as a whole does not. The Xyoners as a *class* are the satire's target. Individual boss arcs may include genuine human moments — the Trusted Anchor's exhaustion, the Debt Dealer's familial obligations, the Settlement Ideologue's grief — but these humanize the *individuals*, not the *class*.

#### The Inner Ring ("The Arrangement")

**Description:** The unknown-membership inner core of the Xyoner class. Referred to in documents as "The Arrangement." Number, names, and identities are unknown to the player throughout most of the campaign. Endgame structural twist: **one Inner Ring member has been feeding the player information all along to eliminate rivals.**

**Status: Identity TBD — open design question carried over from the Game Brief.** The narrative beat is locked. The *who* and *why* needs to be written before endgame implementation.

**Candidate Mole Archetypes** (Cpain to choose; party-mode debate captured for future reference):

1. **The Disgraced Successor** — A failed Inner Ring heir using the player to clear the field for a comeback. Sympathetic on the surface, parasitic underneath.
2. **The True Believer** — An Inner Ring member who genuinely believes the Arrangement has gone too far and is using the player as a controlled demolition. Tragic. The player's success was supposed to be limited and went past their control. *Party-mode majority pick (Samus, Sally, Mary) — strongest thematic alignment with the Truth Paradox; reveal forces re-read of every prior intel as having been sincerely-meant.*
3. **The Cynic** — An Inner Ring member who is simply bored, treating the Arrangement as a game and the player as a fresh piece on the board. Coldest reveal. *Party-mode contrarian pick (Indie) on production-cost grounds — minimal backstory dependencies, no per-thread sim-correctness constraint that "True Believer's intel was actually useful at every moment given" requires.*
4. **The Rival Faction Head** — Inner Ring member who heads one Faction and used the player to weaken the other four. The player wakes up at endgame having helped consolidate, not destroy. *Party-mode flag from Indie: requires Politburo Simulation correctness — the player's actions must mathematically have weakened the other four factions for the reveal to be coherent.*

**Decision deadline:** Before endgame implementation begins (likely Production Phase 3 or earlier).

#### The 13 Boss Archetypes (per-faction, archetype-level summary)

> Full character profiles for each boss belong in per-boss investigation sub-docs at production time. This document captures their *narrative function*, *tonal register*, and *cross-boss dependencies* — not full backstory or dialogue.
>
> **Production guidance:** Prototype 2 bosses fully through vertical slice (recommended: **Trusted Anchor** as dialogue-boss prototype + **Fact Checker** as documentation-defeat combat-light prototype). Lock the per-boss sub-doc template based on what worked in playtest before scaling to the remaining 11.

**Writing-budget tier asymmetry:** Not all 13 bosses cost the same to write.

- **Tier S (highest):** Trusted Anchor, Debt Dealer — full dialogue bosses with multi-stage composure HP. Estimated 5–10× the writing of a combat boss.
- **Tier A:** Engagement Architect, Intelligence Artisan, Benevolent Billionaire, Settlement Ideologue, Jihadist Franchise Operator — deep dialogue + faction-defining moments + sensitivity-review work for the two Pulpit entries.
- **Tier B:** Innovation Czar, Soil Baron, Revolving Door, Fact Checker, Prosperity Prophet, Think Tank Sage, Number Go Up Guy — standard boss writing.
- **Recurring:** Glowie — multiple instances, one shared character template re-skinned per encounter.

**Cross-boss dependency map:**

- **Vault funding crosses Pulpit** — Settlement Ideologue and Jihadist Franchise Operator share Vault funding (this is the structural device that makes equal-opportunity satire mechanically true). **Their dossiers must seed the Vault-funding reveal before either boss is fully resolvable.**
- **Feed continuity** — Trusted Anchor and Engagement Architect share Feed-faction infrastructure. The Anchor's defeat affects the Architect's algorithm-tuning options, and vice versa.
- **Cage thread** — Intelligence Artisan and the Glowie roster share dossier infrastructure. Defeating the Artisan degrades Glowie deployment effectiveness.
- **Vault internal** — Benevolent Billionaire's "philanthropy" is the upstream of Pulpit funding; Number Go Up Guy is the downstream of Trough/Feed monetization. **Vault is structurally the keystone faction.**

##### The Trough (3 bosses)

| Boss | Function | Tonal Register |
|---|---|---|
| **Innovation Czar** | The smiling tech-bro head of food R&D. Sells engineered slop as progress. Functions as the satire of "disruption" rhetoric. | Cheerful TED-talk vocabulary. Speaks in metrics. Believes the slop is *good for you, actually*. |
| **Soil Baron** | Land consolidator. The polite face of dispossession. Functions as the satire of generational property theft. | Old-money courtesy. Speaks of stewardship and legacy. Apologetic only when it costs nothing. |
| **Revolving Door** | Former regulator, now industry executive. Lives in both worlds. Functions as the satire of regulatory capture. | Bureaucratic-fluent code-switching. Knows every loophole because they wrote it. |

##### The Feed (3 bosses)

| Boss | Function | Tonal Register |
|---|---|---|
| **Engagement Architect** | Designs the algorithms. Optimizes outrage and addiction. Functions as the satire of platform engineering ethics. | Silicon-Valley philosophical detachment. "We just build the tools, the users decide." |
| **Trusted Anchor** | The face of GnoyNews. Earnest, exhausted, complicit. **Dialogue boss** (multi-stage composure HP). | Polished broadcast cadence under public pressure. Cracks into raw exhaustion under skill-check pressure. **Sympathetic — knows what they are doing and cannot stop.** |
| **Fact Checker** | Decides what is true. The most polite gatekeeper of acceptable narrative. Functions as the satire of "trust the experts" rhetoric. | Patient academic tone. Citations as weapons. Treats disagreement as a category error. |

##### The Pulpit (4 bosses — equal-opportunity satire of documented extremist ideologies)

> **Production note (high priority):** This is the highest-risk roster in the document for tone-misread reception. Mitigations required:
>
> 1. **Front-load the Vault-funding reveal** in early Pulpit boss writing. The structural balance only lands for completionists if the player learns about Vault funding *during* their first Pulpit boss encounter, not at hour 40. Without front-loading, the equal-opportunity claim is buried under hours of "this game is targeting [my group]."
> 2. **First-encounter sequencing matters more than content.** No Pulpit boss arc should be playable in complete isolation — they should always surface in pairs or in clear context of the Vault funding.
> 3. **Sensitivity-reader budget is currently unscoped.** This roster requires expert pre-publication review across four ideological frames. Add to Production Plan (Step 10).
> 4. **Open question for Cpain:** is the equal-opportunity-satire pillar served by *exactly four* Pulpit bosses, or would *three* hit the same structural claim with 25% less production cost? The argument requires *plural ideological lineages*, not *exactly four*.

| Boss | Function | Tonal Register |
|---|---|---|
| **Prosperity Prophet** | Christian-coded extremism. Megachurch, private jet, tax-exempt empire. Sells salvation as wealth signal. | American-Evangelical broadcaster cadence. Folksy with the camera off, fiery with it on. |
| **Think Tank Sage** | Secular-coded extremism. NGO-funded, op-ed-published, ideologically captured by donor class. Sells respectability as policy. | Op-ed page register. Gentle, professorial, devastating in implication. |
| **Settlement Ideologue** | Jewish-coded extremism (specifically: ideology, not faith — extremist Zionist settler movement). Sells dispossession as divine right. | Older-generation patriarchal certainty. Quotes scripture and policy interchangeably. *Highest specific reception risk in the roster.* |
| **Jihadist Franchise Operator** | Muslim-coded extremism (specifically: ideology, not faith — Vault-funded jihadist franchise). Sells martyrdom as franchise opportunity. | Mid-tier organizational manager voice. Speaks of recruitment funnels and territorial KPIs. *Highest European-platform-policy attention risk.* |

##### The Cage (2 bosses)

| Boss | Function | Tonal Register |
|---|---|---|
| **Intelligence Artisan** | The craftsman of personalized surveillance. Works for the State. Cares about their work. The most chilling because the most *competent*. | Quiet professional pride. Speaks the way a carpenter speaks about a well-made chair. |
| **Glowie** | Undercover informant who recruits awakening Gnoym into honeypots. **Recurring archetype** — multiple Glowies exist; defeating one fills the role with another. | Adaptive — mirrors the player's expected ally archetype. The same template re-skinned across encounters. |

##### The Vault (3 bosses)

| Boss | Function | Tonal Register |
|---|---|---|
| **Benevolent Billionaire** | The "philanthropist" who funds NGOs that restructure the world toward Vault interests. Smiling. Donates publicly. Functions as the satire of philanthrocapitalism. | Avuncular charm. Speaks of "giving back" with the cadence of someone reading their own press release. |
| **Debt Dealer** | Personal debt as compliance lever. **Dialogue boss** (multi-stage composure HP). Functions as the satire of consumer credit. Knows your file before you sit down. | Customer-service-rep professionalism over algorithmic hostility. Polite. Knows your vulnerabilities by line item. |
| **Number Go Up Guy** | The pure-financialization face. Asset stripping. Quarterly extraction. Functions as the satire of shareholder-primacy economics. | Trading-floor staccato. No moral vocabulary at all. Treats human suffering as a P&L line. |

---

### Supporting Cast

#### Dave (Schrödinger's NPC)

**Role:** First and most structurally important named NPC. Greystone coworker. Schrödinger's resolution to one of three locked states based on the player's first voluntary dialogue with him (or, if avoided, a force-resolution at job-quit per Beat 13).

**Description:** Mid-30s, early-40s. Cubicle next to the player's. Works at Greystone same as the player. Drinks the office coffee. Talks about the GnoyNews segment that morning. Has small frustrations about his manager. Has a daughter he mentions sometimes. He is, on the surface, indistinguishable from any of the 339 other Greystone employees. He is the most ordinary person in the game. He is also the most narratively load-bearing character besides the player.

**Personality (state-dependent):**

- **Default-Gnoy state** (player's first dialogue answers from inside the Gnoy worldview): Dave is a friend. The friendship is real. He shares his sandwich. He laughs at the player's jokes. He talks about his daughter. He never awakens. *He is the heartbreak of resistance — the genuinely good person whose life remains inside the system the player chooses to leave.*
- **Real-answer state** (player's first dialogue shows partial pattern recognition): Dave's eyes change in that single conversation. He starts dropping crumbs over the next several workplace interactions. He becomes the **first specialist recruit** if the player builds the relationship — typically the **Researcher** specialist.
- **Too-awakened state** (player's first dialogue is too sharp, too direct, too soon): Dave reports the player. Becomes a **Glowie** even if he wasn't one before, or revealed-as-Glowie if he was. The first Cage flag against the player traces back to this conversation.

**Function in story:** Dave is the **demonstration** of the game's central thesis — the people around you have already been one of these three states the whole time, and the dialogue you choose with them in the first 30 seconds determines which one they become for you. Replayability hook. Cultural-conversation hook ("which Dave did you get?"). Streamer-clip hook.

**Key moments:**

- First voluntary dialogue at Greystone (Beat 8) — the locked Schrödinger's choice
- All subsequent workplace interactions (state-dependent dialogue and sub-beats)
- "Goodbye, Dave" at job-quit (Beat 13 force-trigger if Beat 8 unfired)
- **Sleep-Path beat S3** — "Dave Stays a Friend" — full payoff of the Default-Gnoy branch
- Endgame epilogue — Dave's fate appears in the credits sequence of multiple endings (different fates per ending × per Schrödinger's state)

#### The Specialist Recruits (7 archetype roles)

> Recruits are individually-named characters generated from the recruit pool. The 7 *roles* are locked; the specific characters filling them vary per playthrough. Each role has a typical personality archetype but the actual character can be any Gnoym pulled into the network.

| Role | Typical Background | Function |
|---|---|---|
| **Researcher** | Former academic, journalist, or engineer who lost their job for asking questions. Default if Dave is recruited. | Dossier-builder. Cross-references evidence. |
| **Broadcaster** | Former GnoyNews intern, Trough food-critic, or amateur podcaster. Has charisma and a working microphone setup. | Runs the pirate signal. |
| **Crafter** | Former Vault tech-worker or Cage-fired contractor with grudges and skills. | Makes signature weapons (Evidence Brick, Slop Bag, Megaphone, Signal Jammer, Camera Flash, Fake ID Packet). |
| **Medic** | Former medical-system worker who saw too much. | Treats Slop Damage, Cope drops, Fatigue. Carries the moral weight of who the network can and cannot save. |
| **Quartermaster** | Former Trough warehouse worker, Vault accountant, or Cage gear-handler turned over. | Logistics, equipment storage, set-bonus management. |
| **Analyst** | Former Cage analyst who quit, defected, or was burned. | War Room operator (HQ Stage 3+). Reads dossier graph. Surfaces Inner Ring inferences. **Highest-narrative-importance specialist — primary interlocutor for Politburo Simulation and Inner Ring inference beats.** |
| **Handler** | Experienced former operator from any faction. | Manages cross-cell communication, dead-drop networks, recruit security. |

**Recruit Loyalty (across all roles):** Ongoing resource. Degrades from neglect, broken promises, Credibility collapse, competing faction offers. Recruits can defect, be broken into Glowies, or voluntarily walk away. The character arc of every recruit is *a love story with a sustainability question.*

#### The Inner Voices (Ensemble — Internal Cast)

> Disco Elysium-style internal monologue chorus. Each of the 24 skills speaks as a voice in dialogue and key moments. Treated here as supporting cast because they function as relationships, not just stat checks.
>
> **Production confirm needed (party-mode flag from Indie):** Are the 24 Inner Voices text-only, or voice-acted? VO budget for 24 distinct voices is multi-actor scope and would significantly impact audio budget. **Recommendation: text-only for the Inner Voices, VO reserved for boss dialogue and key NPCs.** Confirm at Production Plan (Step 10).

The Inner Voices scale with **Awakening + Fatigue**. Low Awakening / Low Fatigue = quiet, infrequent, deferential to the player's surface-level reading. High Awakening / High Fatigue = overwhelming, contradictory, sometimes hostile chorus. **Cope governs the player's ability to silence them when needed.**

Selected voice personalities (full roster of 24 in the Dialogue Framework, Step 6):

- **Rabbit Hole (MIND):** The compulsive forum-poster. Always wants to follow another lead. Tireless and dangerous.
- **Glowie Sense (SOUL):** The paranoid friend at the back of every conversation. Sometimes wrong. Sometimes the only one right.
- **Rizz (MOUTH):** The charm. Loves the sound of its own voice. Will get the player into trouble it can't get out of.
- **Ghost Mode (GHOST):** The voice of caution. Wants the player to leave the room.
- **Gymmaxx (BODY):** Confident, simple, dependable. The voice that just wants to *do something physical.*
- **[X] Fatigue (MIND):** The pattern-recognition demon. Speaks more loudly the more tired you are. Will not let things go.
- **Lore Depth (SOUL):** The historian. Always has context the player didn't ask for.
- **Cope (Derived):** The voice of "don't think about it." The voice the player is trying to silence by playing the game.

The Inner Voices' **collective arc** through the campaign: from a polite quiet chorus (Awakening 1) to a deafening, contradictory committee (Awakening 7+) to whatever final state the player has trained them into (Awakening 10 — they speak with authority gained from years of being ignored or trusted).

---

## Character Arcs

### The Player Character — Arc (build- and ending-conditional)

**Starting State:** Full Gnoy Wageworker. Compliant, subscribed, pattern-blind. Has the underground forum bookmarked without remembering why.

**Transformation Moments:**

- **The Doctored Feed Segment (Beat 2)** — first crack
- **First Subscription Cancellation (Beat 9)** — first material refusal
- **The Schrödinger's NPC Choice (Beat 8)** — first irreversible relational consequence
- **First Boss Investigation Closed (Beat 12)** — first encounter with the Truth Paradox at the publication interface
- **Quitting the Greystone Job (Beat 13)** — first life-economic threshold crossed
- **First Recruit Lost (Beat 16)** — first irreversible cost paid
- **The Inner Ring Betrayal Reveal (Beat 5)** — recontextualization of the entire arc
- **The Endgame Trigger (Beat 23)** — irreversible commitment

**Ending States** (one of 5):

| Ending | Arc Type | State |
|---|---|---|
| **The Public Reckoning** | Positive — costly | Burned out. Morally compromised. Truth told but the cost was everything. The character is exhausted and changed. |
| **The Shadow Replacement** | Negative — successful | The character has *become* the system. Ran the table on faction dominance. Inner Ring slot available — and accepted. |
| **The Burn** | Transformation — destructive | The character has dissolved their own life into the act of destruction. No reconstructive arc. The fire is the character. |
| **The Long Game** | Positive — patient | The character has gone permanently underground. Will live and work in the network for decades. Trades dramatic resolution for sustained resistance. |
| **The Sleep** | Flat / Refused arc | The character chose not to grow. Returns to compliance. The arc the character refused IS their arc. **Co-equal to the others.** |

**Lessons learned (per ending, but generalizable):**

- The Truth Paradox cannot be defeated, only navigated.
- Awakening is a cost the character chose to pay.
- The world does not reward correctness.
- Some forms of resistance are quiet. Some forms of compliance are tragic. The game judges nothing.

### Dave — Arc (state-conditional)

- **Default-Gnoy:** Flat arc. Dave's beliefs are tested over and over throughout the campaign and they hold. He stays Dave. He stays a friend. He stays asleep. **The most narratively heartbreaking flat arc of the game.**
- **Real-answer (Recruit):** Positive arc. Dave goes from cubicle-mate to first network specialist to potential lieutenant. May be lost (Beat 16) or survive to credits — fate appears in the epilogue.
- **Too-awakened (Glowie):** Negative arc — but the negative arc was *triggered by the player.* Dave was reportable from the start; the player exposed themselves to him. He becomes a permanent recurring antagonist or is captured/turned/defeated mid-campaign.

### Specialist Recruits — Arcs (general structure)

All specialist recruits share an arc structure: **commitment → erosion → resolution.**

- **Commitment phase:** Recruitment, personal quest, integration into homebase. Recruit Loyalty high.
- **Erosion phase:** Loyalty degrades from accumulated cost. Broken promises. Faction counter-offers. Cage pressure. Competing demands on the player's time.
- **Resolution phase:** Stays loyal, defects, is captured, is broken into a Glowie, or voluntarily walks away. **No recruit's arc is guaranteed to complete in the player's favor.**

The aggregate of recruit arcs across a playthrough is one of the game's primary emotional engines. *The character does not lose the war; the character loses people one by one.*

### The Trusted Anchor and The Debt Dealer — Boss Arcs (illustrative — full per-boss arcs are production-time artifacts)

- **The Trusted Anchor — Negative arc with sympathetic flavor:** Begins as a polished face on the GnoyNews evening segment. Through the dialogue boss confrontation, the player reveals he knows what he is doing and cannot stop. Is exposed, defeated, replaced — but the replacement is identical in function. **The role is the antagonist. The man is the casualty.**
- **The Debt Dealer — Negative arc with strategic flavor:** Begins as the polite face of consumer debt. Through the dialogue boss confrontation, the player exposes the algorithmic precision of his harm. Tries to bargain, then to threaten, then to retreat. May convert to an unlikely informant if the player breaks them by revealing the Vault's exposure of *him*. **The most volatile boss arc — multiple resolution states.**

> Full arcs for the remaining 11 bosses are production-time artifacts. Each archetype has been listed with narrative function and tonal register above; full character writing (backstory, dialogue tree, defeat states) belongs to per-boss sub-docs.

---

## World Building

### World Overview

**Setting:** Alt-Earth, present-day. Recognizable but slightly wrong. The names are changed — McXyon's instead of McDonald's, GnoyNews instead of any specific real network, Greystone Data Solutions instead of any specific consulting firm. The geography is *implied* rather than mapped to real places — think "American-coded mid-sized city" without specifying which city. The technology level is current. The cultural reference points are familiar (subscriptions, gig work, social feeds, content algorithms, doom-scrolling, megachurches, cable news). **The world is intentionally close enough to bite, far enough to deny it bites anyone real.**

**World Type:** Modern alt-Earth dystopia with satirical hyper-realism. Not science fiction. Not fantasy. Not post-apocalyptic. Not historical. The world is the world the player lives in, with the satire dialed up and the conspiracy real.

**World Rules:**

- **No supernatural elements.** No magic, no superpowers, no actual psychic abilities. The Inner Voices are interpreted as the player character's internal monologue, never literal supernatural entities.
- **The conspiracy is real.** This is the only "rule break" from baseline reality. The Xyoners exist. The Inner Ring is real. The staged news events are staged. The player who catches the patterns is correct.
- **Truth has consequences.** Publishing real evidence costs Heat. Suppression is mechanical, not paranoid. The Truth Paradox is a *world rule*, not a metaphor.
- **The world doesn't pause for the player.** The Politburo Simulation runs whether the player acts or not. NPCs have routines. Press cycles play whether the player tunes in or not. Cold cases exist. **Missing things is possible.**
- **Death is real.** Hotline Miami lethality is canonical. Recruits who die stay dead. Captured recruits can be broken into Glowies. The player can die to a single bad encounter. **Permanence is the contract.**
- **Currency is real.** Rent is due. Subscriptions auto-deduct. Quitting the job spikes pressure. Money is a lever the world pulls on the player constantly.

**Atmosphere:** Two opposed registers, both unsettling, signaling Xyoner influence by palette before by text:

- **Xyoner / corporate spaces** — oversaturated, too vibrant, too clean, too cheerful. The artificial cheer IS the satire. Gradually corrupts visually and audibly as the player's Awakening rises. By Awakening 7, the McXyon's brand jingle plays as a damaged file.
- **Slopside / The Hollow** — desaturated, grey-yellow, authentically grimy. Lo-fi melancholic ambient. Real color, real life. *The grimy places are the honest places.*

**Unique Elements:**

- **Mechanical satire.** The world expresses its critique through *systems*, not lectures. Cancelling a subscription is a mechanical Awakening tick. Eating slop heals immediately and damages slowly. The Feed dossiers your conversations. *The mechanics ARE the world's argument.*
- **Build-gated geography.** Sneak routes only become visible at Ghost Mode threshold. Internal Voices only audible at sufficient Awakening. Xyoner symbols only legible at sufficient Awareness. **Two players walking the same street are literally seeing different worlds.**
- **The Music Deterioration Mechanic** as world-state expression — corporate music in Xyoner spaces audibly corrupts as Awakening rises.
- **No supernatural escape.** The world offers no magic, no chosen-one bloodline, no cosmic justice. Whatever the player does, they do as a normal person with normal limits in a normal world that happens to be ruled by people doing the things the player has discovered.

---

### History and Backstory

**Timeline Overview:** Intentionally vague. The game does not commit to a founding date for the Xyoner Arrangement, a specific year for "current events," or a precise relationship between the alt-Earth's history and our own. **The vagueness is the design.** The player is invited to project their own assumptions about how things got this way, and the game does not correct them.

**Major Events (referenced in-world without being narratively litigated):**

- **The Consolidation** — a vague historical period in which the five Faction operational arms achieved their current dominance. Some forum posts call it ancient, some call it post-WWII, some call it post-2008. The game presents all three claims as forum-poster speculation and does not adjudicate.
- **The Information Reform** — a more recent period (within living memory) when the Feed achieved algorithmic dominance over public attention. The Greystone-generation player character was a child during this period. The Inner Voices' "[X] Fatigue" voice was born here.
- **The Loyalty Audits** — a recurring cyclical event in which the Cage performs sweeps. The current cycle is implied to be active during the player's campaign.
- **The Pulpit Funding Reveal** — an in-world journalistic event from ~5 years before the game's start, in which a small awakening-adjacent forum first documented the Vault's cross-funding of all four Pulpit ideological lineages. **The player's character has the bookmark to the original post.** The post itself was scrubbed; the bookmark resolves to a 404. The forum lives on but no one talks about that post anymore.

**Legends and Myths (in-world):**

- **The Awakened Ones** — a forum mythology that an underground network of fully-Awakened operators exists. It does. The player will eventually meet some of them. The legend is true, but the legend is also smaller and more compromised than the legend says.
- **The Inner Ring as Bloodline** — a popular forum theory. Treated by the game as one possibility among many. Never confirmed or denied.
- **The Compound** — the walled Inner Ring enclave. Most Gnoym don't believe it exists. Most awakened forum posters know it does but disagree on where. The player will eventually find it.
- **The Glowie Test** — the forum-mythical method of detecting Glowies in your own awakening community. Sometimes works. Sometimes is itself a Glowie psyop.

**Hidden Secrets (the game's actual lore that the player can uncover):**

- **The Inner Ring exists.** Its size is unknown to almost everyone, including most Faction bosses.
  - *Discovery path:* Universal forum-bookmark reference + faction-build boss confessions at COMPROMISED+ + solo-build Thought Cabinet thread. Three independent paths; at least one accessible per build archetype.

- **The Vault funds all four Pulpit ideological lineages** as a controlled-opposition strategy (the Pulpit Funding Reveal documented this; the Cage suppressed it).
  - *Discovery path:* No exposition required. Vault-branded signage is universally visible on Pulpit Quarter shared infrastructure (security, building maintenance, parking permits, contractor trucks) from first visit, regardless of player Awareness. The eventual reveal is *recognition* of what the player has been seeing for hours, not information delivery. **First-encounter sequencing in the Pulpit Quarter must include a Vault-branded establishing shot before any Pulpit boss dialogue begins.**

- **The Cage and the Feed are in active rivalry over surveillance jurisdiction** (exploitable by the player at high MIND/SOUL).
  - *Discovery path:* Faction Standing UI surfaces an "exploit available" indicator when the player reaches FLAGGED+ with both factions simultaneously. Mechanical reveal, no narrator required. Analyst dialogue (HQ Stage 3+) is confirmation, not introduction.

- **The Politburo has not had a stable internal hierarchy in years** — succession battles are ongoing across all five Factions.
  - *Discovery path:* Environmental tells embedded in boss-replacement scenes (the new boss is visibly mid-power-struggle on first appearance) + low-priority Politburo Simulation news segments in the Feed + forum thread analysis. No announcer. The pattern is available to anyone who reads, invisible to anyone who doesn't.

- **One Inner Ring member is feeding the player information all along** to eliminate rivals (the locked Betrayal Reveal — Mole identity TBD per Step 4).
  - *Discovery path:* Dossier UI tags evidence sources from hour 1; "anonymous tip" tag is rare and distinctive; player retrospectively reconstructs the Mole's signature pattern from their own evidence trail at the Reveal moment. **Production-correctness constraint:** anonymous-tip evidence must have unlocked at least 3-4 specific outcomes the player would not have reached through pure organic investigation. Mole archetype choice (Step 4 open question) determines how many load-bearing anonymous tips must be authored — this is the production-cost differential between Cynic Mole (few) and True Believer Mole (many).

- **The deepest secret the game refuses to commit to:** whether the Xyoners *invented* the conditions of modern Gnoy life, or merely *exploit* conditions that arose without them.
  - *Refusal path (not discovery — the refusal is the design):* The unanswerability is dramatized in-character — at Awakening 9+, a defected Inner Ring member, when pressed, says: *"I genuinely don't know. Some of us thought we made it. Some of us thought we found it. We argue about it. It doesn't matter. We do what we do either way."* The forum has multiple ongoing threads arguing both readings; none ever wins. The five endings each implicitly take a position without naming it (Public Reckoning suggests "exploit"; The Burn suggests "invented"; The Sleep treats the question as irrelevant). **The unresolvability is structurally encoded; the refusal is in-character, never authorial silence.**

---

### Factions and Organizations

> Full faction roster, boss archetypes, and tonal registers documented in Step 4 (Characters). This section captures the world-level relationships and inter-faction politics that shape narrative possibility space.

| Faction | Operational Domain | Public Face | Strategic Posture |
|---|---|---|---|
| **The Trough** | Food, agribusiness, processed consumption, land | Slop is convenience. Land consolidation is "modernization." | Slow erosion. Most patient of the five. |
| **The Feed** | Media, algorithms, narrative control | Trusted news. Engaging platforms. The Fact Checkers care about truth. | Reactive. Most exposed. Most paranoid. |
| **The Pulpit** | Religion, ideology, NGOs, wellness | Sells meaning across four ideological lineages, all secretly Vault-funded. | Distributed. Plausibly-deniable. |
| **The Cage** | Enforcement, surveillance, kompromat | The State. Public safety. Counterterrorism. | Aggressive. Most interventionist. |
| **The Vault** | Finance, debt, capital, philanthropy | The benevolent rich. The patient builders. | Keystone. Funds and constrains all other factions. |

**Cross-faction politics (player-exploitable):**

- **The Cage vs. The Feed** — pre-existing rivalry over surveillance jurisdiction. The Feed wants algorithmic-data monopoly; the Cage wants kompromat priority access. The player can play these against each other at high MIND. **Mechanically surfaced via Faction Standing UI's "exploit available" indicator at FLAGGED+ with both factions.**
- **The Vault is structurally neutral.** Never fully hostile. Always exposed-able. The Vault funds all four Pulpit ideological lineages — Vault internal exposure can collapse Pulpit faction standing across the board.
- **The Pulpit's four ideological lineages distrust each other.** Settlement Ideologue and Jihadist Franchise Operator have decades of operational hostility. Prosperity Prophet and Think Tank Sage compete for donor capture. **The Vault is the only thing keeping them aligned.**
- **The Trough is the slowest-moving and least retaliatory faction.** Investigations against the Trough generate the lowest Heat. Recommended starting boss-investigation faction for new players.

**Faction Standing ladder (per faction):** UNKNOWN → FLAGGED → OBSERVED → ASSET → COMPROMISED → OWNED. Double-cross tests fire at ASSET+. The Vault never fully hostile.

---

### Key Locations

#### The 12 Districts

##### Tier 1 — Major Districts (multi-sub-area, full content depth)

###### Slopside

- **Description:** The desaturated, grey-yellow residential periphery where the player's apartment is. Authentic urban grime. Lived-in. Melancholic. Home to the apartment homebase (Stage 1) and the underground forum's local node.
- **Narrative Significance:** *The honest district.* The first place where the player's awakening is reflected back by the environment. The forum bookmark resolves here. The Sleep ending takes place here.
- **Atmosphere:** Lo-fi ambient. Real color. The texture of compliant survival.
- **Key Events:** Apartment homebase events (Stage 1), forum interactions, first underground network contact, Sleep-path beats.
- **Inhabitants:** Gnoym — mostly compliant, some flagged, some quietly awakening.

###### The Cubicle Belt

- **Description:** The mid-saturation corporate-residential strip where Greystone Data Solutions sits. 340-employee buildings staffed with people processing nothing. Beige hallways. Vending machines. Group-chat dependencies. Mass-transit commute corridor.
- **Narrative Significance:** *The compliance demonstration.* Where the protagonist works at the start. Where Dave is. Where the player learns the texture of meaningless wage labor as systemic compliance.
- **Atmosphere:** Cheerful corporate-app aesthetic blending with fluorescent fatigue. The visual mid-point between Slopside (honest) and the Plaza (artificial).
- **Key Events:** "A Perfectly Normal Morning" tutorial (Beat 1), Dave Schrödinger's choice (Beat 8), Quitting the Greystone Job (Beat 13), Dave's resolution (state-conditional).
- **Inhabitants:** Greystone employees, other cubicle-strip workers, occasional Cage informants on lunch breaks.

###### The Plaza

- **Description:** The oversaturated central commercial-civic district. Brand cathedrals, billboards, the new Wellness Center, McXyon's flagship. Where the staged "spontaneous community celebration" from the opening sequence happens.
- **Narrative Significance:** *The Xyoner showroom.* The most aggressive corporate-music-deterioration district as Awakening rises. The first place the player can witness staged events in real time at sufficient Awareness.
- **Atmosphere:** Too-vibrant Xyoner-corporate. Cheerful soundtrack that audibly corrupts at Awakening 5+.
- **Key Events:** The Doctored Feed Segment (Beat 2 — the inciting event is staged here), GnoyNews Plaza-cam interactions, multiple Pulpit/Trough boss encounters.
- **Inhabitants:** Shoppers, tourists, performance-attendees, Glowies in casual cosplay, Pulpit-operative recruiters working booths.

###### The Vault District

- **Description:** Glass towers, marble lobbies, art collections nobody looks at. Headquarters of all major Vault operations. Adjacent to the Civic Center.
- **Narrative Significance:** *The keystone district.* Investigating the Vault here exposes cross-faction funding (especially Vault → Pulpit). Hardest district to operate in without Heat — Cage presence is constant.
- **Atmosphere:** Slick corporate ambient — expensive and empty. Echoing.
- **Key Events:** Benevolent Billionaire encounters, Debt Dealer dialogue boss confrontation, Vault-funding-of-Pulpit cross-reveal.
- **Inhabitants:** Vault operatives, executive-class Gnoym, security details, lawyers.

###### The Garden

- **Description:** Carefully manicured upper-class residential and recreation district. Estates. Country clubs. Private schools. Gates within gates.
- **Narrative Significance:** Where Inner Ring members live in plausible deniability. Where boss recreation happens. Where children of compromised Gnoym are sent to school, becoming next-generation Xyoner-aligned.
- **Atmosphere:** Quiet. Manicured. Eerily perfect. The most artificial district in the game.
- **Key Events:** Inner Ring inference investigations, late-game Boss-private-life surveillance, Soil Baron encounters.
- **Inhabitants:** Inner-Ring-adjacent families, second-tier Faction leadership, their staff, their security.

##### Tier 2 — Specialty Districts

###### The Pulpit Quarter

- **Description:** The religious-ideological district. Megachurch campuses, NGO headquarters, think tank offices, wellness retreats. Four sub-areas, one per Pulpit ideological lineage, all connected by Vault-funded shared infrastructure.
- **Narrative Significance:** *The equal-opportunity satire's ground.* The four Pulpit boss investigations all originate here. **Front-loading the Vault-funding reveal happens in this district** (per Step 4 production note).
- **Atmosphere:** Variable per sub-area — each ideological lineage has its own visual register, but **the Vault-funded shared infrastructure is identical and visible to attentive players from first visit (security signage, contractor trucks, parking permits, maintenance branding)**. The four ideologies argue; the Vault sweeps the parking lot.
- **Key Events:** Prosperity Prophet, Think Tank Sage, Settlement Ideologue, Jihadist Franchise Operator boss investigations.
- **Inhabitants:** Devotees of the four lineages, NGO staff, wellness-industrial workers, Pulpit operatives, the occasional Vault auditor.

###### University Row

- **Description:** Academic district. Research labs, lecture halls, graduate housing. Where Think Tank Sage holds appointments. Where defected Researchers come from.
- **Narrative Significance:** Recruit source — many Researcher-specialist recruits originate here. Investigation evidence research. Library access.
- **Atmosphere:** Slow. Quiet. Bookish. Tenured-class affluence layered over adjunct/grad-student precarity.
- **Key Events:** Think Tank Sage encounters, Researcher recruit personal quests, Lore Depth voice training opportunities.
- **Inhabitants:** Faculty (variable Awakening), graduate students (often-radicalized), administrative staff, Cage academic-monitoring assets.

###### The Slop Belt

- **Description:** The fast-food and processed-food retail strip. McXyon's outlets, Trough supply chains, food courts. Where Slop Damage accumulates fastest if the player isn't careful.
- **Narrative Significance:** Trough faction operations origin. Innovation Czar's R&D facilities. The most Slop-Damage-dense district.
- **Atmosphere:** Bright. Loud. Always serving. The most aggressively cheerful music in the game (and the most satisfying when it deteriorates).
- **Key Events:** Innovation Czar boss investigation, Trough operational surveillance, Slop-Damage-related Medic recruit personal quests.
- **Inhabitants:** Trough corporate staff, slop-shift workers, eaters, Cage delivery-tracker operatives.

###### The Civic Center

- **Description:** Government buildings, courts, the central police HQ, the Mayor's office, the public records archive. Cage operational center.
- **Narrative Significance:** Cage faction stronghold. Where official records can be accessed (legitimately or otherwise). Where the Loyalty Audits are coordinated. Where Intelligence Artisan works.
- **Atmosphere:** Bureaucratic. Quiet. Surveilled. The Heat baseline here is permanently elevated.
- **Key Events:** Intelligence Artisan boss investigation, Glowie infiltration attempts on the player, official-records investigation paths, Cage raid coordination origin.
- **Inhabitants:** Civil servants, Cage operatives, lawyers, journalists trying to file FOIA requests that go nowhere.

###### The Hollow

- **Description:** Abandoned industrial district at the city's geographic edge. Disused warehouses, train yards, water-treatment infrastructure no one updates. Authentically grimy in a different register from Slopside — *post-industrial decay rather than residential melancholy.*
- **Narrative Significance:** Stage 3 Underground HQ location. Distributed Cell Network nodes. Where the resistance sets up because no one comes here. Where the Cage will eventually come looking once the player gets serious.
- **Atmosphere:** Quiet. Echoing. Wind through empty buildings. Lo-fi ambient with industrial undertones. Real color, no Xyoner saturation.
- **Key Events:** Underground HQ + War Room online (Beat 17), First Cage Raid Survived (Beat 20), distributed cell-network setup (Beat 22), key Resistance-side homebase events.
- **Inhabitants:** Underground Resistance, recruits, occasional unhoused Gnoym (some of whom are awake, some of whom are Cage-planted to surveil the resistance).

###### The Outskirts

- **Description:** The transition zone between city and rural — strip malls, gas stations, motels, edge-of-jurisdiction Cage gray zones. Where the player goes when they need to disappear briefly.
- **Narrative Significance:** Cooldown district. Heat reduction zone. Recruit safe-house network. Where dialogue bosses sometimes get cornered out of their natural habitat.
- **Atmosphere:** Liminal. Quiet. Highway-noise ambient. The most "neither here nor there" district.
- **Key Events:** Heat cooldown, recruit personal quests requiring travel, off-grid meet-ups with Forum contacts.
- **Inhabitants:** Travelers, motel staff, gas-station Gnoym, occasional Resistance handlers using the Outskirts as a meet-point.

##### Tier 3 — Endgame District

###### The Compound

- **Description:** The walled Inner Ring enclave. Private estates within the estate. Helicopter pads. Vault-private infrastructure. The geographic resolution of "the Inner Ring exists."
- **Narrative Significance:** *Endgame district.* Approach is Awakening 9+ gated. The Inner Ring Betrayal Reveal (Beat 5) takes place here. Multiple ending sequences originate here. **Site of the in-character "we don't know if we made it or found it" refusal scene** (per Hidden Secrets section).
- **Atmosphere:** Quiet. Wealthy. Wrong in a register the player hasn't seen before — *the artificial cheer is gone. There's no music. The Compound is the one Xyoner space that doesn't bother to perform for anyone.*
- **Key Events:** Inner Ring Betrayal Reveal (Beat 5), Awakening Level 10 cinematic (Beat 6), Endgame Trigger (Beat 23), four of the five ending sequences.
- **Inhabitants:** Inner Ring members (number TBD per open question), their personal staff, Compound-internal Cage detail.

#### Hidden / Endgame Locations (sub-Compound + auxiliary)

- **Cage Black Sites** — distributed across multiple districts, hidden behind Cage-operations infrastructure. Captured recruits go here. Player infiltration possible at high GHOST + Hands.
- **Inner Ring Private Locations** — yachts, retreats, vacation compounds. Endgame-only. Surveillance investigation paths to identify them are part of the late-game inference work.
- **The Forum Servers** — physical location of the underground forum's hosting infrastructure. Late-game discoverable, late-game vulnerable. Defending the Forum becomes a viable late-game beat.

#### Homebase Locations (player-controlled, scaling)

| Stage | Location | Awakening Gate | Vulnerability |
|---|---|---|---|
| **1. The Apartment** | Slopside | Default start (Awake 1-2) | Vulnerable landlord. Direct Cage approach possible. |
| **2. The Office** | Cubicle Belt or Outskirts | Awake 3-4 | Cover-business lease creates paper trail. Moderate Cage exposure. |
| **3. The Underground HQ** | The Hollow | Awake 5-7 | Single-location vulnerability. Catastrophic loss possible if Cage finds it. |
| **4. The Network** | Distributed across multiple districts | Awake 8+ | No single point of failure. Coordination complexity becomes the new vulnerability. |

---

## Dialogue Framework

### Dialogue Style

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

### The Inner Voices (24-Voice Internal Cast)

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

### Branching Dialogue System

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

### Key Conversations

> Listed by narrative weight, not chronology. Full dialogue tree authoring belongs to per-conversation production sub-docs at writing time.

#### Tier S — Structurally Load-Bearing

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **The Schrödinger's Dialogue with Dave (Beat 8)** | Player + Dave | First voluntary dialogue at Greystone | Permanently locks Dave's three-state arc. *The single most important dialogue in the game.* High unique-content density across the three branches. |
| **"Goodbye, Dave" (Beat 13 force-trigger)** | Player + Dave | Quitting the Greystone job, if Beat 8 unfired | Force-resolution of Dave's arc based on accumulated state. State-conditional dialogue tree. |
| **The Trusted Anchor Confrontation** | Player + Trusted Anchor | Boss investigation completion | **Dialogue boss with multi-stage composure HP.** Anchor begins polished, cracks into raw exhaustion under skill-check pressure. Sympathetic resolution available. |
| **The Debt Dealer Confrontation** | Player + Debt Dealer | Boss investigation completion | **Dialogue boss with multi-stage composure HP.** Dealer knows player's file before sitting down. Multiple resolution states including potential informant conversion. |
| **The Inner Ring Betrayal Reveal (Beat 5)** | Player + The Mole | Endgame approach | The Kishōtenketsu twist. Mole identity TBD per Step 4. Recontextualizes entire campaign. **Production-correctness constraint:** dialogue must pull from the Dossier UI's anonymous-tip log. |
| **The "We Don't Know" Refusal (per Step 5)** | Player + a defected Inner Ring member | Awakening 9+, Compound approach | The in-character refusal of the deepest world question. Single-scene, high-impact. |
| **The Endgame Trigger Commitment** | Player + Inner Voice chorus | Player-decided endgame entry | The protagonist's irreversible commitment. Inner Voices form full chorus. State-conditional dialogue branches into one of 5 endings. |

#### Tier A — Major Dramatic Moments

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **First Underground Forum Post Reply (Beat 10)** | Player + anonymous forum contact | First voluntary forum post | Player's first network contact. Forum chat dialogue tree. Establishes the Forum as a relationship, not a UI. |
| **First Boss Investigation Publication Decision (Beat 12)** | Player + Inner Voices | Dossier Interface publication moment | The first concrete encounter with the Truth Paradox. The voices argue. The player commits. |
| **Each Recruit's Initial Recruitment Dialogue** | Player + prospective recruit | Recruit personal quest completion | High-stakes branching dialogue. Wrong tone permanently loses the recruit. |
| **Each Recruit's Erosion Dialogues** | Player + named recruit | Loyalty-degradation moments | The relationship is in the conversation. Loyalty resolution paths gate here. |
| **Cage Interrogation (if captured)** | Player + Cage interrogator | YIELD outcome from combat | GUT check limits dossier damage. Branching tree of admissions vs. silences. |
| **Each Faction's COMPROMISED→OWNED Confessional** | Player + faction-internal contact | Faction Standing maxed | Sympathetic late-faction-life dialogue. Source of Inner Ring inference dialogue (Beat 21 trigger). |

#### Tier B — Recurring System Dialogues

| Conversation | Participants | Anchor | Purpose |
|---|---|---|---|
| **Glowie Honeypot Dialogues** | Player + Glowie-archetype NPC | Recurring, multiple instances | Replayable detection-or-fail-detection scenarios. Glowie Sense voice gets first read. |
| **Forum Chat Threads** | Player + named forum contacts | Apartment laptop interactions | Background lore + side quest hooks + Hidden Secret discovery paths. |
| **GnoyNews Encounter Reactions** | Player + Inner Voices | Watching daily news segment | Internal monologue reaction to Feed content. Awakening + Fatigue scaling. |
| **Routine NPC Interactions** | Player + Gnoym Reputation Web NPCs | District-based, recurring | Reputation Web maintenance. Most convergent dialogue tier. NPC Mode voice can suppress for full pass. |

---

### Production Notes (carried forward to Step 10)

- **Dialogue volume estimate:** Disco-Elysium-tier (~300k+ words) — confirmed from Brief. Largest single content cost line item.
- **VO scope:** **Text-only for Inner Voices (confirmed).** Voice acting recommended only for boss dialogue (13 bosses, weighted heavily toward dialogue bosses Trusted Anchor and Debt Dealer) and key NPCs (Dave, named recruits, defected Inner Ring member). All other dialogue text-only.
- **Tooling requirements:** Dialogue authoring tool must support visible-DC tagging, hidden-consequence linking, item-drop conditionals, conversation-log weaponization (each line tagged for later quote-back retrieval), Reputation Web ripple triggers, and Inner Voice scaling rules. **This is significant tooling investment — must be locked before scaling content.**
- **Writing pipeline:** Tier-S dialogues authored in vertical slice. Tier-A dialogues authored at EA launch. Tier-B dialogues populated at full launch with template-and-fill workflow.
- **Localization scope:** 300k+ words drives translation cost decisively. Decision deferred to Step 10. **English-only at launch is the realistic bias.**

---

## Environmental Storytelling

> **Foundational design rule (from Brief Pillars + Step 5 Hidden Secrets):** *"No exposition dumps — the world is the information."* Environmental storytelling is the primary lore-delivery vehicle. If a fact about the Xyoner system can be conveyed through a billboard, a sound cue, a parking-lot sign, or a 404 page, **it must be conveyed that way**, not via dialogue.

---

### Visual Storytelling

#### Set Dressing

**Set dressing IS the satire.** Every Xyoner-controlled space is dressed to over-perform the cheerful corporate aesthetic; every honest space is dressed to under-perform. The contrast does the political work the dialogue refuses to do.

- **McXyon's outlets** — too-bright menu boards, perpetually clean floors, an army of cheerful uniforms. The slop is photographed beautifully on every wall. The trash bins are emptied every 90 seconds.
- **Greystone Data Solutions** — beige hallways, motivational posters of mountains and eagles, a foosball table no one uses, a wellness room with a CPR dummy and one yoga mat. The water cooler is the only honest object in the building.
- **The Plaza** — billboards for things no one needed before they saw the billboard. The new Wellness Center has a fountain. The fountain has algae the maintenance crew never quite gets ahead of.
- **Slopside apartments** — mismatched furniture, peeling paint, food delivery containers, a laptop on a coffee table with the underground forum bookmarked. The light through the window is the warmest light in the game.
- **The Hollow** — collapsed signage from businesses that closed during the Information Reform. Train cars repurposed as shelter. Graffiti that's been painted over and re-applied so many times it's a palimpsest of resistance slogans.
- **The Compound** — almost no set dressing at all. The Inner Ring lives in spaces that don't have to perform for anyone.

#### Environmental Storytelling Examples (per district, illustrative)

| Location | Visual Detail | Story It Tells |
|---|---|---|
| **Slopside apartment kitchen** | Three takeout containers from three different brands; same delivery-app sticker on all. | The competition is fake. The brands are owned by the same Trough subsidiary. |
| **Greystone parking lot** | A Cage-issued vehicle parked in the visitor lot every Tuesday morning. | The compliance audit is routine. No one notices because no one has the Awareness threshold to read the license plate yet. |
| **The Plaza Wellness Center** | A doorway in the back-of-house area that staff use; the door has a Vault-branded keycard reader. | The Wellness Center is Vault-funded. Player walks past this 50 times before reading it. |
| **Pulpit Quarter shared infrastructure** | Vault-logo signage on contractor trucks, parking permits, security badges, building maintenance branding. | **The four ideologies argue; the Vault sweeps the parking lot.** Per Step 5 — universal-Awareness readable from first visit. |
| **The Hollow underground HQ** | A handwritten chore wheel on the wall. Names rotate. Names get crossed off (recruits lost). | The recruits become a list of crossed-off names. The chore wheel IS the loss tally. |
| **Cage Civic Center lobby** | A dedication plaque listing the Center's founders. One name is the Engagement Architect's grandfather. | The Cage and the Feed have shared roots. Player reads this if they look. |
| **The Compound interior** | No music. No corporate signage. No staged cheer. The walls have actual art that was bought for itself. | The Inner Ring isn't performing. They don't have to. |

#### Visual Symbolism

- **The cheerful palette is the warning.** As the Awakening Track rises, the player learns to read corporate-bright as the *most threatening* visual register. This inverts the typical horror-game grammar (which reads desaturation as menacing). **The mechanic of the Awakening filter encodes this inversion.**
- **The McXyon's "M" logo** becomes a recurring visual motif. At Awakening 1, it's just a logo. At Awakening 5, the player notices it has the same kerning and proportions as Cage badges. At Awakening 9, the player notices the Inner Ring's helicopter pad uses the same red.
- **Vault branding** appears as the keystone visual — discreet, expensive, on infrastructure no one looks at. The player learns to scan for it.
- **The 404 page** for the original Pulpit Funding Reveal post becomes a recurring visual — same template, same broken-link error message — reused for every scrubbed lore artifact across the game. The player learns to read 404s as evidence of what was suppressed.
- **The chore wheel motif** appears in every homebase stage as the network grows. By Stage 4, multiple chore wheels are pinned across distributed cell locations. **The aggregate is the resistance.**

#### Color and Lighting

> Locked from Brief — captured here for environmental-storytelling integration.

- **Corporate / Xyoner spaces:** Oversaturated, high-key lighting, no shadow ambiguity. Visually assertive.
- **Slopside / The Hollow:** Desaturated, mid-key lighting, real shadow, lived-in haze. Visually quiet.
- **Awakening Filter (progressive):** A subtle saturation pull and contrast adjustment that activates at Awakening 5+ and increases with each level. By Awakening 10, the player sees corporate spaces as *visibly distorted* in ways the Awakening-1 player did not.
- **Compound (endgame):** Daylight-realistic. Neither saturated nor desaturated. *The Inner Ring sees the world as it is.* This visual tonal shift is the player's confirmation that the Compound exists outside the satirical frame the rest of the world performs.

#### Character Design Details (cross-reference Step 4)

- **Faction-coded silhouette and clothing** — Cage operatives have a recognizable silhouette even out of uniform; Vault executives have a tell in their watches; Pulpit operatives across all four lineages have a shared posture (it's how they recognize each other across ideological lines).
- **Awakening-readable details** — at higher Awakening, the player sees additional character-design tells they didn't see before. Glowies have a subtle posture cue at Awakening 4+. Inner Ring members have an unmistakable carriage at Awakening 9+.
- **Player character visual changes** — as Awakening rises, the player's customizable avatar gradually shows wear — eyes get heavier, posture changes, slop gut tracks Slop Damage, gear becomes more tactical and less civilian. The player's body IS the playthrough's record.

---

### Audio Storytelling

> Locked audio direction from Brief preserved; environmental-storytelling integration added.

#### Ambient Design (per location register)

- **Gnoy daily life:** Corporate jingles overheard on shop radios, hold music in waiting rooms, upbeat pop slop on the metro PA system. Cheerful and oppressive in equal measure.
- **Slopside:** Lo-fi melancholic ambient — wind through the apartment block, distant traffic, occasional argument heard through a wall. Authentically inhabited.
- **The Hollow:** Industrial decay — wind through empty buildings, water dripping in disused pipes, the occasional train horn from outside the district. Echoey. The most spatially honest soundscape.
- **The Plaza:** Layered loud — billboard speakers, fountain noise, crowd chatter, looping promotional audio from multiple kiosks at once. **Audibly oppressive in a way the player doesn't consciously notice until it stops.**
- **Investigation moments:** Slow tension, late-night paranoia (Burial / Arca / Boards of Canada DNA). Quiet enough that the player hears their own footsteps.
- **Combat:** Aggressive electronic / synthwave (Perturbator / Carpenter Brut / Hotline Miami DNA). Drives the lethality.
- **Xyoner internal spaces:** Slick corporate ambient — expensive, empty, echoes-with-money. Designed to make the player feel *small* inside it.
- **Awakening moments:** Something cracks in the music production. Distortion, dropped beats, chord-resolution failures.
- **The Compound:** Near-silent. The most striking audio choice in the game. *The Inner Ring doesn't bother to perform.*
- **Endgame coda (per ending):** Orchestral-electronic hybrid, ending-specific. The Sleep ending ends with the McXyon's jingle restored to its undeteriorated form — *the player has trained themselves back into hearing it as music again.*

#### The Music Deterioration Mechanic (signature)

> **Production reminder:** Multi-version recordings of every Xyoner-space track. Budget item locked at Brief; reaffirmed in Step 4 production notes.

- **Awakening 1-2:** Music plays as composed. Player perceives it as background.
- **Awakening 3-4:** Subtle off-notes appear in corporate jingles. Most players don't consciously register; some flag it as a personal mood shift.
- **Awakening 5-6:** Skipping, audible cuts, chord-resolution failures. **Players notice.** They mention it. They search forums to ask if anyone else hears it.
- **Awakening 7-8:** The McXyon's jingle plays as a damaged file. Pulpit-shared-infrastructure audio (security door chimes, elevator music) shows visible (audible) corruption. **The signature moment for streamers.**
- **Awakening 9-10:** Most Xyoner-space music is unrecognizable as the original composition. The player walks through corporate spaces hearing *what the music actually sounds like to them now*. **Some players will reflexively turn the game's music down, then realize that doesn't help — what they're hearing is what's there.**

#### Voice Beyond Dialogue (cross-reference Step 6)

- **Inner Voices (24)** — text-only delivery, but each voice has a distinct text-rendering style (font weight, color tint, italic register) that the player learns to read as voice identity. *The voices have a written-voice even without audio voice.*
- **Crowd ambient murmur** — conversations heard in passing in the Plaza, the Slop Belt, the Cubicle Belt. Generic at low Awareness; surfaces meaningful snippets at high Awareness (the same crowd murmur changes content based on Reputation Web state and Politburo Simulation events).
- **Voice-acted boss dialogue + key NPCs** (per Step 6 production scope). Especially: Trusted Anchor's broadcast-voice cracks audibly during the dialogue boss fight — *the player hears the polish breaking down in real time.*
- **Pirate broadcast quality** — the player's own broadcasts (from the Broadcaster recruit / Stage 3 HQ) have audio fidelity that's mechanically tied to Signal Hijack skill. Low skill = staticky, low-credibility broadcasts; high skill = clear, professionally-mixed signal. **The audio fidelity IS the credibility.**

#### Sound Design as Gameplay (locked from Brief)

- **Footsteps audible before visible** — stealth is partly an audio-recognition game. Cage tactical units have a distinct boot-sound. Glowies in casual cosplay don't.
- **Pirate broadcast signal quality** — see above. Audio is the metric.
- **Homebase ambient sound growth** — Stage 1 Apartment is sparse single-occupant ambient (TV in next room, traffic outside). Stage 2 Office adds keyboards, low conversation, a coffee maker. Stage 3 Underground HQ adds the hum of broadcast equipment, the printer, intermittent radio chatter, a group debate audible from the next room. Stage 4 Distributed Network is heard via radio comms — the player's homebase ambient is now the *coordination chatter of a network they cannot all see.* **The growth IS the progression.**
- **The McXyon's jingle** — the central audio-storytelling artifact. The single most narratively-load-bearing sound asset in the game.

---

### Found Documents and Collected Evidence

> **The world's lore lives in documents the player finds, not exposition lectures the world delivers.** This is the operational interpretation of Pillar 1 ("the systems generate the story; nothing is mandatory"). Every Hidden Secret from Step 5 has a documentary discovery path.

#### Document Types

| Type | Source | Use |
|---|---|---|
| **Forum threads / posts** | Underground forum (apartment laptop, later distributed) | Background lore, side quest hooks, Hidden Secret discovery paths, Inner Ring inference fodder. |
| **Forum 404 pages** | Same forum — links to scrubbed posts | Evidence of what was suppressed. Recurring visual motif. |
| **News segments (GnoyNews)** | In-world TV/Feed | Politburo Simulation surface narrative. Doctored Feed Segment (Beat 2). Boss-replacement environmental tells. |
| **Faction documents** | Recovered from boss investigations, infiltration, interrogation | Direct factional evidence. Source of dossier entries. Some are planted by the Cage. |
| **Anonymous tip dossier entries** | Source: unknown (the Mole's signature — see Step 5) | The single most narratively-load-bearing document type in the game. Player retroactively reconstructs the Mole's pattern from these. |
| **Personal artifacts** | Found in NPC homes, abandoned spaces, Cage Black Sites | Humanizing detail. The Trusted Anchor's daughter's drawing in his desk drawer. The Settlement Ideologue's grandfather's letters. |
| **Corporate ephemera** | Plaza, McXyon's, Vault District | Brand-design evidence of cross-faction connections. Same agency designed multiple "competing" Trough brand identities. |
| **Government records** | Civic Center archives (legitimate or otherwise) | FOIA-exhausted documents that reveal patterns when cross-referenced. |
| **Recruit personal artifacts** | Recruit homebase quarters | The relationship is partially in the personal items the player cohabits with. Loss of a recruit means their items remain — until the player chooses to clear them. |
| **Pulpit materials** | Pulpit Quarter — pamphlets, sermons, fundraising literature | Each lineage's surface-level ideological output, with the Vault-funded production credits visible in the small print. |

#### Quantity (estimated)

- **Forum threads:** ~150-200 distinct threads at full launch, with multi-post depth. Tier-S threads are authored; Tier-B threads are template-and-fill.
- **News segments:** ~80-120 distinct segments, with Politburo Simulation generating recombinations.
- **Faction documents:** ~200-300 distinct documents across all 13 boss investigations and ambient infiltration.
- **Anonymous tip entries:** **Production-correctness gated by Mole archetype choice.** Cynic Mole (~6-10 entries); True Believer Mole (~25-40 entries with greater per-entry significance).
- **Personal artifacts:** ~50-100 distinct items with narrative meaning (this excludes purely-mechanical loot).
- **Corporate ephemera:** ~30-50 environmental items.
- **Government records:** ~40-60 documents.
- **Recruit personal artifacts:** ~5-10 per recruit × 7 specialist roles + named instances.
- **Pulpit materials:** ~30-50 across the four lineages.

**Total estimate:** 800-1200 distinct narrative documents at full launch. **Most are optional. None are required for any Awakened ending. The Sleep ending requires zero document reading.** This is consistent with Pillar 2 (every playthrough is unique; awakening is available, never mandatory).

#### Discovery Mechanics

- **Required vs. Optional:** Almost all documents are *optional*. The few "required" documents are anchored to specific authored beats (e.g., the Doctored Feed Segment, the original forum bookmark from Beat 1, the Mole's anonymous tips). **Required documents are surfaced unmissably; optional documents reward exploration.**
- **Reward for finding:** No achievement systems. No pop-up "Lore Unlocked!" affirmations. Discovery rewards are *narrative integration* — the document content surfaces in dialogue options later, modifies Reputation Web ripples, unlocks investigation paths. **The reward is what becomes possible.**
- **Cross-reference and synthesis:** Many documents are individually meaningless and meaningful only in combination. The Connection Mechanic (Investigation UI Layer 2 — Dossier Interface) is the primary synthesis tool. Solo builds use the Thought Cabinet for the same purpose.

#### Cross-Reference to Previous Steps

- **Step 5 Hidden Secrets** all have documentary discovery paths via this section.
- **Step 6 Conversation Log** is itself a document type — the player's own past words become the most weaponized document in the game.
- **Step 4 Mole identity** determines anonymous-tip document volume (production-correctness constraint).

---

### Production Notes (carried forward to Step 10)

- **Document authoring volume:** Significant — 800-1200 distinct documents at full launch is a writing investment second only to dialogue. **However, ~70% can be authored using template-and-fill approaches** (forum threads, ambient news, generic faction documents) once tier-S anchors are written.
- **Music deterioration pipeline:** Multi-version audio assets per Xyoner-space track. **Recommend 5 deterioration tiers, not 10** (per Step 4 Indie note re: scope-tied tiering). Tiers: Clean (Awake 1-2), Subtle Off-Notes (3-4), Skipping (5-6), Audible Corruption (7-8), Damaged-File (9-10).
- **Audio fidelity for pirate broadcasts:** Skill-tied audio modulation system — not just volume curves. Significant audio engineering work.
- **Visual asset pipeline:** Two-palette (saturated Xyoner / desaturated honest) is locked, but **the Awakening Filter** (progressive saturation pull at Awakening 5+) is a post-process effect. Engineering scope item.
- **The McXyon's jingle is the highest-priority single audio asset in the game.** Locking the composition (and its 5 deterioration tiers) early is recommended — it touches every district and every Awakening level.

---

## Narrative Delivery

> **Foundational design rule:** narrative delivery must respect Pillar 2 — *"every playthrough is unique. The awakening path is available, never mandatory."* This means delivery methods must support both 5-hour Sleep runs and 80-hour Public Reckoning runs without breaking the texture of either. Narrative is *available*, not *imposed*.

---

### Cutscenes

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

### In-Game Storytelling

> Comprehensive coverage in **Step 6 (Dialogue Framework)** and **Step 7 (Environmental Storytelling)**. This section captures the *delivery balance* and *interruption philosophy*, not the methods themselves.

#### Primary Methods (cross-reference)

- **Dialogue with NPCs** (Step 6) — branching, skill-gated, conversation-log weaponized.
- **Inner Voices** (Step 6) — internal monologue chorus, scaling with Awakening + Fatigue + Cope.
- **Environmental visual storytelling** (Step 7) — set dressing, props, color/lighting, character-design tells.
- **Audio storytelling** (Step 7) — ambient design, music deterioration, sound-as-gameplay.
- **Found documents** (Step 7) — forum posts, news segments, faction documents, anonymous tips, personal artifacts.
- **The Investigation UI** (Investigation Layers 1-3 from GDD) — Physical Board / Dossier Interface / Thought Cabinet. *The investigation interface IS storytelling.* Cross-referencing two pieces of evidence with a string is a narrative beat.
- **Politburo Simulation events** — surfaced via news segments, NPC dialogue, environmental tells. The world's narrative motion *is* gameplay.
- **Reputation Web ripples** — gossip propagation across NPCs is a slow narrative mechanic.

#### Show vs. Tell Balance

**~95% show, ~5% tell.** The 5% telling happens in:

- The 7 cutscenes above (locked authored beats).
- The Inner Voices (which are still "show" of the protagonist's inner state, but technically narration).
- The opening tutorial's contextual silent demonstrations ("A Perfectly Normal Morning," Beat 1) — show-by-doing, but with the lightest possible authorial framing.

**The remaining 95% is system-emergent**: dialogue the player initiates, environmental details the player notices, documents the player chooses to read, news segments the player chooses to watch, gossip the player chooses to listen to.

#### Interruption Approach

**Minimal forced interruption.** The game does not stop the player to deliver story unless the locked authored beat absolutely requires it. Three interruption tiers:

| Tier | Interruption Type | Frequency |
|---|---|---|
| **Hard interrupt** | The 7 cutscenes (mostly skippable). Cage-raid forced encounters. Endgame Trigger commitment. | ~10-15 hard interruptions across a full Awakened playthrough. |
| **Soft interrupt** | NPC initiates dialogue (player can decline most). Politburo Simulation event surfaces in the Feed. Recruit personal-quest invitation. | Variable per playthrough; many are missable. |
| **Pull-only** | Player initiates: dialogue, document reading, evidence cross-reference, news segment viewing. | Player-controlled entirely. The dominant mode. |

**Sleep-run players experience near-zero interruption tier above pull-only.**

#### Player Control

- **Skip:** Always available for cutscenes (with two first-play exceptions).
- **Speed:** Dialogue auto-advance toggleable. Reading speed configurable.
- **Markers Mode:** Optional accessibility setting that surfaces objective markers (off by default, per Brief).
- **Quest Journal:** Character's own notes, not auto-task list. Can be ignored entirely.

---

### Optional Content

> Per Brief: *"7 quest types running in parallel; no markers default."* Most narrative content in Gnoy Simulator is optional. The game's structural commitment is that *the awakening path is available, never mandatory*.

#### Optional Content Categories

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

#### Notable Absences

- **No achievements / collectibles UI.** The Brief is explicit: no markers, no auto-log. The player who reads documents and cross-references evidence is rewarded by the gameplay opening up, not by external pop-ups.
- **No "true ending" hidden behind 100% completion.** All 5 endings are co-equal. The Public Reckoning isn't more "true" than the Sleep ending.
- **No NG+ unlocked story content.** NG+ exists (skip-cutscenes enabled, build-knowledge carries over conceptually). No content gated behind multiple playthroughs.
- **No DLC hooks built into the base game.** The Brief identifies post-launch as "possible secondary"; the NDD makes no promises that would constrain DLC scope.

---

### Ending Structure

> The 5 endings are locked from the Brief and elaborated across Steps 2-3 (act structure, transformation arcs). This section captures the *delivery mechanics* of how endings fire, branch, and credit-roll.

#### Number of Endings

**5 distinct endings + 1 implicit "soft fail."**

| # | Ending | Trigger | Coda Style |
|---|---|---|---|
| 1 | **The Public Reckoning** | Endgame triggered with Awakening 8+, Multiple Factions COMPROMISED+, Credibility above-threshold despite high Heat | Bittersweet credits + epilogue: world acknowledges the truth at terrible personal cost. |
| 2 | **The Shadow Replacement** | Endgame triggered with Awakening 7+, Disposition skewed toward OPERATOR/REBEL, Inner Ring slot accepted | Morally compromised credits + epilogue: the player has *become* the system. |
| 3 | **The Burn** | Endgame triggered with Awakening 9+, Disposition heavily REBEL, Multiple recruits lost, low Cope | Destructive catharsis credits + epilogue: the player dissolves their own life into the act of destruction. |
| 4 | **The Long Game** | Endgame triggered with Awakening 8+, distributed cell network online, Heat managed, Cope sustained | Patient melancholy credits + epilogue: permanent underground network operation, decades-long resistance horizon. |
| 5 | **The Sleep** | Sustained low-Awakening, low-Heat, fully-subscribed lifestyle for an extended in-game duration (Beat S5) | Quiet defeat credits + epilogue: the world the player started in remains the world they end in. **Co-equal to the others.** |
| — | **Soft Fail (implicit)** | Player character dies permanently in Ironman mode, or accumulates max Slop Damage in any mode | Brief credits: "they ate the slop. they watched the feed. they did not survive long enough to do anything else." |

#### Ending Triggers

**Endgame Trigger (Beat 23) is player-decided, not auto-fired.** The player declares "I'm doing this now" via an interaction at the Compound (or the Apartment, for Sleep ending). The 5-ending branch resolves from the player's accumulated state at the moment of trigger:

- **Awakening Level** — gates which endings are available
- **Faction Standing** (per faction) — affects Public Reckoning vs. Shadow Replacement vs. Long Game weighting
- **Disposition Axes** (GNOY↔AWAKE, PASSIVE↔REBEL) — affects Burn vs. Long Game weighting
- **Recruit count + Loyalty** — affects which credits epilogue specifics fire
- **Cope state** — affects Burn vs. Long Game eligibility
- **Specific late-game choices** (Inner Ring slot offered/accepted, Compound approach style) — final disambiguation

#### Ending Variety

**Drastically different**, not minor variations. Each ending has:

- A unique credits sequence (~4-8 min)
- A unique epilogue structure showing the world post-trigger
- Per-character fate update (Dave, each named recruit, key bosses) — surfaces ending-conditional outcomes
- A unique audio register (per Step 7 audio direction — Sleep ending restores McXyon's jingle to undeteriorated form, etc.)

**The fate of every named NPC the player interacted with appears in their ending epilogue.** Dave's fate is shown. Each recruit's fate is shown. Each defeated boss's role-replacement is shown. The Sleep ending shows Dave growing older next to the player.

#### True Ending? (No)

**No "true," "golden," or "canonical" ending.** This is structurally enforced:

- The Brief's tonal commitment ("the game judges nothing") forecloses a canonical correct ending.
- The Truth Paradox theme requires that even The Public Reckoning is morally compromised.
- The Sleep ending's structural co-equality (Step 3) forecloses framing it as "the bad ending."
- **Reviewers should be briefed** (per Brief Risk Assessment): Sleep is a *feature* of the design, not an "early-out" or a "joke" ending.

#### Replayability

- **Schrödinger's NPC (Dave) alone gives 3 distinct first-encounter playthroughs.**
- **5 endings × build identity (~5 viable build archetypes) = ~25 meaningfully distinct runs.**
- **Playthrough length variance:** 5-10 hours (Sleep) to 100+ hours (completionist Awakened). The game supports both as primary play patterns, not "speedrun vs. main."
- **Mole identity choice (Step 4 open question) becomes most visible across multiple playthroughs.** A True Believer Mole player will see anonymous-tip evidence patterns differently on second playthrough; a Cynic Mole player will see the cold detachment land more sharply.
- **No content is locked behind multiple playthroughs.** Replayability is in the variation of identity, not in unlocking new content.

---

### Production Notes (carried forward to Step 10)

- **Cutscene budget:** ~25-40 authored minutes total, in-engine real-time-rendered. **No FMV / pre-rendered required.** This is a cost win versus typical AAA narrative-RPG cutscene scope.
- **Ending sequences:** 5 codas × ~4-8 min each = ~20-40 minutes of ending content. **The Sleep ending must receive the same compositional care as the others** — production scope must reflect this, not treat Sleep as a stub.
- **Per-ending epilogue authoring:** named-NPC fate updates require per-ending state-conditional writing. **This is the highest-density single-section writing in the game** outside boss dialogue. Estimate: 5-10k words per ending × 5 endings = 25-50k words just for endings.
- **Optional-content scope:** ~80% of total content volume is optional. **Vertical slice content priority should reflect this** — optional-content authoring patterns must be locked early, not treated as Phase 3 nice-to-haves.
- **No achievements UI / NG+ content scope:** **architecture/scope wins.** No achievement system to design, no NG+ content to author. Capture in scope estimates.

---

## Gameplay Integration

> **The thesis:** Gnoy Simulator does not have narrative *and* gameplay. It has narrative *as* gameplay. The Brief's first design pillar is *"the satire IS the design — every mechanic must reinforce the thematic point or be cut."* This document codifies what that means in practice.

---

### Narrative-Gameplay Connection

#### Integration Approach

**Mechanical satire.** Mechanics don't *illustrate* the theme — they *are* the theme. This is the structural innovation that distinguishes Gnoy Simulator from narrative-RPGs that bolt story on top of generic systems.

| Mechanic | What It Models | What It Is Saying |
|---|---|---|
| **Subscription cancellation = Awakening tick** | Material refusal of slop economy | Awakening isn't a feeling; it's a series of $9.99/month decisions. |
| **Slop healing (immediate) + Slop Damage (slow)** | Compliance is rewarded short-term, punished long-term | The system that hurts you is also the system that comforts you. The hurt arrives later. |
| **Truth Paradox at publication interface** | Credibility ↔ Heat trade-off per published evidence | The world does not reward correctness. Framing IS the moral skill. |
| **Conversation log weaponization** | NPCs quote you back; Cage dossiers your words; Feed edits soundbites | Your words are evidence used against you. There is no "off the record." |
| **NPC Mode (Mouth skill)** | Active suppression of pattern recognition to pass as Gnoy | Compliance is performable. Performing it costs Cope. |
| **Cope mental-resilience stat** | The stat the player spends to keep going at high Awakening | Clarity is exhausting. The price of seeing is the inability to look away. |
| **Build-gated world geography** | Sneak routes / readable symbols / audible voices unlock with build | The Full Gnoy and the Awakened are playing different games on the same map. The world EXPANDS as you wake up. |
| **Music Deterioration Mechanic** | Corporate music corrupts as Awakening rises | The texture of the manufactured world becomes audible. Manipulation made hearable. |
| **Faction Standing ladder** (UNKNOWN→...→OWNED) | Player can be *catalogued* by the system or *catalog* the system | You either pattern-match the system, or it pattern-matches you. There is no neutral position. |
| **Politburo Simulation independence** | World tics regardless of player action | The world does not revolve around you. Cold cases exist. Missing things is possible. |
| **Recruit Loyalty erosion + permanent loss** | Network sustainability has a cost | The character does not lose the war; the character loses people one by one. |
| **Hotline Miami lethality + capture mechanic** | The body is expendable; YIELD or ESCAPE | Permanence is the contract. Your dossier, not your respawn count, is the score. |
| **Schrödinger's NPC (Dave)** | First-30-second dialogue locks an arc forever | Every relationship in your life has already been one of several states. Your first words determined which. |
| **Inner Voice scaling (Awakening + Fatigue)** | Internal chorus loudness tied to character state | The voices in your head get louder the more you see. Cope silences them; Fatigue amplifies them. |
| **Awakening Filter (visual)** | Cheerful palette gradually reads as wrong | What looked normal becomes legibly artificial. The horror is recognition, not invention. |

**This is the entire game's thesis.** Every mechanic on the list above can be described in two sentences: *what it does* and *what it is saying.* If a future mechanic cannot be described that way, it is a candidate for cutting (per Brief Pillar 1).

#### Mechanic-Theme Alignment (the five core themes from Step 2)

| Theme (Step 2) | Mechanics That Embody It |
|---|---|
| **Manufactured consent** | Slop healing + Slop Damage + Subscription auto-deduction + GnoyNews ambient + cheerful Plaza audio loop |
| **Truth Paradox** | Publication interface (Credibility-vs-Heat) + Conversation log weaponization + Glowie planted-evidence system |
| **Awakening as cost** | Cope drops + Fatigue accumulation + Heat per faction + Recruit loyalty erosion + NPC Mode unusability at high Fatigue |
| **Equal-opportunity satire of ideology** | Vault funds all four Pulpit lineages (mechanical, not narrated) + Pulpit Quarter shared infrastructure (visual) |
| **The world doesn't revolve around you** | Politburo Simulation + cold cases + missable beats + Reputation Web independence |

**Every theme has at least three mechanical anchors.** None is delivered through dialogue alone. *This is what "the satire IS the mechanics" looks like in audit form.*

#### Story-Gameplay Balance

**No discrete sections.** Gnoy Simulator does not have "story sections" and "gameplay sections." The day cycle integrates investigation, dialogue, combat, and routine maintenance into a continuous flow. The player decides when to push a thread, when to rest, when to investigate, when to fight, when to talk, when to sleep.

The closest thing to a "story section" is the opening "A Perfectly Normal Morning" tutorial (~15 min) and the per-ending coda sequences. Everything between is integrated.

#### Ludonarrative Considerations

**The design forecloses common ludonarrative dissonance traps:**

- **No "save the world" framing while looting random NPCs' homes.** The looting in Gnoy Simulator is contextualized — the player is investigating, infiltrating, recovering documents. Random theft generates Heat and degrades Reputation Web with the burglarized district.
- **No combat as default solution.** Hotline Miami lethality means combat is a *choice with permanent consequences*, not a problem-solver. Most encounters have non-combat resolutions.
- **No "good ending requires murdering everyone" structural trap.** Faction OWNED can be reached via investigation, social manipulation, or combat — multiple paths to the same mechanical outcome.
- **No "the protagonist hates the system but the player's gameplay reinforces it."** The Awakening Track and Slop Damage stat are *direct mechanical encoding* of the protagonist's relationship to the system. Player play *changes* both.

**One ludonarrative-dissonance risk to monitor:**

- **The Crafter recruit makes signature weapons that are useful in combat.** A pacifist player's narrative arc may dissonate with a high-Crafter homebase. **Mitigation:** Crafter weapons are also dual-purpose (Megaphone, Camera Flash, Fake ID Packet) — pacifist runs use the non-lethal subset. Document this in production sub-docs.

---

### Story Gating

#### Gating Approach

**Soft-gate dominant + build-gated geography.** Almost no hard story gates. Story is *available* via player exploration and *gated* via character build state.

#### Gate Types in Use

| Gate Type | Where It Fires |
|---|---|
| **Hard story gates** | The 7 cutscenes (mostly skippable). The Endgame Trigger commitment. The first-play Doctored Feed Segment. **That is the entire list.** |
| **Soft story gates** | Most NPC dialogues (player can decline). Most boss investigations (player chooses which to chase). Most documents (player chooses to read). |
| **Build-gated geography** | Sneak routes (Ghost Mode threshold) + Internal Voices (Awakening threshold) + Xyoner symbol legibility (Awareness threshold) + War Room access (HQ Stage 3+) + Compound approach (Awake 9+). |
| **Awakening-gated dialogue lines** | Internal Voice options scale with Awakening + Fatigue + Cope. Some dialogue choices become available only at sufficient Awakening. |
| **Item-drop gated dialogue** | Specific evidence items unlock specific dialogue lines. Player can return to old conversations with new items. |
| **Faction Standing gated content** | Higher faction standing opens new dialogue + new boss-confessional content. |
| **Reputation Web gated NPCs** | NPCs the player has built rapport with give different conversational openings to other NPCs in their gossip network. |

#### Story-Locked Elements

- **The Compound** — Awakening 9+ gated. **The only district fully gated by character state.**
- **The Inner Ring Betrayal Reveal scene** — gated by Compound approach.
- **Awakening Track cinematics** — fire when threshold crossed.
- **The 5 endings** — each gated by accumulated state at Endgame Trigger.

#### Mandatory Story Beats

**Six mandatory beats across the entire game:**

1. "A Perfectly Normal Morning" tutorial (Beat 1) — fires on game start. Cannot be skipped on first play.
2. The Doctored Feed Segment (Beat 2) — fires at end of tutorial. Cannot be skipped on first play.
3. The Inner Ring Betrayal Reveal (Beat 5) — fires at Compound approach. Cannot be skipped on first play.
4. Awakening Level 10 cinematic (Beat 6) — fires at Awakening 10 (skippable but not pre-trigger-able).
5. The Endgame Trigger (Beat 23) — player-decided commitment moment.
6. The Coda of whichever ending fires (Beat 7).

**Everything else is optional.** A Sleep playthrough fires only beats 1, 2, and 7 (Sleep ending coda).

#### Optional Narrative

**Per Step 8: ~80% of total content volume is optional.** The Brief's "no markers default" + "quest journal is character's notes" design is the operational expression of this. The player who explores deeply is rewarded; the player who plays minimally still gets a coherent (and short) narrative arc.

---

### Player Agency

#### Agency Level

**Full agency** (in the Disco Elysium / Fallout: New Vegas tradition). The player is not a witness to a fixed story. The player *creates* the story through:

- Build identity (7 attributes × 24 skills × 40 talents × 2 disposition axes)
- Faction relationships (5 factions × Standing ladder × cross-faction politics)
- Investigation choices (which threads to pull, which evidence to publish, how to frame it)
- Dialogue choices (3-5+ paths per goal, conversation log weaponized)
- Recruit choices (who to bring in, who to invest in, who to keep at arm's length)
- Combat-or-not choices (Hotline Miami lethality means every fight is a real decision)
- The Endgame Trigger timing (player-decided)
- The 5 endings (state-determined from accumulated play)
- The Sleep-path opt-out (always available)

**The protagonist is not a character with a fixed personality being shipped through a plot. The protagonist is a build the player walks through a simulation.**

#### Player Influence

**The player can affect:**

- The protagonist's identity (body, gender, name, build, voice-of-self via Inner Voice training)
- The protagonist's relationships (Dave's arc state, every recruit's loyalty trajectory, every NPC in the Reputation Web)
- The protagonist's standing in the world (faction standings, public Credibility, Cage dossier exposure)
- The protagonist's network (who they recruit, who they lose, who they break)
- The world state (which factions get COMPROMISED, which districts get partially Liberated, which Politburo events get caused or stopped)
- The ending and its specific epilogue beats

**The player cannot affect:**

- The Xyoner system existing (it is a world-state truth)
- The Truth Paradox existing (it is a world rule, not a player-toggleable mechanic)
- Faction structures existing (the 5 factions are world-furniture)
- The 13 boss roles existing (specific bosses can be defeated; the *role* gets succession-filled)
- The Music Deterioration Mechanic (it fires per Awakening; cannot be opted out)
- The Inner Ring's existence (a world fact)
- The Mole's role (the *who* is TBD per Step 4 open question; the *role* is locked)

#### Choice System

**Every choice falls into one of three categories:**

| Choice Tier | Description | Example |
|---|---|---|
| **Identity Choice** | Permanently defines the protagonist's character | Dave Schrödinger's dialogue (Beat 8); Endgame Trigger (Beat 23); Inner Ring slot offer accept/reject |
| **State Choice** | Affects accumulated state that drives ending and per-character outcomes | Each subscription cancellation; each publication framing decision; each recruit loyalty decision |
| **Flavor Choice** | Affects tone/conversation log without mechanical state change | Most routine NPC dialogue; most Forum chat options |

**Choice timing:** Choices are surfaced *in the flow of play*, not at scripted decision points. The Disco Elysium convention (visible-DC, hidden-consequence) is preserved across all choices. **The player commits to who they are by what they do, not by selecting from a multi-choice ending menu.**

#### Role-Playing Freedom

**High.** The 24-skill / 40-talent system supports radically different builds. Documented viable build archetypes (per Step 2 motivations and Step 4 player conflicts):

- **The Documentarian** — MIND-heavy, evidence-focused, Investigation UI specialist
- **The Wrecker** — BODY/MOUTH-heavy, faction-disruption-focused, dialogue-as-combat specialist
- **The Survivor** — SOUL/GUT-heavy, longevity-focused, Cope-managed deep run
- **The Operator** — MOUTH/SIGNAL-heavy, faction-manipulation-focused, Shadow Replacement-aimed
- **The Refuser** — Default Gnoy build, Sleep-ending-aimed, low engagement with all systems above
- **The Ghost** — GHOST-heavy, infiltration-focused, low Heat / high stealth specialist
- **The Touch-Grass** — BODY-heavy, simulation-focused, day-cycle-comfortable, low ambition

**Each archetype plays a fundamentally different game on the same map.** Per Brief: "The Full Gnoy and the Awakened are playing different games on the same map."

---

### Production Notes (carried forward to Step 10)

- **Mechanic-theme audit:** The "what it does / what it is saying" list above is a **production-tier governance artifact**. Any new mechanic proposed during production must pass this two-sentence test or be cut. Add to GDD update workflow.
- **Build-archetype playtest gating:** Vertical slice should support **at minimum 3 build archetypes** to validate the "different game on same map" claim. Recommended: Documentarian + Wrecker + Refuser as the most divergent triad.
- **Pacifist-build crafter dissonance** flagged above — production sub-docs for Crafter recruit must specify dual-purpose-weapon framing.
- **Inner Ring slot offer/accept** as Identity Choice — needs explicit dialogue tree authoring at endgame; tied to Mole identity decision (Step 4 open question).

---

## Production Planning

> **Document scope:** This section consolidates every production-relevant note carried forward from Steps 4-9 into a single budget/scope reference. **It is the artifact to hand a producer or publisher.** Estimates are designer-realistic, not aspirational; ranges reflect uncertainty in scope, not in cost.
>
> **Two scope paths are documented:** (1) the **full-scope North Star** (the design as locked across the GDD and Steps 1-9 of this NDD, scoped for a 3-5 person team), and (2) the **Solo + Vibe-Coding Ship Target** (the realistic ship scope under Cpain's confirmed solo + AI-assisted development constraints). The solo path is the recommended ship target.

---

### Writing Scope (Full-Scope North Star)

#### Estimated Total Word Count

**~280,000-340,000 words at full launch.** Disco-Elysium-tier (~300k baseline confirmed in Brief), with refined estimates per content type below. **This is the largest single content cost line item in the project and the single largest scope risk.**

#### Content Breakdown

| Content Type | Estimated Words | Notes |
|---|---|---|
| **Boss dialogue (13 bosses)** | ~75,000-100,000 | Asymmetric. Tier-S dialogue bosses (Trusted Anchor, Debt Dealer) are 5-10× the writing of a combat boss. |
| **Recruit dialogue (7 specialist roles + named instances)** | ~40,000-55,000 | Recruitment + erosion + resolution per recruit; aggregated across instances. |
| **Inner Voices (24 voices, scaled chorus)** | ~50,000-70,000 | Scaled per Awakening + Fatigue + Cope state. Heavy combinatorics. |
| **Routine NPC dialogue (Reputation Web)** | ~30,000-40,000 | Tier-B, template-and-fill workflow after locked patterns. |
| **Forum threads / posts (~150-200 threads)** | ~25,000-35,000 | Mix of authored Tier-S threads + template-and-fill Tier-B threads. |
| **News segments (~80-120 segments + Politburo recombinations)** | ~15,000-20,000 | Politburo Simulation generates recombinations from authored fragments. |
| **Faction documents (~200-300)** | ~20,000-30,000 | Per boss investigation + ambient infiltration evidence. |
| **Per-ending epilogues (5 endings)** | ~25,000-50,000 | Highest-density single-section writing in the game. Per-character fate updates require state-conditional authoring. |
| **Cutscene scripting** (7 cutscenes, ~25-40 min total) | ~5,000-8,000 | Compact; in-engine, real-time-rendered. |
| **Personal artifacts + corporate ephemera + government records** | ~10,000-15,000 | Short, dense lore objects. |
| **Anonymous tip dossier entries (Mole signature)** | **Variable per Mole identity choice** | Cynic Mole: ~3,000-5,000 words. True Believer Mole: ~12,000-20,000 words. **This is the production-cost differential of the open question.** |
| **UI / system text / menus** | ~5,000-8,000 | Interaction prompts, ability descriptions, system messages. |

#### Scene / Chapter Count (functional units, full scope)

- **6 acts** (Prologue + 4 Acts + Coda) — narrative architecture
- **23 named story beats** (Step 3) + **5 Sleep-path beats** = 28 beats with authored or triggered content
- **13 boss investigations** — each is a multi-encounter functional unit
- **7 specialist recruit personal quests** (+ named-instance variants) — each is a multi-scene functional unit
- **5 ending sequences** — each is a coda + epilogue authored unit
- **~30-60 Reputation Web side quests** at full launch
- **~5-10 Cage Black Site infiltrations** at full launch

**Total functional authored units:** ~95-130 distinct scenes/quests/sequences requiring per-unit writing scope.

#### Branching Complexity Impact

- **30-40% unique-content per line** for routine dialogue (most builds see most lines)
- **50-60% unique-content per line** for boss confrontations (build identity matters more)
- **70-80% unique-content per line** for the 7 Tier-S key conversations (Schrödinger's Dave, dialogue bosses, Betrayal Reveal, etc.)
- **3-5+ paths per dialogue goal** means most authored content has multiple gated variants

**The branching system is the single largest writing-cost multiplier** beyond raw word count. The multiplier is captured in the per-content-type estimates above.

#### Writing Pipeline (full-scope production phases)

| Phase | Writing Scope | Word Count |
|---|---|---|
| **Vertical slice** | Tier-S key conversations (Schrödinger's Dave, Trusted Anchor, Fact Checker as 2-boss prototype), opening tutorial, Awakening L1 cinematic, ~3 viable build archetypes' dialogue paths in covered content | ~40,000-55,000 |
| **Early Access launch** | 4-5 boss investigations fully written, 1 ending playable + Sleep ending, Inner Voice chorus operational at L1-L5, partial Forum + Reputation Web | ~120,000-160,000 |
| **Full launch** | All 13 bosses + 5 endings + full Inner Voice scaling + all districts + complete Forum + Reputation Web | Total ~280,000-340,000 |

---

### Solo Dev + Vibe Coding Production Path (recommended ship target)

> **Constraint update:** Cpain has confirmed solo development with AI-assisted (vibe coding) implementation. The full-scope estimates above are the *North Star design*; this section captures the realistic *ship target* under solo + vibe-coding constraints. Both paths are documented so future-Cpain can scale up to the full scope if team size grows.

#### Recommended Solo Ship Target: ~80,000-120,000 words at full launch

**Calibration:**

- Pentiment shipped at ~140k words with a small Obsidian team in ~2 years
- Citizen Sleeper at ~60k words (small team)
- Cruelty Squad at ~10k words (solo)
- **80-120k is the achievable solo + vibe-coding band over 18-30 months from vertical slice.**
- Vibe coding accelerates implementation (code, art, music) by ~30-50%; narrative-quality work (voice consistency, satire calibration, sensitivity review) does not significantly accelerate. **Word count is bottlenecked by author-review bandwidth, not generation speed.**

#### Recommended Cuts (ordered by leverage)

| Cut | Word Count Saved | What's Lost | What Survives |
|---|---|---|---|
| **Boss roster: 13 → 5-7** (one per faction, not multiple) | ~40,000-50,000 | Boss roster depth | All 5 factions still represented; Trusted Anchor + Debt Dealer dialogue bosses preserved |
| **Pulpit: 4 sub-bosses → 1 boss with rotating ideological masks per sub-area** | ~15,000-20,000 + significant sensitivity-review savings | Per-lineage character depth | **Equal-opportunity claim still mechanically true** — same boss, different mask, all Vault-funded. *Arguably more elegant satire.* |
| **Endings: 5 → 3** (Public Reckoning, Sleep, one middle — Long Game OR Shadow Replacement) | ~15,000-30,000 | Two endings | Sleep co-equality preserved; Truth Paradox spine intact |
| **Inner Voices: 24 → 12** (two per attribute, not four) | ~25,000-35,000 | Voice ensemble density | Disco-Elysium-feel preserved with tighter chorus |
| **Districts: 12 → 5-7** (merge Slop Belt into Plaza; merge University Row into Pulpit Quarter; drop Outskirts; consolidate Tier 2) | ~10,000-20,000 + significant art savings | Map breadth | Slopside, Cubicle Belt, Plaza, Pulpit Quarter, Hollow, Compound preserved — every load-bearing district stays |
| **Reputation Web: dozens → 15-20 named NPCs total** | ~10,000-15,000 | Background depth | The mechanic intact, just smaller cast |
| **Forum threads: 150-200 → 30-50, mostly AI-templated** | ~15,000-25,000 | Forum density | Forum-as-relationship preserved |

**Aggregate cut: ~280,000-340,000 → ~80,000-120,000 words.**

#### What Survives the Cut (the design's load-bearing pieces)

- **Pillar 1 (mechanical satire) — fully intact.** Every locked mechanic from the GDD survives.
- **Truth Paradox spine — intact.**
- **Schrödinger's Dave — intact.** Highest-leverage replayability hook preserved.
- **Music Deterioration Mechanic — intact.** Signature mechanic preserved.
- **All 5 factions — intact** (just fewer named bosses per faction).
- **Sleep ending co-equality — intact.**
- **Disco × Hotline Miami × Persona DNA — intact.**
- **Build-gated geography — intact** (just fewer districts to gate).
- **Conversation log weaponization — intact** (mechanic-level, not volume-level).

#### Vertical Slice Target (Solo)

**4-6 months, ~20,000-25,000 words.** Ship publicly before scaling.

- **One district fully playable:** Slopside + Cubicle Belt corridor (including Greystone)
- **One boss prototyped end-to-end:** Trusted Anchor (dialogue boss prototype — proves the highest-cost writing pattern)
- **Opening tutorial complete:** "A Perfectly Normal Morning"
- **Awakening Levels 1-3 functional** (Inner Voice scaling, music deterioration tier 1-2)
- **Schrödinger's Dave dialogue fully written** (3 branches)
- **Investigation UI Layers 1-2 (Physical Board + Dossier Interface) functional**
- **Hotline Miami combat loop working with capture mechanic**
- **Day cycle with finite slots, snooze cost, subscriptions, sleep tick**

#### Hand-Written vs. AI-Assisted Breakdown

| Content Tier | % of Total | Approach |
|---|---|---|
| **Tier S — Hand-authored (Cpain writes)** | ~30-40% (~30,000-50,000 words) | Schrödinger's Dave (all 3 branches), dialogue boss confrontations, the Mole reveal, the "we don't know" Inner Ring refusal scene, all 3 ending codas, opening tutorial, Awakening cinematics. **Voice consistency and satire calibration require Cpain's authorial hand. AI cannot replace this.** |
| **Tier A — AI-assisted with heavy review (Cpain reviews/rewrites every line)** | ~30-35% (~25,000-40,000 words) | Recruit dialogue, faction-boss-confessional dialogue, Inner Voice scaling variants, Sleep-path beats. AI generates first draft from style guide; Cpain rewrites for voice. |
| **Tier B — AI-templated with light curation (Cpain reviews patterns + samples)** | ~30-35% (~25,000-40,000 words) | Routine NPC dialogue, Forum thread fillers, faction documents, ambient news segments, Reputation Web side conversations. AI fills templates from authored patterns; Cpain audits sampling. |

**Critical: tier assignments are about *what AI is good at*, not about *what's important*.** Tier-B content is still narratively necessary — it's just authored via a different process.

#### Vibe-Coding-Specific Risks

- **Voice consistency drift** is the highest narrative risk. AI-generated text in the Pulpit Quarter at month 18 will not naturally match Cpain's hand-written style from month 4. **Mitigation:** maintain a living style guide updated per content tier; periodically re-review Tier-B content against latest Tier-S authored material.
- **Sensitivity review still requires human judgment.** Even with reduced Pulpit roster (1 rotating boss vs. 4), the satire targets sensitive ideologies. **Budget for at least one external sensitivity reviewer pass before EA launch.** AI cannot certify this.
- **The "what it does / what it is saying" mechanic-theme audit (Step 9)** is a *design governance test*, not a generation task. Every AI-suggested mechanic or system must pass Cpain's two-sentence test or be cut.
- **Audio production cannot be vibe-coded to the same degree.** AI music tools have improved but the Music Deterioration Mechanic is a precision artisan asset (5 tiers per track × ~25 tracks = 125 recordings). **Recommend dedicated composer collaboration even in solo mode** — this is the line item where solo + AI breaks down hardest.

#### Solo Ship Timeline Estimate

| Phase | Duration | Word Count Cumulative |
|---|---|---|
| **Vertical slice** (one district + one boss + tutorial + base systems) | 4-6 months | ~20,000-25,000 |
| **Early Access launch** (3 districts, 3 bosses, 1 ending playable + Sleep, full Inner Voice scaling at L1-L7) | +12-18 months from VS | ~50,000-70,000 |
| **Full launch** (5-7 districts, 5-7 bosses, 3 endings, full system depth) | +6-12 months from EA | ~80,000-120,000 |

**Total estimate: 22-36 months from vertical slice start to full launch, solo + vibe-coding.** The Brief's 30-48 month full-launch estimate (which assumed 3-5 person team) is replaced by this estimate for the solo path.

#### Publisher / Funding Implications

- **Solo + vibe-coding scope is Kickstarter-receptive.** ~$50-150k campaign target reasonable for this scope; covers living expenses, dedicated composer, sensitivity reviewer, and a contracted artist for environments/portraits if needed.
- **Publisher signing remains an option** at the small end (Devolver / 11 bit / Raw Fury). Expectations would scale: a publisher-funded version could re-expand toward the full 280-340k scope with hired writers.
- **Self-funded EA** is the most-likely realistic path. Solo + vibe-coding scope makes EA a meaningful milestone, not a compromise.

---

### Localization

#### Approach: English-only at launch (recommended for both scope paths)

**Rationale:**

- Even at solo-scope (80-120k), per-language localization runs ~$0.10-0.20 per word professionally — $8,000-24,000 per language tier just for base translation, before LQA and cultural-adaptation review.
- Satirical content carries unusually high translation risk — jokes don't survive literal translation; the equal-opportunity satire framing of the Pulpit roster requires per-region cultural-adaptation review that adds significant cost.
- Per Brief: localization decision deferred to GDD stage. **This NDD recommends English-only at launch for both scope paths.**

#### Future Consideration (post-launch tiered approach)

| Tier | Languages | Rationale |
|---|---|---|
| **Tier 1** | German, French, Russian, simplified Chinese | Largest CRPG audiences globally |
| **Tier 2** | Spanish (Latin American + Castilian), Brazilian Portuguese, Polish | Disco Elysium / Pentiment-tier audience presence |
| **Tier 3** | Japanese, Korean, Italian | Genre-fit but smaller audience overlap |

#### Cultural Adaptation Notes

- **Pulpit roster requires per-region cultural-adaptation review.** The four ideological lineages (or the rotating-mask version in solo path) map differently in different cultural contexts. Equal-opportunity-satire framing must survive translation.
- **Brand satire** (McXyon's, Greystone, GnoyNews) reads differently per region. May require per-language localized brand parodies.
- **Forum-poster vernacular** is contemporary internet English. Per-language equivalents must capture the *register*, not the *literal text*.
- **Inner Voice text-rendering style** must work across non-Latin alphabets. Engineering scope item.

#### Technical Considerations

- Text expansion buffer: 30% standard for German/Russian; 20% for Romance languages; 15% for CJK. UI must accommodate.
- UI flexibility: Resistance-style (hand-made) UI accommodates variable text more gracefully than Xyoner-style (corporate-app).
- Audio: No dubbing planned even for non-English markets. **Subtitled approach for boss VO + key NPC VO.**

---

### Voice Acting

#### Approach: Selectively voiced (both scope paths)

**Voiced scope (locked recommendations):**

- **Boss dialogue** for all bosses (5-7 in solo path; 13 in full-scope path), weighted heavily toward dialogue bosses (Trusted Anchor, Debt Dealer).
- **Key NPC voice acting** for Dave (state-conditional voice across 3 arcs), named specialist recruits, and the defected Inner Ring member ("we don't know" refusal scene).
- **Trusted Anchor's broadcast-voice cracking** during the dialogue boss fight — *signature single VO performance moment of the game.*

**Text-only scope (locked):**

- **All Inner Voices** (12 in solo path; 24 in full-scope path) — text-only delivery.
- **All routine NPC dialogue** — Reputation Web, ambient Gnoym, generic faction operatives.
- **All Forum threads + news segments + faction documents** — written artifacts, not spoken.
- **Player character** has no voiced dialogue (preserves customizable-protagonist design).

#### Characters Needing Voices

**Solo path: ~12-18 voice actors at full launch.**

- 5-7 boss roles
- Dave (3 voice tracks for 3 states) = 1 actor with multi-take
- 7 specialist recruit roles + ~5-8 named-instance recruits = ~6-10 supporting actors
- Defected Inner Ring member = 1 actor
- Glowie archetype roster = 2-3 actors with multi-character casting

**Full-scope path: ~25-35 voice actors at full launch.**

#### Dialogue Volume for Recording (solo path)

- **Boss dialogue VO:** ~20,000-30,000 words spoken
- **Dave + recruit + Inner Ring member VO:** ~8,000-12,000 words spoken
- **Crowd ambient + Glowie work:** ~3,000-5,000 words
- **Total spoken word recording (solo path):** ~30,000-50,000 words

#### Recording Approach

- **Professional voice cast preferred** for Tier-S roles (Trusted Anchor, Debt Dealer, Dave, defected Inner Ring member, Mole reveal).
- **Mid-tier professional or experienced indie casting** acceptable for remaining boss roles + recruit roles.
- **Placeholder recordings during development** acceptable; final recording in last 6-9 months pre-launch.

---

### Audio Production (cross-reference Step 7)

#### Music Deterioration Pipeline (signature mechanic, locked production scope)

- **5 deterioration tiers per Xyoner-space track** (per Step 7, Indie's scope-tiering recommendation):
  - Tier 1: Clean (Awakening 1-2)
  - Tier 2: Subtle Off-Notes (Awakening 3-4)
  - Tier 3: Skipping (Awakening 5-6)
  - Tier 4: Audible Corruption (Awakening 7-8)
  - Tier 5: Damaged-File (Awakening 9-10)
- **Solo-path estimated track count:** ~12-18 distinct Xyoner-space tracks. **5 tiers × ~15 tracks = ~75 distinct audio recordings** (full-scope path is ~125 recordings).
- **The McXyon's jingle is the highest-priority single audio asset.** Lock composition + 5 tiers in vertical slice.

#### Other Audio Production Items

- **Pirate broadcast audio fidelity system** — skill-tied audio modulation. Custom audio engineering work.
- **Homebase ambient growth (4 stages)** — ~12-20 distinct ambient layers across 4 homebase stages.
- **Inner Voice text-rendering** — typography work (no audio, per locked text-only scope).
- **Combat audio** (Hotline Miami DNA) — synthwave/electronic, ~6-10 tracks (solo path).
- **Investigation audio** (Burial / Arca DNA) — ambient tension, ~4-8 tracks (solo path).
- **Per-ending coda music** — 3 distinct ending themes (solo path; 5 in full-scope).

#### Audio Budget Summary

**Audio is the under-budgeted line item identified in the Brief.** Per Brief, "the music deterioration mechanic alone implies multi-version recordings of every Xyoner-space track." Estimated audio production cost: **2-3× standard indie game audio budget.** **Dedicated composer essential — even at solo-dev scope.** This is the line item where solo + AI breaks down hardest.

---

### Engineering / Tooling Production Notes

> Cross-references throughout Steps 5-9. Consolidated here for engineering scope. Engineering scope is the same for both production paths — content scaling does not significantly alter tooling requirements.

| Engineering Item | Scope | Priority |
|---|---|---|
| **Dialogue authoring tool** | Visible-DC tagging, hidden-consequence linking, item-drop conditionals, conversation-log weaponization (per-line tagging for later quote-back retrieval), Reputation Web ripple triggers, Inner Voice scaling rules | **Critical — must be built before scaling content.** |
| **Awakening Filter (visual post-process)** | Progressive saturation pull at Awakening 5+; configurable per Awakening level; performance-tested on minimum-spec hardware | High — affects every district at high Awakening |
| **Music deterioration audio routing** | Smooth crossfading per Awakening level; no jarring transitions; 5-tier playback selection per track | Critical — signature mechanic |
| **Pirate broadcast audio fidelity modulation** | Skill-tied audio engineering | Medium — needed by Stage 3 HQ |
| **Conversation log retrieval system** | Per-line tagging + retrieval for later weaponization (NPC quote-back, Cage interrogation, Feed editing) | High — central to Truth Paradox theme |
| **Reputation Web ripple system** | Gossip propagation across Slopside-tier NPC networks | High — per-NPC dialogue tree modification |
| **Politburo Simulation tick** | Weekly in-game tick; faction succession events; emergent narrative event surfacing | Critical — independent world simulation |
| **Dossier UI with anonymous-tip tagging** | Source attribution per evidence (per Step 5 Mole-discovery mechanic) | High — Mole identity reveal mechanism |
| **Investigation UI 3 layers** (Physical Board / Dossier Interface / Thought Cabinet) | Three custom UI systems with persistent state | Critical — per Brief locked design |
| **War Room (HQ Stage 3+)** | Network graph + map overlay + live news ticker + Heat map + Dossier panel | High — Stage 3 progression gate |
| **Faction Standing UI** | "Exploit available" indicator at FLAGGED+ with both Cage and Feed | Medium — per Step 5 |

---

### Cross-Production Dependencies (the things that depend on other things)

- **Mole identity decision (Step 4 open question)** → drives anonymous-tip dossier authoring volume → drives writing pipeline scope.
- **Pulpit roster decision (4 sub-bosses vs. 1 rotating-mask boss)** → solo path recommends rotating-mask; full-scope path can support 4. **Decision tied to scope path selection.**
- **Inner Ring size (Brief Open Question #3)** → drives Compound endgame structure + final cinematic scope.
- **Engine selection (Brief Open Question #1)** → drives all engineering item scope; recommended bias toward Unity or Godot per Brief.
- **Localization tier decision** → drives translation budget; English-only at launch is the recommended baseline for both paths.
- **Vertical slice boss prototype** (recommendation: Trusted Anchor for solo path; Trusted Anchor + Fact Checker for full-scope) → locks per-boss writing template before scaling to remaining bosses.
- **Sensitivity-reader engagement timing** → must precede Pulpit boss writing, not follow it.

---

### Open Production Questions Carried to Architecture / Sprint Planning Phases

| Question | Source | Owner | Decision Deadline |
|---|---|---|---|
| **Scope path selection** (solo vs. full) | Step 10 | Cpain | **Decided: Solo + Vibe Coding ship target recommended; full-scope retained as North Star.** |
| **Mole identity** | Step 4 / Brief OQ #10 | Cpain | Before endgame implementation begins |
| **Inner Ring size** | Brief OQ #3 | Cpain | Before Compound implementation begins |
| **Pulpit boss configuration (4 sub-bosses vs. 1 rotating-mask)** | Step 4 + Step 10 | Cpain | **Solo path recommendation: 1 rotating-mask boss.** Confirm before Pulpit Quarter content scaling. |
| **Engine selection** | Brief OQ #1 | Cpain + Architect | Architecture phase (next workflow) |
| **Funding model** | Brief OQ #2 | Cpain | Before vertical slice begins. **Solo + vibe-coding scope is Kickstarter-receptive at $50-150k.** |
| **Localization tier at launch** | Brief OQ #5 + Step 10 | Cpain + Publisher (if engaged) | Before Early Access launch. **Recommendation: English-only at launch for both paths.** |
| **Talent-system 40-talent details** | Brief OQ #4 | Cpain | GDD update; before vertical slice systems implementation |
| **Combat difficulty tuning approach** | Brief OQ #8 | Cpain + playtest data | Vertical slice playtest |
| **Steam Workshop / modding support** | Brief OQ #9 | Cpain + Architect | Before Early Access launch |

---

### Summary — Production Realism Statement

**Gnoy Simulator has two scope paths documented:**

**Full-scope North Star (3-5 person team):** 280,000-340,000 words; 13 bosses; 12 districts; 5 endings; 24 Inner Voices; 30-48 months from vertical slice. The full design as locked across the GDD and this NDD.

**Solo + Vibe-Coding Ship Target (Cpain confirmed):** 80,000-120,000 words; 5-7 bosses; 5-7 districts; 3 endings; 12 Inner Voices; 22-36 months from vertical slice start. **All design pillars survive the cut**; the satire pillar, the Truth Paradox, the Schrödinger's NPC, the Music Deterioration Mechanic, the build-gated geography, and the Sleep ending co-equality are all preserved.

**The single most important risk-mitigation action is locking the vertical slice scope and not exceeding it.** Per Brief: "vertical slice first; design supports content cuts; early-access path is structurally available." Solo + vibe-coding makes that constraint *more* binding, not less. **Every estimate above is achievable if and only if vertical slice discipline is maintained.**

The solo path is the recommended ship target. The full-scope path remains documented for future scaling.

---

## Appendix A: Character Relationship Map

```
                           [THE INNER RING / "THE ARRANGEMENT"]
                                     |
                              (size unknown, identities hidden until endgame)
                                     |
                              [THE MOLE — TBD identity]
                                     |
                          (anonymously feeds info to → )
                                     |
                                     ↓
   [THE XYONERS]                                                   [THE PROTAGONIST]
   (collective antagonist)                                         (build-defined; default: Full Gnoy Wageworker)
        |                                                                    |
        ├── The Trough        ─── Innovation Czar, Soil Baron, Revolving Door |
        ├── The Feed          ─── Engagement Architect, Trusted Anchor★, Fact Checker
        ├── The Pulpit (Vault-funded) ─── Prosperity Prophet, Think Tank Sage,
        |                                  Settlement Ideologue, Jihadist Franchise Operator
        ├── The Cage          ─── Intelligence Artisan, Glowie (recurring)
        └── The Vault         ─── Benevolent Billionaire, Debt Dealer★, Number Go Up Guy
                                                                              |
   ★ = dialogue boss (multi-stage composure HP)                              |
                                                                              |
                            (player can be: cataloged by ↔ catalog of)        |
                                                                              |
   [THE INNER VOICE CHORUS]                                                   |
   (24 voices, scaling with Awakening + Fatigue + Cope)                       |
        |                                                                    |
        ├── MIND: Rabbit Hole, [X] Fatigue, Doxcraft, Edit Farm               |
        ├── SOUL: Glowie Sense, Yap Game, Lore Depth, Based Talk              |
        ├── MOUTH: Rizz, NPC Mode, Ratio, Clout                              |
        ├── GHOST: Ghost Mode, Normie Cosplay, Receipts, OPSEC                |
        ├── BODY: Gymmaxx, Hands, Anti-Slop, IRL Build                        |
        └── SIGNAL: Web, Ghost Protocol, Sneaky Links, Signal Hijack          |
                                  (speak inside →)                            |
                                                                              ↓
   [DAVE — The Schrödinger's NPC]   ←─ (first dialogue locks state) ─    [DIRECT RELATIONSHIPS]
        ├── Default-Gnoy state: friend → forever-Gnoy (heartbreak flat arc)   |
        ├── Real-answer state: → Researcher recruit (positive arc, may be lost)|
        └── Too-awakened state: → Glowie (negative arc, player-triggered)     |
                                                                              |
   [THE 7 SPECIALIST RECRUITS]                                                |
   (commitment → erosion → resolution arc)                                    |
        ├── Researcher (default: Dave if recruited)                           |
        ├── Broadcaster                                                       |
        ├── Crafter                                                           |
        ├── Medic                                                             |
        ├── Quartermaster                                                     |
        ├── Analyst (War Room operator; Inner Ring inference contact)         |
        └── Handler                                                           |
                                                                              |
   [THE REPUTATION WEB]                                                       |
   (15-20 named Gnoym in solo path; dozens in full scope)                     |
        — gossip propagates between them                                      |
        — their interrogated memories enter the player's dossier              |
        — the player's words reach NPCs they've never met                     |
                                                                              |
   [FORUM CONTACTS]                                                           |
   (anonymous underground forum)                                              |
        — first network contact (Beat 10)                                     |
        — Inner Ring inference fodder                                         |
        — Hidden Secret discovery paths                                       |
                                                                              |
   [THE DEFECTED INNER RING MEMBER]   ←─ (single-scene; Awakening 9+) ─       |
        — delivers the "we don't know if we made it or found it" refusal      |
        — appears once at Compound approach                                   |
```

### Relationship Key

- **The Mole → The Protagonist:** anonymous-tip provider throughout campaign, revealed at Beat 5 (Betrayal Reveal)
- **The Xyoners → The Protagonist:** collective antagonist; relationship mediated by Faction Standing per faction (UNKNOWN→FLAGGED→OBSERVED→ASSET→COMPROMISED→OWNED)
- **Inner Voices → The Protagonist:** internal chorus; speak with frequency and volume scaled by Awakening + Fatigue; Cope governs silenceability
- **Dave → The Protagonist:** Schrödinger's first-dialogue lock; one of three permanent states (friend, recruit, Glowie)
- **Specialist Recruits → The Protagonist:** commitment-erosion-resolution; loyalty resource; permanent loss possible
- **Reputation Web → The Protagonist:** distributed gossip network; 15-20 named NPCs (solo path); each remembers the player's words verbatim
- **Forum Contacts → The Protagonist:** anonymous underground network; first reached via Beat 10 (First Underground Forum Post)
- **Defected Inner Ring Member → The Protagonist:** single-scene refusal; appears at Compound approach; refuses the deepest world question
- **The Cage vs. The Feed:** pre-existing rivalry exploitable by player at high MIND
- **The Vault → The Pulpit (all 4 lineages):** secret cross-funding; controlled-opposition device

---

## Appendix B: Story Timeline

```
[BACKSTORY — pre-game, not litigated]
- The Consolidation (factions achieve dominance)
- The Information Reform (Feed achieves algorithmic dominance)
- The Loyalty Audits (Cage cyclical sweeps)
- The Pulpit Funding Reveal (~5 years pre-game; documented Vault funding all 4 Pulpit lineages; suppressed)
- Player character spends decades as a compliant Gnoy (snooze button, slop subscriptions, GnoyNews)
                                |
                                ↓
[PROLOGUE — Awakening 0]
├── Beat 1: "A Perfectly Normal Morning" (~15 min contextual tutorial)
└── Beat 2: The Doctored Feed Segment (inciting incident — STRUCTURAL TRIGGER)
                                |
                                ↓
[ACT I — THE CRACK — Awakening 1-2]
├── Beat 3: Awakening Level 1 cinematic ★
├── Beat 8: The Schrödinger's NPC Choice (Dave) — IDENTITY CHOICE
├── Beat 9: First Subscription Cancellation
├── Beat 10: First Underground Forum Post
└── Beat 11: First Faction FLAGGED
                                |
                                ↓
[ACT II — THE DOCUMENTARIAN — Awakening 3-5]
├── Beat 12: First Boss Investigation Closed (first Truth Paradox publication)
├── Beat 13: Quitting the Greystone Job (force-resolves Dave if Beat 8 unfired)
├── Beat 14: First Recruit Joined
├── Beat 15: Move to Office Homebase (Stage 2)
├── Beat 4: Awakening Level 5 cinematic ★ (AntiXyonetic label canonized)
└── Beat 16: First Recruit Lost
                                |
                                ↓
[ACT III — THE NETWORK — Awakening 6-8]
├── Beat 17: Underground HQ + War Room Online (Stage 3)
├── Beat 18: First Player-Caused Politburo Event
├── Beat 19: First Faction COMPROMISED → OWNED
├── Beat 20: First Cage Raid Survived (or HQ Lost)
└── Beat 21: First Inner Ring Inference (War Room or Thought Cabinet)
                                |
                                ↓
[ACT IV — THE ARRANGEMENT — Awakening 9-10]
├── Beat 22: Distributed Cell Network Online (Stage 4)
├── Beat 5: The Inner Ring Betrayal Reveal ★ — STRUCTURAL TWIST (Kishōtenketsu)
├── (defected Inner Ring "we don't know" refusal scene)
├── Beat 6: Awakening Level 10 cinematic ★ — EMOTIONAL CLIMAX
└── Beat 23: The Endgame Trigger — IRREVERSIBLE COMMITMENT (HIGHEST TENSION)
                                |
                                ↓
[CODA — one of 3-5 endings]
   Beat 7 ★ branches to one of:
   ├── The Public Reckoning (bittersweet — truth told at total cost)
   ├── The Long Game (patient — permanent underground network) [solo path]
   ├── The Sleep (quiet defeat — co-equal to the others)
   ├── The Shadow Replacement (morally compromised — became the system) [full-scope]
   └── The Burn (destructive catharsis — fire is the character) [full-scope]

[PARALLEL: SLEEP PATH — fires across Prologue → Act I → Coda]
├── Beat S1: The Forum Bookmark Deletion
├── Beat S2: The Subscription Renewal
├── Beat S3: "Dave Stays a Friend"
├── Beat S4: The Promotion Offer
└── Beat S5: The Quiet Years → Beat 7 (Sleep ending coda)

★ = Authored cutscene moment
```

### Timeline Notes

- **Acts are descriptive, not gated.** A player can spend 30 in-game weeks in Act II without crossing to Act III. The Awakening Track advances on player action, not real-time.
- **The Sleep Path runs parallel** to the Awakened path through Act I and resolves directly to the Sleep ending coda.
- **Threshold Jump Behavior** (per Step 3): when the player crosses multiple Awakening levels in a single action, missed cinematic-anchored levels (1, 5) play first as flashback-frame reflection before the higher state takes effect.
- **No urgency timer on the Main Quest.** The Politburo Simulation drifts in the background but the player is never on a clock.
- **Solo path: 3 endings (Public Reckoning, Long Game, Sleep) — see Step 10 cuts.** Full-scope path supports all 5.

---

## Appendix C: References

> Lifted from the Game Brief Reference Framework. Authoritative inspiration list for tone, mechanics, and design DNA.

### Tonal / Mechanical Inspirations

| Game | What It Inspires in Gnoy Simulator |
|---|---|
| **Disco Elysium** (ZA/UM, 2019) | Skill voices, dialogue depth, internal monologue, Thought Cabinet, visible-DC skill checks, satirical tone, customizable protagonist |
| **Return of the Obra Dinn** (Lucas Pope, 2018) | Investigation as core mechanic, deduction-based progression, evidence cross-reference |
| **Papers Please** (Lucas Pope, 2013) | Routine-as-gameplay, banal-evil tone, subtle moral pressure |
| **Hotline Miami** (Dennaton, 2012) | Real-time top-down combat, lethality, instant restart, sound design as weapon |
| **Persona 5 / Stardew Valley** (Atlus, 2016 / ConcernedApe, 2016) | Day cycle, finite slots, social link / NPC progression, weekly rhythm |
| **Fallout: New Vegas** (Obsidian, 2010) | Faction reputation, dark satirical tone, branching consequences, multiple endings, build identity |
| **Shadow of Mordor / War** (Monolith, 2014/17) | Adaptive enemy faction structure (note: Dossier/Politburo/Reputation Web is structurally distinct from WB Patent US 10,926,179) |
| **Pathologic 2** (Ice-Pick Lodge, 2019) | Survival pressure as thematic device, consequences stick, no hand-holding |
| **Cruelty Squad / LISA** | Edgy indie tonal fearlessness, satirical hostility, signature aesthetic choices |
| **Citizen Sleeper / Pentiment** | Modern narrative-CRPG storytelling, time pressure, character-defined endings, **solo + small-team scope reference** |

### Tonal References (non-game)

- **They Live** (Carpenter, 1988) — normal until you see it
- **American Beauty** (Mendes, 1999) — perfection over rot
- **Don't Look Up** (McKay, 2021) — deadpan satirical present
- **Network** (Lumet, 1976) — Trusted Anchor's dialogue boss reference

### Audio Inspiration

- **Burial** — investigation moments, late-night paranoia
- **Arca** — distorted production, awakening corruption
- **Boards of Canada** — ambient tension
- **Perturbator / Carpenter Brut** — combat synthwave
- **Hotline Miami OST** — combat aggression

### Patent & Legal References

- **US 10,926,179** — Warner Bros / Monolith "Nemesis System" patent. The Dossier / Politburo / Reputation Web triad is structurally distinct (memory in faction not individuals; hierarchy in independent simulation; non-hierarchical Reputation Web). **Legal review recommended pre-launch.**

### Cultural / Critical References

- **Manufacturing Consent** (Herman & Chomsky, 1988) — core thematic referent for Manufactured Consent theme
- **Amusing Ourselves to Death** (Postman, 1985) — Feed faction satirical referent
- **Bullshit Jobs** (Graeber, 2018) — Greystone Data Solutions referent

### Source Documents

- `_bmad-output/brainstorming-session-2026-05-03.md` — primary design source (670 lines, 100+ decisions)
- `_bmad-output/game-brief.md` — locked vision document
- `_bmad-output/gdd.md` — Game Design Document v1.0

---

## Document Complete

**Narrative Design Document for Gnoy Simulator** — 11 of 11 steps complete (2026-05-03).

**Recommended next workflows:**

1. **`/gds-game-architecture`** — translate locked design + this NDD into technical architecture
2. **`/gds-create-epics-and-stories`** — break this NDD into implementation epics for sprint planning
3. **`/bmad-shard-doc`** — split this NDD into per-section sub-files for navigability

**All scope decisions, open questions, and production-cost differentials are documented in Step 10.** The solo path is the recommended ship target; the full-scope path is preserved as North Star.
