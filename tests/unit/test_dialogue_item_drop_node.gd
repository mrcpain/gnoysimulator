extends GutTest

## Story 6.1 — Unit tests for DialogueItemDropNode Resource schema.


func test_item_drop_node_default_node_type() -> void:
	var node := DialogueItemDropNode.new()
	assert_eq(node.node_type, "item_drop")


func test_item_drop_node_accepted_items_default_empty() -> void:
	var node := DialogueItemDropNode.new()
	assert_eq(node.accepted_items.size(), 0)


func test_item_drop_node_accepted_item_shape() -> void:
	var node := DialogueItemDropNode.new()
	node.accepted_items = [{
		"evidence_definition_id": "passport_scan",
		"next_id": "n_next",
		"consume_on_accept": false,
		"reaction_line_id": "",
	}]
	assert_eq(node.accepted_items.size(), 1)
	assert_eq(node.accepted_items[0].get("evidence_definition_id"), "passport_scan")
	assert_false(node.accepted_items[0].get("consume_on_accept", true))
