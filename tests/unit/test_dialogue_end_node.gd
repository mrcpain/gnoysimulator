extends GutTest

## Story 6.1 — Unit tests for DialogueEndNode Resource schema.


func test_end_node_default_node_type() -> void:
	var node := DialogueEndNode.new()
	assert_eq(node.node_type, "end")


func test_end_node_default_end_reason() -> void:
	var node := DialogueEndNode.new()
	assert_eq(node.end_reason, "normal")


func test_end_node_valid_reasons() -> void:
	var valid_reasons := ["normal", "interrupted", "composure_failure", "player_exit"]
	for reason in valid_reasons:
		var node := DialogueEndNode.new()
		node.end_reason = reason
		assert_eq(node.end_reason, reason)
