class_name DialogueItemDropArmedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_item_drop_armed.
## Sole writer: DialogueVM._resolve_item_drop_node.
## Subscribers: Story 6.4 (drag-drop UI arm). 6.1 only arms the signal.

@export var graph_id: String = ""
@export var node_id: String = ""
@export var accepted_evidence_definition_ids: PackedStringArray = PackedStringArray()
