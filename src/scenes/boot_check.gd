extends Node

## Disposable boot verification scene (Story 1.0).
## Story 12.x replaces this with the real Opening Sequence scene.
## This scene only exists to confirm all 12 autoloads came online without errors.

const AUTOLOAD_COUNT := 12


func _ready() -> void:
	Logger.info("boot", "All %d autoloads online." % AUTOLOAD_COUNT)
	WeaponCatalog.validate()
	EquipmentCatalog.validate()
	SetBonusCatalog.validate()
	RecipeCatalog.validate()      # Story 4.4
	EvidenceCatalog.validate()    # Story 5.1
	_check_board_tokens()         # Story 5.2
	var btn := $OpenBillsScreenButton
	if btn:
		btn.pressed.connect(_on_open_bills_screen_pressed)
	var sleep_btn := $SleepButton
	if sleep_btn:
		sleep_btn.pressed.connect(_on_sleep_pressed)
	var force_bill_btn := $ForceBillsButton
	if force_bill_btn:
		force_bill_btn.pressed.connect(_on_force_bills_pressed)


func _check_board_tokens() -> void:
	## Story 5.2 — assert all 16 board ThemeToken keys resolve without returning Color.MAGENTA.
	var color_keys: Array[String] = [
		"color.board.surface.resistance", "color.board.surface.xyoner",
		"color.board.card.paper.resistance", "color.board.card.paper.xyoner",
		"color.board.card.frame", "color.board.pin.red",
		"color.board.stamp.seized", "color.board.empty_state_ink",
		"color.board.card.armed_outline", "color.board.card.hover_outline",
	]
	for key in color_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color and (val as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: board token '%s' resolved to MAGENTA (key missing)" % key)
	var numeric_keys: Array[String] = [
		"spacing.board.card_size", "spacing.board.pin_layer_padding",
		"font.size.board.empty_state", "font.size.board.card_caption",
		"font.size.board.card_source", "duration.board.card_focus_in",
	]
	for key in numeric_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color:
			Logger.error("boot", "BootCheck: board token '%s' resolved to MAGENTA (key missing)" % key)
		elif float(val) <= 0.0:
			Logger.error("boot", "BootCheck: board token '%s' has non-positive value: %s" % [key, str(val)])
	Logger.info("boot", "BootCheck: board token-presence check complete (Story 5.2)")


func _on_open_bills_screen_pressed() -> void:
	var scene: PackedScene = load("res://src/ui/diegetic/bills_screen.tscn")
	if scene == null:
		Logger.error("boot", "Failed to load bills_screen.tscn")
		return
	var bills := scene.instantiate()
	add_child(bills)


func _on_sleep_pressed() -> void:
	SleepAction.commit(8)


func _on_force_bills_pressed() -> void:
	MonthlyBillingEngine.force_run_cycle()
