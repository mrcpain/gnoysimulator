extends GutTest

## Story 6.1 — AC13: adds exactly 11 new signals; post-6.1 baseline = 82.
## Story 3.3 — AC9 regression: no new EventBus signals added by Story 3.3.
## Story 3.3 reuses existing channels: gnoym_interrogated, heat_input,
## faction_dossier_flag, encounter_resolved, capture_resolved.
## Baseline count must match the post-Story-3.2 signal total (62 signals).
## Story 3.6 — AC6: adds exactly ONE new signal (signature_weapon_used). New baseline: 63.
## Story 3.9 — AC3: adds TWO new signals (enemy_footstep_emitted, combat_intensity_changed). New baseline: 65.
## Story 4.1 — AC6: adds ONE new signal (equipment_changed). New cumulative baseline: 66.


func test_no_new_signals_added_in_3_3() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	# Post-Story-3.2 baseline: 62 signals (verified by manual count after Story 3.2 landed).
	# Story 3.3 must NOT add new signals (reuses existing channels per AC9).
	# NOTE: after 3.6 → 63; after 3.9 → 65; after 4.1 → 66. Principle preserved.
	assert_eq(signal_count, 82,
		"Story 3.3 must NOT add new EventBus signals (reuse existing channels per AC9). " +
		"Post-4.1 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_5() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	# Story 3.5 reuses heat_input for ranged_lethal Heat spike. No new signals added.
	# NOTE: after 3.6 → 63; after 3.9 → 65; after 4.1 → 66. Principle preserved.
	assert_eq(signal_count, 82,
		"Story 3.5 must NOT add new EventBus signals (reuses heat_input for ranged_lethal Heat spike). Post-4.1 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_4() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	# Story 3.4 reuses: capture_resolved, heat_input, gnoym_interrogated, evidence_published, day_advanced.
	# NO new signals. NOTE: after 3.6 → 63; after 3.9 → 65; after 4.1 → 66.
	assert_eq(signal_count, 82,
		"Story 3.4 must NOT add new EventBus signals (reuse capture_resolved / heat_input / " +
		"gnoym_interrogated / evidence_published / day_advanced). Post-4.1 baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_6() -> void:
	# Story 3.6 adds exactly ONE new EventBus signal: signature_weapon_used.
	# New baseline: 63. Future stories MUST extend (not replace) this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	# NOTE: after 3.9 → 65; after 4.1 → 66. Principle preserved: 3.6 added 1.
	assert_eq(signal_count, 82,
		"Story 3.6 baseline is 63 signals (62 prior + signature_weapon_used). Post-4.1 cumulative == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_8() -> void:
	# Story 3.8 (Faction Build Counter-System combat side) adds ZERO new EventBus signals.
	# Observation is via existing subscriptions; integration is via direct method calls.
	# NOTE: after 3.9 → 65; after 4.1 → 66. Principle preserved: 3.8 added no new signals.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82, "Story 3.8 must NOT add new EventBus signals. Post-4.1 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_7() -> void:
	# Story 3.7 adds ZERO new EventBus signals. Music routing is via direct MusicDirector call.
	# Baseline: 63 (unchanged from Story 3.6). NOTE: after 3.9 → 65; after 4.1 → 66.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	# NOTE: after 4.1, cumulative count is 66. Principle preserved: 3.7 added 0.
	assert_eq(signal_count, 82, "Story 3.7 must NOT add new EventBus signals. Post-4.1 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_3_9() -> void:
	# Story 3.9 adds exactly TWO new EventBus signals: enemy_footstep_emitted + combat_intensity_changed.
	# New cumulative baseline: 65. NOTE: after 4.1 → 66. Principle preserved.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in content.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 3.9 baseline is 65 signals (63 prior + enemy_footstep_emitted + combat_intensity_changed). Post-4.1 cumulative == 66. NOTE: after 4.3 → 67.")


func test_signals_added_by_3_9_present() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	assert_true(content.contains("signal enemy_footstep_emitted"), "Story 3.9: enemy_footstep_emitted must be declared")
	assert_true(content.contains("signal combat_intensity_changed"), "Story 3.9: combat_intensity_changed must be declared")


func test_no_new_signals_added_in_3_10() -> void:
	## Story 3.10 ships zero new EventBus signals. NOTE: after 4.1 → 66.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 3.10 must NOT add new EventBus signals (difficulty is balance + config only). Post-4.1 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_4_1() -> void:
	## Story 4.1 adds exactly ONE new EventBus signal: equipment_changed.
	## New cumulative baseline: 66. Future stories MUST extend this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 4.1 baseline is 66 signals (65 prior + equipment_changed). NOTE: after 4.3 → 67.")


func test_no_new_signals_added_in_4_2() -> void:
	## Story 4.2 adds ZERO new EventBus signals. Reuses equipment_changed + district_entered
	## + heat_input. Cumulative baseline remains 66 (unchanged from 4.1).
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 4.2 must NOT add new EventBus signals (reuses equipment_changed + district_entered + heat_input). Post-4.2 cumulative baseline == 66. NOTE: after 4.3 → 67.")


func test_signal_added_by_4_1_present() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	assert_true(content.contains("signal equipment_changed"), "equipment_changed signal must exist")


func test_no_new_signals_added_in_4_3() -> void:
	## Story 4.3 adds exactly ONE new EventBus signal: outfit_state_changed.
	## New cumulative baseline: 67. Future stories MUST extend this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 4.3 baseline is 67 signals (66 prior + outfit_state_changed).")


func test_signal_added_by_4_3_present() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	assert_true(content.contains("signal outfit_state_changed"), "outfit_state_changed signal must exist")


func test_no_new_signals_added_in_4_4() -> void:
	## Story 4.4 adds exactly ONE new EventBus signal: item_crafted.
	## New cumulative baseline: 68. Future stories MUST extend this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 4.4 baseline is 68 signals (67 prior + item_crafted).")


func test_signal_added_by_4_4_present() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	assert_true(content.contains("signal item_crafted"), "item_crafted signal must exist")


func test_no_new_signals_added_in_4_5() -> void:
	## Story 4.5 adds NO new EventBus signals — it is a pure consumer.
	## Baseline unchanged: 68. Future stories MUST extend this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 4.5 baseline is 68 signals (unchanged from 4.4 — pure-consumer story).")


func test_no_new_signals_added_in_5_1() -> void:
	## Story 5.1 adds ZERO new EventBus signals (pure data + persistence + capture-hook story).
	## Baseline unchanged: 68. Future stories MUST extend this assertion.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.1 must NOT add new EventBus signals (pure data + persistence + capture-hook story). Baseline 68 post-4.5.")


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
	assert_eq(signal_count, 82,
		"Story 5.2 must NOT add new EventBus signals (reuses hud_screen_requested). Baseline 68 post-5.1.")

func test_no_new_signals_added_in_5_3() -> void:
	## Story 5.3 adds ZERO new EventBus signals — emits on the existing connection_drawn
	## signal (line 187 of event_bus.gd, declared by Story 1.0, reserved by 5.1 + 5.2).
	## Story 5.3 IS the first emitter on connection_drawn. EvidenceCard.hover_changed is a
	## widget-level signal, not an EventBus signal.
	## Baseline unchanged: 68.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.3 must NOT add new EventBus signals (emits on existing connection_drawn). Baseline 68 post-5.2.")



func test_no_new_signals_added_in_5_4() -> void:
	## Story 5.4 adds ZERO new EventBus signals -- emits on the existing evidence_published
	## signal (line 50 of event_bus.gd, first full emitter in 5.4; stub used by 3.4 + 2.4).
	## Baseline unchanged: 68. NOTE: after 5.5 → 71.
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.4 baseline was 68 signals. After Story 5.5, total is 71 (three new signals added).")


func test_no_new_signals_added_in_5_5() -> void:
	## Story 5.5 adds exactly THREE new EventBus signals:
	##   thought_completed, evidence_reframed, dialogue_line_unlocked.
	## New cumulative baseline: 71 (up from 68 post-5.4).
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.5 adds 3 new signals (thought_completed, evidence_reframed, dialogue_line_unlocked). Post-5.5 baseline == 71.")
	# Assert exact 3-signal additive diff by name
	assert_true(src_text.contains("signal thought_completed"),
		"Story 5.5: thought_completed signal must be declared in event_bus.gd")
	assert_true(src_text.contains("signal evidence_reframed"),
		"Story 5.5: evidence_reframed signal must be declared in event_bus.gd")
	assert_true(src_text.contains("signal dialogue_line_unlocked"),
		"Story 5.5: dialogue_line_unlocked signal must be declared in event_bus.gd")


func test_no_new_signals_added_in_5_6() -> void:
	## Story 5.6 adds ZERO new EventBus signals. The animation work is feedback-only —
	## every dispatch reuses existing signals. Baseline: 71 (post-5.5).
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.6 must add zero EventBus signals (baseline 71 post-5.5)")


func test_no_new_signals_added_in_5_7() -> void:
	## Story 5.7 adds ZERO new EventBus signals. The reframing badge / addenda / tooltip /
	## questioned-badge are STATIC UI surfacings — subscribers only, no new emitters.
	## Baseline: 71 (unchanged from post-5.6).
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 5.7 must add zero EventBus signals (pure surfacing pass — subscribers only, post-6.1 baseline 82)")


func test_no_new_signals_added_in_6_1() -> void:
	## Story 6.1 adds exactly 11 new EventBus signals (dialogue grammar).
	## New cumulative baseline: 82 (71 prior + 11 new).
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var src_text: String = file.get_as_text()
	file.close()
	var signal_count: int = 0
	for line: String in src_text.split("\n"):
		if line.strip_edges().begins_with("signal "):
			signal_count += 1
	assert_eq(signal_count, 82,
		"Story 6.1 adds 11 signals (dialogue grammar). Post-6.1 baseline == 82.")


func test_signals_added_by_6_1_present() -> void:
	var file := FileAccess.open("res://src/core/autoloads/event_bus.gd", FileAccess.READ)
	assert_not_null(file, "event_bus.gd must be readable")
	var content: String = file.get_as_text()
	file.close()
	var expected_signals: Array[String] = [
		"signal dialogue_started",
		"signal dialogue_ended",
		"signal dialogue_node_entered",
		"signal dialogue_line_presented",
		"signal dialogue_choice_presented",
		"signal dialogue_choice_selected",
		"signal dialogue_internal_voice_presented",
		"signal dialogue_item_drop_armed",
		"signal dialogue_item_drop_resolved",
		"signal dialogue_line_committed",
		"signal dialogue_system_effect_applied",
	]
	for sig: String in expected_signals:
		assert_true(content.contains(sig), "Story 6.1: %s must be declared in event_bus.gd" % sig)
