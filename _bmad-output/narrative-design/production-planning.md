# Production Planning

> **Document scope:** This section consolidates every production-relevant note carried forward from Steps 4-9 into a single budget/scope reference. **It is the artifact to hand a producer or publisher.** Estimates are designer-realistic, not aspirational; ranges reflect uncertainty in scope, not in cost.
>
> **Two scope paths are documented:** (1) the **full-scope North Star** (the design as locked across the GDD and Steps 1-9 of this NDD, scoped for a 3-5 person team), and (2) the **Solo + Vibe-Coding Ship Target** (the realistic ship scope under Cpain's confirmed solo + AI-assisted development constraints). The solo path is the recommended ship target.

---

## Writing Scope (Full-Scope North Star)

### Estimated Total Word Count

**~280,000-340,000 words at full launch.** Disco-Elysium-tier (~300k baseline confirmed in Brief), with refined estimates per content type below. **This is the largest single content cost line item in the project and the single largest scope risk.**

### Content Breakdown

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

### Scene / Chapter Count (functional units, full scope)

- **6 acts** (Prologue + 4 Acts + Coda) — narrative architecture
- **23 named story beats** (Step 3) + **5 Sleep-path beats** = 28 beats with authored or triggered content
- **13 boss investigations** — each is a multi-encounter functional unit
- **7 specialist recruit personal quests** (+ named-instance variants) — each is a multi-scene functional unit
- **5 ending sequences** — each is a coda + epilogue authored unit
- **~30-60 Reputation Web side quests** at full launch
- **~5-10 Cage Black Site infiltrations** at full launch

**Total functional authored units:** ~95-130 distinct scenes/quests/sequences requiring per-unit writing scope.

### Branching Complexity Impact

- **30-40% unique-content per line** for routine dialogue (most builds see most lines)
- **50-60% unique-content per line** for boss confrontations (build identity matters more)
- **70-80% unique-content per line** for the 7 Tier-S key conversations (Schrödinger's Dave, dialogue bosses, Betrayal Reveal, etc.)
- **3-5+ paths per dialogue goal** means most authored content has multiple gated variants

**The branching system is the single largest writing-cost multiplier** beyond raw word count. The multiplier is captured in the per-content-type estimates above.

### Writing Pipeline (full-scope production phases)

| Phase | Writing Scope | Word Count |
|---|---|---|
| **Vertical slice** | Tier-S key conversations (Schrödinger's Dave, Trusted Anchor, Fact Checker as 2-boss prototype), opening tutorial, Awakening L1 cinematic, ~3 viable build archetypes' dialogue paths in covered content | ~40,000-55,000 |
| **Early Access launch** | 4-5 boss investigations fully written, 1 ending playable + Sleep ending, Inner Voice chorus operational at L1-L5, partial Forum + Reputation Web | ~120,000-160,000 |
| **Full launch** | All 13 bosses + 5 endings + full Inner Voice scaling + all districts + complete Forum + Reputation Web | Total ~280,000-340,000 |

---

## Solo Dev + Vibe Coding Production Path (recommended ship target)

> **Constraint update:** Cpain has confirmed solo development with AI-assisted (vibe coding) implementation. The full-scope estimates above are the *North Star design*; this section captures the realistic *ship target* under solo + vibe-coding constraints. Both paths are documented so future-Cpain can scale up to the full scope if team size grows.

### Recommended Solo Ship Target: ~80,000-120,000 words at full launch

**Calibration:**

- Pentiment shipped at ~140k words with a small Obsidian team in ~2 years
- Citizen Sleeper at ~60k words (small team)
- Cruelty Squad at ~10k words (solo)
- **80-120k is the achievable solo + vibe-coding band over 18-30 months from vertical slice.**
- Vibe coding accelerates implementation (code, art, music) by ~30-50%; narrative-quality work (voice consistency, satire calibration, sensitivity review) does not significantly accelerate. **Word count is bottlenecked by author-review bandwidth, not generation speed.**

### Recommended Cuts (ordered by leverage)

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

### What Survives the Cut (the design's load-bearing pieces)

- **Pillar 1 (mechanical satire) — fully intact.** Every locked mechanic from the GDD survives.
- **Truth Paradox spine — intact.**
- **Schrödinger's Dave — intact.** Highest-leverage replayability hook preserved.
- **Music Deterioration Mechanic — intact.** Signature mechanic preserved.
- **All 5 factions — intact** (just fewer named bosses per faction).
- **Sleep ending co-equality — intact.**
- **Disco × Hotline Miami × Persona DNA — intact.**
- **Build-gated geography — intact** (just fewer districts to gate).
- **Conversation log weaponization — intact** (mechanic-level, not volume-level).

### Vertical Slice Target (Solo)

**4-6 months, ~20,000-25,000 words.** Ship publicly before scaling.

- **One district fully playable:** Slopside + Cubicle Belt corridor (including Greystone)
- **One boss prototyped end-to-end:** Trusted Anchor (dialogue boss prototype — proves the highest-cost writing pattern)
- **Opening tutorial complete:** "A Perfectly Normal Morning"
- **Awakening Levels 1-3 functional** (Inner Voice scaling, music deterioration tier 1-2)
- **Schrödinger's Dave dialogue fully written** (3 branches)
- **Investigation UI Layers 1-2 (Physical Board + Dossier Interface) functional**
- **Hotline Miami combat loop working with capture mechanic**
- **Day cycle with finite slots, snooze cost, subscriptions, sleep tick**

### Hand-Written vs. AI-Assisted Breakdown

| Content Tier | % of Total | Approach |
|---|---|---|
| **Tier S — Hand-authored (Cpain writes)** | ~30-40% (~30,000-50,000 words) | Schrödinger's Dave (all 3 branches), dialogue boss confrontations, the Mole reveal, the "we don't know" Inner Ring refusal scene, all 3 ending codas, opening tutorial, Awakening cinematics. **Voice consistency and satire calibration require Cpain's authorial hand. AI cannot replace this.** |
| **Tier A — AI-assisted with heavy review (Cpain reviews/rewrites every line)** | ~30-35% (~25,000-40,000 words) | Recruit dialogue, faction-boss-confessional dialogue, Inner Voice scaling variants, Sleep-path beats. AI generates first draft from style guide; Cpain rewrites for voice. |
| **Tier B — AI-templated with light curation (Cpain reviews patterns + samples)** | ~30-35% (~25,000-40,000 words) | Routine NPC dialogue, Forum thread fillers, faction documents, ambient news segments, Reputation Web side conversations. AI fills templates from authored patterns; Cpain audits sampling. |

**Critical: tier assignments are about *what AI is good at*, not about *what's important*.** Tier-B content is still narratively necessary — it's just authored via a different process.

### Vibe-Coding-Specific Risks

- **Voice consistency drift** is the highest narrative risk. AI-generated text in the Pulpit Quarter at month 18 will not naturally match Cpain's hand-written style from month 4. **Mitigation:** maintain a living style guide updated per content tier; periodically re-review Tier-B content against latest Tier-S authored material.
- **Sensitivity review still requires human judgment.** Even with reduced Pulpit roster (1 rotating boss vs. 4), the satire targets sensitive ideologies. **Budget for at least one external sensitivity reviewer pass before EA launch.** AI cannot certify this.
- **The "what it does / what it is saying" mechanic-theme audit (Step 9)** is a *design governance test*, not a generation task. Every AI-suggested mechanic or system must pass Cpain's two-sentence test or be cut.
- **Audio production cannot be vibe-coded to the same degree.** AI music tools have improved but the Music Deterioration Mechanic is a precision artisan asset (5 tiers per track × ~25 tracks = 125 recordings). **Recommend dedicated composer collaboration even in solo mode** — this is the line item where solo + AI breaks down hardest.

### Solo Ship Timeline Estimate

| Phase | Duration | Word Count Cumulative |
|---|---|---|
| **Vertical slice** (one district + one boss + tutorial + base systems) | 4-6 months | ~20,000-25,000 |
| **Early Access launch** (3 districts, 3 bosses, 1 ending playable + Sleep, full Inner Voice scaling at L1-L7) | +12-18 months from VS | ~50,000-70,000 |
| **Full launch** (5-7 districts, 5-7 bosses, 3 endings, full system depth) | +6-12 months from EA | ~80,000-120,000 |

**Total estimate: 22-36 months from vertical slice start to full launch, solo + vibe-coding.** The Brief's 30-48 month full-launch estimate (which assumed 3-5 person team) is replaced by this estimate for the solo path.

### Publisher / Funding Implications

- **Solo + vibe-coding scope is Kickstarter-receptive.** ~$50-150k campaign target reasonable for this scope; covers living expenses, dedicated composer, sensitivity reviewer, and a contracted artist for environments/portraits if needed.
- **Publisher signing remains an option** at the small end (Devolver / 11 bit / Raw Fury). Expectations would scale: a publisher-funded version could re-expand toward the full 280-340k scope with hired writers.
- **Self-funded EA** is the most-likely realistic path. Solo + vibe-coding scope makes EA a meaningful milestone, not a compromise.

---

## Localization

### Approach: English-only at launch (recommended for both scope paths)

**Rationale:**

- Even at solo-scope (80-120k), per-language localization runs ~$0.10-0.20 per word professionally — $8,000-24,000 per language tier just for base translation, before LQA and cultural-adaptation review.
- Satirical content carries unusually high translation risk — jokes don't survive literal translation; the equal-opportunity satire framing of the Pulpit roster requires per-region cultural-adaptation review that adds significant cost.
- Per Brief: localization decision deferred to GDD stage. **This NDD recommends English-only at launch for both scope paths.**

### Future Consideration (post-launch tiered approach)

| Tier | Languages | Rationale |
|---|---|---|
| **Tier 1** | German, French, Russian, simplified Chinese | Largest CRPG audiences globally |
| **Tier 2** | Spanish (Latin American + Castilian), Brazilian Portuguese, Polish | Disco Elysium / Pentiment-tier audience presence |
| **Tier 3** | Japanese, Korean, Italian | Genre-fit but smaller audience overlap |

### Cultural Adaptation Notes

- **Pulpit roster requires per-region cultural-adaptation review.** The four ideological lineages (or the rotating-mask version in solo path) map differently in different cultural contexts. Equal-opportunity-satire framing must survive translation.
- **Brand satire** (McXyon's, Greystone, GnoyNews) reads differently per region. May require per-language localized brand parodies.
- **Forum-poster vernacular** is contemporary internet English. Per-language equivalents must capture the *register*, not the *literal text*.
- **Inner Voice text-rendering style** must work across non-Latin alphabets. Engineering scope item.

### Technical Considerations

- Text expansion buffer: 30% standard for German/Russian; 20% for Romance languages; 15% for CJK. UI must accommodate.
- UI flexibility: Resistance-style (hand-made) UI accommodates variable text more gracefully than Xyoner-style (corporate-app).
- Audio: No dubbing planned even for non-English markets. **Subtitled approach for boss VO + key NPC VO.**

---

## Voice Acting

### Approach: Selectively voiced (both scope paths)

**Voiced scope (locked recommendations):**

- **Boss dialogue** for all bosses (5-7 in solo path; 13 in full-scope path), weighted heavily toward dialogue bosses (Trusted Anchor, Debt Dealer).
- **Key NPC voice acting** for Dave (state-conditional voice across 3 arcs), named specialist recruits, and the defected Inner Ring member ("we don't know" refusal scene).
- **Trusted Anchor's broadcast-voice cracking** during the dialogue boss fight — *signature single VO performance moment of the game.*

**Text-only scope (locked):**

- **All Inner Voices** (12 in solo path; 24 in full-scope path) — text-only delivery.
- **All routine NPC dialogue** — Reputation Web, ambient Gnoym, generic faction operatives.
- **All Forum threads + news segments + faction documents** — written artifacts, not spoken.
- **Player character** has no voiced dialogue (preserves customizable-protagonist design).

### Characters Needing Voices

**Solo path: ~12-18 voice actors at full launch.**

- 5-7 boss roles
- Dave (3 voice tracks for 3 states) = 1 actor with multi-take
- 7 specialist recruit roles + ~5-8 named-instance recruits = ~6-10 supporting actors
- Defected Inner Ring member = 1 actor
- Glowie archetype roster = 2-3 actors with multi-character casting

**Full-scope path: ~25-35 voice actors at full launch.**

### Dialogue Volume for Recording (solo path)

- **Boss dialogue VO:** ~20,000-30,000 words spoken
- **Dave + recruit + Inner Ring member VO:** ~8,000-12,000 words spoken
- **Crowd ambient + Glowie work:** ~3,000-5,000 words
- **Total spoken word recording (solo path):** ~30,000-50,000 words

### Recording Approach

- **Professional voice cast preferred** for Tier-S roles (Trusted Anchor, Debt Dealer, Dave, defected Inner Ring member, Mole reveal).
- **Mid-tier professional or experienced indie casting** acceptable for remaining boss roles + recruit roles.
- **Placeholder recordings during development** acceptable; final recording in last 6-9 months pre-launch.

---

## Audio Production (cross-reference Step 7)

### Music Deterioration Pipeline (signature mechanic, locked production scope)

- **5 deterioration tiers per Xyoner-space track** (per Step 7, Indie's scope-tiering recommendation):
  - Tier 1: Clean (Awakening 1-2)
  - Tier 2: Subtle Off-Notes (Awakening 3-4)
  - Tier 3: Skipping (Awakening 5-6)
  - Tier 4: Audible Corruption (Awakening 7-8)
  - Tier 5: Damaged-File (Awakening 9-10)
- **Solo-path estimated track count:** ~12-18 distinct Xyoner-space tracks. **5 tiers × ~15 tracks = ~75 distinct audio recordings** (full-scope path is ~125 recordings).
- **The McXyon's jingle is the highest-priority single audio asset.** Lock composition + 5 tiers in vertical slice.

### Other Audio Production Items

- **Pirate broadcast audio fidelity system** — skill-tied audio modulation. Custom audio engineering work.
- **Homebase ambient growth (4 stages)** — ~12-20 distinct ambient layers across 4 homebase stages.
- **Inner Voice text-rendering** — typography work (no audio, per locked text-only scope).
- **Combat audio** (Hotline Miami DNA) — synthwave/electronic, ~6-10 tracks (solo path).
- **Investigation audio** (Burial / Arca DNA) — ambient tension, ~4-8 tracks (solo path).
- **Per-ending coda music** — 3 distinct ending themes (solo path; 5 in full-scope).

### Audio Budget Summary

**Audio is the under-budgeted line item identified in the Brief.** Per Brief, "the music deterioration mechanic alone implies multi-version recordings of every Xyoner-space track." Estimated audio production cost: **2-3× standard indie game audio budget.** **Dedicated composer essential — even at solo-dev scope.** This is the line item where solo + AI breaks down hardest.

---

## Engineering / Tooling Production Notes

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

## Cross-Production Dependencies (the things that depend on other things)

- **Mole identity decision (Step 4 open question)** → drives anonymous-tip dossier authoring volume → drives writing pipeline scope.
- **Pulpit roster decision (4 sub-bosses vs. 1 rotating-mask boss)** → solo path recommends rotating-mask; full-scope path can support 4. **Decision tied to scope path selection.**
- **Inner Ring size (Brief Open Question #3)** → drives Compound endgame structure + final cinematic scope.
- **Engine selection (Brief Open Question #1)** → drives all engineering item scope; recommended bias toward Unity or Godot per Brief.
- **Localization tier decision** → drives translation budget; English-only at launch is the recommended baseline for both paths.
- **Vertical slice boss prototype** (recommendation: Trusted Anchor for solo path; Trusted Anchor + Fact Checker for full-scope) → locks per-boss writing template before scaling to remaining bosses.
- **Sensitivity-reader engagement timing** → must precede Pulpit boss writing, not follow it.

---

## Open Production Questions Carried to Architecture / Sprint Planning Phases

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

## Summary — Production Realism Statement

**Gnoy Simulator has two scope paths documented:**

**Full-scope North Star (3-5 person team):** 280,000-340,000 words; 13 bosses; 12 districts; 5 endings; 24 Inner Voices; 30-48 months from vertical slice. The full design as locked across the GDD and this NDD.

**Solo + Vibe-Coding Ship Target (Cpain confirmed):** 80,000-120,000 words; 5-7 bosses; 5-7 districts; 3 endings; 12 Inner Voices; 22-36 months from vertical slice start. **All design pillars survive the cut**; the satire pillar, the Truth Paradox, the Schrödinger's NPC, the Music Deterioration Mechanic, the build-gated geography, and the Sleep ending co-equality are all preserved.

**The single most important risk-mitigation action is locking the vertical slice scope and not exceeding it.** Per Brief: "vertical slice first; design supports content cuts; early-access path is structurally available." Solo + vibe-coding makes that constraint *more* binding, not less. **Every estimate above is achievable if and only if vertical slice discipline is maintained.**

The solo path is the recommended ship target. The full-scope path remains documented for future scaling.

---
