extends GutTest

## Story 6.1 — Unit tests for DialogueChoiceNode Resource schema.


func test_choice_node_default_node_type() -> void:
	var node := DialogueChoiceNode.new()
	assert_eq(node.node_type, "choice")


func test_choice_node_gate_constants_present() -> void:
	assert_eq(DialogueChoiceNode.GATE_NONE, "none")
	assert_eq(DialogueChoiceNode.GATE_SKILL_CHECK, "skill_check")
	assert_eq(DialogueChoiceNode.GATE_AWAKENING_MIN, "awakening_min")
	assert_eq(DialogueChoiceNode.GATE_TALENT_UNLOCKED, "talent_unlocked")
	assert_eq(DialogueChoiceNode.GATE_ITEM_REQUIRED, "item_required")
	assert_eq(DialogueChoiceNode.GATE_LINE_UNLOCKED, "line_unlocked")


func test_choice_node_all_gates_count() -> void:
	assert_eq(DialogueChoiceNode.ALL_GATES.size(), 6, "ALL_GATES must have exactly 6 entries")


func test_choice_node_choices_default_empty() -> void:
	var node := DialogueChoiceNode.new()
	assert_eq(node.choices.size(), 0)


func test_choice_node_choices_shape() -> void:
	var node := DialogueChoiceNode.new()
	node.choices = [
		{"choice_id": "c1", "body_key": "k1", "next_id": "n2",
		 "gate": "none", "gate_args": {}, "item_accepted": false},
	]
	assert_eq(node.choices.size(), 1)
	assert_eq(node.choices[0].get("gate"), "none")
