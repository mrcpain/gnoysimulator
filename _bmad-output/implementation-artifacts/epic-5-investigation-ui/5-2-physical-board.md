# Story 5.2: Physical Board — Pinning + Empty State

**Status:** done
**Epic:** 5 — Investigation UI (Three Layers) — The Truth Paradox
**Story ID:** 5.2
**Story Key:** 5-2-physical-board

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

---

## User Story

As a player working a case in the Apartment,
I want a diegetic corkboard scene where I can pin evidence cards (drag-drop from a side drawer OR via the click-source-then-target accessibility alternative — UX-DR107), see a Resistance-handwritten "Nothing pinned yet." empty-state on first entry, watch the visible area scale with homebase stage (Stage 1 ≈ 30 cards / Stage 4 distributed-board stub), and have pin positions round-trip through save/load,
So that investigation is a tactile *space* rather than a system menu and the first Connection-Draw moment (Story 5.3) lands on a board the player has already curated (FR4, UX-DR30, UX-DR60, UX-DR107, UX-DR125; epics §"Story 5.2").

---

## Scope Boundary (READ FIRST)

This story ships the **first Epic-5 player-facing surface**: the Physical Board scene-as-screen, the `EvidenceCard` widget (custom UX component UX-DR30 — re-used by Stories 5.3 / 5.4 / 5.5 / 5.7), an inventory-drawer side panel sourced from Story 5.1's `EvidenceInventory`, pin position persistence, an empty-state note, and a per-homebase-stage visible-capacity hook. It ships **ZERO connection-mechanic / red-string drawing** (Story 5.3), **ZERO publication routing** (Story 5.4), and **ZERO stamp animation grammar** (Story 5.6). Story 5.7 reads the same EvidenceCard widget for Awakening reframes.

**IN scope:**

- **New folder:** `src/investigation/board/` populated for the first time.
- **`src/investigation/physical_board.gd`** (class_name `PhysicalBoardController extends Control`) — the scene-as-screen overlay. Mirrors `EquipmentScreenController` (`src/ui/diegetic/equipment_screen.gd`) shape: `theme_variant` field set by caller before `add_child`, `_ready()` wires subscribers + refreshes panels + grabs focus, `close()` queue_frees self, `_unhandled_input` consumes `ui_cancel`. **Pause-behavior diverges from 4.5**: per UX §6.6 / line 895 ("does not pause for the Investigation suite"), 5.2 does NOT call `get_tree().paused = true`. Only `process_mode = Node.PROCESS_MODE_ALWAYS` is set, so input still routes while a future pause source is active.
- **`src/investigation/physical_board.tscn`** — root `Control` covering full viewport; child layout is: `Background` (ColorRect = corkboard surface), `Header` (close button + title), `ScrollContainer` (the pin-able board surface with `pin_layer` Control as scrollable child), `InventoryDrawer` (right side, EvidenceInventoryDrawer), `EmptyStateNote` (Label, visible only when zero pinned and zero inventoried), `StageCapacityHint` (small bottom-left Label showing `n/cap` for the current homebase stage).
- **`src/investigation/board/physical_board_state.gd`** (class_name `PhysicalBoardState extends RefCounted`) — pure-static helper module operating on `RPGCore.board_pinned_positions`. Mirrors `EvidenceInventory` shape (storage on RPGCore, ops in module). Exposes: `pin(instance_id, x, y) -> bool`, `unpin(instance_id) -> bool`, `move(instance_id, x, y) -> bool`, `is_pinned(instance_id) -> bool`, `position_of(instance_id) -> Dictionary` (returns `{}` if not pinned), `all_pinned_ids() -> Array[String]`, `count() -> int`, `prune_unknown_instances() -> int` (drops pins whose instance_id no longer exists in `RPGCore.evidence_inventory`; returns count dropped — called by SaveSystem load path AND by `PhysicalBoardController._ready()` defensively). **No EventBus emissions** from this module — pure data ops.
- **`src/ui/components/evidence_card.gd`** + `.tscn` (class_name `EvidenceCard extends Control`) — the custom UX-DR30 widget. Renders the polaroid-style frame + caption (read via `EvidenceInventory.get_instance_for_ui(instance_id)` — **never** `get_instance`, per FR10), and a stamp slot (Verified / Probable / Uncertain / Seized — only Seized is wired in 5.2; the connection-outcome stamps are 5.3 / 5.6 scope). Three states: `default`, `hover` (string-target candidate — visual cue only in 5.2; the candidate semantics light up in 5.3), `armed_source` (UX-DR107 click-source-then-target — the player clicked this card to pick it up for placement). Emits two signals: `card_picked_up(instance_id: String)` (drag-start OR click-arm), `card_placement_committed(instance_id: String, x: int, y: int)` (drag-drop release OR click-target on the board surface). **Does not** emit anything on hover. Keyboard-navigable via Godot's built-in focus chain. **NEVER reads or surfaces `cage_planted`** (FR10 contract — uses `get_instance_for_ui` exclusively).
- **`src/ui/components/evidence_inventory_drawer.gd`** + `.tscn` (class_name `EvidenceInventoryDrawer extends Control`) — the right-side panel listing every un-pinned evidence instance (filters `EvidenceInventory.all_instance_ids()` by `not PhysicalBoardState.is_pinned(id)`). Each row renders a small `EvidenceCard` in `default` state. Click-or-drag from a row → emits `row_picked_up(instance_id)`. Refreshes on `EventBus.hud_screen_requested("evidence_board")` (in case the player picked up evidence between sessions — the drawer is the canonical source-of-truth at scene mount).
- **`PhysicalBoardController` interaction logic:**
  - **Drag path:** mouse-down on inventory-drawer row OR pinned card → starts a drag using Godot's `_get_drag_data` / `_can_drop_data` / `_drop_data` Control pattern (already used by EquipmentSlotWidget at `src/ui/components/equipment_slot_widget.gd`). On drop on the `pin_layer`, calls `PhysicalBoardState.pin(id, drop_x, drop_y)` (or `.move` if already pinned), removes the drawer row (or moves the existing card visual), and rebuilds the empty-state visibility.
  - **Click-source-then-target alt (UX-DR107):** clicking a drawer row OR a pinned card sets `_armed_instance_id`. Visual cue: the card enters `armed_source` state. Next click on the `pin_layer` surface fires `PhysicalBoardState.pin / move` at the click position and clears `_armed_instance_id`. Esc clears `_armed_instance_id` without closing the board. **The armed state mirrors EquipmentScreenController._armed_crafted_item_id (Story 4.5 pattern).**
  - **Right-click on a pinned card:** unpin → `PhysicalBoardState.unpin(id)` → card returns to the drawer.
  - **Keyboard nav:** Tab cycles through inventory-drawer rows then pinned cards. Enter on a focused inventory row arms it. Enter on the pin_layer with an armed instance places it at the pin_layer's center (since keyboard has no pointer). Right-arrow when a pinned card is focused → enters "nudge mode" where arrow keys move it by `Balance.investigation.board_nudge_step_px` pixels per press. Enter commits the move; Esc reverts.
- **RPGCore extension** (`src/core/autoloads/rpg_core.gd`): new `var board_pinned_positions: Dictionary = {}` (key: `instance_id: String`; value: `Dictionary` with the schema locked in AC5). No new EventBus subscriber needed — the board's lifecycle is opening/closing via `hud_screen_requested` (which RPGCore does NOT subscribe to — RPGCore is not a UI host).
- **SaveGameV1 extension** (`src/core/save/save_game_v1.gd`): new `@export var board_pinned_positions: Dictionary = {}`. Add to `migrate_from()` property allowlist (lines 122–143). Add a new `validate_and_clamp` block that drops malformed entries AND drops entries whose `instance_id` is not in the (already-clamped) `evidence_inventory` (mirrors the `crafted_inventory → EquipmentCatalog.has_item` orphan-drop pattern at lines 505–508).
- **SaveSystem round-trip** (`src/core/autoloads/save_system.gd`): wire `save.board_pinned_positions = RPGCore.board_pinned_positions.duplicate(true)` in the save path and `RPGCore.board_pinned_positions = save.board_pinned_positions.duplicate(true)` in `_apply_save_to_rpgcore` (or whatever the canonical load handler is — check `evidence_inventory` wiring from 5.1 for the exact function name). Then call `PhysicalBoardState.prune_unknown_instances()` AFTER the inventory + board copies land, so orphan pins (instance was dropped by clamp but pin survived) are cleaned at load time as a defense-in-depth pass.
- **Apartment scene wiring** (`src/scenes/apartment.gd`):
  1. Add `const PHYSICAL_BOARD_SCENE: PackedScene = preload("res://src/investigation/physical_board.tscn")` next to the existing `EQUIPMENT_SCREEN_SCENE` const.
  2. Add `var _active_board: Control = null` next to `_active_equipment_screen`.
  3. Extend `_on_hud_screen_requested(screen_id: String)` to handle `screen_id == "evidence_board"` (mirroring the existing inventory branch at lines 123–134).
  4. Add corkboard interaction zone — extend the apartment `LAYOUT` (lines 24–40) by re-purposing one of the existing wall cells in the upper-right region as a **corkboard tile**. Locked placement: cell `(row=2, col=16)` (currently code `14` = fridge) — **swap** to a new code `16 = corkboard` AND add the corresponding `ATLAS_COORDS` entry. Then **un-swap fridge** at `(2,16)` by leaving the second fridge tile at `(3,16)` only. **Defer the actual corkboard art tile** to Epic A Story a-6-slopside-tileset-apartment — Story 5.2 ships a programmatic 32×32 corkboard placeholder using the existing window tile `Vector2i(3,2)` as a stand-in (with a TODO comment naming a-6).
  5. Add an `Area2D` child of the corkboard cell that listens for player overlap + Interact action — the existing `interact` action (`KEY_E`) is the contract per UX-DR125 ("walk to corkboard, press E"). On `interact` while overlapping, emit `EventBus.hud_screen_requested.emit("evidence_board")`. **Apartment's existing `_on_hud_screen_requested` handler** then mounts the board scene.
