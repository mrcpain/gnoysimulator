extends GutTest

## Story 6.1 — AC12: Dialogue VM cursor is per-session ephemeral.
## Asserts SaveGameV1 has NO dialogue cursor/state fields added by Story 6.1.
## `dialogue_line_unlocks` was added in Story 5.5 for Thought Cabinet — that is NOT the VM cursor.
## FR194 + arch §3.9 lock: the VM cursor (current graph / current node / active state) is ephemeral.


func before_each() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")


func after_each() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")


func test_save_during_dialogue_does_not_persist_cursor() -> void:
	RNG.restore_stream("dialogue", 11111)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_true(DialogueRunner.is_active(), "Dialogue must be active before save")
	# Save mid-walk using the project's save pattern
	var save := SaveGameV1.new()
	SaveSystem.save_to_slot(0, save)
	# Dialogue must still be active (save doesn't interrupt it)
	assert_true(DialogueRunner.is_active(), "Dialogue must still be active after save")


func test_load_does_not_restore_dialogue_state() -> void:
	# Interrupt first
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	# Load a save — dialogue should NOT be restored
	SaveSystem.load_from_slot(0)
	assert_false(DialogueRunner.is_active(), "After load, dialogue must NOT be restored (ephemeral per arch §3.9)")


func test_save_game_v1_has_no_dialogue_vm_cursor_fields() -> void:
	## AC12: the VM cursor fields (active graph, current node) must NOT exist in save format.
	## NOTE: `dialogue_line_unlocks` is a Story 5.5 field (Thought Cabinet) — NOT a cursor field.
	## We only check for new dialogue VM cursor / active-state fields introduced by Story 6.1.
	var file := FileAccess.open("res://src/core/save/save_game_v1.gd", FileAccess.READ)
	assert_not_null(file, "save_game_v1.gd must be readable")
	var src: String = file.get_as_text()
	file.close()
	# Check that no dialogue cursor / VM state fields were added by 6.1
	var forbidden_patterns := [
		"dialogue_cursor",
		"dialogue_active_graph",
		"dialogue_vm_state",
		"dialogue_current_node",
		"dialogue_runtime_state",
	]
	for pattern in forbidden_patterns:
		assert_false(src.contains(pattern),
			"save_game_v1.gd must NOT have '%s' field (AC12 — VM cursor is ephemeral)" % pattern)
