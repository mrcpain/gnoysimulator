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
	DialogueCatalog.validate()   # Story 6.1
	_check_board_tokens()         # Story 5.2
	_check_dossier_tokens()       # Story 5.4
	_check_cabinet_tokens()       # Story 5.5
	_check_stamp_grammar_tokens()        # Story 5.6
	_check_awakening_reveal_tokens()     # Story 5.7
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
	# Story 5.3 — Connection mechanic token-presence check (AC10).
	var connection_color_keys: Array[String] = [
		"color.board.connection.verified", "color.board.connection.probable",
		"color.board.connection.uncertain", "color.board.connection.in_progress",
	]
	for key in connection_color_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color and (val as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: connection token '%s' resolved to MAGENTA (key missing)" % key)
	var connection_numeric_keys: Array[String] = [
		"spacing.board.connection_string_width.verified",
		"spacing.board.connection_string_width.probable",
		"spacing.board.connection_string_width.uncertain",
		"spacing.board.connection_string_width.in_progress",
		"font.size.board.connection_badge_label",
		"font.size.board.connection_badge_dc",
		"font.size.board.connection_badge_stamp",
	]
	for key in connection_numeric_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color:
			Logger.error("boot", "BootCheck: connection token '%s' resolved to MAGENTA (key missing)" % key)
		elif float(val) <= 0.0:
			Logger.error("boot", "BootCheck: connection token '%s' has non-positive value: %s" % [key, str(val)])
	Logger.info("boot", "BootCheck: board token-presence check complete (Story 5.2)")


func _check_dossier_tokens() -> void:
	## Story 5.4 -- Dossier Interface token-presence check.
	var color_keys: Array[String] = [
		"color.dossier.surface.resistance", "color.dossier.surface.xyoner",
		"color.dossier.paper.resistance", "color.dossier.paper.xyoner",
		"color.dossier.preview.credibility.positive", "color.dossier.preview.credibility.negative",
		"color.dossier.preview.heat",
		"color.dossier.preview.faction.positive", "color.dossier.preview.faction.negative",
		"color.dossier.commit_button.armed",
	]
	for key in color_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color and (val as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: dossier token '%s' resolved to MAGENTA (key missing)" % key)
	var numeric_keys: Array[String] = [
		"spacing.dossier.matrix_padding",
		"font.size.dossier.preview_value",
	]
	for key in numeric_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color:
			Logger.error("boot", "BootCheck: dossier token '%s' resolved to MAGENTA (key missing)" % key)
		elif float(val) <= 0.0:
			Logger.error("boot", "BootCheck: dossier token '%s' has non-positive value: %s" % [key, str(val)])
	Logger.info("boot", "BootCheck: dossier token-presence check complete (Story 5.4)")


func _check_cabinet_tokens() -> void:
	## Story 5.5 — Thought Cabinet token-presence check.
	var color_keys: Array[String] = [
		"color.cabinet.surface.resistance", "color.cabinet.surface.xyoner",
		"color.cabinet.slot_card.resistance", "color.cabinet.slot_card.xyoner",
		"color.cabinet.slot_card.empty_outline",
		"color.cabinet.progress_fill",
	]
	for key in color_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color and (val as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: cabinet token '%s' resolved to MAGENTA (key missing)" % key)
	var numeric_keys: Array[String] = [
		"spacing.cabinet.slot_card_height",
		"font.size.cabinet.thought_title",
	]
	for key in numeric_keys:
		var val: Variant = ThemeTokens.token(key)
		if val is Color:
			Logger.error("boot", "BootCheck: cabinet token '%s' resolved to MAGENTA (key missing)" % key)
		elif float(val) <= 0.0:
			Logger.error("boot", "BootCheck: cabinet token '%s' has non-positive value: %s" % [key, str(val)])
	Logger.info("boot", "BootCheck: cabinet token-presence check complete (Story 5.5)")


func _check_stamp_grammar_tokens() -> void:
	## Story 5.6 — assert all 10 stamp_grammar ThemeToken keys resolve without returning null.
	var required: Array[String] = [
		"motion.stamp.scale_in_duration",
		"motion.stamp.rotation_duration",
		"motion.stamp.fade_in_duration",
		"motion.stamp.dice_flip_step_ms",
		"motion.stamp.dice_flip_count",
		"motion.stamp.rotation_verified_deg",
		"motion.stamp.rotation_probable_deg",
		"motion.stamp.rotation_uncertain_deg",
		"motion.stamp.scale_start",
		"motion.stamp.shadow_offset",
	]
	for key in required:
		var v: Variant = ThemeTokens.token(key)
		if v is Color and (v as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: stamp_grammar token '%s' resolved to MAGENTA (key missing)" % key)
	Logger.info("boot", "BootCheck: stamp_grammar token-presence check complete (Story 5.6)")


func _check_awakening_reveal_tokens() -> void:
	## Story 5.7 — assert all 8 awakening-reveal ThemeToken keys resolve without returning MAGENTA / null.
	var color_keys: Array[String] = [
		"color.evidence.reframing_badge.resistance",
		"color.evidence.reframing_badge.xyoner",
		"color.cabinet.addenda_bracket",
		"color.board.connection.questioned",
	]
	for key in color_keys:
		var v: Variant = ThemeTokens.token(key)
		if v is Color and (v as Color) == Color.MAGENTA:
			Logger.error("boot", "BootCheck: awakening_reveal token '%s' resolved to MAGENTA (key missing)" % key)
	var numeric_keys: Array[String] = [
		"font.size.evidence.reframing_badge",
		"font.size.cabinet.addenda_body",
		"font.size.evidence.symbol_tooltip",
		"spacing.evidence.reframing_badge_offset",
	]
	for key in numeric_keys:
		var v: Variant = ThemeTokens.token(key)
		if v is Color:
			Logger.error("boot", "BootCheck: awakening_reveal token '%s' resolved to MAGENTA (key missing)" % key)
		elif float(v) <= 0.0:
			Logger.error("boot", "BootCheck: awakening_reveal token '%s' has non-positive value: %s" % [key, str(v)])
	Logger.info("boot", "BootCheck: awakening_reveal token-presence check complete (Story 5.7)")


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
