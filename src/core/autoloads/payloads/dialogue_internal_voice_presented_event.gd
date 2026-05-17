class_name DialogueInternalVoicePresentedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_internal_voice_presented.
## Sole writer: DialogueVM._resolve_internal_voice_node.
## Subscribers: Story 6.3 (voice typography + flourish), Story 6.9 (right-pane chorus area).

@export var graph_id: String = ""
@export var node_id: String = ""
@export var voice_profile_id: String = ""
@export var body_key: String = ""
@export var computed_frequency: float = 1.0
@export var chorus_tier: String = "quiet"
@export var is_first_speak: bool = false
