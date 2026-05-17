class_name DialogueCommitNode extends DialogueNode

## Story 6.1 — Dialogue Commit node: records the player's chosen line into the Conversation Log.
## Sole emitter of EventBus.dialogue_line_committed. Story 6.5 subscribes as the log writer.

@export var committed_line_id: String = ""
@export var npc_line_id: String = ""
@export var commit_tags: PackedStringArray = PackedStringArray()


func _init() -> void:
	node_type = TYPE_COMMIT
