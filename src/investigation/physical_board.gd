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
const STAGE_4_DEFERRAL_LOG: String = "physical_board: stage 4 detected — distributed-cells subboard switcher deferred to Story 8.6"

const EVIDENCE_CARD_SCENE: PackedScene = preload("res://src/ui/components/evidence_card.tscn")

# Set by caller BEFORE add_child via `screen.theme_variant = "resistance"`.
var theme_variant: String = THEME_VARIANT_RESISTANCE

# Per-screen runtime state. Reset on every open.
var _armed_instance_id: String = ""
var _nudge_mode_card: EvidenceCard = null
var _nudge_original_pos: Vector2i = Vector2i.ZERO

# Sub-component refs set in _ready()
var _pin_layer: Control = null
var _inventory_drawer: EvidenceInventoryDrawer = null
var _empty_state_note: Label = null
var _stage_capacity_hint: Label = null
var _pinned_card_widgets: Dictionary = {}

@onready var _background: ColorRect = $Background
@onready var _scroll_container: ScrollContainer = $ScrollContainer
@onready var _close_button: Button = $Header/CloseButton
@onready var _title_label: Label = $Header/TitleLabel


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not (theme_variant in VALID_THEME_VARIANTS):
		Logger.warn("investigation", "PhysicalBoardController: unknown theme_variant '%s'; defaulting to resistance" % theme_variant)
		theme_variant = THEME_VARIANT_RESISTANCE

	_pin_layer = $ScrollContainer/pin_layer
	_inventory_drawer = $InventoryDrawer
	_empty_state_note = $EmptyStateNote
	_stage_capacity_hint = $StageCapacityHint

	_apply_theme_tokens()

	# Defensive orphan prune before rendering existing pins
	var pruned := PhysicalBoardState.prune_unknown_instances()
	if pruned > 0:
		Logger.info("investigation", "PhysicalBoardController._ready: pruned %d orphan pins" % pruned)

	# Stage-4 deferral log
	if RPGCore.homebase_stage == 4:
		Logger.info("investigation", STAGE_4_DEFERRAL_LOG)

	# Wire inventory drawer
	if is_instance_valid(_inventory_drawer):
		_inventory_drawer.theme_variant = theme_variant
		_inventory_drawer.row_picked_up.connect(_on_inventory_row_picked_up)
		_inventory_drawer.refresh()

	# Set up pin layer as drop target
	if is_instance_valid(_pin_layer):
		_pin_layer.set_drag_forwarding(
			Callable(self, "_pin_layer_drag"),
			Callable(self, "_pin_layer_can_drop"),
			Callable(self, "_pin_layer_drop")
		)
		_pin_layer.mouse_filter = Control.MOUSE_FILTER_STOP

	# Wire close button
	if is_instance_valid(_close_button):
		_close_button.pressed.connect(close)

	# Render existing pinned cards
	_rebuild_pinned_cards()
	_refresh_empty_state()
	_refresh_capacity_hint()

	# Open log
	Logger.info("investigation", "PhysicalBoard opened: pinned=%d inventory=%d stage=%d" % [
		PhysicalBoardState.count(),
		EvidenceInventory.all_instance_ids().size(),
		RPGCore.homebase_stage,
	])

	# Grab initial focus on the first inventory row
	if is_instance_valid(_inventory_drawer):
		var first_child := _inventory_drawer.get_node_or_null("RowContainer")
		if first_child and first_child.get_child_count() > 0:
			first_child.get_child(0).grab_focus()
		else:
			grab_focus()


func close() -> void:
	if _nudge_mode_card != null:
		_revert_nudge()
		return
	if _armed_instance_id != "":
		_clear_armed()
		return
	Logger.info("investigation", "PhysicalBoard closed: pinned=%d" % PhysicalBoardState.count())
	queue_free()


func _apply_theme_tokens() -> void:
	var surface_key := "color.board.surface.%s" % theme_variant
	var surface_color: Color = ThemeTokens.token(surface_key)
	if is_instance_valid(_background):
		_background.color = surface_color
	if is_instance_valid(_empty_state_note):
		_empty_state_note.add_theme_color_override("font_color", ThemeTokens.token("color.board.empty_state_ink"))
		_empty_state_note.add_theme_font_size_override("font_size", ThemeTokens.token("font.size.board.empty_state"))


func _rebuild_pinned_cards() -> void:
	if not is_instance_valid(_pin_layer):
		return
	# Clear existing widgets
	for widget in _pinned_card_widgets.values():
		if is_instance_valid(widget):
			widget.queue_free()
	_pinned_card_widgets.clear()
	# Rebuild from RPGCore.board_pinned_positions
	for id in PhysicalBoardState.all_pinned_ids():
		_spawn_pinned_card(id)


