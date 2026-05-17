# Story 6.1: Dialogue VM — All 9 Node Types

**Status:** done
**Epic:** 6 — Dialogue System
**Story ID:** 6.1
**Story Key:** 6-1-dialogue-vm-nodes

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

---

## User Story

As a writer authoring dialogue and a developer running it,
I want the custom GDScript Dialogue VM with all 9 node types (`Line` / `Choice` / `SkillCheck` / `InternalVoice` / `ItemDrop` / `Branch` / `SystemEffect` / `Commit` / `End`) walking a `.dialog.tres` graph from a single code path,
So that every conversation — including Composure-HP boss encounters (Story 6.6), Inner-Voice flourish surfacing (Story 6.3), item-drop unlocks (Story 6.4), Conversation Log append (Story 6.5), and the two-pane Dialogue Interface (Story 6.9) — uses the same VM with **no special-case code path** (architecture locked rule 6, FR194; arch §3.8 + §5.5; epics.md §"Story 6.1" lines 1942–1960).

---

## Scope Boundary (READ FIRST)

This story ships the **engine substrate of Epic 6**: the data model for a dialogue graph, the runtime that walks it, the 9 node-type resolvers, the EncounterContext subscriber slot (Composure-HP gameplay lands in 6.6 — 6.1 only declares the seam), and the cross-cluster signal grammar that downstream Epic 6 stories will subscribe to. **It ships ZERO player-facing UI.** Story 6.9 builds the Dialogue Interface scene on top of this; Story 6.3 owns voice typography; Story 6.4 owns item-drop drag UI; Story 6.5 owns Conversation Log persistence; Story 6.6 owns Composure HP; Story 6.8 owns the YAML→tres importer; Story 6.10 owns tier enforcement.

6.1 builds **directly on top of**:

