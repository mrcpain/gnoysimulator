class_name EvidenceCard extends Control

## Story 5.2 — UX-DR30 custom component. Re-used by Stories 5.3 / 5.4 / 5.5 / 5.7.
## Renders a single evidence INSTANCE; reads metadata via EvidenceInventory.get_instance_for_ui.
##
## Forbidden:
##   - Calling EvidenceInventory.get_instance / .is_cage_planted (FR10 — cage_planted MUST NOT
##     surface in UI code paths).
##   - Reading RPGCore.evidence_inventory directly.
##   - Emitting EventBus signals (5.2 ships zero new signals; widget-internal signals only).

const STATE_DEFAULT:      String = "default"
const STATE_HOVER:        String = "hover"
const STATE_ARMED_SOURCE: String = "armed_source"

signal card_picked_up(instance_id: String)
signal card_placement_committed(instance_id: String, x: int, y: int)
signal card_unpin_requested(instance_id: String)

# Set by caller BEFORE add_child. After _ready() this is immutable for the widget lifetime.
var instance_id: String = ""
var theme_variant: String = "resistance"

var _state: String = STATE_DEFAULT
var _is_in_drawer: bool = false

@onready var _caption: Label = $Caption
@onready var _source_subtext: Label = $SourceSubtext
@onready var _seized_badge: Label = $SeizedBadge
@onready var _frame: Panel = $Frame


func _ready() -> void:
	custom_minimum_size = Vector2(
		ThemeTokens.token("spacing.board.card_size"),
		ThemeTokens.token("spacing.board.card_size")
	)
	_apply_state_style()
	_populate_from_instance()
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP


func set_in_drawer(in_drawer: bool) -> void:
	_is_in_drawer = in_drawer


func set_card_state(new_state: String) -> void:
	_state = new_state
	_apply_state_style()


func _apply_state_style() -> void:
	match _state:
		STATE_HOVER, STATE_ARMED_SOURCE:
			var key := "color.board.card.armed_outline" if _state == STATE_ARMED_SOURCE else "color.board.card.hover_outline"
			if is_instance_valid(_frame):
				var style := StyleBoxFlat.new()
				style.bg_color = ThemeTokens.token("color.board.card.paper.%s" % theme_variant)
				style.border_color = ThemeTokens.token(key)
				style.border_width_left = 2
				style.border_width_right = 2
				style.border_width_top = 2
				style.border_width_bottom = 2
				_frame.add_theme_stylebox_override("panel", style)
		_:
			if is_instance_valid(_frame):
				var style := StyleBoxFlat.new()
				style.bg_color = ThemeTokens.token("color.board.card.paper.%s" % theme_variant)
				style.border_color = ThemeTokens.token("color.board.card.frame")
				style.border_width_left = 1
				style.border_width_right = 1
				style.border_width_top = 1
				style.border_width_bottom = 1
				_frame.add_theme_stylebox_override("panel", style)


func _populate_from_instance() -> void:
	if instance_id == "":
		_render_placeholder("(no instance_id)")
		return
	var data: Dictionary = EvidenceInventory.get_instance_for_ui(instance_id)
	if data.is_empty():
		Logger.warn("investigation", "EvidenceCard: unknown instance_id '%s'" % instance_id)
		_render_placeholder("Unknown evidence")
		return
	var def_id: String = data.get("definition_id", "")
	var display_key: String = "evidence.%s.name" % def_id
	if is_instance_valid(_caption):
		var translated: String = tr(display_key)
		_caption.text = translated if translated != display_key else def_id
		_caption.add_theme_font_size_override("font_size", ThemeTokens.token("font.size.board.card_caption"))
	if is_instance_valid(_source_subtext):
		_source_subtext.text = data.get("source_actual", "")
		_source_subtext.add_theme_font_size_override("font_size", ThemeTokens.token("font.size.board.card_source"))
	var is_seized: bool = bool(data.get("seized", false))
	if is_instance_valid(_seized_badge):
		_seized_badge.visible = is_seized
		if is_seized:
			_seized_badge.text = "SEIZED"
			_seized_badge.add_theme_color_override("font_color", ThemeTokens.token("color.board.stamp.seized"))


func _render_placeholder(text: String) -> void:
	if is_instance_valid(_caption):
		_caption.text = text
	if is_instance_valid(_source_subtext):
		_source_subtext.text = ""
	if is_instance_valid(_seized_badge):
		_seized_badge.visible = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			if _is_in_drawer:
				_state = STATE_ARMED_SOURCE
				_apply_state_style()
				card_picked_up.emit(instance_id)
				var vp := get_viewport()
				if vp:
					vp.set_input_as_handled()
		elif mb.pressed and mb.button_index == MOUSE_BUTTON_RIGHT:
			if not _is_in_drawer:
				card_unpin_requested.emit(instance_id)
				var vp := get_viewport()
				if vp:
					vp.set_input_as_handled()
	elif event is InputEventKey:
		var ke := event as InputEventKey
		if ke.pressed and ke.keycode == KEY_ENTER and has_focus():
			if _is_in_drawer:
				_state = STATE_ARMED_SOURCE
				_apply_state_style()
				card_picked_up.emit(instance_id)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			if _state == STATE_DEFAULT:
				_state = STATE_HOVER
				_apply_state_style()
		NOTIFICATION_MOUSE_EXIT:
			if _state == STATE_HOVER:
				_state = STATE_DEFAULT
				_apply_state_style()
		NOTIFICATION_FOCUS_ENTER:
			if _state == STATE_DEFAULT:
				_state = STATE_HOVER
				_apply_state_style()
		NOTIFICATION_FOCUS_EXIT:
			if _state == STATE_HOVER:
				_state = STATE_DEFAULT
				_apply_state_style()


func _get_drag_data(at_position: Vector2) -> Variant:
	if instance_id == "":
		return null
	var preview := duplicate()
	if preview is Control:
		(preview as Control).custom_minimum_size = Vector2(64, 64)
	set_drag_preview(preview)
	card_picked_up.emit(instance_id)
	_state = STATE_ARMED_SOURCE
	_apply_state_style()
	return {"type": "evidence_card", "instance_id": instance_id}
