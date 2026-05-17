class_name DialogueChoiceNode extends DialogueNode

## Story 6.1 — Dialogue Choice node: presents the player a list of options.
## Gate constants are LOCKED — no new gate types without a new story.
## Visible-DC contract (FR55): skill_check gate surfaces display-only DC via RPGCore.preview_check.

const GATE_NONE: String           = "none"
const GATE_SKILL_CHECK: String    = "skill_check"
const GATE_AWAKENING_MIN: String  = "awakening_min"
const GATE_TALENT_UNLOCKED: String = "talent_unlocked"
const GATE_ITEM_REQUIRED: String  = "item_required"
const GATE_LINE_UNLOCKED: String  = "line_unlocked"

const ALL_GATES: Array[String] = [
	GATE_NONE, GATE_SKILL_CHECK, GATE_AWAKENING_MIN, GATE_TALENT_UNLOCKED,
	GATE_ITEM_REQUIRED, GATE_LINE_UNLOCKED,
]

# Each entry: {choice_id, body_key, next_id, gate, gate_args, item_accepted}
@export var choices: Array[Dictionary] = []


func _init() -> void:
	node_type = TYPE_CHOICE
