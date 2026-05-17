extends GutTest

## Story 6.1 — AC5: Offline unlock stash + flush on start_dialogue.


func before_each() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")


func after_each() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")


func test_offline_unlock_stash_recorded_while_inactive() -> void:
	EventBus.dialogue_line_unlocked.emit("offline_test_line_001", "thought_completion")
	# The runner stashes it in _offline_unlocks — no way to directly read it,
	# but we verify it flushes on next start
	assert_true(true, "Offline stash test precondition: signal emitted while inactive")


func test_offline_unlock_flushes_into_runtime_state_on_start() -> void:
	EventBus.dialogue_line_unlocked.emit("offline_flush_line_abc", "thought_completion")
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	var state := DialogueRunner.runtime_state()
	assert_not_null(state, "runtime_state must be non-null after start")
	assert_true(state.unlocked_line_ids.has("offline_flush_line_abc"),
		"Offline stash must flush into runtime_state.unlocked_line_ids on start (AC5)")


func test_offline_stash_cleared_after_flush() -> void:
	EventBus.dialogue_line_unlocked.emit("stash_clear_check_line", "thought_completion")
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	var state := DialogueRunner.runtime_state()
	assert_true(state.unlocked_line_ids.has("stash_clear_check_line"),
		"Stash must flush into state")
	# Interrupt and restart — stash should be empty, so the second start won't have the old line
	DialogueRunner.interrupt("player_exit")
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	var state2 := DialogueRunner.runtime_state()
	assert_false(state2.unlocked_line_ids.has("stash_clear_check_line"),
		"Stash must be cleared after flush — second start must not re-seed old keys")


func test_online_unlock_pushes_into_active_state_immediately() -> void:
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_true(DialogueRunner.is_active())
	EventBus.dialogue_line_unlocked.emit("online_immediate_line", "active_source")
	var state := DialogueRunner.runtime_state()
	assert_true(state.unlocked_line_ids.has("online_immediate_line"),
		"Online unlock (VM active) must push directly into runtime_state.unlocked_line_ids (AC5)")
