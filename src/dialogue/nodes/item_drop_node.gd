class_name DialogueItemDropNode extends DialogueNode

## Story 6.1 — Dialogue ItemDrop node: awaits the player dropping a specific evidence item.
## VM exposes DialogueRunner.accept_item_drop(instance_id) -> bool.
## Drag-drop UI is Story 6.4's scope; 6.1 only exposes the API and emits signals.

# Each entry: {evidence_definition_id, next_id, consume_on_accept: bool, reaction_line_id: String}
@export var accepted_items: Array[Dictionary] = []


func _init() -> void:
	node_type = TYPE_ITEM_DROP
