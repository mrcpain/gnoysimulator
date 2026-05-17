extends GutTest

## Story 6.1 — Unit tests for DialogueBranchNode Resource schema.


func test_branch_node_default_node_type() -> void:
	var node := DialogueBranchNode.new()
	assert_eq(node.node_type, "branch")


func test_branch_node_condition_constants_present() -> void:
	assert_eq(DialogueBranchNode.COND_AWAKENING_MIN, "awakening_min")
	assert_eq(DialogueBranchNode.COND_AWAKENING_MAX, "awakening_max")
	assert_eq(DialogueBranchNode.COND_FLAG_SET, "flag_set")
	assert_eq(DialogueBranchNode.COND_FLAG_NOT_SET, "flag_not_set")
	assert_eq(DialogueBranchNode.COND_LINE_UNLOCKED, "line_unlocked")
	assert_eq(DialogueBranchNode.COND_DISPOSITION_THRESHOLD, "disposition_threshold")
	assert_eq(DialogueBranchNode.COND_DERIVED_STAT_THRESHOLD, "derived_stat_threshold")
	assert_eq(DialogueBranchNode.COND_ALWAYS, "always")


func test_branch_node_all_conditions_count() -> void:
	assert_eq(DialogueBranchNode.ALL_CONDITIONS.size(), 8, "ALL_CONDITIONS must have exactly 8 entries")


func test_branch_node_conditions_default_empty() -> void:
	var node := DialogueBranchNode.new()
	assert_eq(node.conditions.size(), 0)


func test_branch_node_condition_shape() -> void:
	var node := DialogueBranchNode.new()
	node.conditions = [
		{"condition_type": "awakening_min", "args": {"awakening_min": 5}, "next_id": "n_a"},
		{"condition_type": "always", "args": {}, "next_id": "n_b"},
	]
	assert_eq(node.conditions.size(), 2)
	assert_eq(node.conditions[1].get("condition_type"), "always")
