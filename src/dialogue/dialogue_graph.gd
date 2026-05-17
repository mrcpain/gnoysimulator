class_name DialogueGraph extends Resource

## Story 6.1 — On-disk .dialog.tres representation of a dialogue graph.
## DialogueCatalog.validate() calls validate() on every loaded graph at boot.

@export var graph_id: String = ""
@export var tier: String = ""
@export var start_node_id: String = ""
@export var nodes: Array[DialogueNode] = []
@export var participants: PackedStringArray = PackedStringArray()


func find_node(node_id: String) -> DialogueNode:
	for node: DialogueNode in nodes:
		if node != null and node.node_id == node_id:
			return node
	return null


func validate() -> bool:
	if graph_id.strip_edges() == "":
		push_warning("DialogueGraph.validate: graph_id is blank")
		return false

	# Check for duplicate or blank node_ids
	var seen_ids: Dictionary = {}
	for node: DialogueNode in nodes:
		if node == null:
			push_warning("DialogueGraph.validate [%s]: null node in nodes array" % graph_id)
			return false
		if node.node_id.strip_edges() == "":
			push_warning("DialogueGraph.validate [%s]: node has blank node_id" % graph_id)
			return false
		if seen_ids.has(node.node_id):
			push_warning("DialogueGraph.validate [%s]: duplicate node_id '%s'" % [graph_id, node.node_id])
			return false
		seen_ids[node.node_id] = true
		if not DialogueNode.ALL_NODE_TYPES.has(node.node_type):
			push_warning("DialogueGraph.validate [%s]: node '%s' has unknown node_type '%s'" % [graph_id, node.node_id, node.node_type])
			return false

	# Check start_node_id exists
	if start_node_id.strip_edges() == "":
		push_warning("DialogueGraph.validate [%s]: start_node_id is blank" % graph_id)
		return false
	if find_node(start_node_id) == null:
		push_warning("DialogueGraph.validate [%s]: start_node_id '%s' not found" % [graph_id, start_node_id])
		return false

	# Check for dangling next_ids and node-specific validation
	for node: DialogueNode in nodes:
		if node == null:
			continue
		if not _validate_node(node, seen_ids):
			return false

	return true


func _validate_node(node: DialogueNode, seen_ids: Dictionary) -> bool:
	# Validate next_id if non-empty (empty next_id is allowed for End nodes and choice-routed nodes)
	if node.next_id != "" and not seen_ids.has(node.next_id):
		push_warning("DialogueGraph.validate [%s]: node '%s' has dangling next_id '%s'" % [graph_id, node.node_id, node.next_id])
		return false

	match node.node_type:
		DialogueNode.TYPE_CHOICE:
			return _validate_choice_node(node as DialogueChoiceNode, seen_ids)
		DialogueNode.TYPE_SKILL_CHECK:
			return _validate_skill_check_node(node as DialogueSkillCheckNode, seen_ids)
		DialogueNode.TYPE_BRANCH:
			return _validate_branch_node(node as DialogueBranchNode, seen_ids)
		DialogueNode.TYPE_SYSTEM_EFFECT:
			return _validate_system_effect_node(node as DialogueSystemEffectNode)
	return true


func _validate_choice_node(node: DialogueChoiceNode, seen_ids: Dictionary) -> bool:
	for choice: Dictionary in node.choices:
		var next: String = choice.get("next_id", "")
		if next != "" and not seen_ids.has(next):
			push_warning("DialogueGraph.validate [%s]: choice node '%s' choice '%s' has dangling next_id '%s'" % [graph_id, node.node_id, choice.get("choice_id", "?"), next])
			return false
		var gate: String = choice.get("gate", DialogueChoiceNode.GATE_NONE)
		if not DialogueChoiceNode.ALL_GATES.has(gate):
			push_warning("DialogueGraph.validate [%s]: choice '%s' has unknown gate '%s'" % [graph_id, node.node_id, gate])
			return false
		if gate == DialogueChoiceNode.GATE_SKILL_CHECK:
			var gate_args: Dictionary = choice.get("gate_args", {})
			if not gate_args.has("skill_id"):
				push_warning("DialogueGraph.validate [%s]: choice '%s' skill_check gate missing skill_id" % [graph_id, node.node_id])
				return false
	return true


func _validate_skill_check_node(node: DialogueSkillCheckNode, seen_ids: Dictionary) -> bool:
	for outcome_key in ["critical", "success", "fail"]:
		var next: String = node.outcome_next_ids.get(outcome_key, "")
		if next != "" and not seen_ids.has(next):
			push_warning("DialogueGraph.validate [%s]: skill_check '%s' outcome '%s' has dangling next_id '%s'" % [graph_id, node.node_id, outcome_key, next])
			return false
	return true


func _validate_branch_node(node: DialogueBranchNode, seen_ids: Dictionary) -> bool:
	if node.conditions.is_empty():
		push_warning("DialogueGraph.validate [%s]: branch node '%s' has no conditions" % [graph_id, node.node_id])
		return false
	var has_terminal_always := false
	for i: int in range(node.conditions.size()):
		var cond: Dictionary = node.conditions[i]
		var ctype: String = cond.get("condition_type", "")
		if not DialogueBranchNode.ALL_CONDITIONS.has(ctype):
			push_warning("DialogueGraph.validate [%s]: branch '%s' has unknown condition_type '%s'" % [graph_id, node.node_id, ctype])
			return false
		var next: String = cond.get("next_id", "")
		if next != "" and not seen_ids.has(next):
			push_warning("DialogueGraph.validate [%s]: branch '%s' condition has dangling next_id '%s'" % [graph_id, node.node_id, next])
			return false
		if ctype == DialogueBranchNode.COND_ALWAYS:
			if i != node.conditions.size() - 1:
				push_warning("DialogueGraph.validate [%s]: branch '%s' has non-terminal 'always' condition (must be last)" % [graph_id, node.node_id])
				return false
			has_terminal_always = true
	if not has_terminal_always:
		push_warning("DialogueGraph.validate [%s]: branch node '%s' missing terminal 'always' condition" % [graph_id, node.node_id])
		return false
	return true


func _validate_system_effect_node(node: DialogueSystemEffectNode) -> bool:
	for effect: Dictionary in node.effects:
		var etype: String = effect.get("effect_type", "")
		if not DialogueSystemEffectNode.ALL_EFFECTS.has(etype):
			push_warning("DialogueGraph.validate [%s]: system_effect '%s' has unknown effect_type '%s'" % [graph_id, node.node_id, etype])
			return false
		if etype == DialogueSystemEffectNode.EFFECT_QUEUE_SIGNAL:
			var signal_name: String = effect.get("args", {}).get("signal_name", "")
			if not DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has(signal_name):
				push_warning("DialogueGraph.validate [%s]: system_effect '%s' queue_signal name '%s' not in whitelist" % [graph_id, node.node_id, signal_name])
				return false
	return true
