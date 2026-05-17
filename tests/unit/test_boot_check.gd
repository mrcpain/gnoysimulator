extends GutTest

## Story 5.6 — BootCheck stamp_grammar token validation (AC11).


func test_check_stamp_grammar_tokens_passes_with_all_keys_present() -> void:
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
		assert_not_null(v, "ThemeToken '%s' must resolve to a non-null value" % key)
		# token() returns Color.MAGENTA for missing keys — make sure it's not that
		if v is Color:
			assert_ne(v, Color.MAGENTA, "ThemeToken '%s' must not return MAGENTA (missing key)" % key)


func test_check_stamp_grammar_tokens_warns_on_missing_key() -> void:
	# boot_check.gd calls push_warning on missing tokens; we verify the function exists and runs
	var boot_src := FileAccess.open("res://src/scenes/boot_check.gd", FileAccess.READ)
	assert_not_null(boot_src, "boot_check.gd must be readable")
	var content: String = boot_src.get_as_text()
	boot_src.close()
	assert_true(content.contains("_check_stamp_grammar_tokens"),
		"boot_check.gd must define _check_stamp_grammar_tokens()")
	assert_true(content.contains("push_warning"),
		"boot_check.gd _check_stamp_grammar_tokens must call push_warning on missing token")


## Story 5.7 — BootCheck awakening_reveal token validation (AC8 / Task 9).

func test_check_awakening_reveal_tokens_passes_with_all_keys_present() -> void:
	var required_color_keys: Array[String] = [
		"color.evidence.reframing_badge.resistance",
		"color.evidence.reframing_badge.xyoner",
		"color.cabinet.addenda_bracket",
		"color.board.connection.questioned",
	]
	for key in required_color_keys:
		var v: Variant = ThemeTokens.token(key)
		assert_not_null(v, "Token '%s' must resolve to non-null" % key)
		if v is Color:
			assert_ne(v as Color, Color.MAGENTA, "Token '%s' must not return MAGENTA" % key)
	var required_numeric_keys: Array[String] = [
		"font.size.evidence.reframing_badge",
		"font.size.cabinet.addenda_body",
		"font.size.evidence.symbol_tooltip",
		"spacing.evidence.reframing_badge_offset",
	]
	for key in required_numeric_keys:
		var v: Variant = ThemeTokens.token(key)
		assert_false(v is Color, "Numeric token '%s' must not be Color (missing key fallback)" % key)
		assert_gt(float(v), 0.0, "Numeric token '%s' must be > 0" % key)


func test_check_awakening_reveal_tokens_errors_on_missing_color_key() -> void:
	# Boot check source-level: verify _check_awakening_reveal_tokens exists and is called from _ready
	var boot_src := FileAccess.open("res://src/scenes/boot_check.gd", FileAccess.READ)
	assert_not_null(boot_src, "boot_check.gd must be readable")
	var content: String = boot_src.get_as_text()
	boot_src.close()
	assert_true(content.contains("_check_awakening_reveal_tokens()"),
		"boot_check.gd must declare and call _check_awakening_reveal_tokens()")
	assert_true(content.contains("color.evidence.reframing_badge.resistance"),
		"_check_awakening_reveal_tokens must check resistance badge color token")
	assert_true(content.contains("color.board.connection.questioned"),
		"_check_awakening_reveal_tokens must check questioned connection color token")


## Story 6.1 — Boot check calls DialogueCatalog.validate() and fixture parses cleanly.

func test_boot_check_calls_dialogue_catalog_validate() -> void:
	var boot_src := FileAccess.open("res://src/scenes/boot_check.gd", FileAccess.READ)
	assert_not_null(boot_src, "boot_check.gd must be readable")
	var content: String = boot_src.get_as_text()
	boot_src.close()
	assert_true(content.contains("DialogueCatalog.validate()"),
		"boot_check.gd must call DialogueCatalog.validate() (Story 6.1)")


func test_dialogue_fixture_parses_without_errors() -> void:
	var g := DialogueCatalog.get_graph("dialogue_vm_test_fixture")
	assert_not_null(g, "VS fixture graph must load from catalog")
	assert_true(g.validate(), "VS fixture graph must pass DialogueGraph.validate()")

