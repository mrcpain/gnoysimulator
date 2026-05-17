class_name DialogueLineNode extends DialogueNode

## Story 6.1 — Dialogue Line node: spoken text from an NPC or narrator.
## Sole emitter on EventBus.dialogue_line_presented (via DialogueVM._resolve_line_node).

@export var speaker_id: String = ""
@export var body_key: String = ""
@export var tags: PackedStringArray = PackedStringArray()
@export var voice_profile_id: String = ""


func _init() -> void:
	node_type = TYPE_LINE
