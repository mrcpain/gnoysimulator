# Gameplay Integration

> **The thesis:** Gnoy Simulator does not have narrative *and* gameplay. It has narrative *as* gameplay. The Brief's first design pillar is *"the satire IS the design — every mechanic must reinforce the thematic point or be cut."* This document codifies what that means in practice.

---

## Narrative-Gameplay Connection

### Integration Approach

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

### Mechanic-Theme Alignment (the five core themes from Step 2)

| Theme (Step 2) | Mechanics That Embody It |
|---|---|
| **Manufactured consent** | Slop healing + Slop Damage + Subscription auto-deduction + GnoyNews ambient + cheerful Plaza audio loop |
| **Truth Paradox** | Publication interface (Credibility-vs-Heat) + Conversation log weaponization + Glowie planted-evidence system |
| **Awakening as cost** | Cope drops + Fatigue accumulation + Heat per faction + Recruit loyalty erosion + NPC Mode unusability at high Fatigue |
| **Equal-opportunity satire of ideology** | Vault funds all four Pulpit lineages (mechanical, not narrated) + Pulpit Quarter shared infrastructure (visual) |
| **The world doesn't revolve around you** | Politburo Simulation + cold cases + missable beats + Reputation Web independence |

**Every theme has at least three mechanical anchors.** None is delivered through dialogue alone. *This is what "the satire IS the mechanics" looks like in audit form.*

### Story-Gameplay Balance

**No discrete sections.** Gnoy Simulator does not have "story sections" and "gameplay sections." The day cycle integrates investigation, dialogue, combat, and routine maintenance into a continuous flow. The player decides when to push a thread, when to rest, when to investigate, when to fight, when to talk, when to sleep.

The closest thing to a "story section" is the opening "A Perfectly Normal Morning" tutorial (~15 min) and the per-ending coda sequences. Everything between is integrated.

### Ludonarrative Considerations

**The design forecloses common ludonarrative dissonance traps:**

- **No "save the world" framing while looting random NPCs' homes.** The looting in Gnoy Simulator is contextualized — the player is investigating, infiltrating, recovering documents. Random theft generates Heat and degrades Reputation Web with the burglarized district.
- **No combat as default solution.** Hotline Miami lethality means combat is a *choice with permanent consequences*, not a problem-solver. Most encounters have non-combat resolutions.
- **No "good ending requires murdering everyone" structural trap.** Faction OWNED can be reached via investigation, social manipulation, or combat — multiple paths to the same mechanical outcome.
- **No "the protagonist hates the system but the player's gameplay reinforces it."** The Awakening Track and Slop Damage stat are *direct mechanical encoding* of the protagonist's relationship to the system. Player play *changes* both.

**One ludonarrative-dissonance risk to monitor:**

- **The Crafter recruit makes signature weapons that are useful in combat.** A pacifist player's narrative arc may dissonate with a high-Crafter homebase. **Mitigation:** Crafter weapons are also dual-purpose (Megaphone, Camera Flash, Fake ID Packet) — pacifist runs use the non-lethal subset. Document this in production sub-docs.

---

## Story Gating

### Gating Approach

**Soft-gate dominant + build-gated geography.** Almost no hard story gates. Story is *available* via player exploration and *gated* via character build state.

### Gate Types in Use

| Gate Type | Where It Fires |
|---|---|
| **Hard story gates** | The 7 cutscenes (mostly skippable). The Endgame Trigger commitment. The first-play Doctored Feed Segment. **That is the entire list.** |
| **Soft story gates** | Most NPC dialogues (player can decline). Most boss investigations (player chooses which to chase). Most documents (player chooses to read). |
| **Build-gated geography** | Sneak routes (Ghost Mode threshold) + Internal Voices (Awakening threshold) + Xyoner symbol legibility (Awareness threshold) + War Room access (HQ Stage 3+) + Compound approach (Awake 9+). |
| **Awakening-gated dialogue lines** | Internal Voice options scale with Awakening + Fatigue + Cope. Some dialogue choices become available only at sufficient Awakening. |
| **Item-drop gated dialogue** | Specific evidence items unlock specific dialogue lines. Player can return to old conversations with new items. |
| **Faction Standing gated content** | Higher faction standing opens new dialogue + new boss-confessional content. |
| **Reputation Web gated NPCs** | NPCs the player has built rapport with give different conversational openings to other NPCs in their gossip network. |

### Story-Locked Elements

- **The Compound** — Awakening 9+ gated. **The only district fully gated by character state.**
- **The Inner Ring Betrayal Reveal scene** — gated by Compound approach.
- **Awakening Track cinematics** — fire when threshold crossed.
- **The 5 endings** — each gated by accumulated state at Endgame Trigger.

### Mandatory Story Beats

**Six mandatory beats across the entire game:**

1. "A Perfectly Normal Morning" tutorial (Beat 1) — fires on game start. Cannot be skipped on first play.
2. The Doctored Feed Segment (Beat 2) — fires at end of tutorial. Cannot be skipped on first play.
3. The Inner Ring Betrayal Reveal (Beat 5) — fires at Compound approach. Cannot be skipped on first play.
4. Awakening Level 10 cinematic (Beat 6) — fires at Awakening 10 (skippable but not pre-trigger-able).
5. The Endgame Trigger (Beat 23) — player-decided commitment moment.
6. The Coda of whichever ending fires (Beat 7).

**Everything else is optional.** A Sleep playthrough fires only beats 1, 2, and 7 (Sleep ending coda).

### Optional Narrative

**Per Step 8: ~80% of total content volume is optional.** The Brief's "no markers default" + "quest journal is character's notes" design is the operational expression of this. The player who explores deeply is rewarded; the player who plays minimally still gets a coherent (and short) narrative arc.

---

## Player Agency

### Agency Level

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

### Player Influence

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

### Choice System

**Every choice falls into one of three categories:**

| Choice Tier | Description | Example |
|---|---|---|
| **Identity Choice** | Permanently defines the protagonist's character | Dave Schrödinger's dialogue (Beat 8); Endgame Trigger (Beat 23); Inner Ring slot offer accept/reject |
| **State Choice** | Affects accumulated state that drives ending and per-character outcomes | Each subscription cancellation; each publication framing decision; each recruit loyalty decision |
| **Flavor Choice** | Affects tone/conversation log without mechanical state change | Most routine NPC dialogue; most Forum chat options |

**Choice timing:** Choices are surfaced *in the flow of play*, not at scripted decision points. The Disco Elysium convention (visible-DC, hidden-consequence) is preserved across all choices. **The player commits to who they are by what they do, not by selecting from a multi-choice ending menu.**

### Role-Playing Freedom

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

## Production Notes (carried forward to Step 10)

- **Mechanic-theme audit:** The "what it does / what it is saying" list above is a **production-tier governance artifact**. Any new mechanic proposed during production must pass this two-sentence test or be cut. Add to GDD update workflow.
- **Build-archetype playtest gating:** Vertical slice should support **at minimum 3 build archetypes** to validate the "different game on same map" claim. Recommended: Documentarian + Wrecker + Refuser as the most divergent triad.
- **Pacifist-build crafter dissonance** flagged above — production sub-docs for Crafter recruit must specify dual-purpose-weapon framing.
- **Inner Ring slot offer/accept** as Identity Choice — needs explicit dialogue tree authoring at endgame; tied to Mole identity decision (Step 4 open question).

---
