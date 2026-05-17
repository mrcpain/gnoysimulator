class_name DialogueChoicePresentedEvent extends Resource

## Story 6.1 — Payload for EventBus.dialogue_choice_presented.
## Sole writer: DialogueVM._resolve_choice_node.
## choices entries contain display-only fields — no outcome leakage (FR55).

@export var graph_id: String = ""
@export var node_id: String = ""
@export var choices: Array[Dictionary] = []
