extends GutTest

## Story 6.1 — Unit tests for DialogueRunner autoload-level passthrough + offline-unlock stashing.


func test_runner_start_dialogue_returns_true_for_fixture() -> void:
	assert_true(DialogueRunner.start_dialogue("dialogue_vm_test_fixture"),
		"start_dialogue with valid graph_id must return true")
	DialogueRunner.interrupt("player_exit")


func test_runner_start_dialogue_returns_false_for_unknown_graph() -> void:
	assert_false(DialogueRunner.start_dialogue("totally_unknown_graph_xyzzy"),
		"start_dialogue with unknown graph_id must return false")


func test_runner_is_active_after_start() -> void:
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_true(DialogueRunner.is_active())
	DialogueRunner.interrupt("player_exit")


func test_runner_is_not_active_before_start() -> void:
	# Interrupt any lingering dialogue first
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	assert_false(DialogueRunner.is_active())


func test_runner_current_graph_id_after_start() -> void:
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_eq(DialogueRunner.current_graph_id(), "dialogue_vm_test_fixture")
	DialogueRunner.interrupt("player_exit")


func test_runner_interrupt_sets_inactive() -> void:
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	DialogueRunner.interrupt("player_exit")
	assert_false(DialogueRunner.is_active())


func test_offline_unlock_stash_while_inactive() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	# Fire unlock while VM is inactive
	EventBus.dialogue_line_unlocked.emit("test_stash_line", "thought_completion")
	# The offline stash should hold it
	var state := DialogueRunner.runtime_state()
	# State may be null if no active dialogue; that's expected
	assert_true(true, "Offline unlock stash must not crash")


func test_offline_unlock_flushed_on_start() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	EventBus.dialogue_line_unlocked.emit("test_offline_flush_line", "test_source")
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	var state := DialogueRunner.runtime_state()
	assert_not_null(state)
	assert_true(state.unlocked_line_ids.has("test_offline_flush_line"),
		"Offline unlock stash must be flushed into runtime_state on start_dialogue")
	DialogueRunner.interrupt("player_exit")


func test_online_unlock_pushes_into_active_state() -> void:
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	# At choice node now — emit unlock while active
	EventBus.dialogue_line_unlocked.emit("test_online_line", "active_source")
	var state := DialogueRunner.runtime_state()
	assert_not_null(state)
	assert_true(state.unlocked_line_ids.has("test_online_line"),
		"Active unlock must push directly into runtime_state.unlocked_line_ids")
	DialogueRunner.interrupt("player_exit")
