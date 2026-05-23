# Balance Guide — Magic-Number Taxonomy

**Architecture:** §3.9 (constants), §7.2 (forbidden patterns), §7.3 (review checklist)
**Lint tool:** `godot --headless -s tools/balance_validator.gd`

## The Rule of Thumb

> **If changing the number is a *tuning pass*, it is balance.**
> **If changing the number is a *design pivot*, it is a design constant.**

A tuning pass adjusts how much / how fast / how often without changing what the system *is*.
A design pivot changes a system's identity, contract, or invariant.

| Situation | Where it lives |
|---|---|
| "How much XP does a successful skill use grant?" | Balance — `skill_xp_per_use` |
| "What is the maximum rank a skill can reach?" | Code — `Skills.MAX_RANK` (FR82) |
| "How many minutes is a Morning slot?" | Balance — `slot_minutes` |
| "How many slots per day?" | Code — design pivot per FR33 (four slots is the design) |
| "What's the d20 face count?" | Code — `SkillCheck.DICE_FACES` (changing it breaks the 50%-at-parity invariant) |
| "What's the DC for a Pulpit dialogue check?" | Balance — `dc_table` |
| "Cope penalty when below threshold?" | Code — `DerivedStats.COPE_LOW_PENALTY` (FR79 spec) |
| "Cope threshold value?" | Code — `DerivedStats.COPE_LOW_THRESHOLD` (FR79 spec) |
| "Save autosave wall-clock budget warning?" | Balance — `save_perf_warn_ms` (NFR9-tied; see invariant test) |

## Currently-Locked Design Constants

These are NOT balance. Every entry below cites the FR / arch ref that locks it.

- `Attributes.MIN/MAX = 0/10` — FR76, FR77 (attribute clamp range)
- `Attributes.WAGEWORKER_DEFAULT = {…}` — FR77 (starting attribute distribution)
- `Skills.MIN_RANK/MAX_RANK = 0/10` — FR82 (skill rank cap)
- `Skills.TALENT_POINT_RANKS = [2, 4, 6, 8, 10]` — FR87 ("every other Skill milestone")
- `Disposition.MIN/MAX = -1.0/1.0` — Story 1.6 (axis range)
- `Disposition.STRONG_NEGATIVE/LEAN_NEGATIVE/LEAN_POSITIVE/STRONG_POSITIVE` — semantic labels (Story 1.6)
- `DerivedStats.MIN/MAX = 0/100` — Story 1.7 (derived-stat clamp)
- `DerivedStats.COPE_LOW_THRESHOLD = 25` — FR79 (cope-low gate)
- `DerivedStats.COPE_LOW_PENALTY = -2` — FR79 (cope-low skill-check penalty)
- `DerivedStats.COPE_LOW_NPC_MODE_EXTRA = -3` — FR79 (additional npc_mode penalty)
- `DerivedStats.FATIGUE_TIER_LOW_MAX/MEDIUM_MAX/HIGH_MAX = 25/50/75` — FR80 (fatigue tier bounds)
- `DerivedStats.FATIGUE_NPC_MODE_PENALTY = {low:0, medium:-1, high:-3, max:-6}` — FR80 (fatigue penalty curve)
- `DerivedStats.FATIGUE_PATTERN_BONUS = {…, max: 5}` — FR80 (max-fatigue pattern-skill bonus)
- `SkillCheck.DICE_FACES = 20` — Story 1.3 (d20 invariant — 50% at parity)
- `SkillCheck.DC_OFFSET = 11` — Story 1.3 (50%-at-parity invariant)
- `SkillCheck.NAT_CRIT/NAT_FAIL = 20/1` — Story 1.3 (natural-roll outcomes)
- `RPGCore.AWAKENING_MAX = 10` — FR82 / GDD §Awakening Track (10 levels)
- `RPGCore.AWAKENING_CINEMATIC_LEVELS = [1, 5, 10]` — Story 1.5 (cinematic gate levels)
- `SaveSystem.CURRENT_SCHEMA_VERSION = 1` — Story 1.9 (schema contract identifier)
- `SaveSystem.ACTIVE_SLOT = 0` — Story 1.8 (single-slot vertical slice)

## Currently-Tunable Balance Numbers

These ARE balance. Editing `balance.tres` reloads them on next launch (AC3); save state is unaffected.

| Field | Owner Story / FR | Current value | Status |
|---|---|---|---|
| `dc_table` | Epic 5 / 6 (dialogue + investigation) | `{}` | Stub — populated when DC consumers ship |
| `skill_xp_per_use` | FR82 / Story 1.2 | `{critical: 2, success: 1, fail: 1}` | Live |
| `skill_xp_thresholds` | FR82 / Story 1.2 | `[10, 25, 50, 90, 145, 215, 305, 415, 545, 700]` | Live |
| `awakening_thresholds` | Story 1.5 | `[]` | Stub — Story 1.5 follow-up locks the curve |
| `talent_passive_magnitudes` | Story 1.4 / FR86 | populated for 40 talents | Live; values tunable per talent |
| `talent_cost_overrides` | Story 1.4 | `{}` | Stub — used only when a talent's cost diverges from `TalentDefinition.cost` |
| `slot_minutes` | Epic 2 / FR33 | `{}` | Stub — Story 2.1 fills |
| `subscription_costs` | Epic 2 | `{}` | Stub — Story 2.4 fills |
| `politburo_tick_budget_ms` | Arch §3.10 | `500` | Live; failure threshold per arch §3.10 |
| `crossfade_duration_seconds` | Epic 13 | `4.0` | Live; tunable per music-deterioration spec |
| `save_perf_warn_ms` | NFR9 / Story 1.8 | `3000` | Live; pinned to NFR9 by `test_save_perf_warn_ms_matches_nfr9` |
| `save_key_event_debounce_ms` | Story 1.8 | `500` | Live |
| `save_backup_count` | Story 1.8 | `1` | Live; multi-gen rotation deferred |

## Reviewer / Author Workflow

Before opening a PR that touches `src/`:

1. Run `godot --headless -s tools/balance_validator.gd` from the repo root. The validator
   prints either `STATUS=PASS` or `STATUS=FAIL` as its final line — grep that line for scripted
   gating (Godot 4.3 + Windows does not reliably propagate `quit()` exit codes from tool scripts;
   `OS.set_exit_code` lands in 4.4).
2. If the report shows VIOLATIONS, either:
   - Move the literal into `balance.tres` and read via `Balance.get_data().<field>`, or
   - Add a rule entry to `tools/balance_lint_rules.gd` with an FR or arch reference, or
   - Append `# balance-allow: <reason>` to the literal's line for one-off pragmatic exceptions.
3. Run `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` and verify
   `tests/unit/test_balance_invariants.gd` and `tests/unit/test_balance_lint_rules.gd` pass.