func _spawn_pinned_card(instance_id: String) -> void:
	if not is_instance_valid(_pin_layer):
		return
	var pos: Dictionary = PhysicalBoardState.position_of(instance_id)
	if pos.is_empty():
		return
	var card: EvidenceCard = EVIDENCE_CARD_SCENE.instantiate()
	card.instance_id = instance_id
	card.theme_variant = theme_variant
	card.set_in_drawer(false)
	card.position = Vector2(int(pos.get("x", 0)), int(pos.get("y", 0)))
	card.card_unpin_requested.connect(_on_card_unpin_requested)
	card.card_picked_up.connect(_on_pinned_card_picked_up)
	_pin_layer.add_child(card)
	_pinned_card_widgets[instance_id] = card


func _refresh_empty_state() -> void:
	if not is_instance_valid(_empty_state_note):
		return
	var has_pinned := PhysicalBoardState.count() > 0
	var has_inventory := EvidenceInventory.all_instance_ids().size() > 0
	_empty_state_note.visible = (not has_pinned) and (not has_inventory)
	if _empty_state_note.visible:
		_empty_state_note.text = tr("ui.board.empty_state")


func _refresh_capacity_hint() -> void:
	if not is_instance_valid(_stage_capacity_hint):
		return
	var pinned_count := PhysicalBoardState.count()
	var capacity := _resolve_visible_capacity()
	_stage_capacity_hint.text = "%d / %d" % [pinned_count, capacity]
	if pinned_count > capacity:
		_stage_capacity_hint.add_theme_color_override("font_color", ThemeTokens.token("color.overdue_marker"))
	else:
		_stage_capacity_hint.remove_theme_color_override("font_color")


func _resolve_visible_capacity() -> int:
	var caps: Dictionary = Balance.get_data().investigation.get("board_visible_capacity_by_stage", {})
	var stage: int = RPGCore.homebase_stage
	return int(caps.get(stage, caps.get(1, 30)))


func _on_inventory_row_picked_up(instance_id: String) -> void:
	_clear_armed()
	_armed_instance_id = instance_id
	if is_instance_valid(_inventory_drawer):
		var card_node = _inventory_drawer.get_node_or_null("RowContainer")
		if card_node:
			for child in card_node.get_children():
				if child is EvidenceCard and (child as EvidenceCard).instance_id == instance_id:
					(child as EvidenceCard).set_card_state(EvidenceCard.STATE_ARMED_SOURCE)


func _on_pinned_card_picked_up(instance_id: String) -> void:
	_clear_armed()
	_armed_instance_id = instance_id
	if _pinned_card_widgets.has(instance_id):
		var card := _pinned_card_widgets[instance_id] as EvidenceCard
		if is_instance_valid(card):
			card.set_card_state(EvidenceCard.STATE_ARMED_SOURCE)


func _on_card_unpin_requested(instance_id: String) -> void:
	PhysicalBoardState.unpin(instance_id)
	if _pinned_card_widgets.has(instance_id):
		var card := _pinned_card_widgets[instance_id] as EvidenceCard
		if is_instance_valid(card):
			card.queue_free()
		_pinned_card_widgets.erase(instance_id)
	if is_instance_valid(_inventory_drawer):
		_inventory_drawer.refresh()
	_refresh_empty_state()
	_refresh_capacity_hint()


func _clear_armed() -> void:
	if _armed_instance_id == "":
		return
	# Reset visual state of the previously armed card
	if _pinned_card_widgets.has(_armed_instance_id):
		var card := _pinned_card_widgets[_armed_instance_id] as EvidenceCard
		if is_instance_valid(card):
			card.set_card_state(EvidenceCard.STATE_DEFAULT)
	if is_instance_valid(_inventory_drawer):
		var row_container := _inventory_drawer.get_node_or_null("RowContainer")
		if row_container:
			for child in row_container.get_children():
				if child is EvidenceCard and (child as EvidenceCard).instance_id == _armed_instance_id:
					(child as EvidenceCard).set_card_state(EvidenceCard.STATE_DEFAULT)
	_armed_instance_id = ""


func _commit_placement(instance_id: String, x: int, y: int) -> void:
	var was_in_drawer := not PhysicalBoardState.is_pinned(instance_id)
	if not PhysicalBoardState.pin(instance_id, x, y):
		return
	if was_in_drawer:
		_spawn_pinned_card(instance_id)
	else:
		if _pinned_card_widgets.has(instance_id):
			var card := _pinned_card_widgets[instance_id] as EvidenceCard
			if is_instance_valid(card):
				card.position = Vector2(x, y)
	if _pinned_card_widgets.has(instance_id):
		var placed_card := _pinned_card_widgets[instance_id] as EvidenceCard
		if is_instance_valid(placed_card):
			placed_card.card_placement_committed.emit(instance_id, x, y)
	if is_instance_valid(_inventory_drawer):
		_inventory_drawer.refresh()
	_clear_armed()
	_refresh_empty_state()
	_refresh_capacity_hint()