- **ThemeTokens extensions** (`src/ui/theme/tokens.gd`): add Story 5.2 keys per AC9 (corkboard surface color, pin red, evidence card paper, polaroid frame, empty-state typewriter font size, motion durations). Two theme variants: `xyoner` (post-VS — Stage 3+ War Room aesthetic) and `resistance` (VS-locked Apartment aesthetic). 5.2 SHIPS BOTH KEYS but `physical_board.tscn` mounts at `theme_variant = "resistance"` only (the Apartment is Resistance-side per the Story 4.5 precedent). Xyoner variant defaults are placeholders for War Room work post-VS.
- **Balance extension** (`src/core/balance/balance_resource.gd` + `balance.tres`): add new top-level `investigation` Dictionary with two keys: `board_visible_capacity_by_stage: {1: 30, 2: 60, 3: 100, 4: 200}` (per GDD §Layer 1 "Stage 1 ≈ 30 items"), and `board_nudge_step_px: 8`. Update `tests/unit/test_balance_invariants.gd` with `test_balance_investigation_section_present` + `test_board_visible_capacity_by_stage_keyed_1_to_4_monotonic`. **No balance-lint magnitude assertions** — these are visible-area hints, not numeric balance tunables.
- **BootCheck wiring** (`src/scenes/boot_check.gd` line 12–15): add `ThemeTokens.token("color.board.surface.resistance")` token-presence check (mirror the Story 4.5 token-presence pattern if one exists; if not, add the call to `ThemeTokens.token(...)` for the five new tokens and assert returned Color != Color.MAGENTA — the "unknown key" sentinel per `tokens.gd` line 65).
- **`.godot/global_script_class_cache.cfg`** — append pre-emptive class entries for 4 new `class_name` declarations: `PhysicalBoardController`, `PhysicalBoardState`, `EvidenceCard`, `EvidenceInventoryDrawer`. Mirrors the 4.1–4.5 + 5.1 headless-parser pre-emption pattern (every `class_name` declaration must have a matching cache entry so headless GUT runs don't NPE on first reference).
- **Tests** — unit tests for each new module (`tests/unit/test_physical_board_state.gd`, `test_evidence_card.gd`, `test_evidence_inventory_drawer.gd`, `test_physical_board_controller.gd`); save round-trip test (`tests/unit/test_save_game_v1_board.gd`); RPGCore var-existence test (`test_rpg_core_board_pinned_positions.gd`); integration test for the open → pin → save → reload → see-pinned arc (`tests/integration/test_physical_board_pin_persist_arc.gd`); apartment-scene integration test for the `interact`→ open arc (`tests/integration/test_apartment_corkboard_open_arc.gd`).
- **NO new EventBus signals.** Story 5.2 reuses **`hud_screen_requested`** (line 199 of event_bus.gd, declared by Story 1.12) as the open trigger. Baseline stays at **68** signals — `tests/unit/test_no_new_eventbus_signals.gd` gets a new `test_no_new_signals_added_in_5_2` assertion at 68. The pin / unpin / move mutations are observable only via direct read of `RPGCore.board_pinned_positions`; tests assert this directly. The `connection_drawn` signal at line 187 stays reserved for 5.3 — 5.2 must not emit on it.

**OUT of scope — explicitly deferred. Do NOT implement:**

- **Connection mechanic / red string drag / 3-outcome skill check.** Story 5.3 owns this in full. 5.2's `EvidenceCard.hover` state is a visual placeholder only — no string preview rendering, no skill-check fire, no `connection_drawn` emission.
- **Stamp grammar animations** (Verified +5° / Probable 0° / Uncertain −5° rotation; dice-flip; SFX). Story 5.6 owns the shared stamp grammar reused across connection / publication / subscription / thought-completion. 5.2 renders a Seized stamp as a **static badge** (no animation) on cards whose underlying instance has `seized == true` — this is the only stamp surface in 5.2.
- **Publication routing** ("Prepare for Publication" button, Dossier scene navigation, PublicationFramingMatrix). Story 5.4 scope.
- **Thought Cabinet integration.** Story 5.5.
- **Awakening reframe bracketed addenda on cards.** Story 5.7 — 5.2's EvidenceCard reads only the canonical `get_instance_for_ui` fields; no Awakening-conditional rendering.
- **Cage-planted-flag UI surfacing.** FR10 contract from 5.1 carries forward — `EvidenceCard` MUST call `EvidenceInventory.get_instance_for_ui(...)` (the UI-safe getter that strips `cage_planted`). Any reference to `EvidenceInventory.get_instance(...)` or `EvidenceInventory.is_cage_planted(...)` inside `src/ui/components/evidence_card.gd` or `src/investigation/physical_board.gd` is a **dev-review blocker**.
- **Stage 4 Distributed-Cells subboard switcher (FR4 second clause).** 5.2 ships only the visible-capacity scaling hook (`Balance.investigation.board_visible_capacity_by_stage`) and a Logger.info one-liner when the scene opens at `RPGCore.homebase_stage == 4`. The actual cell-switcher UI (per-cell subboards, distributed assignment) is Story 8.6 scope. **A `# TODO Story 8.6` comment marks the call site.**
- **War Room scene** (Stage 3+ network-graph + map overlay + Heat map). Out of Epic 5 entirely — see `_bmad-output/game-architecture.md` §4.1 `src/investigation/war_room.gd` planned path; first ship is post-VS.
- **Multi-board / multi-scene support.** 5.2 ships ONE board (the Apartment corkboard). Future homebase stages get their own corkboard scenes in 8.6.
- **Sticky-note margin annotation.** GDD §Layer 1 mentions "scrawls margin notes" — that's post-VS authoring tool work.
- **Telemetry hooks.** No Logger.info per pin/unpin. Log only at scene open (one summary line: `"PhysicalBoard opened: pinned=%d inventory=%d stage=%d"`), at scene close (`"PhysicalBoard closed: pinned=%d"`), and inside `prune_unknown_instances` (one summary line if non-zero pruned).
- **Xyoner theme variant rendering.** Tokens are authored (AC9) but no scene mounts at `theme_variant = "xyoner"` in 5.2. The keys are stub placeholders for War Room work post-VS.
- **Schema migration to V2.** 5.2 is a V1 schema bump (new field on V1, default `{}`). The migrate_from V1→V1 path coerces missing fields to defaults (lines 122–143). No SchemaVersion bump.

If you find yourself drawing a red string, emitting `connection_drawn`, rendering a Verified/Probable/Uncertain stamp animation, routing to a Dossier scene, reading `cage_planted` from any UI code, or building a per-cell subboard switcher — **stop and re-read this section.**

---

## Acceptance Criteria

**AC1 — `PhysicalBoardController` scene-as-screen at `src/investigation/physical_board.gd`.**

```gdscript
class_name PhysicalBoardController extends Control

## Story 5.2 — Diegetic corkboard scene-as-screen.
## Source: epics.md §"Story 5.2" + UX-DR30 + UX-DR60 + UX-DR107 + UX-DR125 + GDD §"Layer 1 — Physical Board".
## Theme variant injected by caller; defaults to "resistance" (Apartment scene).
##
## Lifecycle:
##   1. Caller (apartment.gd) instantiates, sets theme_variant, calls add_child (mounts as overlay).
##   2. _ready() defensively prunes orphan pins, wires inventory drawer, refreshes pin_layer,
##      grabs initial focus on the first inventory row.
##   3. _unhandled_input() consumes ui_cancel to close.
##   4. close() queue_frees self. Does NOT touch get_tree().paused (UX rule §6.6 — investigation
##      does NOT pause).
##
## Forbidden:
##   - Mutating RPGCore.evidence_inventory. Reads only via EvidenceInventory.get_instance_for_ui.
##   - Calling EvidenceInventory.get_instance (raw getter; surfaces cage_planted — FR10 violation).
##   - Calling EvidenceInventory.is_cage_planted from any UI code path.
##   - Emitting EventBus.connection_drawn (Story 5.3 owns).
##   - Calling get_tree().paused = true (UX rule §6.6 — investigation IS the day slot).
##   - Subscribing to EventBus.theme_tokens_changed (read tokens on mount only).
##   - Holding scene refs in static state.

const THEME_VARIANT_RESISTANCE: String = "resistance"
const THEME_VARIANT_XYONER:     String = "xyoner"
const VALID_THEME_VARIANTS: Array[String] = ["resistance", "xyoner"]

# Set by caller BEFORE add_child via `screen.theme_variant = "resistance"`.
var theme_variant: String = THEME_VARIANT_RESISTANCE

# Per-screen runtime state. Reset on every open.
var _armed_instance_id: String = ""           # "" = no armed instance (UX-DR107 alt mode)
var _nudge_mode_card: EvidenceCard = null     # Non-null = a pinned card is in keyboard-nudge mode
var _nudge_original_pos: Vector2i = Vector2i.ZERO  # Restored on Esc-during-nudge

# Sub-component refs set in _build_layout()
var _pin_layer: Control = null
var _inventory_drawer: EvidenceInventoryDrawer = null
var _empty_state_note: Label = null
var _stage_capacity_hint: Label = null
var _pinned_card_widgets: Dictionary = {}     # {instance_id: EvidenceCard}
```

- **Given** the controller is instantiated with `theme_variant = "resistance"`, **when** `_ready()` completes, **then** every `RPGCore.board_pinned_positions` entry whose key is in `RPGCore.evidence_inventory` renders an `EvidenceCard` at its stored position; entries whose key is missing from inventory are pruned (with a Logger.info one-liner naming the prune count).
- **Given** `RPGCore.board_pinned_positions` is empty AND `RPGCore.evidence_inventory` is empty, **when** the scene mounts, **then** the empty-state note is visible with text `tr("ui.board.empty_state")` (e.g., `"Nothing pinned yet."` per UX line 1095).
- **Given** the empty-state note is showing, **when** the player pins a card (via drag or click-arm-then-target), **then** the empty-state note becomes hidden (visibility toggled on every `_refresh_empty_state()` call after every pin / unpin).
- **Given** `RPGCore.homebase_stage == 4`, **when** the scene opens, **then** a single `Logger.info("investigation", "physical_board: stage 4 detected — distributed-cells subboard switcher deferred to Story 8.6")` line fires. The board still renders as the Stage-4 single-flat-list view (no special UI in 5.2).
- **Given** the player presses `ui_cancel` (Esc), **when** no nudge mode is active and no armed instance is set, **then** the board closes (queue_free, parent un-references via `tree_exited`).
- **Given** the player presses `ui_cancel`, **when** a card is in nudge mode, **then** the nudge is reverted (position restored to `_nudge_original_pos`) and the board STAYS open.
- **Given** the player presses `ui_cancel`, **when** `_armed_instance_id != ""`, **then** the armed state clears and the board STAYS open (mirrors `EquipmentScreenController.close` line 76–79).

Unit tests (`tests/unit/test_physical_board_controller.gd`): `test_controller_ready_prunes_orphan_pins`; `test_controller_renders_existing_pinned_cards`; `test_controller_empty_state_visible_when_zero_pinned_and_zero_inventory`; `test_controller_empty_state_hides_after_first_pin`; `test_controller_stage_4_logs_subboard_deferral`; `test_controller_close_via_ui_cancel`; `test_controller_ui_cancel_reverts_nudge_does_not_close`; `test_controller_ui_cancel_clears_armed_does_not_close`; `test_controller_does_not_pause_tree` (assert `get_tree().paused == false` after `_ready()`).

---

**AC2 — `EvidenceCard` widget at `src/ui/components/evidence_card.gd`.**

```gdscript
class_name EvidenceCard extends Control

## Story 5.2 — UX-DR30 custom component. Re-used by Stories 5.3 / 5.4 / 5.5 / 5.7.
## Renders a single evidence INSTANCE; reads metadata via EvidenceInventory.get_instance_for_ui.
##
## Forbidden:
##   - Calling EvidenceInventory.get_instance / .is_cage_planted (FR10 — cage_planted MUST NOT
##     surface in UI code paths).
##   - Reading RPGCore.evidence_inventory directly.
##   - Emitting EventBus signals (5.2 ships zero new signals; widget-internal signals only).

const STATE_DEFAULT: String      = "default"
const STATE_HOVER: String        = "hover"          # Visual only in 5.2; semantic in 5.3.
const STATE_ARMED_SOURCE: String = "armed_source"   # UX-DR107 click-source-then-target.

signal card_picked_up(instance_id: String)
signal card_placement_committed(instance_id: String, x: int, y: int)
signal card_unpin_requested(instance_id: String)   # Right-click on pinned cards.

# Set by caller BEFORE add_child. After _ready() this is immutable for the widget lifetime.
var instance_id: String = ""

var _state: String = STATE_DEFAULT
var _is_in_drawer: bool = false   # true when rendered in EvidenceInventoryDrawer; false when on pin_layer.
```

- **Given** an `EvidenceCard` with `instance_id` set to a known evidence, **when** `_ready()` completes, **then** the polaroid frame, caption (`display_name` via tr key), source-actual subtext, and (if `seized == true`) a static Seized badge are all rendered. The `cage_planted` flag is NEVER read or rendered.
- **Given** an `EvidenceCard` with `instance_id` referencing an unknown evidence, **when** `_ready()` runs, **then** the card renders an "Unknown evidence" placeholder body + a `Logger.warn("investigation", "EvidenceCard: unknown instance_id '%s'" % instance_id)`. The card does NOT crash and does NOT emit signals.
- **Given** the player mouse-clicks a card in the drawer (`_is_in_drawer == true`), **when** the click completes, **then** `card_picked_up.emit(instance_id)` fires and the state transitions to `STATE_ARMED_SOURCE`.
- **Given** the player drags a card and releases on the pin_layer, **when** drop is accepted, **then** `card_placement_committed.emit(instance_id, drop_x, drop_y)` fires.
- **Given** the player right-clicks a pinned card (`_is_in_drawer == false`), **when** the click completes, **then** `card_unpin_requested.emit(instance_id)` fires.
- **Given** an EvidenceCard, **when** it is keyboard-focused via Tab, **then** `STATE_HOVER` engages (visual outline change).
- **Given** an instance with `seized == true`, **when** the card renders, **then** a static Seized badge child node is visible. The badge uses `tokens.token("color.board.stamp.seized")`. No animation in 5.2.

Unit tests (`tests/unit/test_evidence_card.gd`): `test_evidence_card_renders_display_name_from_tr_key`; `test_evidence_card_renders_seized_badge_when_seized_true`; `test_evidence_card_no_seized_badge_when_seized_false`; `test_evidence_card_unknown_instance_id_renders_placeholder_and_warns`; `test_evidence_card_drawer_click_emits_picked_up_and_arms`; `test_evidence_card_drag_drop_emits_placement_committed`; `test_evidence_card_right_click_pinned_emits_unpin_requested`; `test_evidence_card_does_not_call_get_instance` (parse the widget file's source text — assert literal substring `"EvidenceInventory.get_instance("` does NOT appear; substring `"EvidenceInventory.get_instance_for_ui("` MUST appear); `test_evidence_card_does_not_call_is_cage_planted` (same parser check).

---

**AC3 — `EvidenceInventoryDrawer` widget at `src/ui/components/evidence_inventory_drawer.gd`.**

```gdscript
class_name EvidenceInventoryDrawer extends Control

## Story 5.2 — Right-side panel on the Physical Board. Lists every un-pinned evidence
## instance as a small EvidenceCard. Drag-source AND click-source-then-target source.
##
## Refreshes on:
##   - _ready (initial mount).
##   - PhysicalBoardController calling refresh() after every pin / unpin.

signal row_picked_up(instance_id: String)

var _card_widgets: Dictionary = {}    # {instance_id: EvidenceCard}


func refresh() -> void:
    ## Tears down + re-builds the row list from EvidenceInventory.all_instance_ids()
    ## minus PhysicalBoardState.all_pinned_ids().
    ## Hot path is called on every pin/unpin — keep cheap (no preload re-instancing of
    ## scenes between calls; reuse the SCENE preload const but instantiate per row).
    ...
```

- **Given** `EvidenceInventory.all_instance_ids()` returns 5 ids AND 2 are pinned, **when** `refresh()` runs, **then** the drawer renders exactly 3 rows (`5 - 2`).
- **Given** an empty inventory, **when** the drawer renders, **then** the drawer is empty (no rows) and the controller's empty-state note handles the "Nothing pinned" surface (the drawer itself does not show its own "empty" text — the controller's empty-state is the single canonical surface).
- **Given** the player clicks a drawer row, **when** the click is processed, **then** `row_picked_up.emit(instance_id)` fires (the drawer relays the underlying EvidenceCard's `card_picked_up` signal).
- **Given** the drawer is keyboard-focused, **when** Tab cycles, **then** each row is focusable in `EvidenceInventory.all_instance_ids()` order (which mirrors `RPGCore.evidence_inventory.keys()` Dictionary insertion order — Godot 4.3 preserves insertion order per the GDScript reference).

Unit tests (`tests/unit/test_evidence_inventory_drawer.gd`): `test_drawer_renders_only_unpinned_instances`; `test_drawer_renders_empty_when_all_pinned`; `test_drawer_renders_empty_when_zero_inventory`; `test_drawer_row_click_emits_row_picked_up`; `test_drawer_refresh_idempotent` (call refresh twice; assert child count and row order unchanged); `test_drawer_row_order_matches_inventory_insertion_order`.

---

**AC4 — Empty-state note: "Nothing pinned yet." (UX line 1095).**

- The empty-state Label is a child of `PhysicalBoardController` at `$EmptyStateNote`. Text key: `"ui.board.empty_state"`. Visible only when `PhysicalBoardState.count() == 0` AND `EvidenceInventory.all_instance_ids().size() == 0`.
- Font: `tokens.token("font.size.board.empty_state")` = `24` (typewriter / handwritten — Resistance-side). Color: `tokens.token("color.board.empty_state_ink")`.

- **Given** zero pinned AND zero inventoried, **when** the board mounts, **then** `$EmptyStateNote.visible == true`.
- **Given** zero pinned AND ONE inventory item (un-pinned), **when** the board mounts, **then** `$EmptyStateNote.visible == false` (the drawer shows a row; the canonical "empty" state is "no evidence at all").
- **Given** the player pins the first card, **when** the pin commits, **then** `$EmptyStateNote.visible == false`.
- **Given** the player unpins the last card AND inventory is empty AFTER the unpin (since the unpinned card moves to the drawer), **then** `$EmptyStateNote.visible` is recomputed correctly — pinned=0 + inventory=1 → still false. The empty-state surface fires ONLY when *no* evidence exists anywhere.

Unit test (in `tests/unit/test_physical_board_controller.gd`): `test_empty_state_visibility_truth_table` (4 cases: pinned=0+inv=0 → true; pinned=0+inv=1 → false; pinned=1+inv=0 → false; pinned=1+inv=1 → false).

---

**AC5 — Pin-position INSTANCE schema (the Dictionary shape stored in `RPGCore.board_pinned_positions`).**

Each entry is a `Dictionary` (not a Resource — mirrors `queued_feed_segments` / `evidence_inventory` Story 5.1 pattern). **Locked schema** — `PhysicalBoardState.pin` is the SOLE writer of new entries; `.move` mutates existing; `.unpin` removes; `.prune_unknown_instances` removes orphans.

```gdscript
# Locked schema (Story 5.2):
{
    "x":          int,    # pixel x within the pin_layer Control, >= 0 and <= pin_layer.size.x
    "y":          int,    # pixel y within the pin_layer Control, >= 0 and <= pin_layer.size.y
    "pinned_at_minutes": int,  # WorldClock snapshot at pin time; informational only (no UI surfaces it in 5.2)
}
```

The key (Dictionary outer key) is the evidence `instance_id` (the `evi_<8hex>` string from Story 5.1). One pin per instance — pinning an already-pinned instance is treated as a `move` (locked behavior; PhysicalBoardState.pin internally dispatches to move if already pinned).

- **Given** a brand-new save, **when** `RPGCore.board_pinned_positions` is read, **then** it returns an empty `Dictionary`.
- **Given** `PhysicalBoardState.pin("evi_12345678", 400, 200)` is called, **then** a new entry is added; `RPGCore.board_pinned_positions.size()` increases by 1; the entry has all 3 schema keys with the locked types.
- **Given** `PhysicalBoardState.pin("evi_12345678", 100, 200)` is called for an instance that is ALREADY pinned at (400, 200), **then** the existing entry's `x`/`y` are updated to (100, 200) and `pinned_at_minutes` is **NOT** updated (the original pin time is preserved — `move` does not bump it).
- **Given** `PhysicalBoardState.pin("evi_00000000", 400, 200)` is called with an instance_id NOT in `RPGCore.evidence_inventory`, **then** `Logger.error("investigation", "pin rejected: unknown instance_id '%s'" % instance_id)` fires AND no entry is added AND `pin()` returns false.
- **Given** `PhysicalBoardState.pin("evi_12345678", -10, 200)` is called with negative coordinates, **then** `Logger.error` fires AND `pin()` returns false (coordinates clamped to `>= 0` before write).
- **Given** an instance was pinned, **when** `PhysicalBoardState.unpin(instance_id)` runs, **then** the entry is erased from `RPGCore.board_pinned_positions` and `unpin()` returns true. Unpinning an un-pinned instance returns false silently (no warn).
- **Given** a `Dictionary` returned from `position_of(instance_id)`, **when** the caller mutates it, **then** the underlying `RPGCore.board_pinned_positions` is **NOT** mutated (deep-copy isolation via `duplicate(true)` in the getter — mirrors `EvidenceInventory.get_instance` line 48 of 5.1).

Unit tests (`tests/unit/test_physical_board_state.gd`): `test_pin_creates_entry_with_three_keys`; `test_pin_rejects_unknown_instance_id_with_error`; `test_pin_rejects_negative_coordinates_with_error`; `test_pin_existing_instance_dispatches_to_move`; `test_move_updates_xy_preserves_pinned_at_minutes`; `test_unpin_removes_entry_returns_true`; `test_unpin_unknown_returns_false_silent`; `test_position_of_returns_empty_dict_for_unpinned`; `test_position_of_returns_deep_copy`; `test_is_pinned_true_false`; `test_count_returns_dict_size`; `test_all_pinned_ids_returns_keys_array`; `test_prune_unknown_instances_drops_orphans_returns_count`.

---

**AC6 — RPGCore extension: `board_pinned_positions` var (no EventBus subscriber).**

Extend `src/core/autoloads/rpg_core.gd`:

```gdscript
# ── Board pinned positions (Story 5.2) ────────────────────────────────────────
# instance_id (String) → Dictionary (schema: x, y, pinned_at_minutes per
# PhysicalBoardState's locked schema). Sole writers: PhysicalBoardState.pin /
# .move / .unpin / .prune_unknown_instances. RPGCore exposes the storage var;
# mutations go through the static helper. Persisted by SaveSystem.save_to_slot /
# restored by _apply_save_to_rpgcore (mirrors evidence_inventory wiring from 5.1).
var board_pinned_positions: Dictionary = {}
```

**No `_ready()` subscriber wiring for Story 5.2** — the board's open/close lifecycle is driven by `EventBus.hud_screen_requested`, which the apartment scene (not RPGCore) consumes. RPGCore stays a pure storage role here. **Do not connect any signal in RPGCore for 5.2.**

- **Given** a fresh RPGCore, **when** `_ready()` completes, **then** `RPGCore.board_pinned_positions` is `{}` and **no new** `EventBus` connections are added (verified by snapshot: `EventBus.hud_screen_requested.get_connections().size()` unchanged from pre-5.2 baseline).
- **Given** RPGCore is reset (test-only `reset_for_test` if it exists, else manual `RPGCore.board_pinned_positions = {}`), **when** read, **then** the Dictionary is empty.

Unit tests (`tests/unit/test_rpg_core_board_pinned_positions.gd`): `test_rpg_core_default_board_pinned_positions_empty`; `test_rpg_core_does_not_add_eventbus_subscriber_for_5_2` (the negative assertion — verifies no `hud_screen_requested.connect(...)` call appears in `rpg_core.gd` source).

---

**AC7 — SaveGameV1 schema extension + migrate_from + validate_and_clamp.**

Extend `src/core/save/save_game_v1.gd`:

1. Add the field (after the evidence_inventory block at line 87, before captured-state block at line 89):

```gdscript
# Investigation board (Story 5.2, FR4).
# Dictionary keyed by evidence instance_id (String, format "evi_<8hex>" from Story 5.1).
# Values are Dictionaries with the locked PhysicalBoardState schema (x, y, pinned_at_minutes).
# Orphan pins (instance_id not in evidence_inventory) are dropped by validate_and_clamp +
# defense-in-depth pruned by SaveSystem on load.
@export var board_pinned_positions: Dictionary = {}
```

2. Append `"board_pinned_positions"` to the property-allowlist Array in `migrate_from()` (last entry, after `"evidence_inventory"` at line 143).

3. Add the validate_and_clamp block (mirror the `evidence_inventory` pattern at lines 533–589 of 5.1 spec — same structure but with the 5.2 schema):

```gdscript
# Story 5.2 — board_pinned_positions Dictionary clamps.
# Requires the evidence_inventory clamp ABOVE this block to have already run, so
# orphan-instance pruning can reference the post-clamp inventory state.
if save.board_pinned_positions == null or typeof(save.board_pinned_positions) != TYPE_DICTIONARY:
    push_warning("validate_and_clamp: board_pinned_positions had unexpected type %d; coerced to {}." % typeof(save.board_pinned_positions))
    save.board_pinned_positions = {}
else:
    var kept_pins: Dictionary = {}
    var pins_changed := false
    for k in save.board_pinned_positions.keys():
        var entry = save.board_pinned_positions[k]
        if typeof(k) != TYPE_STRING:
            push_warning("validate_and_clamp: dropping non-String board_pinned_positions key (type=%d)." % typeof(k))
            pins_changed = true
            continue
        if typeof(entry) != TYPE_DICTIONARY:
            push_warning("validate_and_clamp: dropping non-Dictionary board_pinned_positions['%s'] (type=%d)." % [k, typeof(entry)])
            pins_changed = true
            continue
        if not save.evidence_inventory.has(k):
            push_warning("validate_and_clamp: dropping board_pinned_positions['%s'] — instance not in (clamped) evidence_inventory." % k)
            pins_changed = true
            continue
        var x = entry.get("x", null)
        var y = entry.get("y", null)
        var pinned_at = entry.get("pinned_at_minutes", null)
        if typeof(x) == TYPE_FLOAT:
            x = int(x)
            pins_changed = true
        if typeof(y) == TYPE_FLOAT:
            y = int(y)
            pins_changed = true
        if typeof(pinned_at) == TYPE_FLOAT:
            pinned_at = int(pinned_at)
            pins_changed = true
        if typeof(x) != TYPE_INT or x < 0:
            push_warning("validate_and_clamp: dropping board_pinned_positions['%s'] with invalid x (%s)." % [k, str(x)])
            pins_changed = true
            continue
        if typeof(y) != TYPE_INT or y < 0:
            push_warning("validate_and_clamp: dropping board_pinned_positions['%s'] with invalid y (%s)." % [k, str(y)])
            pins_changed = true
            continue
        if typeof(pinned_at) != TYPE_INT or pinned_at < 0:
            push_warning("validate_and_clamp: board_pinned_positions['%s'] had invalid pinned_at_minutes (%s); coerced to 0." % [k, str(pinned_at)])
            pinned_at = 0
            pins_changed = true
        kept_pins[k] = {
            "x":                  x,
            "y":                  y,
            "pinned_at_minutes":  pinned_at,
        }
    if pins_changed:
        save.board_pinned_positions = kept_pins
```

**Ordering constraint**: this block MUST run AFTER the evidence_inventory clamp (lines 533–589 in 5.1) so the orphan-pruning check `save.evidence_inventory.has(k)` reads the post-clamp inventory state. Place the block IMMEDIATELY after the evidence_inventory clamp.

- **Given** a SaveGameV1 with `board_pinned_positions = null`, **when** `validate_and_clamp` runs, **then** the field is coerced to `{}` with a `push_warning`.
- **Given** a pin entry whose `instance_id` (key) is not in the post-clamp `evidence_inventory`, **when** clamp runs, **then** the pin is dropped with a `push_warning` (orphan pruning — defense in depth, since UI should never produce this state but post-migration legacy saves might).
- **Given** an entry with `x = 5.0` (float — possible from .tres text serialization), **when** clamp runs, **then** the float coerces to int 5 and the entry is kept.
- **Given** an entry missing `pinned_at_minutes` (legacy save), **when** clamp runs, **then** the field defaults to 0 and the entry is kept.
- **Given** a SaveGameV1 with a foreign-Resource shape that has a `board_pinned_positions` property, **when** `migrate_from(prev)` runs, **then** the field is copied through (the property-allowlist branch at lines 122–143 picks it up).

Unit tests (`tests/unit/test_save_game_v1_board.gd`): `test_save_v1_board_pinned_positions_default_empty`; `test_save_v1_migrate_from_board_pinned_preserved`; `test_save_v1_migrate_from_legacy_missing_board_field_defaults_empty`; `test_validate_and_clamp_board_null_coerces_empty`; `test_validate_and_clamp_board_non_dict_coerces_empty`; `test_validate_and_clamp_board_drops_orphan_pin`; `test_validate_and_clamp_board_drops_negative_x`; `test_validate_and_clamp_board_drops_negative_y`; `test_validate_and_clamp_board_coerces_float_x_to_int`; `test_validate_and_clamp_board_coerces_missing_pinned_at_to_zero`; `test_validate_and_clamp_board_preserves_well_formed_entry_exact_shape`; `test_validate_and_clamp_board_runs_after_evidence_inventory_clamp` (build a save with 1 evidence + 1 orphan pin; assert pin is dropped — proves ordering).

---

**AC8 — SaveSystem round-trip + apartment wiring.**

**Part A — SaveSystem (`src/core/autoloads/save_system.gd`):**

- In the save-build path: `save.board_pinned_positions = RPGCore.board_pinned_positions.duplicate(true)` (immediately after the existing `save.evidence_inventory = RPGCore.evidence_inventory.duplicate(true)` line from Story 5.1).
- In the canonical load handler (`_apply_save_to_rpgcore` or whatever the 5.1 evidence_inventory line lives in): `RPGCore.board_pinned_positions = save.board_pinned_positions.duplicate(true)` (immediately after the evidence_inventory load line). Then call `PhysicalBoardState.prune_unknown_instances()` as the LAST step in the load handler (after both inventory + pins are written) so any orphan pins (e.g., from a partial-corruption case where validate_and_clamp missed an edge) are defensively cleaned at load time.

**Part B — Apartment wiring (`src/scenes/apartment.gd`):**

1. Add the preload const (next to the existing `EQUIPMENT_SCREEN_SCENE` at line 68):
   ```gdscript
   const PHYSICAL_BOARD_SCENE: PackedScene = preload("res://src/investigation/physical_board.tscn")
   ```
2. Add the active-instance tracker (next to `_active_equipment_screen` at line 70):
   ```gdscript
   var _active_board: Control = null
   ```
3. Extend `_on_hud_screen_requested` (lines 123–134) with a second branch — DO NOT replace the inventory branch:
   ```gdscript
   func _on_hud_screen_requested(screen_id: String) -> void:
       if screen_id == "inventory":
           ... (existing 4.5 wiring)
           return
       if screen_id == "evidence_board":
           if is_instance_valid(_active_board):
               Logger.debug("ui", "apartment: physical board already mounted — ignoring duplicate request")
               return
           var board := PHYSICAL_BOARD_SCENE.instantiate()
           board.theme_variant = "resistance"
           _active_board = board
           board.tree_exited.connect(_on_board_closed)
           add_child(board)
           return
   ```
4. Add the close handler:
   ```gdscript
   func _on_board_closed() -> void:
       _active_board = null
   ```
5. **Corkboard interaction zone** — at the end of `_build_room()` (line 107), instantiate an `Area2D` child with a `CollisionShape2D` (RectangleShape2D 32×32) positioned at the corkboard cell `(col=16, row=2)` global pixel position. Wire the `Area2D.body_entered` / `body_exited` signals to track player overlap. Subscribe to the existing `interact` action — in `_unhandled_input`, after the existing `ui_open_settings` branch (line 141–144), add:
   ```gdscript
   if event.is_action_pressed(&"interact") and _player_overlapping_corkboard:
       EventBus.hud_screen_requested.emit("evidence_board")
       get_viewport().set_input_as_handled()
       return
   ```
6. Add `var _player_overlapping_corkboard: bool = false` and the signal handlers `_on_corkboard_body_entered(body) -> void` / `_on_corkboard_body_exited(body) -> void` that toggle the flag based on whether the entering/exiting body equals `_player`.

- **Given** a fresh RPGCore with `PhysicalBoardState.pin("evi_12345678", 100, 200)`, **when** `SaveSystem.save_to_slot(0, ...)` runs and then `SaveSystem.load_from_slot(0, ...)` runs, **then** `RPGCore.board_pinned_positions["evi_12345678"]` round-trips with identical content (same x, y, pinned_at_minutes, exact Dictionary shape).
- **Given** the loaded save, **when** the runtime mutates a pin's `x` value via direct dictionary write, **then** the on-disk SaveGameV1 resource is not mutated (deep-copy isolation).
- **Given** the player walks the apartment Player onto the corkboard Area2D AND presses Interact (E), **then** `EventBus.hud_screen_requested.emit("evidence_board")` fires AND the `PhysicalBoardController` scene mounts as an Apartment child.
- **Given** the board is already open AND the player triggers `hud_screen_requested("evidence_board")` a second time, **then** `_active_board` is detected as valid, a `Logger.debug` line fires, and a duplicate mount is suppressed (idempotent reentry).
- **Given** the player closes the board (Esc), **then** `_active_board` is cleared via `tree_exited` and the next interact press can re-open it.
- **Given** OnDemandHUDDispatcher's `open_board` action (KEY_B) fires from anywhere in the apartment (no corkboard overlap required), **then** the apartment's `_on_hud_screen_requested("evidence_board")` handler still mounts the board — the global hotkey works AND the local interact gesture works (two paths, one outcome).

Integration tests:
- `tests/integration/test_physical_board_pin_persist_arc.gd`:
  - `test_pin_save_reload_pin_persists` — instantiate RPGCore + 1 evidence + 1 pin; save; clear RPGCore.board_pinned_positions; load; assert pin restored with exact x/y.
  - `test_loaded_board_pinned_positions_is_deep_copy_isolated_from_save`.
  - `test_load_prunes_orphan_pin_when_inventory_dropped_by_clamp` — build a save with 1 evidence + 1 pin pointing to a *different* (invalid) instance_id; assert post-load that `RPGCore.board_pinned_positions` is empty.
- `tests/integration/test_apartment_corkboard_open_arc.gd`:
  - `test_apartment_hud_screen_requested_evidence_board_mounts_scene`.
  - `test_apartment_idempotent_open_request_ignored_if_already_mounted`.
  - `test_apartment_close_re_opens_cleanly`.
  - `test_apartment_open_board_key_b_routes_through_hud_dispatcher`.

---

**AC9 — ThemeTokens additions (`src/ui/theme/tokens.gd`).**

Add the following keys to `ThemeTokens.DEFAULTS` (after the Story 4.5 block ending at line 58):

```gdscript
# Story 5.2 — Physical Board tokens (UX-DR30 / UX-DR60 / UX-DR125).
# Two theme variants live side-by-side: keys ending in .xyoner / .resistance.
"color.board.surface.resistance":   Color(0.42, 0.30, 0.20, 1.0),  # warm corkboard brown
"color.board.surface.xyoner":       Color(0.92, 0.93, 0.96, 1.0),  # War Room sleek (placeholder, post-VS)
"color.board.card.paper.resistance": Color(0.96, 0.94, 0.85, 1.0),  # off-white polaroid paper
"color.board.card.paper.xyoner":     Color(0.98, 0.98, 1.00, 1.0),  # near-white (post-VS placeholder)
"color.board.card.frame":           Color(0.20, 0.18, 0.16, 1.0),  # dark frame edge, shared across themes
"color.board.pin.red":              Color(0.85, 0.18, 0.15, 1.0),  # classic corkboard pin head
"color.board.stamp.seized":         Color(0.55, 0.55, 0.55, 0.85),  # muted grey "SEIZED" overprint
"color.board.empty_state_ink":      Color(0.92, 0.88, 0.78, 1.0),  # handwritten cream over corkboard
"color.board.card.armed_outline":   Color(0.40, 0.85, 0.55, 1.0),  # UX-DR107 armed-source highlight (shares the 4.5 armed colour for cross-screen affordance consistency)
"color.board.card.hover_outline":   Color(0.95, 0.85, 0.55, 1.0),  # focused/hover (matches 4.5 focus colour)
"spacing.board.card_size":           96,  # px — polaroid square card edge
"spacing.board.pin_layer_padding":   24,
"font.size.board.empty_state":       24,
"font.size.board.card_caption":      12,
"font.size.board.card_source":       10,
"duration.board.card_focus_in":      0.08,  # match 4.5 equipment focus-in
```

- **Given** any of the 16 new keys, **when** `ThemeTokens.token(key)` is called, **then** the corresponding value is returned (NOT `Color.MAGENTA`, which is the "unknown key" sentinel per line 65).
- **Given** the BootCheck's token-presence assertion (AC11), **when** boot runs, **then** all 16 keys resolve without `Logger.error`.

Unit test (`tests/unit/test_theme_tokens.gd` — extend existing): `test_board_tokens_present_no_magenta` (iterate the 16 keys, assert returned values are not `Color.MAGENTA`); `test_board_tokens_resistance_and_xyoner_both_authored` (assert both variant keys exist for the two split keys: `surface` and `card.paper`).

---

**AC10 — Homebase-stage capacity scaling + Stage 4 stub.**

**Part A — Balance extension (`src/core/balance/balance_resource.gd`):**

Add a new top-level `investigation` Dictionary export (after `dossier` at line 538 — alphabetical-ish keep with other top-level dicts):

```gdscript
## Story 5.2 — Investigation board tunables (FR4; GDD §"Layer 1 — Physical Board" lines 436–442).
##
##   board_visible_capacity_by_stage: maps homebase_stage int → visible-card capacity int.
##     The board does NOT enforce a hard cap (pinning above this count is allowed and the
##     ScrollContainer simply scrolls). The capacity hint Label uses this for the
##     `n/cap` display so the player has a soft signal that the board is "filling up."
##     VS-locked from GDD line 442: Stage 1 ≈ 30 items; Stage 4 = 200 (distributed-cells flat
##     view; the per-cell subboard switcher is Story 8.6 scope).
##   board_nudge_step_px: pixels-per-keystroke for arrow-key card nudging (UX-DR107
##     keyboard alt). 8 = matches the 32px tile alignment grid divided by 4 — easy to land
##     near tile centers without snapping.
@export var investigation: Dictionary = {
    "board_visible_capacity_by_stage": {1: 30, 2: 60, 3: 100, 4: 200},
    "board_nudge_step_px": 8,
}
```

**Part B — balance.tres** — append `investigation = {"board_visible_capacity_by_stage": {1: 30, 2: 60, 3: 100, 4: 200}, "board_nudge_step_px": 8}` as a new resource-property line (mirror the on-disk .tres encoding of the other Dictionary properties).

**Part C — PhysicalBoardController reads:**

```gdscript
const STAGE_4_DEFERRAL_LOG: String = "physical_board: stage 4 detected — distributed-cells subboard switcher deferred to Story 8.6"

func _resolve_visible_capacity() -> int:
    var caps: Dictionary = Balance.investigation.get("board_visible_capacity_by_stage", {})
    var stage: int = RPGCore.homebase_stage  # clamped 1..4 by Save validate_and_clamp
    return int(caps.get(stage, caps.get(1, 30)))   # fallback to Stage 1 if missing — defensive
```

The `_stage_capacity_hint` Label renders `"%d / %d" % [PhysicalBoardState.count(), _resolve_visible_capacity()]`. If `count() > capacity`, the Label text color shifts to `tokens.token("color.overdue_marker")` (the existing red-warn color from 2.5 — reused for "you're over visible budget").

- **Given** `RPGCore.homebase_stage == 1`, **when** the controller mounts, **then** `_resolve_visible_capacity()` returns 30.
- **Given** `RPGCore.homebase_stage == 4`, **when** the controller mounts, **then** `_resolve_visible_capacity()` returns 200 AND the Stage-4 deferral Logger.info fires exactly once.
- **Given** 31 pinned cards at Stage 1, **when** the capacity hint renders, **then** the Label color is `color.overdue_marker`.
- **Given** the player exceeds capacity, **then** pinning still succeeds (no hard cap in 5.2 — visible signal only).

Unit tests (added to `test_physical_board_controller.gd`): `test_resolve_visible_capacity_stage_1`; `test_resolve_visible_capacity_stage_4`; `test_capacity_hint_text_format`; `test_capacity_hint_overcapacity_color_shift`. Plus `tests/unit/test_balance_invariants.gd` extension: `test_balance_investigation_section_present`; `test_board_visible_capacity_by_stage_keyed_1_to_4_monotonic_ascending` (assert keys are exactly {1,2,3,4} AND values strictly ascend).

---

**AC11 — BootCheck wiring + EventBus signal-count regression test + class cache entries.**

1. **BootCheck token-presence assertion** (extend `src/scenes/boot_check.gd`). Add a list of the 16 new tokens and iterate, asserting `ThemeTokens.token(key) != Color.MAGENTA` for color keys (skip the `spacing.*` / `font.size.*` / `duration.*` keys — those are non-Color types where MAGENTA isn't the sentinel; for those, just call `.token(key)` and rely on `Logger.error` to fire if missing). Place the block after the existing `EvidenceCatalog.validate()` call from Story 5.1 (line 16-ish per the 5.1 spec).

2. **EventBus signal-count regression** (extend `tests/unit/test_no_new_eventbus_signals.gd`). Add a new assertion immediately after the Story 5.1 `test_no_new_signals_added_in_5_1` block:

   ```gdscript
   func test_no_new_signals_added_in_5_2() -> void:
       ## Story 5.2 adds ZERO new EventBus signals — reuses hud_screen_requested (Story 1.12)
       ## for the open trigger; connection_drawn (line 187) stays reserved for Story 5.3.
       ## Baseline unchanged: 68.
       var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
       assert_not_null(file, "event_bus.gd must be readable")
       var src_text: String = file.get_as_text()
       file.close()
       var signal_count: int = 0
       for line in src_text.split("\n"):
           if line.strip_edges().begins_with("signal "):
               signal_count += 1
       assert_eq(signal_count, 68,
           "Story 5.2 must NOT add new EventBus signals (reuses hud_screen_requested). Baseline 68 post-5.1.")
   ```

3. **Pre-emptive class entries** in `.godot/global_script_class_cache.cfg` for the 4 new `class_name` declarations: `PhysicalBoardController`, `PhysicalBoardState`, `EvidenceCard`, `EvidenceInventoryDrawer`. Mirror the existing entries for Story 5.1's `EvidenceDefinition` / `EvidenceCatalog` / `EvidenceInventory` blocks (find the 5.1-added entries and clone the pattern).

- **Given** the boot scene runs, **when** `_ready()` completes, **then** Logger shows the new token-presence-check line firing with zero errors (assuming all 16 keys are authored).
- **Given** the GUT suite runs headlessly via `godot.exe _console`, **when** the suite resolves any of the 4 new `class_name`s for the first time, **then** the class is found (cache entry pre-emptively added).
- **Given** the EventBus baseline is 68, **when** `test_no_new_signals_added_in_5_2` runs, **then** the assertion passes.

---

## Tasks / Subtasks

- [x] Task 1: Scaffold `src/investigation/board/` + new widget files (AC1, AC2, AC3)
  - [x] 1.1 Create `src/investigation/board/physical_board_state.gd` (class_name PhysicalBoardState) per AC5
  - [x] 1.2 Create `src/investigation/physical_board.gd` (class_name PhysicalBoardController) per AC1
  - [x] 1.3 Create `src/investigation/physical_board.tscn` with the locked child layout (Background, Header, ScrollContainer→pin_layer, InventoryDrawer, EmptyStateNote, StageCapacityHint)
  - [x] 1.4 Create `src/ui/components/evidence_card.gd` (class_name EvidenceCard) + `.tscn` per AC2
  - [x] 1.5 Create `src/ui/components/evidence_inventory_drawer.gd` (class_name EvidenceInventoryDrawer) + `.tscn` per AC3
  - [x] 1.6 Add 4 entries to `.godot/global_script_class_cache.cfg` (mirror the 5.1 EvidenceDefinition/EvidenceCatalog/EvidenceInventory block)

- [x] Task 2: ThemeTokens authoring + balance extension (AC9, AC10)
  - [x] 2.1 Append the 16 board tokens to `src/ui/theme/tokens.gd` `DEFAULTS` per AC9
  - [x] 2.2 Add `@export var investigation: Dictionary` to `src/core/balance/balance_resource.gd` per AC10 Part A
  - [x] 2.3 Add the matching `investigation = {...}` line to `src/core/balance/balance.tres` per AC10 Part B
  - [x] 2.4 Wire `_resolve_visible_capacity` + `_stage_capacity_hint` Label in `PhysicalBoardController` per AC10 Part C

- [x] Task 3: Extend RPGCore with `board_pinned_positions` var (AC6)
  - [x] 3.1 Add `var board_pinned_positions: Dictionary = {}` to `src/core/autoloads/rpg_core.gd` (after `evidence_inventory` from 5.1)
  - [x] 3.2 **Do NOT** add any `_ready()` subscriber for 5.2 — verify no `hud_screen_requested.connect` line exists in rpg_core.gd

- [x] Task 4: Extend SaveGameV1 schema + migrate + clamp (AC7)
  - [x] 4.1 Add `@export var board_pinned_positions: Dictionary = {}` to `src/core/save/save_game_v1.gd` (after `evidence_inventory` at line 87)
  - [x] 4.2 Append `"board_pinned_positions"` to the migrate_from property-allowlist Array (after `"evidence_inventory"` at line 143)
  - [x] 4.3 Add the board_pinned_positions clamp block to `validate_and_clamp` IMMEDIATELY after the evidence_inventory clamp (so the orphan-prune check reads the post-clamp inventory)

- [x] Task 5: Wire SaveSystem round-trip + apartment scene (AC8)
  - [x] 5.1 Save path: `save.board_pinned_positions = RPGCore.board_pinned_positions.duplicate(true)` (after the 5.1 evidence_inventory save line)
  - [x] 5.2 Load path: `RPGCore.board_pinned_positions = save.board_pinned_positions.duplicate(true)` (after the 5.1 evidence_inventory load line)
  - [x] 5.3 Append `PhysicalBoardState.prune_unknown_instances()` as the LAST step in the load handler
  - [x] 5.4 Add `PHYSICAL_BOARD_SCENE` preload const + `_active_board` var + the second branch in `_on_hud_screen_requested` + the `_on_board_closed` handler in `src/scenes/apartment.gd`
  - [x] 5.5 Add the corkboard Area2D + CollisionShape2D programmatic instantiation in `_build_room()` at cell (col=16, row=2)
  - [x] 5.6 Wire `_player_overlapping_corkboard` + body_entered/body_exited handlers + the `interact` action branch in `_unhandled_input`
  - [x] 5.7 Add the `# TODO Epic A Story a-6` comment marking the placeholder corkboard tile sprite

- [x] Task 6: Boot wiring + EventBus regression (AC11)
  - [x] 6.1 Extend `src/scenes/boot_check.gd` with the token-presence assertion for the 16 new keys (after Story 5.1's `EvidenceCatalog.validate()` line)
  - [x] 6.2 Add `test_no_new_signals_added_in_5_2` to `tests/unit/test_no_new_eventbus_signals.gd` per AC11

- [x] Task 7: Unit tests for all new modules (AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC9, AC10)
  - [x] 7.1 `tests/unit/test_physical_board_state.gd` per AC5
  - [x] 7.2 `tests/unit/test_evidence_card.gd` per AC2 (includes the FR10 parser-check tests)
  - [x] 7.3 `tests/unit/test_evidence_inventory_drawer.gd` per AC3
  - [x] 7.4 `tests/unit/test_physical_board_controller.gd` per AC1 + AC4 + AC10
  - [x] 7.5 `tests/unit/test_rpg_core_board_pinned_positions.gd` per AC6
  - [x] 7.6 `tests/unit/test_save_game_v1_board.gd` per AC7
  - [x] 7.7 Extend `tests/unit/test_theme_tokens.gd` per AC9 (or create if absent — check for an existing file first)
  - [x] 7.8 Extend `tests/unit/test_balance_invariants.gd` per AC10 (`test_balance_investigation_section_present`, `test_board_visible_capacity_by_stage_keyed_1_to_4_monotonic_ascending`)

- [x] Task 8: Integration tests (AC8)
  - [x] 8.1 `tests/integration/test_physical_board_pin_persist_arc.gd` per AC8 Integration block (pin → save → reload → restored, deep-copy isolation, orphan-prune-on-load)
  - [x] 8.2 `tests/integration/test_apartment_corkboard_open_arc.gd` per AC8 (mount on hud_screen_requested, idempotent reentry, close-then-reopen, KEY_B routing)

- [ ] Task 9: Manual editor sanity check
  - [ ] 9.1 Open `src/investigation/physical_board.tscn` in the Godot inspector — confirm the child layout (Background, Header, ScrollContainer→pin_layer, InventoryDrawer, EmptyStateNote, StageCapacityHint) renders with the locked node names
  - [ ] 9.2 Launch the apartment scene — walk to the corkboard cell (top-right area near col=16, row=2), press E, confirm the board mounts; verify the empty-state note shows "Nothing pinned yet."; verify Esc closes the board and a second E press re-opens it
  - [ ] 9.3 In a debug console (or via a test grant), call `EvidenceInventory.create_instance("passport_scan", "test", "slopside", 100, false)` to seed one evidence; reopen the board; verify the row appears in the drawer; click it; click on the pin_layer; verify the card moves from drawer to pin_layer; close the board; reopen — verify the pin persists
  - [ ] 9.4 Run the full headless GUT suite via the `godot.exe _console` variant at the WinGet path (memory: `reference_godot_binary`) — all new tests pass; existing tests still pass ✅ (1665 tests, 0 failing)

---

## Dev Notes

### Relevant architecture patterns and constraints

- **Scene-as-screen pattern (LOCKED across Stories 2.4 BillsScreen, 4.5 EquipmentScreen, and now 5.2):** the controller is a `Control` (not an autoload, not a Resource), the caller (a gameplay scene) instantiates + sets `theme_variant` BEFORE `add_child`, the controller's `_ready()` wires + refreshes + grabs initial focus, and `close()` queue_frees. Tree-pause behavior is **screen-specific**: settings/save/quit menus DO pause; Investigation suite + Bills do NOT pause (UX rule §6.6 / ux-design-specification.md line 895). 5.2 follows the no-pause rule.
- **Static-module + Dictionary-storage pattern** (LOCKED across Story 4.4 materials, Story 4.4 crafted_inventory, Story 5.1 evidence_inventory, and now 5.2 board_pinned_positions): the helper class (`PhysicalBoardState`) is a static `RefCounted` module with no instance state; storage lives on `RPGCore` as a typed var. The static helper exposes the API; RPGCore exposes the var. SaveGameV1 mirrors the var; SaveSystem ferries between RPGCore and SaveGameV1. **Do not** invent a new `PhysicalBoardState` autoload — that diverges from the materials / crafted_inventory / evidence_inventory pattern and breaks the "12 autoloads" boot constraint (`AUTOLOAD_COUNT := 12` in `src/scenes/boot_check.gd:7`).
- **No new EventBus signals** (LOCKED rule for 5.2). The board's open trigger is `hud_screen_requested(screen_id="evidence_board")` (declared by Story 1.12, line 199 of event_bus.gd, with zero consumers until 5.2). The `connection_drawn` signal at line 187 is RESERVED for Story 5.3 — 5.2 must not emit on it. The `evidence_published` signal at line 50 is RESERVED for Story 5.4. 5.2's pin/unpin/move mutations are observable only via direct read of `RPGCore.board_pinned_positions`; tests assert this directly.
- **FR10 cage_planted contract (LOCKED at Story 5.1):** the `cage_planted` flag MUST be invisible to UI. The split-getter pattern (`EvidenceInventory.get_instance` for backend, `EvidenceInventory.get_instance_for_ui` for UI) is the locked enforcement mechanism. `EvidenceCard` and `EvidenceInventoryDrawer` are UI — they MUST call `get_instance_for_ui` only. AC2's last two test names (`test_evidence_card_does_not_call_get_instance` + `test_evidence_card_does_not_call_is_cage_planted`) are parser-level enforcement tests — they grep the widget source files for forbidden substrings.
- **Cross-cluster forbidden direct call** (arch §4.6, `event_bus.gd:3–6`): `src/scenes/apartment.gd` is a gameplay scene (not strictly a "cluster"), but it must not directly read `src/investigation/*` internal state. The pattern here: apartment subscribes to `hud_screen_requested`, instantiates `PhysicalBoardController` (a public scene root), and that's the entire surface area. Apartment never reaches into `PhysicalBoardState` directly. Tests should verify this by grepping `apartment.gd` for `PhysicalBoardState.` (must NOT appear).
- **Deterministic RNG**: 5.2 does NOT generate ids (instances come from 5.1's `EvidenceInventory.create_instance`). No RNG usage in 5.2 modules.
- **Schema authority**: SaveGameV1 fields ARE the persistence schema (LOCK; arch §3.7 rule 8). RPGCore vars are the in-memory cache layer. Any new persistent collection requires: (a) `@export var` in SaveGameV1, (b) entry in the `migrate_from` allowlist, (c) clamp block in `validate_and_clamp`, (d) save-side ferry in SaveSystem, (e) load-side ferry in SaveSystem. Skipping (b) silently drops the field on legacy saves; skipping (c) admits corrupt data; skipping (d) or (e) means no round-trip. 5.2 hits all five.
- **Clamp ORDERING is load-bearing:** the board_pinned_positions clamp MUST run AFTER the evidence_inventory clamp so the orphan-prune check `save.evidence_inventory.has(k)` reads the *clamped* inventory (a definition_id that gets dropped by the inventory clamp must trigger the corresponding pin to also be dropped). The test `test_validate_and_clamp_board_runs_after_evidence_inventory_clamp` enforces this.
- **Headless-parser class-cache pre-emption** (LOCKED across Stories 4.1–4.5 + 5.1): every new `class_name` must have a pre-emptive entry in `.godot/global_script_class_cache.cfg`. The headless GUT run via `godot.exe _console` (memory: `reference_godot_binary`) does NOT re-scan; missing entries → first reference NPEs at parse time. Find the 5.1-added block for `EvidenceCatalog` and clone its shape for the 4 new 5.2 classes.
- **Drag-drop pattern**: Godot's `_get_drag_data` / `_can_drop_data` / `_drop_data` Control overrides are the canonical drag-drop hook. Story 4.5's `EquipmentSlotWidget` (`src/ui/components/equipment_slot_widget.gd`) is the precedent — clone its drag-handler shape. The drag preview is a duplicate of the dragged EvidenceCard sized down (`Vector2(64, 64)`).
- **Logger conventions**: cluster string is the first arg. Use `"investigation"` as the cluster string for all 5.2 logs. Use `"ui"` for the apartment scene logs (matches Story 4.5).
- **tr() keys**: convention `"ui.board.<surface>"` (`ui.board.empty_state`, `ui.board.title`, `ui.board.close`, `ui.board.capacity_format`). Free-form strings for VS (tr-lint Story 14.4 enforces real keys later).

### Source tree components to touch

- **Create:**
  - `src/investigation/physical_board.gd`
  - `src/investigation/physical_board.tscn`
  - `src/investigation/board/physical_board_state.gd`
  - `src/ui/components/evidence_card.gd`
  - `src/ui/components/evidence_card.tscn`
  - `src/ui/components/evidence_inventory_drawer.gd`
  - `src/ui/components/evidence_inventory_drawer.tscn`
  - `tests/unit/test_physical_board_state.gd`
  - `tests/unit/test_evidence_card.gd`
  - `tests/unit/test_evidence_inventory_drawer.gd`
  - `tests/unit/test_physical_board_controller.gd`
  - `tests/unit/test_rpg_core_board_pinned_positions.gd`
  - `tests/unit/test_save_game_v1_board.gd`
  - `tests/integration/test_physical_board_pin_persist_arc.gd`
  - `tests/integration/test_apartment_corkboard_open_arc.gd`

- **Extend:**
  - `src/core/autoloads/rpg_core.gd` (add var only — no subscriber)
  - `src/core/save/save_game_v1.gd` (add @export, extend migrate_from allowlist, add clamp block in correct order)
  - `src/core/autoloads/save_system.gd` (add save + load wiring + prune_unknown_instances call)
  - `src/scenes/apartment.gd` (preload const, _active_board var, _on_hud_screen_requested branch, corkboard Area2D, interact handler)
  - `src/scenes/apartment.tscn` (no edits expected — Area2D is instantiated programmatically in _build_room; verify no scene-level conflict)
  - `src/ui/theme/tokens.gd` (16 new keys in DEFAULTS)
  - `src/core/balance/balance_resource.gd` (`investigation` Dictionary export)
  - `src/core/balance/balance.tres` (matching resource-property line)
  - `src/scenes/boot_check.gd` (token-presence assertion block)
  - `tests/unit/test_no_new_eventbus_signals.gd` (add `test_no_new_signals_added_in_5_2`)
  - `tests/unit/test_balance_invariants.gd` (add investigation-section tests)
  - `tests/unit/test_theme_tokens.gd` if it exists, else create (verify both .resistance and .xyoner variants for the two split keys)
  - `.godot/global_script_class_cache.cfg` (4 new class entries)

### Testing standards summary

- **Framework**: GUT (Godot Unit Test) — naming `test_*` for methods, `tests/unit/test_<subsystem>.gd` for files. Use `assert_eq`, `assert_true`, `assert_false`, `assert_null`, `assert_not_null` consistent with `tests/unit/test_evidence_inventory.gd` and `tests/unit/test_equipment.gd`.
- **Headless runner**: `godot.exe _console` variant at the WinGet path (per memory `reference_godot_binary`). Plain `godot.exe` is not on PATH on this Windows 11 Home machine.
- **Integration tests** live in `tests/integration/` (parallel to `tests/unit/`). They exercise multi-module flows via the real EventBus + real SaveSystem — never mock RPGCore, never mock EventBus.
- **Scene-mount tests**: `PhysicalBoardController` tests use `add_child_autofree(...)` patterns (see `tests/unit/test_equipment_screen_controller.gd` and `test_equipment_screen_arming.gd` for the exact harness). The test mounts the controller as a child of the GUT test root, awaits `process_frame`, runs assertions, then `tree_exiting` auto-frees.
- **Round-trip tests** mirror `tests/integration/test_save_round_trip_evidence.gd`. Build a SaveGameV1, populate the field, call `SaveSystem.save_to_slot` then `SaveSystem.load_from_slot`, assert field survived AND deep-copy isolation holds.
- **Parser-level FR10 tests**: load the widget source file via `FileAccess.open(...)`, read as text, assert forbidden substrings absent (`"EvidenceInventory.get_instance("` and `"EvidenceInventory.is_cage_planted("`). This is a coarse but durable check — even if a refactor renames functions, the test will fail loudly on the next FR10 violator.
- **Determinism**: no RNG in 5.2 paths, so no `RNG.seed_master` setup needed.

### Project Structure Notes

- The `src/investigation/` directory was populated by Story 5.1 with 4 data files (definition / resource / catalog / inventory). Story 5.2 adds the first UI controller (`physical_board.gd` + `.tscn`) and a new `board/` subdirectory for board-specific state (`physical_board_state.gd`). Future Stories 5.3–5.7 add `connection_draw.gd`, `dossier_interface.gd`, `publication_commit.gd`, `thought_cabinet.gd` under the same root (per arch §4.1 line 405–411).
- The `src/ui/components/` directory hosts shared widgets across screens. `EvidenceCard` lives here (not under `src/investigation/`) because Stories 5.4 (Dossier desk) and 5.5 (Thought Cabinet) also render evidence cards. **Do NOT** colocate `evidence_card.gd` under `src/investigation/` — that would force cross-cluster includes from the Dossier / Thought Cabinet stories.
- The `src/investigation/board/` subdirectory holds board-specific *state modules* (the static helpers). Connection-related state (Story 5.3) will land in `src/investigation/connections/`. Dossier UI state (Story 5.4) in `src/investigation/dossier/`. This is a forward-looking org choice — keeps the top-level `src/investigation/` directory navigable.

### Project Context Rules

- No `project-context.md` was found in the repo. The locked rules that apply to this story are surfaced inline in the Dev Notes / Scope Boundary above and trace back to:
  - `_bmad-output/planning-artifacts/epics.md` §"Story 5.2" (AC source) + §"Architectural Decision Records" (locked rules 4, 6, 8)
  - `_bmad-output/planning-artifacts/ux-design-specification.md` line 895 (no-pause for Investigation), line 928–933 (EvidenceCard widget spec UX-DR30), line 1095 ("Nothing pinned yet." empty-state)
  - `_bmad-output/game-architecture.md` §5.4 (Connection Draw + Publication Commit are the operational thesis — 5.2 is the scaffolding), §4.1 (folder layout)
  - `_bmad-output/gdd.md` §"Layer 1 — The Physical Board" line 436–442 (capacity scales with homebase, Stage 1 ≈ 30 / Stage 4 distributed)
  - `src/core/autoloads/event_bus.gd:3–6` (no bare Dictionary payloads; cross-cluster routing rule)
  - `src/scenes/boot_check.gd:7` (`AUTOLOAD_COUNT := 12` — do not add a new autoload)
  - Memory entry `reference_godot_binary` (use `godot.exe _console` variant for headless GUT)
  - FR10 (cage_planted ambiguity) — UI MUST use `EvidenceInventory.get_instance_for_ui` only (locked at Story 5.1)

### Previous Story Intelligence (Story 5.1 — Evidence System)

- **Pattern reused — Scope Boundary (READ FIRST)**: Story 5.1's IN/OUT scope-lock-in section is the template here. Same explicit-list-of-deferrals format — anything that touches connection drawing, stamp animations, publication, or Awakening reframes is OUT of 5.2.
- **Pattern reused — split-getter for FR10**: `EvidenceInventory.get_instance_for_ui` is the canonical UI surface (5.1 spec line 347–357). All 5.2 widgets (`EvidenceCard`, `EvidenceInventoryDrawer`, `PhysicalBoardController`) use it exclusively. The parser-level test (AC2 last test) enforces this.
- **Pattern reused — clamp pruning of orphan references**: 5.1's `validate_and_clamp` drops evidence entries whose `definition_id` isn't in `EvidenceCatalog` (5.1 spec line 551–553). 5.2's clamp does the parallel: drops pins whose `instance_id` isn't in `evidence_inventory`. The clamp ORDERING is load-bearing — 5.2 clamp runs AFTER 5.1 clamp.
- **Pattern reused — SaveSystem `prune_unknown_instances()` defense-in-depth**: 5.2 adds a load-time call to `PhysicalBoardState.prune_unknown_instances()` after both inventory + pins are restored. This catches edge cases where validate_and_clamp missed an orphan (paranoid layering).
- **Pattern reused — signature signal-count regression test**: 5.1 spec line 661 ("Baseline stays at **68** signals"). Story 5.2 extends with `test_no_new_signals_added_in_5_2` asserting the same count.
- **Pattern reused — "Forbidden:" block in module headers**: 5.1's `EvidenceInventory` header (lines 7–10) and `EvidenceDefinition` header (lines 73–75) effectively prevented dev-agent feature creep. 5.2 mirrors the pattern in `PhysicalBoardController`, `PhysicalBoardState`, `EvidenceCard`, `EvidenceInventoryDrawer` headers.
- **Lesson from 5.1**: the `RNG.stream("evidence")` collision-guard while-loop (5.1 implementation line 141–143) was added during code review. 5.2 doesn't generate ids — uses 5.1's already-issued instance_ids — so no equivalent guard is needed.

### Previous Story Intelligence (Story 4.5 — Equipment / Inventory Screen)

- **Pattern reused — scene-as-screen lifecycle**: 4.5's `EquipmentScreenController` (`src/ui/diegetic/equipment_screen.gd`) is the template for 5.2's `PhysicalBoardController`. Same `theme_variant` field, same `_was_paused_before_open` snapshot pattern (though 5.2 SKIPS the actual pause — per UX rule §6.6), same `close()` queue_free, same `_unhandled_input` ui_cancel.
- **Pattern reused — UX-DR107 armed-state alt to drag**: 4.5's `_armed_crafted_item_id` field and `_clear_all_armed_targets()` helper (line 282–289) is the template for 5.2's `_armed_instance_id`. The visual cue (`color.equipment.slot.armed` color token, green-ish) is mirrored in 5.2 as `color.board.card.armed_outline` — **same value** (`Color(0.40, 0.85, 0.55, 1.0)`) for cross-screen affordance consistency (locked in AC9).
- **Pattern reused — apartment scene mount pattern**: 4.5's `_on_hud_screen_requested("inventory")` branch in `src/scenes/apartment.gd` (lines 123–134) is the template for 5.2's `_on_hud_screen_requested("evidence_board")` branch. The two branches coexist as sibling if-blocks; the dispatcher routes by `screen_id`.
- **Pattern reused — drag-drop pattern from EquipmentSlotWidget**: 4.5's `equipment_slot_widget.gd` uses `_get_drag_data` / `_can_drop_data` / `_drop_data` Control overrides. 5.2's `EvidenceCard` uses the same pattern (locked at AC2 — see the drag-source / drop-target signal contract).
- **Lesson from 4.5 review**: the explicit "Forbidden:" block in `EquipmentScreenController` header (4.5 lines 13–18) was effective. 5.2 mirrors the pattern in `PhysicalBoardController` header (AC1 — see the `Forbidden:` enumeration).
- **Lesson from 4.5 review**: `process_mode = Node.PROCESS_MODE_ALWAYS` ensures the screen stays responsive while the SceneTree is paused. Even though 5.2 does NOT pause the tree, setting `PROCESS_MODE_ALWAYS` is still correct because OTHER systems (settings menu, save/load) might pause the tree above the board, and the board should remain responsive in that case.

### Previous Story Intelligence (Story 1.12 — Persistent Ambient HUD)

- **`hud_screen_requested` is the canonical UI-open dispatch signal.** Story 1.12 declared it; Story 4.5 added the first consumer (`"inventory"` screen_id); Story 5.2 adds the second (`"evidence_board"`). Story 9.x will add `"map"`, Story 7.x will add `"dossier"`, Story 10.x will add `"journal"`. The action→screen_id mapping lives in `OnDemandHUDDispatcher.ACTION_TO_SCREEN` (`src/ui/hud/on_demand_hud_dispatcher.gd:15–22`) and is LOCKED — Story 5.2 does NOT modify it (the mapping `open_board → "evidence_board"` is already authored).

### Git Intelligence Summary

Recent commits show Story 5.1 (Evidence System) just landed (per sprint-status.yaml comment `last_updated: 2026-05-17 (Story 5.1 Evidence System — done after code review patches)`). The 5.1 commits established the `src/investigation/` directory pattern and the static-helper + RPGCore-storage convention. Recent equipment-system commits (4.1–4.5) established the scene-as-screen pattern. Patterns reused above all trace to these landed commits — no migration risk, no new infrastructure choices in 5.2.

### Latest Tech Information

- **Godot 4.3 Control-drag pattern** (unchanged from 4.2 → 4.3): `_get_drag_data(at_position)` returns the drag payload; `_can_drop_data(at_position, data)` returns bool; `_drop_data(at_position, data)` consumes. The drag preview is set via `set_drag_preview(Control)` inside `_get_drag_data`. No breaking changes since 4.2 — 4.5's pattern is safe to clone verbatim.
- **Godot 4.3 `Dictionary` insertion-order preservation**: GDScript 4.3 reference confirms Dictionary preserves insertion order on iteration. This is load-bearing for AC3's `test_drawer_row_order_matches_inventory_insertion_order` — the drawer iterates `EvidenceInventory.all_instance_ids()` which iterates `RPGCore.evidence_inventory.keys()` which iterates in insertion order.

### References

- [Source: `_bmad-output/planning-artifacts/epics.md:1820–1842` — Story 5.2 acceptance criteria]
- [Source: `_bmad-output/planning-artifacts/epics.md:1796–1798` — Epic 5 user outcome]
- [Source: `_bmad-output/planning-artifacts/ux-design-specification.md:735–763` — Journey 2 (Drawing a Connection — the post-5.2 follow-on)]
- [Source: `_bmad-output/planning-artifacts/ux-design-specification.md:872–895` — Journey Patterns + Pause-aware design]
- [Source: `_bmad-output/planning-artifacts/ux-design-specification.md:928–933` — EvidenceCard UX-DR30 spec]
- [Source: `_bmad-output/planning-artifacts/ux-design-specification.md:1095` — Empty-state copy "Nothing pinned yet."]
- [Source: `_bmad-output/game-architecture.md:601–614` — Connection Draw subsystem design (forward-ref; 5.2 sets the stage)]
- [Source: `_bmad-output/game-architecture.md:405–411` — investigation/ folder layout]
- [Source: `_bmad-output/gdd.md:436–442` — Physical Board capacity-scales-with-homebase rule (FR4)]
- [Source: `src/investigation/evidence_inventory.gd:45–61` — `get_instance_for_ui` FR10 contract surface]
- [Source: `src/core/autoloads/event_bus.gd:196–199` — `hud_screen_requested` declaration]
- [Source: `src/ui/hud/on_demand_hud_dispatcher.gd:15–22` — action→screen_id mapping]
- [Source: `src/scenes/apartment.gd:67–138` — Story 4.5 apartment-side `_on_hud_screen_requested` precedent]
- [Source: `src/ui/diegetic/equipment_screen.gd:1–110` — scene-as-screen lifecycle template]
- [Source: `src/core/save/save_game_v1.gd:533–589` — Story 5.1 evidence_inventory validate_and_clamp pattern (5.2 clones)]
- [Source: `_bmad-output/implementation-artifacts/epic-5-investigation-ui/5-1-evidence-system.md` — predecessor story, all 11 ACs are upstream dependencies]

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (1M context)

### Debug Log References

- Fixed `get_viewport().set_input_as_handled()` ordering in `EvidenceCard._gui_input` — emit signals BEFORE calling set_input_as_handled to avoid silent failure in headless test context.
- Used Array-based signal capture instead of String lambdas in GUT tests for reliable signal assertion.
- Fixed `physical_board.tscn` ScrollContainer node declaration (type must be attribute, not property).
- `TranslationServer.has_translation` unavailable in Godot 4.3 — replaced with `tr(key) != key` pattern.

### Completion Notes List

- All 9 tasks completed (Tasks 1–8 fully automated; Task 9.1–9.3 require human verification in editor, 9.4 ✅ confirmed via headless GUT).
- PhysicalBoardController mirrors EquipmentScreenController shape exactly: process_mode=ALWAYS, no tree pause (UX §6.6), theme_variant injection, close() queue_free.
- EvidenceCard FR10 contract enforced at both code level (only calls get_instance_for_ui) and parser-level tests (assert forbidden substrings absent).
- SaveSystem pipeline follows the 5-step schema authority rule: @export, migrate_from allowlist, validate_and_clamp, save ferry, load ferry + prune call.
- board_pinned_positions clamp placed AFTER evidence_inventory clamp (load-bearing ordering for orphan detection).
- Corkboard tile code 16 added to apartment ATLAS_COORDS using window tile Vector2i(3,2) as placeholder per story spec, with TODO comment naming Epic A Story a-6.
- Headless GUT: 1665 tests, 1655 passing, 0 failing, 10 pre-existing risky/pending (unchanged from baseline).

### File List

**Created:**
- `src/investigation/board/physical_board_state.gd`
- `src/investigation/physical_board.gd`
- `src/investigation/physical_board.tscn`
- `src/ui/components/evidence_card.gd`
- `src/ui/components/evidence_card.tscn`
- `src/ui/components/evidence_inventory_drawer.gd`
- `src/ui/components/evidence_inventory_drawer.tscn`
- `tests/unit/test_physical_board_state.gd`
- `tests/unit/test_evidence_card.gd`
- `tests/unit/test_evidence_inventory_drawer.gd`
- `tests/unit/test_physical_board_controller.gd`
- `tests/unit/test_rpg_core_board_pinned_positions.gd`
- `tests/unit/test_save_game_v1_board.gd`
- `tests/integration/test_physical_board_pin_persist_arc.gd`
- `tests/integration/test_apartment_corkboard_open_arc.gd`

**Modified:**
- `src/core/autoloads/rpg_core.gd` — added `var board_pinned_positions: Dictionary = {}`
- `src/core/save/save_game_v1.gd` — added `@export var board_pinned_positions`, extended migrate_from allowlist, added clamp block
- `src/core/autoloads/save_system.gd` — wired save/load paths + prune_unknown_instances call
- `src/scenes/apartment.gd` — added PHYSICAL_BOARD_SCENE const, _active_board var, corkboard tile code 16, corkboard Area2D zone, evidence_board branch in _on_hud_screen_requested, interact handler
- `src/ui/theme/tokens.gd` — added 16 board tokens (10 color + 3 spacing + 2 font.size + 1 duration)
- `src/core/balance/balance_resource.gd` — added `@export var investigation: Dictionary`
- `src/core/balance/balance.tres` — added `investigation = {...}` resource property line
- `src/scenes/boot_check.gd` — added `_check_board_tokens()` token-presence assertion
- `tests/unit/test_no_new_eventbus_signals.gd` — added `test_no_new_signals_added_in_5_2`
- `tests/unit/test_theme_tokens.gd` — added 3 board token tests
- `tests/unit/test_balance_invariants.gd` — added 2 investigation invariant tests
- `.godot/global_script_class_cache.cfg` — added 4 class entries (EvidenceCard, EvidenceInventoryDrawer, PhysicalBoardController, PhysicalBoardState)
- `_bmad-output/implementation-artifacts/sprint-status.yaml` — updated status to `review`

### Review Findings — 2026-05-16

- [x] [Review][Patch] `_commit_placement` ignored `pin()` return value — ghost card spawned on failed pin [physical_board.gd:241]
- [x] [Review][Patch] `card_placement_committed` declared but never emitted (AC4) [evidence_card.gd:17]
- [x] [Review][Patch] Keyboard nudge mode not implemented: right-arrow entry, arrow movement, Enter commit [physical_board.gd]
- [x] [Review][Patch] Enter on pin_layer with armed instance not implemented [physical_board.gd]
- [x] [Review][Patch] BootCheck checked only 10 of 16 board tokens — spacing/font/duration missing (AC11) [boot_check.gd:31]
- [x] [Review][Patch] `EvidenceCard._apply_state_style` hardcoded `.resistance` paper color — ignored theme_variant (AC9) [evidence_card.gd:58]
- [x] [Review][Patch] Overwriting `_armed_instance_id` left prior armed card stuck in STATE_ARMED_SOURCE [physical_board.gd:191]
- [x] [Review][Patch] No NOTIFICATION_DRAG_END handler — dragging pinned card and cancelling left _armed_instance_id set [physical_board.gd]
- [x] [Review][Patch] Click-to-place in `_unhandled_input` fired while nudge mode was active [physical_board.gd:294]
- [x] [Review][Defer] `StyleBoxFlat` allocated on every state change (perf, not correctness) [evidence_card.gd] — deferred
- [x] [Review][Defer] Double-emit `card_picked_up` on drag-after-click (non-data-corrupting) [evidence_card.gd] — deferred
- [x] [Review][Defer] `refresh()` called twice same frame leaves one-frame ghost rows (Godot queue_free behavior) — deferred

### Change Log

- Implemented Story 5.2 Physical Board — pinning + empty state (2026-05-16)
- Code-review patches applied (2026-05-16): pin() return guard, card_placement_committed emission, keyboard nudge mode, BootCheck 16-token coverage, theme_variant propagation to cards, armed-state overwrite protection, drag-cancel clear, nudge/click guard
