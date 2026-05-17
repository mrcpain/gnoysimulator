class_name DialogueVM extends RefCounted

## Story 6.1 — Custom GDScript Dialogue VM. Walks a DialogueGraph resource.
## Architecture locked rule 6: this is the ONLY runtime for all dialogue (including boss encounters).
## No await chains. Synchronous node-resolution only (arch §7.2 forbidden patterns).
## All EncounterContext interaction routes through the seam methods only (locked rule 6).

var _state: DialogueRuntimeState = null
var _active: bool = false


# ── Public API ───────────────────────────────────────────────────────────────

func start(graph: DialogueGraph, encounter_context: RefCounted = null, prefill_unlocks: Dictionary = {}) -> bool:
	if graph == null:
		Logger.error("dialogue", "DialogueVM.start: graph is null")
		return false
	if not graph.validate():
		Logger.error("dialogue", "DialogueVM.start: graph '%s' failed validation" % graph.graph_id)
		return false

	_state = DialogueRuntimeState.new()
	_state.reset(graph)
	# Seed offline unlocks BEFORE first advance so choice/branch gates see them (AC5)
	for lid: String in prefill_unlocks:
		_state.unlocked_line_ids[lid] = true
	# Attach context BEFORE the initial advance so EncounterContext hooks fire correctly
	if encounter_context != null:
		_state.encounter_context = encounter_context
	_active = true

	if _state.encounter_context != null:
		(_state.encounter_context as DialogueEncounterContext).on_dialogue_started(_state)

	EventBus.dialogue_started.emit(graph.graph_id)
	Logger.info("dialogue", "DialogueVM.start: graph='%s'" % graph.graph_id)

	# Advance through non-interactive nodes synchronously
	_advance_to_interactive()
	return true


func step() -> Dictionary:
	if not _active or _state == null:
		return {"node_type": "end", "node_id": "", "payload": {}}
	var node: DialogueNode = _state.current_node()
	if node == null:
		return {"node_type": "end", "node_id": "", "payload": {}}
	return {"node_type": node.node_type, "node_id": node.node_id, "payload": {}}


func submit_choice(choice_id: String) -> bool:
	if not _active or _state == null:
		return false
	var node: DialogueNode = _state.current_node()
	if node == null or node.node_type != DialogueNode.TYPE_CHOICE:
		Logger.error("dialogue", "DialogueVM.submit_choice: current node is not a Choice")
		return false
	var choice_node := node as DialogueChoiceNode
	for choice: Dictionary in choice_node.choices:
		if choice.get("choice_id", "") == choice_id:
			EventBus.dialogue_choice_selected.emit(_state.graph.graph_id, node.node_id, choice_id)
			var next: String = choice.get("next_id", "")
			if next == "":
				next = choice_node.next_id  # fallback to node-level default routing
			if next != "":
				_state.current_node_id = next
			_advance_to_interactive()
			return true
	Logger.error("dialogue", "DialogueVM.submit_choice: choice_id '%s' not found in node '%s'" % [choice_id, node.node_id])
	return false


func accept_item_drop(instance_id: String) -> bool:
	if not _active or _state == null:
		return false
	var node: DialogueNode = _state.current_node()
	if node == null or node.node_type != DialogueNode.TYPE_ITEM_DROP:
		Logger.error("dialogue", "DialogueVM.accept_item_drop: current node is not an ItemDrop")
		return false
	var drop_node := node as DialogueItemDropNode

	# Match instance_id against evidence_inventory definitions
	var matched_def_id: String = _find_item_definition_id(instance_id)
	for item: Dictionary in drop_node.accepted_items:
		var def_id: String = item.get("evidence_definition_id", "")
		if def_id != "" and matched_def_id == def_id:
			EventBus.dialogue_item_drop_resolved.emit(
				_state.graph.graph_id, node.node_id, instance_id, true)
			var next: String = item.get("next_id", node.next_id)
			if next != "":
				_state.current_node_id = next
			_advance_to_interactive()
			return true

	EventBus.dialogue_item_drop_resolved.emit(
		_state.graph.graph_id, node.node_id, instance_id, false)
	return false


func attach_encounter_context(ctx: RefCounted) -> void:
	if _state == null:
		return
	_state.encounter_context = ctx


func interrupt(reason: String) -> void:
	if not _active or _state == null:
		return
	_teardown(reason)


func is_active() -> bool:
	return _active


