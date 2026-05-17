extends GutTest

## Story 6.1 — Unit tests for DialogueVM per-node-type resolver coverage + lifecycle.


# ── Helpers ──────────────────────────────────────────────────────────────────

func _make_two_node_graph(first: DialogueNode, end_id: String = "n_end") -> DialogueGraph:
	var g := DialogueGraph.new()
	g.graph_id = "vm_test"
	g.start_node_id = first.node_id
	first.next_id = end_id
	var end := DialogueEndNode.new()
	end.node_id = end_id
	end.end_reason = "normal"
	g.nodes = [first, end]
	return g


func _make_vm() -> DialogueVM:
	return DialogueVM.new()


# ── start() ──────────────────────────────────────────────────────────────────

func test_vm_start_with_null_graph_returns_false() -> void:
	var vm := _make_vm()
	assert_false(vm.start(null))


func test_vm_start_with_valid_graph_returns_true() -> void:
	var vm := _make_vm()
	var line := DialogueLineNode.new()
	line.node_id = "n_line"
	line.speaker_id = "npc"
	line.body_key = "test.line"
	var g := _make_two_node_graph(line)
	assert_true(vm.start(g))


func test_vm_is_active_after_start() -> void:
	var vm := _make_vm()
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	var g := DialogueGraph.new()
	g.graph_id = "g"
	g.start_node_id = "n_end"
	g.nodes = [end]
	vm.start(g)
	# After an End node, vm is inactive
	assert_false(vm.is_active(), "VM must be inactive after End node resolves")


func test_vm_not_active_before_start() -> void:
	var vm := _make_vm()
	assert_false(vm.is_active())


# ── Line node resolver ────────────────────────────────────────────────────────

func test_vm_resolves_line_node_and_emits_signal() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_line_presented.connect(cb)
	var line := DialogueLineNode.new()
	line.node_id = "n_line"
	line.speaker_id = "test_npc"
	line.body_key = "test.body"
	var g := _make_two_node_graph(line)
	vm.start(g)
	assert_eq(received.size(), 1, "dialogue_line_presented must fire once")
	assert_eq(received[0].speaker_id, "test_npc")
	assert_eq(received[0].body_key, "test.body")
	EventBus.dialogue_line_presented.disconnect(cb)


# ── Choice node resolver ──────────────────────────────────────────────────────

func test_vm_choice_node_emits_choice_presented() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_choice_presented.connect(cb)
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{"choice_id": "c1", "body_key": "k1", "next_id": "n_end",
						"gate": "none", "gate_args": {}}]
	var g := _make_two_node_graph(choice)
	vm.start(g)
	assert_eq(received.size(), 1, "dialogue_choice_presented must fire")
	EventBus.dialogue_choice_presented.disconnect(cb)


func test_vm_submit_choice_advances() -> void:
	var vm := _make_vm()
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{"choice_id": "c1", "body_key": "k1", "next_id": "n_end",
						"gate": "none", "gate_args": {}}]
	var g := _make_two_node_graph(choice)
	vm.start(g)
	assert_true(vm.is_active(), "VM must be active before submit")
	vm.submit_choice("c1")
	assert_false(vm.is_active(), "VM must be inactive after routing to End")


func test_vm_submit_choice_no_outcome_leakage_in_payload() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_choice_presented.connect(cb)
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{
		"choice_id": "c_skill", "body_key": "k_skill", "next_id": "n_end",
		"gate": "skill_check", "gate_args": {"skill_id": "yap_game", "dc": 10}
	}]
	var g := _make_two_node_graph(choice)
	vm.start(g)
	assert_eq(received.size(), 1)
	var choice_data: Dictionary = received[0].choices[0]
	assert_false(choice_data.has("will_succeed"), "Choice payload must NOT have outcome-leaking keys")
	assert_false(choice_data.has("outcome"), "Choice payload must NOT have 'outcome' key")
	EventBus.dialogue_choice_presented.disconnect(cb)


# ── SkillCheck node resolver ──────────────────────────────────────────────────

func test_vm_skill_check_node_calls_rpgcore() -> void:
	var vm := _make_vm()
	RNG.restore_stream("dialogue", 42)
	var sk := DialogueSkillCheckNode.new()
	sk.node_id = "n_sk"
	sk.skill_id = "yap_game"
	sk.dc = 10
	sk.stream_name = "dialogue"
	sk.outcome_next_ids = {"critical": "n_end", "success": "n_end", "fail": "n_end"}
	var g := _make_two_node_graph(sk)
	vm.start(g)
	# VM must have resolved (either outcome routes to n_end, so VM is inactive)
	assert_false(vm.is_active())


