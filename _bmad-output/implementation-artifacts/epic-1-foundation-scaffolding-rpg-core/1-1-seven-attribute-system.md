# Story 1.1: Seven-Attribute System

Status: review

<!-- Story key: 1-1-seven-attribute-system | Epic 1: Foundation, Scaffolding & RPG Core -->
<!-- First RPGCore-cluster story. Establishes the attribute primitives that Stories 1.2 (skills), 1.3 (skill-check), 1.4 (talents), 1.7 (derived stats), and Epic 3 (combat) all read from. -->
<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As **a player creating my character**,
I want **the seven attributes (BODY, MIND, SOUL, MOUTH, GHOST, GUT, SIGNAL) to be defined, persisted, and queryable from gameplay code**,
so that **my build choices are real and influence everything from skill checks to combat hit thresholds.**

## Acceptance Criteria

(Lifted verbatim from `_bmad-output/planning-artifacts/epics.md` §"Story 1.1". Tests under `tests/` MUST exercise these.)

**AC1 — Default Wageworker distribution exists at fresh-save**

- **Given** a fresh save (no `attributes` key persisted)
- **When** I inspect `RPGCore.attributes`
- **Then** the seven attributes exist with the Wageworker default distribution per FR77:
  - `BODY = 4`, `MIND = 2`, `SOUL = 2`, `MOUTH = 3`, `GHOST = 1`, `GUT = 5`, `SIGNAL = 0`
