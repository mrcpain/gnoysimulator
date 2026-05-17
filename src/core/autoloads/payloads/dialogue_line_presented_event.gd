class_name DialogueLinePresentedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_line_presented.
## Sole writer: DialogueVM._resolve_line_node. Sole readers: Story 6.9 (UI),
## Story 6.3 (voice typography lookup for voice_profile_id).
## Tags are surfaced as a frozen copy — subscribers MUST NOT mutate.

@export var graph_id: String = ""
@export var node_id: String = ""
@export var speaker_id: String = ""
@export var body_key: String = ""
@export var voice_profile_id: String = ""
@export var tags: PackedStringArray = PackedStringArray()