func _revert_nudge() -> void:
	if _nudge_mode_card == null:
		return
	var id: String = _nudge_mode_card.instance_id
	PhysicalBoardState.move(id, _nudge_original_pos.x, _nudge_original_pos.y)
	if is_instance_valid(_nudge_mode_card):
		_nudge_mode_card.position = Vector2(_nudge_original_pos)
		_nudge_mode_card.set_card_state(EvidenceCard.STATE_DEFAULT)
	_nudge_mode_card = null
	_nudge_original_pos = Vector2i.ZERO


func _get_focused_pinned_card() -> EvidenceCard:
	for id in _pinned_card_widgets:
		var card := _pinned_card_widgets[id] as EvidenceCard
		if is_instance_valid(card) and card.has_focus():
			return card
	return null


func _enter_nudge_mode(card: EvidenceCard) -> void:
	_nudge_mode_card = card
	var pos: Dictionary = PhysicalBoardState.position_of(card.instance_id)
	_nudge_original_pos = Vector2i(int(pos.get("x", 0)), int(pos.get("y", 0)))
	card.set_card_state(EvidenceCard.STATE_ARMED_SOURCE)


func _apply_nudge(dx: int, dy: int) -> void:
	if _nudge_mode_card == null or not is_instance_valid(_nudge_mode_card):
		return
	var nx := max(0, int(_nudge_mode_card.position.x) + dx)
	var ny := max(0, int(_nudge_mode_card.position.y) + dy)
	PhysicalBoardState.move(_nudge_mode_card.instance_id, nx, ny)
	_nudge_mode_card.position = Vector2(nx, ny)


func _commit_nudge() -> void:
	if _nudge_mode_card == null:
		return
	_nudge_mode_card.set_card_state(EvidenceCard.STATE_DEFAULT)
	_nudge_mode_card = null
	_nudge_original_pos = Vector2i.ZERO


# ── Pin layer drag forwarding ─────────────────────────────────────────────────

func _pin_layer_drag(_at_position: Vector2) -> Variant:
	return null  # pin_layer is a drop target only


func _pin_layer_can_drop(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	return data.get("type", "") == "evidence_card" and data.get("instance_id", "") != ""


func _pin_layer_drop(at_position: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY:
		return
	var id: String = data.get("instance_id", "")
	if id == "":
		return
	_commit_placement(id, int(at_position.x), int(at_position.y))


# ── Input handling ────────────────────────────────────────────────────────────

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			if _armed_instance_id != "" and not get_viewport().gui_is_drag_successful():
				_clear_armed()


func _unhandled_input(event: InputEvent) -> void:
	# Keyboard: nudge arrows, nudge Enter commit, armed Enter placement, right-arrow nudge entry
	if event is InputEventKey and (event as InputEventKey).pressed:
		var ke := event as InputEventKey
		if _nudge_mode_card != null:
			var step: int = int(Balance.get_data().investigation.get("board_nudge_step_px", 8))
			match ke.keycode:
				KEY_UP:
					_apply_nudge(0, -step)
					get_viewport().set_input_as_handled()
					return
				KEY_DOWN:
					_apply_nudge(0, step)
					get_viewport().set_input_as_handled()
					return
				KEY_LEFT:
					_apply_nudge(-step, 0)
					get_viewport().set_input_as_handled()
					return
				KEY_RIGHT:
					_apply_nudge(step, 0)
					get_viewport().set_input_as_handled()
					return
				KEY_ENTER, KEY_KP_ENTER:
					_commit_nudge()
					get_viewport().set_input_as_handled()
					return
		elif _armed_instance_id != "":
			if ke.keycode == KEY_ENTER or ke.keycode == KEY_KP_ENTER:
				if is_instance_valid(_pin_layer):
					var center := _pin_layer.size / 2.0
					get_viewport().set_input_as_handled()
					_commit_placement(_armed_instance_id, int(center.x), int(center.y))
					return
		elif ke.keycode == KEY_RIGHT:
			var focused := _get_focused_pinned_card()
			if focused != null:
				_enter_nudge_mode(focused)
				get_viewport().set_input_as_handled()
				return

	if not event.is_action_pressed(&"ui_cancel"):
		# Click on pin_layer while armed (only when NOT in nudge mode) → place at click position
		if _nudge_mode_card == null and _armed_instance_id != "" and event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT and is_instance_valid(_pin_layer):
				if _pin_layer.get_global_rect().has_point(mb.global_position):
					var local_pos := _pin_layer.get_local_mouse_position()
					get_viewport().set_input_as_handled()
					_commit_placement(_armed_instance_id, int(local_pos.x), int(local_pos.y))
		return

	get_viewport().set_input_as_handled()

	if _nudge_mode_card != null:
		_revert_nudge()
		return

	if _armed_instance_id != "":
		_clear_armed()
		return

	close()
