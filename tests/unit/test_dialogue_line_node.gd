extends GutTest

## Story 6.1 — Unit tests for DialogueLineNode Resource schema.


func test_line_node_default_node_type() -> void:
	var node := DialogueLineNode.new()
	assert_eq(node.node_type, "line", "LineNode must default node_type to 'line'")


func test_line_node_fields_default_empty() -> void:
	var node := DialogueLineNode.new()
	assert_eq(node.speaker_id, "", "speaker_id must default to empty")
	assert_eq(node.body_key, "", "body_key must default to empty")
	assert_eq(node.voice_profile_id, "", "voice_profile_id must default to empty")
	assert_eq(node.tags.size(), 0, "tags must default to empty PackedStringArray")


func test_line_node_set_fields() -> void:
	var node := DialogueLineNode.new()
	node.node_id = "n_test"
	node.speaker_id = "npc_01"
	node.body_key = "dialogue.test.intro"
	node.tags = PackedStringArray(["quotable", "faction_relevant"])
	assert_eq(node.speaker_id, "npc_01")
	assert_eq(node.body_key, "dialogue.test.intro")
	assert_eq(node.tags.size(), 2)
	assert_true(node.tags.has("quotable"))


func test_line_node_type_in_all_node_types() -> void:
	assert_true(DialogueNode.ALL_NODE_TYPES.has(DialogueNode.TYPE_LINE))


func test_line_node_tags_are_frozen_copy_safe() -> void:
	var node := DialogueLineNode.new()
	node.tags = PackedStringArray(["a", "b"])
	var copy := node.tags.duplicate()
	copy.append("c")
	assert_eq(node.tags.size(), 2, "Modifying the copy must not affect original tags")
