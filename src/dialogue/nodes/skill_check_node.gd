class_name DialogueSkillCheckNode extends DialogueNode

## Story 6.1 — Dialogue SkillCheck node: calls RPGCore.skill_check exactly once, routes per outcome.
## outcome_next_ids keys: "critical", "success", "fail" — all three required by DialogueGraph.validate().

@export var skill_id: String = ""
@export var dc: int = 10
@export var modifier: int = 0
@export var stream_name: String = "dialogue"
# Keys: "critical" / "success" / "fail" → next_id String values.
@export var outcome_next_ids: Dictionary = {}


func _init() -> void:
	node_type = TYPE_SKILL_CHECK
