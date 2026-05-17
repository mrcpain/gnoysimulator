class_name DialogueInternalVoiceNode extends DialogueNode

## Story 6.1 — Dialogue InternalVoice node: stochastic Inner Voice interjection.
## base_frequency=1.0 guarantees emission (deterministic); <1.0 is a probability roll.
## Enforcement of voice_cap_per_dialogue is Story 6.3's contract; 6.1 records emit counts only.

@export var voice_profile_id: String = ""
@export var body_key: String = ""
@export var base_frequency: float = 1.0
@export var chorus_tier: String = "quiet"
# chorus_tier values: "quiet" / "interjecting" / "chorus" / "full_chorus"
# Story 6.3 enforces the render differences; 6.1 passes this through as payload.


func _init() -> void:
	node_type = TYPE_INTERNAL_VOICE