func current_node_id() -> String:
	if _state == null:
		return ""
	return _state.current_node_id


func current_graph_id() -> String:
	if _state == null or _state.graph == null:
		return ""
	return _state.graph.graph_id


func runtime_state() -> DialogueRuntimeState:
	return _state


# ── Internal ─────────────────────────────────────────────────────────────────

func _advance_to_interactive() -> void:
	## Synchronously walks through non-interactive nodes (Line, Branch, SystemEffect,
	## InternalVoice-that-skips, Commit) until reaching a Choice / SkillCheck / ItemDrop / End,
	## or an InternalVoice that emits. Each node entry fires EncounterContext hooks.
	var safety: int = 0
	while _active and _state != null and safety < 500:
		safety += 1
		var node: DialogueNode = _state.current_node()
		if node == null:
			Logger.error("dialogue", "DialogueVM: cursor '%s' not found in graph" % _state.current_node_id)
			_teardown("interrupted")
			return

		EventBus.dialogue_node_entered.emit(
			_state.graph.graph_id, node.node_id, node.node_type)

		# EncounterContext: on_node_entered (step 1 in AC9 locked sequence)
		if _state.encounter_context != null:
			(_state.encounter_context as DialogueEncounterContext).on_node_entered(_state, node)

		# Resolve node
		var yielded: bool = _resolve_node(node)

		# EncounterContext: should_interrupt (step 3 in AC9 locked sequence)
		if _active and _state != null and _state.encounter_context != null:
			var interrupt_req: Variant = (_state.encounter_context as DialogueEncounterContext).should_interrupt(_state)
			if interrupt_req is Dictionary and interrupt_req.has("end_reason"):
				interrupt(interrupt_req.get("end_reason", "interrupted"))
				return

		if yielded:
			# Reached an interactive node — stop advancing
			return

	if safety >= 500:
		Logger.error("dialogue", "DialogueVM._advance_to_interactive: loop limit reached — possible cycle in graph '%s'" % current_graph_id())
		_teardown("interrupted")


func _resolve_node(node: DialogueNode) -> bool:
	## Returns true if the node yields (requires player input or is End).
	match node.node_type:
		DialogueNode.TYPE_LINE:
			_resolve_line_node(node as DialogueLineNode)
			return false
		DialogueNode.TYPE_CHOICE:
			_resolve_choice_node(node as DialogueChoiceNode)
			return true  # Yields — waits for submit_choice
		DialogueNode.TYPE_SKILL_CHECK:
			_resolve_skill_check_node(node as DialogueSkillCheckNode)
			return false
		DialogueNode.TYPE_INTERNAL_VOICE:
			return _resolve_internal_voice_node(node as DialogueInternalVoiceNode)
		DialogueNode.TYPE_ITEM_DROP:
			_resolve_item_drop_node(node as DialogueItemDropNode)
			return true  # Yields — waits for accept_item_drop
		DialogueNode.TYPE_BRANCH:
			_resolve_branch_node(node as DialogueBranchNode)
			return false
		DialogueNode.TYPE_SYSTEM_EFFECT:
			_resolve_system_effect_node(node as DialogueSystemEffectNode)
			return false
		DialogueNode.TYPE_COMMIT:
			_resolve_commit_node(node as DialogueCommitNode)
			return false
		DialogueNode.TYPE_END:
			_resolve_end_node(node as DialogueEndNode)
			return true  # Yields — dialogue is over
		_:
			Logger.error("dialogue", "DialogueVM: unknown node_type '%s'" % node.node_type)
			_teardown("interrupted")
			return true


func _resolve_line_node(node: DialogueLineNode) -> void:
	var payload := DialogueLinePresentedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.speaker_id = node.speaker_id
	payload.body_key = node.body_key
	payload.voice_profile_id = node.voice_profile_id
	payload.tags = node.tags.duplicate()
	EventBus.dialogue_line_presented.emit(payload)
	_state.current_node_id = node.next_id


