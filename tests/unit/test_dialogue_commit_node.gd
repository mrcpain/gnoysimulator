extends GutTest

## Story 6.1 — Unit tests for DialogueCommitNode Resource schema.


func test_commit_node_default_node_type() -> void:
	var node := DialogueCommitNode.new()
	assert_eq(node.node_type, "commit")


func test_commit_node_default_fields() -> void:
	var node := DialogueCommitNode.new()
	assert_eq(node.committed_line_id, "")
	assert_eq(node.npc_line_id, "")
	assert_eq(node.commit_tags.size(), 0)


func test_commit_node_set_fields() -> void:
	var node := DialogueCommitNode.new()
	node.committed_line_id = "c_choice_1"
	node.npc_line_id = "n_line_intro"
	node.commit_tags = PackedStringArray(["quotable", "faction_relevant"])
	assert_eq(node.committed_line_id, "c_choice_1")
	assert_eq(node.commit_tags.size(), 2)
