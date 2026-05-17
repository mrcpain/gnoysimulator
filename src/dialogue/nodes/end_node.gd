class_name DialogueEndNode extends DialogueNode

## Story 6.1 — Dialogue End node: terminates the conversation and tears down runtime state.
## Sole emitter of EventBus.dialogue_ended (via DialogueVM._teardown).

@export var end_reason: String = "normal"
# Valid values: "normal" / "interrupted" / "composure_failure" / "player_exit"


func _init() -> void:
	node_type = TYPE_END