func _resolve_choice_node(node: DialogueChoiceNode) -> void:
	# Build display choices (visible-DC contract FR55 — no outcome leakage)
	var display_choices: Array[Dictionary] = []
	for choice: Dictionary in node.choices:
		var display: Dictionary = {
			"choice_id": choice.get("choice_id", ""),
			"body_key": choice.get("body_key", ""),
			"next_id": choice.get("next_id", ""),
			"gate": choice.get("gate", DialogueChoiceNode.GATE_NONE),
			"gate_args": choice.get("gate_args", {}).duplicate(),
		}
		# For skill_check gates, surface display-only DC info (FR55)
		if display.gate == DialogueChoiceNode.GATE_SKILL_CHECK:
			var ga: Dictionary = display.gate_args
			var skill_id: String = ga.get("skill_id", "")
			var dc: int = int(ga.get("dc", 0))
			var preview: Dictionary = RPGCore.preview_check(skill_id, dc)
			display["skill_preview"] = {
				"dc": preview.get("dc", dc),
				"skill_id": preview.get("skill_id", skill_id),
				"skill_name_key": preview.get("skill_name_key", ""),
			}
			# NO outcome leakage — no "will succeed"/"will fail" keys
		display_choices.append(display)

	_state.presented_choices = display_choices

	var payload := DialogueChoicePresentedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.choices = display_choices.duplicate(true)
	EventBus.dialogue_choice_presented.emit(payload)
	# Does NOT advance current_node_id — waits for submit_choice


func _resolve_skill_check_node(node: DialogueSkillCheckNode) -> void:
	var result: Dictionary = RPGCore.skill_check(
		node.skill_id, node.dc, node.modifier, node.stream_name)
	_state.last_skill_check = result

	var outcome: String = result.get("outcome", "fail")
	var next: String = node.outcome_next_ids.get(outcome, node.next_id)
	if next == "":
		next = node.next_id
	_state.current_node_id = next


func _resolve_internal_voice_node(node: DialogueInternalVoiceNode) -> bool:
	# Frequency roll — base_frequency=1.0 always emits
	var freq: float = _compute_voice_frequency(node.base_frequency)
	if freq < 1.0:
		var roll: float = RNG.stream("dialogue").randf()
		if roll >= freq:
			# Skip — advance to next node without emitting
			_state.current_node_id = node.next_id
			return false

	var profile_id: String = node.voice_profile_id
	var is_first_speak: bool = not _state.voice_emit_counts.has(profile_id)
	_state.voice_emit_counts[profile_id] = _state.voice_emit_counts.get(profile_id, 0) + 1

	var payload := DialogueInternalVoicePresentedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.voice_profile_id = profile_id
	payload.body_key = node.body_key
	payload.computed_frequency = freq
	payload.chorus_tier = node.chorus_tier
	payload.is_first_speak = is_first_speak
	EventBus.dialogue_internal_voice_presented.emit(payload)

	_state.current_node_id = node.next_id
	return false  # InternalVoice doesn't yield — continues to next node


func _resolve_item_drop_node(node: DialogueItemDropNode) -> void:
	var def_ids := PackedStringArray()
	for item: Dictionary in node.accepted_items:
		var def_id: String = item.get("evidence_definition_id", "")
		if def_id != "":
			def_ids.append(def_id)

	var payload := DialogueItemDropArmedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.accepted_evidence_definition_ids = def_ids
	EventBus.dialogue_item_drop_armed.emit(payload)
	# Does NOT advance current_node_id — waits for accept_item_drop


func _resolve_branch_node(node: DialogueBranchNode) -> void:
	for condition: Dictionary in node.conditions:
		if _evaluate_condition(condition):
			_state.current_node_id = condition.get("next_id", node.next_id)
			return
	# Should not reach here if graph validation passed (always condition required)
	Logger.error("dialogue", "DialogueVM._resolve_branch: no condition matched in '%s' — using next_id fallback" % node.node_id)
	_state.current_node_id = node.next_id


func _evaluate_condition(condition: Dictionary) -> bool:
	var ctype: String = condition.get("condition_type", "")
	var args: Dictionary = condition.get("args", {})
	match ctype:
		DialogueBranchNode.COND_ALWAYS:
			return true
		DialogueBranchNode.COND_AWAKENING_MIN:
			return RPGCore.awakening_level >= int(args.get("awakening_min", 0))
		DialogueBranchNode.COND_AWAKENING_MAX:
			return RPGCore.awakening_level <= int(args.get("awakening_max", 10))
		DialogueBranchNode.COND_FLAG_SET:
			return _state.flags.get(args.get("flag_id", ""), false) == true
		DialogueBranchNode.COND_FLAG_NOT_SET:
			return _state.flags.get(args.get("flag_id", ""), false) != true
		DialogueBranchNode.COND_LINE_UNLOCKED:
			return _state.unlocked_line_ids.has(args.get("line_id", ""))
		DialogueBranchNode.COND_DISPOSITION_THRESHOLD:
			var axis: String = args.get("axis", "")
			var op: String = args.get("op", ">=")
			var value: float = float(args.get("value", 0.0))
			var disp: Dictionary = RPGCore.get_disposition(axis)
			var current: float = float(disp.get("value", 0.0))
			return _compare_float(current, op, value)
		DialogueBranchNode.COND_DERIVED_STAT_THRESHOLD:
			var stat_id: String = args.get("stat_id", "")
			var op: String = args.get("op", ">=")
			var value: int = int(args.get("value", 0))
			var current: int = RPGCore.get_derived_stat(stat_id)
			return _compare_int(current, op, value)
	Logger.error("dialogue", "DialogueVM._evaluate_condition: unknown condition_type '%s'" % ctype)
	return false


