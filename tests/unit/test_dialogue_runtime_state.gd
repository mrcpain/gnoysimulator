extends GutTest

## Story 6.1 — Unit tests for DialogueRuntimeState defaults + mutations.


func _make_minimal_graph(start_id: String = "n_start") -> DialogueGraph:
	var g := DialogueGraph.new()
	g.graph_id = "state_test"
	g.start_node_id = start_id
	var end := DialogueEndNode.new()
	end.node_id = start_id
	end.end_reason = "normal"
	g.nodes = [end]
	return g


func test_fresh_state_defaults() -> void:
	var state := DialogueRuntimeState.new()
	assert_null(state.graph)
	assert_eq(state.current_node_id, "")
	assert_eq(state.flags, {})
	assert_eq(state.voice_emit_counts, {})
	assert_eq(state.unlocked_line_ids, {})
	assert_eq(state.committed_line_count, 0)
	assert_null(state.encounter_context)


func test_reset_sets_cursor_to_start() -> void:
	var state := DialogueRuntimeState.new()
	var g := _make_minimal_graph("n_my_start")
	state.reset(g)
	assert_eq(state.current_node_id, "n_my_start")
	assert_not_null(state.graph)


func test_reset_clears_all_mutable_state() -> void:
	var state := DialogueRuntimeState.new()
	var g := _make_minimal_graph()
	state.reset(g)
	state.flags["test_flag"] = true
	state.voice_emit_counts["doxcraft"] = 3
	state.unlocked_line_ids["line_x"] = true
	state.committed_line_count = 5
	state.reset(g)
	assert_eq(state.flags, {})
	assert_eq(state.voice_emit_counts, {})
	assert_eq(state.unlocked_line_ids, {})
	assert_eq(state.committed_line_count, 0)


func test_voice_emit_count_tracking() -> void:
	var state := DialogueRuntimeState.new()
	state.voice_emit_counts["doxcraft"] = 0
	state.voice_emit_counts["doxcraft"] += 1
	assert_eq(state.voice_emit_counts.get("doxcraft", 0), 1)
	state.voice_emit_counts["doxcraft"] += 1
	assert_eq(state.voice_emit_counts.get("doxcraft", 0), 2)


func test_unlocked_line_id_set_semantics() -> void:
	var state := DialogueRuntimeState.new()
	assert_false(state.unlocked_line_ids.has("line_secret"))
	state.unlocked_line_ids["line_secret"] = true
	assert_true(state.unlocked_line_ids.has("line_secret"))


func test_flag_set_and_clear() -> void:
	var state := DialogueRuntimeState.new()
	state.flags["test_flag"] = true
	assert_true(state.flags.get("test_flag", false))
	state.flags.erase("test_flag")
	assert_false(state.flags.has("test_flag"))


func test_current_node_returns_correct_node() -> void:
	var state := DialogueRuntimeState.new()
	var g := _make_minimal_graph("n_start")
	state.reset(g)
	var node := state.current_node()
	assert_not_null(node)
	assert_eq(node.node_id, "n_start")