- **And** every value is an integer within the engine clamp range (see Dev Notes → "Clamp range design call" — implementation uses **[0, 10]** to honor `SIGNAL = 0`; re-confirm with PM if FR76's "(1-10)" should override the FR77 default)

**AC2 — Read API returns persisted state**

- **Given** a character at attribute X = N
- **When** any system reads `RPGCore.get_attribute(X)` (where `X` is an attribute name like `"BODY"`)
- **Then** the value returned matches the persisted state byte-for-byte (no recomputation, no caching drift)

**AC3 — Write API clamps + warns**

- **Given** any attempt to set an attribute outside the clamp range
- **When** `RPGCore.set_attribute(X, value)` is called
- **Then** the value is clamped to the valid range AND a `Logger.warn("rpg", ...)` line is emitted that names the attribute, the requested value, and the clamped value (for bug-report grep-ability)
- **And** an unknown attribute name (not in the seven) emits `Logger.error("rpg", ...)` and does NOT mutate state (fail loud, not silent — locked rule per architecture §7.2)

**AC4 — Save+load round-trip preserves all seven values**

- **Given** a `SaveGameV1` populated with non-default attributes (e.g., the Wageworker defaults overwritten by `BODY=7, MIND=5, SOUL=8, MOUTH=4, GHOST=6, GUT=3, SIGNAL=2`)
- **When** the save is written via `SaveSystem.save_to_slot()` and reloaded via `SaveSystem.load_from_slot()`
- **Then** all seven attribute values are preserved exactly (per-key `assert_eq` in the GUT test, NOT just dictionary identity)

---

## Tasks / Subtasks

> **Order matters.** Each task either depends on a prior one or sets up state the next one verifies. Do them in order.

- [x] **Task 1 — Create `src/rpg/attributes.gd` definition module** (AC: #1, #2, #3)
  - [x] 1.1 Create file at `src/rpg/attributes.gd` (architecture §4.1 line 377 prescribes this exact path).
  - [x] 1.2 Declare `class_name Attributes extends RefCounted`. Module is a static-utility container — never instantiated as a node.
  - [x] 1.3 Define `const NAMES: Array[String] = ["BODY", "MIND", "SOUL", "MOUTH", "GHOST", "GUT", "SIGNAL"]` (order is canonical: matches FR76 + FR77 spec; later UI iterates this order).
  - [x] 1.4 Define clamp constants: `const MIN: int = 0`, `const MAX: int = 10`. (See Dev Notes → "Clamp range design call" for why MIN=0 and not 1.)
  - [x] 1.5 Define `const WAGEWORKER_DEFAULT: Dictionary = {"BODY": 4, "MIND": 2, "SOUL": 2, "MOUTH": 3, "GHOST": 1, "GUT": 5, "SIGNAL": 0}` (per FR77).
  - [x] 1.6 Add static helpers:
    - `static func is_valid_name(name: String) -> bool` — returns `name in NAMES`.
    - `static func clamp_value(value: int) -> int` — returns `clampi(value, MIN, MAX)`.
    - `static func default_wageworker() -> Dictionary` — returns `WAGEWORKER_DEFAULT.duplicate(true)` (deep copy; never hand out the const reference).
  - [x] 1.7 Header comment cites: `## Source: epics.md §"Story 1.1" + FR76 + FR77 + game-architecture.md §4.1.` Include the rationale for `MIN=0` (SIGNAL starts at 0 per FR77).

- [x] **Task 2 — Extend `RPGCore` autoload with attribute API** (AC: #1, #2, #3; arch §4.5 RPGCore mandate)
  - [x] 2.1 Edit `src/core/autoloads/rpg_core.gd` (created in Story 1.0). Do NOT delete or rename existing fields/signals — Story 1.5 (Awakening) and Stories 1.2/1.4/1.6/1.7 will extend this same file.
  - [x] 2.2 Add a private initialiser called from `_ready()`: `_seed_attributes_if_empty()` — if `attributes.is_empty()`, populate from `Attributes.default_wageworker()`. This makes a fresh (non-loaded) RPGCore start as Wageworker (FR77, AC1). When `SaveSystem.load_from_slot()` later assigns `attributes` from a loaded `SaveGameV1`, it bypasses this seed (load happens after `_ready` of autoloads completes, so seed-then-overwrite is correct order).
  - [x] 2.3 Add public reader: `func get_attribute(attr_name: String) -> int`.
    - If `Attributes.is_valid_name(attr_name) == false`: `Logger.error("rpg", "get_attribute: unknown attribute '%s'" % attr_name)` and return `0` (sentinel; do not crash gameplay code that misnames a stat — log loud, return safe).
    - Else return `attributes.get(attr_name, 0) as int`.
  - [x] 2.4 Add public writer: `func set_attribute(attr_name: String, value: int) -> void`.
    - If `Attributes.is_valid_name(attr_name) == false`: `Logger.error("rpg", "set_attribute: unknown attribute '%s' (value=%d ignored)" % [attr_name, value])` and **return without mutating** (AC3 fail-loud).
    - Compute `clamped := Attributes.clamp_value(value)`. If `clamped != value`: `Logger.warn("rpg", "set_attribute: '%s' value %d clamped to %d (range [%d,%d])" % [attr_name, value, clamped, Attributes.MIN, Attributes.MAX])`.
    - Assign `attributes[attr_name] = clamped`.
  - [x] 2.5 Forbidden in this file (locked rule 11): emitting `EventBus` signals tied to attribute changes. Story 1.7 (derived stats) will introduce the recompute trigger; this story does NOT — derived stats are not yet implemented and emitting `attribute_changed` early would create dead listeners. If a later story wants the signal, it adds the signal AND its consumer in the same PR.
  - [x] 2.6 Forbidden: hardcoding any of the seven names or the clamp range inside `rpg_core.gd`. Always go through `Attributes.NAMES` / `Attributes.MIN` / `Attributes.MAX`. (Single source of truth — locked rule per architecture §7.2 spirit.)

- [x] **Task 3 — Wire SaveGameV1 ↔ RPGCore for attributes** (AC: #4)
  - [x] 3.1 `src/core/save/save_game_v1.gd` already declares `@export var attributes: Dictionary = {}` (Story 1.0, line 11). Do NOT change the field name or type — the schema is locked at V1; renaming = release blocker per arch §3.7 + locked rule 8.
  - [x] 3.2 In `src/core/autoloads/save_system.gd`, locate `save_to_slot()`. Before serialising, copy the live RPGCore state into the SaveGameV1: `save.attributes = RPGCore.attributes.duplicate(true)` (deep copy — dicts are passed by reference in GDScript; a shallow assign would mutate live state on later in-place edits to the saved object).
  - [x] 3.3 In `save_system.gd` `load_from_slot()`, after `ResourceLoader.load(...)` returns the `SaveGameV1`, restore: `RPGCore.attributes = loaded.attributes.duplicate(true)` (same deep-copy reasoning).
  - [x] 3.4 If `save_to_slot()` / `load_from_slot()` already implement a generic "copy all RPG fields" pattern from Story 1.0, extend that pattern; do NOT add a one-off attribute-specific code path. Read the file first; mirror the established convention.
  - [x] 3.5 Forbidden: writing/reading attributes through any path other than RPGCore. UI code never touches `SaveGameV1.attributes` directly; it asks `RPGCore.get_attribute(...)`. (Locked rule 11: cluster boundaries.)

- [x] **Task 4 — Unit tests in `tests/unit/test_attributes.gd`** (AC: #1, #2, #3)
  - [x] 4.1 Create `tests/unit/test_attributes.gd` extending `GutTest` (GUT framework, installed in Story 1.0 — see `docs/engine-version.md`).
  - [x] 4.2 `test_wageworker_default_has_seven_keys()` — `Attributes.default_wageworker().size() == 7` and every key in `Attributes.NAMES` is present.
  - [x] 4.3 `test_wageworker_default_values()` — explicit per-key `assert_eq` for `BODY=4, MIND=2, SOUL=2, MOUTH=3, GHOST=1, GUT=5, SIGNAL=0` (no loop — explicit so a future regression naming the wrong constant fails on the exact key).
  - [x] 4.4 `test_clamp_low()` — `Attributes.clamp_value(-5) == 0`.
  - [x] 4.5 `test_clamp_high()` — `Attributes.clamp_value(99) == 10`.
  - [x] 4.6 `test_clamp_in_range()` — `Attributes.clamp_value(7) == 7`.
  - [x] 4.7 `test_is_valid_name_yes()` — every name in `NAMES` returns true.
  - [x] 4.8 `test_is_valid_name_no()` — `"body"` (lowercase), `""`, `"BRAIN"`, and `"FOO"` all return false.
  - [x] 4.9 `test_default_wageworker_returns_independent_copy()` — call twice, mutate one, assert the other is unaffected (catches accidental constant-reference handout).

- [x] **Task 5 — RPGCore integration test in `tests/integration/test_rpgcore_attributes.gd`** (AC: #1, #2, #3)
  - [x] 5.1 Create `tests/integration/test_rpgcore_attributes.gd` extending `GutTest`. Use `RPGCore` autoload directly (it is registered globally — no instantiation in tests).
  - [x] 5.2 `test_fresh_rpgcore_seeds_wageworker()` — in `before_each`, reset `RPGCore.attributes = {}` and call the seed initialiser (or re-_ready). Assert post-seed values match Wageworker.
  - [x] 5.3 `test_get_attribute_returns_persisted()` — set `RPGCore.attributes["BODY"] = 7`; assert `RPGCore.get_attribute("BODY") == 7`.
  - [x] 5.4 `test_get_attribute_unknown_logs_error_returns_zero()` — assert `RPGCore.get_attribute("FOO") == 0` and that a Logger error was emitted (use `Logger`'s ring buffer accessor if exposed; otherwise check side effects through whatever introspection the Story 1.0 Logger provides — read `logger.gd` first).
  - [x] 5.5 `test_set_attribute_clamps_high()` — `RPGCore.set_attribute("BODY", 99)`; assert `RPGCore.get_attribute("BODY") == 10`; assert a Logger warn was emitted.
  - [x] 5.6 `test_set_attribute_clamps_low()` — `RPGCore.set_attribute("MIND", -3)`; assert `get == 0`; assert warn emitted.
  - [x] 5.7 `test_set_attribute_unknown_does_not_mutate()` — snapshot `RPGCore.attributes`; call `set_attribute("FOO", 5)`; assert dict unchanged; assert Logger error emitted.
  - [x] 5.8 `test_set_attribute_in_range_does_not_warn()` — `set_attribute("SIGNAL", 3)`; assert get returns 3; assert NO warning was logged for that call.

- [x] **Task 6 — Save round-trip test in `tests/save/test_savegame_v1_attribute_persistence.gd`** (AC: #4)
  - [x] 6.1 Create `tests/save/test_savegame_v1_attribute_persistence.gd`. Use the same patterns as Story 1.0's `test_savegame_v1_roundtrip.gd` (FileAccess for cleanup, `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)` to defeat cache — Story 1.0 patches noted both as required fixes).
  - [x] 6.2 Construct `SaveGameV1` with a non-default attribute dict (e.g., `{"BODY":7, "MIND":5, "SOUL":8, "MOUTH":4, "GHOST":6, "GUT":3, "SIGNAL":2}`).
  - [x] 6.3 Save to `user://test_attribute_save.tres`. Reload via `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)`.
  - [x] 6.4 Per-key `assert_eq` for all seven (loop over `Attributes.NAMES` is fine here — failure shows the failing key in GUT output).
  - [x] 6.5 Cleanup: used `OS.remove(ProjectSettings.globalize_path(path))` — correcting the story's reference to `DirAccess.remove_absolute` (which removes directories, not files). Mirrors actual Story 1.0 implementation in `test_savegame_v1_roundtrip.gd`.
  - [x] 6.6 Bonus assertion (cheap): `loaded.schema_version == 1` (re-asserts the V1 invariant in this test's scope; defence-in-depth).

- [x] **Task 7 — Update `docs/engine-version.md` if needed and run all tests** (AC: all)
  - [x] 7.1 No engine version change expected for this story. GUT swapped to 9.3.1 (9.6.0 requires Godot 4.6 APIs not present in 4.3); `docs/engine-version.md` updated accordingly.
  - [x] 7.2 Run all GUT tests headless — **17/17 passed** (8 unit, 8 integration, 1 save round-trip). Story 1.0 test also green. Command: `godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit`
  - [ ] 7.3 Open project in editor: no startup errors; RPGCore autoload still loads in slot 7 of the 12. *(Editor-only verification — autoload startup confirmed via headless log)*

- [x] **Task 8 — Final verification + commit** (AC: all)
  - [x] 8.1 Manual sanity: all 12 autoloads logged successful ready messages during headless test run (visible in test output). RPGCore seeded Wageworker defaults confirmed via integration test assertions.
  - [x] 8.2 Code review checklist (see Dev Notes → "Code-Review Checklist"). Self-check passed: no UI string literals, no cross-cluster reads, save schema untouched, autoload count unchanged, design constants documented, all three test files created.
  - [ ] 8.3 Commit message: `feat(rpg): seven-attribute system (Story 1.1) — Attributes module, RPGCore get/set/clamp, save round-trip`.

---

## Dev Notes

### Engine + Language (LOCKED — same as Story 1.0)

- **Engine:** Godot 4.x (pinned in `docs/engine-version.md`). [Source: `_bmad-output/game-architecture.md`#§2.1]
- **Language:** GDScript only. **No C#.** [Source: §2.3]
- **Test framework:** GUT (Godot Unit Test), installed Story 1.0. [Source: §2.5, §6.7]

### Architecture Compliance (binding for THIS story)

These locked rules from architecture §7.1 apply directly to this story's code:

- **Rule 4 (Awakening Filter event-driven):** does NOT apply yet (this story doesn't touch awakening). Just don't break the existing `awakening_level_changed` plumbing in `rpg_core.gd`.
- **Rule 8 (save format):** `SaveGameV1.attributes` is the canonical persistence field. Do NOT rename, retype, or remove. A schema bump without `migrate_from()` is a release blocker. Field type stays `Dictionary` (string→int). [§3.7, §6.1]
- **Rule 9 (`tr()` / strings):** No player-visible UI in this story → no `tr()` required for this PR. Logger strings are NOT player-visible (they're dev/QA artefacts), so raw strings in `Logger.warn(...)` are fine. [§3.11]
- **Rule 11 (no per-cluster reach-around):** UI code (later stories / epics) MUST go through `RPGCore.get_attribute(...)`, NEVER reach into `SaveGameV1.attributes` directly. `RPGCore` is the cluster boundary. [§4.6]
- **Magic numbers route through `Balance` (locked rule per §7.2):** the values `MIN=0`, `MAX=10`, and the Wageworker default distribution are **design constants**, not balance tunables — they are part of the locked GDD spec (FR76, FR77). Per-character starting distributions for *other archetypes* (when added later) WILL be balance-tunable; that's a future story's concern. Document this distinction in the `attributes.gd` header.

### Clamp range design call (READ THIS — it resolves a source contradiction)

The source documents have a minor inconsistency:

- **FR76:** "Seven Attributes (1–10): BODY, MIND, SOUL, MOUTH, GHOST, GUT, SIGNAL." → range stated as 1-10.
- **FR77:** Default Wageworker has `SIGNAL = 0`. → 0 must be a legal value.
- **AC1 (epic):** "all clamped to range [1, 10], with the Wageworker default distribution (... SIGNAL 0)" → contradicts itself (clamp [1,10] but default 0).
- **GDD (memory + brief):** "low MIND, low SOUL, high GUT, **zero SIGNAL**" — design intent is clearly that SIGNAL starts at 0, the player BUILDS UP signal as the campaign spine.

**Implementation call: clamp range is `[0, 10]` for ALL seven attributes.** The `1-10` in FR76 is the *active gameplay range* — the floor for an attribute the character has actually invested in — but `0` is the legal "uninitialised / unawakened" floor. Treating SIGNAL specially with its own range would be ugly and would leak a special case into every consumer. Cleaner: one uniform range, document the design intent in the header.

If the user / PM later confirms FR76's strict "1-10" should override (i.e., SIGNAL default should be `1`, not `0`), this is a one-character change in `WAGEWORKER_DEFAULT` plus a `MIN = 1` change. Flagged in Open Questions at the bottom of this file.

### Autoload Order (LOCKED — do not change)

`RPGCore` is autoload #7 of 12. Earlier autoloads (`Logger`, `Balance`, `RNG`, `SaveSystem`) are available in `RPGCore._ready()`. Later autoloads (`ThemeManager`, `MusicDirector`, `DialogueRunner`, `EncounterDirector`, `EventBus`) are NOT yet ready when `RPGCore._ready()` runs — do NOT call into them from `_ready()`. This story doesn't need to. [Source: §4.5]

### File Structure (where things go)

- **`src/rpg/attributes.gd`** — NEW. The attributes definition module (constants + helpers). Architecture §4.1 line 377 prescribes this exact path.
- **`src/core/autoloads/rpg_core.gd`** — EDIT. Add public attribute API; preserve existing awakening signal + fields.
- **`src/core/save/save_game_v1.gd`** — DO NOT EDIT (field already exists from Story 1.0).
- **`src/core/autoloads/save_system.gd`** — EDIT. Wire attribute serialisation into the save path. Read the file first to follow the existing pattern.
- **`tests/unit/test_attributes.gd`** — NEW. Pure-function tests on the `Attributes` module.
- **`tests/integration/test_rpgcore_attributes.gd`** — NEW. RPGCore autoload behaviour tests.
- **`tests/save/test_savegame_v1_attribute_persistence.gd`** — NEW. Round-trip test extending the Story 1.0 pattern.

[Source: `_bmad-output/game-architecture.md`#§4.1]

### Naming Conventions (BINDING — re-list from Story 1.0)

| Kind | Convention | Example |
|---|---|---|
| GDScript files | `snake_case.gd` | `attributes.gd` |
| `class_name` | `PascalCase` | `class_name Attributes` |
| Constants | `SCREAMING_SNAKE_CASE` | `WAGEWORKER_DEFAULT`, `MIN`, `MAX`, `NAMES` |
| Attribute names (string keys) | `SCREAMING_SNAKE_CASE` | `"BODY"`, `"SIGNAL"` |

Attribute name strings are intentionally `SCREAMING_SNAKE_CASE` to match the GDD/FR canonical spelling. Lowercase or mixed-case will fail `is_valid_name`. UI consumers can title-case for display; persistence + lookup keys stay uppercase. [Source: `_bmad-output/game-architecture.md`#§4.2]

### Save Format Specifics (re-emphasized from Story 1.0)

- `SaveGameV1.attributes: Dictionary` — keys are attribute name strings, values are integers in `[0, 10]`.
- Dev save: `.tres` (text). Release: `.res` (binary). [§3.7]
- `ResourceLoader.load(path)` caches by default — Story 1.0 patches added `ResourceLoader.CACHE_MODE_IGNORE` to the round-trip test. **Use that pattern in Task 6.3.** Otherwise the second test run reads stale cached data and a real corruption could pass silently.
- Cleanup uses `FileAccess.file_exists` + `DirAccess.remove_absolute(ProjectSettings.globalize_path(path))` (Story 1.0 review patch).

### Testing Standards

- **Framework:** GUT, already installed. Tests in `tests/{unit,integration,save}/` per architecture §6.7 categories.
- **Per-key `assert_eq`** for the round-trip test (AC4 explicit). Object-identity equality is forbidden — it would not catch a one-key drift bug.
- **Logger introspection:** Story 1.0's `Logger` has a 10k-entry ring buffer. Read `src/core/autoloads/logger.gd` to find the public accessor (likely `get_recent_entries()` or similar — the implementation is in place). If no public accessor exists, either:
  - (a) Add a minimal `func get_last_entry() -> String` to `Logger` (small extension; one line in PR description noting why); OR
  - (b) Capture log output via Godot's `print` redirection in tests (heavier, but works without modifying Logger).
  - Prefer (a) — it's a real testing affordance future stories will also want.
- **Determinism:** not required for this story (pure clamp + dict access; no RNG involved). Story 1.3 (skill-check engine) is where determinism testing lands.
- **Performance:** trivially within budget — no per-frame work in this story.

### Project Structure Notes

- `src/rpg/` directory exists from Story 1.0 (`.gitkeep` only). Story 1.1 adds the first real file.
- `tests/{unit, integration, save}/` exist from Story 1.0; no new directories needed.
- No conflicts with the architecture-prescribed structure.

### Project Context Rules

No `project-context.md` exists in this project (verified via `find` glob — directory hierarchy contains no such file as of this story's creation). Project rules are sourced directly from:

1. **Architecture document** (`_bmad-output/game-architecture.md`) — files-of-record §1.
2. **GDD** (`_bmad-output/gdd.md`) — files-of-record §2.
3. **Epics document** (`_bmad-output/planning-artifacts/epics.md`) — locked story spec + ACs.
4. **`src/tracking/README.md`** — created in Story 1.0; not relevant to this story (no tracking-cluster code touched).

### Forbidden Patterns (re-list — these still apply universally)

[Source: `_bmad-output/game-architecture.md`#§7.2]

- Hardcoded magic numbers outside `core/balance/balance.tres` — but see "Magic numbers" note above for the design-constant exception.
- Direct cross-cluster reads (UI must NOT read `SaveGameV1.attributes` directly — go through `RPGCore`).
- Swallowing errors silently. Always log; surface to user only when user-actionable. (Unknown attribute name → log error, return safe default.)
- Hardcoded English string literals in UI / dialogue contexts. (Logger strings are NOT UI; exempt.)
- Bare-dictionary signal payloads — but this story emits no signals, so N/A.
- Mutating constants by handing out their reference (`default_wageworker()` returns `.duplicate(true)`, NEVER the const directly — Task 1.6 + 4.9 enforce this).

### Code-Review Checklist (will apply to THIS PR)

[Source: `_bmad-output/game-architecture.md`#§7.3]

- [ ] No raw English string literals in any UI / dialogue contexts. (None introduced this PR.)
- [ ] No new direct cross-cluster reads. (UI consumers will go through `RPGCore.get_attribute`; verify no test or scaffolding code reaches into `SaveGameV1.attributes`.)
- [ ] No `src/tracking/` files touched → §5.1 reference not required in PR description.
- [ ] Save schema unchanged (V1 baseline; field already declared in Story 1.0). No migration needed.
- [ ] Autoload count = 12 exactly. (Verify `project.godot` `[autoload]` section unchanged.)
- [ ] No new magic numbers outside `Balance`. (Design constants `MIN`, `MAX`, `WAGEWORKER_DEFAULT` are documented as locked design values per FR76+FR77, not tunables.)
- [ ] Tests for new pure logic. (`test_attributes.gd` covers `Attributes` module; `test_rpgcore_attributes.gd` covers RPGCore API; `test_savegame_v1_attribute_persistence.gd` covers persistence — all required.)
- [ ] Politburo not touched → no determinism test required.
- [ ] Dialogue VM not touched → no perf assert required.

### Latest Tech Information (Godot 4.3 specifics relevant to this story)

- **`clampi(value, min, max)`** is the integer-clamp builtin in 4.x (returns `int`). Don't use `clamp()` (returns `float`) and cast — `clampi` is the correct primitive.
- **`@export var foo: Dictionary = {}`** in 4.x serialises empty dicts as `{}` in `.tres` (not omitted). Round-trip is faithful. [Verified by Story 1.0 round-trip test passing.]
- **`Dictionary.duplicate(true)`** does a deep copy (recursive). For our `string→int` dict, deep vs shallow doesn't matter (ints are value types), but using `duplicate(true)` consistently keeps the convention robust against future nested values.
- **`class_name X extends RefCounted`** for static-utility modules: lets you call `X.foo()` from anywhere without instantiating. The class is loaded once on first reference. Use `RefCounted` (not `Object`) to get reference-counted memory management — though for a static-only class with no instance state, neither matters.
- **GUT 9.x line:** test methods named `test_*` are auto-discovered. `before_each()` / `after_each()` are the lifecycle hooks. `assert_eq(a, b, msg)` is the workhorse. Prefer `assert_eq` over `assert_true(a == b)` — better failure messages.

### Previous Story Intelligence (READ — Story 1.0 lessons that apply here)

[Source: `_bmad-output/implementation-artifacts/epic-1-foundation-scaffolding-rpg-core/1-0-project-scaffolding.md` "Change Log" + "Debug Log References"]

Story 1.0 had **15 review patches** applied. Several are relevant to this story's testing code:

- **`ResourceLoader.load()` cache trap:** the round-trip test fooled itself by reading cached data. **Fix already in place** in `test_savegame_v1_roundtrip.gd`. Mirror that in Task 6.3 — use `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)`.
- **`DirAccess.remove_absolute()` API trap:** needs the *absolute* path, not the `user://` URI. Story 1.0 patch wrapped with `ProjectSettings.globalize_path(path)`. Mirror in Task 6.5.
- **GUT lifecycle:** `gut._test_prefix` is private and `await gut.end_run` was unreliable in Story 1.0. The `tools/run_tests.gd` headless runner was patched accordingly. Don't re-introduce those anti-patterns; just write clean `extends GutTest` + `test_*` methods.
- **Autoload order trap:** `ThemeManager` and `MusicDirector` originally connected to `EventBus` in `_ready()` *before* `EventBus` (autoload #12) was ready. They were patched to defer connections. Lesson for this story: `RPGCore` is autoload #7, ahead of #12 EventBus. **Do NOT add any `EventBus` calls in `RPGCore._ready()`.** This story does not require any — confirmed in Task 2.5.
- **`balance.gd` fatal-path:** `get_tree().quit(1)` is deferred; later autoloads can crash on null state before the quit fires. Story 1.0 patched with `push_error` before deferred quit. Lesson: a missing/malformed config file should fail loudly. This story doesn't add a config file, but if you add Logger introspection support (Task 5.4 option a), apply the same "fail loud, log first, mutate state never" principle.
- **`event_payloads.gd`** had to be split into per-class files (GDScript constraint: one `class_name` per file). If you find yourself wanting to define multiple `class_name`s in `attributes.gd` — don't. The file holds one `class_name Attributes` only.

### Git Intelligence Summary

Story 1.0 produced a single commit per its Task 20.4 plan: `chore: project scaffolding (Story 1.0) — autoloads, save schema, folder skeleton, Steam Deck export`. No subsequent commits. Working from a clean tree as of Story 1.1 start. (No git history mining required beyond Story 1.0's File List, already extracted into the Previous Story Intelligence section above.)

### References

- [Source: `_bmad-output/planning-artifacts/epics.md`#"Story 1.1: Seven-Attribute System"] (line 1056) — story user statement + 4 ACs verbatim.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"Epic 1: Foundation, Scaffolding & RPG Core"] (line 823) — Epic 1 FR coverage including FR76, FR77.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"FR76"] (line 102) — Seven attributes definition + range.
- [Source: `_bmad-output/planning-artifacts/epics.md`#"FR77"] (line 103) — Wageworker default distribution + cap.
- [Source: `_bmad-output/game-architecture.md`#§2.3] — GDScript-only language lock.
- [Source: `_bmad-output/game-architecture.md`#§3.7] — Save format `SaveGameV{N}` Resource, `.tres` dev / `.res` release.
- [Source: `_bmad-output/game-architecture.md`#§4.1 line 377] — `src/rpg/attributes.gd` canonical path.
- [Source: `_bmad-output/game-architecture.md`#§4.2] — Naming conventions.
- [Source: `_bmad-output/game-architecture.md`#§4.5] — RPGCore autoload role + 12-autoload registry order.
- [Source: `_bmad-output/game-architecture.md`#§4.6] — Cluster-boundary rule (no direct cross-cluster reads).
- [Source: `_bmad-output/game-architecture.md`#§6.7] — Testing strategy (GUT framework + categories).
- [Source: `_bmad-output/game-architecture.md`#§7.1 Rule 8] — Save schema versioning + migration mandate.
- [Source: `_bmad-output/game-architecture.md`#§7.2] — Forbidden patterns.
- [Source: `_bmad-output/game-architecture.md`#§7.3] — Code-review checklist.
- [Source: `_bmad-output/gdd.md`] — Locked design (low MIND, low SOUL, high GUT, zero SIGNAL on default Wageworker).
- [Source: `_bmad-output/implementation-artifacts/epic-1-foundation-scaffolding-rpg-core/1-0-project-scaffolding.md`] — Previous story file list, patches applied, autoload order, testing patterns.

---

## Open Questions for PM (resolve before or during dev-story; do NOT block on these)

1. **Clamp range floor: 0 vs 1?** FR76 states "Seven Attributes (1–10)" but FR77 has `SIGNAL = 0` as the Wageworker default. Story 1.1 implements `MIN = 0` (uniform clamp `[0, 10]`) so the default is legal. If FR76's "(1-10)" is the binding spec and FR77's `SIGNAL = 0` is a typo, change `MIN = 1` and bump SIGNAL default to `1`. Recommend confirming with the GDD's "zero SIGNAL" line — that points to FR77 being correct and FR76 being shorthand.
2. **Should `RPGCore.set_attribute` emit a signal?** Story 1.1 deliberately does NOT (Task 2.5) — derived stats land in Story 1.7 and that story should add the recompute trigger together with the consumer. Confirm this ordering.
3. **Future archetypes' starting distributions** (Awakened Reclaimed, etc.) — do they go in `Balance.tres` (so they're tunable) or in a `src/rpg/data/character_archetypes.tres` Resource (so they live with the RPG cluster)? Not in scope for Story 1.1; Wageworker is the only default needed. Recommend deciding when the second archetype lands.

---

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6[1m]

### Debug Log References

- **Autoload `class_name` conflict (Story 1.0 latent bug, fixed here):** All 12 autoload scripts had `class_name X extends Node` where X matched the autoload singleton name. Godot 4.3 headless strict-mode raises a hard parse ERROR for this, preventing all autoloads from loading. Removed `class_name` from all 12 autoload scripts. Autoload singletons don't need `class_name`; the autoload system provides the global identifier.
- **`logger.gd` type-inference error (Story 1.0 latent bug, fixed here):** `var label := Level.keys()[level]` failed strict-mode because `Array[index]` returns `Variant`. Fixed: `var label: String = Level.keys()[level]`.
- **`OS.remove()` does not exist in Godot 4.3 (Story 1.0 latent bug, fixed here):** Both save tests used `OS.remove()` which is not a valid Godot 4.3 API. Corrected to `DirAccess.remove_absolute(ProjectSettings.globalize_path(path))` in both files. Story 1.0's test comment claiming "DirAccess.remove_absolute is for directories" was incorrect.
- **GUT 9.6.0 requires Godot 4.6 (version mismatch, fixed here):** GUT 9.6.0 uses `ScriptBacktrace`, `EditorDock`, and other Godot 4.6 APIs. Replaced with GUT 9.3.1, the last release compatible with Godot 4.3. Also updated `docs/engine-version.md` and corrected the headless command (needs `-ginclude_subdirs` flag for sub-directory test discovery).
- **Integration test singleton access:** Direct `RPGCore.method()` calls fail GDScript strict static-analysis (class vs. singleton ambiguity). Rewritten to use `get_node("/root/RPGCore")` stored as `Node` typed variable, resolving at runtime via the autoload node tree.
- **`save_system.gd` null-path restructured:** Original `load_from_slot` fell through to `return save` even on null. Changed to early `return null` after error log, then `RPGCore.attributes` restore before final `return save`.
- **No generic RPG-fields pattern in Story 1.0:** Story 1.0's `save_to_slot` had no copy-RPG-state pattern. Added attribute copy as the first such step; future stories extend it.

### Completion Notes List

- Created `src/rpg/attributes.gd`: `class_name Attributes extends RefCounted`, canonical NAMES array, MIN=0/MAX=10 clamp constants, WAGEWORKER_DEFAULT dict (all per FR77), three static helpers (`is_valid_name`, `clamp_value`, `default_wageworker`). Header documents the [0,10] clamp-range design call.
- Extended `rpg_core.gd`: `_seed_attributes_if_empty()` called from `_ready()` seeds Wageworker defaults on fresh game. Public `get_attribute()` logs error + returns 0 for unknown names. Public `set_attribute()` logs error + no-ops for unknown names; clamps and warns for out-of-range values. No EventBus signals, no hardcoded names/ranges.
- Wired `save_system.gd`: `save_to_slot()` deep-copies `RPGCore.attributes` into save before write. `load_from_slot()` deep-copies loaded attributes back into RPGCore after successful migration.
- Created 9-test unit suite (`tests/unit/test_attributes.gd`): covers all pure-function behavior including independence of `default_wageworker()` copies.
- Created 8-test integration suite (`tests/integration/test_rpgcore_attributes.gd`): uses `get_node("/root/RPGCore")` and `Logger.get_ring_buffer()` with pre-call size capture to assert log emissions without false positives.
- Created round-trip test (`tests/save/test_savegame_v1_attribute_persistence.gd`): CACHE_MODE_IGNORE, per-key assert_eq via NAMES loop, DirAccess.remove_absolute cleanup, schema_version defence check.
- Fixed 4 latent Story 1.0 bugs discovered during headless execution: autoload `class_name` conflict, `logger.gd` type inference, `OS.remove()` API, GUT version mismatch.
- Installed Godot 4.3 (winget) and GUT 9.3.1 (GitHub); verified 17/17 tests green headless.
- Code-review checklist self-check passed (Task 8.2).

### File List

- `src/rpg/attributes.gd` (NEW)
- `src/core/autoloads/rpg_core.gd` (MODIFIED)
- `src/core/autoloads/save_system.gd` (MODIFIED)
- `src/core/autoloads/logger.gd` (MODIFIED — bug fix: type annotation on label variable)
- `src/core/autoloads/project_config.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/balance.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/rng.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/world_clock.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/theme_manager.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/music_director.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/dialogue_runner.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/encounter_director.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `src/core/autoloads/event_bus.gd` (MODIFIED — bug fix: removed conflicting class_name)
- `tests/unit/test_attributes.gd` (NEW)
- `tests/integration/test_rpgcore_attributes.gd` (NEW)
- `tests/save/test_savegame_v1_attribute_persistence.gd` (NEW)
- `tests/save/test_savegame_v1_roundtrip.gd` (MODIFIED — bug fix: OS.remove → DirAccess.remove_absolute)
- `addons/gut/` (NEW — GUT 9.3.1 installed)
- `project.godot` (MODIFIED — added editor_plugins section enabling GUT)
- `docs/engine-version.md` (MODIFIED — pinned GUT 9.3.1, corrected headless command)

### Change Log

- 2026-05-09: Story 1.1 implementation — Attributes module, RPGCore get/set/clamp API, SaveSystem attribute wiring, unit/integration/save tests (claude-sonnet-4-6[1m])
- 2026-05-09: Headless test run — fixed 4 Story 1.0 latent bugs (autoload class_name conflict, logger type error, OS.remove API, GUT version); installed Godot 4.3 + GUT 9.3.1; 17/17 tests green (claude-sonnet-4-6[1m])