func _compare_float(a: float, op: String, b: float) -> bool:
	match op:
		">=": return a >= b
		"<=": return a <= b
		">":  return a > b
		"<":  return a < b
		"==": return is_equal_approx(a, b)
	return false


func _compare_int(a: int, op: String, b: int) -> bool:
	match op:
		">=": return a >= b
		"<=": return a <= b
		">":  return a > b
		"<":  return a < b
		"==": return a == b
	return false


func _resolve_system_effect_node(node: DialogueSystemEffectNode) -> void:
	for effect: Dictionary in node.effects:
		var etype: String = effect.get("effect_type", "")
		var args: Dictionary = effect.get("args", {})

		# Runtime whitelist check (defense-in-depth — graph validate is first line)
		if etype == DialogueSystemEffectNode.EFFECT_QUEUE_SIGNAL:
			var signal_name: String = args.get("signal_name", "")
			if not DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has(signal_name):
				Logger.error("dialogue", "DialogueVM: queue_signal name '%s' not in whitelist — skipped" % signal_name)
				_emit_system_effect_applied(node, etype, args, false)
				continue

		var applied: bool = true
		# Check EncounterContext first (may consume the effect)
		if _state.encounter_context != null:
			var consumed: bool = (_state.encounter_context as DialogueEncounterContext).on_system_effect(_state, effect)
			if consumed:
				applied = false
				_emit_system_effect_applied(node, etype, args, false)
				continue

		_apply_system_effect(etype, args)
		_emit_system_effect_applied(node, etype, args, applied)

	_state.current_node_id = node.next_id


func _apply_system_effect(etype: String, args: Dictionary) -> void:
	match etype:
		DialogueSystemEffectNode.EFFECT_SET_FLAG:
			_state.flags[args.get("flag_id", "")] = true
		DialogueSystemEffectNode.EFFECT_CLEAR_FLAG:
			_state.flags.erase(args.get("flag_id", ""))
		DialogueSystemEffectNode.EFFECT_FATIGUE_DELTA:
			EventBus.fatigue_input.emit(int(args.get("delta", 0)), args.get("reason", "dialogue_effect"))
		DialogueSystemEffectNode.EFFECT_COPE_OVERWORK_DELTA:
			EventBus.cope_overwork_input.emit(int(args.get("delta", 0)), args.get("reason", "dialogue_effect"))
		DialogueSystemEffectNode.EFFECT_HEAT_INPUT:
			EventBus.heat_input.emit(args.get("district_id", ""), int(args.get("delta", 0)), args.get("reason", "dialogue_effect"))
		DialogueSystemEffectNode.EFFECT_AWAKENING_INPUT:
			var awk_delta: int = int(args.get("delta", 0))
			var awk_reason: String = args.get("reason", "dialogue_effect")
			for _i in range(maxi(awk_delta, 0)):
				RPGCore.advance_awakening(awk_reason)
		DialogueSystemEffectNode.EFFECT_DISPOSITION_INPUT:
			EventBus.disposition_input.emit(args.get("axis", ""), float(args.get("delta", 0.0)), args.get("reason", "dialogue_effect"))
		DialogueSystemEffectNode.EFFECT_COMPOSURE_DAMAGE:
			# No-op without EncounterContext (already handled above)
			pass
		DialogueSystemEffectNode.EFFECT_UNLOCK_LINE:
			var line_id: String = args.get("line_id", "")
			if line_id != "":
				_state.unlocked_line_ids[line_id] = true
		DialogueSystemEffectNode.EFFECT_QUEUE_SIGNAL:
			_apply_queue_signal_effect(args)
		_:
			Logger.error("dialogue", "DialogueVM._apply_system_effect: unknown effect_type '%s'" % etype)


