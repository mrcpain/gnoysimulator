extends GutTest

## Story 6.1 — Unit tests for DialogueSkillCheckNode Resource schema.


func test_skill_check_node_default_node_type() -> void:
	var node := DialogueSkillCheckNode.new()
	assert_eq(node.node_type, "skill_check")


func test_skill_check_node_default_fields() -> void:
	var node := DialogueSkillCheckNode.new()
	assert_eq(node.dc, 10)
	assert_eq(node.modifier, 0)
	assert_eq(node.stream_name, "dialogue")
	assert_eq(node.outcome_next_ids.size(), 0)


func test_skill_check_node_outcome_keys() -> void:
	var node := DialogueSkillCheckNode.new()
	node.outcome_next_ids = {"critical": "n_a", "success": "n_b", "fail": "n_c"}
	assert_eq(node.outcome_next_ids.get("critical"), "n_a")
	assert_eq(node.outcome_next_ids.get("success"), "n_b")
	assert_eq(node.outcome_next_ids.get("fail"), "n_c")


func test_skill_check_node_skill_id_set() -> void:
	var node := DialogueSkillCheckNode.new()
	node.skill_id = "yap_game"
	assert_eq(node.skill_id, "yap_game")