- **Story 1.0** Project Scaffolding (`DialogueRunner` autoload exists as a stub — `src/core/autoloads/dialogue_runner.gd` lines 1–14 — and is wired in `project.godot` line 30; 6.1 fleshes it out without changing autoload order).
- **Story 1.3** Skill Check Engine (`RPGCore.skill_check(skill_id, dc, modifier, stream_name) -> Dictionary` from `src/core/autoloads/rpg_core.gd` line 412 — the SkillCheck node is a thin wrapper that calls it; the existing `RPGCore.preview_check(skill_id, dc)` at line 442 is the FR55 visible-DC surface the SkillCheck node uses to populate `Choice.preview_data` without leaking outcome consequence).
- **Story 1.5** Awakening Track (`RPGCore.awakening_level` is read by `InternalVoice` and `SystemEffect` nodes via `Balance` thresholds; the VM is a SUBSCRIBER, never a writer — arch locked rule 4 preserved).
- **Story 1.7** Derived Stats (Fatigue / Cope from `RPGCore.fatigue_accumulator` + `RPGCore.cope_overwork_debit` read-only via `RPGCore.get_derived_stat(...)` — `SystemEffect` nodes that emit Fatigue/Cope deltas route through `EventBus.fatigue_input` / `cope_overwork_input` per locked rule 11 single-writer-input discipline).
- **Story 1.8/1.9** Save System (the VM cursor is **per-session ephemeral** per arch §3.9 — NEVER persisted. The save-format diff in this story is **zero**. Tests assert this).
- **Story 1.10** Balance (`Balance.dialogue` sub-dict is NEW in this story — perf budgets + cap-per-dialog limits + cinematic-flag thresholds; AC2 locks the schema).
- **Story 3.1** EncounterDirector (Composure-HP encounters reuse `EncounterDirector.enter_encounter(...)` per arch §3.5; the VM exposes `attach_encounter_context(ctx)` so Story 6.6 can subscribe a `ComposureEncounterContext` without touching VM internals — locked rule 6 enforced architecturally).
- **Story 5.1** Evidence System (`ItemDrop` node reads `RPGCore.evidence_inventory` by `instance_id` to validate a drop; the VM does NOT mutate evidence — `seize / restore` paths remain Story 5.1's contract).
- **Story 5.5** Thought Cabinet (`EventBus.dialogue_line_unlocked(line_id, source)` exists at `src/core/autoloads/event_bus.gd` line 64 — the VM is the FIRST subscriber; thoughts that unlock dialogue lines flip `_unlocked_line_ids` set inside the active runtime state per AC5).

**IN scope:**

- **New folder content for `src/dialogue/`** (currently empty except `nodes/.gitkeep`):
  - `src/dialogue/dialogue_node.gd` (class_name `DialogueNode extends Resource`) — abstract base with `node_id: String`, `node_type: String`, `next_id: String`, common helpers. Sealed enum-string of node types in `ALL_NODE_TYPES` constant.
  - `src/dialogue/nodes/line_node.gd` (class_name `DialogueLineNode extends DialogueNode`) — `speaker_id`, `body_key` (tr() key), `tags: PackedStringArray` (`quotable`, `faction_relevant`, `incriminating` — read by Story 6.5 commit hook), `voice_profile_id: String = ""` (empty = no internal-voice tint — UX-DR32 lives in Story 6.3; this is just the data slot).
  - `src/dialogue/nodes/choice_node.gd` (class_name `DialogueChoiceNode extends DialogueNode`) — `choices: Array[Dictionary]` (each entry: `{choice_id, body_key, next_id, gate, gate_args, item_accepted}`). Gate enum-string: `"none"`, `"skill_check"`, `"awakening_min"`, `"talent_unlocked"`, `"item_required"`, `"line_unlocked"`. AC4 locks shape.
  - `src/dialogue/nodes/skill_check_node.gd` (class_name `DialogueSkillCheckNode extends DialogueNode`) — `skill_id: String`, `dc: int`, `modifier: int = 0`, `stream_name: String = "dialogue"`, `outcome_next_ids: Dictionary` (keys: `critical / success / fail`; values: next_id strings). On enter, calls `RPGCore.skill_check(...)` exactly once, routes per outcome.
  - `src/dialogue/nodes/internal_voice_node.gd` (class_name `DialogueInternalVoiceNode extends DialogueNode`) — `voice_profile_id: String`, `body_key: String`, `base_frequency: float` (0.0–1.0; effective freq = base × `Balance.dialogue.voice_scaling(awakening, fatigue, cope)` — 6.1 ships a stub scaling fn; Story 6.3 replaces with real curve), `chorus_tier: String` (`quiet`/`interjecting`/`chorus`/`full_chorus` — read but not enforced in 6.1, purely a passthrough payload for 6.3).
  - `src/dialogue/nodes/item_drop_node.gd` (class_name `DialogueItemDropNode extends DialogueNode`) — `accepted_items: Array[Dictionary]` (each: `{evidence_definition_id, next_id, consume_on_accept: bool, reaction_line_id: String}`). VM matches against `RPGCore.evidence_inventory` instance lookups; the actual drag-drop UI is Story 6.4 — 6.1 exposes `DialogueRunner.accept_item_drop(instance_id) -> bool`.
  - `src/dialogue/nodes/branch_node.gd` (class_name `DialogueBranchNode extends DialogueNode`) — `conditions: Array[Dictionary]` (each: `{condition_type, args, next_id}`). Condition types: `"awakening_min"`, `"awakening_max"`, `"flag_set"`, `"flag_not_set"`, `"line_unlocked"`, `"disposition_threshold"`, `"derived_stat_threshold"`, `"always"`. Evaluated top-to-bottom; first match wins; `"always"` is the fallthrough. **No arbitrary GDScript expressions** (security + determinism — locked).
  - `src/dialogue/nodes/system_effect_node.gd` (class_name `DialogueSystemEffectNode extends DialogueNode`) — `effects: Array[Dictionary]` (each: `{effect_type, args}`). Effect types: `"set_flag"`, `"clear_flag"`, `"fatigue_delta"`, `"cope_overwork_delta"`, `"heat_input"`, `"awakening_input"` (write-path via RPGCore.advance_awakening), `"disposition_input"`, `"composure_damage"` (no-op in 6.1 — Story 6.6 wires it via EncounterContext), `"unlock_line"` (writes to `_unlocked_line_ids`), `"queue_signal"` (free-form `EventBus.<signal>` re-emission with whitelisted signal names — see AC7 for the whitelist).
  - `src/dialogue/nodes/commit_node.gd` (class_name `DialogueCommitNode extends DialogueNode`) — `committed_line_id: String` (the player's chosen line referenced by id; `""` allowed for NPC-only commits), `npc_line_id: String`, `commit_tags: PackedStringArray` (overrides/augments tags from the most recent Line node; Story 6.5 consumes). VM emits `EventBus.dialogue_line_committed(...)` here — sole writer.
  - `src/dialogue/nodes/end_node.gd` (class_name `DialogueEndNode extends DialogueNode`) — `end_reason: String` (`"normal"`, `"interrupted"`, `"composure_failure"`, `"player_exit"`). VM emits `EventBus.dialogue_ended(...)` and tears down the active runtime state.
- **`src/dialogue/dialogue_graph.gd`** (class_name `DialogueGraph extends Resource`) — the on-disk `.dialog.tres` shape:
  - `@export var graph_id: String = ""` — unique id (snake_case). Validator rejects duplicates / blanks.
  - `@export var tier: String = ""` — one of `Balance.dialogue.tier_ids` (Story 6.10 enforces word budgets; 6.1 just persists the tag — empty string allowed for VS fixtures).
  - `@export var start_node_id: String = ""` — entry point.
  - `@export var nodes: Array[DialogueNode] = []` — every node in the graph; id-uniqueness enforced in `DialogueGraph.validate()`.
  - `@export var participants: PackedStringArray = []` — NPC ids referenced by this graph (read by Story 5.6 Schrödinger NPC dispatch; 6.1 just persists).
  - Static helper `validate() -> bool` and `find_node(node_id) -> DialogueNode`. Validator catches: missing start node, dangling next_ids, duplicate node_ids, unknown node_types, broken Choice gate references (e.g., `skill_check` gate args missing `skill_id`).
- **`src/dialogue/dialogue_runtime_state.gd`** (class_name `DialogueRuntimeState extends RefCounted`) — per-session ephemeral cursor + flags:
  - `graph: DialogueGraph` (ref).
  - `current_node_id: String` (the cursor).
  - `flags: Dictionary` (transient `{flag_id: bool}` — cleared on dialogue end).
  - `voice_emit_counts: Dictionary` (`{voice_profile_id: int}` — cap-per-dialog enforcement; reset on dialogue end).
  - `unlocked_line_ids: Dictionary` (`{line_id: true}` — populated from `EventBus.dialogue_line_unlocked` events received WHILE this dialogue is active AND from `system_effect.unlock_line`).
  - `presented_choices: Array[Dictionary]` (snapshot of last presented choice menu — readable by Story 6.9 UI scene without re-entering the VM).
  - `encounter_context: RefCounted = null` (the attached `ComposureEncounterContext` — null for normal dialogue; Story 6.6 sets it via `DialogueRunner.attach_encounter_context(...)`).
  - `committed_line_count: int = 0` (telemetry only).
  - `last_skill_check: Dictionary = {}` (the most recent `RPGCore.skill_check` return Dictionary, for tests + 6.6 EncounterContext readback).
  - **NOT saved.** Per-session ephemeral per arch §3.9.
- **`src/dialogue/dialogue_vm.gd`** (class_name `DialogueVM extends RefCounted`) — the core graph-walker. Public API:
  - `start(graph: DialogueGraph) -> bool` — initializes `_state`, sets cursor to `graph.start_node_id`, emits `EventBus.dialogue_started(graph.graph_id)`, advances synchronously through nodes that don't yield (Line / Branch / SystemEffect chains) until the first interactive node (Choice / SkillCheck / ItemDrop) or End.
  - `step() -> Dictionary` — advances by one node; returns a Dictionary describing the new cursor state (`{node_type, node_id, payload}`). Idempotent on End.
  - `submit_choice(choice_id: String) -> bool` — resolves a Choice's gate (or fires SkillCheck for skill-gated choices), routes to `next_id`.
  - `accept_item_drop(instance_id: String) -> bool` — matches against current ItemDrop node's `accepted_items`; routes or rejects.
  - `attach_encounter_context(ctx: RefCounted) -> void` — Story 6.6 hook; 6.1 stores the ref but otherwise inert.
  - `interrupt(reason: String) -> void` — forces an early End with `end_reason` set; Story 6.6 calls this on `composure_failure`; Story 6.9 calls it on player-exit.
  - `is_active() -> bool` / `current_node_id() -> String` / `current_graph_id() -> String` / `runtime_state() -> DialogueRuntimeState` — read accessors.
  - **No `await` chains that block the main thread >16ms** (arch §7.2 forbidden patterns line 802). Synchronous node-resolution only; UI animation is the UI scene's problem.
- **`src/dialogue/encounter_context.gd`** (class_name `DialogueEncounterContext extends RefCounted`) — the BASE class Story 6.6 will extend. Declares the interface:
  - `func on_dialogue_started(state: DialogueRuntimeState) -> void` (default no-op).
  - `func on_node_entered(state: DialogueRuntimeState, node: DialogueNode) -> void` (default no-op).
  - `func on_system_effect(state: DialogueRuntimeState, effect: Dictionary) -> bool` — return true to consume the effect (e.g., `composure_damage`); false to let VM apply normal handling.
  - `func on_dialogue_ended(state: DialogueRuntimeState, reason: String) -> void` (default no-op).
  - `func should_interrupt(state: DialogueRuntimeState) -> Variant` — return a `{end_reason}` Dictionary to force interrupt, or `null` for normal flow. Polled after every node resolution.
  - **6.1 ships the BASE class only.** Story 6.6 ships `ComposureEncounterContext extends DialogueEncounterContext`. AC9 documents the contract.
- **`src/core/autoloads/dialogue_runner.gd`** rewrite — replaces the 14-line stub. Becomes a thin facade that owns ONE `DialogueVM` instance + the public API surface for callers:
  - `start_dialogue(graph_id: String, encounter_context: RefCounted = null) -> bool` — loads `DialogueCatalog.get_graph(graph_id)`, calls `_vm.start(graph)`. Attaches encounter_context if non-null. Logs via `Logger.info("dialogue", ...)`.
  - `submit_choice(choice_id: String) -> bool` — pass-through to `_vm.submit_choice`.
  - `accept_item_drop(instance_id: String) -> bool` — pass-through.
  - `interrupt(reason: String) -> void` — pass-through.
  - `attach_encounter_context(ctx: RefCounted) -> void` — pass-through.
  - `is_active() -> bool` / `current_node_id() -> String` / `current_graph_id() -> String` — pass-through.
  - `_on_dialogue_line_unlocked(line_id: String, source: String)` — `EventBus` subscriber wired in `_ready()`. Forwards to `_vm._state.unlocked_line_ids[line_id] = true` if `_vm.is_active()`; otherwise stashes in an `_offline_unlocks: Dictionary` for the next `start_dialogue` to seed.
  - **Forbidden:** caller mutation of the underlying `DialogueVM` instance. Tests use the runner's public API; only `tests/` may peek `_vm` for inspection via `runtime_state()`.
- **`src/dialogue/dialogue_catalog.gd`** (class_name `DialogueCatalog extends RefCounted`) — pure-static catalog mirroring `RecipeCatalog` / `EvidenceCatalog` shape line-for-line:
  - `_catalog: Dictionary` (`{graph_id: DialogueGraph}`), `_ordered_ids: Array[String]`, `_cache_built: bool`, `_build_cache()`, `get_graph(graph_id) -> DialogueGraph`, `has_graph(graph_id) -> bool`, `all_graphs() -> Array[DialogueGraph]`, `ordered_graph_ids() -> Array[String]`, `validate() -> bool` (calls `DialogueGraph.validate()` on every entry, dedupe-checks graph_ids).
  - Authored data source: `src/dialogue/data/dialogue_index.tres` (a `DialogueIndexResource` with `@export var graphs: Array[DialogueGraph] = []`). 6.1 ships **one VS fixture graph** `dialogue_vm_test_fixture` exercising all 9 node types (AC10).
- **`src/dialogue/dialogue_index_resource.gd`** (class_name `DialogueIndexResource extends Resource`) — `@export var graphs: Array[DialogueGraph] = []`. Mirrors `EvidenceResource` / `RecipeResource`.
- **`src/dialogue/data/dialogue_index.tres`** — DialogueIndexResource instance carrying the VS fixture graph (AC10 locks the shape).
- **`src/dialogue/data/fixtures/`** — folder hosting the per-graph `.dialog.tres` files. AC10 names the fixture: `dialogue_vm_test_fixture.tres`.
- **`src/core/balance/balance_resource.gd` extension** — NEW `@export var dialogue: Dictionary = {...}` block. AC2 locks the schema; defaults:
  - `node_resolve_budget_ms: int = 50` (NFR8 / arch §6.3 — asserted in tests).
  - `vm_frame_budget_ms: int = 1` (arch §6.3 — informational; not asserted per-frame in 6.1 since the VM is event-driven, not per-frame).
  - `voice_cap_per_dialogue: int = 6` (UX-DR86; informational for 6.3 — 6.1 records emit counts but does not enforce the cap; 6.3 owns enforcement).
  - `voice_first_speak_flourish_ms: int = 400` (UX-DR86; passthrough payload).
  - `tier_ids: Array[String] = ["boss", "recruit_personal", "awakening_beat", "reputation_side", "routine"]` (FR66; Story 6.10 enforces word budgets).
  - `tier_word_budgets: Dictionary = {}` (Story 6.10 populates; 6.1 leaves empty default).
  - `voice_scaling_default: Dictionary = {"base_floor": 0.1, "awakening_curve": 0.08, "fatigue_curve": 0.05, "cope_curve": 0.03}` (placeholder linear; Story 6.3 replaces with real curve. 6.1's `DialogueVM._compute_voice_frequency(...)` reads these.)
- **`src/core/balance/balance.tres`** — write the new dialogue block matching the export defaults (matches the Story 1.10 magic-number discipline).
- **`src/core/autoloads/event_bus.gd` extension** — NEW signals (the dialogue grammar):
  - `signal dialogue_started(graph_id: String)` — sole writer: `DialogueVM.start`. Subscribers (future): Story 6.9 UI scene (mount + show), Story 6.5 (no-op — Conversation Log subscribes to `dialogue_line_committed`), telemetry. Always emits on a successful start.
  - `signal dialogue_ended(graph_id: String, reason: String)` — sole writer: `DialogueVM._teardown` (called by End node, `interrupt`, or `EncounterContext.should_interrupt`). Subscribers (future): Story 6.9 (tear down UI), Story 6.6 (Composure-HP teardown — 6.6 also drives the interrupt path), Story 6.5 (no-op), telemetry. Always emits on dialogue end.
  - `signal dialogue_node_entered(graph_id: String, node_id: String, node_type: String)` — sole writer: `DialogueVM._enter_node`. Subscribers (future): telemetry; **NOT** a UI hook (UI subscribes to typed signals below). Observability-only.
  - `signal dialogue_line_presented(payload: DialogueLinePresentedEvent)` — sole writer: `DialogueVM._resolve_line_node`. Typed payload (AC8 schema). Subscribers (future): Story 6.9 (renders portrait + body text), Story 6.3 (voice typography lookup for `voice_profile_id`), Story 6.5 (NO — 6.5 subscribes to `dialogue_line_committed`, NOT presented). Fires every time a Line node enters.
  - `signal dialogue_choice_presented(payload: DialogueChoicePresentedEvent)` — sole writer: `DialogueVM._resolve_choice_node`. Typed payload carrying the prepared choice list with gates already evaluated for display (skill DC + skill_name_key from `RPGCore.preview_check`, never the outcome). Subscribers (future): Story 6.9 (renders the choice list), Story 6.2 (visible-DC formatting), telemetry.
  - `signal dialogue_choice_selected(graph_id: String, node_id: String, choice_id: String)` — sole writer: `DialogueVM.submit_choice` (BEFORE routing, AFTER gate evaluation). Subscribers (future): telemetry. Observability-only.
  - `signal dialogue_internal_voice_presented(payload: DialogueInternalVoicePresentedEvent)` — sole writer: `DialogueVM._resolve_internal_voice_node`. Typed payload (voice_profile_id, body_key, computed_frequency, chorus_tier, is_first_speak). Subscribers (future): Story 6.3 (voice typography + flourish + audio cue), Story 6.9 (interleave into right-pane chorus area), telemetry. Fires every time an InternalVoice node enters AND its frequency-roll passes (frequency<1.0 means it MAY skip — VM rolls and only emits on pass).
  - `signal dialogue_item_drop_armed(payload: DialogueItemDropArmedEvent)` — sole writer: `DialogueVM._resolve_item_drop_node`. Typed payload listing `accepted_evidence_definition_ids` (the UI may highlight matching inventory items). Subscribers (future): Story 6.4 (drag-drop UI arm), telemetry. Fires on every ItemDrop node entry.
  - `signal dialogue_item_drop_resolved(graph_id: String, node_id: String, instance_id: String, accepted: bool)` — sole writer: `DialogueVM.accept_item_drop` (always emits — accepted or rejected). Subscribers (future): Story 6.4 (UI feedback), telemetry.
  - `signal dialogue_line_committed(payload: DialogueLineCommittedEvent)` — sole writer: `DialogueVM._resolve_commit_node`. Typed payload (graph_id, node_id, committed_line_id, npc_line_id, speaker_id, tags). Subscribers (future): **Story 6.5 (the Conversation Log append path — this is the contract handoff)**, Story 6.7 (weaponization annotations consume the same log entries — subscribes via 6.5), telemetry. Always emits on Commit node entry.
  - `signal dialogue_system_effect_applied(payload: DialogueSystemEffectAppliedEvent)` — sole writer: `DialogueVM._resolve_system_effect_node` (AFTER each effect in the array is applied / dispatched). Typed payload `(graph_id, node_id, effect_type, effect_args, applied: bool)`. Subscribers (future): telemetry; observability anchor. `applied=false` when an EncounterContext consumed the effect (Story 6.6 path).
- **`src/core/autoloads/payloads/`** — new typed payloads (FIVE files; mirrors the Story 2.4–2.8 payload pattern):
  - `dialogue_line_presented_event.gd` (class_name `DialogueLinePresentedEvent extends Resource`). AC8 locks the schema.
  - `dialogue_choice_presented_event.gd` (class_name `DialogueChoicePresentedEvent extends Resource`).
  - `dialogue_internal_voice_presented_event.gd` (class_name `DialogueInternalVoicePresentedEvent extends Resource`).
  - `dialogue_item_drop_armed_event.gd` (class_name `DialogueItemDropArmedEvent extends Resource`).
  - `dialogue_line_committed_event.gd` (class_name `DialogueLineCommittedEvent extends Resource`).
  - `dialogue_system_effect_applied_event.gd` (class_name `DialogueSystemEffectAppliedEvent extends Resource`).
- **`src/scenes/boot_check.gd`** — add `DialogueCatalog.validate()` to the validation list at line 17 area (one new line after `EvidenceCatalog.validate()`). No new token-presence check (no UI tokens introduced — those land in Story 6.9 via UX-DR28/29/32/33/56/136/137 tokens).
- **`.godot/global_script_class_cache.cfg`** — pre-emptive class entries for all 14 new `class_name` declarations: `DialogueNode`, `DialogueLineNode`, `DialogueChoiceNode`, `DialogueSkillCheckNode`, `DialogueInternalVoiceNode`, `DialogueItemDropNode`, `DialogueBranchNode`, `DialogueSystemEffectNode`, `DialogueCommitNode`, `DialogueEndNode`, `DialogueGraph`, `DialogueRuntimeState`, `DialogueVM`, `DialogueEncounterContext`, `DialogueCatalog`, `DialogueIndexResource`, `DialogueLinePresentedEvent`, `DialogueChoicePresentedEvent`, `DialogueInternalVoicePresentedEvent`, `DialogueItemDropArmedEvent`, `DialogueLineCommittedEvent`, `DialogueSystemEffectAppliedEvent`. Mirrors the Story 5.1 / 5.5 headless-parser pre-emption pattern.
- **Tests:**
  - Unit per node Resource: `tests/unit/test_dialogue_line_node.gd`, `test_dialogue_choice_node.gd`, `test_dialogue_skill_check_node.gd`, `test_dialogue_internal_voice_node.gd`, `test_dialogue_item_drop_node.gd`, `test_dialogue_branch_node.gd`, `test_dialogue_system_effect_node.gd`, `test_dialogue_commit_node.gd`, `test_dialogue_end_node.gd` (9 files; one per node type; ~3–6 tests each — schema validation, equality, optional-field defaults).
  - `tests/unit/test_dialogue_graph.gd` — `validate()` happy path + each failure mode (missing start, dangling next_id, duplicate node_id, unknown node_type, broken Choice gate args). ~10 tests.
  - `tests/unit/test_dialogue_catalog.gd` — mirrors `test_evidence_catalog.gd` line-for-line in structure. ~6 tests.
  - `tests/unit/test_dialogue_runtime_state.gd` — fresh-state defaults, voice-emit-count tracking, unlocked-line-id set semantics, flag set/clear. ~6 tests.
  - `tests/unit/test_dialogue_vm.gd` — per-node-type resolution behavior with mock graphs (one test per node type's resolver path), `start` initialization, `interrupt` path, `attach_encounter_context` ref tracking, the End-node teardown sequence. ~20 tests.
  - `tests/unit/test_dialogue_runner_facade.gd` — autoload-level passthrough verification; offline-unlock stashing; `_on_dialogue_line_unlocked` subscriber wiring. ~8 tests.
  - `tests/unit/test_dialogue_encounter_context.gd` — base-class default no-op behavior; `should_interrupt` polling protocol; effect consumption protocol. ~5 tests.
  - `tests/unit/test_dialogue_perf.gd` — synthesizes a 200-node graph and asserts `node_resolve_ms_max < Balance.dialogue.node_resolve_budget_ms` (50). NFR8 lock.
  - `tests/unit/test_no_new_eventbus_signals.gd` extension — assert exactly **11 new signals** added in 6.1 (the dialogue grammar). Baseline jumps to **71 + 11 = 82** (Story 5.7 baseline is **71** per its checklist line `parser-level "no new EventBus signals in 5.7"`).
  - `tests/unit/test_balance_invariants.gd` extension — 6 new tests asserting (a) `dialogue` sub-dict shape, (b) `node_resolve_budget_ms > 0`, (c) `voice_cap_per_dialogue > 0`, (d) `tier_ids` is non-empty Array[String], (e) `voice_scaling_default` has all four documented keys, (f) `tier_word_budgets` is a Dictionary (may be empty in 6.1).
  - `tests/unit/test_boot_check.gd` extension — 2 new tests: `DialogueCatalog.validate()` called; fixture graph parses without errors.
  - `tests/integration/test_dialogue_vm_full_walk.gd` — drives the VS fixture graph through start → choice → skill-check → branch → internal-voice → item-drop → system-effect → commit → end, asserting every signal fires with correct payload shape AND that the cursor lands on `EndNode` with `end_reason="normal"`. NO scene loaded — VM-only via DialogueRunner facade.
  - `tests/integration/test_dialogue_vm_encounter_context_arc.gd` — attaches a stub `DialogueEncounterContext` subclass that captures every callback, then walks the fixture graph. Asserts the four lifecycle callbacks fire in order and the `should_interrupt` polled value is honored when set.
  - `tests/integration/test_dialogue_no_save_persistence.gd` — starts a dialogue, mid-walk triggers a save via `SaveSystem.commit("test")`, asserts the resulting `SaveGameV1` instance has NO `dialogue_*` fields. Parser-level grep on `save_game_v1.gd` diff for new `@export` finds zero matches. **FR194 + arch §3.9 lock — dialogue is ephemeral.**
  - `tests/integration/test_dialogue_runner_offline_unlocks.gd` — fires `EventBus.dialogue_line_unlocked` while VM is inactive, asserts stash; starts a dialogue and asserts the stash flushes into `runtime_state().unlocked_line_ids`.
- **NO** new save-format fields. **NO** new ThemeTokens keys (UI tokens land in Story 6.9). **NO** new input actions (`dialogue_choice_1..9` already exist from Story 1.11 — see `project.godot` lines 192–235; 6.1 does NOT consume them — Story 6.9 does).

**OUT of scope — explicitly deferred. Do NOT implement:**

- **Conversation Log persistence.** Story 6.5 owns the append-only ConversationLog autoload + per-NPC indices + gossip-propagation perf gate. 6.1 emits `dialogue_line_committed` and stops; 6.5 subscribes and writes the log. If you find yourself creating `src/dialogue/conversation_log.gd` or adding a save field for conversation log entries, **STOP** — that's 6.5.
- **Inner Voice typography, frequency scaling, first-speak flourish.** Story 6.3 owns 24 `VoiceProfile` resources + per-voice fonts/colors + flourish animation + Awakening/Fatigue/Cope frequency math. 6.1 ships a *placeholder* linear scaling fn in `Balance.dialogue.voice_scaling_default` and a `_compute_voice_frequency` helper that reads it — but the voice cap-per-dialog ENFORCEMENT and typography are 6.3. The 6.1 InternalVoice resolver just emits `dialogue_internal_voice_presented` with the computed frequency; rendering is 6.9 + 6.3.
- **Item-drop drag-drop UI.** Story 6.4 owns the drag-from-inventory-onto-NPC-portrait UX. 6.1 exposes `DialogueRunner.accept_item_drop(instance_id)` and emits `dialogue_item_drop_armed` / `dialogue_item_drop_resolved`; the UI binding is 6.4. If you find yourself drawing a drop zone, **STOP** — that's 6.4.
- **Composure HP gameplay.** Story 6.6 ships `ComposureEncounterContext extends DialogueEncounterContext` + Composure HP stat + multi-stage failure repeat + blown-cover + Heat spike per `Balance.dialogue.boss_failure_consequences`. 6.1 ships ONLY the abstract `DialogueEncounterContext` base class + the `attach_encounter_context` seam + the `system_effect.composure_damage` effect-type passthrough (no-op when no context attached; consumed by 6.6's context when attached). Do NOT implement Composure HP math, stage tracking, or failure consequences.
- **Conversation Log weaponization at high Awakening.** Story 6.7 owns the retroactive annotations + red-bg + tone shift. 6.1 ships zero annotation logic.
- **YAML → tres importer.** Story 6.8 owns `tools/dialogue_yaml_to_tres.gd`. 6.1 hand-authors the VS fixture as `.tres` directly (arch §3.8 explicitly allows this pre-EA).
- **Dialogue Interface scene** (two-pane portrait + choice list + chorus). Story 6.9 owns `src/dialogue/dialogue_interface.tscn` + the UX-DR56/UX-DR28/UX-DR29/UX-DR32/UX-DR33/UX-DR136/UX-DR137 component grammar + portrait micro-animations + choice hover/select. 6.1 ships ZERO scenes. Tests drive the VM via the `DialogueRunner` facade directly.
- **Dialogue Tiering word-budget lint.** Story 6.10 owns `Balance.dialogue.tier_word_budgets` enforcement + the writing-tooling tier-tag validator. 6.1 just persists the `tier` field on `DialogueGraph` (empty string allowed).
- **Specific boss / NPC dialogue content.** Trusted Anchor + Debt Dealer dialogue graphs are Epic 11. Schrödinger's Dave first-conversation graph is Epic 12. 6.1 ships ONE test fixture exercising every node type — that is the only `.dialog.tres` content this story produces.
- **Schrödinger NPC `schrodinger_resolved` emission.** Architecture §5.6 says `DialogueRunner` emits `schrodinger_resolved(npc_id, role)` on the qualifying choice. The signal is already declared (`event_bus.gd` line 254). **6.1 does NOT emit it** — the emit logic lives in Story 12.4 (Schrödinger Dave's first-conversation lock). 6.1's `submit_choice` does check `_state.encounter_context.on_node_entered` only; Schrödinger's qualifying-choice dispatch is a SEPARATE concern owned by 12.4.
- **`SystemEffect.composure_damage` real behavior.** 6.1 emits `dialogue_system_effect_applied` with `applied=false` for `composure_damage` when no context attached, and with `applied=ctx.on_system_effect(...)` return value when attached. Story 6.6's `ComposureEncounterContext.on_system_effect` is where the actual HP arithmetic lives. 6.1 ships zero Composure HP state.
- **Arbitrary GDScript expressions in Branch conditions.** The Branch node uses a CLOSED ENUM of condition types (AC4 lists). Adding a `"expression"` condition type would open determinism + security holes. If a designer needs a condition outside the enum, they author a `SystemEffect.set_flag` upstream and a `flag_set` Branch downstream. Locked.
- **Save persistence of `_offline_unlocks` stash.** The stash is per-session ephemeral. If a player saves while no dialogue is active and stashed unlocks haven't been consumed, the stash is dropped on next load. The reason: `EventBus.dialogue_line_unlocked` is emitted by Thought Cabinet completions (Story 5.5) and any future Epic 6 system; those are themselves persisted through their own save paths (thought completion state in 5.5; whatever future paths). On load, the Thought-completion subscribers re-establish, but the unlock signal does not re-fire — instead, the runner's `is_active()` guard means stashing only happens during active-game runtime. A future story (6.5 or 6.9) may revisit this; 6.1 keeps it ephemeral.
- **Telemetry / debug overlay integration.** No F12 overlay panel for current dialogue state. The Logger.info lines per dialogue start/end/commit + the observability signals are the complete telemetry surface.
- **Localization-file authoring.** All `body_key` strings in the VS fixture render as the key strings (Godot's `tr()` no-table fallback). Story 14.4 (tr-lint) audits.
- **Performance assertion on `dialogue_internal_voice_presented` payload allocation.** The 50ms node-resolve budget is the only enforced perf gate in 6.1. Per-signal payload allocation profiling is post-VS.
- **The `voice_cap_per_dialog` ENFORCEMENT** (skipping internal-voice emits once cap reached). Story 6.3 owns enforcement; 6.1's VM emits unconditionally (subject to the frequency roll) AND increments `voice_emit_counts` — Story 6.3 reads the counts and switches to skip-mode when cap exceeded.

If you find yourself creating a Conversation Log autoload, writing voice typography overrides, drawing a drag-drop zone, implementing Composure HP math, opening a Branch-condition GDScript expression, persisting dialogue state to save, adding a `schrodinger_resolved` emit, or building a two-pane UI scene — **stop and re-read this section.**

---

## Acceptance Criteria

**AC1 — Dialogue VM walks the test fixture graph exercising all 9 node types in one path.**

**Given** the `.dialog.tres` resource `src/dialogue/data/fixtures/dialogue_vm_test_fixture.tres` (a `DialogueGraph`)
**When** `DialogueRunner.start_dialogue("dialogue_vm_test_fixture")` is called
**Then** the VM walks every node type exactly once (Line → Branch → InternalVoice → Choice → SkillCheck → ItemDrop → SystemEffect → Commit → End) in that order
**And** the corresponding signal fires for each interactive entry (`dialogue_started`, `dialogue_line_presented`, `dialogue_internal_voice_presented` (frequency-permitting; fixture sets `base_frequency=1.0` for determinism), `dialogue_choice_presented`, `dialogue_choice_selected`, `dialogue_item_drop_armed`, `dialogue_item_drop_resolved`, `dialogue_system_effect_applied`, `dialogue_line_committed`, `dialogue_ended`)
**And** `dialogue_ended` carries `reason="normal"`.

**AC2 — `Balance.dialogue` sub-dict LOCKED schema + defaults.**

Add a NEW top-level `dialogue: Dictionary` entry on `BalanceResource` (alongside `cope_fatigue`, `subscription_cancellation`, etc.):

```gdscript
## Story 6.1 — Dialogue VM tunables.
##
##   node_resolve_budget_ms: int — Hard cap on a single node resolution time
##     (arch §6.3 / NFR8). DialogueVM perf test asserts max <= this value.
##     Default 50.
##   vm_frame_budget_ms: int — Soft per-frame budget for the VM (arch §6.3).
##     Informational only in 6.1; not asserted per-frame (VM is event-driven).
##     Default 1.
##   voice_cap_per_dialogue: int — Max InternalVoice emissions per dialogue
##     run (UX-DR86). Story 6.3 enforces; 6.1 records but does not enforce.
##     Default 6.
##   voice_first_speak_flourish_ms: int — Duration of the first-speak flourish
##     animation envelope (UX-DR86). Passthrough payload; 6.3 consumes.
##     Default 400.
##   tier_ids: Array[String] — Locked enum of dialogue tier tags (FR66). Story
##     6.10 enforces word-budgets keyed by these strings. 6.1 stores the tag
##     on DialogueGraph.tier; validator accepts empty + ALL_TIER_IDS members.
##   tier_word_budgets: Dictionary — Per-tier word budget (Story 6.10). Empty
##     in 6.1; populated by 6.10.
##   voice_scaling_default: Dictionary — Placeholder linear coefficients for
##     InternalVoice frequency computation. Story 6.3 replaces with real curve.
##     Schema:
##       base_floor: float — minimum frequency floor (clamped from below).
##       awakening_curve: float — added per awakening_level.
##       fatigue_curve: float — added per fatigue derived-stat unit (scaled).
##       cope_curve: float — added per cope_overwork_debit derived-stat unit (scaled).
@export var dialogue: Dictionary = {
    "node_resolve_budget_ms": 50,
    "vm_frame_budget_ms": 1,
    "voice_cap_per_dialogue": 6,
    "voice_first_speak_flourish_ms": 400,
    "tier_ids": ["boss", "recruit_personal", "awakening_beat", "reputation_side", "routine"],
    "tier_word_budgets": {},
    "voice_scaling_default": {
        "base_floor": 0.1,
        "awakening_curve": 0.08,
        "fatigue_curve": 0.05,
        "cope_curve": 0.03,
    },
}
```

`balance.tres` must mirror this. `test_balance_invariants.gd` asserts the locked shape per the IN-scope list.

**AC3 — `DialogueNode` base + 9 concrete subclasses. Resource shapes.**

Each subclass extends `DialogueNode` and `@export`s the fields listed in the IN-scope per-file section. The base class:

```gdscript
class_name DialogueNode extends Resource

## Story 6.1 — Abstract base for the 9 dialogue node types.
## Sealed list of node types: subclasses set `node_type` in _init / via override.
## DialogueVM dispatches on node_type via a switch (no virtual dispatch — concrete).

const TYPE_LINE: String          = "line"
const TYPE_CHOICE: String        = "choice"
const TYPE_SKILL_CHECK: String   = "skill_check"
const TYPE_INTERNAL_VOICE: String = "internal_voice"
const TYPE_ITEM_DROP: String     = "item_drop"
const TYPE_BRANCH: String        = "branch"
const TYPE_SYSTEM_EFFECT: String = "system_effect"
const TYPE_COMMIT: String        = "commit"
const TYPE_END: String           = "end"

const ALL_NODE_TYPES: Array[String] = [
    TYPE_LINE, TYPE_CHOICE, TYPE_SKILL_CHECK, TYPE_INTERNAL_VOICE,
    TYPE_ITEM_DROP, TYPE_BRANCH, TYPE_SYSTEM_EFFECT, TYPE_COMMIT, TYPE_END,
]

@export var node_id: String = ""
# Unique within a DialogueGraph. DialogueGraph.validate() rejects duplicates / blanks.

@export var node_type: String = ""
# Must be one of ALL_NODE_TYPES. Subclasses set this in _init.

@export var next_id: String = ""
# Default routing target. For Choice / SkillCheck / Branch / ItemDrop, the
# concrete subclass overrides next routing — `next_id` is the fallback when
# no choice-specific routing applies (e.g., Choice with no edges).
```

**AC4 — Choice gate enum + skill-gate visible-DC contract.**

`DialogueChoiceNode.choices` entries follow this LOCKED schema:

```gdscript
# Each entry shape:
# {
#     "choice_id": String,        # unique within this choice node
#     "body_key": String,         # tr() key for the choice text
#     "next_id": String,          # routing target when this choice is selected
#     "gate": String,             # one of: GATE_NONE, GATE_SKILL_CHECK, GATE_AWAKENING_MIN,
#                                 #         GATE_TALENT_UNLOCKED, GATE_ITEM_REQUIRED, GATE_LINE_UNLOCKED
#     "gate_args": Dictionary,    # gate-specific: {"skill_id": "yap_game", "dc": 14, "modifier": 0}
#                                 #                 {"awakening_min": 3}
#                                 #                 {"talent_id": "red_pill_dealer"}
#                                 #                 {"evidence_definition_id": "passport_scan"}
#                                 #                 {"line_id": "council_secret_handshake"}
# }
```

Gate constants are declared on `DialogueChoiceNode`:

```gdscript
const GATE_NONE: String              = "none"
const GATE_SKILL_CHECK: String       = "skill_check"
const GATE_AWAKENING_MIN: String     = "awakening_min"
const GATE_TALENT_UNLOCKED: String   = "talent_unlocked"
const GATE_ITEM_REQUIRED: String     = "item_required"
const GATE_LINE_UNLOCKED: String     = "line_unlocked"

const ALL_GATES: Array[String] = [
    GATE_NONE, GATE_SKILL_CHECK, GATE_AWAKENING_MIN, GATE_TALENT_UNLOCKED,
    GATE_ITEM_REQUIRED, GATE_LINE_UNLOCKED,
]
```

**Visible-DC contract (FR55 — locked):** when a choice's `gate == GATE_SKILL_CHECK`, the `dialogue_choice_presented` payload includes display-only `{skill_id, skill_name_key, dc}` derived via `RPGCore.preview_check(...)` (which is documented as DISPLAY-ONLY in `rpg_core.gd` line 443). The choice text body MUST NOT include outcome strings (e.g., NO `"[Yap Game 14/16] — you will succeed"` — only `"[Yap Game 14/16] — body text"`). Test asserts the payload Dictionary has NO outcome-leaking keys.

**AC5 — `unlocked_line_ids` seeding and runtime push.**

**Given** the VM is inactive
**When** `EventBus.dialogue_line_unlocked.emit("council_secret_handshake", "thought_completion")` fires
**Then** the `DialogueRunner._offline_unlocks` Dictionary records `{"council_secret_handshake": "thought_completion"}` (source kept for telemetry)
**And** the next `start_dialogue(...)` call seeds `_vm._state.unlocked_line_ids["council_secret_handshake"] = true` BEFORE the start signal fires
**And** the stash is cleared on consumption.

**Given** the VM is active
**When** `dialogue_line_unlocked` fires
**Then** the runtime state's `unlocked_line_ids` mutates immediately and a `Choice` whose gate is `GATE_LINE_UNLOCKED` for that line_id becomes available to the next `dialogue_choice_presented` payload (the VM does NOT re-emit a presented payload — UI must re-query if it needs live-update; that nuance is Story 6.9's problem).

**AC6 — Branch node closed-enum condition evaluation.**

`DialogueBranchNode.conditions` is evaluated top-to-bottom. The CLOSED ENUM of `condition_type`:

```gdscript
const COND_AWAKENING_MIN: String          = "awakening_min"
const COND_AWAKENING_MAX: String          = "awakening_max"
const COND_FLAG_SET: String               = "flag_set"
const COND_FLAG_NOT_SET: String           = "flag_not_set"
const COND_LINE_UNLOCKED: String          = "line_unlocked"
const COND_DISPOSITION_THRESHOLD: String  = "disposition_threshold"  # args: axis, op (">="/"<="), value
const COND_DERIVED_STAT_THRESHOLD: String = "derived_stat_threshold" # args: stat_id, op, value
const COND_ALWAYS: String                 = "always"
```

The first matching condition wins; `COND_ALWAYS` MUST appear last (validator rejects graphs missing a terminal `always`). **No GDScript expression evaluation. No `eval` / `expression.parse`. Locked.** Test asserts a graph with a non-terminal `always` is rejected by `DialogueGraph.validate()`.

**AC7 — SystemEffect closed-enum effect types + EventBus.queue_signal whitelist.**

`DialogueSystemEffectNode.effects` entries:

```gdscript
const EFFECT_SET_FLAG: String               = "set_flag"               # args: {flag_id}
const EFFECT_CLEAR_FLAG: String             = "clear_flag"             # args: {flag_id}
const EFFECT_FATIGUE_DELTA: String          = "fatigue_delta"          # args: {delta, reason}
const EFFECT_COPE_OVERWORK_DELTA: String    = "cope_overwork_delta"    # args: {delta, reason}
const EFFECT_HEAT_INPUT: String             = "heat_input"             # args: {district_id, delta, reason}
const EFFECT_AWAKENING_INPUT: String        = "awakening_input"        # args: {delta, reason}
const EFFECT_DISPOSITION_INPUT: String      = "disposition_input"      # args: {axis, delta, reason}
const EFFECT_COMPOSURE_DAMAGE: String       = "composure_damage"       # args: {amount} — no-op without EncounterContext
const EFFECT_UNLOCK_LINE: String            = "unlock_line"            # args: {line_id, source}
const EFFECT_QUEUE_SIGNAL: String           = "queue_signal"           # args: {signal_name, payload (Dictionary)}
```

For `EFFECT_QUEUE_SIGNAL`, the LOCKED whitelist of permitted `signal_name` values is:
`dialogue_line_unlocked`, `evidence_reframed`, `subscription_cancelled`-NEVER (not re-emittable from dialogue), `awakening_cinematic_due` (Epic 13 hook), `feed_segment_queued`. Validator rejects any other name. The whitelist exists so dialogue authors cannot accidentally fire `player_died` or other system-critical signals from content. Tests assert non-whitelisted names are rejected at `DialogueGraph.validate()` time AND at runtime (defense-in-depth).

For input-class effects (`fatigue_delta`, `cope_overwork_delta`, `heat_input`, `awakening_input`, `disposition_input`), the VM ROUTES THROUGH the existing single-writer input channels on `EventBus` (e.g., `EventBus.fatigue_input.emit(delta, reason)`). The VM does NOT mutate `RPGCore` state directly — single-writer-input discipline per arch §4.6 and Story 1.7 contract.

**AC8 — `DialogueLinePresentedEvent` payload schema (and the other four typed payloads).**

```gdscript
class_name DialogueLinePresentedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_line_presented.
## Sole writer: DialogueVM._resolve_line_node. Sole reader: Story 6.9 (UI),
## Story 6.3 (voice typography lookup for voice_profile_id).
##
## Tags are surfaced as a frozen copy — subscribers MUST NOT mutate.

@export var graph_id: String = ""
@export var node_id: String = ""
@export var speaker_id: String = ""        # NPC id or "player" / "narrator" (free-form)
@export var body_key: String = ""          # tr() key
@export var voice_profile_id: String = ""  # empty = no Inner Voice tint; non-empty = Story 6.3 typography
@export var tags: PackedStringArray = PackedStringArray()
```

The other four payload classes follow this shape line-for-line:
- `DialogueChoicePresentedEvent`: `graph_id`, `node_id`, `choices: Array[Dictionary]` (each entry has display-only fields — no outcome leakage).
- `DialogueInternalVoicePresentedEvent`: `graph_id`, `node_id`, `voice_profile_id`, `body_key`, `computed_frequency: float`, `chorus_tier: String`, `is_first_speak: bool` (true on this voice_profile_id's FIRST emission within this dialogue run).
- `DialogueItemDropArmedEvent`: `graph_id`, `node_id`, `accepted_evidence_definition_ids: PackedStringArray`.
- `DialogueLineCommittedEvent`: `graph_id`, `node_id`, `committed_line_id: String`, `npc_line_id: String`, `speaker_id: String`, `tags: PackedStringArray`.
- `DialogueSystemEffectAppliedEvent`: `graph_id`, `node_id`, `effect_type: String`, `effect_args: Dictionary` (frozen copy), `applied: bool`.

**AC9 — `DialogueEncounterContext` interface contract (Story 6.6 implements).**

```gdscript
class_name DialogueEncounterContext extends RefCounted

## Story 6.1 — Abstract base for dialogue-as-combat encounter contexts.
## Story 6.6 subclasses as ComposureEncounterContext (multi-stage Composure HP).
## Architecture locked rule 6: the DialogueVM is the only runtime for dialogue;
## boss encounters attach a context, they do NOT use a separate VM.
##
## The five lifecycle methods default to no-op (or null return) so an attached
## context can selectively override only what it needs.

func on_dialogue_started(state: DialogueRuntimeState) -> void:
    pass

func on_node_entered(state: DialogueRuntimeState, node: DialogueNode) -> void:
    pass

func on_system_effect(state: DialogueRuntimeState, effect: Dictionary) -> bool:
    ## Return true to CONSUME (skip default VM handling).
    ## Composure damage example: ComposureEncounterContext intercepts
    ## effect_type == "composure_damage" and reduces HP.
    return false

func on_dialogue_ended(state: DialogueRuntimeState, reason: String) -> void:
    pass

func should_interrupt(state: DialogueRuntimeState) -> Variant:
    ## Return a Dictionary {end_reason: String} to force interrupt;
    ## null to continue normally. Polled after every node resolution.
    return null
```

VM polling sequence per node resolution (LOCKED):

1. `_state.encounter_context.on_node_entered(state, node)` if context attached.
2. Resolve node (emit signals, route).
3. `var interrupt_request = _state.encounter_context.should_interrupt(state)` if attached.
4. If `interrupt_request` is a Dictionary with `end_reason` → call `interrupt(interrupt_request.end_reason)`.

**AC10 — VS fixture graph `dialogue_vm_test_fixture.tres` exercises all 9 node types.**

The fixture is a `DialogueGraph` with:
- `graph_id = "dialogue_vm_test_fixture"`
- `tier = "routine"` (FR66 — does not affect 6.1 behavior; just persisted)
- `participants = ["test_npc_001"]`
- `start_node_id = "n_line_intro"`
- Nine nodes wired in this order:
  - `n_line_intro` (Line, next=`n_branch_awakening`) — speaker `"test_npc_001"`, body_key `"dialogue.test_fixture.intro"`, voice_profile_id `""`, tags `["quotable"]`.
  - `n_branch_awakening` (Branch, conditions=[{`awakening_min`, args={awakening_min: 0}, next=`n_internal_voice_doxcraft`}, {`always`, next=`n_choice_skill_gate`}]) — verifies branch always-fallthrough works.
  - `n_internal_voice_doxcraft` (InternalVoice, voice_profile_id=`"doxcraft"`, body_key=`"dialogue.test_fixture.doxcraft_interjection"`, base_frequency=1.0, chorus_tier=`"interjecting"`, next=`n_choice_skill_gate`) — frequency=1.0 ensures deterministic emit.
  - `n_choice_skill_gate` (Choice, choices=[{choice_id=`c_skill_yap`, body_key=`"dialogue.test_fixture.choice_yap"`, next_id=`n_skill_check_yap`, gate=GATE_SKILL_CHECK, gate_args={skill_id=`"yap_game"`, dc=10}}, {choice_id=`c_plain`, body_key=`"dialogue.test_fixture.choice_plain"`, next_id=`n_item_drop`, gate=GATE_NONE, gate_args={}}]) — test always submits `c_skill_yap` to exercise the SkillCheck node.
  - `n_skill_check_yap` (SkillCheck, skill_id=`"yap_game"`, dc=10, modifier=0, stream_name=`"dialogue"`, outcome_next_ids={critical=`n_item_drop`, success=`n_item_drop`, fail=`n_item_drop`}) — all three outcomes converge to the next node so the fixture is deterministic-result-agnostic.
  - `n_item_drop` (ItemDrop, accepted_items=[{evidence_definition_id=`"passport_scan"`, next_id=`n_system_effect`, consume_on_accept=false, reaction_line_id=`""`}], next=`n_system_effect`) — test calls `accept_item_drop(<passport_scan instance_id>)`.
  - `n_system_effect` (SystemEffect, effects=[{effect_type=`set_flag`, args={flag_id=`"test_flag_set"`}}, {effect_type=`unlock_line`, args={line_id=`"test_unlocked_line"`, source=`"system_effect_node"`}}], next=`n_commit`) — exercises two effect types.
  - `n_commit` (Commit, committed_line_id=`c_skill_yap`, npc_line_id=`n_line_intro`, commit_tags=PackedStringArray([`quotable`, `faction_relevant`]), next=`n_end`).
  - `n_end` (End, end_reason=`"normal"`).

The fixture is referenced by `dialogue_index.tres` and validated by `DialogueCatalog.validate()` on boot.

**AC11 — Performance: `node_resolve_budget_ms` not exceeded.**

`tests/unit/test_dialogue_perf.gd` builds a synthetic 200-node DialogueGraph (200 Line nodes in a linear chain), runs `DialogueRunner.start_dialogue` + repeated `step()` calls to walk it, and tracks the max per-node resolve duration using `Time.get_ticks_msec()`. Asserts `max_ms <= Balance.dialogue.node_resolve_budget_ms` (50ms). NFR8 / arch §6.3 lock.

**AC12 — Save-format diff is ZERO.**

`tests/integration/test_dialogue_no_save_persistence.gd` starts a dialogue, advances to mid-graph, calls `SaveSystem.commit("dialogue_test")`, loads the resulting save into a fresh `RPGCore` instance, and asserts: (a) the load completes without error, (b) `is_active()` returns false (no dialogue restored), (c) parser-level grep on `src/core/save/save_game_v1.gd` against the 6.1 diff finds zero new `@export` lines. The dialogue VM cursor is per-session ephemeral per arch §3.9 — confirmed.

**AC13 — Exactly 11 new EventBus signals; no others.**

`tests/unit/test_no_new_eventbus_signals.gd` adds `test_no_new_signals_added_in_6_1` — asserts the post-6.1 baseline is exactly 71 + 11 = 82 declared signals, and that the 11 new names are exactly: `dialogue_started`, `dialogue_ended`, `dialogue_node_entered`, `dialogue_line_presented`, `dialogue_choice_presented`, `dialogue_choice_selected`, `dialogue_internal_voice_presented`, `dialogue_item_drop_armed`, `dialogue_item_drop_resolved`, `dialogue_line_committed`, `dialogue_system_effect_applied`. (The Story 5.7 baseline of 71 holds.) Test fails if any signal name drifts.

---

## Tasks / Subtasks

- [x] **Task 1 — Author the 9 DialogueNode Resource classes** (AC3, AC4, AC6, AC7)
  - [x] 1.1 `src/dialogue/dialogue_node.gd` — base class + constants
  - [x] 1.2 `src/dialogue/nodes/line_node.gd`
  - [x] 1.3 `src/dialogue/nodes/choice_node.gd` (with `GATE_*` constants)
  - [x] 1.4 `src/dialogue/nodes/skill_check_node.gd`
  - [x] 1.5 `src/dialogue/nodes/internal_voice_node.gd`
  - [x] 1.6 `src/dialogue/nodes/item_drop_node.gd`
  - [x] 1.7 `src/dialogue/nodes/branch_node.gd` (with `COND_*` constants)
  - [x] 1.8 `src/dialogue/nodes/system_effect_node.gd` (with `EFFECT_*` constants + signal whitelist)
  - [x] 1.9 `src/dialogue/nodes/commit_node.gd`
  - [x] 1.10 `src/dialogue/nodes/end_node.gd`
  - [x] 1.11 Append all 10 class entries to `.godot/global_script_class_cache.cfg`
- [x] **Task 2 — Author DialogueGraph + DialogueIndexResource + Catalog** (AC10)
  - [x] 2.1 `src/dialogue/dialogue_graph.gd` (with `validate()`)
  - [x] 2.2 `src/dialogue/dialogue_index_resource.gd`
  - [x] 2.3 `src/dialogue/dialogue_catalog.gd` (mirror `EvidenceCatalog` shape)
  - [x] 2.4 Append class entries to global_script_class_cache.cfg
  - [x] 2.5 Hand-author `src/dialogue/data/fixtures/dialogue_vm_test_fixture.tres` per AC10 spec
  - [x] 2.6 Hand-author `src/dialogue/data/dialogue_index.tres` referencing the fixture
- [x] **Task 3 — Author DialogueRuntimeState, DialogueVM, DialogueEncounterContext** (AC1, AC5, AC9, AC11)
  - [x] 3.1 `src/dialogue/dialogue_runtime_state.gd`
  - [x] 3.2 `src/dialogue/encounter_context.gd` (abstract base)
  - [x] 3.3 `src/dialogue/dialogue_vm.gd` — start / step / submit_choice / accept_item_drop / interrupt / attach_encounter_context + per-node resolvers (the dispatch switch)
  - [x] 3.4 `_compute_voice_frequency(awakening, fatigue, cope) -> float` helper reading `Balance.dialogue.voice_scaling_default`
  - [x] 3.5 Per-node resolver private methods: `_resolve_line_node`, `_resolve_choice_node`, `_resolve_skill_check_node`, `_resolve_internal_voice_node`, `_resolve_item_drop_node`, `_resolve_branch_node`, `_resolve_system_effect_node`, `_resolve_commit_node`, `_resolve_end_node`
  - [x] 3.6 EncounterContext polling sequence per AC9 (locked order)
  - [x] 3.7 Append class entries to global_script_class_cache.cfg
- [x] **Task 4 — Author the 6 typed payload Resources** (AC8)
  - [x] 4.1 `src/core/autoloads/payloads/dialogue_line_presented_event.gd`
  - [x] 4.2 `src/core/autoloads/payloads/dialogue_choice_presented_event.gd`
  - [x] 4.3 `src/core/autoloads/payloads/dialogue_internal_voice_presented_event.gd`
  - [x] 4.4 `src/core/autoloads/payloads/dialogue_item_drop_armed_event.gd`
  - [x] 4.5 `src/core/autoloads/payloads/dialogue_line_committed_event.gd`
  - [x] 4.6 `src/core/autoloads/payloads/dialogue_system_effect_applied_event.gd`
  - [x] 4.7 Append class entries to global_script_class_cache.cfg
- [x] **Task 5 — Extend EventBus + Balance + DialogueRunner facade** (AC2, AC5, AC13)
  - [x] 5.1 Declare 11 new signals in `src/core/autoloads/event_bus.gd` (alongside existing dialogue grouping if any; add a `# Dialogue (Epic 6, Story 6.1)` section header)
  - [x] 5.2 Extend `BalanceResource.dialogue` per AC2 schema
  - [x] 5.3 Write `balance.tres` matching the export defaults
  - [x] 5.4 Rewrite `src/core/autoloads/dialogue_runner.gd` — facade owning one DialogueVM instance + `_offline_unlocks` stash + `_on_dialogue_line_unlocked` subscriber
  - [x] 5.5 Wire `EventBus.dialogue_line_unlocked.connect(_on_dialogue_line_unlocked)` in `_ready()`
- [x] **Task 6 — BootCheck hook + fixture validation** (AC10)
  - [x] 6.1 Add `DialogueCatalog.validate()` to `src/scenes/boot_check.gd` `_ready()`
- [x] **Task 7 — Tests**
  - [x] 7.1 9 unit tests for node Resources (one per type)
  - [x] 7.2 `tests/unit/test_dialogue_graph.gd` — validate() coverage
  - [x] 7.3 `tests/unit/test_dialogue_catalog.gd` — catalog shape
  - [x] 7.4 `tests/unit/test_dialogue_runtime_state.gd` — state defaults + mutations
  - [x] 7.5 `tests/unit/test_dialogue_vm.gd` — per-node-type resolver coverage + lifecycle
  - [x] 7.6 `tests/unit/test_dialogue_runner_facade.gd` — autoload-level coverage + offline-unlock stashing
  - [x] 7.7 `tests/unit/test_dialogue_encounter_context.gd` — base-class contract
  - [x] 7.8 `tests/unit/test_dialogue_perf.gd` — 200-node walk + node_resolve_budget_ms assertion (AC11)
  - [x] 7.9 Extend `tests/unit/test_no_new_eventbus_signals.gd` per AC13
  - [x] 7.10 Extend `tests/unit/test_balance_invariants.gd` — 6 new assertions per IN-scope list
  - [x] 7.11 Extend `tests/unit/test_boot_check.gd` — 2 new tests
  - [x] 7.12 `tests/integration/test_dialogue_vm_full_walk.gd` — full fixture walk + signal-fire verification (AC1)
  - [x] 7.13 `tests/integration/test_dialogue_vm_encounter_context_arc.gd` — stub context lifecycle (AC9)
  - [x] 7.14 `tests/integration/test_dialogue_no_save_persistence.gd` — AC12 lock
  - [x] 7.15 `tests/integration/test_dialogue_runner_offline_unlocks.gd` — AC5 stash + flush

---

## Dev Notes

### Architectural Guardrails — READ BEFORE TYPING

- **Locked rule 6 (arch §7.1):** "Dialogue VM is the only runtime for dialogue. Composure-HP boss encounters use the same VM; no special-case code paths." If you find yourself authoring a `composure_dialogue_vm.gd` or branching on encounter-type inside `DialogueVM`, stop. The seam is `DialogueEncounterContext` (AC9); Story 6.6 subclasses it. The VM remains agnostic.
- **Locked rule 5 (arch §7.1):** Conversation Log is append-only. Story 6.1 does NOT implement the log — it emits `dialogue_line_committed`. Story 6.5 owns the log. Do not write to a `conversation_log.gd` from 6.1.
- **Locked rule 4 (arch §7.1):** Awakening Filter / Awakening level subscribers MUST NOT read `RPGCore.awakening_level` directly outside the signal subscription mechanism. EXCEPTION: synchronous reads from within node resolvers are permitted (the resolver is itself responding to a signal-driven flow already mediated by the VM start path; reading is consistent with the established pattern in `RPGCore.preview_check` and `SkillCheck` engine usage). Just don't subscribe inside DialogueVM to `awakening_level_changed` — there's nothing to react to mid-dialogue.
- **Locked rule 11 (arch §7.1):** No per-cluster reach-around. The VM routes input-class effects through `EventBus.fatigue_input` / `cope_overwork_input` / `heat_input` / `awakening_input` / `disposition_input` — NEVER mutates `RPGCore.fatigue_accumulator` directly. Per Story 1.7 single-writer-input contract.
- **Forbidden patterns (arch §7.2 line 802):** No `await` chains in DialogueVM that block the main thread for >16ms. The VM is synchronous-event-driven, not coroutine-based. UI animation (e.g., portrait micro-animations from Story 6.9) is the UI scene's concern.
- **Forbidden — Branch expression evaluation:** Do NOT use `Expression.parse()` or any string-eval to extend Branch conditions. The enum in AC6 is the complete grammar. If you find a content need not covered, the answer is a new condition_type added to the enum, NOT a string-eval escape hatch.
- **Forbidden — `EFFECT_QUEUE_SIGNAL` whitelist expansion at runtime:** AC7 lists the whitelist. Adding new entries requires a new story (and updates to `DialogueGraph.validate()` + the runtime guard). Do not bypass.

### Source Tree Components to Touch

**New folders + files (greenfield):**

```
src/dialogue/
├── dialogue_node.gd
├── dialogue_graph.gd
├── dialogue_index_resource.gd
├── dialogue_catalog.gd
├── dialogue_runtime_state.gd
├── dialogue_vm.gd
├── encounter_context.gd
├── nodes/
│   ├── .gitkeep (existing)
│   ├── line_node.gd
│   ├── choice_node.gd
│   ├── skill_check_node.gd
│   ├── internal_voice_node.gd
│   ├── item_drop_node.gd
│   ├── branch_node.gd
│   ├── system_effect_node.gd
│   ├── commit_node.gd
│   └── end_node.gd
└── data/
    ├── dialogue_index.tres
    └── fixtures/
        └── dialogue_vm_test_fixture.tres

src/core/autoloads/payloads/
├── dialogue_line_presented_event.gd
├── dialogue_choice_presented_event.gd
├── dialogue_internal_voice_presented_event.gd
├── dialogue_item_drop_armed_event.gd
├── dialogue_line_committed_event.gd
└── dialogue_system_effect_applied_event.gd
```

**Existing files to extend (NO BEHAVIORAL REGRESSION):**

- `src/core/autoloads/dialogue_runner.gd` — full rewrite from 14-line stub to facade.
- `src/core/autoloads/event_bus.gd` — add 11 new signals; existing 71 stay untouched.
- `src/core/balance/balance_resource.gd` — add `dialogue` `@export var` Dictionary.
- `src/core/balance/balance.tres` — write `dialogue` block.
- `src/scenes/boot_check.gd` — add `DialogueCatalog.validate()` line.
- `.godot/global_script_class_cache.cfg` — pre-emptive class entries (~22 new entries).

### Testing Standards Summary

- **Framework:** GUT (already wired per `addons/gut/plugin.cfg`).
- **Unit-test naming:** `tests/unit/test_<module>.gd`. One `extends GutTest` class per file. Test methods named `test_<scenario>_<expected>` per established convention (see `tests/unit/test_evidence_card.gd` for the pattern).
- **Integration tests** under `tests/integration/`. Drive the system via public API (DialogueRunner facade); avoid reaching into `_vm` private state except for assertions on runtime_state().
- **NO scene loading in integration tests for 6.1** — no UI scene exists yet. Story 6.9 will add scene-loading integration tests when the UI lands.
- **Headless test invocation** (memory entry [[reference_godot_binary]]): `& "C:\Users\cpain\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.3-stable_win64_console.exe" --headless --path . -s "addons/gut/gut_cmdln.gd" -gtest=res://tests/unit/test_dialogue_vm.gd` (or whichever file). Run all dialogue tests as a final pass before flipping status to `review`.
- **Performance assertion** (AC11) uses `Time.get_ticks_msec()` deltas. The 200-node fixture is BUILT IN-TEST (programmatically — not authored as a .tres) to keep the fixture set lean. Synthesizing in-test mirrors the Story 5.5 perf-test pattern.
- **NO mocks for `RPGCore.skill_check`** — call the real engine with a controlled RNG seed (`RNG.set_stream_seed("dialogue", <int>)`) to keep outcomes deterministic per the existing test convention (`test_skill_check_distribution.gd` is the reference).

### Project Structure Notes

- `src/dialogue/` was scaffolded by Story 1.0 but ships empty except for `nodes/.gitkeep`. Story 6.1 is the population pass per arch §4.1 folder layout.
- The `DialogueRunner` autoload exists at slot #10 in `project.godot` lines 19–32 (between `MusicDirector` and `EncounterDirector`). The slot order is locked by Story 1.0 and Story 1.5; do NOT reorder. The autoload boots BEFORE `EventBus` (#12), which is why the runner's `EventBus.dialogue_line_unlocked.connect(...)` must happen in `_ready()` (after all autoloads online — Godot guarantees this for cross-autoload signal wiring), NOT at parse time.
- **Naming distinction (locked rule 12):** the player's evidence dossier (`src/investigation/`) is the **Evidence Dossier**; the Cage-side faction file (`src/tracking/player_dossier.gd`) is the **Faction Dossier**. Story 6.1's ItemDrop node reads `RPGCore.evidence_inventory` (the Evidence Dossier instance store from Story 5.1) — NEVER the Faction Dossier.
- **Voice profile ids referenced by the fixture** (`"doxcraft"`, `"yap_game"` skill_id) are placeholder strings. Story 6.3 ships the 24 `VoiceProfile` resources with the canonical ids matching this list (gdd.md line 1981: Rabbit Hole, [X] Fatigue, Doxcraft, Glowie Sense, Yap Game, Lore Depth, Based Talk, Rizz, NPC Mode, Ratio, Clout, Ghost Mode, Normie Cosplay, Receipts, OPSEC, Gymmaxx, Hands, Anti-Slop, IRL Build, Web, Ghost Protocol, Sneaky Links, Signal Hijack, Edit Farm). 6.1 does NOT validate voice_profile_id against a catalog — that's 6.3's gate.

### Previous Story Intelligence (Story 5.7 — most recent done in Epic 5)

- **Verbose AC pseudocode pattern.** 5.7 locked schemas verbatim with `gdscript` code blocks. Continue here — every Resource shape is locked in an AC.
- **`tests/unit/test_no_new_eventbus_signals.gd` baseline ticking.** 5.7 set baseline at 71. 6.1 jumps it by exactly +11 to 82 per AC13. The test file pattern is to add a new `test_no_new_signals_added_in_6_1` method asserting the count AND the exact new-name set.
- **`.godot/global_script_class_cache.cfg` pre-emptive registration.** 5.7 / 5.5 / 5.1 all pre-emptively appended class entries. Headless GUT fails-fast if a `class_name` is referenced before its file is registered in the cache. ~22 new entries land in 6.1.
- **Frozen-copy discipline for tag arrays.** 5.7's payload tests assert PackedStringArray returns are duplicated to prevent caller mutation. Mirror in `DialogueLinePresentedEvent.tags`.
- **"Forbidden patterns" lists at the end of each scope-boundary section.** 6.1 follows this convention — see the "If you find yourself..." paragraph in Scope Boundary above.

### Git Intelligence — Recent Commit Patterns

Recent commits show the established workflow:
- `66f8676 fix(investigation): code-review patches for Story 5.2 Physical Board` — code-review patches land as fix commits BEFORE the story flips to done. After patches + tests pass, flip to done (memory entry [[feedback_code_review_auto_done]]).
- `5716c95 fix(rpg): code-review patches for Story 1.2` — guard / threshold / test-hardening pattern. Story 6.1 will likely see review feedback on: Branch evaluation edge cases, EFFECT_QUEUE_SIGNAL whitelist coverage, the EncounterContext null-check on every poll, and the perf budget test's tolerance (consider 1.5× budget on min-spec to avoid flakes).
- `2b80934 feat(rpg): 24-skill system (Story 1.2)` — the `feat(<cluster>):` commit-prefix convention. Use `feat(dialogue): Story 6.1 Dialogue VM — all 9 node types`.

### References

- [Source: _bmad-output/game-architecture.md §3.8 lines 289–300] — Dialogue Runtime decision (D-DIALOG-01); locked rule 6 statement; 9 node-type list.
- [Source: _bmad-output/game-architecture.md §3.9 lines 304–311] — Per-session ephemeral classification of dialogue VM cursor.
- [Source: _bmad-output/game-architecture.md §5.5 lines 630–648] — Conversation Log + Dialogue VM responsibility split; the Commit node hook.
- [Source: _bmad-output/game-architecture.md §6.3 lines 700–711] — Performance budgets table; <1ms per frame; <50ms per node resolve.
- [Source: _bmad-output/game-architecture.md §7.1 lines 778–790] — Locked rules 1–12 (esp. 4, 5, 6, 11, 12).
- [Source: _bmad-output/game-architecture.md §7.2 lines 793–814] — Forbidden patterns (esp. await chains line 802).
- [Source: _bmad-output/gdd.md lines 844–918] — Dialogue depth design intent; visible-DC / hidden-consequence; tier-based frequency; Composure HP; item-drop; 24 Inner Voices.
- [Source: _bmad-output/planning-artifacts/epics.md §"Epic 6" lines 894–906] — Epic-level scope + architecture scope + UX-DRs + Conversation Log perf gate.
- [Source: _bmad-output/planning-artifacts/epics.md §"Story 6.1" lines 1942–1960] — Story-level user story + acceptance criteria + perf budgets + EncounterContext clause.
- [Source: src/core/autoloads/rpg_core.gd line 412] — `RPGCore.skill_check(skill_id, dc, modifier, stream_name)` return shape; SkillCheck node wraps.
- [Source: src/core/autoloads/rpg_core.gd line 442] — `RPGCore.preview_check(skill_id, dc)` DISPLAY-ONLY return shape; Choice gate visible-DC surface.
- [Source: src/core/autoloads/event_bus.gd line 64] — Existing `dialogue_line_unlocked(line_id, source)` signal — VM is first subscriber.
- [Source: src/core/autoloads/dialogue_runner.gd lines 1–14] — Current stub being rewritten.
- [Source: project.godot line 30] — `DialogueRunner` autoload registration; do not reorder.
- [Source: _bmad-output/implementation-artifacts/epic-5-investigation-ui/5-7-awakening-reframes-evidence.md] — Reference for story-detail-level + AC-pseudocode pattern + Scope Boundary discipline.
- [Source: _bmad-output/implementation-artifacts/epic-5-investigation-ui/5-1-evidence-system.md] — Reference for catalog + Resource + class_cache pre-emption pattern.

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6[1m]

### Debug Log References

- Fixed `RPGCore.advance_awakening` signature: takes only `reason: String`, not `(delta, reason)`. Looped N times for delta.
- Fixed `RPGCore.get_disposition` return: returns `{value, label}` Dictionary, not float. Extracted `.value` for threshold comparison.
- Fixed lambda signal disconnect: stored callables as `var cb := func(...)` before connect/disconnect.
- Fixed `RNG.set_stream_seed` → correct API is `RNG.restore_stream("stream", seed)`.
- Fixed encounter context timing: moved attach_encounter_context from AFTER vm.start() to INSIDE vm.start() via new optional parameter, so EncounterContext hooks fire correctly during initial advance.
- Fixed test for AC12: `dialogue_line_unlocks` is a Story 5.5 Thought Cabinet field — NOT a VM cursor field. Test now checks forbidden cursor-pattern strings instead.

### Completion Notes List

- All 9 node types implemented as Resource classes with locked enum constants (GATE_*, COND_*, EFFECT_*, QUEUE_SIGNAL whitelist).
- DialogueGraph.validate() covers all failure modes: missing start, dangling next_ids, duplicate node_ids, unknown types, broken choice gate args, non-terminal branch always, non-whitelisted queue_signal.
- DialogueVM walks graphs synchronously — no await chains. EncounterContext hooks fire per AC9 locked sequence.
- DialogueCatalog mirrors EvidenceCatalog shape. VS fixture exercises all 9 node types deterministically (base_frequency=1.0, all skill_check outcomes converge).
- 11 new EventBus signals added; post-6.1 baseline = 82. All existing signal-count tests updated.
- Balance.dialogue sub-dict matches AC2 locked schema. balance.tres mirrors defaults.
- DialogueRunner is a thin facade; encounter_context now passed to vm.start() for correct hook sequencing.
- Offline unlock stash flushes to runtime_state.unlocked_line_ids on start_dialogue (AC5).
- All dialogue tests pass: 100/100 unit, 7/7 full-walk integration, 3/3 encounter context arc, 3/3 save persistence, 4/4 offline unlocks. Perf test: 200-node walk well under 50ms budget. Full regression: 2337 passing (1 pre-existing boot_check stamp failure unchanged).

### File List

- src/dialogue/dialogue_node.gd (new)
- src/dialogue/nodes/line_node.gd (new)
- src/dialogue/nodes/choice_node.gd (new)
- src/dialogue/nodes/skill_check_node.gd (new)
- src/dialogue/nodes/internal_voice_node.gd (new)
- src/dialogue/nodes/item_drop_node.gd (new)
- src/dialogue/nodes/branch_node.gd (new)
- src/dialogue/nodes/system_effect_node.gd (new)
- src/dialogue/nodes/commit_node.gd (new)
- src/dialogue/nodes/end_node.gd (new)
- src/dialogue/dialogue_graph.gd (new)
- src/dialogue/dialogue_index_resource.gd (new)
- src/dialogue/dialogue_catalog.gd (new)
- src/dialogue/dialogue_runtime_state.gd (new)
- src/dialogue/dialogue_vm.gd (new)
- src/dialogue/encounter_context.gd (new)
- src/dialogue/data/dialogue_index.tres (new)
- src/dialogue/data/fixtures/dialogue_vm_test_fixture.tres (new)
- src/core/autoloads/payloads/dialogue_line_presented_event.gd (new)
- src/core/autoloads/payloads/dialogue_choice_presented_event.gd (new)
- src/core/autoloads/payloads/dialogue_internal_voice_presented_event.gd (new)
- src/core/autoloads/payloads/dialogue_item_drop_armed_event.gd (new)
- src/core/autoloads/payloads/dialogue_line_committed_event.gd (new)
- src/core/autoloads/payloads/dialogue_system_effect_applied_event.gd (new)
- src/core/autoloads/event_bus.gd (modified — +11 dialogue signals)
- src/core/autoloads/dialogue_runner.gd (rewritten — full VM facade)
- src/core/balance/balance_resource.gd (modified — +dialogue dict export)
- src/core/balance/balance.tres (modified — +dialogue block)
- src/scenes/boot_check.gd (modified — +DialogueCatalog.validate())
- .godot/global_script_class_cache.cfg (modified — +22 new class entries)
- tests/unit/test_dialogue_line_node.gd (new)
- tests/unit/test_dialogue_choice_node.gd (new)
- tests/unit/test_dialogue_skill_check_node.gd (new)
- tests/unit/test_dialogue_internal_voice_node.gd (new)
- tests/unit/test_dialogue_item_drop_node.gd (new)
- tests/unit/test_dialogue_branch_node.gd (new)
- tests/unit/test_dialogue_system_effect_node.gd (new)
- tests/unit/test_dialogue_commit_node.gd (new)
- tests/unit/test_dialogue_end_node.gd (new)
- tests/unit/test_dialogue_graph.gd (new)
- tests/unit/test_dialogue_catalog.gd (new)
- tests/unit/test_dialogue_runtime_state.gd (new)
- tests/unit/test_dialogue_vm.gd (new)
- tests/unit/test_dialogue_runner_facade.gd (new)
- tests/unit/test_dialogue_encounter_context.gd (new)
- tests/unit/test_dialogue_perf.gd (new)
- tests/unit/test_no_new_eventbus_signals.gd (modified — +6.1 assertions, counts 71→82)
- tests/unit/test_balance_invariants.gd (modified — +6 dialogue dict assertions)
- tests/unit/test_boot_check.gd (modified — +2 dialogue catalog tests)
- tests/integration/test_dialogue_vm_full_walk.gd (new)
- tests/integration/test_dialogue_vm_encounter_context_arc.gd (new)
- tests/integration/test_dialogue_no_save_persistence.gd (new)
- tests/integration/test_dialogue_runner_offline_unlocks.gd (new)

### Review Findings

- [x] [Review][Patch] AC5 violation — offline unlocks seeded AFTER dialogue_started fires [dialogue_runner.gd:29, dialogue_vm.gd:start()]
- [x] [Review][Patch] Dead code `pass` block in start_dialogue for offline unlocks [dialogue_runner.gd:24-27]
- [x] [Review][Patch] randf() used for voice frequency roll instead of RNG.stream("dialogue").randf() [dialogue_vm.gd:267]
- [x] [Review][Patch] submit_choice with empty next_id doesn't advance cursor, silently stalls [dialogue_vm.gd:60-62]
- [x] [Review][Patch] Branch condition empty next_id passes validator, causes runtime interrupted teardown [dialogue_graph.gd:116]
- [x] [Review][Defer] speaker_id hardcoded "player" in CommitNode payload [dialogue_vm.gd:467] — deferred, Story 6.5 owns speaker resolution
- [x] [Review][Defer] accept_item_drop no-match leaves cursor on item_drop node indefinitely [dialogue_vm.gd:91] — deferred, Story 6.4 owns UX response path

### Change Log

- feat(dialogue): Story 6.1 Dialogue VM — all 9 node types (2026-05-17)
- fix(dialogue): code-review patches for Story 6.1 — AC5 ordering, randf stream, submit_choice fallback, branch validator (2026-05-17)
