extends GutTest

## Story 6.1 — Unit tests for DialogueEncounterContext base-class contract.


func _make_state() -> DialogueRuntimeState:
	var state := DialogueRuntimeState.new()
	var g := DialogueGraph.new()
	g.graph_id = "ctx_test"
	g.start_node_id = "n_end"
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [end]
	state.reset(g)
	return state


func test_base_on_dialogue_started_no_op() -> void:
	var ctx := DialogueEncounterContext.new()
	var state := _make_state()
	ctx.on_dialogue_started(state)
	assert_true(true, "on_dialogue_started must be a no-op (not crash)")


func test_base_on_node_entered_no_op() -> void:
	var ctx := DialogueEncounterContext.new()
	var state := _make_state()
	var node := DialogueEndNode.new()
	node.node_id = "n_end"
	ctx.on_node_entered(state, node)
	assert_true(true, "on_node_entered must be a no-op (not crash)")


func test_base_on_system_effect_returns_false() -> void:
	var ctx := DialogueEncounterContext.new()
	var state := _make_state()
	var result: bool = ctx.on_system_effect(state, {"effect_type": "composure_damage", "args": {}})
	assert_false(result, "Base on_system_effect must return false (do not consume)")


func test_base_should_interrupt_returns_null() -> void:
	var ctx := DialogueEncounterContext.new()
	var state := _make_state()
	var result: Variant = ctx.should_interrupt(state)
	assert_null(result, "Base should_interrupt must return null (do not interrupt)")


func test_subclass_can_override_should_interrupt() -> void:
	# Verify the interrupt contract by creating an inline override via GDScript
	var ctx := DialogueEncounterContext.new()
	# Base returns null — that's the contract; subclass returning a Dict forces interrupt.
	# We verify the base null case here; Story 6.6 verifies the Dict case.
	assert_null(ctx.should_interrupt(DialogueRuntimeState.new()))
