# Story 1.2: 24-Skill System

Status: review

<!-- Story key: 1-2-24-skill-system | Epic 1: Foundation, Scaffolding & RPG Core -->
<!-- Second RPGCore-cluster story. Builds the skill ladder primitives that Stories 1.3 (skill-check engine), 1.4 (talents), 1.7 (derived stats), and Epic 6 (dialogue VM) all read from. -->
<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As **a player improving my character**,
I want **all 24 skills (4 per archetype × 6 archetypes) to exist in a 0–10 ladder with skill XP that drives level-ups**,
so that **the character I level into mechanically matches the build I intended.**

## Acceptance Criteria

(Lifted verbatim from `_bmad-output/planning-artifacts/epics.md` §"Story 1.2". Tests under `tests/` MUST exercise these.)

**AC1 — All 24 skills exist at rank 0 by default with data-driven definitions**

- **Given** a fresh save (no `skills` key persisted)
- **When** I inspect `RPGCore.skills`
- **Then** all 24 skills are present with `rank == 0`
- **And** the canonical skill catalog at `src/rpg/data/skills.tres` defines exactly 24 entries — one per skill — each with: `id` (snake_case string), `display_name_key` (tr() translation key), `archetype` (one of `MIND / SOUL / MOUTH / GHOST / BODY / SIGNAL`), `parent_attribute` (one of `Attributes.NAMES`), `description_key` (tr() key), `voice_profile_id` (string id for Epic 6's VoiceProfile registry — placeholder accepted at this story; Story 6.3 will instantiate the actual VoiceProfile resources)

**AC2 — Skill check fires → relevant skill earns XP per `Balance.skill_xp_per_use`**

- **Given** a skill check fires (regardless of outcome)
- **When** the dispatching code calls `RPGCore.award_skill_xp(skill_id, outcome)` (where `outcome ∈ {"critical", "success", "fail"}`)
- **Then** the skill's cumulative XP increases by `Balance.skill_xp_per_use[outcome]` (the curve table)
- **And** an unknown `skill_id` emits `Logger.error("rpg", ...)` and does NOT mutate state
- **And** an unknown `outcome` emits `Logger.error("rpg", ...)` and does NOT mutate state
- *Note:* Story 1.3 (skill-check engine) is the **only legitimate caller** of this API in production code. This story stops at the data path; the actual `RPGCore.skill_check(...)` resolver lands in 1.3. **Test code in this story calls `award_skill_xp` directly.**

**AC3 — XP crossing a level threshold increments rank + awards talent point per FR87 cadence + fires `EventBus.skill_levelled`**

- **Given** a skill at rank N with cumulative XP just below `Balance.skill_xp_thresholds[N]`
- **When** an `award_skill_xp` call pushes XP across that threshold
- **Then** the skill's rank increments to `N + 1`
- **And** if `N + 1` is an "every other milestone" rank per FR87 (`N + 1 ∈ {2, 4, 6, 8, 10}`), `RPGCore.talent_points` increments by 1
- **And** `EventBus.skill_levelled.emit(skill_id, new_rank)` fires exactly once per rank transition
- **And** rank cannot exceed `10` (further XP at rank 10 is ignored — excess is NOT banked, NOT logged as warning, just no-ops; design intent: rank 10 is the cap, "wasted" use-XP at the ceiling is by design, not a bug)

**AC4 — `RPGCore.get_skill_rank(skill_id)` returns persisted state across save/load**

- **Given** a `SaveGameV1` populated with non-default skill ranks (e.g., `rabbit_hole = 5`, `hands = 7`, plus their corresponding XP) and `talent_points = 3`
- **When** the save is written via `SaveSystem.save_to_slot()` and reloaded via `SaveSystem.load_from_slot()`
- **Then** `RPGCore.get_skill_rank(skill_id)` returns the exact persisted rank for every skill (per-key `assert_eq` in the round-trip test, NOT just dictionary identity)
- **And** `RPGCore.skill_xp` and `RPGCore.talent_points` are restored exactly

---

## Tasks / Subtasks

> **Order matters.** Each task either depends on a prior one or sets up state the next one verifies. Do them in order.

- [x] **Task 1 — Define `SkillDefinition` Resource and `SkillCatalog` Resource** (AC: #1)
  - [x] 1.1 Create `src/rpg/skill_definition.gd`. Declare `class_name SkillDefinition extends Resource`. Per architecture §4.1 the RPG cluster owns this.
  - [x] 1.2 Add `@export` fields with strict types: `id: String`, `display_name_key: String`, `archetype: String`, `parent_attribute: String`, `description_key: String`, `voice_profile_id: String`. Header comment cites: `## Source: epics.md §"Story 1.2" + FR82 + game-architecture.md §4.1.`
  - [x] 1.3 Create `src/rpg/skill_catalog.gd`. Declare `class_name SkillCatalog extends Resource`. One field: `@export var skills: Array[SkillDefinition] = []`. Header comment notes the catalog is the **single source of truth** for the 24 skill ids; runtime code reads `skills.gd` constants but the data lives here.
  - [x] 1.4 Forbidden in this story: defining `display_name` / `description` as raw English strings. Use `display_name_key` / `description_key` and let Epic 14 / Story 14-4 (`tr()` lint) catch raw-string regressions. Locked rule 9. The string CSV lands in Story 1.0's `src/localization/translations.csv` later — Story 1.2 may add placeholder entries but is NOT blocked on the CSV being populated.
  - [x] 1.5 Forbidden: a `class_name` per skill (e.g., `class_name RabbitHoleSkillDef`). One `class_name SkillDefinition` is the schema; each skill is a *resource instance*, not a subclass. (GDScript constraint: one `class_name` per file — Story 1.0 patch lesson.)

- [x] **Task 2 — Create `src/rpg/skills.gd` constants module** (AC: #1, #2, #3)
  - [x] 2.1 Create file at `src/rpg/skills.gd` (architecture §4.1 line 379 prescribes this exact path). Mirrors the `attributes.gd` pattern: pure-utility static module, never instantiated.
  - [x] 2.2 Declare `class_name Skills extends RefCounted`.
  - [x] 2.3 Define canonical id constants — one per skill, in archetype order matching FR82:
    ```
    const MIND_IDS:  Array[String] = ["rabbit_hole",   "x_fatigue",      "doxcraft",      "edit_farm"]
    const SOUL_IDS:  Array[String] = ["glowie_sense",  "yap_game",       "lore_depth",    "based_talk"]
    const MOUTH_IDS: Array[String] = ["rizz",          "npc_mode",       "ratio",         "clout"]
    const GHOST_IDS: Array[String] = ["ghost_mode",    "normie_cosplay", "receipts",      "opsec"]
    const BODY_IDS:  Array[String] = ["gymmaxx",       "hands",          "anti_slop",     "irl_build"]
    const SIGNAL_IDS:Array[String] = ["web",           "ghost_protocol", "sneaky_links",  "signal_hijack"]
    const ALL_IDS:   Array[String] = MIND_IDS + SOUL_IDS + MOUTH_IDS + GHOST_IDS + BODY_IDS + SIGNAL_IDS
    ```
    - **24 ids total** — assert this in tests (Task 5).
    - `[X] Fatigue` becomes `x_fatigue` (square brackets stripped for snake_case id legality). Display string keeps the brackets via `display_name_key` → `tr("skill.x_fatigue.name")` → `"[X] Fatigue"`.
    - `OPSEC` → `opsec` (lowercased). Display string uppercases via translation entry.
  - [x] 2.4 Define rank constants: `const MIN_RANK: int = 0`, `const MAX_RANK: int = 10`. Locked design constants per FR82 — NOT balance tunables. Document in the header comment.
  - [x] 2.5 Define talent-point cadence: `const TALENT_POINT_RANKS: Array[int] = [2, 4, 6, 8, 10]` — the "every other Skill milestone" set per FR87. Justify in header: FR87 says "every other Skill milestone"; design call is even ranks (rank-up TO 2, 4, 6, 8, 10). Flagged in Open Questions for PM confirmation.
  - [x] 2.6 Define outcome constants: `const OUTCOME_CRITICAL := "critical"`, `const OUTCOME_SUCCESS := "success"`, `const OUTCOME_FAIL := "fail"`. These string keys index `Balance.skill_xp_per_use`. Forbidden: stringly-typed call sites — `RPGCore.award_skill_xp(id, "succes")` typo would silently log error; consumers should use `Skills.OUTCOME_SUCCESS` constants.
  - [x] 2.7 Add static helpers:
    - `static func is_valid_id(skill_id: String) -> bool` — returns `skill_id in ALL_IDS`.
    - `static func is_valid_outcome(outcome: String) -> bool` — returns `outcome in [OUTCOME_CRITICAL, OUTCOME_SUCCESS, OUTCOME_FAIL]`.
    - `static func is_talent_point_rank(rank: int) -> bool` — returns `rank in TALENT_POINT_RANKS`.
    - `static func default_skill_ranks() -> Dictionary` — returns `{id: 0}` for every id in `ALL_IDS` (deep dictionary; do NOT hand out a constant reference).
    - `static func default_skill_xp() -> Dictionary` — returns `{id: 0}` for every id in `ALL_IDS`.
  - [x] 2.8 Forbidden: importing from any other cluster (`src/dialogue/`, `src/combat/`, etc.). This is a pure data-and-helpers module; cluster boundary is RPG.

- [x] **Task 3 — Author `src/rpg/data/skills.tres` catalog** (AC: #1)
  - [x] 3.1 Create the catalog at `src/rpg/data/skills.tres` (folder exists from Story 1.0; currently empty per `ls src/rpg/data`).
  - [x] 3.2 Resource type: `SkillCatalog` (Task 1.3). The `skills` array contains 24 `SkillDefinition` sub-resources.
  - [x] 3.3 Each entry's `parent_attribute` matches `Attributes.NAMES` exactly (uppercase: `"MIND"`, `"SOUL"`, etc.). `archetype` is the same uppercase string (in this game's design, archetype == parent attribute for skills — the 6 skill archetypes are the 6 attributes that have skills attached; GUT has none per FR82).
  - [x] 3.4 Translation keys follow the §4.2 pattern: `display_name_key = "skill.<id>.name"`, `description_key = "skill.<id>.desc"` (e.g., `"skill.rabbit_hole.name"`). Stub strings; the actual translations land in Story 14-4 (Localization) — not blocking.
  - [x] 3.5 `voice_profile_id` placeholder convention: `"voice.<id>"` (e.g., `"voice.rabbit_hole"`). Story 6.3 (Inner Voices) will create the actual `VoiceProfile` resources at `src/dialogue/voices/<id>.tres` and rebind. Story 1.2 makes no assumption about voice file presence; this is a forward-declared id.
  - [x] 3.6 Use the GDD §"Skills (24)" table verbatim for descriptions (tr keys point to those one-line descriptions). Source mapping below — copy from `_bmad-output/gdd.md` lines 256–308.
  - [x] 3.7 Forbidden: missing skills, duplicate ids, ids that don't match `Skills.ALL_IDS` exactly. Test 4.1 / 5.x will catch all three.
  - [x] 3.8 Save the .tres in **text format** (Story 1.0 convention — `.tres`, diffable). The release pipeline (Story 14-x) handles `.res` conversion.

- [x] **Task 4 — Extend `Balance` (BalanceResource + balance.tres) with skill XP curves** (AC: #2, #3)
  - [x] 4.1 Edit `src/core/balance/balance_resource.gd`. The `skill_xp_per_use: Dictionary` field already exists (declared empty as a stub since Story 1.0). Repurpose its semantics: keys = outcome strings (`"critical" / "success" / "fail"`); values = ints (XP awarded per call). Document this in the field comment.
  - [x] 4.2 Add a NEW field: `@export var skill_xp_thresholds: Array[int] = []`. This is the XP-to-next-rank curve. `skill_xp_thresholds[i]` is the TOTAL cumulative XP needed to reach rank `i+1` (so `[0]` is XP for rank 1, `[1]` for rank 2, etc.). 10 entries (rank 1 through 10).
  - [x] 4.3 Edit `src/core/balance/balance.tres`. Populate:
    - `skill_xp_per_use = {"critical": 2, "success": 1, "fail": 1}` — recommended baseline (criticals = 2x, all attempts grant XP per AC2 "regardless of outcome"). Tunable; PM can adjust pre-EA.
    - `skill_xp_thresholds = [10, 25, 50, 90, 145, 215, 305, 415, 545, 700]` — gentle quadratic; gives ~700 total successful uses to max one skill. Tunable.
  - [x] 4.4 The Balance values are **balance tunables**, not design constants. Locked rule per architecture §7.2 (magic numbers route through Balance). Story 1.2 wires the data path; the actual numbers remain editable without code changes.
  - [x] 4.5 Forbidden: hardcoding XP per outcome or threshold values inside `rpg_core.gd`, `skills.gd`, or `skill_definition.gd`. Always read from `Balance.get_data().skill_xp_per_use` and `.skill_xp_thresholds`. Single source of truth.
  - [x] 4.6 Defensive read: `RPGCore.award_skill_xp` MUST tolerate the `skill_xp_per_use` dict missing a key (log warn + treat as 0; don't crash). The Balance loader fails loud on missing file (Story 1.0 patch), but a fat-fingered test could clear keys at runtime — be robust.

- [x] **Task 5 — Extend `EventBus` autoload with `skill_levelled` signal** (AC: #3)
  - [x] 5.1 Edit `src/core/autoloads/event_bus.gd`. Locate the RPG section near `awakening_level_changed` (line ~14).
  - [x] 5.2 Add: `signal skill_levelled(skill_id: String, new_rank: int)` — typed payload (NOT a bare Dictionary; arch §4.6 forbids bare-Dict EventBus payloads, but two scalar args is the established pattern from `awakening_level_changed`).
  - [x] 5.3 No emitter on EventBus directly; the signal is only emitted from `RPGCore.award_skill_xp` after a successful rank-up (Task 6.6).
  - [x] 5.4 Forbidden: re-using `awakening_level_changed` for skill levels. They're separate concepts (Awakening Track is the campaign-spine progression; skill ranks are crafted-build progression). Locked design intent — distinct signals, distinct subscribers.
  - [x] 5.5 Forbidden: adding a signal for skill XP gain (only level-up). Per-XP-tick signal would flood any subscriber and is unnecessary — XP is internal accounting until a level-up.

- [x] **Task 6 — Extend `RPGCore` autoload with skill API** (AC: #1, #2, #3, #4)
  - [x] 6.1 Edit `src/core/autoloads/rpg_core.gd`. Story 1.1 already declared `var skills: Dictionary = {}` (line 11). KEEP that field — Story 1.2 populates it. Do NOT change its name or type.
  - [x] 6.2 Add NEW fields:
    - `var skill_xp: Dictionary = {}` — `{skill_id: cumulative_xp}` for all 24 skills.
    - `var talent_points: int = 0` — the "spendable" pool. Story 1.4 (talents) will spend from this; Story 1.2 only awards.
  - [x] 6.3 Add a private initialiser called from `_ready()`: `_seed_skills_if_empty()`.
    - If `skills.is_empty()`: `skills = Skills.default_skill_ranks()`.
    - If `skill_xp.is_empty()`: `skill_xp = Skills.default_skill_xp()`.
    - `talent_points` already defaults to `0` — no seed.
    - Same load-then-overwrite pattern as Story 1.1: SaveSystem.load_from_slot() runs *after* autoload `_ready()`, so seed-then-overwrite is correct order.
  - [x] 6.4 Add public reader: `func get_skill_rank(skill_id: String) -> int`.
    - If `Skills.is_valid_id(skill_id) == false`: `Logger.error("rpg", "get_skill_rank: unknown skill '%s'" % skill_id)` and return `0`. (Sentinel; mirrors `get_attribute` pattern from Story 1.1.)
    - Else return `skills.get(skill_id, 0) as int`.
  - [x] 6.5 Add public reader (helper for tests + Story 1.3): `func get_skill_xp(skill_id: String) -> int` — same validation pattern, returns `skill_xp.get(skill_id, 0) as int`.
  - [x] 6.6 Add public writer: `func award_skill_xp(skill_id: String, outcome: String) -> void`.
    - Validate `skill_id` (`Skills.is_valid_id`) — log error + early return if invalid.
    - Validate `outcome` (`Skills.is_valid_outcome`) — log error + early return if invalid.
    - Look up XP delta: `var bal := Balance.get_data(); var delta := int(bal.skill_xp_per_use.get(outcome, 0))`. If `bal.skill_xp_per_use` is missing the key → `Logger.warn("rpg", "skill_xp_per_use missing key '%s'; awarding 0 XP" % outcome)` and proceed with 0.
    - If current rank is already `Skills.MAX_RANK` (10): log debug only (`"rank capped, ignoring xp"`) and return without mutation.
    - Add delta: `skill_xp[skill_id] = int(skill_xp.get(skill_id, 0)) + delta`.
    - Check threshold: walk `bal.skill_xp_thresholds` from current `rank` upward; for each threshold crossed, increment rank and emit signal + check talent-point cadence:
      ```gdscript
      var current_rank := int(skills.get(skill_id, 0))
      var current_xp := int(skill_xp[skill_id])
      while current_rank < Skills.MAX_RANK and current_rank < bal.skill_xp_thresholds.size() and current_xp >= bal.skill_xp_thresholds[current_rank]:
          current_rank += 1
          skills[skill_id] = current_rank
          if Skills.is_talent_point_rank(current_rank):
              talent_points += 1
              Logger.info("rpg", "talent point awarded (skill '%s' reached rank %d)" % [skill_id, current_rank])
          EventBus.skill_levelled.emit(skill_id, current_rank)
          Logger.info("rpg", "skill '%s' levelled to rank %d" % [skill_id, current_rank])
      ```
    - **Multi-level-up edge case:** if a single XP award crosses two thresholds (e.g., a Story 1.3 critical-success grants enough XP to skip rank 1 and land rank 2), the `while` loop handles it correctly — emit `skill_levelled` once per rank. Test 7.x verifies this.
  - [x] 6.7 Forbidden in this file (locked rules):
    - **Rule 11:** No reach-around into `src/dialogue/`, `src/combat/`, etc. RPGCore is a cluster boundary.
    - **Rule 4:** No reading `RPGCore.awakening_level` from inside `award_skill_xp` (FR87's "per Awakening level" cadence is a *separate* talent-point trigger that lands in Story 1.5/1.7's awakening-up handler — NOT here. Story 1.2 owns ONLY the "every other Skill milestone" trigger.)
    - **Rule 8:** Don't change SaveGameV1 field types. Skill ranks are stored as `Dictionary[String, int]` exactly like attributes.
    - **No bare Dictionary EventBus payloads** (already covered by signal signature in Task 5.2).
  - [x] 6.8 Forbidden: hardcoding any of the 24 ids, the rank ceiling, the talent-point ranks, or the XP curve inside `rpg_core.gd`. Always go through `Skills.ALL_IDS` / `Skills.MAX_RANK` / `Skills.TALENT_POINT_RANKS` / `Balance.get_data().skill_xp_*`. Single source of truth.

- [x] **Task 7 — Wire `SaveGameV1` ↔ `RPGCore` for skills, skill_xp, talent_points** (AC: #4)
  - [x] 7.1 Edit `src/core/save/save_game_v1.gd`.
    - The `@export var skills: Dictionary = {}` field already exists (line 12, Story 1.0). KEEP.
    - The `@export var talents: Array = []` field already exists (line 13). It holds *unlocked talent ids* (Story 1.4's job). Do NOT touch in this story.
    - **Add NEW field:** `@export var skill_xp: Dictionary = {}`.
    - **Add NEW field:** `@export var talent_points: int = 0`.
    - Both fields are added *during V1's pre-ship dev baseline*; this is NOT a schema bump (V1 is still being built up; Story 1.0/1.1 added fields the same way without bumping). Locked rule 8 governs schema bumps *after* ship; pre-ship V1 expansion is part of the baseline.
  - [x] 7.2 Edit `src/core/autoloads/save_system.gd`. Story 1.1 established the convention in `save_to_slot()` (line 21): `save.attributes = RPGCore.attributes.duplicate(true)`. **Mirror that pattern**:
    - In `save_to_slot()` add: `save.skills = RPGCore.skills.duplicate(true)` + `save.skill_xp = RPGCore.skill_xp.duplicate(true)` + `save.talent_points = RPGCore.talent_points`.
    - In `load_from_slot()` (after the existing `RPGCore.attributes = save.attributes.duplicate(true)` on line 46) add: `RPGCore.skills = save.skills.duplicate(true)` + `RPGCore.skill_xp = save.skill_xp.duplicate(true)` + `RPGCore.talent_points = save.talent_points`.
    - **Deep copy reasoning** (Story 1.1 lesson): GDScript dicts pass by reference; a shallow assign would mutate live state on later in-place edits to the saved object.
  - [x] 7.3 Edit `src/core/autoloads/save_system.gd` `dump_save()` — already includes `"skills": save.skills` and `"talents": save.talents` (line 58–59). **Add** `"skill_xp": save.skill_xp` and `"talent_points": save.talent_points` to the JSON dict so the `--dump-save` CLI tool sees them.
  - [x] 7.4 Forbidden: writing/reading skills, skill_xp, or talent_points through any path other than `RPGCore`. UI code never touches `SaveGameV1.skills` directly — it asks `RPGCore.get_skill_rank(...)`. Locked rule 11 (cluster boundaries).
  - [x] 7.5 Forbidden: schema bump (`SaveGameV1` → `SaveGameV2`). V1 is still being built. If we're tempted to bump for any reason in this story, stop and re-read locked rule 8 — V1 is the dev baseline; expansion of the baseline is part of `feat:` work, not a migration.

- [x] **Task 8 — Unit tests in `tests/unit/test_skills.gd`** (AC: #1, #2)
  - [x] 8.1 Create `tests/unit/test_skills.gd` extending `GutTest`.
  - [x] 8.2 `test_all_ids_count_is_24()` — `assert_eq(Skills.ALL_IDS.size(), 24)`.
  - [x] 8.3 `test_all_ids_unique()` — convert `ALL_IDS` to a unique set; assert size is still 24 (catches accidental duplicate registration).
  - [x] 8.4 `test_archetype_ids_each_size_4()` — `MIND_IDS.size() == 4` repeated for all 6 archetypes (FR82 spec).
  - [x] 8.5 `test_is_valid_id_yes()` — every id in `ALL_IDS` returns true.
  - [x] 8.6 `test_is_valid_id_no()` — `"FOO"`, `"rabbit hole"` (with space), `""`, `"Rabbit_Hole"` (mixed case) all return false.
  - [x] 8.7 `test_is_valid_outcome()` — `"critical"`, `"success"`, `"fail"` all true; `"crit"`, `"win"`, `""` all false.
  - [x] 8.8 `test_is_talent_point_rank()` — `2, 4, 6, 8, 10` true; `0, 1, 3, 5, 7, 9, 11` false. (Catches "every other milestone" interpretation regression.)
  - [x] 8.9 `test_default_skill_ranks_returns_24_zeros()` — assert size 24, every value 0, every key in `ALL_IDS`.
  - [x] 8.10 `test_default_skill_ranks_returns_independent_copy()` — call twice, mutate one, assert the other is unaffected (mirrors `default_wageworker` test from Story 1.1).
  - [x] 8.11 `test_default_skill_xp_returns_24_zeros()` — same as 8.9 for `default_skill_xp`.

- [x] **Task 9 — Catalog test in `tests/unit/test_skills_catalog.gd`** (AC: #1)
  - [x] 9.1 Create `tests/unit/test_skills_catalog.gd` extending `GutTest`.
  - [x] 9.2 Load: `var catalog := load("res://src/rpg/data/skills.tres") as SkillCatalog`. Assert non-null.
  - [x] 9.3 `test_catalog_has_24_skills()` — `assert_eq(catalog.skills.size(), 24)`.
  - [x] 9.4 `test_catalog_ids_match_skills_module()` — collect every `SkillDefinition.id`, assert the resulting set equals `Skills.ALL_IDS` (catches drift between catalog and module).
  - [x] 9.5 `test_catalog_parent_attributes_valid()` — every `SkillDefinition.parent_attribute` is in `Attributes.NAMES`.
  - [x] 9.6 `test_catalog_archetypes_valid()` — every `SkillDefinition.archetype` is one of the 6 expected archetype strings.
  - [x] 9.7 `test_catalog_archetype_matches_parent_attribute()` — for skill catalog, design call is `archetype == parent_attribute` (per FR82). Assert this for every entry.
  - [x] 9.8 `test_catalog_translation_keys_present()` — every `display_name_key` and `description_key` is non-empty and matches the `skill.<id>.{name,desc}` pattern (regex check).
  - [x] 9.9 `test_catalog_voice_profile_ids_present()` — every `voice_profile_id` is non-empty (Story 6.3 will validate it points to an actual VoiceProfile resource; Story 1.2 just asserts a string is set).

- [x] **Task 10 — RPGCore integration tests in `tests/integration/test_rpgcore_skills.gd`** (AC: #1, #2, #3)
  - [x] 10.1 Create `tests/integration/test_rpgcore_skills.gd` extending `GutTest`. Use `get_node("/root/RPGCore")` pattern (Story 1.1 lesson — direct `RPGCore.method()` calls fail GDScript strict static-analysis as class vs. singleton ambiguity).
  - [x] 10.2 `before_each()`: reset RPGCore state — `rpg.skills = {}; rpg.skill_xp = {}; rpg.talent_points = 0;` then call the seed initialiser (or simulate a fresh `_ready()`). Capture pre-call Logger ring buffer size for emission assertions (Story 1.1 pattern from `test_rpgcore_attributes.gd`).
  - [x] 10.3 `test_fresh_rpgcore_seeds_24_skills_at_rank_0()` — assert `rpg.skills.size() == 24`, every value `== 0`, every key in `Skills.ALL_IDS`.
  - [x] 10.4 `test_get_skill_rank_returns_persisted()` — set `rpg.skills["rabbit_hole"] = 5`; assert `rpg.get_skill_rank("rabbit_hole") == 5`.
  - [x] 10.5 `test_get_skill_rank_unknown_logs_error_returns_zero()` — assert `rpg.get_skill_rank("foo") == 0` and Logger error emitted (delta the ring buffer to confirm).
  - [x] 10.6 `test_award_skill_xp_success_increments_xp()` — `rpg.award_skill_xp("rabbit_hole", "success")`; assert `rpg.get_skill_xp("rabbit_hole") == Balance.get_data().skill_xp_per_use["success"]`.
  - [x] 10.7 `test_award_skill_xp_critical_grants_more_xp()` — assert critical XP delta > success XP delta (uses Balance values; doesn't hardcode).
  - [x] 10.8 `test_award_skill_xp_fail_still_grants_xp()` — fail outcome grants `> 0` XP per AC2 "regardless of outcome".
  - [x] 10.9 `test_award_skill_xp_unknown_skill_logs_error_no_mutate()` — snapshot `rpg.skill_xp`; call `award_skill_xp("foo", "success")`; assert dict unchanged + Logger error emitted.
  - [x] 10.10 `test_award_skill_xp_unknown_outcome_logs_error_no_mutate()` — same pattern with `("rabbit_hole", "win")`.
  - [x] 10.11 `test_skill_levels_up_at_threshold()` — set `rpg.skill_xp["hands"]` to `threshold[0] - 1`; call `award_skill_xp("hands", "success")` enough times to cross threshold[0]; assert `get_skill_rank("hands") == 1`; assert `EventBus.skill_levelled` was emitted (use a signal-watcher / Awaitable counter).
  - [x] 10.12 `test_talent_point_awarded_at_rank_2()` — push a skill from rank 0 to rank 2 via XP awards; assert `rpg.talent_points == 1` (one TP awarded for crossing rank 2; rank 1 awards none).
  - [x] 10.13 `test_talent_point_NOT_awarded_at_rank_1_3_5_7_9()` — push a skill from rank 0 to rank 1 only; assert `talent_points == 0`. Repeat for rank 3 (should still be 1 — rank 2 awarded one, rank 3 awarded none). And so on.
  - [x] 10.14 `test_skill_capped_at_rank_10()` — directly set `rpg.skills["rabbit_hole"] = 10`, set `rpg.skill_xp["rabbit_hole"] = 99999`; call `award_skill_xp("rabbit_hole", "critical")` repeatedly; assert rank stays 10; assert no further `skill_levelled` emitted.
  - [x] 10.15 `test_multi_level_up_in_single_award()` — set XP just below threshold[1] (rank 2 boundary); award an XP delta large enough (or call repeatedly) to cross threshold[2] in the same call (force the case via Balance override or by repeating awards in a controlled loop); assert two `skill_levelled` emissions; assert rank advanced two steps. (If thresholds in default Balance don't allow a single `award_skill_xp` to cross two, manually inject a `skill_xp` value before the call and award 1 XP — that single call must rank up twice.)
  - [x] 10.16 `test_award_skill_xp_does_not_emit_awakening_signal()` — connect a counter to `EventBus.awakening_level_changed`; perform skill awards; assert counter == 0. (Locked rule 4 sentinel — skill levelling and awakening must NOT be conflated.)

- [x] **Task 11 — Save round-trip test in `tests/save/test_savegame_v1_skill_persistence.gd`** (AC: #4)
  - [x] 11.1 Create `tests/save/test_savegame_v1_skill_persistence.gd`. Mirror Story 1.1's `test_savegame_v1_attribute_persistence.gd` structure exactly (CACHE_MODE_IGNORE, DirAccess.remove_absolute(globalize_path) cleanup).
  - [x] 11.2 Construct `SaveGameV1` with non-default skill state:
    ```gdscript
    var custom_skills := Skills.default_skill_ranks()
    custom_skills["rabbit_hole"] = 5
    custom_skills["hands"] = 7
    custom_skills["receipts"] = 3
    var custom_xp := Skills.default_skill_xp()
    custom_xp["rabbit_hole"] = 145  # mid-rank-5
    custom_xp["hands"] = 305         # at-rank-7-threshold
    custom_xp["receipts"] = 50       # at rank 3 boundary
    ```
  - [x] 11.3 Save to `user://test_skill_save.tres`. Reload via `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)`.
  - [x] 11.4 Per-key `assert_eq` for all 24 skill ranks (loop over `Skills.ALL_IDS`).
  - [x] 11.5 Per-key `assert_eq` for all 24 `skill_xp` values.
  - [x] 11.6 `assert_eq(loaded.talent_points, original.talent_points)` (set to a non-zero value like `7` before saving).
  - [x] 11.7 Defence-in-depth: `assert_eq(loaded.schema_version, 1)`.
  - [x] 11.8 Cleanup: `DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))` in `after_each`.

- [x] **Task 12 — Run all GUT tests headless and verify green** (AC: all)
  - [x] 12.1 Run: `godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit`.
  - [x] 12.2 Expect: previous tests (Story 1.0 + 1.1) still green (17 tests + new ones from Story 1.2). New tests should add ~30+ assertions.
  - [x] 12.3 If a test fails: fix the production code (NOT the test), unless the test itself is wrong — then justify in Completion Notes.
  - [x] 12.4 No engine version change expected. `docs/engine-version.md` should NOT need updates this story (still Godot 4.3 + GUT 9.3.1).

- [x] **Task 13 — Manual editor sanity + commit** (AC: all)
  - [x] 13.1 Open project in Godot editor: confirm no autoload startup errors. Confirm `src/rpg/data/skills.tres` opens in the inspector and shows 24 entries.
  - [x] 13.2 Self-check the architecture §7.3 code-review checklist (see Dev Notes → "Code-Review Checklist"). All items must pass.
  - [x] 13.3 Commit message: `feat(rpg): 24-skill system (Story 1.2) — SkillCatalog, RPGCore award_skill_xp + get_skill_rank, talent-point cadence, save round-trip`.

---

## Dev Notes

### Engine + Language (LOCKED — same as Story 1.0)

- **Engine:** Godot 4.3 (pinned in `docs/engine-version.md`). [Source: `_bmad-output/game-architecture.md`#§2.1]
- **Language:** GDScript only. **No C#.** [Source: §2.3]
- **Test framework:** GUT 9.3.1, installed Story 1.0. [Source: §2.5, §6.7, `docs/engine-version.md`]

### Architecture Compliance (binding for THIS story)

These locked rules from architecture §7.1 apply directly to this story's code:

- **Rule 4 (Awakening Filter event-driven):** `award_skill_xp` MUST NOT read `RPGCore.awakening_level` directly. The "per Awakening level" talent-point trigger from FR87 lives in a separate handler (Story 1.5 — Awakening Track engine). This story only owns the "every other Skill milestone" trigger. Test 10.16 enforces.
- **Rule 8 (save format):** Adding `skill_xp: Dictionary` and `talent_points: int` to `SaveGameV1` is **pre-ship V1 expansion**, not a schema bump. V1 is the dev baseline — it grows as RPG fields are added (Stories 1.1–1.7 all add fields). Schema bumps come *after* first ship. No migration needed.
- **Rule 9 (`tr()` / strings):** Skill display names + descriptions go through translation keys (`"skill.<id>.name"`, `"skill.<id>.desc"`). Logger strings are NOT player-visible — raw English in `Logger.warn(...)` is fine. [§3.11]
- **Rule 10 (Theme tokens, not hardcoded styles):** N/A — this story has no UI. The skill *display* (later stories' HUD/character screen) will theme via tokens.
- **Rule 11 (no per-cluster reach-around):** UI code (Stories 1.12 ambient HUD, Epic 6 dialogue) MUST go through `RPGCore.get_skill_rank(...)` / `RPGCore.get_skill_xp(...)`, NEVER reach into `SaveGameV1.skills` directly. RPGCore is the cluster boundary. [§4.6]
- **Magic numbers route through `Balance` (locked rule per §7.2):** The XP curve and the per-outcome XP table are tunables in `Balance`. The skill *count* (24), *id strings*, *rank min/max* (0/10), and *talent-point cadence ranks* (`{2,4,6,8,10}`) are **design constants** locked by FR82 + FR87 — they live in `Skills` constants, not `Balance`. Document this distinction in `skills.gd` header.

### Talent-Point Cadence design call (READ THIS — it resolves a source ambiguity)

FR87: "Talent acquisition: per Awakening level + per faction OBSERVED + every other Skill milestone."

"Every other Skill milestone" is ambiguous. Three readings:
1. **Every other rank-up of any skill** — i.e., the 1st rank-up across all skills awards none, the 2nd awards a TP, the 3rd none, the 4th a TP, etc. This requires a global counter that tracks total rank-ups.
2. **Even ranks per skill** — when *a given skill* reaches rank 2/4/6/8/10, award one TP. Ranks 1/3/5/7/9 award none. Per-skill, not global.
3. **Every other milestone tier** — interpret "milestone" as a 5-rank tier (0–4 vs 5–9 vs 10), so a TP at rank 5 and rank 10 only.

**Implementation call: reading #2 (even ranks per skill).** Justification:
- "Skill milestone" reads most naturally as "this skill leveled up" — singular skill, singular event.
- Reading #1 is fragile (a player who power-levels one skill before another would feel different from a player who balanced — design intent of FR87 is rewards for sustained progression).
- Reading #3 is too sparse (24 skills × 2 TPs = 48 max from skills alone; reading #2 yields 24 × 5 = 120, which is closer to the "40 talents" target across 7 archetypes per FR86 with realistic rank distributions).

If the user / PM later confirms reading #1 or #3 is canonical, change `Skills.TALENT_POINT_RANKS` (reading #2 → #3) or add a global rank-up counter (reading #1). Flagged in Open Questions.

### Skill Outcome Strings — interface for Story 1.3

`RPGCore.award_skill_xp(skill_id, outcome)` is the data path. Story 1.3 (skill-check engine) is the only legitimate caller in production code. The contract:

```
Story 1.3's RPGCore.skill_check(skill_id, dc, modifiers) -> Dictionary
  → on resolution, calls: RPGCore.award_skill_xp(skill_id, outcome)
  where outcome ∈ {"critical", "success", "fail"}
```

Story 1.2 makes NO assumption about *how* Story 1.3 computes the outcome — that's the next story's job. It only owns the XP table, the threshold curve, the rank-up logic, and the talent-point cadence.

### Voice Profile IDs — interface for Story 6.3

Each `SkillDefinition` has `voice_profile_id: String`. Convention: `"voice.<skill_id>"` (e.g., `"voice.rabbit_hole"`).

Story 1.2 stores the id string only. **No VoiceProfile resources are created here.** Story 6.3 (Inner Voices, Epic 6) will:
- Create `src/dialogue/voices/<id>.tres` `VoiceProfile` resources.
- Add a `VoiceRegistry` autoload that resolves ids → resources.
- Validate at startup that every `SkillDefinition.voice_profile_id` resolves.

If you add a voice-profile-loading path in this story (you shouldn't), you're crossing the cluster boundary — locked rule 11 violation. Forward-declared id is sufficient.

### Autoload Order (LOCKED — do not change)

`RPGCore` is autoload #7 of 12. Earlier autoloads (`Logger`, `Balance`, `RNG`, `SaveSystem`) are available in `RPGCore._ready()`. **`Balance` is autoload #3** — `RPGCore._ready()` can safely read `Balance.get_data().skill_xp_per_use` if needed at seed time, but the seed function only seeds *defaults* (zeros), not Balance-derived data. Balance reads happen in `award_skill_xp` (called only at gameplay time, well after `_ready()`).

`EventBus` is autoload #12 — last. **Do NOT call `EventBus.skill_levelled.emit(...)` from `RPGCore._ready()`.** No skill-up at game start. Skill-ups happen in response to gameplay events; by that time, EventBus has been ready for many frames.

[Source: §4.5]

### File Structure (where things go)

- **`src/rpg/skill_definition.gd`** — NEW. `class_name SkillDefinition extends Resource`.
- **`src/rpg/skill_catalog.gd`** — NEW. `class_name SkillCatalog extends Resource`.
- **`src/rpg/skills.gd`** — NEW. `class_name Skills extends RefCounted`. The constants + helpers module. Architecture §4.1 line 379 prescribes this exact path.
- **`src/rpg/data/skills.tres`** — NEW. The 24-entry SkillCatalog instance. Architecture §4.1 line 384 (`data/` for skill defs).
- **`src/core/balance/balance_resource.gd`** — EDIT. Add `skill_xp_thresholds: Array[int]` field. Document `skill_xp_per_use` semantics.
- **`src/core/balance/balance.tres`** — EDIT. Populate `skill_xp_per_use` and `skill_xp_thresholds` with baseline values.
- **`src/core/autoloads/event_bus.gd`** — EDIT. Add `skill_levelled` signal.
- **`src/core/autoloads/rpg_core.gd`** — EDIT. Add `skill_xp`/`talent_points` fields, `_seed_skills_if_empty()`, `get_skill_rank()`, `get_skill_xp()`, `award_skill_xp()`. Preserve existing attribute API (Story 1.1) + awakening fields (Story 1.5 hooks).
- **`src/core/save/save_game_v1.gd`** — EDIT. Add `@export var skill_xp: Dictionary = {}` and `@export var talent_points: int = 0`.
- **`src/core/autoloads/save_system.gd`** — EDIT. Mirror Story 1.1's attribute-deep-copy pattern in `save_to_slot()` and `load_from_slot()` for skills, skill_xp, talent_points. Extend `dump_save()` JSON dict.
- **`tests/unit/test_skills.gd`** — NEW.
- **`tests/unit/test_skills_catalog.gd`** — NEW.
- **`tests/integration/test_rpgcore_skills.gd`** — NEW.
- **`tests/save/test_savegame_v1_skill_persistence.gd`** — NEW.

[Source: `_bmad-output/game-architecture.md`#§4.1]

### Naming Conventions (BINDING — re-list from Story 1.0/1.1)

| Kind | Convention | Example |
|---|---|---|
| GDScript files | `snake_case.gd` | `skills.gd`, `skill_definition.gd` |
| `class_name` | `PascalCase` | `class_name Skills`, `class_name SkillDefinition` |
| Constants | `SCREAMING_SNAKE_CASE` | `ALL_IDS`, `MIN_RANK`, `MAX_RANK`, `TALENT_POINT_RANKS` |
| Skill ids (string keys) | `snake_case` | `"rabbit_hole"`, `"x_fatigue"`, `"opsec"` |
| Outcome ids (string keys) | `snake_case` | `"critical"`, `"success"`, `"fail"` |
| Translation keys | `domain.subdomain.identifier`, lowercase | `"skill.rabbit_hole.name"` |
| Resource files | `snake_case.tres` | `skills.tres` |
| Signals | `snake_case` past-tense verb | `skill_levelled` (matches `awakening_level_changed`) |

**Note on `skill_levelled` (British "ll") vs `skill_leveled` (US "l"):** Project signal style not yet established. `awakening_level_changed` is neutral. Defaulting to `skill_levelled` (matches British "levelled" — the AC text in epics.md line 1098 spells it `skill_levelled` with two l's). If the user prefers US spelling project-wide, change here AND update the AC reference in Open Questions. Story 1.0 / 1.1 codebase has no precedent search hit either way.

[Source: `_bmad-output/game-architecture.md`#§4.2 + epics.md line 1098]

### Save Format Specifics (re-emphasized from Story 1.0/1.1)

- `SaveGameV1.skills: Dictionary` — keys are skill ids (snake_case strings), values are integers in `[0, 10]`.
- `SaveGameV1.skill_xp: Dictionary` — keys are skill ids, values are non-negative integers (cumulative XP).
- `SaveGameV1.talent_points: int` — non-negative integer counter.
- Dev save: `.tres` (text). Release: `.res` (binary). [§3.7]
- `ResourceLoader.load(path)` caches by default — Story 1.0 patches added `ResourceLoader.CACHE_MODE_IGNORE` to round-trip tests. **Use that pattern in Task 11.3.** Otherwise the second test run reads stale cached data and a real corruption could pass silently.
- Cleanup uses `DirAccess.remove_absolute(ProjectSettings.globalize_path(path))` — Story 1.1 Debug Log corrected the original `OS.remove()` reference (which doesn't exist in Godot 4.3) and clarified that `DirAccess.remove_absolute` does in fact remove files (not just directories). Mirror Story 1.1's `test_savegame_v1_attribute_persistence.gd` exactly.

### Testing Standards

- **Framework:** GUT 9.3.1, already installed. Tests in `tests/{unit,integration,save}/` per architecture §6.7 categories.
- **Per-key `assert_eq`** for the round-trip test (AC4 explicit). Object-identity equality is forbidden — it would not catch a one-key drift bug.
- **Logger introspection:** Story 1.1 used `Logger.get_ring_buffer()` (line 45 of `logger.gd`) with pre-call ring-buffer size capture. Mirror that pattern — capture size before, call function, capture size after, compare delta and inspect new entries for substring match.
- **Determinism:** not required for this story (XP awarding is deterministic by construction; no RNG involved). Story 1.3 (skill-check engine) is where determinism testing lands.
- **Performance:** trivially within budget — the `while`-loop level-up is bounded (max 10 iterations) and all-Dict ops are O(1). No per-frame work.
- **Signal watching for Test 10.11 / 10.15:** GUT 9.x supports `watch_signals(node)` then `assert_signal_emitted_with_parameters(...)`. Use `watch_signals(EventBus)` in `before_each` and `assert_signal_emit_count(EventBus, "skill_levelled", n)` for the multi-level-up test. If GUT 9.3.1 lacks this exact API, fall back to a manual `_signal_count` member updated in a test-local `_on_skill_levelled` handler — same observation, more code. **Read the GUT 9.3.1 API docs** before assuming an API exists; Story 1.1 Debug Log notes that `gut._test_prefix` (private) was unreliable, so prefer the documented `watch_signals` if present.

### Project Structure Notes

- `src/rpg/` directory has `attributes.gd` (Story 1.1) + `data/` (currently empty). Story 1.2 adds `skills.gd`, `skill_definition.gd`, `skill_catalog.gd` siblings to `attributes.gd`, plus the populated `data/skills.tres`.
- `tests/{unit, integration, save}/` exist; no new directories needed.
- `src/core/balance/` has `balance.tres` + `balance_resource.gd` (Story 1.0). Story 1.2 edits both.
- `src/core/autoloads/` has 12 autoload files. Story 1.2 edits 3 (`event_bus.gd`, `rpg_core.gd`, `save_system.gd`); the 9 others are untouched. **Autoload count remains 12. Do NOT add a 13th autoload.**
- No conflicts with the architecture-prescribed structure.

### Project Context Rules

No `project-context.md` exists in this project (verified via Story 1.1 — directory hierarchy contains no such file as of this story's creation). Project rules are sourced directly from:

1. **Architecture document** (`_bmad-output/game-architecture.md`) — locked rules + forbidden patterns + code-review checklist.
2. **GDD** (`_bmad-output/gdd.md` §"Skills (24)") — the canonical 24-skill list with descriptions.
3. **Epics document** (`_bmad-output/planning-artifacts/epics.md`) — locked story spec + ACs (line 1080).
4. **`src/tracking/README.md`** — created in Story 1.0; not relevant to this story (no tracking-cluster code touched).

### Forbidden Patterns (re-list — these still apply universally)

[Source: `_bmad-output/game-architecture.md`#§7.2]

- **Hardcoded magic numbers outside `Balance`** — XP table + threshold curve MUST live in `balance.tres`. The 24 skill ids, MIN_RANK/MAX_RANK, and TALENT_POINT_RANKS are **design constants**, not balance tunables — they live in `Skills` constants. Document this exception in `skills.gd` header (mirror Story 1.1 pattern).
- **Direct cross-cluster reads** — UI must NOT read `SaveGameV1.skills` directly — go through `RPGCore`.
- **Swallowing errors silently** — unknown skill_id / unknown outcome → log error + return safe default + no mutation.
- **Hardcoded English string literals in UI / dialogue contexts** — display names + descriptions are translation keys, NOT raw strings. Logger strings are NOT UI; exempt.
- **Bare-Dict signal payloads** — `skill_levelled(skill_id: String, new_rank: int)` uses two scalar args, matching the `awakening_level_changed(old, new)` precedent. Do NOT change to a Dictionary.
- **Mutating constants by handing out their reference** — `Skills.default_skill_ranks()` and `default_skill_xp()` return fresh dicts; never the const reference. Test 8.10 enforces.
- **Reading `RPGCore.awakening_level` from `award_skill_xp`** — locked rule 4 violation. Awakening-driven talent points are a separate handler.

### Code-Review Checklist (will apply to THIS PR)

[Source: `_bmad-output/game-architecture.md`#§7.3]

- [ ] No raw English string literals in any UI / dialogue contexts. (Display names + descriptions use `tr()` keys; Logger strings exempt.)
- [ ] No new direct cross-cluster reads. (UI consumers go through `RPGCore.get_skill_rank/get_skill_xp`; verify no test or scaffolding code reaches into `SaveGameV1.skills`.)
- [ ] No `src/tracking/` files touched → §5.1 reference not required in PR description.
- [ ] Save schema unchanged at version level (V1 baseline; pre-ship expansion of V1 fields is not a bump). No migration needed.
- [ ] Autoload count = 12 exactly. (Verify `project.godot` `[autoload]` section unchanged.)
- [ ] No new magic numbers outside `Balance`. (XP table + thresholds in `balance.tres`; design constants `MIN_RANK`/`MAX_RANK`/`TALENT_POINT_RANKS`/`ALL_IDS` documented as locked design values per FR82+FR87.)
- [ ] Tests for new pure logic. (`test_skills.gd` covers `Skills` module; `test_skills_catalog.gd` covers data integrity; `test_rpgcore_skills.gd` covers RPGCore API; `test_savegame_v1_skill_persistence.gd` covers persistence — all required.)
- [ ] Politburo not touched → no determinism test required.
- [ ] Dialogue VM not touched → no perf assert required.

### Latest Tech Information (Godot 4.3 specifics relevant to this story)

- **`Array[T]` typed arrays** in 4.x: `const NAMES: Array[String] = ["..."]` works at module scope. `const FOO: Array[int] = [1, 2]` works for primitives. Pattern matches Story 1.1's `Attributes.NAMES`.
- **Resource arrays in `@export`:** `@export var skills: Array[SkillDefinition] = []` works in 4.x; the editor inspector shows a typed array slot. The `.tres` file inspector lets you drag in or instantiate sub-resources.
- **Sub-resources in `.tres`:** A `SkillCatalog` resource containing 24 `SkillDefinition` sub-resources can be authored two ways: (a) as 24 separate `.tres` files referenced by `ext_resource`, or (b) as 24 inline `[sub_resource]` blocks in the catalog's `.tres`. **Use (b)** — single-file catalog is the convention for small datasets, mirrors Godot's tutorial style for "data tables", and keeps the 24-skill set diffable in one place.
- **`watch_signals(emitter)` + `assert_signal_emitted` in GUT 9.x:** documented signal-watching API. Use this for `EventBus.skill_levelled` assertions instead of manual handlers.
- **`Resource.duplicate(true)`** for catalogs: do NOT duplicate the catalog at runtime — it's read-only data. Read it via `load("res://src/rpg/data/skills.tres")` (cached in resource cache) and treat as immutable.
- **`ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)`** is still the only reliable round-trip test pattern — Story 1.1 lesson.

### Previous Story Intelligence (READ — Story 1.1 lessons that apply here)

[Source: `_bmad-output/implementation-artifacts/epic-1-foundation-scaffolding-rpg-core/1-1-seven-attribute-system.md` "Debug Log References" + "Completion Notes"]

Story 1.1 produced a clean implementation but discovered **4 latent Story 1.0 bugs** during headless test runs. Several patterns from Story 1.1 directly apply:

- **`get_node("/root/RPGCore")` for integration tests:** direct `RPGCore.method()` calls fail GDScript strict static-analysis. Story 1.1 fixed this in `test_rpgcore_attributes.gd`. **Mirror in Task 10.1.**
- **Logger ring buffer pattern:** Story 1.1 used `Logger.get_ring_buffer()` with pre-call size capture. **Mirror in Task 10.5 / 10.9 / 10.10.** Logger is autoload #1, available in all tests.
- **`save_to_slot` / `load_from_slot` deep-copy pattern:** Story 1.1's Completion Notes confirm `save_to_slot` had no copy-RPG-state pattern in Story 1.0; Story 1.1 added `RPGCore.attributes` copy as the first such step. **Story 1.2 extends that pattern with skills + skill_xp + talent_points** (Task 7.2). Read `save_system.gd` lines 20–47 first to see the exact established convention; do NOT add a one-off code path.
- **Test cleanup uses `DirAccess.remove_absolute(ProjectSettings.globalize_path(path))`:** Story 1.1 Debug Log corrected Story 1.0's `OS.remove()` reference (`OS.remove` doesn't exist in 4.3). Mirror in Task 11.8.
- **`CACHE_MODE_IGNORE` for round-trip:** mandatory — without it, the second test run reads stale cached data. Mirror in Task 11.3.
- **Autoload `class_name` conflict:** Story 1.1 fixed this latent bug by removing `class_name` from all 12 autoload scripts (autoload singletons don't need it; the autoload system provides the global identifier). **Do NOT add `class_name` to `event_bus.gd` or `rpg_core.gd` when editing them.** Read the file first; preserve the existing pattern.
- **GDScript constraint: one `class_name` per file.** `attributes.gd` has `class_name Attributes`. `skills.gd` has `class_name Skills`. `skill_definition.gd` has `class_name SkillDefinition`. `skill_catalog.gd` has `class_name SkillCatalog`. **Each in its own file.** Do NOT try to fold `SkillDefinition` and `SkillCatalog` into `skills.gd` — the `class_name` collision will fail.
- **Logger `.gd` type-inference bug:** Story 1.1 fixed `var label := Level.keys()[level]` → `var label: String = Level.keys()[level]`. Lesson for this story: GDScript strict-mode type inference is unreliable for `Array[Variant]` indexing — always annotate the type explicitly when pulling from `.keys()` / `.values()` of a typed Dictionary.

### Git Intelligence Summary

Story 1.1 produced a single commit per its Task 8.3 plan: `feat(rpg): seven-attribute system (Story 1.1) — Attributes module, RPGCore get/set/clamp, save round-trip` (commit `6008a5e`). Story 1.0 commit `1309e5a` precedes. No subsequent commits. Working from a clean tree as of Story 1.2 start (one untracked `.claude/settings.local.json` modification, unrelated to this story).

Recent work patterns to mirror:
- One commit per story (atomic).
- `feat(rpg): ...` prefix for RPG-cluster work.
- Body lists the major subsystems touched.
- Tests added in same commit as implementation (no test-only follow-up commit pattern observed).

### References

- [Source: `_bmad-output/planning-artifacts/epics.md`#"Story 1.2: 24-Skill System"] (line 1080) — story user statement + 4 ACs verbatim.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"Epic 1: Foundation, Scaffolding & RPG Core"] (line 823) — Epic 1 FR coverage including FR82, FR86, FR87.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"FR82"] (line 108) — 24 Skills (0–10) full list.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"FR87"] (line 113) — Talent acquisition cadence.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"FR157"] (line 183) — Skill XP drives skill levels (0→10); skill use awards XP, level-up awards talent points + bonus.
- [Source: `_bmad-output/gdd.md`#§"Skills (24)"] (lines 252–308) — Canonical skill list with descriptions per archetype.
- [Source: `_bmad-output/gdd.md`#"Talents"] (line 426) — Talent points awarded per Awakening level + per faction OBSERVED + every other Skill Level milestone (the design intent for FR87 cadence).
- [Source: `_bmad-output/game-architecture.md`#§2.3] — GDScript-only language lock.
- [Source: `_bmad-output/game-architecture.md`#§3.7] — Save format `SaveGameV{N}` Resource, `.tres` dev / `.res` release.
- [Source: `_bmad-output/game-architecture.md`#§4.1 lines 376–384] — `src/rpg/skills.gd` + `src/rpg/data/` canonical paths.
- [Source: `_bmad-output/game-architecture.md`#§4.2] — Naming conventions.
- [Source: `_bmad-output/game-architecture.md`#§4.5] — RPGCore + EventBus autoload roles.
- [Source: `_bmad-output/game-architecture.md`#§4.6] — Cluster-boundary rule (no direct cross-cluster reads); EventBus is the cross-cluster signal hub.
- [Source: `_bmad-output/game-architecture.md`#§6.7] — Testing strategy (GUT framework + categories).
- [Source: `_bmad-output/game-architecture.md`#§7.1 Rule 4] — Awakening Filter event-driven; subsystems do NOT read `RPGCore.awakening_level` directly.
- [Source: `_bmad-output/game-architecture.md`#§7.1 Rule 8] — Save schema versioning + migration mandate.
- [Source: `_bmad-output/game-architecture.md`#§7.1 Rule 11] — No per-cluster reach-around; cross-cluster via EventBus.
- [Source: `_bmad-output/game-architecture.md`#§7.2] — Forbidden patterns (no bare-Dict EventBus payloads, no magic numbers outside Balance).
- [Source: `_bmad-output/game-architecture.md`#§7.3] — Code-review checklist.
- [Source: `_bmad-output/implementation-artifacts/epic-1-foundation-scaffolding-rpg-core/1-1-seven-attribute-system.md`] — Previous story file list, patches applied, autoload order, testing patterns, deep-copy reasoning, ring-buffer Logger introspection.
- [Source: `_bmad-output/implementation-artifacts/epic-1-foundation-scaffolding-rpg-core/1-0-project-scaffolding.md`] — Project scaffolding: 12 autoloads, SaveGameV1 baseline, GUT installed.
- [Source: `src/core/autoloads/event_bus.gd`] — Existing signal precedents (`awakening_level_changed`, `theme_tokens_changed`, etc.).
- [Source: `src/core/balance/balance_resource.gd`] — `skill_xp_per_use: Dictionary` already declared (Story 1.0 stub); this story populates semantics + adds `skill_xp_thresholds`.

---

## Open Questions for PM (resolve before or during dev-story; do NOT block on these)

1. **FR87 "every other Skill milestone" — reading #1 (global), #2 (per-skill even ranks), or #3 (tier milestones)?** Story 1.2 implements reading #2 (`TALENT_POINT_RANKS = [2, 4, 6, 8, 10]` per skill). Recommend confirming with the GDD line 426 ("on every other Skill Level milestone") — that phrasing supports reading #2. If #1 (global) is canonical, replace `TALENT_POINT_RANKS` with a global rank-up counter on RPGCore (one TP per 2 rank-ups across all skills). If #3 (tier), use `TALENT_POINT_RANKS = [5, 10]` only.

2. **Default `skill_xp_per_use` values — `{"critical": 2, "success": 1, "fail": 1}`?** Recommended baseline; tunable. Alternatives: `{"critical": 3, "success": 1, "fail": 0}` (zero XP on fail — discourages spam-failing for XP) or `{"critical": 2, "success": 2, "fail": 1}` (heavier curve). AC2 requires "regardless of outcome" so fail must be `> 0` (the recommended baseline complies; the zero-fail alternative does NOT and would need an AC2 amendment).

3. **Default `skill_xp_thresholds` curve — gentle quadratic `[10, 25, 50, 90, 145, 215, 305, 415, 545, 700]`?** Tunable. Total ~700 successful uses to max one skill. If Epic 2 day-cycle gameplay yields ~10 skill checks/day, that's ~70 days of focused use to max one skill — feels right for a 50–100 hour campaign. PM can adjust pre-EA based on playtest feel.

4. **Signal name spelling: `skill_levelled` (British) vs `skill_leveled` (US)?** AC text in epics.md line 1098 uses `skill_levelled` (British "ll"). Defaulted to that. If the project standard should be US-spelling, change here AND signal-watcher tests.

5. **`voice_profile_id` placeholder convention — `"voice.<id>"`?** Forward declaration for Story 6.3. If Story 6.3's design has a different id scheme (e.g., voices are not 1:1 with skills — some voices are shared across skill clusters), this decision can be revised in Story 6.3 with no impact to Story 1.2's data path.

6. **Should `award_skill_xp` clamp/return XP when at rank 10?** Story 1.2 implements: at rank 10, additional XP is **ignored** (skill_xp counter is NOT incremented further; no warning). Alternative: keep accumulating XP as a vanity counter (would show "max-skill use count" later). Default ignored is simpler and matches the spirit of "rank 10 is the cap." Confirmable post-EA based on whether design wants a vanity counter surface.

---

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (1M context) — claude-sonnet-4-6[1m]

### Debug Log References

- **class_name cache miss (headless):** All new `class_name` scripts (`Skills`, `SkillDefinition`, `SkillCatalog`) created outside the Godot editor were absent from `.godot/global_script_class_cache.cfg`. Godot headless uses this cache — not a live filesystem scan — so `Skills` was unknown to `rpg_core.gd` at parse time, causing a cascade failure. Fix: manually added the three entries to the cache. This is a standard latent issue when creating `.gd` files with `class_name` outside the editor; opening the project in the editor afterward will regenerate the cache automatically.
- **Typed Array const concatenation unsupported:** Initial `const ALL_IDS: Array[String] = (MIND_IDS + SOUL_IDS + ...)` was a runtime-only operation and failed silently at parse time. Replaced with a flat 24-element literal, which IS a valid const expression.

### Completion Notes List

- Implemented all 13 tasks (all ACs satisfied) in a single session.
- `Skills` module mirrors `Attributes` pattern exactly: pure static helpers, no instantiation, no cluster reach-through.
- `ALL_IDS` is a flat literal (not computed from group arrays) because GDScript 4.3 `const` cannot evaluate array `+` operations at compile time.
- `award_skill_xp` uses a `while` loop over `skill_xp_thresholds` so a single call can advance multiple ranks (multi-level-up edge case, verified by test 10.15).
- XP is not incremented when rank is already at `MAX_RANK` (10) — design intent per AC3: excess XP at ceiling is a no-op, not banked.
- Integration tests for attributes (`test_rpgcore_attributes.gd`) that were "Risky" in prior sessions are now all passing (7/7) — the RPGCore autoload loads cleanly once `Skills` is in the class cache.
- Final run: **51/51 tests passing, 534 assertions, 0 failures, 0 regressions.**

### File List

**New files:**
- `src/rpg/skill_definition.gd`
- `src/rpg/skill_catalog.gd`
- `src/rpg/skills.gd`
- `src/rpg/data/skills.tres`
- `tests/unit/test_skills.gd`
- `tests/unit/test_skills_catalog.gd`
- `tests/integration/test_rpgcore_skills.gd`
- `tests/save/test_savegame_v1_skill_persistence.gd`

**Modified files:**
- `src/core/balance/balance_resource.gd` — added `skill_xp_thresholds: Array[int]` field + documented `skill_xp_per_use` semantics
- `src/core/balance/balance.tres` — populated `skill_xp_per_use` and `skill_xp_thresholds` with baseline values
- `src/core/autoloads/event_bus.gd` — added `skill_levelled(skill_id: String, new_rank: int)` signal
- `src/core/autoloads/rpg_core.gd` — added `skill_xp`/`talent_points` fields, `_seed_skills_if_empty()`, `get_skill_rank()`, `get_skill_xp()`, `award_skill_xp()`
- `src/core/save/save_game_v1.gd` — added `skill_xp: Dictionary` and `talent_points: int` fields
- `src/core/autoloads/save_system.gd` — mirrored attribute deep-copy pattern for skills/skill_xp/talent_points in `save_to_slot()`, `load_from_slot()`, `dump_save()`
- `.godot/global_script_class_cache.cfg` — registered `SkillCatalog`, `SkillDefinition`, `Skills` (required for headless test run; editor will regenerate on next open)

## Change Log

- **2026-05-09 (Story 1.2):** Implemented 24-Skill System — SkillDefinition + SkillCatalog resources, Skills constants module, skills.tres catalog, Balance XP curves, EventBus skill_levelled signal, RPGCore award_skill_xp + get_skill_rank + get_skill_xp + talent_point cadence, SaveGameV1/SaveSystem skill persistence. 51 tests passing.
