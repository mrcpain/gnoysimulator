# Three Tracking Systems — AI-Agent PR Review Checklist

**Architecture:** §5.1 (legal-distinctness rules), §6.1 (save schema / WorldState), §7.1 Locked Rule 2 + 12, §7.3 (code-review checklist)
**Automated gate:** `godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_tracking_distinctness.gd`

This document is the binding AI-agent code-review checklist for any PR touching `src/tracking/`. Architecture §7.1 Locked Rule 2 makes this checklist non-negotiable. PRs without a §5.1 Rule citation in their description are blocked.

## PR Description Citation Requirement

Every PR touching `src/tracking/` MUST contain `§5.1 Rule N:` (N ∈ {1, 2, 3, 4}) in the PR description before any reviewer ticks any other item. An un-cited PR is blocked at review time.

## Rule 1 Checklist

**Rule 1: The Player Dossier MUST NOT contain per-NPC memory.**

- [ ] Does any new field on `player_dossier.gd` contain a Gnoym id, a Gnoym name, or a per-NPC quote? If yes, the PR violates Rule 1 and is blocked.
- [ ] Does any new field store the identity of a specific NPC as the *owner* of information (rather than as a *source* of a cross-faction `InterrogationReport`)? If yes, blocked.
- [ ] Are all new Dossier updates routed through the Interrogation Bridge (Rule 3), an EventBus subscriber summary, or an operative report? Ensure no direct NPC-to-Dossier path exists.
- [ ] Does the PR add any field keyed by Gnoym id rather than report id or operation id? If yes, blocked.

## Rule 2 Checklist

**Rule 2: The Politburo Simulation MUST NOT read the player-action graph directly.**

- [ ] Does any new code in `politburo_sim.gd` read `player_dossier.gd`, `reputation_web/`, or the player's action history directly? If yes, blocked.
- [ ] Does any new code in `politburo_sim.gd` call a function on `PlayerDossier` or import `player_dossier.gd`? If yes, blocked.
- [ ] Are all new player inputs to the simulation routed as summarized EventBus events (e.g., `OperativeEliminated`, `EvidencePublished`), not raw action-history reads?
- [ ] Would the simulation still produce outputs if the player took no action this tick (succession from old age, blackmail debt cycle, intra-faction politics)? Verify simulation independence.

## Rule 3 Checklist

**Rule 3: Interrogation Bridge is the ONLY data path from Reputation Web to Player Dossier.**

- [ ] Does any new file import from `src/tracking/reputation_web/` except `interrogation_bridge.gd`? If yes, blocked.
- [ ] Does `player_dossier.gd` import any new file from `reputation_web/` that is NOT `interrogation_bridge.gd`? If yes, blocked.
- [ ] Is `interrogation_bridge.gd` the sole caller writing `InterrogationReport` records to the Dossier from Reputation Web data?
- [ ] Is Reputation Web self-contained? No new code in `reputation_web/` should write directly to the Dossier.

## Rule 4 Checklist

**Rule 4: A standing legal-distinctness README in `src/tracking/README.md`.**

- [ ] If the PR modifies `src/tracking/README.md`, are all modifications additive? The existing Rules block and Naming Clarification section must not be removed or altered.
- [ ] Does the PR description reference `src/tracking/README.md` and cite which §5.1 Rule applies?
- [ ] If the PR adds a new subsystem under `src/tracking/`, does a corresponding contract statement exist in the README?

## Forbidden Imports

The following patterns MUST NOT match in the listed files. Run these greps before approving:

```
# Pattern (a): player_dossier.gd must NOT import anything from reputation_web/ except interrogation_bridge.gd
grep -nE "(preload|load)\s*\(\s*\"res://src/tracking/reputation_web/(?!interrogation_bridge\.gd)" src/tracking/player_dossier.gd
# Expected: no output (zero matches)

# Pattern (b): politburo/*.gd must NOT import player_dossier.gd or anything from reputation_web/
grep -rnE "(preload|load).*(player_dossier|reputation_web)" src/tracking/politburo/ 2>/dev/null
# Expected: no output (zero matches)

# Pattern (c): politburo/*.gd must NOT reference PlayerDossier or ReputationWeb class names
grep -rniE "PlayerDossier|ReputationWeb" src/tracking/politburo/ 2>/dev/null
# Expected: no output (zero matches)
```

