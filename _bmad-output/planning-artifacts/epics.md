---
stepsCompleted: ["step-01-validate-prerequisites", "step-02-design-epics", "step-03-create-stories", "step-04-final-validation"]
totalEpics: 14
totalStories: 119
totalFRs: 204
totalNFRs: 66
totalUXDRs: 147
verticalSliceScopeHint: "Partial Epics 1/2/3/5/6/7-subset/8-Stage1/9-one-district/10-skeleton/11-one-boss(Fact Checker)/12-full/13-prototype per NFR42"
inputDocuments:
  - "_bmad-output/gdd.md"
  - "_bmad-output/game-architecture.md"
  - "_bmad-output/planning-artifacts/ux-design-specification.md"
  - "_bmad-output/narrative-design/index.md"
  - "_bmad-output/game-brief.md"
---

# goySimulator (Gnoy Simulator) — Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for **Gnoy Simulator**, decomposing the requirements from the GDD (1814 lines), Architecture (873 lines), and UX Design Spec (1195 lines) into implementable stories. Vertical Slice → Early Access → Full Launch staged delivery; solo-dev / vibe-coding cadence on Godot 4.x with GDScript.

## Requirements Inventory

### Functional Requirements

FR1: Player starts as a fully-compliant Gnoy Wageworker, eating slop, scrolling the feed, clocking into a job at Greystone Data Solutions.
FR2: A staged news event cracks the player's reality open and triggers the investigation phase.
FR3: Three-layer investigation UI: Physical Board (diegetic conspiracy board), Dossier Interface (per-evidence desk-style UI with stamping and publication), Thought Cabinet (mental threads).
FR4: Physical Board allows pinning evidence, drawing string connections, and scrawling notes; scales with homebase progression (Stage 1 ~30 items, Stage 4 distributed boards).
FR5: Dossier Interface supports document cross-referencing, stamping evidence as Verified/Uncertain/Planted, and publication with framing angle (accusation/question/investigation/leak/personal testimony/parody).
FR6: Publication interface previews predicted Credibility-vs-Heat delta before commit, modified by relevant skill checks.
FR7: Thought Cabinet processes mental "threads" that cost action slots and yield conclusions reframing existing evidence or unlocking dialogue lines.
FR8: Awakening Track reveals new interpretations of existing evidence (documents filed at Awakening 1 mean something different at Awakening 7).
FR9: Connection Mechanic: drawing a string fires a skill check with three outcomes — Critical Success (confirmed + hidden context), Standard Success (confirmed), Fail (dotted line, publishable at Credibility penalty).
FR10: Wrong connections remain ambiguous; the game does not tell the player they're wrong (Cage plants false evidence to trigger this).
FR11: War Room UI (HQ Stage 3+) displays five panels: Network Graph, Map Overlay, Live News Ticker, Heat Map, Dossier Panel.
FR12: Inner Ring Confidence Indicator updates as evidence accumulates ("Based on current evidence, we believe we've identified [X] of the Inner Ring with [low/medium/high] confidence").
FR13: Analyst recruit (Stage 3+) passively flags potential connections for the player to confirm; may be a Cage-planted Glowie.
FR14: Real-time top-down combat with extreme lethality, instant restart within encounters, and world-state persistence between restarts (broken doors, evidence found, corpses persist).
FR15: Sound design as a weapon — enemy footsteps audible before visible; combat music palette signals threat tier.
FR16: Stats modify combat parameters but never grant invincibility (BODY=hit threshold, Gymmaxx=speed/dodge, Hands=damage/disarm, Ghost Mode=stealth first-strike).
FR17: Capture Mechanic at BODY=0: YIELD (guaranteed capture, GUT check determines intel leak severity) or ATTEMPT ESCAPE (GHOST + Gymmaxx, district Heat penalty on fail).
FR18: Captured player transferred to Cage holding location off-map; escape via sneak/dialogue/contact-broadcast/Dead-Man-Switch.
FR19: Faction Build Counter-System: Xyoner Dossier reads build patterns and dispatches counter-tactics (stealth=thermal sensors; broadcast=2x counter-publication; melee=ranged-only squads; high-publication=pre-emptive misinfo; high-recruit=Glowie-conversion ops).
FR20: Slop heals BODY immediately in combat with no in-moment penalty; cost is Slop Damage (slow-accumulation track) causing long-term BODY/MIND drift, Cope reduction, and visible character art changes.
FR21: Evidence is a physical inventory item seizable on capture; Ghost Protocol skill unlocks encrypted remote backup to survive capture.
FR22: Melee weapons: pipe wrench, baseball bat, crowbar, combat knife, security baton, brass knuckles, chain, hammer, fire extinguisher, skateboard, shovel, broken bottle, heavy book.
FR23: Non-lethal weapons: taser, tranq syringe, tranq dart gun, pepper spray, rubber bullet pistol, smoke grenade, flashbang, sleep gas canister, sedative-laced food, net launcher.
FR24: Ranged lethal weapons (massive Heat): suppressed pistol, standard pistol, shotgun, SMG (seized from Cage), sniper rifle, improvised zip gun.
FR25: Thrown/trap weapons: Molotov, rock/brick, throwing knife, distraction objects.
FR26: Signature Weapons (satirical, tactically distinct): Evidence Brick (USB/dossier; Gnoym stunned 4s, Cage distracted 2s); Slop Bag (Gnoym stunned 6s eating, Cage ignores); Megaphone (chance to hesitate/defect/flee Gnoy-tier; scales with Yap Game + Clout); Signal Jammer (cuts Cage backup 30s); Camera Flash (4s blind cone + Receipts evidence); Fake ID Packet (NPCs verify each other ~10s).
FR27: Combat Engagement Tiers: Routine, Operative, Capture-Op, Boss Phase, Endgame Set-Piece.
FR28: 15 equipment slots: Head, Face, Neck, Shoulders, Chest, Wrist, Hands, Waist, Legs, Feet, Back, Accessory 1, Accessory 2, Main Hand, Off Hand.
FR29: Equipment quality tiers: Gnoy-grade, Standard, Underground, Resistance-crafted, Xyoner-seized.
FR30: Set bonuses: Full Civilian (+3 Normie Cosplay, +2 NPC Mode, +20% Heat decay); Full Tactical (+20% combat dmg, +15% speed, −5 social); Hidden Operator (+10% combat, −1 NPC Mode, weapon-pull from concealment); Press Cover (+3 Receipts, +2 Doxcraft, passes light Cage checkpoints); Underground Standard (+1 Web, +10% underground discount).
FR31: Equipment grants flat attribute bonuses, skill bonuses, Heat modifiers, and unique abilities.
FR32: Day cycle divides into Morning, Afternoon, Evening, optional Night (risky) slots.
FR33: Snooze button costs the morning slot silently (first system lesson in opening sequence).
FR34: Sleeping ends day, partially restores Cope, advances world clock, triggers Politburo Simulation tick, auto-deducts subscriptions.
FR35: Action slots can be spent on Investigation, Publication, Combat/Op, Social, Maintenance, Cover (work shift), or Rest (genuine off-day).
FR36: Quitting the job opens day fully but spikes financial pressure until alt income covers rent (network payments, pirate broadcast monetization, seized Xyoner money).
FR37: Heat is tracked per-district (12 districts) with color-coded HUD (cool blue → orange → red → flashing red).
FR38: Heat sources: public publication, combat ops, subscription cancellations, recruit ops, tail-detection, boss investigation activity, Dead-Man-Switch triggers.
FR39: Heat consequences scale: Cool (standard NPC), Warm (more patrols, civilian stops), Hot (checkpoints, paper-checks), Burning (Cage operations, recruits at risk), Flashing Red (lockdown, presence triggers events).
FR40: Heat decays during downtime slots (cover work, social, rest); district rotation is core mature-gameplay strategy.
FR41: Player Dossier is a single shared faction file (no per-NPC personal memory inside the faction).
FR42: Dossier contents: threat axes (Reach, Awareness, Heat, Embarrassment Caused), build classifier (Ghost/Broadcast/Hands/Grifter/Mixed/Unknown), known associates, known operations, open warrants, suspected aliases, plant flags, last-update timestamp + delay-debt.
FR43: Dossier updates from operative reports, leaks, published evidence, informant reports, and Reputation Web ingestion via Interrogation Bridge.
FR44: OPSEC delay: high-OPSEC players' actions don't register on dossier for several in-game days.
FR45: Politburo Simulation runs whether the player exists or not, with weekly in-game tick rate.
FR46: Politburo contents: 13 Boss Operatives (each w/ power score, faction position, allies/rivals, blackmail debts, current ops, succession status), 5 Faction Hierarchies (Trough/Feed/Pulpit/Cage/Vault), Inner Ring, cross-faction relationships.
FR47: Weekly Politburo Tick outputs 0–3 events (promotions, betrayals, blackmail moves, scandals), updates Network Graph, generates Emergent Politburo Quests.
FR48: Player actions feed Politburo as inputs; eliminating a boss opens succession; next tick shows the simulation's autonomous response.
FR49: Boss operatives can be permanently destroyed; role gets succession-filled by sim; individual is gone forever.
FR50: Player can manipulate internal politics indirectly via false dossiers, leaks to rivals, exploiting Cage-Feed rivalry; outcomes not scripted.
FR51: Reputation Web tracks personal Gnoym memory: quotes (verbatim/paraphrased), rumors heard about player, trust level, recent shared events.
FR52: Gossip propagates through Gnoym at sim tick rate; rumor planted in The Hollow takes weeks to reach The Cubicle Belt.
FR53: Interrogation Bridge: when Cage interrogates a Gnoym the player has spoken with, that Gnoym's personal memory of the player flows verbatim into the Player Dossier.
FR54: Player conversations have real consequence — NPCs quote weeks later, Cage interrogations matter, recruit Loyalty matters even pre-recruit, conversation log is weaponizable.
FR55: Visible-DC / Hidden-Consequence skill check system: player sees "Yap Game (DC 14) — 'Push back on his framing'" but NOT outcome consequences.
FR56: Internal Voices (7 default, 24 total per skill set): Glowie Sense, [X] Fatigue, Lore Depth, Rabbit Hole, Yap Game, NPC Mode, Cope (each color, font, audio cue).
FR57: Internal voice frequency scales with Awakening + Fatigue.
FR58: Each voice has distinct color, font, audio cue (whispered VO when funded).
FR59: Dialogue Skills gate active player-selectable lines: Rizz, Yap Game, Based Talk, NPC Mode, Ratio, Glowie Sense, Lore Depth, Hands.
FR60: Each skill gates 3–5+ paths per goal; different builds reach same conversation goal differently.
FR61: Dialogue-as-Combat boss encounters: Trusted Anchor (multi-stage Composure HP, Yap Game/Ratio/Lore Depth + evidence drops); Debt Dealer (multi-stage, Yap Game + Credibility + evidence-of-debt-trap).
FR62: Composure HP: 3–5 stages, each requires combo (skill check + evidence drop + framing); failure repeats with reduced options; total failure = blown cover + lost evidence + Heat spike.
FR63: Every meaningful conversation recorded for the world: NPCs quote earlier words; Cage interrogates spoken-with Gnoym; Feed weaponizes soundbites at high Heat; recruits remember promises; silence registers as evasion.
FR64: Conversation log is highest-risk performance/storage area; performance validated at vertical slice.
FR65: Item-Drop in Dialogue: drag inventory item into conversation (photo on desk, dossier, burner phone) unlocks lines unavailable without physical evidence.
FR66: Dialogue tiering: 13 Boss full Disco-Elysium treatment; Recruit Personal Quests full for personal arcs; Awakening Beats full at 1/5/10, lighter at 2–9; Reputation Web Side Quests pared; Routine Gnoym minimal/environmental.
FR67: Seven Quest Types in parallel: Main Quest ("The Arrangement"), Faction Boss Investigations (13), Recruit Personal Quests, Emergent Politburo Events, Reputation Web Side Quests, Awakening Track Story Beats, District Liberation Goals.
FR68: Quest Discovery via overheard dialogue, forum posts, recruit intelligence, evidence cross-reference, Politburo broadcasts, random encounters, dead drops.
FR69: Quest Journal is character's own notes (not auto-logged): notebook-style, hand-written font, sketches, filable tabs, evidence cross-linkable.
FR70: Endgame is player-decided: once Inner Ring Confidence is sufficient and disposition axes positioned, player commits.
FR71: Five Endings: Public Reckoning (AWAKE+REBEL high Web), Shadow Replacement (REBEL+PASSIVE), The Burn (AWAKE+REBEL low Web), The Long Game (high SOUL+Web+Touch-Grass), The Sleep (GNOY+PASSIVE).
FR72: No game-over from death in combat — death sends to previous autosave.
FR73: Permanent loss applies to recruits (raids, breaking, defection, voluntary exit) and destroyed operatives (succession-filled).
FR74: Permanent loss applies to published evidence (cannot un-publish; Feed caches it).
FR75: Player can reach effective dead-end by collapsing every variable simultaneously; game does not auto-end (Sleep ending or burnout).
FR76: Seven Attributes (1–10): BODY, MIND, SOUL, MOUTH, GHOST, GUT, SIGNAL.
FR77: Default Wageworker start: BODY 4, MIND 2, SOUL 2, MOUTH 3, GHOST 1, GUT 5, SIGNAL 0 (17 base + distributable); attribute cap 10.
FR78: Derived Stats (7): Credibility, Heat, Awareness, Slop Damage, Reach, Fatigue, Cope.
FR79: Cope mechanics: low Cope spikes voice frequency overwhelming, all checks −2, social = Credibility risk, NPC Mode −3; recovery requires genuine off-day.
FR80: Fatigue Tension: Low (0–25) NPC Mode full, slow recognition; Mid (26–50) NPC Mode −1; High (51–75) instant recognition, NPC Mode −3; Max (76–100) pattern skills +5, NPC Mode −6, "talks crazy" tag spreads.
FR81: Fatigue is a feature; maxed-Fatigue is better investigator, worse operator; player chooses sharp vs sociable.
FR82: 24 Skills (0–10): MIND (Rabbit Hole, [X] Fatigue, Doxcraft, Edit Farm); SOUL (Glowie Sense, Yap Game, Lore Depth, Based Talk); MOUTH (Rizz, NPC Mode, Ratio, Clout); GHOST (Ghost Mode, Normie Cosplay, Receipts, OPSEC); BODY (Gymmaxx, Hands, Anti-Slop, IRL Build); SIGNAL (Web, Ghost Protocol, Sneaky Links, Signal Hijack).
FR83: Two Disposition Axes (emergent, gate ending eligibility): GNOY↔AWAKE, PASSIVE↔REBEL.
FR84: Awakening Track 1–10: each level reshapes perception (sneak routes, readable symbols, NPC awakenings), cinematic at 1/5/10, in-world+monologue at 2–9.
FR85: Music Deterioration: 1–2 clean, 3–4 wrong notes/wobble, 5–6 jingle skips/compression, 7 corruption/dropouts, 8–9 silence-between-glitches, 10 collapse → endgame audio.
FR86: 40 Talents across 7 archetypes (Combat, Stealth/Infiltration, Information Warfare, Network/Social, Awakening, Economy/Resources, Wildcard); some mutually exclusive.
FR87: Talent acquisition: per Awakening level + per faction OBSERVED + every other Skill milestone.
FR88: Organic Recruitment: side quests + in-dialogue puzzles, read the Gnoy, retry with more Credibility/evidence; repeated failure can flag the Gnoy.
FR89: Mission-Based Recruitment: Handler/Analyst recruit points to contact, complete trust-task to unlock.
FR90: Seven Specialist Roles: Researcher, Broadcaster, Crafter, Medic, Quartermaster, Analyst, Handler.
FR91: Recruit Properties: Background, Specialty, Trust Level (0–100), Loyalty, Risk Profile, Breaking Point.
FR92: Recruit Loyalty degrades from neglect (−2/wk no contact), broken promises (−5 to −20), Credibility collapse (all −3), competing offers.
FR93: High-Loyalty harder to turn; Low-Loyalty may defect, feed info, walk out.
FR94: Loyalty maintained via slot-cost during day cycle; Personal Quests are major boosters.
FR95: Permanent recruit loss via Cage raids (capture/kill), recruits can break and feed Dossier verbatim, Stage-4 cell structure limits damage, recruits can be turned into Glowies, OPSEC investment protects relationships.
FR96: Homebase Evolution (4 Stages): Stage 1 Apartment (Awakening 1–2), Stage 2 Office (3–4, cover front), Stage 3 Underground HQ (5–7, war room, broadcast tower, medical bay), Stage 4 Network (8+, distributed cells).
FR97: Stage transitions are major milestones requiring resources, recruits, narrative beats.
FR98: Homebase Diegetic Evolution: ambient sound progression, visual density progression, recruit presence cosmetic NPCs at homebase.
FR99: Dave (Schrödinger's NPC, Greystone coworker) first dialogue choice permanently determines his arc: Default = forever Gnoy; Real = first Recruit (Researcher); Too-awakened = becomes Glowie / Greystone is Cage front.
FR100: Opening Sequence "A Perfectly Normal Morning" locked beats: Alarm/Snooze, Fridge/Slop, Feed/News, Commute/Billboard, Greystone/Dave, The Incident, Evening/Doctored Footage, Forum bookmark.
FR101: Opening silently introduces: time slot system, Slop Damage, financial pressure, dialogue consequences, Receipts, evidence board, Feed-vs-reality, underground forum.
FR102: Opening Sequence is MVP, shippable in Vertical Slice.
FR103: Monthly bills: Rent, SloppFlix, McXyon's DeliverEasy, FeedGram Premium, GnoyGym, FeedBoost Supplements, vehicle insurance, debt servicing.
FR104: Each subscription cancelled = Awakening tick + Feed dossier flag + severance of one Feed-data input.
FR105: Full Gnoy bled dry monthly; Endgame Awakened near-zero recurring expenses.
FR106: Shedding the slop economy IS the awakening, mechanically represented.
FR107: 12 Districts: Tier 1 Major (Slopside, Cubicle Belt, Plaza, Vault District, The Garden); Tier 2 Specialty (Pulpit Quarter, University Row, Slop Belt, Civic Center, The Hollow, The Outskirts); Tier 3 Endgame (The Compound); Hidden (Cage Black Sites, Inner Ring Private Locations).
FR108: Slopside (Trough-saturated): The Strip, Tenements (player apartment), Yards, Free Clinic.
FR109: Cubicle Belt (Cage/mixed): Greystone Data Solutions, Tech Park, Convention Center, Coffee Row; Fact Checker + Revolving Door bosses.
FR110: Plaza (Feed dominant): Broadcast Row, Influencer Mile, Theater District, Press Square; Engagement Architect + Trusted Anchor bosses.
FR111: Vault District: Banker's Mile, Stock Exchange, Debt Court, Crypto Alley; Debt Dealer + Number Go Up Guy bosses.
FR112: The Garden (mixed): Country Club, Private Schools, Operative Estates, Marina, Wellness Centers; most boss residences.
FR113: Pulpit Quarter: Prosperity Prophet + Settlement Ideologue bosses; Annex sub-area = Jihadist Franchise Operator territory (quest-locked).
FR114: University Row: Think Tank Sage boss.
FR115: Slop Belt: Innovation Czar boss.
FR116: Civic Center: Intelligence Artisan boss (cover identity).
FR117: The Hollow: Player HQ, safe houses, dead drops.
FR118: The Outskirts: Soil Baron + estate.
FR119: The Compound: Inner Ring residences, late-game only.
FR120: Cage Black Sites: revealed by investigation, capture/rescue scenarios.
FR121: Inner Ring Private Locations: endgame only.
FR122: Heat tracked per district; rotation is core mature gameplay.
FR123: Traversal options: Walking, Bicycle, Public Bus, Subway, SloppDrive, Personal Vehicle, Sneak Routes (Ghost-gated).
FR124: Sneak Routes visible only after Ghost Mode threshold (Awakening 6 + Ghost Mode 4 baseline).
FR125: Progressive Map UI richer as Awakening rises.
FR126: Toggleable map overlays: Heat heatmap, Cage surveillance points (Glowie Sense/Receipts), sneak routes (Ghost gated), recruit positions, faction operations (Analyst), dead drops.
FR127: THE TROUGH bosses: Innovation Czar (defeated by R&D docs + Cage rivalry); Soil Baron (deed records + displaced-farmer organizing); Revolving Door (paper trail).
FR128: THE FEED bosses: Engagement Architect (Signal Hijack memos); Trusted Anchor (dialogue boss, Based Talk + Rizz); Fact Checker (Doxcraft exposing foundation funding).
FR129: THE PULPIT bosses: Prosperity Prophet (triple-channel exposure); Think Tank Sage (Edit Farm leaking pre-research drafts); Settlement Ideologue (Doxcraft + timed Signal Hijack); Jihadist Franchise Operator (money trail exposure).
FR130: THE CAGE bosses: Intelligence Artisan (physical infiltration → weaponize files); Glowie (detected via Glowie Sense, defeated via false intel + tracking).
FR131: THE VAULT bosses: Benevolent Billionaire (Web + Rabbit Hole, longest evidence chain); Debt Dealer (dialogue boss, Yap Game + Credibility); Number Go Up Guy (only handable to Cage).
FR132: Inner Ring unknown number/identities throughout; "The Arrangement" with redacted names; member fed player info to eliminate rivals.
FR133: Inner Ring size + manipulator identity are open narrative questions (Brief OQs).
FR134: Faction Standing Ladder: UNKNOWN → FLAGGED → OBSERVED → ASSET → COMPROMISED → OWNED.
FR135: Double-cross tests at ASSET+; cross-faction interference; Vault never fully hostile; Cage-Feed pre-existing rivalry mechanic.
FR136: Controls Primary: mouse + keyboard. Default scheme: WASD movement, Shift sprint, Ctrl sneak, E interact, mouse aim, LMB attack, RMB secondary, Q signature, R reload, Space dodge, F camera, I/M/B/J/C/L screens, Esc pause, F5 quick-save, T sleep.
FR137: Combat-mode bindings auto-engage: WASD, mouse aim, LMB, RMB, Space dodge, Q signature, E pickup, F YIELD, Shift ESCAPE.
FR138: Dialogue-mode bindings: number keys 1–9 select skill-gated lines.
FR139: Investigation UI mouse-first: drag-and-drop pinning, hold-to-draw-string for connections, click-to-stamp on Dossier, click-to-process on Thought Cabinet.
FR140: Controller scheme post-prototype with full mappings; radial menus, snap-targeting, context-action button.
FR141: Markers Mode optional pins on map (off by default).
FR142: Combat Difficulty Tuning: Hotline-Miami lethality tunable (encounter-restart only / day-rewind / forgiving-mode).
FR143: Text Sizing & High-Contrast modes required.
FR144: Subtitle / Caption Toggle required.
FR145: Hold vs. Toggle: every hold input has toggle alternative.
FR146: HUD Minimal Default — top-left per-district Heat indicator, top-right day/time slot + date.
FR147: On-demand HUD (button press): Character (C), Evidence board (B), Map (M), Inventory (I), Dossier (J), War Room (Stage 3+).
FR148: Contextual HUD: Dialogue UI (bottom third), skill-check prompts, internal voice overlays, combat BODY indicator, brief evidence notifications, Receipts capture.
FR149: HUD Philosophy: world is information, numbers in menus, HUD does not narrate.
FR150: UI Duality: Xyoner-facing UI = polished corporate app; Resistance-facing = hand-made (sticky notes, photos, red string, CRT terminal).
FR151: Duality itself is satire.
FR152: Save default: autosave at day boundaries + key events; no manual save; consequences stick.
FR153: Optional Ironman: one file, permanent death.
FR154: Day-boundary autosaves worst case = lose one in-game day.
FR155: Encounter restart in combat separate from save state.
FR156: Captured-state save allows escape gameplay reattempt without losing broader save.
FR157: Skill-check experience drives skill levels (0→10); skill use awards XP, level-up awards talent points + bonus.
FR158: Attribute growth via stat-point allocation at milestones and talents.
FR159: Awakening Track is Mythic-Equivalent secondary progression; triggered from in-world events (not grinding); cinematic at 1/5/10.
FR160: Awakening Track is campaign spine (player experience); skill levels are character knowledge.
FR161: Combat Difficulty Curve: VS/Early Awakening 1–3 builds; Mid Faction Counter kicks in; Late 13 bosses + Inner Ring multi-phase; Endgame ending-specific set-pieces.
FR162: Investigation Difficulty Curve: Early single-thread; Mid multi-thread + planted evidence; Late multi-faction Inner Ring + Feed counter-narrative.
FR163: Social/Recruitment Difficulty Curve: Early few Gnoym; Mid 5–10 recruits + Personal Quests; Late distributed cells + Glowie infiltration.
FR164: Money sources: job paycheck, underground market sales, pirate broadcast monetization, network payments, Xyoner money seized.
FR165: Materials & Crafting: IRL Build/Crafter unlocks crafted gear; materials looted/scavenged/purchased/dead-dropped.
FR166: Time is scarcest resource; finite slots/day; economy of slot-spend is primary difficulty lever.
FR167: Skill check infrastructure: attribute + skill + situation modifier vs. visible DC; outcome consequence hidden.
FR168: Equal-Opportunity Satire: ideology/behavior, not faith/ethnicity; Pulpit multi-faith, Vault/Cage ecumenical, Xyoners fictional.
FR169: Writing volume Disco-Elysium-tier (target ~80–120k for solo-ship per Brief; 300k+ for full team scaling).
FR170: Main Quest "The Arrangement" loose Inner Ring investigation, no timer, no markers.
FR171: Visual Style Satirical Hyper-Realism: Xyoner oversaturated/cheerful, Slopside/Hollow desaturated/grimy.
FR172: Contrast IS art direction; neighborhoods read by palette before text.
FR173: As Awakening rises, visual filter shift makes cheerful read as WRONG.
FR174: Format: pixel art OR hand-drawn 2D sprites (not 3D); top-down Pokémon/Zelda camera.
FR175: Audio Style Layered by Context: Gnoy daily, Slopside, Investigation, Combat, Xyoner, Awakening moments, Endgame.
FR176: Music Deterioration Mechanic Signature: 5 deterioration tiers, multi-version recordings, smooth crossfade.
FR177: Sound as Gameplay: footsteps, pirate signal quality, homebase ambient growth, distinct internal voice VO.
FR178: Accessibility Pairings: subtitles mandatory; sound-cue visual indicators for hearing-impaired.
FR179: Top-down 2D district-based (not open world); detailed bounded streamed transitions.
FR180: Target framerate 60fps minimum on minimum-spec PC.
FR181: Steam Deck Verified target.
FR182: Memory footprint moderate.
FR183: Politburo Simulation tick weekly, coarse-grained, off-thread acceptable.
FR184: Conversation Log retrieval supports thousands of conversations across hundreds of in-game weeks.
FR185: Primary platform PC Steam; secondary Steam Deck Verified, post-launch macOS/Switch; tertiary PS5/Xbox if controller-funded.
FR186: Art Assets locked scope intent: 12 districts (Tier 1 5×4 sub = 20 sub-areas), Tier 2 6 specialty, Tier 3 Compound, hidden, 13 boss arenas, 4-stage homebase, characters (customization, NPCs, recruits, bosses, Reputation-web Gnoym, crowd Gnoym), dual-aesthetic UI, Awakening filter coverage on every Xyoner-space environment.
FR187: Audio Assets locked scope: layered context music, music deterioration (every Xyoner track × 5 tiers), SFX (combat, footsteps, environmental, signature), internal voice VO (7+ roles), boss VO (13), recruit VO TBD, routine NPC minimal/none default.
FR188: Writing Assets: target word budget per scope tier; tooling required pre-scaling; skill-voice templates; tiered dialogue depth.
FR189: Three Tracking Systems must be code-distinct (no per-NPC memory in Player Dossier; Politburo independent of player-action graph; Reputation Web has no faction hierarchy linkage).
FR190: Build Classifier/Tactical Response abstraction: clean separation between dossier classification (input pattern) and faction tactical response (output loadout).
FR191: Conversation Log first-class subsystem with vertical-slice performance validation.
FR192: Save System boundaries: autosave at day-boundary + key event; Ironman alternative.
FR193: Music Deterioration pipeline locked at vertical slice: 5-tier crossfade, multi-version recordings.
FR194: Skill check / dialogue branching infrastructure: visible DC, hidden consequence, internal voice trigger, item-drop, robust dialogue tooling.
FR195: Localization English at launch; localization-readiness designed in from day 1 (string externalization, voice localization-friendliness, UI flex).
FR196: Languages-at-launch decision open.
FR197: Engine selection: GODOT 4.x (locked per architecture).
FR198: Team scope: SOLO DEV + VIBE CODING (locked per project state).
FR199: Legal review of Three Tracking Systems vs. US 10,926,179 required pre-launch, ideally pre-VS.
FR200: Music Deterioration asset pipeline locked at vertical slice: Beatoven.ai tier-1 generation per Xyoner context + per-context offline DSP deterioration recipe producing tier 2–5 files.
FR201: Writing tooling investment required pre-scaling past vertical slice.
FR202: IP-counsel relationship for satirical edge cases (platform certification, region risk).
FR203: Tone calibration playtests for satire required external eyes pre-EA.
FR204: Inner Ring narrative finalization (size + manipulator identity) required before endgame implementation.

### NonFunctional Requirements

NFR1: Platform target PC (Steam) Windows/Linux primary; Steam Deck Verified launch target.
NFR2: 60fps stable on minimum-spec PC (5-year-old mid-range hardware).
NFR3: Steam Deck Verified pipeline mandatory.
NFR4: Memory footprint moderate (not 3D-asset constrained).
NFR5: Top-down 2D pixel art or hand-drawn sprites only (no 3D).
NFR6: Districts bounded with streamed transitions (loading screens acceptable).
NFR7: Politburo Simulation weekly tick <500ms worst-case 100-week save.
NFR8: Conversation Log retrieval <50ms; gossip propagation <2s for 200+ Gnoym.
NFR9: Save/load: day-boundary autosave <3s on min spec; load <5s.
NFR10: Music deterioration crossfade unnoticeable (no jarring transitions).
NFR11: Faction Build Counter classifier rolling-window <100ms; tactical response <500ms.
NFR12: Architecture-level patent differentiation demonstrated in code review.
NFR13: Tutorial without text — >80% playtesters identify silently-introduced systems within 30 minutes post-tutorial.
NFR14: Truth Paradox legibility — >75% post-VS playtesters describe Truth Paradox unprompted within 30 minutes.
NFR15: Build differentiation — >70% playtesters report two playthroughs felt materially different.
NFR16: Schrödinger's NPC awareness — community discussion of Dave outcomes within 30 days EA.
NFR17: Music Deterioration moment — >60% playtesters cite as memorable in post-EA reviews.
NFR18: Replay rate — median player initiates 2+ playthroughs.
NFR19: Sleep ending engagement — >5% completionist players choose/reach Sleep ending; structurally supported without nudging away.
NFR20: Reviews aligned with satirical-CRPG niche (Disco Elysium / Pentiment / Citizen Sleeper tier).
NFR21: Cultural conversation — Music Deterioration + Schrödinger's NPC spawn organic streamer/TikTok/forum content.
NFR22: Satirical tone equal-opportunity targeting ideology/behavior not faith/ethnicity.
NFR23: Marketing includes briefing reviewers on Sleep ending support.
NFR24: 3D rendering and 3D character models out of scope.
NFR25: Open world out of scope (district-based bounded).
NFR26: Live service / always-online out of scope.
NFR27: Multiplayer / co-op out of scope.
NFR28: Romance system as focus out of scope (recruit relationships exist).
NFR29: Procedural district generation out of scope.
NFR30: Deep player customization / character-creation out of scope.
NFR31: Mod support / Steam Workshop at launch out of scope.
NFR32: DLC / expansion at launch out of scope.
NFR33: AAA-scale branching cinematic cutscenes out of scope (only Awakening 1/5/10 + 5 endings).
NFR34: Real-name real-event references out of scope.
NFR35: Voice acting beyond funded scope (design supports text-only).
NFR36: Mobile / tablet ports out of scope.
NFR37: Console launch v1 out of scope.
NFR38: English at launch; localization-readiness day 1.
NFR39: Languages-at-launch decision open.
NFR40: Content rating constraints — satirical framing rules.
NFR41: Vertical Slice → Early Access → Full Launch staging.
NFR42: VS scope: partial Epics 1/2/3/5/6/7-subset/8-Stage1/9-one-district/10-skeleton/11-one-boss/12-full/13-prototype.
NFR43: Three Tracking Systems code-enforced legal distinctness.
NFR44: Tone calibration playtests pre-EA.
NFR45: Inner Ring finalization before endgame implementation.
NFR46: Talent balance numbers finalize architecture/balance pass.
NFR47: Conversation Log performance/storage validated at vertical slice.
NFR48: Music Deterioration pipeline locked at vertical slice.
NFR49: Writing tooling pre-scaling past vertical slice.
NFR50: IP-counsel relationship for satirical edge cases.
NFR51: Ironman default-on/off decision TBD.
NFR52: Combat difficulty default Hotline-Miami lethality (tunable).
NFR53: Markers Mode default state accessibility decision TBD.
NFR54: Engine choice locked: Godot 4.x.
NFR55: Team scope locked: solo dev + vibe coding.
NFR56: Inner Ring "one fed you info all along" beat locked; identity needs writing pre-endgame.
NFR57: Combat lethality tunable (encounter-restart / day-rewind / forgiving).
NFR58: Art direction references: They Live, American Beauty, Don't Look Up, Disco Elysium.
NFR59: Tonal benchmarks: Fallout, They Live, American Beauty, Don't Look Up, Disco Elysium, Cruelty Squad.
NFR60: Writing register: sharp, satirical, funny, Disco-Elysium/Fallout DNA, no exposition dumps.
NFR61: Composition pipeline supports 5-tier deterioration crossfade smooth.
NFR62: Music Deterioration asset pipeline (tier-1 generation + offline DSP recipe) locked at vertical slice.
NFR63: No game-over from combat death; permanent loss only for recruits/published evidence/operatives.
NFR64: Consequence stickiness (no manual save, Ironman one-file permanent).
NFR65: Player-authored system-generated narrative.
NFR66: Build-gated world geography.

### Additional Requirements (Architecture)

#### Engine, Language, Foundation

- **Engine: Godot 4.3 or latest stable 4.x at vertical-slice start.** Pinned for VS; upgrades within 4.x only at major milestones.
- **Primary language: GDScript.** No C# / Mono. No third-party "RPG framework" addons. Approved addons documented in §2.5.
- **Escape valve:** GDExtension (C++ or Rust) for profiler-validated hotspots only (likely candidates: gossip-propagation tick, Conversation Log search index).
- **Platform targets:** PC Windows/Linux native; Steam Deck Verified pipeline; macOS/Switch post-launch.

#### Initial Project Scaffolding (§2.4 — Story 0 of Epic 1)

- `project.godot` configured: Window 1920×1080, viewport stretch `canvas_items`, default texture filter `nearest` (pixel-art-safe; configurable per asset), physics tick 60, audio mix rate 44100.
- Default audio bus layout with the 9 buses listed in §4.3 (Master, Music, Music_Stinger, SFX_World, SFX_Combat, SFX_UI, Voice_Internal, Voice_Dialogue, Ambient).
- All 12 autoload singletons (§4.5) registered and initialized.
- Folder skeleton per §4.1: `art/`, `audio/`, `src/{core,rpg,day_cycle,combat,dialogue,investigation,tracking,audio,world,npcs,ui,opening,quest,recruitment,localization}/`, `tests/`, `tools/`.
- `.gitignore` for Godot + OS clutter.
- Initial Resource schema for `SaveGameV1` (§7.1) with version stamp + round-trip test.
- Steam Deck Verified-ready Linux export preset.

#### 12 Autoload Singletons (§4.5)

1. **Logger** — Structured logging (debug levels, ring buffer, subsystem tags, file rotation).
2. **ProjectConfig** — Build flags, runtime feature toggles.
3. **Balance** — Loaded `balance.tres` exposed read-only (all magic numbers live here).
4. **RNG** — Seeded RNG instances per subsystem (rpg / politburo / dialogue / combat).
5. **SaveSystem** — Save/load, schema version management, migrations.
6. **WorldClock** — In-game time (integer minutes since campaign start), slot/day/week derivation.
7. **RPGCore** — Player attributes, derived stats, skills, talents, dispositions, Awakening Track.
8. **ThemeManager** — Token resolution + Awakening-aware token swap (11 variants per token + "off").
9. **MusicDirector** — Music context, tier crossfade scheduling, Awakening-driven transitions.
10. **DialogueRunner** — Custom GDScript dialogue VM (NOT Dialogic / Yarn / Ink).
11. **EncounterDirector** — Combat encounter snapshots and restart-state management.
12. **EventBus** — Project-wide signal hub for cross-cluster events (subscription_cancelled, awakening_level_changed, day_advanced, faction_standing_changed, etc.).

**Note:** Three Tracking Systems are NOT autoloads — they are members of a single `WorldState` object owned by `SaveSystem`.

#### 7 Subsystem Clusters (§1.3)

- **A. RPG Core** — 7 attrs × 24 skills × 40 talents × 2 disposition axes × 10-level Awakening Track + skill-check engine + derived stats.
- **B. Day-Cycle / Survival** — Slot calendar, snooze, subscriptions, bills, sleep tick, Cope, Fatigue, Politburo input queue.
- **C. Combat (Hotline-Miami)** — Real-time top-down, encounter restart with world-state persistence, capture, faction counter-system.
- **D. Dialogue Runtime** — Custom GDScript VM (visible-DC / hidden-consequence checks, internal voice chorus, item-drop, multi-path, dialogue-as-combat / Composure HP, Conversation Log).
- **E. Investigation UI (3 layers)** — Physical Board (drag-and-connect), Dossier (publication × framing × audience × Credibility/Heat preview), Thought Cabinet (Awakening-driven), War Room (Stage 3+).
- **F. Three Tracking Systems** — Player Dossier (faction file), Politburo Simulation (independent weekly tick), Reputation Web (per-Gnoym memory + Interrogation Bridge) — with legal-distinctness enforcement.
- **G. Audio Pipeline + Music Deterioration** — 5-tier deterioration on every Xyoner-space track, smooth crossfade, sound-as-gameplay, Awakening filter audio coupling.

**Cross-cutting:** Token-driven UI theme system (Xyoner / Resistance) sharing one component grammar + diegetic-scene exception list (Apartment Laptop, War Room, Compound, Endgame Trigger).

#### 12 Locked Architectural Rules (§7.1)

1. Engine: Godot 4.x, GDScript primary. No C# / Mono. No third-party RPG-framework addons.
2. Three Tracking Systems are code-distinct. §5.1 Rules 1–4 non-negotiable. Any `src/tracking/` PR re-reads `src/tracking/README.md`.
3. Politburo Simulation is deterministic + seeded + pure-function. No file I/O, no autoload reads inside the tick.
4. Awakening Filter is event-driven via EventBus. No subsystem reads `RPGCore.awakening_level` directly.
5. Conversation Log is append-only. Feed edits create new annotated entries; never mutate originals.
6. Dialogue VM is the only runtime for dialogue. Composure-HP boss encounters use the same VM; no special-case paths.
7. Music deterioration is multi-version files + crossfade. Tiers 2–5 may be derived offline from tier 1 via a per-context DSP recipe; never apply runtime DSP.
8. Save format is versioned with mandatory migrations. Schema bump without migration = release blocker.
9. Strings go through `tr()`. Raw English literals in UI/dialogue contexts fail the EA-prep build lint.
10. Theme tokens, not hardcoded styles. UI components consume tokens; literals are a code smell.
11. No per-cluster reach-around. Cross-cluster communication routes through `EventBus` or autoload mediators.
12. Player Evidence Dossier ≠ Faction Dossier. Naming distinction is binding.

#### Forbidden Patterns (§7.2)

- Storing per-NPC personal memory inside `src/tracking/player_dossier.gd`.
- Importing from `src/tracking/reputation_web/` into `player_dossier.gd` outside `interrogation_bridge.gd`.
- Reading the player-action graph inside `politburo_sim.gd`.
- Mutating a `ConversationLog` entry after creation.
- Adding a third-party UI library or web-tech-in-engine wrapper.
- Mocking the Politburo simulation in unit tests (test the real function with synthetic inputs and seeds).
- Adding manual save support outside Ironman's existing semantics.
- Hardcoded magic numbers outside `core/balance/balance.tres`.
- `await` chains in the Dialogue VM that block the main thread for >16ms.
- Swallowing errors silently; always log and surface.

#### Three Tracking Systems Legal-Distinctness Contract (§5.1)

**Rule 1:** Player Dossier MUST NOT contain per-NPC memory. It owns only threat axes, build classifier, known associates (recruit ids), known operations, warrants, suspected aliases, plant flags, last-update timestamp, OPSEC delay-debt. Quotes enter only via the Interrogation Bridge as `InterrogationReport` records keyed by report id, not Gnoym identity.

**Rule 2:** Politburo Simulation MUST NOT read player-action graph directly. Reads only previous Politburo state, RNG seed, the queued input list. Inputs are constructed by `EventBus` subscribers that *summarize* relevant player actions for the tick (e.g., `OperativeEliminated(boss_id)`, `EvidencePublished(faction_id, framing_strength)`). Hierarchy would update if the player did nothing.

**Rule 3:** Interrogation Bridge is the ONLY data path from Reputation Web to Player Dossier. Single function `src/tracking/reputation_web/interrogation_bridge.gd`. Called explicitly when an interrogation event resolves. Writes an `InterrogationReport` with the source Gnoym's quoted-back surface form.

**Rule 4:** Standing legal-distinctness README in `src/tracking/README.md`. Every code change in `src/tracking/` reviewed against it. Quotes GDD §Three Tracking Systems verbatim.

**Enforcement:** `# DISTINCTNESS CONTRACT — see §6.1` comment header in `player_dossier.gd` listing the only allowed import; code-review checklist; future static analysis (EA prep).

#### Save System & Determinism (§3.7, §6.1, §3.10, §5.2)

- Custom `SaveGameV{N}` Godot Resources via `ResourceSaver`; `.tres` (text) in dev for diffability, `.res` (binary) in release.
- One save per slot at `user://saves/save_{slot}.res`. Day-boundary autosave at midnight or forced sleep-advance commit. Key-event saves at faction-standing transitions, ending triggers, capture/escape resolution, district transitions.
- Save-corruption handling: "Recover from yesterday's autosave?" UI on load failure.
- Ironman: exactly one file, in-place overwrite, deletion on death, no recovery UI.
- Schema versioning tests in CI (EA prep): each historical version round-trips frozen reference saves.
- RNG autoload per-subsystem (rpg / politburo / dialogue / combat). Politburo determinism: `pure_function(prev_state, input_list, rng_seed) → (new_state, event_list)`. Replay debugging via `tools/replay_politburo.gd`.

#### Performance Budgets (§1.4, §6.3)

| Metric | Budget |
|---|---|
| Frame rate | 60fps stable on 5-yr-old mid-range PC |
| Politburo weekly tick | <500ms worst-case 100-week save |
| Conversation Log retrieval | <50ms any past lookup |
| Gossip propagation tick | <2s for 200+ Gnoym |
| Day-boundary autosave | <3s on min spec |
| Load from save | <5s |
| Per-frame rendering | ~8ms |
| Per-frame combat tick | ~4ms |
| Per-frame AI/NPC | ~2ms |
| Per-frame dialogue VM | <1ms |
| Per-event dialogue node resolve | <50ms |
| HUD-only redraw per-frame | ~2ms |
| Music tier crossfade | 4s default (per-context tunable) |

Profiling gates: VS (synthetic worst-case validation), EA (Steam Deck), Full launch (most-expanded localization).

#### Combat / Physics / Rendering / Dialogue / Music / Clock / Theme / Scene Architecture

- **Combat:** Encounter snapshot at entry; restart restores snapshot; world clock paused during encounter; resolution commits.
- **Physics (D-PHYS-01):** Godot 2D, `CharacterBody2D`/`StaticBody2D`/`Area2D`; no rigid-body sim; `move_and_slide()`; bullets are scripted projectiles via `Area2D`; `NavigationAgent2D` with baked nav regions.
- **Rendering (D-RENDER-01):** 2D Canvas-only, top-down `Camera2D`, pixel-perfect viewport. Awakening Filter = single fragment shader on `CanvasLayer` ColorRect with `awakening_level` + `xyoner_space_intensity` uniforms. Mobile renderer for Steam Deck.
- **Dialogue (D-DIALOG-01):** Custom GDScript VM. Node types: Line, Choice, SkillCheck, InternalVoice, ItemDrop, Branch, SystemEffect, Commit, End. `DialogueRunner` autoload. Composure-HP encounters use same VM. Internal voices scale by Awakening + Fatigue, capped per dialogue. Authoring: hand-authored `.tres` at VS; YAML→tres importer mandatory pre-EA.
- **Music (D-AUDIO-01):** 5-tier multi-version recordings + runtime crossfade between tier players. 9 audio buses. Two `AudioStreamPlayer` instances per Xyoner-space context (tier-N, tier-N+1). Crossfade default 4s, per-context-tunable. Sample at scene-load + every 30s; threshold crossings deferred to scene transitions or natural loop boundaries unless boundary >60s away. Slopside/Hollow do not deteriorate. Combat music = separate stem-and-layer.
- **WorldClock (D-CLOCK-01):** Single autoload; integer minutes since campaign start. Slot/day/week derived. Politburo ticks at week boundaries. Sleep is the only player-driven time-jump.
- **Theme (D-THEME-01):** Two themes (Xyoner / Resistance) sharing one component grammar + diegetic exceptions. Tokens (color, type size, spacing, border radius, animation duration) in `src/ui/theme/tokens.gd` typed dict. 11 Awakening variants per token + "off". Awakening Filter is a token state. Music-deterioration-equivalent UI glitching at high Awakening = token state. Diegetic exceptions: Apartment Laptop, War Room, Compound, Endgame Trigger.
- **Scenes (§4.3):** One scene per logical concern. No god scenes. Signals or autoload calls only — no parent-pointer chains.

#### Accessibility (§6.6 — minimum bar)

- Subtitles on by default (mandatory; stealth is partly audio).
- Footstep visual indicators option.
- Markers Mode toggle (default off).
- Color-blind safe palettes (Heat color has shape/position redundancy).
- Text scale 1× / 1.25× / 1.5×.
- Reduced motion option (turns off filter shimmer, glitch UI, particle-heavy effects).
- Rebindable input every action; Publication Commit two-step re-bindable but cannot be one-button-locked.
- Combat: Hotline-Miami baseline + "More Forgiving" tier.

#### Testing & CI

- Unit tests (GUT): RPG core math, save round-trip, Politburo determinism, dialogue VM resolution, theme token resolution, music tier crossfade math.
- Integration tests: subscription-cancellation event chain, evidence-publication ripple, encounter restart preserves world state, Schrödinger NPC role-lock.
- Determinism tests are CI-gated: Politburo non-determinism = release blocker.
- Manual playtest plan at VS and EA.
- No tests required for purely visual/audio polish (playtest-reviewed).

#### Asset Pipeline

- Sprites in Aseprite (or hand-drawn tool TBD). `nearest` filter for pixel art.
- Audio: music as `.ogg` per tier; SFX as `.wav`. Loop points baked at composer side or in Godot Import settings.
- Dialogue: YAML in `dialogue_source/`, compiled to `.tres` at import time by `tools/dialogue_yaml_to_tres.gd`. Writers never edit `.tres`.
- Localization: CSV-based via Godot's translation, PO export for translators. `tr()` mandatory; `tools/string_lint.gd` fails build if raw English literals found in UI/dialogue contexts (EA prep).
- Asset budget tracking automated tool reports against scope-tier budget targets (EA prep).

#### Novel Systems (Custom Architecture Required)

Three Tracking Systems triad; Music Deterioration tier system; Awakening Filter (visual + audio + UI theme + dialogue coupling); Connection Draw skill-check on Physical Board; Publication Commit framing matrix with live Credibility/Heat preview; Conversation Log as live system; Schrödinger's NPC system (Dave); Subscription cancellation as cross-system event; Diegetic UI scenes.

### UX Design Requirements

UX-DR1: **Xyoner color palette** — 10 color tokens (McXyon's Red `#E8302F`, Trough Yellow `#FFC629`, Wellness Green `#00B488`, Vault Blue `#1F8FFF`, Engagement Orange `#FF7A00`, white bg, elevated surface `#F5F7FA`, text primary `#1A1A1A`, text secondary `#6B7280`, white-on-brand text), each at WCAG AA contrast (4.5:1 body, 3:1 large).
UX-DR2: **Resistance color palette** — 8 color tokens (Faded Marker Red `#C2362B`, Sticky-Note Mustard `#9C8A4A`, Aged Paper `#EFE7D6`, Typewriter Black `#1B1A18`, Pencil Gray `#4A4A48`, Hollow Concrete `#2A2826`, Resistance Alert Red `#B23A2F`, Pirate-Signal Green `#5C7A4F`), WCAG AA with aged-paper texture overlay.
UX-DR3: **Awakening Filter post-process layer** — Saturation desaturation curve across 10 levels (0–4 1.00×, 5 0.92×, 6 0.85×, 7 0.78×, 8 0.70×, 9 0.62×, 10 0.55×; Compound interior exception at 1.00×); crossfade <2s per tier crossing.
UX-DR4: **Xyoner typography stack** — Geometric sans (Inter Display / GT Walsheim / Aeonik equivalent): Display 32–64px, Heading 20–28px, Body 14–16px LH 1.5, Caption 11–13px LH 1.4 + tabular-figures variant.
UX-DR5: **Resistance typography stack** — Pasted-up display 28–48px, Courier Prime heading 18–24px, typewriter mono body 14–16px LH 1.6, marker handwritten annotations 14–18px, caption typewriter 11–13px.
UX-DR6: **Inner Voice typography system** — 24 distinct voice identities, each with font / weight / color tint / style register (Italic / Caps / Underline / Tracked / Strikethrough / Whisper / Compressed). Voices: Rabbit Hole, [X] Fatigue, Doxcraft, Glowie Sense, Yap Game, Lore Depth, Based Talk, Rizz, NPC Mode, Ratio, Clout, Ghost Mode, Normie Cosplay, Receipts, OPSEC, Gymmaxx, Hands, Anti-Slop, IRL Build, Web, Ghost Protocol, Sneaky Links, Signal Hijack, Edit Farm.
UX-DR7: **Spacing/layout foundation** — 4px base grid; 4/8/12/16/24/32/48/64/96 increments; body max ~70 chars/line; no reflow 1080p→1440p; Steam Deck compact ≤1366px; ultrawide ≥2560px centers max-width.
UX-DR8: **Motion/transition tokens** — Skill check anim <200ms; Music Deterioration crossfade <2s; stamp animations (typewriter/Polaroid/wax-seal) on commit; Awakening Filter shift <2s; no smooth transitions on Resistance surfaces (jumps); no tooltip delays.
UX-DR9: **Sound design tokens** — 5-tier seamless multi-version music crossfade; McXyon's jingle at each Awakening milestone; Cage alarm sound at heat spikes; pirate-broadcast on-air tone; no UI SFX for normal interactions (sound = diegetic).
UX-DR10: **Button (primary)** — Filled rounded-rect Xyoner, pasted-tape with marker stroke Resistance. 40px+ Steam Deck min. States: default/hover/active/disabled. Critical actions paired with two-step confirm.
UX-DR11: **Button (secondary)** — Outlined Xyoner, sticky-note typewriter Resistance.
UX-DR12: **Button (tertiary/quiet)** — Text-only `xy-text-secondary` Xyoner, pencil-stroke Resistance.
UX-DR13: **IconButton** — Circular icon Xyoner, marker-stroke bordered Resistance. 40px+ touch target. Tooltip on hover.
UX-DR14: **Panel** — Card with drop-shadow Xyoner, paper-stack with irregular borders Resistance.
UX-DR15: **Modal** — Centered overlay Xyoner, pinned-corkboard Resistance. Restricted to settings, save/load, quit, two-step commits only.
UX-DR16: **List** — Vertical/horizontal collection. Xyoner sleek dividers; Resistance index-card-stack with irregular edges. Keyboard-navigable + empty state.
UX-DR17: **TextBlock** — Body container, theme-styled, color from palette.
UX-DR18: **Heading** — H1–H4 hierarchy. Xyoner display sans 20–64px, Resistance pasted-up 18–48px. Never skip levels.
UX-DR19: **Tooltip** — Xyoner rounded popover; Resistance sticky-note hand-drawn. 300ms hover delay.
UX-DR20: **Slider** — Xyoner smooth filled track, Resistance graph-paper hashmarks. Keyboard arrow accessible.
UX-DR21: **Checkbox** — Xyoner filled + check; Resistance hand-drawn check in circle. Screen-reader explicit checked state.
UX-DR22: **Dropdown** — Xyoner native; Resistance rolodex-flip animation. Keyboard accessible.
UX-DR23: **TextInput** — Xyoner clean field, Resistance typewriter-platen.
UX-DR24: **TextArea** — Xyoner bordered, Resistance legal-pad ruled lines. Auto-save where appropriate.
UX-DR25: **ProgressBar** — Xyoner filled gradient, Resistance hashmark. Horizontal/vertical.
UX-DR26: **Tabs** — Xyoner pill+underline, Resistance hand-labeled index-card stack. Keyboard arrow + Enter.
UX-DR27: **StatPip** — Tiny status indicator. 4-cluster (Cope/Fatigue/Heat/Slop) bottom-left. Grows louder as Cope drops. States: tiny/grown/pulsing/critical. Each pip has shape + position + color + hover-text.
UX-DR28: **DialogPortrait** — NPC: 200×200 portrait + name + faction sigil. Inner Voice: typography-only with color tint + font weight. Right-aligned.
UX-DR29: **SkillCheckBadge** — Skill name + DC + outcome stamp (Verified / Probable / Uncertain / Fail). Animates in <200ms at connection midpoint or inline in dialog.
UX-DR30: **EvidenceCard** — Polaroid + typewriter caption + stamp. States: default/hover/pinned/connected/faded. Variants: photo, document, audio (waveform+transcript), forum-thread. Keyboard nav + click-source-then-target alternative to drag.
UX-DR31: **ConnectionString** — Red bezier between cards. States: in-progress / Verified solid / Probable dashed / Uncertain thin. Skill-check badge at midpoint.
UX-DR32: **InnerVoiceLine** — Voice-name + voice-styled body + optional action prompt. States: quiet (Awakening 1–2) / interjecting (3–5) / chorus (6–8) / full-chorus (9–10). All 24 voices rendered with their typography spec.
UX-DR33: **DialogChoice** — Selectable text + optional `[Skill X/Y]` + item-required tag + disposition tag. States: default/hover/selected/disabled/locked. Tab to swap focus.
UX-DR34: **PublicationFramingMatrix** — Three column-selectors (Platform / Framing / Audience) + live Credibility delta + Heat delta + Faction Standing deltas + Inner Voice slot + commit button. Real-time meters. States: configuring/previewing/committing/committed.
UX-DR35: **DossierEntry** — Header (date/source) + body + optional evidence link. States: new/read/archived. Variants: Faction-sourced / Mole-sourced / interrogation-sourced.
UX-DR36: **ConversationLogEntry** — NPC name + timestamp + player's exact line + optional annotation flag (quoted-back-by, weaponized-by). Searchable full-text.
UX-DR37: **DaySlotHUD** — Day# + DOW + 4-slot indicator (Morning/Afternoon/Evening/Night) with current highlighted. States: active/consumed/pending/urgent. Variants: Xyoner calendar widget / Resistance chore-wheel.
UX-DR38: **StatusPipCluster** — Bottom-left HUD with 4 pips (Cope brain, Fatigue lightning, Heat thermometer, Slop stomach). Hover-text accessible. Grows/shrinks with Cope state.
UX-DR39: **MusicDeteriorationIndicator** — Optional accessibility component (off by default) showing tier 1–5 for hearing-impaired.
UX-DR40: **BillsScreen** — Subscription list + per-sub detail (cost, last-used, retention metrics) + Cancel → retention dialog stages 1–3 → confirmation stamp. Post-cancel: Awakening tick + Feed flag + "anti-subscription extremism" Feed segment within 1 in-game hour.
UX-DR41: **WarRoomGrid** — Stage 3+ tabbed grid: network graph, map overlay, news ticker, dossier panel. Full at EA; VS stub only.
UX-DR42: **Persistent ambient HUD (Direction 3+6)** — Always-visible multi-cluster: bottom-left StatusPips, top-right DaySlotHUD, bottom-right contextual action prompt. HUD itself awakens — token swaps on Awakening thresholds glitch/desaturate Xyoner HUD elements.
UX-DR43: **Heat indicator** — Real-time per-district threat (0–100). Top-right HUD. Updates on publication, combat, NPC reports, raid. Visual spike anim on rapid changes.
UX-DR44: **Fatigue indicator** — 0–100 bottom-left pip. Grows with activity, resets at sleep. Affects DCs.
UX-DR45: **Cope indicator** — 0–100 brain pip. Drops on NPC Mode / contradiction / failed checks / music deterioration / subscription cancel. Drives Inner Voice chorus.
UX-DR46: **Slop Damage indicator** — 0–100 stomach pip. Accumulates from low-quality slop. Reduces max BODY.
UX-DR47: **Awakening Level indicator** — NOT displayed as number; surfaced via music deterioration tier, palette, Resistance HUD elements, voice chorus. No "Awakening +1!" toasts.
UX-DR48: **Day/Time slot indicator** — Top-right HUD, 4 slots, current highlighted, faction sigil for scheduled events.
UX-DR49: **Location indicator** — Current district name top-right; Xyoner name on Xyoner UI, Resistance name on Resistance UI.
UX-DR50: **Signal indicator** — Broadcaster recruit VU-meter style top-right when Signal Hijack active. Green on-air tally light.
UX-DR51: **Contextual action prompt** — Bottom-right dynamic text (`[E] to search`, etc.). Theme-styled.
UX-DR52: **Title Screen / Main Menu** — Play New / Continue / Load / Settings / Quit. Xyoner-styled with McXyon's branding. Tutorial onboarding gate (settings before play; Markers Mode default off; accessibility visible).
UX-DR53: **Character Sheet / Player Stats screen** — Tabs: Build (24-skill grid 1–5), Equipment (15-slot paper-doll), Status (Cope/Fatigue/Heat/Slop/Awakening as prose), Perks (unlocked build-gating).
UX-DR54: **Inventory / Equipment Screen** — 15-slot paper-doll. Xyoner sleek mock-up; Resistance hand-drawn outline. Right-click remove, left-click detail. Keyboard nav.
UX-DR55: **Skill Tree / Build Progression Screen** — 24 skills in spatial node grid (not tier list). Visual prereqs as connected lines. Inner Voice tooltip per skill on hover. Both theme variants.
UX-DR56: **Dialogue Interface** — Left: NPC portrait + name + faction sigil + relationship callout. Right: dialogue text (~70 char/line) + Inner Voice chorus (0–5 voices) + choice list. Visible-DC tags on choices.
UX-DR57: **Conversation Log / Chat History** — Diegetic via Apartment Laptop. Full-text search, sort by date/NPC/location. Flagged lines: "quoted-back-by" (red) / "weaponized-by Cage" (red+bold). Copy-to-clipboard per line. Opens silently.
UX-DR58: **Quest Journal / Notes** — Character's prose notes (not checklist). Sections: Threads / Cold Cases / Personal Notes / NPCs. Searchable. Xyoner clean digital notes vs Resistance handwritten journal w/ margin annotations.
UX-DR59: **World Map / Navigation Map** — M to toggle. Top-down district map, player marker, known-location pins, Markers Mode pins (default off), Heat heatmap overlay. Arrow keys pan, Esc close. No fast-travel.
UX-DR60: **Physical Board / Investigation Scene** — Diegetic Apartment scene. Cork board with EvidenceCards. Drag or click-source-then-target. Skill checks <200ms. Empty state Resistance handwritten note. "Prepare for Publication" routes to Dossier.
UX-DR61: **Dossier Interface / Publication Scene** — Diegetic desk scene from Physical Board. Center: PublicationFramingMatrix. Two-step confirm → typewriter-stamp animation. No undo.
UX-DR62: **Thought Cabinet / Rumination Interface** — Diegetic Apartment scene. Vertical slot list with Inner Voice thoughts + skill-check challenges. Persistent across days. High-Awakening reveals bracketed addenda `[At Awakening 5+: This might mean...]`.
UX-DR63: **War Room / HQ Stage 3+ Command Center** — Diegetic Underground HQ. Tabbed grid: network graph (drag-zoom), map overlay (Heat+control), news ticker, dossier panel. EA full; VS stub.
UX-DR64: **Underground Forum Interface** — Diegetic Apartment Laptop bookmark. Subforum tree + thread list + thread content. User-card on hover. Search top-right. Xyoner clean modern; Resistance early-2000s phpBB.
UX-DR65: **Apartment Laptop / Terminal Interface** — Desktop metaphor: taskbar (Conversation Log, Quest Journal, Forum, Settings, Email) + background. Apps fullscreen on click. Alt-Tab between.
UX-DR66: **Greystone Intranet / Corporate Workspace** — Diegetic Greystone office scene. Employee directory, work-list, payroll, memos, surveillance-alert inbox. Deliberately bloated (IRS-portal density) as satire.
UX-DR67: **McXyon's Ordering / Slop Delivery UI** — Diegetic in-world / phone app. 3-tap reorder favorites. Loyalty points display. Promo banner stack. DoorDash playbook.
UX-DR68: **Bills Screen / Subscription Management** — See UX-DR40.
UX-DR69: **Vault Account / Banking Interface** — Diegetic phone/laptop. Balance, transactions, loan products, insurance offerings. Robinhood/Chase aesthetic.
UX-DR70: **Settings / Options Menu** — Categories: Audio, Video, Controls, Accessibility, Game.
UX-DR71: **Accessibility Settings Panel** — Subpanel of Settings. Shipped at VS even if toggles wired later. Hold-to-Confirm, Click-Source-Then-Target, Auto-Restart, Combat Difficulty, Markers Mode, Awakening Hints, Dyslexia Font, Color-Blindness Simulator (deuter/protan/tritan/achroma), Subtitle Size, Subtitle Contrast, Music Deterioration Visual Indicator.
UX-DR72: **Pause Menu** — Esc overlay (not in active combat). Resume/Settings/Save/Load/Quit-to-Menu/Quit-to-Desktop. Two-column with keylist.
UX-DR73: **Save/Load Interface** — Slot list with thumbnails, play-time, character, Awakening level, day#. No manual save after Endgame Trigger.
UX-DR74: **Death / Restart Screen** — "You Died" + Restart Encounter [R] / Load Last Save [L] / Quit [Q]. Restart loop ≤0.5s.
UX-DR75: **Intro Cinematic UI** — Skip top-right, optional subtitles bottom-center. No HUD during cinematic.
UX-DR76: **Ending Cinematic UI / Coda Screens** — 5 endings (Public Reckoning / Shadow Replacement / Burn / Long Game / Sleep). Coda + epilogue narration + credits. Sleep ending: McXyon's jingle restored undeteriorated + palette resaturated.
UX-DR77: **Faction Standing / Reputation Screen** — 5-faction ladder (Trough/Feed/Pulpit/Cage/Vault) qualitative states (UNKNOWN/FLAGGED/OBSERVED/ASSET/COMPROMISED/OWNED) — visual ladder, not numeric counters. Upcoming events listed per faction.
UX-DR78: **Quest Journal / Case Log Screen** — See UX-DR58. Threads vs Cold Cases separation prevents "missing content" frustration.
UX-DR79: **NPC / Recruit Management Screen** — Roster: portraits + relationship state + location + last-seen + gifts/assignments/loyalty visual + status (alive/captured/defected/fled).
UX-DR80: **Xyoner personality menu transitions** — Smooth ease-out (cubic-bezier), 300–400ms. Slide-in right, fade-in overlays, stagger-entry McXyon branding. Applied to: Settings, Save/Load, Pause, Character Sheet, Faction Standing.
UX-DR81: **Resistance personality menu transitions** — No easing; jump/snap, instant or 1-frame. Sticky-note flip-out, pasted-tape edges, pencil-line draw. Applied to: Physical Board, Dossier, Thought Cabinet, Conversation Log, Quest Journal, War Room.
UX-DR82: **Publication commit ceremony** — Multi-stage typewriter-stamp: typewriter clatter sound → "PUBLISHED" types char-by-char → stamp fade-in + 5° rotation → return to Physical Board. 2–3s total.
UX-DR83: **Subscription cancellation ritual** — 3-stage retention dialog (20% discount → tell-us-why → match competitor). Artificial 2–3s loading spinner (satire). Cancellation stamp animates. Inner Voice "There it is."
UX-DR84: **Music Deterioration visual mirror** — 5 tiers mirror in HUD: T1 pure / T2 color-fringe / T3 scanlines / T4 channel-separation / T5 heavy glitch + 0.55× saturation.
UX-DR85: **Combat HUD appearance / disappearance** — Slides in from left (300ms) on encounter, slides back on victory/restart. Persistent HUD (status pips, day-slot) never hidden.
UX-DR86: **Inner Voice typography flourish moments** — First-time voice speak: 2× scale + subtle glow, 400ms. Subsequent normal scale. All 24 voices introduced by Awakening 3.
UX-DR87: **Awakening Filter visual transition** — Smooth post-process curve <2s per tier crossing. Subtle audio cue + one-time Inner Voice "There it is." per crossing.
UX-DR88: **Evidence stamp system** — 3 stamps for Physical Board: Verified (Polaroid green border + check, bounce, tilt 5°) / Probable (dashed border, yellow/orange, slight tilt) / Uncertain (thin border, grayscale, flat). Same stamp grammar reused for subscription/publication/thought completion.
UX-DR89: **Faction event escalation animations** — Day-slot HUD pulse 2–3 beats + faction sigil badge. Cage raid incoming = intensifies + alarm tone (diegetic). Non-blocking.
UX-DR90: **Dialog branch path memory visualization** — Thought Cabinet shows traveled branches (highlighted) vs unexplored (dimmed 30% opacity). No popup.
UX-DR91: **HUD softening / hardening with Awakening** — 1–2 clean Xyoner polish; 3–5 small glitches; 7–10 active corruption (scanlines, channel separation, jitter). Resistance HUD stable but desaturates in parallel.
UX-DR92: **Color desaturation curve across Awakening filter** — Per UX-DR3.
UX-DR93: **Music Deterioration as Awakening milestone feedback** — At Awakening 2/4/6/8/10, music crossfades to degraded version. No notification. Possible Inner Voice "There it is."
UX-DR94: **Marker-mode activation at high Awakening** — Optional Markers Mode (off default) becomes useful at high Awakening; player discovers in settings — no UI suggests "you can now turn on markers."
UX-DR95: **Internal Voice rendering intensity scaling** — Awakening 1–2 + high Cope: 1 quiet supportive voice. Awakening 7–10 + low Cope: 5+ voices loud, contradictory, overlapping. Typography-only (size/weight/color/opacity).
UX-DR96: **Build-gated world legibility surfaces silently** — Skill rises → new dialogue lines, sneak routes on map, Xyoner symbols readable. No "you can now see X" toasts. Surfaced via journal hint, Inner Voice, NPC dialogue ("I thought you couldn't read that").
UX-DR97: **Resistance HUD elements appearance at high Awakening** — Awakening 5+ Resistance UI elements appear in homebase HUD; 8+ Resistance default across all non-Xyoner scenes.
UX-DR98: **NPC look-through / recognition at high Awakening** — Awakening 6+ "NPC Mode" cheerful scripts add slight hesitation; 8+ explicit weariness ("(sigh) Oh, it's you").
UX-DR99: **Conversation log darkening / weaponization feedback** — Awakening 6+ retroactive "quoted-back-by Cage" annotations on archived lines; 8+ adds "evidence in interrogation." Visual highlight (red bg) + tone shift.
UX-DR100: **Color contrast minimums across both palettes** — All text/bg pairs WCAG 2.1 AA: 4.5:1 body, 3:1 large/UI. Awakening Filter desaturation does not pull UI text contrast below threshold.
UX-DR101: **Color-blindness accessible cues (status pips)** — All status indicators carry: shape uniqueness, fixed position order, fill-level, hover/long-press text. Tested vs deuter/protan/tritan/achromatopsia.
UX-DR102: **Text scaling accessibility** — 100/125/150/200% via Settings. Layouts reflow without clipping. Tested 1080p, 1280×800 (Steam Deck), 1440p.
UX-DR103: **Dyslexia-friendly font option** — OpenDyslexic-equivalent toggle (default off). Applies to Resistance body; Inner Voices retain per-voice typography for identifiability.
UX-DR104: **Subtitles and captions for voice-acted content** — All voice-acted boss + key NPC dialogue toggle-able subtitles centered bottom + speaker name. Subtitle size (normal/125/150) + contrast options.
UX-DR105: **Music Deterioration visual indicator for hearing-impaired** — Settings toggle (default off). Tiny 30×30px corner icon showing tier 1–5.
UX-DR106: **Hold-to-confirm option for commit screens** — Settings toggle (default off). Buttons marked irreversible (Publish / Cancel Subscription / Trigger Endgame / Break Loyalty / destructive Load) → hold 2s with progress fill.
UX-DR107: **Motor accessibility — click-source-then-target alternative to drag** — Settings toggle (default off). Replaces Physical Board drag with two-tap. Keyboard alt: Tab + arrows + Enter.
UX-DR108: **Combat difficulty / auto-restart accessibility** — Settings: Combat Difficulty (Lethal/Balanced/Forgiving), Auto-Restart on Death toggle (default on), configurable restart key. Preserves <0.5s loop.
UX-DR109: **Optional Markers Mode (objectives overlay)** — Settings toggle (default off). Pins for currently pursued threads, labeled by name not generic.
UX-DR110: **Awakening Hints mode for navigation-impaired play** — Settings toggle (default off). Quiet corner indicator after 2+ slots in district without major progress. Quest Journal "Hints available" subsection — directional, not spoiler.
UX-DR111: **Keyboard navigation across all UI screens** — Tab/Shift+Tab, arrow keys, Enter, Escape, Space throughout. No mouse-only screens.
UX-DR112: **Screen-reader compatibility (navigation layer)** — ARIA-labels, semantic hierarchy, status-pip combined voice description, Inner-Voice prefix, Conversation Log full-row read. Complex scenes (Physical Board, Dossier, War Room) have screen-reader tour mode (skipable). NVDA/JAWS tested.
UX-DR113: **Steam Deck controller scheme (deferred, required for Verified)** — Mouse+keyboard parity: D-pad/stick, A/B confirm/cancel, RT action, menu button = Esc. Touch-screen support in docked mode. Drag → trigger-hold-and-move pattern.
UX-DR114: **Full input remapping** — Settings > Controls > Keyboard. Every action rebindable. Conflicts flagged. Reset to default + Clear All. Controller remapping same pattern (deferred).
UX-DR115: **Pause-anywhere design (except active combat)** — Esc pauses except in real-time combat. Investigation suite pause not needed (investigation IS the slot spend). Dialogue allows pause.
UX-DR116: **Audio mix settings** — Master/Music/SFX/Voice 0–100, subtitles toggle, subtitle size (normal/125/150), Music Deterioration Visual Indicator toggle.
UX-DR117: **Marker toggles + difficulty flags** — Markers Mode toggle, Awakening Hints toggle, Combat Difficulty slider, Auto-Restart toggle.
UX-DR118: **Ironman mode toggle** — Default off. "Warning: Permanent mode" + secondary confirm before activation.
UX-DR119: **Language / Localization option** — English at launch. UI authored to support text +30% expansion. Font fallback documented.
UX-DR120: **Display / Video settings** — Text Scale 100/125/150/200, Brightness, Sharpness toggle, Fullscreen/Windowed, Resolution selector, Frame Rate Cap (uncapped/60/120/variable).
UX-DR121: **Control scheme / input rebinding** — Per UX-DR114. Conflicts flagged. Reset / Clear All.
UX-DR122: **Xyoner-app personality rule (non-diegetic UI)** — Xyoner-controlled scenes (Greystone, McXyon, Trough HQ, Apartment TV Feed, Vault, Banks) render as apps on devices. Rounded corners, sans, bright primary, smooth transitions, corporate branding.
UX-DR123: **Resistance-handmade personality rule (diegetic UI)** — Player-controlled homebase / Physical Board / Dossier / Thought Cabinet / War Room render as the physical world itself. Irregular borders, typewriter, paper textures, hand-drawn accents, no smooth transitions.
UX-DR124: **Engine-system UI (neutral)** — Pause, Settings, Save/Load, Quit confirm, loading screens use minimal neutral voice. Pause inherits last-active scene's personality; engine systems stay neutral.
UX-DR125: **Scene-as-screen rule** — Major surfaces (Apartment Laptop, Physical Board, Dossier, War Room, Compound entry, Endgame Trigger) are scenes, not modals. Diegetic entry/exit. World clock paused. Documented exceptions: Thought Cabinet + Conversation Log run on Apartment Laptop (nested diegesis).
UX-DR126: **Diegetic feedback over system popups** — No "Achievement Unlocked!" toasts, "Quest Complete!" announcements, "Skill Up!" badges. All progression diegetic: Awakening = Inner Voice line, faction shifts = NPC behavior, Music Deterioration = audio, build-gated legibility = new dialogue/map, recruits = diegetic knock or forum post.
UX-DR127: **Conversation log as found artifact** — Not a UI system; a diegetic artifact found on the Apartment Laptop. Searchable archive of chat transcripts. Late game reads as a weapon ("weaponized-by Cage", interrogations use exact lines).
UX-DR128: **Menu transition system (Xyoner)** — Smooth ease-out cubic-bezier ~0.34/1.56/0.64/1, 300–400ms. Fade-in overlay, slide-in from right, button entrance fade+scale 0.8→1.0. Stagger 50ms per element on McXyon branding.
UX-DR129: **Menu transition system (Resistance)** — No easing; instant or 1-frame pop. Sticky-note flip 90→0deg, pasted-tape edges 2–3 frames, pencil-line draw 100–200ms. No fade-ins.
UX-DR130: **Skill check animation system** — Skill portrait + DC badge at midpoint: scale 0.5→1.0 (100ms), dice-roll number flip 50ms × 3–4 flips, outcome stamp fades + rotates (Verified +5°, Probable 0°, Uncertain −5°). <200ms total. Sound: dice rattle + stamp press.
UX-DR131: **Stamp animations (commit feedback)** — 4 stamp types: Connection Verified (Polaroid green) / Publication Typewriter (PUBLISHED types out) / Subscription Cancelled (date-stamp) / Thought Research Complete (wax-seal). All share scale/rotation entrance, shadow, brief sound. 300–500ms.
UX-DR132: **Loading state diegesis** — No engine spinners. Diegetic: typewriter cursor pulse, paper-stack shuffle, dial-up modem stutter, Vault loading bar, McXyon's "preparing" timer. Subscription cancellation = artificial 2–3s satire delay.
UX-DR133: **Awakening Filter desaturation curve** — Smooth post-process saturation curve <2s per tier. No abrupt jump. Brief audio cue (200ms) + optional Inner Voice "There it is." on each crossing, never repeated on return.
UX-DR134: **Music crossfade at Deterioration tiers** — On Awakening 2/4/6/8/10, music crossfades <2s to corresponding deterioration version. Visual mirror synchronized with audio.
UX-DR135: **Status pip pulse animations** — Cope drops rapidly = pulse (300ms × 2–3). Same for Fatigue/Heat/Slop spikes. Visual alert without audio/text.
UX-DR136: **Dialog choice highlight / selection animation** — Hover = 25% color overlay (100ms fade-in). Select = scale 1.0→1.05 (100ms) + fade-out (100ms). No instant disappear.
UX-DR137: **Dialogue portrait micro-animations** — Mouth shifts 2–3px at inflection points (every 1–2 sentences); blink animation (50ms close+open) every 3–5s. No full-body anim.
UX-DR138: **Mouse + keyboard primary input scheme** — Native input. Click-based, drag-based, keyboard shortcuts. Controller is adaptation layer (deferred post-VS).
UX-DR139: **Keyboard navigation and shortcuts** — Tab/Shift+Tab/arrows/Enter/Esc/Space + R restart, M map, P pause, S save. Listed in Settings > Controls. Global (no context-dependent binds). Rebindable per UX-DR114.
UX-DR140: **Drag-and-connect gesture (Physical Board)** — Mouse drag-and-drop. String follows cursor. Invalid release = no-op. Valid release = skill check fires immediately. Motor-accessibility tap mode per UX-DR107.
UX-DR141: **Click-heavy interaction grammar** — Single-click for list/button/card/text/checkbox/radio. No double-click. Right-click context menus on Physical Board (Prepare for Publication / Remove / View Details).
UX-DR142: **Gamepad scheme (deferred, Steam Deck Verified scope)** — D-pad/stick navigate, A confirm, B cancel, RT action, LT alternate, Menu = pause, Touchpad secondary input. Drag → trigger-hold-and-move.
UX-DR143: **Touch screen support (Steam Deck docked mode)** — Touch parity: drag for connection, tap select, swipe scroll, ≥40px targets, long-press for right-click. Documented; deferred post-VS.
UX-DR144: **Text expansion budget** — UI accommodates +30% text length (German benchmark). Body containers max-width not fixed. Button labels with 20% padding buffer. Dialog text max 70 chars/line.
UX-DR145: **Font fallback system** — Primary fonts bundled TTF/OTF. Fallbacks: CJK Noto Sans CJK (~50MB bundled), Arabic/Hebrew Noto Sans Arabic/Hebrew (bidi supported), symbols/emoji OS default. Unicode + fallback fonts.
UX-DR146: **UI string externalization** — All UI text in strings.json key-value pairs (`ui_button_publish`, `ui_error_insufficient_cope`, etc.). No hardcoded text in scenes. Versioned. Missing-key fallback = English key name. CSV export for translator workflow.
UX-DR147: **Subtitle and caption localization** — Voice-acted lines stored as (audio_id, dialogue_id, timestamp_start, timestamp_end). Subtitles pulled from localized strings.json. Timing fixed across languages; over-length translations auto-scale font. Speaker name labels mandatory (no audio-only speaker ID).

### FR Coverage Map

| FR | Epic | Brief |
|---|---|---|
| FR1 | Epic 12 | Opening: Wageworker start state |
| FR2 | Epic 12 | Opening: staged news event triggers investigation |
| FR3 | Epic 5 | Three-layer investigation UI |
| FR4 | Epic 5 | Physical Board pinning + drawing + scaling |
| FR5 | Epic 5 | Dossier Interface + stamping + publication framing |
| FR6 | Epic 5 | Publication Credibility/Heat preview |
| FR7 | Epic 5 | Thought Cabinet threads |
| FR8 | Epic 5 / Epic 13 | Awakening reframes evidence |
| FR9 | Epic 5 | Connection mechanic skill-check outcomes |
| FR10 | Epic 5 / Epic 7 | Wrong connections + Cage planted evidence |
| FR11 | Epic 7 / Epic 8 | War Room UI Stage 3+ |
| FR12 | Epic 7 / Epic 10 | Inner Ring Confidence Indicator |
| FR13 | Epic 8 / Epic 7 | Analyst recruit (Glowie risk) |
| FR14 | Epic 3 | Real-time combat + encounter restart |
| FR15 | Epic 3 / Epic 13 | Sound design as gameplay weapon |
| FR16 | Epic 3 | Stat-modulated combat parameters |
| FR17 | Epic 3 | Capture: YIELD vs ESCAPE |
| FR18 | Epic 3 | Captured-state escape gameplay |
| FR19 | Epic 3 / Epic 7 | Faction Build Counter-System |
| FR20 | Epic 2 / Epic 3 | Slop heals + Slop Damage track |
| FR21 | Epic 3 / Epic 5 | Evidence as inventory + Ghost Protocol backup |
| FR22 | Epic 3 | Melee weapons |
| FR23 | Epic 3 | Non-lethal weapons |
| FR24 | Epic 3 | Ranged lethal weapons |
| FR25 | Epic 3 | Thrown/trap weapons |
| FR26 | Epic 3 | Signature Weapons (6) |
| FR27 | Epic 3 | Combat Engagement Tiers |
| FR28 | Epic 4 | 15 equipment slots |
| FR29 | Epic 4 | Equipment quality tiers |
| FR30 | Epic 4 | Set bonuses |
| FR31 | Epic 4 | Equipment modifiers |
| FR32 | Epic 2 | Day cycle slots |
| FR33 | Epic 2 / Epic 12 | Snooze costs morning slot silently |
| FR34 | Epic 2 / Epic 7 | Sleep tick + subscription auto-deduct + Politburo tick |
| FR35 | Epic 2 | Action slot types |
| FR36 | Epic 2 | Quitting job + alt income |
| FR37 | Epic 9 | Heat per-district HUD |
| FR38 | Epic 9 / Epic 7 | Heat sources |
| FR39 | Epic 9 | Heat consequence scaling |
| FR40 | Epic 9 / Epic 2 | Heat decay + district rotation |
| FR41 | Epic 7 | Player Dossier as shared faction file |
| FR42 | Epic 7 | Dossier contents |
| FR43 | Epic 7 | Dossier update sources |
| FR44 | Epic 7 | OPSEC delay |
| FR45 | Epic 7 | Politburo Simulation independence |
| FR46 | Epic 7 | Politburo contents |
| FR47 | Epic 7 / Epic 10 | Weekly Politburo events + emergent quests |
| FR48 | Epic 7 / Epic 11 | Player actions feed Politburo |
| FR49 | Epic 7 / Epic 11 | Boss permanent destruction + succession |
| FR50 | Epic 7 / Epic 11 | Indirect political manipulation |
| FR51 | Epic 7 | Reputation Web personal memory |
| FR52 | Epic 7 | Gossip propagation |
| FR53 | Epic 7 | Interrogation Bridge |
| FR54 | Epic 6 / Epic 7 | Conversations have real consequence |
| FR55 | Epic 6 | Visible-DC / Hidden-consequence |
| FR56 | Epic 6 / Epic 13 | Internal voices |
| FR57 | Epic 6 | Voice frequency scales w/ Awakening + Fatigue |
| FR58 | Epic 6 / Epic 13 | Voice color/font/audio |
| FR59 | Epic 6 | Dialogue skill paths |
| FR60 | Epic 6 | Build-differentiated dialogue paths |
| FR61 | Epic 6 / Epic 11 | Dialogue-as-Combat (Anchor + Debt Dealer) |
| FR62 | Epic 6 / Epic 11 | Composure HP mechanic |
| FR63 | Epic 6 / Epic 7 | Conversation log weaponization |
| FR64 | Epic 6 / Epic 7 | Conversation log performance validation |
| FR65 | Epic 6 / Epic 5 | Item-drop in dialogue |
| FR66 | Epic 6 | Dialogue tiering |
| FR67 | Epic 10 | Seven quest types |
| FR68 | Epic 10 | Quest discovery surfaces |
| FR69 | Epic 10 | Quest Journal as character notes |
| FR70 | Epic 10 / Epic 14 | Player-decided endgame |
| FR71 | Epic 14 | Five endings |
| FR72 | Epic 1 / Epic 3 | No game-over from death |
| FR73 | Epic 8 / Epic 11 | Permanent loss (recruits, operatives) |
| FR74 | Epic 5 | Permanent loss (published evidence) |
| FR75 | Epic 14 | Effective dead-end → Sleep ending |
| FR76 | Epic 1 | Seven attributes |
| FR77 | Epic 1 / Epic 12 | Wageworker default starting distribution |
| FR78 | Epic 1 | Seven derived stats |
| FR79 | Epic 1 / Epic 2 | Cope mechanics |
| FR80 | Epic 1 / Epic 2 | Fatigue tension |
| FR81 | Epic 1 | Fatigue tradeoff |
| FR82 | Epic 1 | 24 skills |
| FR83 | Epic 1 / Epic 14 | Two disposition axes |
| FR84 | Epic 1 / Epic 13 | Awakening Track 1–10 |
| FR85 | Epic 13 | Music Deterioration mapping |
| FR86 | Epic 1 | 40 talents across 7 archetypes |
| FR87 | Epic 1 | Talent acquisition cadence |
| FR88 | Epic 8 | Organic recruitment |
| FR89 | Epic 8 | Mission-based recruitment |
| FR90 | Epic 8 | Seven specialist roles |
| FR91 | Epic 8 | Recruit properties |
| FR92 | Epic 8 | Recruit Loyalty degradation |
| FR93 | Epic 8 | Loyalty consequences |
| FR94 | Epic 8 / Epic 2 | Loyalty maintenance via slots |
| FR95 | Epic 8 / Epic 7 | Permanent recruit loss / breaking / Glowie conversion |
| FR96 | Epic 8 | Homebase 4 stages |
| FR97 | Epic 8 | Stage transitions as milestones |
| FR98 | Epic 8 / Epic 13 | Diegetic homebase evolution |
| FR99 | Epic 12 / Epic 8 | Schrödinger's Dave |
| FR100 | Epic 12 | Opening sequence beats |
| FR101 | Epic 12 | Opening silently introduces systems |
| FR102 | Epic 12 | Opening Sequence VS-MVP |
| FR103 | Epic 2 | Monthly bills |
| FR104 | Epic 2 / Epic 7 | Subscription cancellation cross-system event |
| FR105 | Epic 2 | Awakening shifts financial state |
| FR106 | Epic 2 | Shedding slop = awakening |
| FR107 | Epic 9 | 12 districts in 3 tiers |
| FR108 | Epic 9 | Slopside |
| FR109 | Epic 9 / Epic 11 | Cubicle Belt + bosses |
| FR110 | Epic 9 / Epic 11 | Plaza + bosses |
| FR111 | Epic 9 / Epic 11 | Vault District + bosses |
| FR112 | Epic 9 / Epic 11 | The Garden + bosses |
| FR113 | Epic 9 / Epic 11 | Pulpit Quarter + bosses |
| FR114 | Epic 9 / Epic 11 | University Row + boss |
| FR115 | Epic 9 / Epic 11 | Slop Belt + boss |
| FR116 | Epic 9 / Epic 11 | Civic Center + boss |
| FR117 | Epic 9 / Epic 8 | The Hollow (HQ) |
| FR118 | Epic 9 / Epic 11 | The Outskirts + boss |
| FR119 | Epic 9 / Epic 14 | The Compound endgame |
| FR120 | Epic 9 / Epic 7 | Cage Black Sites |
| FR121 | Epic 9 / Epic 14 | Inner Ring Private Locations |
| FR122 | Epic 9 / Epic 2 | Per-district Heat + rotation |
| FR123 | Epic 9 | Traversal options |
| FR124 | Epic 9 / Epic 13 | Sneak routes Ghost-gated |
| FR125 | Epic 9 / Epic 13 | Progressive map UI |
| FR126 | Epic 9 / Epic 8 | Map overlays |
| FR127 | Epic 11 | Trough bosses |
| FR128 | Epic 11 | Feed bosses |
| FR129 | Epic 11 | Pulpit bosses |
| FR130 | Epic 11 / Epic 7 | Cage bosses (incl. Glowie) |
| FR131 | Epic 11 | Vault bosses |
| FR132 | Epic 11 / Epic 14 | Inner Ring + manipulator reveal |
| FR133 | Epic 14 | Inner Ring narrative finalization |
| FR134 | Epic 7 | Faction Standing Ladder |
| FR135 | Epic 7 / Epic 11 | Double-cross + cross-faction |
| FR136 | Epic 1 / Epic 14 | Default control scheme |
| FR137 | Epic 3 | Combat-mode bindings |
| FR138 | Epic 6 | Dialogue-mode bindings |
| FR139 | Epic 5 | Investigation UI mouse-first |
| FR140 | Epic 14 | Controller scheme post-prototype |
| FR141 | Epic 9 / Epic 14 | Markers Mode optional |
| FR142 | Epic 3 / Epic 14 | Combat difficulty tuning |
| FR143 | Epic 14 | Text sizing + high-contrast |
| FR144 | Epic 14 | Subtitle/Caption toggle |
| FR145 | Epic 14 | Hold vs Toggle |
| FR146 | Epic 1 / Epic 13 | HUD minimal default |
| FR147 | Epic 1 | On-demand HUD screens |
| FR148 | Epic 1 / Epic 6 | Contextual HUD |
| FR149 | Epic 1 / Epic 13 | HUD philosophy |
| FR150 | Epic 13 | UI Duality |
| FR151 | Epic 13 | Duality as satire |
| FR152 | Epic 1 | Save default |
| FR153 | Epic 1 | Ironman option |
| FR154 | Epic 1 | Day-boundary autosave bound |
| FR155 | Epic 3 / Epic 1 | Encounter restart separate from save |
| FR156 | Epic 3 / Epic 1 | Captured-state save |
| FR157 | Epic 1 | Skill-check XP |
| FR158 | Epic 1 | Attribute growth |
| FR159 | Epic 1 / Epic 13 | Awakening as Mythic-equivalent |
| FR160 | Epic 1 / Epic 12 | Awakening = campaign spine |
| FR161 | Epic 3 / Epic 11 | Combat difficulty curve |
| FR162 | Epic 5 / Epic 11 | Investigation difficulty curve |
| FR163 | Epic 8 | Social/recruitment difficulty curve |
| FR164 | Epic 2 | Money sources |
| FR165 | Epic 4 | Materials & crafting |
| FR166 | Epic 2 | Time as scarcest resource |
| FR167 | Epic 1 / Epic 6 | Skill check infrastructure |
| FR168 | Epic 14 / Epic 11 | Equal-opportunity satire |
| FR169 | Epic 6 | Disco-Elysium-tier writing volume |
| FR170 | Epic 10 / Epic 14 | Main Quest "The Arrangement" |
| FR171 | Epic 13 | Visual style satirical hyper-realism |
| FR172 | Epic 13 / Epic 9 | Contrast as art direction |
| FR173 | Epic 13 | Awakening visual filter shift |
| FR174 | Epic 13 | 2D top-down format |
| FR175 | Epic 13 | Audio style layered |
| FR176 | Epic 13 | Music deterioration mechanic |
| FR177 | Epic 13 / Epic 3 | Sound as gameplay |
| FR178 | Epic 14 / Epic 13 | Accessibility audio pairings |
| FR179 | Epic 9 | District-based bounded |
| FR180 | Epic 14 / Epic 1 | 60fps min-spec target |
| FR181 | Epic 14 | Steam Deck Verified |
| FR182 | Epic 14 | Memory footprint |
| FR183 | Epic 7 / Epic 14 | Politburo tick budget |
| FR184 | Epic 6 / Epic 14 | Conversation log scale |
| FR185 | Epic 14 | Platform tiers |
| FR186 | Epic 13 / Epic 9 / Epic 11 / Epic 8 | Art assets scope |
| FR187 | Epic 13 / Epic 6 / Epic 11 / Epic 8 | Audio assets scope |
| FR188 | Epic 6 / Epic 14 | Writing assets + tooling |
| FR189 | Epic 7 | Three Tracking Systems code-distinct |
| FR190 | Epic 3 / Epic 7 | Build classifier abstraction |
| FR191 | Epic 6 / Epic 7 | Conversation Log first-class subsystem |
| FR192 | Epic 1 | Save system boundaries |
| FR193 | Epic 13 | Music deterioration pipeline VS-locked |
| FR194 | Epic 6 | Skill check / dialogue branching infra |
| FR195 | Epic 14 | Localization-readiness day 1 |
| FR196 | Epic 14 | Languages-at-launch open |
| FR197 | Epic 1 | Engine = Godot 4.x |
| FR198 | Epic 1 | Solo dev + vibe coding |
| FR199 | Epic 7 / Epic 14 | Three Tracking Systems legal review |
| FR200 | Epic 13 | Composer engagement VS |
| FR201 | Epic 6 / Epic 14 | Writing tooling pre-scaling |
| FR202 | Epic 14 | IP-counsel for satirical edge cases |
| FR203 | Epic 14 | Tone calibration playtests pre-EA |
| FR204 | Epic 10 / Epic 14 | Inner Ring narrative finalization |

## Epic List

**14 epics total. Numbering follows GDD §Development Epics with refinements; ordering reflects dependency flow. Solo-dev VS scope per NFR42 takes partial slices of Epics 1/2/3/5/6/7/8/9/10/11/12/13.**

### Epic 1: Foundation, Scaffolding & RPG Core

**User outcome:** A player can launch the game, create a character with the seven attributes / 24 skills / 40 talents / disposition axes / Awakening-Track engine in place, advance progression via skill-check experience, and have their state survive a save-and-load cycle (including Ironman).

**FRs covered:** FR72, FR76, FR77, FR78, FR79, FR80, FR81, FR82, FR83, FR84 (engine only), FR86, FR87, FR136, FR146, FR147, FR148, FR149, FR152, FR153, FR154, FR155 (interface), FR156 (interface), FR157, FR158, FR159, FR160, FR167, FR192, FR197, FR198.

**Architecture scope:** Story 0 project scaffolding per §2.4 (project.godot, 12 autoloads, 9 audio buses, folder skeleton, .gitignore, SaveGameV1, Steam Deck export preset). RPGCore + SaveSystem + Logger + ProjectConfig + Balance + RNG + WorldClock + EventBus + ThemeManager (token registry only) + DialogueRunner stub + EncounterDirector stub + MusicDirector stub. Locked rules 1, 8, 9, 10, 11, 12. Performance budgets baselined.

**UX-DRs:** UX-DR52, UX-DR53, UX-DR55, UX-DR70, UX-DR72, UX-DR73, UX-DR111, UX-DR114, UX-DR115, UX-DR118, UX-DR124.

**Implementation notes:** Story 0 is the project-scaffolding deliverable per architecture §2.4. Awakening Track surface effects (filter, music deterioration) live in Epic 13; this epic owns the Track *engine* (level transitions, persistence, EventBus signals).

---

### Epic 2: Day Cycle & Survival Loop

**User outcome:** A player can live a day in slots, snooze (and lose Morning), spend slots on Investigation/Publication/Combat/Social/Maintenance/Cover/Rest, sleep to advance the world, pay monthly bills, cancel subscriptions (with retention-ritual + Awakening tick + Feed flag), feel the slop economy bleed them dry, and recover Cope on a genuine off-day.

**FRs covered:** FR20 (slop heal + damage tracks), FR32, FR33, FR34, FR35, FR36, FR40 (Heat decay during downtime), FR94 (Loyalty maintenance via slots), FR103, FR104, FR105, FR106, FR122 (Heat tied to district rotation strategy), FR164, FR166.

**Architecture scope:** WorldClock autoload integration, DayCycleConfig resource, subscription event chain, Cope/Fatigue/Slop Damage derived stat hooks via EventBus, sleep advance commit triggers Politburo tick (cross-event to Epic 7).

**UX-DRs:** UX-DR37 (DaySlotHUD), UX-DR40 (BillsScreen), UX-DR44 (Fatigue), UX-DR45 (Cope), UX-DR46 (Slop Damage), UX-DR48 (Day/Time slot), UX-DR68 (Bills Screen), UX-DR83 (Subscription cancellation ritual), UX-DR89 (Faction event escalation), UX-DR135 (Pip pulse animations).

**Implementation notes:** Subscription Cancellation is a signature satire moment — designed and tested as a complete ritual at VS. Politburo tick fires after sleep but Epic 7 owns the simulation; this epic owns only the input-queueing and tick scheduling.

---

### Epic 3: Combat (Hotline Miami DNA)

**User outcome:** A player can engage in lethal real-time top-down combat where stats modify parameters (never invincibility), die-and-restart-encounter in <0.5s with world-state persistence, or get captured and choose YIELD vs ATTEMPT ESCAPE. The Faction Build Counter-System reads their build and dispatches counter-tactics. Signature weapons let satire shape combat tactics.

**FRs covered:** FR14, FR15, FR16, FR17, FR18, FR19, FR21 (evidence-as-inventory + remote backup), FR22, FR23, FR24, FR25, FR26, FR27, FR137, FR142, FR155, FR156, FR161, FR177 (sound as gameplay — combat-side), FR190.

**Architecture scope:** EncounterDirector autoload (snapshot + restart). Combat cluster (C). Physics rules per D-PHYS-01. Build Classifier / Tactical Response abstraction (clean separation: dossier classification = input pattern; faction tactical response = output loadout — split across Epic 3 and Epic 7).

**UX-DRs:** UX-DR74 (Death/Restart screen), UX-DR85 (Combat HUD slide-in), UX-DR108 (Combat difficulty + auto-restart accessibility).

**Implementation notes:** Capture state is a save-eligible substate (player can sleep/quit during capture without losing escape option). Boss combat encounters live in Epic 11; this epic owns the engine.

---

### Epic 4: Equipment & Crafting

**User outcome:** A player can equip 15 slots from 5 quality tiers, hit set bonuses for outfit combinations (Civilian / Tactical / Hidden Operator / Press Cover / Underground Standard), and unlock crafted Resistance gear via the IRL Build skill or a Crafter recruit.

**FRs covered:** FR28, FR29, FR30, FR31, FR165.

**Architecture scope:** Equipment slot system as RPG sub-module. Static config in Resource files (15 slot definitions, 5 tier definitions, 5 set bonus rules, all crafted items). All bonus deltas route through `Balance` (locked rule 10).

**UX-DRs:** UX-DR54 (Inventory/Equipment paper-doll screen).

**Implementation notes:** Set bonus detection is a runtime function over the equipped loadout. Heat modifiers from gear feed into Epic 9 Heat system.

---

### Epic 5: Investigation UI (Three Layers) — The Truth Paradox

**User outcome:** A player can investigate using a diegetic Physical Board (drag pins, draw red string with skill-check resolution, three-outcome stamp), prepare a publication via the Dossier Interface (cross-reference + stamp evidence + framing matrix with live Credibility/Heat preview), and rumiate on Thought Cabinet threads that reframe existing evidence as Awakening rises. They feel the Truth Paradox: more correct = more dangerous.

**FRs covered:** FR3, FR4, FR5, FR6, FR7, FR8 (surface), FR9, FR10 (player side; planted-evidence side lives in Epic 7), FR65 (item-drop in dialogue *into* a publication), FR74 (publication permanence), FR139, FR162.

**Architecture scope:** Investigation UI cluster (E). Connection Draw skill-check on Physical Board. Publication Commit framing matrix. Thought Cabinet thread persistence across day boundaries.

**UX-DRs:** UX-DR25 (ProgressBar for Credibility/Heat preview), UX-DR30 (EvidenceCard), UX-DR31 (ConnectionString), UX-DR34 (PublicationFramingMatrix), UX-DR35 (DossierEntry), UX-DR60 (Physical Board scene), UX-DR61 (Dossier scene), UX-DR62 (Thought Cabinet scene), UX-DR82 (Publication commit ceremony), UX-DR88 (Evidence stamps), UX-DR130 (Skill check animation), UX-DR131 (Stamp animations), UX-DR140 (Drag-and-connect), UX-DR141 (Click-heavy grammar).

**Implementation notes:** Truth Paradox legibility is NFR14 (>75% playtesters describe unprompted within 30 minutes) — playtest gate at VS. War Room (Stage 3+) lives in Epic 8 (Homebase) because it's a Stage-3-unlock.

---

### Epic 6: Dialogue System

**User outcome:** A player can have rich Disco-Elysium-tier dialogue with visible-DC / hidden-consequence skill checks; hear 24 named Inner Voices that scale with Awakening + Fatigue; drop physical evidence into conversations to unlock locked lines; route through Composure-HP boss encounters (Trusted Anchor, Debt Dealer); and have every word recorded for the world (NPCs quote, Cage interrogates, Feed weaponizes).

**FRs covered:** FR54, FR55, FR56, FR57, FR58, FR59, FR60, FR61 (engine; specific bosses in Epic 11), FR62, FR63, FR64, FR65 (item-drop side), FR66, FR138, FR148 (dialogue contextual HUD), FR167, FR169, FR184, FR188, FR191, FR194, FR201.

**Architecture scope:** Dialogue Runtime cluster (D). DialogueRunner autoload. Custom GDScript dialogue VM with all 9 node types (Line / Choice / SkillCheck / InternalVoice / ItemDrop / Branch / SystemEffect / Commit / End). Conversation Log subsystem with append-only invariant (locked rule 5). Composure HP context for dialogue-as-combat (locked rule 6: same VM, no special-case path). Internal Voice cap-per-dialogue logic. YAML→tres dialogue importer (mandatory pre-EA).

**UX-DRs:** UX-DR6 (Inner Voice typography), UX-DR28 (DialogPortrait), UX-DR29 (SkillCheckBadge), UX-DR32 (InnerVoiceLine), UX-DR33 (DialogChoice), UX-DR36 (ConversationLogEntry), UX-DR56 (Dialogue Interface), UX-DR57 (Conversation Log screen), UX-DR86 (Inner Voice flourish), UX-DR95 (Voice intensity scaling), UX-DR99 (Conversation log darkening), UX-DR127 (Conversation log as artifact), UX-DR136 (Choice highlight), UX-DR137 (Portrait micro-animations), UX-DR147 (Subtitle localization).

**Implementation notes:** Conversation Log performance is highest-risk subsystem (NFR8 / NFR47): retrieval <50ms, gossip <2s for 200+ Gnoym. Validate at VS. Writing tooling investment (FR201) is a parallel deliverable on this epic.

---

### Epic 7: Three Tracking Systems

**User outcome:** A living world tracks the player. The Cage assembles a single shared faction Dossier from operative reports, leaks, publications, and interrogations. The Politburo Simulation runs weekly whether the player exists or not — bosses succeed each other, blackmail debts come due, factions ally and betray. Individual Gnoym remember the player's exact words and gossip with each other; when one is interrogated, their memory enters the Dossier verbatim. The Glowie may have been a recruit all along.

**FRs covered:** FR10 (Cage planted evidence side), FR11 (War Room data), FR12 (Inner Ring Confidence), FR13 (Analyst flagging + Glowie risk), FR19 (Faction Build Counter-System dossier side), FR34 (Politburo tick on sleep), FR38 (Heat sources from Politburo), FR41, FR42, FR43, FR44, FR45, FR46, FR47, FR48, FR50, FR51, FR52, FR53, FR54, FR63 (Cage interrogation use), FR64 (perf), FR95 (Glowie conversion), FR104 (Feed dossier flag from cancellation), FR120 (Cage Black Sites data), FR130 (Glowie boss is Inner Ring tracker test), FR134, FR135, FR183, FR189, FR190 (counter-tactic side), FR191, FR199.

**Architecture scope:** Tracking cluster (F) — the SINGLE most architecturally constrained cluster. Legal-distinctness contract §5.1 Rules 1–4: (1) Player Dossier never holds per-NPC memory; (2) Politburo never reads player-action graph directly; (3) Interrogation Bridge is the only data path from Reputation Web to Dossier; (4) Standing README in `src/tracking/README.md`. `# DISTINCTNESS CONTRACT` comment header. Locked rules 2, 3, 12. AI agent code-review checklist binding for all PRs touching `src/tracking/`. Politburo as deterministic pure-function; replay debugging tool. WorldState owns the triad (not autoloads).

**UX-DRs:** UX-DR35 (DossierEntry — Faction-sourced / Mole-sourced / interrogation-sourced variants), UX-DR41 (WarRoomGrid component, Stage 3+), UX-DR50 (Signal indicator), UX-DR63 (War Room scene; full at EA, stub at VS), UX-DR77 (Faction Standing screen).

**Implementation notes:** This epic carries the project's largest legal/architectural risk. Pre-VS legal review of the contract (FR199) is a separate deliverable. Code review process from architecture §7.3 is binding for every PR in this epic.

---

### Epic 8: Recruitment & Homebase

**User outcome:** A player can recruit specialists organically (side quests + in-dialogue puzzles) or via missions, build their homebase from Apartment → Office → Underground HQ → Distributed Cell Network, fill 7 specialist roles (Researcher, Broadcaster, Crafter, Medic, Quartermaster, Analyst, Handler), maintain Loyalty as an ongoing resource, and lose recruits permanently to Cage raids, breaking, voluntary exit, or Glowie conversion.

**FRs covered:** FR11 (War Room as Stage 3 unlock), FR13 (Analyst recruit specialist), FR73 (permanent loss of recruits), FR88, FR89, FR90, FR91, FR92, FR93, FR94, FR95, FR96, FR97, FR98, FR117 (The Hollow as HQ home), FR126 (Analyst-supported map overlays), FR163, FR186 (homebase art assets), FR187 (recruit VO).

**Architecture scope:** Recruitment cluster within `src/recruitment/`. Static recruit config + Loyalty/Trust state in WorldState. Stage transition events fire EventBus signals consumed by Epic 13 (diegetic homebase evolution).

**UX-DRs:** UX-DR79 (NPC/Recruit Management screen).

**Implementation notes:** Homebase Stage 1 is VS scope (NFR42). Stages 2–4 are EA / Full-launch. Schrödinger's Dave first-conversation lock is technically Epic 12 (Opening) but his recruit-arc consequences land here.

---

### Epic 9: World & Districts

**User outcome:** A player can navigate 12 districts (5 Tier-1 multi-sub-area + 6 Tier-2 specialty + 1 Tier-3 Compound endgame), each with its own faction-dominance flavor, per-district Heat tracking, Heat-decay during downtime, sneak routes that only appear above Ghost Mode threshold, and a progressive map UI that reveals more layers as Awakening rises.

**FRs covered:** FR37, FR38 (district scope), FR39, FR40, FR107, FR108, FR109, FR110, FR111, FR112, FR113, FR114, FR115, FR116, FR117, FR118, FR119, FR120, FR121, FR122, FR123, FR124, FR125, FR126, FR141, FR172 (palette per district), FR179, FR186 (district art).

**Architecture scope:** World cluster `src/world/`. Per-district scene per architecture §4.3 (one scene per logical concern; no god scenes). Streamed transitions between districts. NavigationAgent2D-baked nav regions per district. Per-district Heat state in WorldState.

**UX-DRs:** UX-DR43 (Heat indicator), UX-DR49 (Location indicator), UX-DR51 (Contextual action prompt), UX-DR59 (World Map screen), UX-DR109 (Markers Mode pin overlay), UX-DR110 (Awakening Hints).

**Implementation notes:** VS ships one district (Slopside + Cubicle Belt + Plaza for the prototype, per project state). Boss residences and arena scenes live in Epic 11 but use this epic's district as host.

---

### Epic 10: Quest System & Endgame Trigger

**User outcome:** A player can pursue 7 quest types in parallel (Main Quest "The Arrangement" + 13 Faction Boss Investigations + Recruit Personal Quests + Emergent Politburo Events + Reputation Web Side Quests + Awakening Track Story Beats + District Liberation Goals), discover quests through overheard dialogue / forum posts / recruit intelligence / evidence cross-reference / Politburo broadcasts / random encounters / dead drops, journal them in their own prose-style notebook, and decide for themselves when they've assembled enough Inner Ring evidence to commit to an endgame.

**FRs covered:** FR12 (Inner Ring Confidence as endgame trigger gate), FR47 (emergent quest spawning), FR67, FR68, FR69, FR70, FR75 (effective dead-end), FR141 (Markers Mode at quest level), FR170, FR204.

**Architecture scope:** Quest cluster `src/quest/`. Quest definitions as Resources; quest state in WorldState. Inner Ring Confidence calculation across investigation evidence. Endgame Trigger gate.

**UX-DRs:** UX-DR58 (Quest Journal), UX-DR78 (Quest Journal screen), UX-DR109 (Markers Mode), UX-DR110 (Awakening Hints).

**Implementation notes:** Quest Journal is character's prose notes (not auto-logged). Threads vs Cold Cases sections prevent "missing content" frustration. VS ships skeleton (one Main-Quest thread + one boss investigation flow).

---

### Epic 11: Boss Investigations (13 → 5–7 for solo-ship)

**User outcome:** A player can investigate, expose, and resolve faction boss operatives via documentation / dialogue-as-combat / cross-faction manipulation / direct combat — each boss is a multi-stage arc with boss-specific defeat conditions, and assembling evidence across multiple bosses opens the Inner Ring path. Boss operatives can be permanently destroyed; the Politburo succession-fills their role.

**FRs covered:** FR48 (player→Politburo input on boss elimination), FR49 (succession), FR50 (indirect manipulation), FR61 (specific dialogue-bosses Trusted Anchor + Debt Dealer), FR62 (Composure-HP scenes), FR73 (operative permanent loss), FR127, FR128, FR129, FR130, FR131, FR132, FR135, FR161, FR162, FR163, FR186 (boss arenas), FR187 (boss VO), FR168 (equal-opportunity Pulpit roster).

**Architecture scope:** Each boss investigation is a quest of seven types (per Epic 10). Boss arenas are scenes per architecture §4.3. Trusted Anchor + Debt Dealer use Composure-HP context with the same Dialogue VM (locked rule 6).

**UX-DRs:** Inherits Epic 5 + Epic 6 + Epic 9 UX-DRs.

**Implementation notes:** **Solo-dev cut: 5–7 bosses ship at full launch (Pulpit reduces from 4 sub-bosses → 1 rotating-mask boss).** VS ships Fact Checker (Cubicle Belt, recommended in NFR42). North Star list of all 13 retained for future team scaling.

---

### Epic 12: Opening Sequence & Schrödinger's Dave

**User outcome:** A new player experiences "A Perfectly Normal Morning" — alarm → fridge → feed → commute → Greystone job (with Dave's first-conversation choice that permanently locks his arc) → witnesses the staged Incident → sees the Feed gap that night → bookmarks the underground forum. In 15 minutes of contextual tutorial, they've been silently introduced to time slots, Slop Damage, financial pressure, dialogue consequences, Receipts, evidence board, Feed-vs-reality, and the underground forum.

**FRs covered:** FR1, FR2, FR33 (snooze lesson lives here), FR77 (Wageworker default state), FR99 (Schrödinger's Dave), FR100, FR101, FR102, FR160 (Awakening as campaign spine seeds here).

**Architecture scope:** Opening cluster `src/opening/`. Diegetic-scene exception list includes Greystone Intranet + McXyon's app + Apartment Laptop. Dave's first-dialogue commit locks his role (Schrödinger's NPC system) — uses standard Dialogue VM but writes a permanent flag to WorldState that gates his future appearances.

**UX-DRs:** UX-DR65 (Apartment Laptop), UX-DR66 (Greystone Intranet), UX-DR67 (McXyon's Ordering UI), UX-DR75 (Intro Cinematic UI).

**Implementation notes:** **VS-MVP requirement** (FR102). Opening Sequence is shippable as part of Vertical Slice. Tutorial-without-text is NFR13 (>80% playtesters identify silently-introduced systems within 30 minutes). Dave's lock + Greystone-as-Cage-front + first staged news event are the locked beats.

---

### Epic 13: Theme System, Awakening Filter & Music Deterioration

**User outcome:** The world *looks* satirical hyper-realism — Xyoner spaces oversaturated and too cheerful, Slopside/Hollow desaturated and grimy. As the player Awakens, the visual filter desaturates the world (cheerful starts reading as wrong), the corporate music in Xyoner spaces audibly deteriorates across 5 tiers (multi-version recordings + smooth crossfade), the HUD itself glitches, and Resistance UI elements appear in homebase. The duality between Xyoner-app polish and Resistance-handmade aesthetics IS the satire.

**FRs covered:** FR8 (Awakening reframes evidence — visual side), FR15 (sound design surface), FR56 (voice color/font), FR58 (voice audio cue), FR84 (Awakening level surface effects), FR85, FR98 (homebase diegetic evolution), FR124 (sneak route reveal), FR125 (progressive map UI), FR146, FR149, FR150, FR151, FR159 (Awakening cinematic at 1/5/10), FR171, FR172, FR173, FR174, FR175, FR176, FR177 (sound as gameplay surface), FR178 (accessibility audio pairings), FR186, FR187, FR193, FR200.

**Architecture scope:** Audio Pipeline cluster (G). MusicDirector autoload. ThemeManager autoload (token swap on Awakening thresholds). Awakening Filter fragment shader on CanvasLayer ColorRect. 5-tier music deterioration via two-AudioStreamPlayer crossfade per Xyoner-space context. 9 audio buses. UI duality (Xyoner / Resistance) sharing one component grammar via theme tokens (locked rule 10). Diegetic-scene exception list. Locked rules 4 (Awakening Filter event-driven), 7 (multi-version recordings, never DSP).

**UX-DRs:** UX-DR1 (Xyoner palette), UX-DR2 (Resistance palette), UX-DR3 (Awakening Filter), UX-DR4 (Xyoner type), UX-DR5 (Resistance type), UX-DR7 (Spacing), UX-DR8 (Motion tokens), UX-DR9 (Sound tokens), UX-DR10–UX-DR26 (component primitives — both themes), UX-DR27 (StatPip), UX-DR38 (StatusPipCluster), UX-DR39 (Music Deterioration accessibility indicator), UX-DR42 (Persistent ambient HUD), UX-DR47 (Awakening Level not-on-HUD rule), UX-DR80 (Xyoner transitions), UX-DR81 (Resistance transitions), UX-DR84 (Music Deterioration visual mirror), UX-DR87 (Awakening Filter transition), UX-DR91 (HUD softening / hardening), UX-DR92 (Saturation curve), UX-DR93 (Music milestone feedback), UX-DR96 (Build-gated legibility surfaces), UX-DR97 (Resistance HUD at high Awakening), UX-DR98 (NPC look-through), UX-DR122 (Xyoner-app rule), UX-DR123 (Resistance-handmade rule), UX-DR125 (Scene-as-screen), UX-DR126 (Diegetic feedback over popups), UX-DR128 (Xyoner menu transition system), UX-DR129 (Resistance menu transition system), UX-DR132 (Loading state diegesis), UX-DR133 (Filter desaturation curve), UX-DR134 (Music crossfade).

**Implementation notes:** **VS prototype: one Xyoner-space track in deterioration tiers** (NFR42). Music Deterioration is signature satire surface (NFR17 — >60% playtesters cite as memorable). Music Deterioration asset pipeline (Story 13.4a) locks at vertical slice (NFR48, FR200).

---

### Epic 14: Endings, Polish, Localization & Accessibility

**User outcome:** A player can reach all 5 endings (Public Reckoning / Shadow Replacement / Burn / Long Game / Sleep — solo-dev ships 3: Public Reckoning + Long Game + Sleep) with proper coda + epilogue narration + credits; play in a localization-ready UI that supports +30% text expansion + font fallbacks for CJK/Arabic/Hebrew + UI strings via tr(); play with WCAG AA accessibility (text scaling, dyslexia font, color-blindness cues, subtitles, hold-to-confirm, click-source-then-target alternative, full keyboard nav, screen-reader navigation layer); and play on Steam Deck Verified at 60fps stable on min-spec hardware.

**FRs covered:** FR70 (player-decided endgame trigger — endgame side), FR71, FR75, FR83 (disposition axes gate ending eligibility), FR119 (Compound endgame), FR121 (Inner Ring locations endgame), FR132 (Inner Ring reveal), FR133, FR136 (control rebinding side), FR140, FR141, FR142, FR143, FR144, FR145, FR168 (equal-opportunity satire QA), FR170 (Main Quest endgame side), FR178, FR180, FR181, FR182, FR184 (perf gate at EA), FR185, FR188 (writing tooling QA), FR195, FR196, FR199 (final legal pre-launch), FR201, FR202, FR203, FR204.

**NFRs explicitly addressed:** NFR2, NFR3, NFR9, NFR12, NFR38, NFR39, NFR41, NFR44, NFR45, NFR50.

**Architecture scope:** Locked rule 9 (tr() lint enforcement; `tools/string_lint.gd` build gate at EA prep). Localization pipeline (Godot CSV + PO export). Asset budget tracking automation. Save-schema versioning CI (frozen reference saves round-trip). Steam Deck Verified export validation. IP review of Three Tracking Systems. Tone calibration external playtests pre-EA.

**UX-DRs:** UX-DR70 (Settings menu), UX-DR71 (Accessibility panel), UX-DR72 (Pause menu), UX-DR73 (Save/Load), UX-DR74 (Death/Restart), UX-DR76 (Ending cinematics + Sleep coda), UX-DR100 (contrast minimums), UX-DR101 (color-blind cues), UX-DR102 (text scaling), UX-DR103 (dyslexia font), UX-DR104 (subtitles), UX-DR105 (music deterioration visual indicator), UX-DR106 (hold-to-confirm), UX-DR107 (click-source-then-target), UX-DR108 (combat accessibility), UX-DR109 (markers), UX-DR110 (awakening hints), UX-DR111 (keyboard nav), UX-DR112 (screen-reader), UX-DR113 (Steam Deck controller — deferred), UX-DR114 (input remapping), UX-DR115 (pause-anywhere), UX-DR116 (audio mix), UX-DR117 (markers + difficulty), UX-DR118 (Ironman toggle), UX-DR119 (Language), UX-DR120 (Display/Video), UX-DR121 (Control rebinding), UX-DR138 (mouse+kbd primary), UX-DR139 (kbd shortcuts), UX-DR141 (click grammar), UX-DR142 (gamepad — deferred), UX-DR143 (touch — deferred), UX-DR144 (text expansion budget), UX-DR145 (font fallback), UX-DR146 (string externalization), UX-DR147 (subtitle localization).

**Implementation notes:** **Endings cut for solo-dev: 3 ship at full launch (Public Reckoning + Long Game + Sleep), with hooks for Shadow Replacement + Burn retained as North Star.** Sleep ending engagement target NFR19 (>5% completionist players reach without nudging away). Marketing brief (NFR23) is part of this epic. Full accessibility WCAG AA pass + Steam Deck Verified are gated by this epic.

---

## Epic 1: Foundation, Scaffolding & RPG Core

A player can launch the game, create a character with the seven attributes / 24 skills / 40 talents / disposition axes / Awakening-Track engine in place, advance progression via skill-check experience, and have their state survive a save-and-load cycle (including Ironman).

### Story 1.0: Project Scaffolding (Story 0)

As the solo developer,
I want a Godot 4.x project skeleton with all 12 autoloads registered, the folder structure enforced, the SaveGameV1 round-trip test passing, and the Steam Deck Linux export preset working,
So that every subsequent story has a stable foundation that respects the architecture's locked rules from day one.

**Acceptance Criteria:**

**Given** a fresh clone of the repo
**When** I open it in Godot 4.3 (or latest stable 4.x)
**Then** `project.godot` is configured with window 1920×1080, viewport stretch `canvas_items`, default texture filter `nearest`, physics tick 60, audio mix rate 44100
**And** the 9 audio buses (Master, Music, Music_Stinger, SFX_World, SFX_Combat, SFX_UI, Voice_Internal, Voice_Dialogue, Ambient) exist in the default bus layout

**Given** the project opens successfully
**When** the editor scans autoloads
**Then** all 12 autoloads (Logger, ProjectConfig, Balance, RNG, SaveSystem, WorldClock, RPGCore, ThemeManager, MusicDirector, DialogueRunner, EncounterDirector, EventBus) are registered and load without errors

**Given** the autoloads are registered
**When** the project tree is inspected
**Then** the folder skeleton from architecture §4.1 exists (art/, audio/, src/{core,rpg,day_cycle,combat,dialogue,investigation,tracking,audio,world,npcs,ui,opening,quest,recruitment,localization}/, tests/, tools/) and `.gitignore` excludes Godot+OS clutter

**Given** the project loads
**When** the SaveGameV1 round-trip test in `tests/save/test_savegame_v1_roundtrip.gd` runs
**Then** it serializes a known SaveGameV1 instance to `.tres`, reloads it, and asserts field-level equality (version stamp, every save-relevant field intact)

**Given** all preceding tests pass
**When** I run the Linux export preset for Steam Deck Verified
**Then** a `.x86_64` binary builds successfully and launches on a Steam Deck or Steam Deck-shaped Linux VM

**And** `src/tracking/README.md` exists with the §5.1 legal-distinctness contract verbatim

### Story 1.1: Seven-Attribute System

As a player creating my character,
I want the seven attributes (BODY, MIND, SOUL, MOUTH, GHOST, GUT, SIGNAL) to be defined, persisted, and queryable from gameplay code,
So that my build choices are real and influence everything from skill checks to combat hit thresholds.

**Acceptance Criteria:**

**Given** a fresh save
**When** I inspect `RPGCore.attributes`
**Then** the seven attributes exist as integer keys, all clamped to range [1, 10], with the Wageworker default distribution (BODY 4, MIND 2, SOUL 2, MOUTH 3, GHOST 1, GUT 5, SIGNAL 0)

**Given** a character at attribute X = N
**When** any system reads `RPGCore.get_attribute(X)`
**Then** the value returned matches the persisted state

**Given** any attempt to set an attribute outside [1, 10]
**When** `RPGCore.set_attribute(X, value)` is called
**Then** the value is clamped to the valid range and a Logger warning is emitted

**Given** a save+load cycle
**When** the save is reloaded
**Then** all seven attribute values are preserved exactly

### Story 1.2: 24-Skill System

As a player improving my character,
I want all 24 skills (4 per archetype × 6 archetypes) to exist in a 0–10 ladder with skill XP that drives level-ups,
So that the character I level into mechanically matches the build I intended.

**Acceptance Criteria:**

**Given** a fresh save
**When** I inspect `RPGCore.skills`
**Then** all 24 skills are present with rank 0 by default and have data-driven definitions in `src/rpg/data/skills.tres` (one per skill: name, archetype, parent attribute, description, voice profile id)

**Given** a skill check fires
**When** the check resolves (regardless of outcome)
**Then** the relevant skill earns XP per the curve in `Balance.skill_xp_per_use`

**Given** skill XP crosses a level threshold
**When** the level-up resolves
**Then** the skill rank increments, a talent point is awarded per FR87 cadence, and an `EventBus.skill_levelled(skill_id, new_rank)` signal fires

**Given** any skill at rank N
**When** any consumer calls `RPGCore.get_skill_rank(skill_id)`
**Then** the returned value matches save state

### Story 1.3: Skill Check Engine (Visible-DC, Hidden-Consequence)

As a player making decisions,
I want skill checks to surface their visible DC and required skill but never their consequences,
So that the world remains uncertain and my choices feel weighted instead of optimal.

**Acceptance Criteria:**

**Given** a skill-check request `{skill_id, dc, modifiers}`
**When** `RPGCore.skill_check(...)` is called
**Then** it returns `{outcome: critical_success | success | fail, roll, total, dc}` using attribute + skill rank + situation modifiers + RNG seeded from the `dialogue` or `rpg` subsystem RNG

**Given** an unbiased RNG distribution
**When** 10,000 checks at attribute+skill = DC are simulated
**Then** the success rate falls within ±2% of the documented 50% baseline

**Given** the same RNG seed and same inputs
**When** `skill_check` is called twice
**Then** identical results are produced (determinism)

**Given** a UI consumer
**When** it requests check display data via `RPGCore.preview_check(skill_id, dc)`
**Then** it receives the visible DC, the skill name + voice profile id, but never an outcome-consequence string

### Story 1.4: 40 Talents Across 7 Archetypes

As a player specializing my build,
I want 40 named talents across 7 archetypes (Combat, Stealth/Infiltration, Information Warfare, Network/Social, Awakening, Economy/Resources, Wildcard) with a talent-point spend mechanism and mutual-exclusion support,
So that two playthroughs feel mechanically different (NFR15 build differentiation target ≥70%).

**Acceptance Criteria:**

**Given** the talent definitions in `src/rpg/data/talents.tres`
**When** the data loads
**Then** all 40 talents from FR86 are present, each with archetype tag, prereqs, mutual-exclusion list (where applicable), passive/active hooks, balance numbers loaded from `Balance`

**Given** a player with N talent points
**When** they unlock a talent
**Then** the point cost is debited, the talent's effect attaches to the appropriate `RPGCore` derivation pipeline, and `EventBus.talent_unlocked(talent_id)` fires

**Given** a talent X has mutually-exclusive talent Y already unlocked
**When** the player attempts to unlock X
**Then** the unlock is rejected with a UI-surface error message

**Given** a save+load cycle
**When** the save reloads
**Then** unlocked talents persist and their effects re-attach correctly

### Story 1.5: Awakening Track Engine

As a player on the awakening journey,
I want an Awakening Track (Levels 1–10) that responds to in-world events (not grinding) and emits events for surface effects (filter, music, voice intensity),
So that my consciousness is the campaign spine, distinct from skill levels.

**Acceptance Criteria:**

**Given** the Awakening Track engine
**When** `RPGCore.advance_awakening(reason: String)` is called from an in-world event source (subscription cancellation, evidence published with truth, completing an Awakening Beat)
**Then** the level increments, `EventBus.awakening_level_changed(old, new, reason)` fires, the level is persisted

**Given** any subsystem
**When** it needs the current Awakening level
**Then** it does NOT read `RPGCore.awakening_level` directly — it subscribes to `EventBus.awakening_level_changed` (architecture locked rule 4)

**Given** Awakening Track levels 1, 5, and 10
**When** the level transition fires
**Then** an `EventBus.awakening_cinematic_due(level)` signal fires (consumed by Epic 13 + Epic 14 cinematic systems; this story stops at the signal)

**Given** a save+load cycle
**When** the save reloads
**Then** the Awakening level is preserved

### Story 1.6: Disposition Axes (GNOY↔AWAKE, PASSIVE↔REBEL)

As a player whose actions accumulate a disposition,
I want my disposition tracked emergently across two axes from action history (not direct selection),
So that ending eligibility flows from how I played, not a menu choice.

**Acceptance Criteria:**

**Given** the disposition system
**When** any signal in `EventBus.disposition_input(axis, delta, reason)` fires (subscription cancelled / evidence published / capture vs kill / etc.)
**Then** the corresponding axis (GNOY↔AWAKE or PASSIVE↔REBEL) integrates the delta into a clamped [-1.0, 1.0] running value

**Given** a disposition value
**When** UI requests it via `RPGCore.get_disposition(axis)`
**Then** it returns the float and a qualitative label (GNOY / leaning GNOY / mixed / leaning AWAKE / AWAKE — same pattern for the other axis)

**Given** a save+load cycle
**When** the save reloads
**Then** both axis values persist with full precision

### Story 1.7: Derived Stats (Credibility, Heat, Awareness, Slop Damage, Reach, Fatigue, Cope)

As a player feeling pressure,
I want my seven derived stats to update in real time from their attribute/skill/event sources, with proper clamping and per-district Heat partitioning,
So that the world's pressure on me is mechanically consistent and surface-able to HUD/UI.

**Acceptance Criteria:**

**Given** the derived-stats engine
**When** any input changes (attribute, skill, equipment, action event)
**Then** the relevant derived stat recomputes and `EventBus.derived_stat_changed(stat_id, old, new)` fires

**Given** the seven derived stats
**When** the system initializes
**Then** each is clamped (Credibility 0–100, Heat 0–100 per-district, Awareness 0–100, Slop Damage 0–100, Reach 0–100, Fatigue 0–100, Cope 0–100), each formula matches FR78

**Given** Heat as a per-district stat
**When** any consumer queries `RPGCore.get_heat(district_id)`
**Then** the per-district value is returned independently of other districts

**Given** Cope drops below 25
**When** any skill check resolves
**Then** the −2 penalty applies per FR79; NPC Mode rolls receive an additional −3

**Given** Fatigue at any tier (Low/Medium/High/Max per FR80)
**When** the relevant gameplay surface queries
**Then** the documented modifiers apply (NPC Mode penalty + pattern-skill bonus at Max)

### Story 1.8: Save System (Day-Boundary Autosave + Key Events) and Ironman Mode

As a player whose consequences stick,
I want the game to autosave at day boundaries and key events, with optional Ironman mode for permanent commitment,
So that my decisions matter and I can choose between safety-net or no-second-chances pacing.

**Acceptance Criteria:**

**Given** a player at midnight in-game (or a forced sleep-advance commit)
**When** the day-boundary trigger fires
**Then** the SaveSystem serializes WorldState as `SaveGameV{N}` to `user://saves/save_{slot}.res` (binary in release, `.tres` in dev)

**Given** any key event (faction-standing transition, ending trigger, capture/escape resolution, district transition)
**When** the event fires
**Then** an autosave is committed with the relevant key-event tag

**Given** Ironman mode is enabled
**When** the player attempts a save outside sleep-boundary
**Then** the save is rejected; only midnight autosave persists, in-place overwrite, no recovery UI

**Given** a corrupted save
**When** the player tries to load it
**Then** "Recover from yesterday's autosave?" UI appears, falls back to most-recent valid file, and the failure is logged with the full save dump for bug filing

**Given** the day-boundary autosave on minimum-spec hardware
**When** the save commits
**Then** total time is <3s (NFR9)

### Story 1.9: Schema Versioning + Migrations

As the solo developer shipping multiple builds,
I want save format versioned with mandatory migrations and a frozen-reference-saves CI check at EA prep,
So that no save-schema bump silently drops player data.

**Acceptance Criteria:**

**Given** a SaveGame schema bump from V{N} to V{N+1}
**When** a save is loaded
**Then** the SaveSystem runs the registered migration `V{N} → V{N+1}` and writes the migrated save back; missing migration = release blocker

**Given** the historical-saves test suite
**When** CI runs
**Then** each frozen reference save (one per shipped schema version) round-trips through the current code without data loss

### Story 1.10: Balance.tres + Magic-Number Enforcement

As the solo developer maintaining this codebase long-term,
I want all magic numbers (DC tables, threshold values, week tick budget, all balance numbers) routed through `Balance` resource, with a code-review checklist that fails PRs containing hardcoded numbers in code,
So that tuning is a designer activity, not a code activity, and no number is ever buried in a script (architecture locked rule 10).

**Acceptance Criteria:**

**Given** `Balance` autoload
**When** any subsystem needs a tunable number (DC threshold, time slot length, subscription cost, talent multiplier, etc.)
**Then** it reads from `Balance.<key>` and never declares the value as a literal

**Given** a CI lint pass
**When** code is scanned for magic-number patterns in `src/`
**Then** offending lines are flagged in PR comments per the AI agent code review checklist (architecture §7.3)

**Given** a save+load cycle and a Balance change
**When** the player reloads
**Then** the new balance values apply (Balance is not save-state)

### Story 1.11: Default Control Scheme + Rebindable Bindings

As a player choosing my input,
I want the default control scheme bound at launch (WASD+mouse, F5 quicksave, T sleep, etc.) and every action remappable via Settings > Controls,
So that my hands and my engine agree on what each key does.

**Acceptance Criteria:**

**Given** a fresh install
**When** the player launches
**Then** the default scheme from FR136 is active and every key is functional in its mode-appropriate context

**Given** Settings > Controls > Keyboard
**When** the player remaps any action
**Then** the binding persists across sessions, conflicts are flagged ("already bound to..."), and Reset-to-Default + Clear-All buttons work

**Given** mode-switching (Combat / Dialogue / Investigation / Exploration)
**When** the mode changes
**Then** the appropriate per-mode binding set engages (FR137, FR138, FR139)

### Story 1.12: Persistent Ambient HUD Frame (Minimal Default)

As a player situated in the world,
I want a persistent always-visible HUD with top-left district Heat indicator and top-right day/time slot + date — and nothing else by default,
So that I always know where I am and what time it is, but the HUD never narrates the experience for me.

**Acceptance Criteria:**

**Given** any non-cinematic gameplay scene
**When** the scene loads
**Then** the persistent HUD shows Heat indicator (top-left, color-coded per FR37) and DaySlotHUD (top-right, day# + DOW + 4-slot indicator + current slot highlighted)

**Given** an on-demand HUD button press
**When** the player presses C / B / M / I / J (or War Room key when Stage 3+)
**Then** the corresponding screen overlays without disrupting persistent HUD state

**Given** a contextual moment (dialogue, skill-check prompt, internal voice, combat BODY indicator, evidence notification, Receipts capture)
**When** the moment fires
**Then** the contextual element renders per FR148 and dismisses cleanly

**And** no progression toasts ever appear ("Achievement Unlocked!", "Quest Complete!", "Skill Up!" all FORBIDDEN per UX-DR126)

---

## Epic 2: Day Cycle & Survival Loop

A player can live a day in slots, snooze (and lose Morning), spend slots on Investigation/Publication/Combat/Social/Maintenance/Cover/Rest, sleep to advance the world, pay monthly bills, cancel subscriptions (with retention ritual + Awakening tick + Feed flag), feel the slop economy bleed them dry, and recover Cope on a genuine off-day.

### Story 2.1: WorldClock + Slot System

As a player whose time is finite,
I want a WorldClock autoload that owns in-game time as integer minutes since campaign start, deriving day / day-of-week / four-slot calendar (Morning / Afternoon / Evening / Night),
So that every gameplay system consumes a single source of truth for time.

**Acceptance Criteria:**

**Given** a fresh save
**When** WorldClock initializes
**Then** time = 0 minutes, day = 1, slot = Morning

**Given** any time-advancing action (slot-spend, snooze, sleep)
**When** the action commits
**Then** WorldClock advances by the configured minute count (read from `Balance.day_cycle`), `EventBus.day_advanced`, `EventBus.slot_changed`, and (if applicable) `EventBus.day_boundary_crossed` fire

**Given** the WorldClock state
**When** any consumer queries `WorldClock.current_slot()` or `current_day()` or `day_of_week()`
**Then** the values match the underlying minute count

**Given** a save+load cycle
**When** the save reloads
**Then** time persists exactly

### Story 2.2: Snooze Costs Morning Slot (Silent Tutorial)

As a Wageworker hitting snooze,
I want my morning slot silently disappearing the moment I press snooze,
So that the game's first system lesson lands without any text explaining it (FR33, NFR13 tutorial-without-text).

**Acceptance Criteria:**

**Given** the alarm scene in Slopside Apartment morning
**When** the player presses Snooze
**Then** the morning slot is consumed (slot_changed → Afternoon), no text overlay narrates this, and the player wakes up in Afternoon with the day visibly advanced

**Given** the player presses "Get Up" instead
**When** they exit the alarm scene
**Then** the morning slot remains and is consumable

### Story 2.3: Action Slot Spend Engine

As a player making choices in my day,
I want every action slot spend to route through a single pathway (Investigation / Publication / Combat / Social / Maintenance / Cover / Rest), each with documented effects (slot consumption, derived-stat impact, EventBus events),
So that downstream systems (Cope, Heat decay, Loyalty) react consistently.

**Acceptance Criteria:**

**Given** the slot-spend engine
**When** the player commits a slot of type T
**Then** WorldClock advances one slot, the type-specific effects apply (e.g., Cover work pays paycheck portion + decreases Heat decay debt; Rest restores Cope + advances no work), and `EventBus.slot_spent(type, context)` fires

**Given** the player has 0 remaining slots in a day
**When** they attempt a non-Sleep action that consumes a slot
**Then** the action is rejected and the player is prompted to sleep or accept the consequence

**Given** Rest as the slot type with no investigation/publication/op committed today
**When** sleep commits
**Then** Cope fully restores; otherwise Cope partial-restores per FR34

### Story 2.4: Subscription Cancellation Ritual (Cross-System Event)

As a Wageworker awakening,
I want cancelling a subscription to trigger a multi-stage retention dialog (20% discount → tell-us-why → match competitor) ending in an Awakening tick + Feed dossier flag + 1-in-game-hour delay before "anti-subscription extremism" Feed segment airs,
So that shedding the slop economy IS the awakening (FR104, FR106, NFR48 satire signature).

**Acceptance Criteria:**

**Given** the BillsScreen on Apartment Laptop
**When** the player clicks Cancel on a subscription
**Then** retention Stage 1 opens ("20% discount?") with two-step confirmation; Stage 2 follows ("tell us why" with optional open text); Stage 3 follows ("match competitor pricing")

**Given** the player commits cancellation through all three stages
**When** the final commit fires
**Then** an artificial 2–3s loading spinner plays (satire), the cancellation stamp animates per UX-DR131, `RPGCore.advance_awakening("subscription_cancelled:" + sub_id)` fires, the Feed dossier flag is added via `EventBus.faction_dossier_flag(feed, "anti_subscription")`, and within 1 in-game hour a Feed news segment "anti-subscription extremism" surfaces in environmental Feed contexts

**Given** the player aborts at any retention stage
**When** they back out
**Then** the subscription remains active and no flags are set

### Story 2.5: Monthly Bills + Auto-Deduct on Sleep

As a Wageworker with rent and slop subscriptions,
I want monthly bills (Rent, SloppFlix, McXyon's DeliverEasy, FeedGram Premium, GnoyGym, FeedBoost Supplements, optional vehicle insurance, optional debt servicing) auto-deducted on sleep at month-rollover,
So that the slop economy bleeds me dry without me having to engage with it (FR103, FR105).

**Acceptance Criteria:**

**Given** sleep advance crosses the month boundary
**When** the auto-deduct fires
**Then** each active subscription debits the player wallet from `Balance.subscription_costs.<sub_id>` and the rent line item debits from `Balance.rent_per_homebase_stage.<stage>`

**Given** the player wallet is insufficient
**When** auto-deduct attempts to debit
**Then** the missing amount accrues as Vault dossier weight per FR103 (debt servicing) and `EventBus.bill_unpaid(item, amount)` fires

**Given** `EventBus.bill_unpaid` fires
**When** the player next opens the BillsScreen
**Then** the overdue item is visually flagged (red overdue marker + overdue amount) and a non-blocking "Overdue: [bill name]" notice renders at the top of the screen
**And** this stub notice is replaced by Epic 8's full stage-transition consequence (eviction warning, homebase pressure) — the notice must be observable at Vertical Slice without Epic 8

### Story 2.6: Cope and Fatigue Tick + Genuine Off-Day Recovery

As a player feeling worn down,
I want Fatigue to accumulate during Xyoner-confirmation actions and reset on extended rest, and Cope to drop during overwork and only recover on a genuine off-day at homebase (no investigation/publication/ops),
So that the rhythm of resistance work has a real cost and benefit (FR79, FR80, FR81).

**Acceptance Criteria:**

**Given** any slot-spend matching the Fatigue input list (Xyoner-space presence, NPC Mode rolls, etc.)
**When** the slot commits
**Then** Fatigue increments per `Balance.fatigue_per_action`

**Given** Cope's daily debt accumulates from action types tagged "high-cost" (op, dialogue-as-combat, contradiction)
**When** sleep advances
**Then** Cope partial-restores per FR34; if the day was a genuine off-day (Rest slot used, no high-cost actions), Cope fully restores

**Given** Fatigue at any tier (Low/Med/High/Max)
**When** any skill check fires
**Then** the documented modifier applies (Low: full NPC Mode + slow recognition; Max: pattern +5, NPC Mode −6, "talks crazy" tag spreads via Reputation Web)

### Story 2.7: Job Quitting + Alt-Income Sources

As a Wageworker who's had enough of Greystone,
I want quitting the job to remove my paycheck, open my Afternoon slot fully, and require alt income (network payments / pirate broadcast monetization / seized Xyoner money) to cover rent,
So that quitting becomes a major awakening milestone with real consequence (FR36, FR164).

**Acceptance Criteria:**

**Given** the player at Greystone with the option to quit
**When** they commit the quit
**Then** the paycheck stops, the Afternoon slot frees up for any spend type, `EventBus.job_quit` fires, and Awakening Track advances

**Given** active alt-income sources
**When** the Quartermaster recruit / Handler relationship / pirate broadcast / market sales tick
**Then** money credits the player wallet per `Balance.alt_income_rates.<source>`

### Story 2.8: Slop Damage Track

As a player healing with slop in combat,
I want every slop heal to instantly restore BODY but accumulate Slop Damage on a separate track, and Slop Damage to drift my BODY/MIND attributes downward and reduce Cope over time, with visible character-art changes in homebase mirror,
So that the satirical "free heal" has a real long-term cost (FR20, FR106).

**Acceptance Criteria:**

**Given** a slop-heal action in combat
**When** the heal applies
**Then** BODY restores per the food's heal value AND Slop Damage += `Balance.slop_damage_per_heal.<food_id>`

**Given** Slop Damage at level >= threshold (per `Balance.slop_damage_thresholds`)
**When** time advances on sleep
**Then** BODY/MIND attribute drift accumulates and the homebase mirror sprite-set reflects the deterioration tier

---

## Epic 3: Combat (Hotline Miami DNA)

A player can engage in lethal real-time top-down combat where stats modify parameters (never invincibility), die-and-restart-encounter in <0.5s with world-state persistence, or get captured and choose YIELD vs ATTEMPT ESCAPE. The Faction Build Counter-System reads their build and dispatches counter-tactics. Signature weapons let satire shape combat tactics.

### Story 3.1: EncounterDirector + Snapshot/Restore

As a player dying in a lethal encounter,
I want the encounter to restart in <0.5s from the encounter-entry snapshot — preserving world state outside the encounter (broken doors, evidence found, corpses),
So that combat is lethal but not punishing-by-save-loss (FR14, FR155, UX-DR74 restart loop ≤0.5s).

**Acceptance Criteria:**

**Given** an encounter triggers
**When** EncounterDirector receives `enter_encounter(encounter_id)`
**Then** a snapshot of relevant state (player position, NPC positions, weapon inventory, BODY/Cope, RNG seed for combat subsystem) is captured to in-memory `EncounterSnapshot` and the world clock pauses

**Given** player BODY hits 0
**When** the death scene resolves
**Then** Auto-Restart toggle (default on) restores the snapshot in <0.5s on min-spec hardware; the death screen renders with [R] Restart [L] Load [Q] Quit otherwise

**Given** an encounter resolves successfully (kill / yield / escape)
**When** the resolution commits
**Then** the snapshot is discarded, world state advances, dossier updates schedule per OPSEC delay, and `EventBus.encounter_resolved(outcome)` fires

**Given** the player tries to save during an encounter
**When** the save attempt fires
**Then** it is deferred until encounter resolution (encounter-restart is separate from save state per FR155)

### Story 3.2: Stat-Modulated Combat Parameters

As a player whose build matters,
I want BODY, Gymmaxx, Hands, and Ghost Mode to modify combat parameters (hit threshold, speed/dodge, damage/disarm, stealth first-strike) without ever granting invincibility,
So that progression feels mechanical not numerical (FR16).

**Acceptance Criteria:**

**Given** a player with attribute/skill values
**When** combat starts
**Then** BODY raises hit threshold per `Balance.combat.hit_threshold_per_body`; Gymmaxx raises move speed and dodge window per `Balance.combat.gymmaxx_speed_curve`; Hands raises melee damage and disarm chance; Ghost Mode enables a one-shot stealth first-strike multiplier on the encounter's first attack

**Given** any combat parameter computation
**When** the value would reach "invincible" (no possible hit)
**Then** the value is capped per `Balance.combat.invincibility_cap` (currently disallowed; permanent guard)

### Story 3.3: Capture Mechanic — YIELD vs ATTEMPT ESCAPE

As a player out of options at BODY=0,
I want the choice between YIELD (guaranteed capture, GUT check minimizes intel leak) and ATTEMPT ESCAPE (GHOST + Gymmaxx check, district Heat penalty on fail),
So that defeat is a choice and the consequence is trackable (FR17).

**Acceptance Criteria:**

**Given** player BODY hits 0 and the encounter is Tier ≤ Capture-Op
**When** the Downed UI surfaces
**Then** F = YIELD prompt and Shift = ATTEMPT ESCAPE prompt render

**Given** player commits YIELD
**When** the GUT check fires
**Then** capture is guaranteed; the GUT check determines how many `InterrogationReport`s seed the Player Dossier per `Balance.combat.yield_intel_curve`

**Given** player commits ATTEMPT ESCAPE
**When** the GHOST + Gymmaxx check fires
**Then** success continues encounter resolution per fight terms; failure spikes district Heat per `Balance.combat.escape_fail_heat_penalty`

### Story 3.4: Captured-State Save + Escape Gameplay

As a captured player,
I want my captured state to be a save-eligible substate so I can sleep/quit and return to attempt escape via sneak/dialogue/contact-broadcast/Dead-Man-Switch later,
So that capture is a gameplay loop, not a fail-state (FR18, FR156).

**Acceptance Criteria:**

**Given** captured state in WorldState
**When** the player saves and quits
**Then** the next load restores the captured-state scene with all four escape vectors available

**Given** an escape vector resolves successfully
**When** the resolution commits
**Then** the player is restored to map at the captured-from district (or off-map drop point per scenario), and the captured-state flag is cleared

### Story 3.5: Weapon Inventory + Five Weapon Categories

As a player choosing how to fight,
I want melee / non-lethal / ranged-lethal / thrown-trap / signature weapon categories with per-weapon stats (damage, range, Heat impact, special effects) all data-driven from `Balance`,
So that weapon choice is meaningful and balanced (FR22, FR23, FR24, FR25, FR26).

**Acceptance Criteria:**

**Given** the weapon definitions
**When** the data loads from `src/combat/data/weapons.tres`
**Then** every weapon listed in FR22–FR26 is present with its stats

**Given** a weapon equipped in main hand or off hand
**When** the player attacks
**Then** the weapon's damage/range/Heat impact apply per `Balance.weapons.<weapon_id>`

**Given** ranged-lethal weapons (suppressed pistol, standard pistol, shotgun, SMG, sniper rifle, zip gun)
**When** any are fired
**Then** Heat spikes massively per `Balance.weapons.ranged_lethal_heat_spike`

### Story 3.6: Six Signature Weapons + Satirical Tactical Effects

As a player wielding the signature satire,
I want Evidence Brick, Slop Bag, Megaphone, Signal Jammer, Camera Flash, and Fake ID Packet each with their distinct tactical effect (stuns, distractions, defection chance, jamming, blinding, identity confusion),
So that the game's satirical voice expresses through combat itself (FR26).

**Acceptance Criteria:**

**Given** Evidence Brick equipped
**When** thrown at a Gnoym
**Then** the Gnoym is stunned 4s and turns/flees; thrown at Cage, Cage is distracted 2s

**Given** Megaphone equipped + Yap Game / Clout skill check
**When** activated against Gnoy-tier enemies
**Then** chance to hesitate / defect / flee scales with the skill check per `Balance.weapons.megaphone_defection_curve`

**Given** Signal Jammer activated
**When** Cage tries to call backup
**Then** backup is suppressed for 30s

**Given** Camera Flash activated
**When** in cone-of-effect
**Then** targets are blinded 4s AND a Receipts evidence item is captured to inventory

**Given** Fake ID Packet thrown into a Cage cluster
**When** the packet activates
**Then** NPCs spend ~10s verifying each other's identity before resuming aggression

### Story 3.7: Combat Engagement Tier System

As a player progressing through the game,
I want combat encounters tagged by tier (Routine / Operative / Capture-Op / Boss Phase / Endgame Set-Piece) with appropriate AI difficulty and music intensity routing,
So that escalation is legible (FR27, FR161).

**Acceptance Criteria:**

**Given** an encounter definition
**When** spawned
**Then** the tier tag drives AI archetype selection from `Balance.combat.tier_ai_pool.<tier>` and music routing to the appropriate `MusicDirector` context

**Given** Boss Phase or Endgame Set-Piece tier
**When** the encounter starts
**Then** the special-case path stays within `EncounterDirector` (no separate code path; locked rule 6 spirit)

### Story 3.8: Faction Build Counter-System (Combat Side)

As a player whose build is being read,
I want the Cage Dossier classification (Ghost / Broadcast / Hands / Grifter / Mixed / Unknown) to dispatch counter-tactics into combat (thermal sensors against Ghost, ranged-only squads against Hands, etc.) with a documented latency,
So that the world adapts to my play (FR19, FR190).

**Acceptance Criteria:**

**Given** a Player Dossier classification of "Ghost"
**When** a Cage encounter spawns at OPSEC-delayed timeline
**Then** thermal sensors are present per `Balance.combat.counter_tactics.ghost`

**Given** classifier latency (OPSEC delay)
**When** the player switches build mid-game
**Then** counter-tactics lag the build switch by `Balance.dossier.opsec_delay_days` × OPSEC modifier

**Given** the classifier rolling-window evaluation
**When** profiled on min-spec hardware
**Then** classification completes <100ms (NFR11)

### Story 3.9: Sound-as-Gameplay (Combat Footsteps + Music Threat-Tier)

As a player relying on audio,
I want enemy footsteps audible before they're visible and the combat music palette signaling threat tier — both with subtitle / visual-indicator alternatives for hearing-impaired,
So that stealth and combat work as audio games with full accessibility (FR15, FR177, NFR47-side).

**Acceptance Criteria:**

**Given** an enemy NPC moving in audible range but outside visible range
**When** their footsteps audio plays
**Then** the audio routes through SFX_World bus, attenuates by distance, and a visual footstep indicator option (per UX-DR101) shows direction-tells when enabled

**Given** combat tier change
**When** the music routes
**Then** the `MusicDirector.set_combat_intensity(tier)` adjusts stem layering accordingly

### Story 3.10: Combat Difficulty Tuning (Lethal / Balanced / Forgiving + Auto-Restart)

As a player setting my own combat threshold,
I want Combat Difficulty (Lethal / Balanced / Forgiving) and Auto-Restart on Death (default on) accessible from Settings, both preserving the <0.5s restart loop,
So that the Hotline-Miami feel is preserved while accessibility players can engage (FR142, FR145, UX-DR108).

**Acceptance Criteria:**

**Given** Settings > Accessibility > Combat Difficulty slider
**When** the player sets a tier
**Then** `Balance.combat.difficulty_tiers.<tier>` modifies enemy damage output and player hit-threshold (without removing one-hit-death risk on Lethal)

**Given** Auto-Restart on Death = on
**When** the player dies
**Then** the encounter restarts immediately without surfacing the death screen, in <0.5s on min-spec

---

## Epic 4: Equipment & Crafting

A player can equip 15 slots from 5 quality tiers, hit set bonuses for outfit combinations, and unlock crafted Resistance gear via the IRL Build skill or a Crafter recruit.

### Story 4.1: 15-Slot Equipment System

As a player gearing up,
I want a 15-slot equipment loadout (Head, Face, Neck, Shoulders, Chest, Wrist, Hands, Waist, Legs, Feet, Back, Accessory 1, Accessory 2, Main Hand, Off Hand) with slot validation, equip/unequip flows, and stat application,
So that gear is mechanically present in every system that reads stats (FR28, FR31).

**Acceptance Criteria:**

**Given** the equipment system
**When** the player drags an item to a slot
**Then** the slot validates the item's category (e.g., Main Hand only accepts Weapon main-hand items), equips it on success, and emits `EventBus.equipment_changed(slot, item_id)`

**Given** equipped items
**When** any consumer queries `RPGCore.get_equipment_modifiers()`
**Then** the cumulative attribute / skill / Heat modifiers sum correctly with unique abilities exposed per item

### Story 4.2: 5 Quality Tiers + Tier-Specific Heat Penalty

As a player choosing my gear,
I want the 5 quality tiers (Gnoy-grade / Standard / Underground / Resistance-crafted / Xyoner-seized) with appropriate stat magnitudes and the Xyoner-seized tier raising carrying Heat,
So that better gear has appropriate cost (FR29).

**Acceptance Criteria:**

**Given** the item definitions in `src/rpg/data/equipment.tres`
**When** the data loads
**Then** every item is tagged with one of the 5 tiers and the tier modifiers apply (Xyoner-seized tier raises carrying Heat per `Balance.equipment.xyoner_carrying_heat`)

**Given** an equipped Xyoner-seized item
**When** the player enters a district with Heat tracking
**Then** the carrying-Heat penalty applies in addition to the equipment's stat bonuses

### Story 4.3: Set Bonus Detection

As a player wearing a thematic outfit,
I want set bonuses (Full Civilian / Full Tactical / Hidden Operator / Press Cover / Underground Standard) automatically applied when the equipment combination matches the set rules,
So that outfit choice is a meaningful build axis (FR30).

**Acceptance Criteria:**

**Given** the set bonus rules in `src/rpg/data/set_bonuses.tres`
**When** equipment changes
**Then** the system evaluates which sets are now active and applies the documented bonuses (e.g., Full Civilian: +3 Normie Cosplay, +2 NPC Mode, +20% Heat decay)

**Given** an active set
**When** a single piece is removed breaking the set
**Then** the bonuses are removed and a UI feedback signal fires

### Story 4.4: Materials Crafting System

As a player with the IRL Build skill or a Crafter recruit,
I want to craft Resistance-tier gear from materials (looted, scavenged, purchased, dead-dropped),
So that Resistance-crafted tier is reachable through play, not just NPC vendors (FR165).

**Acceptance Criteria:**

**Given** a recipe in `src/rpg/data/recipes.tres`
**When** the player has materials + meets the IRL Build skill threshold (or has a Crafter recruit assigned)
**Then** they can craft the item; materials debit; item enters inventory; `EventBus.item_crafted` fires

**Given** a Crafter recruit assigned to a homebase station
**When** time advances
**Then** passive crafting yields per `Balance.recruitment.crafter_passive_rate`

### Story 4.5: Equipment / Inventory Screen

As a player managing my loadout,
I want a paper-doll inventory screen with drag-equip, right-click remove, hover-detail, and full keyboard navigation in both Xyoner sleek mock-up and Resistance hand-drawn outline themes,
So that gearing up is fast and accessible (UX-DR54, UX-DR111).

**Acceptance Criteria:**

**Given** the Inventory/Equipment screen open
**When** the player drags an item to a slot
**Then** equip resolves per Story 4.1 with appropriate feedback animation

**Given** keyboard-only navigation
**When** the player Tabs through slots and presses E to equip / R to remove
**Then** the screen functions identically to mouse use

**Given** the active scene's theme (Apartment = Resistance, Greystone = Xyoner)
**When** the inventory opens
**Then** the appropriate theme variant renders

---

## Epic 5: Investigation UI (Three Layers) — The Truth Paradox

A player can investigate using a diegetic Physical Board, prepare a publication via the Dossier Interface, and ruminate on Thought Cabinet threads that reframe existing evidence as Awakening rises. They feel the Truth Paradox: more correct = more dangerous.

### Story 5.1: Evidence System — Item Definitions + Inventory Persistence

As a player accumulating evidence,
I want evidence to be a first-class data type (id, surface form, source, related entities, capture timestamp, Cage-planted flag) stored in WorldState, seizable on capture but with Ghost Protocol remote-backup hook,
So that every investigation surface reads the same source of truth (FR21, FR74).

**Acceptance Criteria:**

**Given** an `Evidence` Resource schema
**When** an evidence item is created (combat scavenge, dialogue commit, Camera Flash capture, dead-drop)
**Then** it persists to WorldState with full metadata

**Given** capture with no Ghost Protocol skill
**When** the capture commits
**Then** evidence on player's person is seized (flagged `seized=true`); Ghost Protocol unlocked = remote-backup hook restores after escape

**Given** a Cage-planted evidence flag set on an item
**When** any UI reads the item
**Then** the flag is internally tracked but NEVER surfaced to the player UI directly (planted-evidence is ambiguous per FR10)

### Story 5.2: Physical Board — Pinning + Empty State

As a player working a case,
I want a diegetic corkboard scene in my Apartment where I can pin evidence cards (drag-drop from inventory or via click-source-then-target accessibility alternative), with a Resistance-handwritten empty-state note, and the board scaling capacity with homebase stage,
So that investigation is a tactile space, not a system menu (FR4, UX-DR60, UX-DR107).

**Acceptance Criteria:**

**Given** the Apartment Physical Board scene
**When** the player walks to the corkboard and presses E
**Then** the board scene takes over the screen, pause-the-world (UX-DR125 scene-as-screen rule)

**Given** the player drags an evidence item from inventory
**When** they drop it on the board
**Then** an EvidenceCard renders at the drop position, persists in WorldState, and the corkboard layout scrolls if overcrowded

**Given** the empty board on first entry
**When** the scene renders
**Then** a Resistance-handwritten note ("Nothing pinned yet.") shows

**Given** homebase stage progression
**When** stage advances to 4 (Distributed Cells)
**Then** distributed-board behavior engages per FR4

### Story 5.3: Connection Mechanic — Drag String + 3-Outcome Skill Check

As a player connecting dots,
I want to drag a red string between two evidence cards, fire a skill check ([X] Fatigue / Rabbit Hole / Lore Depth / Glowie Sense as appropriate), and see one of three outcomes (Critical Success: confirmed + hidden context revealed; Standard Success: confirmed; Fail: dotted line, publishable at Credibility penalty), with wrong connections never explicitly told to me,
So that the Truth Paradox emerges from doubt (FR9, FR10, UX-DR31, UX-DR130).

**Acceptance Criteria:**

**Given** the Physical Board with two pinned cards
**When** the player drags a string from card A to card B (or via click-source-then-target alt)
**Then** within <200ms the appropriate skill check fires, an outcome is determined, and the ConnectionString renders in the corresponding state (Verified solid red / Probable dashed / Uncertain thin)

**Given** the connection committed in any state
**When** the player publishes from this connection
**Then** a Credibility penalty applies if Probable / Uncertain per `Balance.investigation.connection_credibility_penalty`

**Given** a wrong connection (drawn against a Cage-planted card)
**When** the connection commits
**Then** no UI signal informs the player — the connection state surfaces only at Awakening level milestones via reframing (Story 5.7)

### Story 5.4: Dossier Interface — Cross-Reference + Stamp + Publication Framing Matrix

As a player preparing to publish,
I want a desk-style Dossier scene from the Physical Board with the PublicationFramingMatrix (Platform × Framing × Audience selectors with live Credibility/Heat preview + faction standing deltas + Inner Voice slot), two-step commit, and typewriter-stamp ceremony on confirm — with no undo,
So that publication is a deliberate, gravity-bearing act (FR5, FR6, FR74, UX-DR34, UX-DR61, UX-DR82).

**Acceptance Criteria:**

**Given** a connection or evidence cluster selected on the Physical Board
**When** the player chooses "Prepare for Publication"
**Then** the Dossier scene opens with the cluster on the desk

**Given** the PublicationFramingMatrix
**When** the player adjusts any selector
**Then** Credibility delta + Heat delta + faction standing deltas update in real time, modified by the relevant skill check (visible DC + Yap Game / Doxcraft / etc.)

**Given** the player commits two-step ("Publish Draft?" → "Final Confirm")
**When** the typewriter-stamp ceremony plays (UX-DR82)
**Then** the publication persists immutably (cannot un-publish), Credibility / Heat / faction-standing deltas apply, `EventBus.evidence_published(...)` fires for Politburo input + Reputation Web propagation

### Story 5.5: Thought Cabinet — Mental Threads + Time-Cost Processing

As a player ruminating,
I want a Thought Cabinet scene where I can slot Inner Voice thoughts that cost action slots to research and yield conclusions reframing existing evidence or unlocking dialogue lines,
So that internal investigation has a gameplay surface (FR7, UX-DR62).

**Acceptance Criteria:**

**Given** the Thought Cabinet scene
**When** the player slots a thought
**Then** time-cost processing engages (e.g., 2 day-slots), with the slot consumed when the player uses an Investigation slot tagged "rumination"

**Given** a thought completes processing
**When** the resolution commits
**Then** the conclusion attaches to relevant evidence (reframing flag) and unlocks any gated dialogue lines via WorldState

**Given** thoughts persist across day boundaries
**When** the player saves and loads
**Then** in-progress thoughts retain their progress

### Story 5.6: Connection Skill-Check Animation + Stamp Grammar

As a player getting feedback,
I want each connection skill check to render in <200ms with a scale-up + dice-roll number flip + outcome stamp animation (Verified +5° / Probable 0° / Uncertain −5° rotation), reusing the same stamp grammar across publication / subscription / thought completion,
So that satisfying feedback creates investigation rhythm (UX-DR130, UX-DR131).

**Acceptance Criteria:**

**Given** a connection commit
**When** the skill check fires
**Then** within <200ms the badge scales 0.5→1.0 + 3–4 dice-flip number rolls + outcome stamp lands with documented rotation, accompanied by dice-rattle + stamp-press SFX

**Given** subscription cancellation / publication commit / thought research completion
**When** their respective stamps fire
**Then** they reuse the stamp grammar (scale + rotation + shadow + sound) with type-specific visuals

### Story 5.7: Awakening Reframes Existing Evidence

As a player whose consciousness shifts,
I want documents I filed at Awakening 1 to mean something different at Awakening 5/7 — surfaced via bracketed addenda in Thought Cabinet and via reading-tooltip surfacing on previously-readable Xyoner symbols,
So that Truth Paradox legibility lands and replays feel materially different (FR8, NFR14, NFR18, UX-DR62, UX-DR96).

**Acceptance Criteria:**

**Given** Awakening level crosses a milestone (5 / 7 / 10)
**When** `EventBus.awakening_level_changed` fires
**Then** thoughts in Thought Cabinet show new bracketed addenda `[At Awakening 5+: ...]` and previously-locked re-interpretation flags are exposed on relevant evidence

**Given** Xyoner-symbol items in evidence
**When** Awakening crosses 5
**Then** symbol-readable tooltips become available without any UI announcement (UX-DR96 silent surfacing)

---

## Epic 6: Dialogue System

A player can have rich Disco-Elysium-tier dialogue with visible-DC / hidden-consequence skill checks; hear 24 named Inner Voices that scale with Awakening + Fatigue; drop physical evidence into conversations to unlock locked lines; route through Composure-HP boss encounters; and have every word recorded for the world.

### Story 6.1: Dialogue VM — All 9 Node Types

As a writer authoring dialogue and a developer running it,
I want the custom GDScript Dialogue VM with all 9 node types (Line / Choice / SkillCheck / InternalVoice / ItemDrop / Branch / SystemEffect / Commit / End) usable from a single code path,
So that every conversation — including Composure-HP boss encounters — uses the same VM (architecture locked rule 6, FR194).

**Acceptance Criteria:**

**Given** a `.dialog.tres` resource with all 9 node types
**When** the DialogueRunner walks the graph
**Then** each node type resolves correctly per its semantics; node resolve <50ms (NFR8 / arch perf budget)

**Given** the per-frame budget for the dialogue VM
**When** profiled during a typical dialog
**Then** total dialogue VM CPU per frame stays <1ms (architecture perf budget)

**Given** Composure-HP boss encounters
**When** the encounter starts
**Then** the same `DialogueRunner` is used with an additional `EncounterContext` subscribed; no special-case code path exists

### Story 6.2: Visible-DC / Hidden-Consequence Skill Checks in Dialogue

As a player making conversational choices,
I want every dialogue skill check to display the skill name + DC but never the consequence, with skill rolling per Story 1.3,
So that the world remains uncertain (FR55, FR167).

**Acceptance Criteria:**

**Given** a SkillCheck node in dialogue
**When** the choice is presented
**Then** the choice text shows `[Skill X/Y]` tag (e.g., `[Yap Game 14/16]`) but never an outcome-consequence string

**Given** the player selects the gated choice
**When** the skill check resolves via `RPGCore.skill_check`
**Then** the dialogue branches per outcome and the Conversation Log captures the player's exact line (Story 6.5)

### Story 6.3: 24 Inner Voices — Per-Voice Typography + Frequency Scaling

As a player's awakened consciousness,
I want 24 named Inner Voices (Rabbit Hole, [X] Fatigue, Doxcraft, Glowie Sense, Yap Game, Lore Depth, Based Talk, Rizz, NPC Mode, Ratio, Clout, Ghost Mode, Normie Cosplay, Receipts, OPSEC, Gymmaxx, Hands, Anti-Slop, IRL Build, Web, Ghost Protocol, Sneaky Links, Signal Hijack, Edit Farm) each with distinct font/weight/color/style register, frequency scaling with Awakening + Fatigue + Cope, and first-time-spoken flourish (2× scale + glow, 400ms),
So that voices are recognizable and intensity legible (FR56, FR57, FR58, UX-DR6, UX-DR32, UX-DR86, UX-DR95).

**Acceptance Criteria:**

**Given** the `VoiceProfile` resources
**When** the data loads
**Then** all 24 voices exist with their per-voice typography spec from UX-DR6

**Given** an InternalVoice node in dialogue
**When** the VM resolves it
**Then** the voice fires at frequency = base × `Balance.voices.scaling(awakening, fatigue, cope)` capped per dialog; size/intensity scale per UX-DR95 quiet/interjecting/chorus/full-chorus tiers

**Given** a voice's first-time-ever speak
**When** rendered
**Then** the 2× scale + glow flourish animates 400ms, then subsequent same-voice lines render at normal scale

**Given** Awakening 3
**When** the player has played the opening + first hours
**Then** all 24 voices have been introduced at least once (UX-DR86 target)

### Story 6.4: Item-Drop in Dialogue — Unlock Locked Lines

As a player wielding evidence in conversation,
I want to drag inventory items (photo, dossier, burner phone) into the dialogue UI and have the VM check the active node for `ItemAccepted` edges keyed to item id, routing accordingly,
So that physical evidence unlocks lines unavailable without it (FR65).

**Acceptance Criteria:**

**Given** an active dialogue with a node that has an `ItemAccepted` edge
**When** the player drags a matching item onto the NPC portrait
**Then** the VM routes to the unlocked branch and the item is consumed or marked as "shown"

**Given** an item drop with no matching edge
**When** released
**Then** the drop is rejected with no-op feedback (item returns to inventory)

### Story 6.5: Conversation Log — Append-Only + Searchable + Performance-Validated

As the world remembering my words,
I want every dialog line committed to a Conversation Log that's append-only, full-text searchable, with retrieval <50ms and gossip propagation <2s for 200+ Gnoym, accessible via the Apartment Laptop as a found artifact (not a system),
So that NPCs can quote me weeks later, Cage can interrogate, Feed can edit (FR54, FR63, FR64, FR184, NFR8, UX-DR57, UX-DR127).

**Acceptance Criteria:**

**Given** a dialog Commit node fires
**When** the log appends
**Then** the entry is `{npc_id, timestamp, player_line, npc_line_id, location}` and is immutable (append-only, locked rule 5)

**Given** a search query in the Conversation Log scene
**When** the player searches
**Then** retrieval completes <50ms on min-spec for any past entry across thousands of entries (validated at VS per NFR47)

**Given** Gossip propagation across 200+ Gnoym
**When** the propagation tick runs
**Then** total time <2s on min-spec hardware

**Given** the Conversation Log opens on the Apartment Laptop
**When** the player opens the app
**Then** it reads as a chat-transcript archive with no "system log" framing — the log IS the artifact

### Story 6.6: Composure HP — Dialogue-as-Combat Encounter Context

As a player in a dialogue boss encounter (Trusted Anchor or Debt Dealer specifically),
I want multi-stage Composure HP (3–5 stages, each requiring a combo of skill check + evidence drop + framing choice), with failure repeating the stage with reduced options and total failure causing blown cover + lost evidence + Heat spike,
So that dialogue can be combat (FR61, FR62).

**Acceptance Criteria:**

**Given** the Composure-HP encounter starts
**When** the EncounterContext subscribes to the same `DialogueRunner`
**Then** Composure HP renders as a meter visible in dialogue UI

**Given** a stage requires combo (skill check + evidence drop + framing)
**When** the player fails the stage
**Then** the stage repeats with reduced options per stage rules; total failure routes to the designated graph node and triggers blown-cover + evidence-lost + Heat spike per `Balance.dialogue.boss_failure_consequences`

### Story 6.7: Conversation Log Weaponization at High Awakening

As a player whose words come back,
I want previously archived lines to gain "quoted-back-by Cage" annotations at Awakening 6+ and "evidence in interrogation" annotations at 8+, with visual highlighting (red bg) and tone shift,
So that the log darkens with my consciousness (UX-DR99).

**Acceptance Criteria:**

**Given** Awakening crosses 6
**When** the Conversation Log is opened
**Then** retroactive flags appear on archived lines that match the criteria

**Given** Awakening crosses 8
**When** the log is opened
**Then** "evidence in interrogation" annotations appear with red background and tone shift

### Story 6.8: Dialogue Authoring Pipeline — YAML→TRES Importer (EA-prep)

As a writer iterating on dialogue,
I want to author dialogue in YAML in `dialogue_source/` and have a `tools/dialogue_yaml_to_tres.gd` importer compile to `.tres` at import time,
So that writers never touch `.tres` files (mandatory pre-EA per architecture).

**Acceptance Criteria:**

**Given** a YAML dialogue source file
**When** the importer runs
**Then** a corresponding `.tres` is produced with all node types preserved + validated

**Given** an invalid YAML (missing required field, bad ItemAccepted reference)
**When** the importer runs
**Then** the build fails with a useful error pointing to the YAML line

### Story 6.9: Dialogue Interface Screen — Two-Pane + Inner Voice Chorus

As a player in conversation,
I want a two-pane dialogue interface (left: NPC portrait + name + faction sigil + relationship callout; right: dialogue text max ~70 chars/line + Inner Voice chorus + choice list) with subtle portrait micro-animations (mouth shift + blink) and choice highlight/select animations,
So that text-heavy reading remains tractable (FR148, UX-DR56, UX-DR136, UX-DR137).

**Acceptance Criteria:**

**Given** an active dialog
**When** the scene renders
**Then** layout per UX-DR56 with portrait left, text right, choices listed, Inner Voices interjecting with their typography

**Given** an NPC speaking
**When** the line plays
**Then** mouth region shifts 2–3px at inflection points and blink animates every 3–5s (UX-DR137)

**Given** a choice hover/select
**When** the input fires
**Then** 25% color overlay on hover (100ms fade) + scale 1.0→1.05 on select + fade-out (UX-DR136)

### Story 6.10: Dialogue Tiering Implementation

As a writer with finite words and a player feeling depth,
I want dialogue tiered by content type (Boss = full Disco-Elysium / Recruit Personal Quests = full personal arc / Awakening Beats = full at 1/5/10 lighter at 2–9 / Reputation Web Side Quests = pared trees / Routine Gnoym = minimal environmental flavor),
So that solo-dev word budget lands where it matters (FR66, FR169, FR188).

**Acceptance Criteria:**

**Given** the dialogue corpus
**When** content is authored
**Then** each `.dialog.tres` resource carries a `tier` tag matching one of the FR66 categories

**Given** the writing-tooling lint at EA prep
**When** content is reviewed
**Then** tier tags are validated against word-budget targets per `Balance.dialogue.tier_word_budgets`

---

## Epic 7: Three Tracking Systems

A living world tracks the player. The Cage assembles a single shared faction Dossier. The Politburo Simulation runs weekly whether the player exists or not. Individual Gnoym remember the player's exact words and gossip; when one is interrogated, their memory enters the Dossier verbatim. The Glowie may have been a recruit all along.

### Story 7.1: Standing Legal-Distinctness Contract README

As the solo developer protecting the project from US 10,926,179 (WB Nemesis patent),
I want `src/tracking/README.md` published with §5.1 Rules 1–4 verbatim, the `# DISTINCTNESS CONTRACT — see §6.1` comment header in `player_dossier.gd` listing the only allowed import (Interrogation Bridge), and the AI agent code-review checklist gating any PR touching `src/tracking/`,
So that legal distinctness is enforced at code level on every commit (FR189, FR199, NFR12, NFR43, locked rule 2).

**Acceptance Criteria:**

**Given** the repo at any commit
**When** `src/tracking/README.md` is read
**Then** it contains §5.1 Rules 1–4 verbatim, quotes GDD §Three Tracking Systems verbatim, and points to architecture §6.1

**Given** a PR touching any file in `src/tracking/`
**When** the AI agent code review checklist runs
**Then** the checklist enforces: which §5.1 Rule applies must be cited in the PR description; locked rules 2 and 12 are checked; forbidden patterns are scanned

**Given** `player_dossier.gd`
**When** opened
**Then** the `# DISTINCTNESS CONTRACT — see §6.1` comment header is present and lists `src/tracking/reputation_web/interrogation_bridge.gd` as the only allowed import from `reputation_web/`

### Story 7.2: Player Dossier — Faction-Shared, No Per-NPC Memory

As the player being watched,
I want a single shared Player Dossier owned by the Cage (no per-NPC memory inside it) containing threat axes, build classifier, known associates (recruit ids only), known operations, warrants, suspected aliases, plant flags, last-update timestamp, OPSEC delay-debt — built from operative reports / leaks / publications / informants,
So that the Cage's intel reads as a single faction file, legally distinct from a per-NPC nemesis system (FR41, FR42, FR43, FR44, §5.1 Rule 1).

**Acceptance Criteria:**

**Given** `src/tracking/player_dossier.gd`
**When** the data structure is inspected
**Then** it owns ONLY the fields listed in §5.1 Rule 1 — no per-NPC memory fields exist

**Given** a dossier update event source (operative report, leak, publication, informant report, InterrogationReport)
**When** the dossier writes
**Then** the data flows in via the appropriate single-file path (no smuggling of per-NPC quotes outside the InterrogationReport surface form)

**Given** a player with high OPSEC + Stealth talents
**When** they complete an operation
**Then** the dossier update lags by `Balance.dossier.opsec_delay_days` × OPSEC modifier (FR44 OPSEC delay)

**Given** `Balance.dossier.classifier_window_ms`
**When** the classifier runs
**Then** classification completes <100ms (NFR11)

### Story 7.3: Politburo Simulation — Independent Pure Function + Deterministic Tick

As a player whose absence still moves the world,
I want a Politburo Simulation that runs as a deterministic pure function `pure_function(prev_state, input_list, rng_seed) → (new_state, event_list)`, ticking weekly at minutes-since-campaign-start week boundaries, never reading the player-action graph directly,
So that hierarchies update whether the player acts or not (FR45, FR46, FR47, FR48, FR49, FR183, §5.1 Rule 2, locked rule 3).

**Acceptance Criteria:**

**Given** `src/tracking/politburo/politburo_sim.gd`
**When** the function is inspected
**Then** it accepts only `(prev_state, input_list, rng_seed)`, contains no file I/O, no autoload reads, and never imports `player_dossier.gd` or any subsystem outside its own module

**Given** the Politburo state at week N
**When** sleep advance crosses a week boundary
**Then** the tick runs with input_list constructed by `EventBus` subscribers that summarize player actions (`OperativeEliminated(boss_id)`, `EvidencePublished(faction_id, framing_strength)`, etc.)

**Given** identical inputs + identical seed
**When** the tick runs twice
**Then** identical (new_state, event_list) is produced — determinism test in CI (release blocker if it fails)

**Given** worst-case 100-week-deep save
**When** the tick runs on min-spec
**Then** completion time <500ms (NFR7)

**Given** `tools/replay_politburo.gd`
**When** invoked on a save
**Then** it replays from week 0 forward, asserting state equality at each tick

### Story 7.4: Politburo Outputs — Events + Network Graph + Emergent Quests

As a player checking the world,
I want each weekly tick to output 0–3 events (promotions, betrayals, blackmail moves, scandals), updated Network Graph data for the War Room, and Emergent Politburo Quests routed to the Quest System,
So that the simulation surfaces visibly through gameplay (FR47, Epic 10 quest integration).

**Acceptance Criteria:**

**Given** a Politburo tick completing
**When** event_list is non-empty
**Then** events route to `EventBus.politburo_event(event)` consumers; Network Graph data updates in WorldState; emergent quests are spawned via Epic 10 quest system

**Given** 0 events in a tick
**When** the player checks the news ticker
**Then** ambient news plays (Politburo silent week is supported)

### Story 7.5: Reputation Web — Per-Gnoym Memory + Gossip Propagation

As individual Gnoym noticing me,
I want per-Gnoym personal memory (quoted lines from conversations, rumors heard, trust level, recent shared events) with gossip propagating across the Gnoym population at simulation tick rate, isolated from the faction Dossier except via the Interrogation Bridge,
So that the world has personal memory legally distinct from faction memory (FR51, FR52, NFR8, §5.1 Rule 3).

**Acceptance Criteria:**

**Given** `src/tracking/reputation_web/`
**When** inspected
**Then** the module contains per-Gnoym memory and gossip propagation logic; the only export to outside the module is `interrogation_bridge.gd`

**Given** a player conversation commits
**When** a Gnoym is the conversation partner
**Then** their personal memory updates with the player's quoted line + context

**Given** the propagation tick across 200+ Gnoym
**When** profiled on min-spec
**Then** total time <2s (NFR8)

**Given** any code path attempting to import from `reputation_web/` into `player_dossier.gd` outside `interrogation_bridge.gd`
**When** the AI code review checklist runs
**Then** the import is flagged and the PR is blocked

### Story 7.6: Interrogation Bridge — Single Data Path Reputation Web → Dossier

As the Cage interrogating a Gnoym,
I want `src/tracking/reputation_web/interrogation_bridge.gd` to be the SINGLE function that writes a Gnoym's personal memory of the player into the Dossier as an `InterrogationReport` keyed by report id (not Gnoym identity), with the source surface form quoted-back,
So that legal distinctness is preserved at the data path level (FR53, FR63, §5.1 Rule 3).

**Acceptance Criteria:**

**Given** an interrogation event resolves on a Gnoym X
**When** `interrogation_bridge.write_report(gnoym_x, dossier)` fires
**Then** an `InterrogationReport(report_id, timestamp, surface_form, threat_axis_input)` is appended to the Dossier; the Dossier never gains a reference to gnoym_x's identity directly

**Given** any other module
**When** it tries to write per-Gnoym data into the Dossier
**Then** the AI code review checklist flags the violation

### Story 7.7: Faction Standing Ladder + Cross-Faction Interference

As a player navigating five factions,
I want each faction's standing tracked on the UNKNOWN→FLAGGED→OBSERVED→ASSET→COMPROMISED→OWNED ladder, with double-cross tests at ASSET+, cross-faction interference (Cage-Feed pre-existing rivalry, Vault never fully hostile),
So that politics has shape (FR134, FR135).

**Acceptance Criteria:**

**Given** any faction-impacting action (publication, op, dialog commit)
**When** the action commits
**Then** standing deltas apply per `Balance.faction.standing_deltas.<action_type>`

**Given** ASSET-tier standing with a faction
**When** the player encounters a double-cross test (mission gating)
**Then** the test resolves per the faction's tactical rules

**Given** Cage and Feed simultaneous standing
**When** their pre-existing rivalry mechanic fires
**Then** standing changes in one cascade asymmetrically into the other per `Balance.faction.cross_faction_rules`

### Story 7.8: War Room UI (Stage 3+ Stub at VS, Full at EA)

As a player whose homebase has reached Stage 3,
I want a War Room scene with five tabbed panels (Network Graph, Map Overlay, Live News Ticker, Heat Map, Dossier Panel) plus an Inner Ring Confidence Indicator, the Analyst recruit's flagged-connections feed, and full keyboard navigation,
So that the world's pattern becomes legible from a single command surface (FR11, FR12, FR13, UX-DR41, UX-DR63).

**Acceptance Criteria:**

**Given** Stage 3 unlocked
**When** the player walks to the War Room scene
**Then** the tabbed grid renders all five panels with current data sourced from WorldState

**Given** the Analyst recruit assigned (and their Glowie risk evaluated)
**When** their work tick fires
**Then** flagged-connection notifications appear with the appropriate trustworthiness indicator (Glowie-suspect data is flagged but not labeled overtly)

**Given** the Inner Ring Confidence calculation across published evidence + Politburo state
**When** rendered
**Then** the indicator shows `"Based on current evidence, we believe we've identified [X] of the Inner Ring with [low/medium/high] confidence"` per FR12

**Given** the VS scope
**When** the War Room scene is reached
**Then** a stub renders (skeleton tabs, placeholder data, navigation works) — full panel implementation lands at EA

---

## Epic 8: Recruitment & Homebase

A player can recruit specialists organically or via missions, build their homebase from Apartment → Office → Underground HQ → Distributed Cell Network, fill 7 specialist roles, maintain Loyalty as an ongoing resource, and lose recruits permanently to Cage raids, breaking, voluntary exit, or Glowie conversion.

### Story 8.1: Recruit Data Model + 7 Specialist Roles

As a player building a network,
I want a Recruit data model (Background, Specialty, Trust 0–100, Loyalty, Risk Profile, Breaking Point) covering all 7 specialist roles (Researcher / Broadcaster / Crafter / Medic / Quartermaster / Analyst / Handler),
So that every recruit slot in the game has consistent state (FR90, FR91).

**Acceptance Criteria:**

**Given** the recruit definitions
**When** loaded from `src/recruitment/data/recruits.tres`
**Then** every recruit has all required fields populated and a specialty matching one of the 7 roles

**Given** a recruited NPC
**When** any system queries `Recruitment.get_recruit(npc_id)`
**Then** the full property set returns

### Story 8.2: Organic Recruitment via In-Dialogue Puzzles

As a player reading a Gnoy's psychology,
I want to recruit organically by completing side-quest + in-dialogue-puzzle paths, with retry support after failure (more Credibility / new evidence / different approach), and repeated failure flagging the Gnoy in Reputation Web,
So that recruitment is a Disco-Elysium-tier challenge not a transaction (FR88).

**Acceptance Criteria:**

**Given** a recruitable NPC with their unlock-puzzle defined in dialogue
**When** the player completes the puzzle path
**Then** the recruit transitions to "Recruited" and joins the homebase

**Given** the player fails the recruitment path
**When** the dialogue closes
**Then** retry is enabled with later attempts; repeated failures flag the Gnoy in Reputation Web ("possible resistance contact attempt")

### Story 8.3: Mission-Based Recruitment via Handler/Analyst

As a player needing a specialist,
I want Handler / Analyst recruits to point me to a contact and gate the recruitment behind a trust-building task,
So that some recruits arrive via the network not the streets (FR89).

**Acceptance Criteria:**

**Given** a Handler recruit is active
**When** the player asks for a specialist (e.g., a Medic)
**Then** the Handler points to a target NPC and a trust-building task spawns in the quest system

**Given** the trust task completes
**When** the resolution commits
**Then** the contact joins as a recruit

### Story 8.4: Loyalty as Ongoing Resource

As a player managing relationships,
I want Recruit Loyalty to degrade from neglect (−2/wk no contact) / broken promises (−5 to −20) / Credibility collapse (all recruits −3) / competing offers, with high-Loyalty resistant to Cage turning and low-Loyalty risking defection / info leaks / walk-out,
So that the network has cost (FR92, FR93, FR94).

**Acceptance Criteria:**

**Given** a recruit
**When** weekly tick fires with no Social slot used on them
**Then** Loyalty -=2

**Given** a Social slot used on the recruit
**When** the slot commits
**Then** Loyalty +=`Balance.recruitment.social_slot_loyalty_gain`

**Given** Credibility collapse event
**When** it fires
**Then** all recruits Loyalty -=3

**Given** a competing-faction offer event
**When** the recruit GUT check fires
**Then** the outcome scales per `Balance.recruitment.competing_offer_curve(recruit.gut)`

### Story 8.5: Permanent Recruit Loss + Glowie Conversion

As a player who can lose people permanently,
I want recruits removable from the network via Cage raids (capture/kill), interrogation breaking (recruit feeds Dossier verbatim), defection, voluntary exit, or Glowie conversion (Cage-flipped recruit reports back),
So that the stakes are real (FR73, FR95).

**Acceptance Criteria:**

**Given** a Cage raid event resolves with capture
**When** the resolution commits
**Then** the recruit transitions to `captured` state; can break under interrogation per their Breaking Point

**Given** a recruit broken under interrogation
**When** the break resolves
**Then** the InterrogationBridge writes the recruit's player-memory to the Dossier (Story 7.6)

**Given** Cage Glowie conversion succeeds on a recruit
**When** the conversion commits
**Then** the recruit's status changes to `glowie_undetected`; they continue appearing in homebase but feed Dossier on player; Glowie Sense skill checks can detect

### Story 8.6: 4-Stage Homebase Evolution

As a player whose operation grows,
I want the homebase to evolve through 4 stages (Apartment Awakening 1–2 → Office cover business 3–4 → Underground HQ 5–7 → Distributed Cell Network 8+) with each transition gated by resources + recruits + narrative beats,
So that progression has a spatial signature (FR96, FR97).

**Acceptance Criteria:**

**Given** the homebase stage data
**When** the player meets the gating requirements (Awakening level, recruit count, resources, narrative-beat completion)
**Then** stage advance becomes available; commit fires `EventBus.homebase_stage_advanced(new_stage)` and a new homebase scene replaces the prior

**Given** Stage 4 (Distributed Cells)
**When** Cage raids hit
**Then** raids only impact one cell per Stage 4 cell-isolation rules (FR95)

### Story 8.7: Diegetic Homebase Evolution (Ambient Sound + Visual + Recruit Presence)

As a player feeling the homebase grow,
I want each stage's ambient sound (empty-flat-echo → traffic → resistance-operation hum → variable-per-cell), visual density (sparse → semi-active → war-room operational → distributed), and recruit presence (cosmetic NPCs with idle dialogue) to all reflect stage progression,
So that the homebase tells the story of the resistance (FR98, UX-DR125).

**Acceptance Criteria:**

**Given** each stage scene
**When** loaded
**Then** the ambient audio bus mix matches the stage (per `Balance.homebase.stage_ambient`); the scene's visual density assets match the stage

**Given** assigned recruits at homebase
**When** the player walks the homebase
**Then** cosmetic recruit NPCs perform their specialist-work animations and have idle dialogue available on E-press

### Story 8.8: NPC / Recruit Management Screen

As a player tracking my network,
I want a roster screen (portraits + relationship state + location + last-seen + gifts/assignments/loyalty visual + status flag alive/captured/defected/fled), keyboard-navigable,
So that I always know where my people are and how they feel (UX-DR79).

**Acceptance Criteria:**

**Given** the Recruit Management screen
**When** opened
**Then** all current recruits render with all listed properties

**Given** keyboard nav
**When** the player Tabs through the roster
**Then** focus moves cleanly between recruit cards

---

## Epic 9: World & Districts

A player can navigate 12 districts, each with its own faction-dominance flavor, per-district Heat tracking, Heat-decay during downtime, sneak routes that only appear above Ghost Mode threshold, and a progressive map UI that reveals more layers as Awakening rises.

### Story 9.1: District Scene System + Streamed Transitions

As a player traveling between districts,
I want each district as a self-contained scene with streamed transitions (loading screens acceptable) and `NavigationAgent2D`-baked navigation regions per district,
So that the world is bounded but feels populated (FR179, FR186).

**Acceptance Criteria:**

**Given** a district scene
**When** loaded
**Then** it owns its own NavigationAgent2D regions, ambient SFX bus mix, district-tagged NPCs, and Heat state

**Given** the player crosses a district boundary
**When** the streamed transition fires
**Then** the destination scene loads with a loading screen, the source scene unloads, and Heat state is preserved per-district

### Story 9.2: Per-District Heat Tracking + Decay

As a player rotating across districts,
I want Heat tracked independently per district with decay during downtime slots (cover work, social, rest),
So that district rotation is a real strategy (FR37, FR40, FR122).

**Acceptance Criteria:**

**Given** a Heat-raising action in district X
**When** the action commits
**Then** Heat[X] increments per `Balance.heat.action_heat_deltas` and `EventBus.heat_changed(district, old, new)` fires

**Given** downtime slot commit
**When** sleep advances
**Then** all districts Heat decays per `Balance.heat.decay_curve` modulated by recent activity

### Story 9.3: 12-District Definitions + Tier Tags

As the world having shape,
I want all 12 districts defined as Resources (Tier 1: Slopside, Cubicle Belt, Plaza, Vault District, The Garden; Tier 2: Pulpit Quarter, University Row, Slop Belt, Civic Center, The Hollow, The Outskirts; Tier 3: The Compound; Hidden: Cage Black Sites, Inner Ring Private Locations) each with sub-areas, faction dominance, and boss residence flags,
So that the world's structure is complete (FR107–FR121).

**Acceptance Criteria:**

**Given** the district definitions
**When** loaded
**Then** all 12 + hidden districts exist with sub-area lists matching FR108–FR121

**Given** the VS scope
**When** the project ships VS
**Then** Slopside + Cubicle Belt + Plaza render with full sub-area detail; remaining districts present as scene stubs / locked

### Story 9.4: Sneak Routes — Ghost Mode + Awakening Gated

As a Ghost-mode player,
I want sneak routes (alleys, rooftops, service tunnels) visible only after Ghost Mode 4 + Awakening 6 baseline, and the map UI surfacing them silently,
So that the world rewards build investment without telling me about it (FR124, UX-DR96).

**Acceptance Criteria:**

**Given** the player's Ghost Mode skill < 4 OR Awakening level < 6
**When** the world map is queried
**Then** sneak routes are not rendered

**Given** the threshold is crossed
**When** the player re-enters the district / map
**Then** sneak routes appear without a UI toast — discovered through play

### Story 9.5: Progressive Map UI + Toggleable Overlays

As a player whose vision sharpens with Awakening,
I want the map UI to read as a clean tourist map at low Awakening and reveal richer layers (per-district Heat heatmap, Cage surveillance points, sneak routes, recruit positions, faction operation indicators, dead drops) as Awakening + skills rise — with toggleable overlays,
So that the map feels like consciousness (FR125, FR126).

**Acceptance Criteria:**

**Given** low-Awakening player
**When** the world map opens
**Then** tourist-style map renders without overlays

**Given** higher Awakening + Glowie Sense / Receipts / Analyst-recruited
**When** the map opens
**Then** corresponding overlay toggles become available

**Given** an overlay toggled on
**When** the map renders
**Then** the overlay layer appears with appropriate visual (Heat heatmap = color gradient, surveillance = pin icons, etc.)

### Story 9.6: Traversal Options + Tracking Cost

As a player choosing how to move,
I want 7 traversal options (Walking / Bicycle / Public Bus / Subway / SloppDrive / Personal Vehicle / Sneak Routes) each with documented speed / tracking / cost trade-offs,
So that movement is also resistance strategy (FR123).

**Acceptance Criteria:**

**Given** a district-to-district move
**When** the player chooses a traversal
**Then** the documented speed/tracking/cost applies per `Balance.traversal.<option>` (e.g., Subway = fast/light-tracking-Cage-cameras/cheap/checkpoint-risk)

### Story 9.7: World Map Screen + Markers Mode

As a player navigating,
I want a World Map screen (M to toggle) showing top-down district layout, player position, known-location pins, optional Markers Mode pins (default off), Heat heatmap overlay; arrow-keys pan, Esc close, no fast-travel,
So that map traversal is intentional (UX-DR59, UX-DR109, FR141).

**Acceptance Criteria:**

**Given** the player presses M
**When** the world map overlays
**Then** layout, pins, and overlays render per UX-DR59

**Given** Markers Mode toggled in Settings
**When** the map renders
**Then** objective pins for active threads appear (labeled by thread name, not generic)

---

## Epic 10: Quest System & Endgame Trigger

A player can pursue 7 quest types in parallel, journal them in their own prose-style notebook, and decide for themselves when they've assembled enough Inner Ring evidence to commit to an endgame.

### Story 10.1: Quest Data Model + 7 Quest Types

As a player working multiple threads,
I want quests as Resources tagged by type (Main Quest / Faction Boss Investigation / Recruit Personal Quest / Emergent Politburo Event / Reputation Web Side Quest / Awakening Track Story Beat / District Liberation Goal) with state, prereqs, and resolution paths,
So that all 7 quest types share a single engine (FR67).

**Acceptance Criteria:**

**Given** the quest definitions
**When** loaded from `src/quest/data/`
**Then** each is tagged with one of the 7 types and has the standard state machine (locked / available / active / completed / failed / cold)

**Given** quest state changes
**When** any state transition commits
**Then** `EventBus.quest_state_changed(quest_id, old, new)` fires

### Story 10.2: Quest Discovery Surfaces (No Markers Default)

As a player listening to the world,
I want quests to surface via overheard dialogue, forum posts, recruit intelligence, evidence cross-reference, Politburo broadcasts, random encounters, and dead drops — never via marker-on-map default,
So that the world surfaces content organically (FR68, FR141).

**Acceptance Criteria:**

**Given** a quest discovery source fires (e.g., Politburo event surfaces a quest)
**When** the source resolves
**Then** the quest enters the Quest Journal as available

**Given** Markers Mode = off
**When** the quest is available
**Then** no map pin renders

### Story 10.3: Quest Journal (Character's Prose Notes, Not Auto-Logged)

As a player keeping track,
I want a Quest Journal scene (accessed via Apartment Laptop or Journal bookmark) with sections (Threads / Cold Cases / Personal Notes / NPCs), full-text searchable, with Xyoner clean-digital and Resistance handwritten variants,
So that the journal feels like my notes not the game's task tracker (FR69, UX-DR58, UX-DR78).

**Acceptance Criteria:**

**Given** the Quest Journal scene
**When** opened
**Then** all sections render with current data, search bar functional

**Given** an active thread becoming dormant
**When** the player has not progressed for ≥3 in-game weeks
**Then** the thread moves to Cold Cases section (not labeled "failed")

### Story 10.4: Inner Ring Confidence + Endgame Trigger Gate

As a player deciding to commit,
I want Inner Ring Confidence to be calculated from published evidence + Politburo state, and the endgame trigger only available when Confidence is sufficient + disposition axes are stably positioned for an ending eligibility,
So that the game does not push me to commit before I'm ready (FR70, FR12, FR133, FR204).

**Acceptance Criteria:**

**Given** the Inner Ring Confidence calculation
**When** the War Room renders
**Then** the indicator string per FR12 displays with [low/medium/high]

**Given** Confidence at "high" + disposition axes positioned for a valid ending
**When** the player approaches the Endgame Trigger location
**Then** the commit option becomes available

**Given** Confidence below threshold
**When** the player attempts the commit
**Then** the commit is gated with a diegetic explanation (no system popup; Inner Voice line only)

### Story 10.5: Emergent Politburo Quest Routing

As a player whose world generates content,
I want emergent quests from Politburo events (0–3 per week) routed to the Quest System with intervene / document / ignore / exploit response options,
So that the simulation surfaces playable beats (FR47, FR48).

**Acceptance Criteria:**

**Given** a Politburo event fires from Story 7.4
**When** routed to the Quest System
**Then** an emergent quest spawns with the four standard response options

**Given** an emergent quest expires (player ignored too long)
**When** the expiration tick fires
**Then** consequences apply per the event's `on_ignore` resolution rules

### Story 10.6: Markers Mode + Awakening Hints (Accessibility)

As an accessibility-minded player,
I want Markers Mode (objective pins on map for currently pursued threads) and Awakening Hints (corner indicator after 2+ slots stuck in a district, Quest Journal Hints subsection with directional pointers) both default-off in Settings,
So that the game is playable without me getting stuck (UX-DR109, UX-DR110).

**Acceptance Criteria:**

**Given** Markers Mode toggled on
**When** the world map renders
**Then** active-thread markers appear, labeled by thread name

**Given** Awakening Hints toggled on
**When** 2+ day-slots pass in a district without major progress
**Then** the corner lightbulb indicator appears; clicking surfaces hints in Quest Journal (directional, not spoiler)

---

## Epic 11: Boss Investigations (5–7 ship; 13 North Star)

A player can investigate, expose, and resolve faction boss operatives via documentation / dialogue-as-combat / cross-faction manipulation / direct combat — each a multi-stage arc with boss-specific defeat conditions.

### Story 11.1: Boss Investigation Template + Multi-Stage Arc Engine

As a writer authoring boss investigations,
I want a reusable boss-investigation template (multi-stage arc, evidence gathering, dialogue gating, defeat condition) data-driven from `Balance.bosses.<boss_id>` with a generic resolution engine,
So that each boss is bespoke content but the engine is one (FR127–FR131).

**Acceptance Criteria:**

**Given** a boss definition resource
**When** the data loads
**Then** the boss has stages, evidence gates per stage, defeat condition (documentation / dialogue-as-combat / combat / cross-faction route), Inner-Ring-evidence yield, and arena scene reference

**Given** the player progresses through stages
**When** evidence/dialogue/combat gates are met
**Then** the next stage unlocks per the boss's flow

### Story 11.2: Fact Checker (VS Boss Selection)

As a VS-shipping player,
I want the Fact Checker boss (Cubicle Belt, Feed faction) fully implemented — defeat-by-Doxcraft-exposing-foundation-funding — with full investigation arc, dialogue tree, arena scene, and Inner Ring evidence yield,
So that the VS demonstrates the full boss-investigation experience (FR128, NFR42 VS boss).

**Acceptance Criteria:**

**Given** the Fact Checker investigation thread starts
**When** the player gathers evidence + completes Doxcraft sub-quests
**Then** the Cubicle Belt arena scene becomes accessible

**Given** the arena confrontation
**When** the player commits the Doxcraft-defeat path
**Then** the boss is resolved, an Inner Ring evidence item drops, `EventBus.boss_resolved(fact_checker, defeat_method, ...)` fires

### Story 11.3: Trusted Anchor (Dialogue-as-Combat Boss)

As a player tackling a media boss,
I want the Trusted Anchor (Plaza, Feed faction) as a Composure-HP dialogue-as-combat encounter using Yap Game / Ratio / Lore Depth + evidence drops per stage,
So that the satire of cable news lands as gameplay (FR61, FR128).

**Acceptance Criteria:**

**Given** the Trusted Anchor encounter starts
**When** the EncounterContext attaches to DialogueRunner
**Then** Composure HP renders + multi-stage flow per Story 6.6 — but with Anchor-specific stage rules

**Given** the player exhausts the anchor's Composure
**When** the final stage commits
**Then** boss resolution fires + Inner Ring evidence yields

### Story 11.4: Debt Dealer (Dialogue-as-Combat Boss)

As a player tackling a finance boss,
I want the Debt Dealer (Vault District, Vault faction) as a Composure-HP dialogue-as-combat encounter using Yap Game + Credibility + evidence-of-debt-trap per stage,
So that the satire of predatory lending lands as gameplay (FR61, FR131).

**Acceptance Criteria:**

**Given** the Debt Dealer encounter starts
**When** evidence-of-debt-trap items are present in inventory
**Then** the Composure HP encounter routes per Story 6.6 with Dealer-specific stage rules

### Story 11.5: Innovation Czar (Trough — Documentation Defeat)

As a player tackling a fast-food boss,
I want the Innovation Czar (Slop Belt, Trough) defeatable by R&D documentation + leveraging Cage rivalry,
So that documentation-based investigation has an arc (FR127, FR135).

**Acceptance Criteria:**

**Given** R&D documents pinned and connected on Physical Board with high Credibility
**When** the publication commits with the right framing
**Then** Innovation Czar's Politburo state shifts; Cage-Feed rivalry mechanic can be triggered for the kill

### Story 11.6: Pulpit Rotating-Mask Boss (Solo-Cut Consolidation)

As a solo dev cutting scope,
I want the 4 Pulpit sub-bosses (Prosperity Prophet / Think Tank Sage / Settlement Ideologue / Jihadist Franchise Operator) consolidated into one rotating-mask boss whose mask shifts per encounter context, preserving the equal-opportunity satire across multi-faith ideology critique,
So that solo-ship preserves the Pulpit thematic completeness (per project state scope decision, FR113, FR114, FR129, FR168).

**Acceptance Criteria:**

**Given** the Pulpit boss encounter
**When** spawned
**Then** the active mask is selected from the 4-mask roster per encounter-context rules; each mask carries its faction-funding theme (Trough/Vault/etc.)

**Given** the boss is defeated
**When** resolution commits
**Then** the equal-opportunity satire across multi-faith ideologies is exposed in the resolution arc; each mask's documentation surfaces

### Story 11.7: Glowie (Cage — Detected Recruit)

As a player slowly realizing,
I want the Glowie boss as a recruit who has been in my network all along (detected via Glowie Sense skill checks + false-intel-tracking), with the defeat path being feeding false intel and tracking where it surfaces,
So that the satire of intelligence-led resistance lands (FR130, FR95).

**Acceptance Criteria:**

**Given** Glowie Sense skill checks throughout play on recruits with Glowie-flag
**When** the threshold is met
**Then** the Glowie's detected-state flag surfaces in War Room (Stage 3+)

**Given** false-intel feeding mechanic
**When** the player commits a tagged false intel item
**Then** the surfacing-tracker fires; if surfaced in expected channels, defeat condition met

### Story 11.8: Inner Ring Manipulator Reveal (Endgame Hook)

As a player in the endgame,
I want the Inner Ring "one-fed-you-info-all-along" beat to land at the Endgame Trigger — with the manipulator's identity locked in Story 14.x,
So that the final twist arrives with weight (FR132, FR204).

**Acceptance Criteria:**

**Given** the Endgame Trigger conditions met
**When** the trigger commits
**Then** the manipulator reveal scene plays, the Inner Ring identities are exposed, and routing to the chosen ending begins

---

## Epic 12: Opening Sequence & Schrödinger's Dave

A new player experiences "A Perfectly Normal Morning" — alarm → fridge → feed → commute → Greystone job (Dave's first-conversation lock) → witnesses the staged Incident → sees the Feed gap that night → bookmarks the underground forum.

### Story 12.1: Apartment Morning Scene + Alarm/Snooze

As a Wageworker waking up,
I want the Apartment morning scene with the alarm phone notification and snooze-or-get-up choice (snooze costs morning slot silently),
So that the first system lesson lands (FR33, FR100, FR102).

**Acceptance Criteria:**

**Given** a fresh save
**When** the game opens
**Then** the player wakes in Slopside Apartment with alarm ringing

**Given** the player snoozes
**When** the morning slot consumes silently
**Then** the player wakes in Afternoon with no UI explanation (NFR13 tutorial-without-text)

### Story 12.2: Fridge — Slop Heal + Slop Damage Tick

As a Wageworker eating breakfast,
I want eating slop from the fridge to restore BODY immediately + tick a grey unexplained Slop Damage number,
So that the cost-side of slop is silently introduced (FR100, FR101).

**Acceptance Criteria:**

**Given** the fridge interaction
**When** the player eats slop
**Then** BODY heals; Slop Damage ticks per Story 2.8; an unexplained grey UI number renders briefly

### Story 12.3: Feed — Staged News Item

As a Wageworker scrolling,
I want the Feed app on the phone showing a GnoyNews segment seeded with names/logos/locations (no markers), foreshadowing the Incident,
So that the player has cognitive material before the Incident (FR2, FR100).

**Acceptance Criteria:**

**Given** the phone Feed scene
**When** opened
**Then** the seeded news item renders with characters/locations that will appear later in the day

### Story 12.4: Commute + Greystone Job + Dave's Schrödinger Lock

As a Wageworker arriving at work,
I want the Greystone Data Solutions commute scene (environmental satire: McXyon's everywhere, billboards, homeless-Gnoy whisper) and the Greystone office where my first dialogue choice with Dave permanently locks his arc,
So that my first conversation has invisible weight (FR1, FR99, FR100).

**Acceptance Criteria:**

**Given** the commute scene
**When** the player traverses
**Then** environmental satire elements render (McXyon's billboards, homeless-Gnoy's whisper "THEY PUT SOMETHING IN THE FOOD")

**Given** the Greystone office scene
**When** Dave initiates first dialog
**Then** the three-choice path resolves: Default = Dave_State_Forever_Gnoy; "Real" answer = Dave_State_Future_Recruit; "Too-awakened-too-early" = Dave_State_Glowie

**Given** Dave's state locked
**When** any future scene queries Dave's role
**Then** the locked state determines all subsequent behavior (no further re-elicitation possible)

### Story 12.5: The Incident — Staged News Filming

As a Wageworker stumbling into truth,
I want to encounter the staged news event being filmed (player can ignore/watch/photograph), with the option to use Camera Flash to capture Receipts evidence,
So that the Truth Paradox seed is planted (FR2, FR100).

**Acceptance Criteria:**

**Given** the Incident scene
**When** the player walks into the filming
**Then** the three player options surface (ignore/watch/photograph)

**Given** the player photographs
**When** Camera Flash captures
**Then** a Receipts evidence item enters inventory tagged with the discrepancy

### Story 12.6: Evening Feed + Forum Bookmark

As a Wageworker home from work,
I want to see the Feed's doctored footage of the Incident later that night (Feed-vs-reality gap visible) and a notification leading to the underground forum bookmark — closing the opening sequence,
So that the rabbit hole opens (FR100, FR101).

**Acceptance Criteria:**

**Given** evening of day 1
**When** the player checks the Feed
**Then** the doctored version of the Incident surfaces, contradicting any Receipts captured

**Given** the underground forum link surfaces
**When** the player follows
**Then** the forum bookmark adds to the Apartment Laptop and a thread about the staged event is visible — opening sequence resolves

---

## Epic 13: Theme System, Awakening Filter & Music Deterioration

The world *looks* satirical hyper-realism — Xyoner spaces oversaturated, Slopside/Hollow desaturated. As the player Awakens, the visual filter desaturates the world, the corporate music in Xyoner spaces audibly deteriorates across 5 tiers, the HUD glitches, and Resistance UI elements appear in homebase. The duality between Xyoner-app polish and Resistance-handmade aesthetics IS the satire.

### Story 13.1: Theme Tokens Foundation — Two-Theme Component Grammar

As a UI developer building once,
I want all theme tokens (color, type size, spacing, border radius, animation duration) in `src/ui/theme/tokens.gd` as a typed dictionary with 11 Awakening variants per token + "off" + Xyoner / Resistance themes sharing one component grammar,
So that components consume tokens (locked rule 10), never literals (FR150, FR151, UX-DR1, UX-DR2, UX-DR4, UX-DR5, UX-DR7, UX-DR8, UX-DR9).

**Acceptance Criteria:**

**Given** the token registry
**When** loaded
**Then** Xyoner palette (10 tokens), Resistance palette (8 tokens), typography stacks, spacing 4/8/12/16/24/32/48/64/96, motion tokens, sound tokens are all present per UX-DR1–UX-DR9

**Given** any UI component
**When** rendered
**Then** it reads from `ThemeManager.get_token(token_id)` — never declares a color/size literal (architecture lint at EA prep)

### Story 13.2: ThemeManager — Awakening-Aware Token Swap

As a player whose UI awakens with me,
I want `ThemeManager` autoload to resolve tokens with the current Awakening level applied, swapping at threshold crossings via `EventBus.theme_tokens_changed`,
So that the HUD itself shifts without per-component patches (architecture locked rule 4).

**Acceptance Criteria:**

**Given** Awakening level changes
**When** the threshold crossing fires
**Then** ThemeManager re-resolves all tokens to their Awakening-variant value; `theme_tokens_changed` signal emits

**Given** UI components subscribed to the signal
**When** received
**Then** they rebind their consumed tokens and re-render

### Story 13.3: Awakening Filter Shader

As a player feeling reality desaturate,
I want a single fragment shader on a CanvasLayer-mounted ColorRect consuming `awakening_level` (0–10) + `xyoner_space_intensity` (0–1) uniforms, with the saturation desaturation curve (UX-DR3) and Compound interior exception,
So that the visual filter is one shader, not per-component patches (UX-DR3, UX-DR87, UX-DR92, UX-DR133).

**Acceptance Criteria:**

**Given** the shader
**When** awakening_level + xyoner_space_intensity uniforms update
**Then** the saturation curve from UX-DR3 applies in <2s crossfade

**Given** Compound interior scene tag
**When** the player enters
**Then** xyoner_space_intensity = 1.00× regardless of Awakening (Compound interior exception)

### Story 13.4: Music Deterioration — 5-Tier Multi-Version Crossfade

As the satirical soundtrack,
I want each Xyoner-space music context to resolve to 5 multi-version recordings (tier 1 clean → tier 5 collapsed), with 2 AudioStreamPlayer instances per context cross-fading at Awakening thresholds, default 4s crossfade per-context-tunable, never producing mid-loop discontinuity,
So that the signature satire feature lands (FR176, FR193, NFR48, UX-DR93, UX-DR134, locked rule 7).

**Acceptance Criteria:**

**Given** an Xyoner-space MusicContextResource with 5 stream paths
**When** scene loads at Awakening N
**Then** MusicDirector engages the appropriate tier player + standby tier player

**Given** Awakening crosses a music threshold
**When** the next scene transition or natural loop boundary arrives (or boundary >60s away forces deferral)
**Then** crossfade from current tier → next tier completes in 4s (default) without producing a mid-loop discontinuity

**Given** Awakening at 10 + endgame trigger
**When** the cinematic stinger plays
**Then** hard-cut is supported per FR85 / cinematic at 1/5/10

**Given** any code attempting runtime DSP on tier-1 stream to fake higher tiers
**When** PR review runs
**Then** the violation is flagged (locked rule 7)

### Story 13.4a: Music Deterioration Asset Pipeline — Offline Tier Derivation Recipe

As the audio production pipeline,
I want each Xyoner-space music context to have a tier-1 clean `.ogg` generated via Beatoven.ai and tiers 2–5 derived via a version-controlled per-context offline DSP recipe (bitcrush curves, EQ rolloff, stutter rate, dropout density, pitch wobble) matching FR85's tier mapping,
So that all 5 tier files are loop-clean, deterministically reproducible, and committed to source before VS prototype (NFR48, FR200, architecture §3.3).

**Acceptance Criteria:**

**Given** the VS prototype Xyoner-space context
**When** the asset pipeline runs
**Then** 5 loop-clean `.ogg` files (`track_t1.ogg`–`track_t5.ogg`) exist in source, each matching the FR85 tier description (clean → wrong notes/wobble → jingle skips/compression → corruption/dropouts → collapse)

**Given** the per-context DSP recipe file
**When** inspected
**Then** it is version-controlled, documented, and deterministically reproducible from the tier-1 source (same input + recipe → same output bytes)

**Given** a PR adding or modifying a Xyoner-space music context
**When** reviewed
**Then** the recipe file and all 5 tier files are included

### Story 13.5: 9 Audio Buses + Bus-Specific Effect Slots

As the audio engineer of a satirical game,
I want all 9 audio buses (Master, Music, Music_Stinger, SFX_World, SFX_Combat, SFX_UI, Voice_Internal, Voice_Dialogue, Ambient) configured at Story 1.0 and each with named effect slots per architecture §4.3,
So that mixing is consistent and accessible (FR15, FR177).

**Acceptance Criteria:**

**Given** the project audio bus layout
**When** inspected
**Then** all 9 buses exist with the documented effect slots

### Story 13.6: Awakening Cinematic at Levels 1, 5, 10

As a player crossing Awakening milestones,
I want short cinematics at levels 1, 5, and 10 (level 1 = Inner Voice first speaks; level 5 = perception shift moment; level 10 = endgame revelation),
So that the campaign spine has authored peaks (FR84, FR159).

**Acceptance Criteria:**

**Given** `EventBus.awakening_cinematic_due(level)` fires
**When** the cinematic player engages
**Then** the appropriate cinematic scene plays (engine-system UI hidden, optional subtitles, Skip button per UX-DR75)

### Story 13.7: HUD Glitch Mirror at Music Deterioration Tiers

As a player watching the HUD itself awaken,
I want each music deterioration tier mirrored in HUD: T1 pure / T2 color-fringe / T3 scanlines / T4 channel-separation / T5 heavy glitch + 0.55× saturation, intensity-synced with music crossfade,
So that the satirical signature is multi-modal (UX-DR84, UX-DR91).

**Acceptance Criteria:**

**Given** music tier crossfade engaged
**When** the audio crossfades
**Then** the HUD-glitch shader/effect intensity ramps in parallel <2s

**Given** Resistance-themed homebase HUD
**When** tier rises
**Then** Resistance HUD desaturates in parallel (UX-DR91), but does not glitch (only Xyoner UI glitches)

### Story 13.8: Internal Voice Audio Cues (When VO Funded; Otherwise Typography Only)

As a player hearing distinct voices,
I want each Internal Voice to render its line via per-voice typography always; if VO is funded, a whispered audio cue plays from Voice_Internal bus,
So that voices are recognizable in both fully-voiced and text-only builds (FR58, FR187).

**Acceptance Criteria:**

**Given** a voice line firing
**When** rendered
**Then** the voice's typography from `VoiceProfile` resource always applies; if `VoiceProfile.audio_cue` is set, the cue plays from Voice_Internal bus

### Story 13.9: Diegetic-Scene Exception List

As a developer documenting bespoke scenes,
I want the diegetic-scene exception list (Apartment Laptop, War Room, Compound, Endgame Trigger) documented in `src/ui/diegetic/README.md`, allowed to ignore tokens for bespoke art, but not allowed to leak patterns back to shared components,
So that the diegetic art has freedom + the system has protection (UX-DR125).

**Acceptance Criteria:**

**Given** the exception README
**When** read
**Then** all 4 named diegetic scenes are listed with per-scene custom component-grammar descriptions

**Given** a PR adding a new diegetic exception
**When** reviewed
**Then** the README must be updated and the AI agent code review checklist enforces

---

## Epic 14: Endings, Polish, Localization & Accessibility

A player can reach all 5 endings with proper coda + epilogue + credits; play in localization-ready UI with WCAG AA accessibility; and play on Steam Deck Verified at 60fps stable on min-spec hardware.

### Story 14.1: Ending Selection — 3 Endings Ship + 2 North Star Hooks

As a player committing to an ending,
I want the 3 ship-endings (Public Reckoning + Long Game + Sleep) fully implemented with coda + epilogue narration + credits, and Shadow Replacement + Burn retained as engineering hooks for future,
So that solo-dev ships a complete arc (FR71, FR75, NFR19).

**Acceptance Criteria:**

**Given** the Endgame Trigger commits with eligibility for one of the 3 ship endings
**When** the player selects
**Then** the chosen ending's coda scene plays + epilogue narration + credits

**Given** the Sleep ending
**When** played
**Then** the McXyon's jingle restored (undeteriorated audio) + palette resaturated land per UX-DR76

### Story 14.2: Tutorial-Without-Text Validation

As the project hitting NFR13,
I want internal+external playtests confirming >80% playtesters identify all silently-introduced systems (slot system, Slop Damage, financial pressure, dialogue consequences, Receipts, evidence board, Feed-vs-reality, underground forum) within 30 minutes post-tutorial,
So that the tutorial-without-text design works (NFR13).

**Acceptance Criteria:**

**Given** the playtest plan at VS gate + EA gate
**When** ≥10 playtesters complete the opening sequence + 30-minute investigation period
**Then** the system-identification rate is recorded; ≥80% target validates; <80% triggers a design pass

### Story 14.3: Truth Paradox Legibility Validation

As the project hitting NFR14,
I want post-VS playtests confirming >75% playtesters describe the Truth Paradox unprompted within 30 minutes of investigation play,
So that the signature mechanic lands.

**Acceptance Criteria:**

**Given** the playtest plan at VS gate
**When** investigation is played for 30 minutes
**Then** post-session interviews capture unprompted Truth-Paradox descriptions; ≥75% target validates

### Story 14.4: Localization-Readiness — `tr()` Lint + String Externalization

As the project ready to localize,
I want all UI/dialogue strings externalized via `tr()`, `tools/string_lint.gd` failing the build at EA prep on any raw English literal in UI/dialogue contexts, and a string IDs registry that translators key off (renaming = migration entry),
So that localization can begin without a refactor (FR195, locked rule 9, UX-DR146).

**Acceptance Criteria:**

**Given** the source tree at EA prep
**When** `string_lint.gd` runs in CI
**Then** any raw English literal in UI/dialogue contexts fails the build with a useful pointer

**Given** the string registry
**When** a string ID is renamed
**Then** a migration entry is required (translators key off IDs)

### Story 14.5: Font Fallback System

As an internationalizing UI,
I want a font fallback registry: CJK = Noto Sans CJK (~50MB bundled), Arabic/Hebrew = Noto Sans Arabic/Hebrew (bidi supported), symbols = OS default, with text-expansion budget (+30% width) per UX-DR144,
So that adding languages later doesn't force a UI refactor (UX-DR144, UX-DR145).

**Acceptance Criteria:**

**Given** the font registry
**When** a string with non-Latin codepoints renders
**Then** the appropriate fallback font engages

**Given** the +30% expansion test fixture
**When** German benchmark strings render
**Then** no clipping / overflow occurs at 1080p / Steam Deck / 1440p

### Story 14.6: Accessibility — Keyboard Nav + Screen-Reader Layer

As an accessibility-focused player,
I want every UI screen fully keyboard-navigable (Tab/Shift+Tab/arrows/Enter/Esc/Space), ARIA-labels on interactive elements, status-pip combined-voice description, Inner-Voice prefix in screen-reader, and a screen-reader tour mode for complex scenes (Physical Board, Dossier, War Room),
So that the game is playable for keyboard-only and screen-reader users (UX-DR111, UX-DR112).

**Acceptance Criteria:**

**Given** every UI screen
**When** played keyboard-only on NVDA / JAWS
**Then** full navigation is possible without mouse

**Given** complex scenes on first entry with screen-reader tour mode enabled
**When** entered
**Then** the layout description plays and is skipable

### Story 14.7: Accessibility — Hold-to-Confirm + Click-Source-Then-Target

As a motor-accessibility player,
I want Settings toggles for Hold-to-Confirm (commit-irreversible buttons need 2s hold with progress fill) and Click-Source-Then-Target (replaces Physical Board drag with two-tap, with keyboard alternative),
So that motor-impaired play is supported without losing tension (UX-DR106, UX-DR107).

**Acceptance Criteria:**

**Given** Hold-to-Confirm toggled on
**When** the player presses a commit-irreversible button
**Then** the button fills over 2s with progress bar visualization

**Given** Click-Source-Then-Target toggled on
**When** the player taps source card + target card on Physical Board
**Then** the connection skill check fires identically to drag

### Story 14.8: Accessibility — Text Scaling + Color-Blindness + Dyslexia Font

As an accessibility-focused player,
I want Text Scale 100/125/150/200% with reflow, color-blindness simulator modes (deuter/protan/tritan/achroma) and shape+position+fill redundancy on status pips, and OpenDyslexic-equivalent toggle for Resistance body text (Inner Voices retain per-voice typography),
So that the game is readable across visual differences (UX-DR101, UX-DR102, UX-DR103).

**Acceptance Criteria:**

**Given** text scale at 200% on min-spec hardware
**When** all UI screens render
**Then** no clipping / overlap

**Given** color-blindness simulator engaged
**When** the player plays
**Then** all status indicators remain distinguishable via shape+position+fill

**Given** OpenDyslexic toggle on
**When** Resistance body text renders
**Then** the dyslexia font applies; Inner Voices retain per-voice typography

### Story 14.9: Accessibility — Subtitles + Music Deterioration Visual Indicator

As a hearing-impaired player,
I want all voice-acted lines toggleable subtitles (default-on) + Music Deterioration Visual Indicator (default-off, tiny corner icon showing tier 1–5),
So that audio-game stealth + the satire signature are accessible (UX-DR104, UX-DR105, FR144, FR178).

**Acceptance Criteria:**

**Given** subtitles toggled on
**When** any voice-acted line plays
**Then** subtitles render bottom-center with speaker-name label

**Given** Music Deterioration Visual Indicator toggled on
**When** the music tier changes
**Then** the corner icon updates to the current tier (1–5)

### Story 14.10: Performance Validation Gate (VS / EA / Full Launch)

As the developer hitting performance targets,
I want CI/manual perf gates at VS (synthetic worst-case validation), EA (Steam Deck validation), and Full Launch (most-expanded localization validation), with the documented per-event budgets and per-frame budgets validated,
So that 60fps min-spec is real (NFR2, NFR7, NFR8, NFR9, NFR47, NFR48).

**Acceptance Criteria:**

**Given** the VS perf gate
**When** profiled with a synthetic 100-week save + 200-Gnoym Reputation Web + 6000-entry conversation log
**Then** all per-event budgets pass (Politburo <500ms, log retrieval <50ms, gossip <2s)

**Given** the EA gate on Steam Deck
**When** played
**Then** 60fps stable + autosave <3s + load <5s validated

### Story 14.11: Steam Deck Verified Compliance

As the project shipping on Steam Deck,
I want Steam Deck Verified compliance: gamepad scheme parity (deferred but functional), touch parity in docked mode (deferred but functional), all UI touch targets ≥40px, controller-friendly menu nav,
So that Steam Deck Verified launch target is reachable (NFR3, UX-DR113, UX-DR142, UX-DR143).

**Acceptance Criteria:**

**Given** the Steam Deck export preset Linux build
**When** run on Steam Deck hardware
**Then** all UI is navigable via controller, all touch targets ≥40px in docked mode, gamepad scheme provides parity with mouse+keyboard

### Story 14.12: IP-Counsel + Tone Calibration Pre-EA Gate

As the project protecting itself,
I want pre-EA legal review of Three Tracking Systems vs US 10,926,179 + tone calibration playtests with external eyes (equal-opportunity satire across multi-faith ideology critique),
So that legal + tonal risk is mitigated before EA launch (FR168, FR199, FR202, FR203, NFR22, NFR50).

**Acceptance Criteria:**

**Given** pre-EA gate
**When** legal counsel reviews `src/tracking/` + reads §5.1 contract + reviews architecture §6.1
**Then** sign-off achieved before EA ship

**Given** tone calibration playtests
**When** ≥10 external playtesters review Pulpit-roster + Vault/Cage ecumenical framing
**Then** equal-opportunity satire validation achieved; corrections applied if flagged

### Story 14.13: Inner Ring Final Narrative Lock

As the player approaching the endgame,
I want the Inner Ring size + manipulator identity finalized in writing before endgame implementation begins (per project state open question),
So that the "one-fed-you-info-all-along" beat lands consistent and weighty (FR132, FR133, FR204, NFR45, NFR56).

**Acceptance Criteria:**

**Given** pre-endgame implementation gate
**When** narrative writing locks
**Then** the Inner Ring size, all member identities, the manipulator's identity + motive, and the breadcrumb-trail of "info fed to player" all exist in the narrative bible

**Given** Story 11.8 implementation
**When** built
**Then** it consumes the locked narrative

### Story 14.14: Asset Budget Tracking Automation

As the project monitoring its scope,
I want an asset budget tracking tool (`tools/asset_budget.gd`) reporting total asset count + size per category against scope-tier budget targets (~80–120k word target for solo-ship per project state),
So that scope creep is visible (FR188, NFR41).

**Acceptance Criteria:**

**Given** the asset budget tool
**When** run
**Then** per-category asset counts and sizes are reported against `Balance.scope.tier_budgets.<scope_tier>` targets; over-budget categories are flagged



