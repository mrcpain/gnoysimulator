extends GutTest

## Story 6.1 — AC1: Full fixture walk through all 9 node types via DialogueRunner facade.
## NO scene loaded — VM-only. Asserts every signal fires with correct payload shape.
## graph: dialogue_vm_test_fixture (n_line_intro → n_branch → n_voice → n_choice → n_skill_check
##         → n_item_drop → n_system_effect → n_commit → n_end)


var _signals := {
	"started": [],
	"ended": [],
	"node_entered": [],
	"line_presented": [],
	"choice_presented": [],
	"choice_selected": [],
	"voice_presented": [],
	"item_drop_armed": [],
	"item_drop_resolved": [],
	"line_committed": [],
	"system_effect": [],
}


func before_each() -> void:
	for key in _signals:
		_signals[key].clear()
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	EventBus.dialogue_started.connect(_on_started)
	EventBus.dialogue_ended.connect(_on_ended)
	EventBus.dialogue_node_entered.connect(_on_node_entered)
	EventBus.dialogue_line_presented.connect(_on_line_presented)
	EventBus.dialogue_choice_presented.connect(_on_choice_presented)
	EventBus.dialogue_choice_selected.connect(_on_choice_selected)
	EventBus.dialogue_internal_voice_presented.connect(_on_voice_presented)
	EventBus.dialogue_item_drop_armed.connect(_on_item_drop_armed)
	EventBus.dialogue_item_drop_resolved.connect(_on_item_drop_resolved)
	EventBus.dialogue_line_committed.connect(_on_line_committed)
	EventBus.dialogue_system_effect_applied.connect(_on_system_effect)


func after_each() -> void:
	if DialogueRunner.is_active():
		DialogueRunner.interrupt("player_exit")
	EventBus.dialogue_started.disconnect(_on_started)
	EventBus.dialogue_ended.disconnect(_on_ended)
	EventBus.dialogue_node_entered.disconnect(_on_node_entered)
	EventBus.dialogue_line_presented.disconnect(_on_line_presented)
	EventBus.dialogue_choice_presented.disconnect(_on_choice_presented)
	EventBus.dialogue_choice_selected.disconnect(_on_choice_selected)
	EventBus.dialogue_internal_voice_presented.disconnect(_on_voice_presented)
	EventBus.dialogue_item_drop_armed.disconnect(_on_item_drop_armed)
	EventBus.dialogue_item_drop_resolved.disconnect(_on_item_drop_resolved)
	EventBus.dialogue_line_committed.disconnect(_on_line_committed)
	EventBus.dialogue_system_effect_applied.disconnect(_on_system_effect)


func _on_started(graph_id: String) -> void: _signals.started.append(graph_id)
func _on_ended(graph_id: String, reason: String) -> void: _signals.ended.append({"gid": graph_id, "reason": reason})
func _on_node_entered(gid: String, nid: String, ntype: String) -> void: _signals.node_entered.append(ntype)
func _on_line_presented(p: DialogueLinePresentedEvent) -> void: _signals.line_presented.append(p)
func _on_choice_presented(p: DialogueChoicePresentedEvent) -> void: _signals.choice_presented.append(p)
func _on_choice_selected(gid: String, nid: String, cid: String) -> void: _signals.choice_selected.append(cid)
func _on_voice_presented(p: DialogueInternalVoicePresentedEvent) -> void: _signals.voice_presented.append(p)
func _on_item_drop_armed(p: DialogueItemDropArmedEvent) -> void: _signals.item_drop_armed.append(p)
func _on_item_drop_resolved(gid: String, nid: String, iid: String, accepted: bool) -> void:
	_signals.item_drop_resolved.append({"instance_id": iid, "accepted": accepted})
func _on_line_committed(p: DialogueLineCommittedEvent) -> void: _signals.line_committed.append(p)
func _on_system_effect(p: DialogueSystemEffectAppliedEvent) -> void: _signals.system_effect.append(p)


func test_dialogue_started_fires() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_eq(_signals.started.size(), 1, "dialogue_started must fire once")
	assert_eq(_signals.started[0], "dialogue_vm_test_fixture")
	DialogueRunner.interrupt("player_exit")


func test_line_presented_fires_for_intro_line() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_gte(_signals.line_presented.size(), 1, "dialogue_line_presented must fire at least once")
	var first: DialogueLinePresentedEvent = _signals.line_presented[0]
	assert_eq(first.speaker_id, "test_npc_001")
	DialogueRunner.interrupt("player_exit")


func test_internal_voice_fires_at_frequency_1() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	# Branch routes to InternalVoice (awakening_min 0 is always true with awakening_level >= 1)
	assert_gte(_signals.voice_presented.size(), 1, "InternalVoice must fire (base_frequency=1.0)")
	var vp: DialogueInternalVoicePresentedEvent = _signals.voice_presented[0]
	assert_eq(vp.voice_profile_id, "doxcraft")
	assert_eq(vp.computed_frequency, 1.0)
	DialogueRunner.interrupt("player_exit")


func test_choice_presented_fires_at_skill_gate_node() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	assert_gte(_signals.choice_presented.size(), 1, "dialogue_choice_presented must fire")
	var cp: DialogueChoicePresentedEvent = _signals.choice_presented[0]
	assert_gte(cp.choices.size(), 1)
	DialogueRunner.interrupt("player_exit")


func test_full_walk_all_9_node_types_complete() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")

	# At choice node — submit skill_check choice
	DialogueRunner.submit_choice("c_skill_yap")
	# Now at item_drop node
	DialogueRunner.accept_item_drop("passport_scan")
	# Now past system_effect → commit → end

	# Verify all signals fired
	assert_eq(_signals.started.size(), 1, "dialogue_started must fire once")
	assert_gte(_signals.line_presented.size(), 1, "dialogue_line_presented must fire")
	assert_gte(_signals.voice_presented.size(), 1, "dialogue_internal_voice_presented must fire")
	assert_gte(_signals.choice_presented.size(), 1, "dialogue_choice_presented must fire")
	assert_gte(_signals.choice_selected.size(), 1, "dialogue_choice_selected must fire")
	assert_gte(_signals.item_drop_armed.size(), 1, "dialogue_item_drop_armed must fire")
	assert_gte(_signals.item_drop_resolved.size(), 1, "dialogue_item_drop_resolved must fire")
	assert_true(_signals.item_drop_resolved[0].get("accepted", false), "Item drop must be accepted")
	assert_gte(_signals.system_effect.size(), 1, "dialogue_system_effect_applied must fire")
	assert_gte(_signals.line_committed.size(), 1, "dialogue_line_committed must fire")
	assert_eq(_signals.ended.size(), 1, "dialogue_ended must fire once")
	assert_eq(_signals.ended[0].get("reason"), "normal", "dialogue_ended reason must be 'normal'")


func test_dialogue_ended_reason_is_normal() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	DialogueRunner.submit_choice("c_skill_yap")
	DialogueRunner.accept_item_drop("passport_scan")
	assert_eq(_signals.ended[0].get("reason"), "normal")


func test_cursor_lands_on_end_node() -> void:
	RNG.restore_stream("dialogue", 1234)
	DialogueRunner.start_dialogue("dialogue_vm_test_fixture")
	DialogueRunner.submit_choice("c_skill_yap")
	DialogueRunner.accept_item_drop("passport_scan")
	assert_false(DialogueRunner.is_active(), "After full walk, VM must be inactive (End node reached)")