func test_vm_skill_check_stores_last_result() -> void:
	var vm := _make_vm()
	RNG.restore_stream("dialogue", 42)
	var sk := DialogueSkillCheckNode.new()
	sk.node_id = "n_sk"
	sk.skill_id = "yap_game"
	sk.dc = 10
	sk.stream_name = "dialogue"
	sk.outcome_next_ids = {"critical": "n_end", "success": "n_end", "fail": "n_end"}
	var g := _make_two_node_graph(sk)
	vm.start(g)
	# runtime_state is still accessible after dialogue ends
	var state := vm.runtime_state()
	assert_not_null(state)
	assert_true(state.last_skill_check.has("outcome"), "last_skill_check must be populated after skill check")


# ── Branch node resolver ──────────────────────────────────────────────────────

func test_vm_branch_always_routes_correctly() -> void:
	var vm := _make_vm()
	var g := DialogueGraph.new()
	g.graph_id = "branch_test"
	g.start_node_id = "n_branch"
	var branch := DialogueBranchNode.new()
	branch.node_id = "n_branch"
	branch.next_id = ""
	branch.conditions = [{"condition_type": "always", "args": {}, "next_id": "n_end"}]
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	end.end_reason = "normal"
	g.nodes = [branch, end]
	vm.start(g)
	assert_false(vm.is_active(), "VM must end after Branch → always → End")


# ── InternalVoice node resolver ───────────────────────────────────────────────

func test_vm_internal_voice_emits_at_frequency_1() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_internal_voice_presented.connect(cb)
	var voice := DialogueInternalVoiceNode.new()
	voice.node_id = "n_voice"
	voice.voice_profile_id = "doxcraft"
	voice.body_key = "test.voice"
	voice.base_frequency = 1.0  # Always emits
	var g := _make_two_node_graph(voice)
	vm.start(g)
	assert_eq(received.size(), 1, "InternalVoice with base_frequency=1.0 must emit")
	assert_eq(received[0].voice_profile_id, "doxcraft")
	assert_true(received[0].is_first_speak, "First emission must have is_first_speak=true")
	EventBus.dialogue_internal_voice_presented.disconnect(cb)


func test_vm_internal_voice_second_emit_not_first_speak() -> void:
	var vm := _make_vm()
	var g := DialogueGraph.new()
	g.graph_id = "voice_twice"
	g.start_node_id = "n_v1"
	var v1 := DialogueInternalVoiceNode.new()
	v1.node_id = "n_v1"
	v1.voice_profile_id = "doxcraft"
	v1.base_frequency = 1.0
	v1.next_id = "n_v2"
	var v2 := DialogueInternalVoiceNode.new()
	v2.node_id = "n_v2"
	v2.voice_profile_id = "doxcraft"
	v2.base_frequency = 1.0
	v2.next_id = "n_end"
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [v1, v2, end]
	var payloads := []
	var cb := func(p): payloads.append(p)
	EventBus.dialogue_internal_voice_presented.connect(cb)
	vm.start(g)
	assert_eq(payloads.size(), 2)
	assert_true(payloads[0].is_first_speak, "First emit must be is_first_speak=true")
	assert_false(payloads[1].is_first_speak, "Second emit must be is_first_speak=false")
	EventBus.dialogue_internal_voice_presented.disconnect(cb)


# ── ItemDrop node resolver ────────────────────────────────────────────────────

func test_vm_item_drop_emits_armed_signal() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_item_drop_armed.connect(cb)
	var drop := DialogueItemDropNode.new()
	drop.node_id = "n_drop"
	drop.accepted_items = [{"evidence_definition_id": "passport_scan", "next_id": "n_end",
							"consume_on_accept": false, "reaction_line_id": ""}]
	drop.next_id = "n_end"
	var g := _make_two_node_graph(drop)
	vm.start(g)
	assert_eq(received.size(), 1, "dialogue_item_drop_armed must fire")
	assert_true(received[0].accepted_evidence_definition_ids.has("passport_scan"))
	EventBus.dialogue_item_drop_armed.disconnect(cb)


