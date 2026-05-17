class_name DialogueSystemEffectAppliedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_system_effect_applied.
## Sole writer: DialogueVM._resolve_system_effect_node (after each effect is applied/dispatched).
## applied=false when an EncounterContext consumed the effect (Story 6.6 path).

@export var graph_id: String = ""
@export var node_id: String = ""
@export var effect_type: String = ""
@export var effect_args: Dictionary = {}
@export var applied: bool = true
