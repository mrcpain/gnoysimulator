class_name DialogueLineCommittedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_line_committed.
## Sole writer: DialogueVM._resolve_commit_node.
## Primary subscriber: Story 6.5 (Conversation Log append path — this is the contract handoff).

@export var graph_id: String = ""
@export var node_id: String = ""
@export var committed_line_id: String = ""
@export var npc_line_id: String = ""
@export var speaker_id: String = ""
@export var tags: PackedStringArray = PackedStringArray()