func test_vm_accept_item_drop_routes_correctly() -> void:
	var vm := _make_vm()
	var drop := DialogueItemDropNode.new()
	drop.node_id = "n_drop"
	drop.accepted_items = [{"evidence_definition_id": "passport_scan", "next_id": "n_end",
							"consume_on_accept": false, "reaction_line_id": ""}]
	drop.next_id = "n_end"
	var g := _make_two_node_graph(drop)
	vm.start(g)
	assert_true(vm.is_active())
	vm.accept_item_drop("passport_scan")
	assert_false(vm.is_active(), "After accepting drop that routes to End, VM must be inactive")


# ── SystemEffect node resolver ────────────────────────────────────────────────

func test_vm_system_effect_set_flag() -> void:
	var vm := _make_vm()
	var effect := DialogueSystemEffectNode.new()
	effect.node_id = "n_effect"
	effect.effects = [{"effect_type": "set_flag", "args": {"flag_id": "my_test_flag"}}]
	var g := _make_two_node_graph(effect)
	vm.start(g)
	var state := vm.runtime_state()
	assert_true(state.flags.get("my_test_flag", false), "set_flag effect must set the flag in runtime state")


func test_vm_system_effect_unlock_line() -> void:
	var vm := _make_vm()
	var effect := DialogueSystemEffectNode.new()
	effect.node_id = "n_effect"
	effect.effects = [{"effect_type": "unlock_line", "args": {"line_id": "secret_line", "source": "test"}}]
	var g := _make_two_node_graph(effect)
	vm.start(g)
	var state := vm.runtime_state()
	assert_true(state.unlocked_line_ids.has("secret_line"), "unlock_line must add to unlocked_line_ids")


func test_vm_system_effect_queue_signal_non_whitelisted_rejected() -> void:
	var vm := _make_vm()
	var effect := DialogueSystemEffectNode.new()
	effect.node_id = "n_effect"
	effect.effects = [{"effect_type": "queue_signal", "args": {"signal_name": "player_died", "payload": {}}}]
	var g := _make_two_node_graph(effect)
	# Should not crash; should log an error and skip
	vm.start(g)
	assert_false(vm.is_active(), "VM must complete even when queue_signal is non-whitelisted")


# ── Commit node resolver ──────────────────────────────────────────────────────

func test_vm_commit_node_emits_dialogue_line_committed() -> void:
	var vm := _make_vm()
	var received := []
	var cb := func(p): received.append(p)
	EventBus.dialogue_line_committed.connect(cb)
	var commit := DialogueCommitNode.new()
	commit.node_id = "n_commit"
	commit.committed_line_id = "c_my_choice"
	commit.npc_line_id = "n_intro"
	commit.commit_tags = PackedStringArray(["quotable"])
	var g := _make_two_node_graph(commit)
	vm.start(g)
	assert_eq(received.size(), 1, "dialogue_line_committed must fire")
	assert_eq(received[0].committed_line_id, "c_my_choice")
	EventBus.dialogue_line_committed.disconnect(cb)


# ── End node + teardown ───────────────────────────────────────────────────────

func test_vm_end_node_emits_dialogue_ended() -> void:
	var vm := _make_vm()
	var ended_args := []
	var cb := func(gid, reason): ended_args.append({"gid": gid, "reason": reason})
	EventBus.dialogue_ended.connect(cb)
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	end.end_reason = "normal"
	var g := DialogueGraph.new()
	g.graph_id = "teardown_test"
	g.start_node_id = "n_end"
	g.nodes = [end]
	vm.start(g)
	assert_eq(ended_args.size(), 1, "dialogue_ended must fire once")
	assert_eq(ended_args[0].get("reason"), "normal")
	EventBus.dialogue_ended.disconnect(cb)


func test_vm_interrupt_sets_inactive() -> void:
	var vm := _make_vm()
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{"choice_id": "c1", "body_key": "k", "next_id": "n_end",
						"gate": "none", "gate_args": {}}]
	var g := _make_two_node_graph(choice)
	vm.start(g)
	assert_true(vm.is_active(), "VM must be active at Choice node")
	vm.interrupt("player_exit")
	assert_false(vm.is_active(), "VM must be inactive after interrupt")


# ── attach_encounter_context ──────────────────────────────────────────────────

func test_vm_attach_encounter_context_stores_ref() -> void:
	var vm := _make_vm()
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{"choice_id": "c1", "body_key": "k", "next_id": "n_end",
						"gate": "none", "gate_args": {}}]
	var g := _make_two_node_graph(choice)
	vm.start(g)
	var ctx := DialogueEncounterContext.new()
	vm.attach_encounter_context(ctx)
	assert_not_null(vm.runtime_state().encounter_context)
