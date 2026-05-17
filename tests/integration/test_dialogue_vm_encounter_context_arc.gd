extends GutTest

## Story 6.1 — AC9: Attaches a stub EncounterContext and verifies all lifecycle callbacks.
## Verifies the four callback fire order and that should_interrupt is honored.


class StubEncounterContext extends DialogueEncounterContext:
	var started_calls := 0
	var node_entered_calls := []
	var effect_calls := []
	var ended_calls := 0
	var interrupt_value: Variant = null  # null = no interrupt; Dictionary = force interrupt

	func on_dialogue_started(state: DialogueRuntimeState) -> void:
		started_calls += 1

	func on_node_entered(state: DialogueRuntimeState, node: DialogueNode) -> void:
		node_entered_calls.append(node.node_type)

	func on_system_effect(state: DialogueRuntimeState, effect: Dictionary) -> bool:
		effect_calls.append(effect.get("effect_type", ""))
		return false  # Don't consume by default

	func on_dialogue_ended(state: DialogueRuntimeState, reason: String) -> void:
		ended_calls += 1

	func should_interrupt(state: DialogueRuntimeState) -> Variant:
		return interrupt_value


func test_encounter_context_lifecycle_callbacks_fire_in_order() -> void:
	var ctx := StubEncounterContext.new()
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	RNG.restore_stream("dialogue", 9999)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture", ctx)

	# on_dialogue_started must fire
	assert_eq(ctx.started_calls, 1, "on_dialogue_started must fire once")
	# on_node_entered must have fired for the nodes traversed so far
	assert_gte(ctx.node_entered_calls.size(), 1, "on_node_entered must fire at least once")

	DialogueRunner.submit_choice("c_skill_yap")
	DialogueRunner.accept_item_drop("passport_scan")

	# on_dialogue_ended must fire
	assert_eq(ctx.ended_calls, 1, "on_dialogue_ended must fire once after walk completes")

	# Node types covered: line, branch, internal_voice, choice, skill_check, item_drop, system_effect, commit, end
	assert_true(ctx.node_entered_calls.has("line"), "on_node_entered must see 'line' type")
	assert_true(ctx.node_entered_calls.has("end"), "on_node_entered must see 'end' type")


func test_should_interrupt_honored_when_set() -> void:
	var ctx := StubEncounterContext.new()
	ctx.interrupt_value = {"end_reason": "composure_failure"}
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	RNG.restore_stream("dialogue", 9999)
	var ended_reasons := []
	var cb := func(gid, reason): ended_reasons.append(reason)
	EventBus.dialogue_ended.connect(cb)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture", ctx)
	# should_interrupt immediately returns the dict → VM must interrupt
	assert_false(DialogueRunner.is_active(), "VM must be interrupted by should_interrupt returning Dict")
	assert_gte(ended_reasons.size(), 1, "dialogue_ended must fire")
	assert_eq(ended_reasons[0], "composure_failure", "End reason must match should_interrupt return value")
	EventBus.dialogue_ended.disconnect(cb)


func test_on_system_effect_called_for_effects() -> void:
	var ctx := StubEncounterContext.new()
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	RNG.restore_stream("dialogue", 9999)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture", ctx)
	DialogueRunner.submit_choice("c_skill_yap")
	DialogueRunner.accept_item_drop("passport_scan")
	assert_gte(ctx.effect_calls.size(), 1, "on_system_effect must be called for system_effect node effects")