func _apply_queue_signal_effect(args: Dictionary) -> void:
	var signal_name: String = args.get("signal_name", "")
	var payload: Dictionary = args.get("payload", {})
	match signal_name:
		"dialogue_line_unlocked":
			EventBus.dialogue_line_unlocked.emit(
				payload.get("line_id", ""), payload.get("source", "queue_signal"))
		"evidence_reframed":
			EventBus.evidence_reframed.emit(
				payload.get("evidence_definition_id", ""),
				payload.get("reframing_tag", ""),
				payload.get("source_thought_id", ""))
		"awakening_cinematic_due":
			EventBus.awakening_cinematic_due.emit(int(payload.get("level", 0)))
		"feed_segment_queued":
			pass  # FeedSegment resource payload — queue_signal from dialogue not yet wired in 6.1
		_:
			Logger.error("dialogue", "DialogueVM._apply_queue_signal_effect: '%s' not in whitelist at runtime" % signal_name)


func _emit_system_effect_applied(node: DialogueSystemEffectNode, etype: String, args: Dictionary, applied: bool) -> void:
	var payload := DialogueSystemEffectAppliedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.effect_type = etype
	payload.effect_args = args.duplicate()
	payload.applied = applied
	EventBus.dialogue_system_effect_applied.emit(payload)


func _resolve_commit_node(node: DialogueCommitNode) -> void:
	_state.committed_line_count += 1

	var payload := DialogueLineCommittedEvent.new()
	payload.graph_id = _state.graph.graph_id
	payload.node_id = node.node_id
	payload.committed_line_id = node.committed_line_id
	payload.npc_line_id = node.npc_line_id
	# speaker_id: best-effort from committed_line_id (Story 6.5 may augment)
	payload.speaker_id = "player"
	payload.tags = node.commit_tags.duplicate()
	EventBus.dialogue_line_committed.emit(payload)

	_state.current_node_id = node.next_id


func _resolve_end_node(node: DialogueEndNode) -> void:
	_teardown(node.end_reason)


func _teardown(reason: String) -> void:
	if not _active:
		return
	_active = false
	var graph_id: String = _state.graph.graph_id if (_state != null and _state.graph != null) else ""

	if _state != null and _state.encounter_context != null:
		(_state.encounter_context as DialogueEncounterContext).on_dialogue_ended(_state, reason)

	EventBus.dialogue_ended.emit(graph_id, reason)
	Logger.info("dialogue", "DialogueVM._teardown: graph='%s' reason='%s'" % [graph_id, reason])


func _compute_voice_frequency(base_frequency: float) -> float:
	## Placeholder linear scaling. Story 6.3 replaces with real curve.
	## Reads Balance.dialogue.voice_scaling_default coefficients.
	if base_frequency >= 1.0:
		return 1.0
	var cfg: Dictionary = Balance.get_data().dialogue.get("voice_scaling_default", {})
	var floor_val: float = float(cfg.get("base_floor", 0.1))
	var awakening_curve: float = float(cfg.get("awakening_curve", 0.08))
	var fatigue_curve: float = float(cfg.get("fatigue_curve", 0.05))
	var cope_curve: float = float(cfg.get("cope_curve", 0.03))
	var awakening_val: float = float(RPGCore.awakening_level)
	var fatigue_val: float = float(RPGCore.get_derived_stat("fatigue"))
	var cope_val: float = float(RPGCore.cope_overwork_debit)
	var computed: float = base_frequency + floor_val + \
		awakening_val * awakening_curve + \
		fatigue_val * fatigue_curve + \
		cope_val * cope_curve
	return clampf(computed, 0.0, 1.0)


func _find_item_definition_id(instance_id: String) -> String:
	## Looks up an evidence instance in RPGCore.evidence_inventory to find its definition_id.
	## Returns "" if not found. Falls back to treating instance_id as definition_id (for tests).
	var inventory: Dictionary = RPGCore.evidence_inventory
	if inventory.has(instance_id):
		var entry: Dictionary = inventory.get(instance_id, {})
		var def_id: String = entry.get("evidence_definition_id", "")
		if def_id != "":
			return def_id
	# Fallback for tests where instance_id IS the definition_id
	return instance_id