## Locked Rules Cross-Check

These rules are quoted verbatim from architecture §7.1. Each applies to every PR touching `src/tracking/`:

**Locked Rule 2:** Three Tracking Systems are code-distinct. §5.1 Rules 1–4 are non-negotiable. Any code in `src/tracking/` PR requires a re-read of `src/tracking/README.md`.

- [ ] Does this PR violate Locked Rule 2? (i.e., do the three tracking systems remain structurally isolated from each other?)

**Locked Rule 12:** Player Evidence Dossier ≠ Faction Dossier. Naming distinction is binding. (§5.4)

- [ ] Does any new identifier, field name, or comment conflate `PlayerDossier` (faction intel file) with `DossierInterface` (player's evidence notes)? If yes, blocked.

## Story Crosswalk

For each Epic 7 story PR, invoke the listed rule checklist items:

| Story | What it ships | Checklist items to invoke |
|---|---|---|
| 7.2 (Player Dossier data model) | Adds threat axes, build classifier, OPSEC fields to `player_dossier.gd` | Rule 1 checklist (full) + Locked Rule 12 + Forbidden Imports (a) |
| 7.3 (Politburo Simulation) | Adds `politburo_sim.gd` with tick logic | Rule 2 checklist (full) + Locked Rule 2 + Forbidden Imports (b) + (c) |
| 7.4 (Politburo Outputs) | Politburo events route via EventBus | Rule 2 checklist (items 1, 3) + Locked Rule 2 + verify no direct Dossier writes |
| 7.5 (Reputation Web) | Adds `reputation_web/` module: `GnoymMemory`, `Gossip`, `ReputationState`, `ReputationScheduler`, `InterrogationBridge` stub | **§5.1 Rule 3:** Rule 3 checklist (items 3, 4) + Forbidden Imports (a) — verify self-containment. Tests: `test_reputation_web_is_self_contained`, `test_gossip_sim_has_no_eventbus_or_autoload_read`, `test_reputation_web_classes_not_in_autoloads`. Save round-trip asserted by `test_gnoym_memory.gd`. NFR8 perf gate: `test_reputation_web_perf.gd`. |
| 7.6 (Interrogation Bridge) ✅ | Fills `interrogation_bridge.gd` — single Reputation Web → Faction Dossier data path via `EventBus.gnoym_interrogated` | Rule 3 checklist (full) + Locked Rule 2 + Forbidden Imports (a) — verified: bridge is the ONLY write path; `test_reputation_web_is_self_contained` + `test_interrogation_bridge_routes_via_eventbus` enforce the contract |
| 7.7 (Faction Standing Ladder) ✅ | Adds `FactionStanding` (producer for `EventBus.faction_standing_changed`) + `FactionLadder` constant; reconciles `politburo_sim.gd` to 6-rung `FactionLadder.RUNGS` (fixes UNKNOWN/FLAGGED no-op bug) | **§5.1 Rule 1:** `FactionStanding.scores` keyed by faction_id only — Rule 1 checklist (items 1, 2) satisfied; `test_faction_standing_is_faction_keyed_only` enforces. **§5.1 Rule 2:** `politburo_sim.gd` references only `FactionLadder.RUNGS` (pure constant); `FactionStanding` runtime instance never imported — Rule 2 checklist (items 1, 2) + Forbidden Imports (b)(c) green; `test_politburo_sim_uses_faction_ladder_constant_not_instance` enforces. **Locked Rule 12** satisfied: subsystem named `FactionStanding` / `FactionLadder`, never `*Dossier`. |
| 7.8 (War Room UI) | Reads Dossier as faction file; renders Network Graph | Rule 1 checklist (items 1, 4) + Rule 4 checklist + Locked Rule 12 |

## Automated Gate

Run the following command and verify all asserts pass before approving any PR touching `src/tracking/`:

```
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_tracking_distinctness.gd
```

The test suite (`tests/unit/test_tracking_distinctness.gd`) is the automated gate that CI runs on every commit. A PR cannot be merged if this gate fails.
