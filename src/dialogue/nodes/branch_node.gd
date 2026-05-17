class_name DialogueBranchNode extends DialogueNode

## Story 6.1 — Dialogue Branch node: evaluates a closed-enum condition list, routes to first match.
## LOCKED: no GDScript expression evaluation. Use set_flag + flag_set for custom conditions.

const COND_AWAKENING_MIN: String          = "awakening_min"
const COND_AWAKENING_MAX: String          = "awakening_max"
const COND_FLAG_SET: String               = "flag_set"
const COND_FLAG_NOT_SET: String           = "flag_not_set"
const COND_LINE_UNLOCKED: String          = "line_unlocked"
const COND_DISPOSITION_THRESHOLD: String  = "disposition_threshold"
const COND_DERIVED_STAT_THRESHOLD: String = "derived_stat_threshold"
const COND_ALWAYS: String                 = "always"

const ALL_CONDITIONS: Array[String] = [
	COND_AWAKENING_MIN, COND_AWAKENING_MAX, COND_FLAG_SET, COND_FLAG_NOT_SET,
	COND_LINE_UNLOCKED, COND_DISPOSITION_THRESHOLD, COND_DERIVED_STAT_THRESHOLD,
	COND_ALWAYS,
]

# Each entry: {condition_type, args: Dictionary, next_id}.
# Evaluated top-to-bottom; first match wins. COND_ALWAYS must appear last.
@export var conditions: Array[Dictionary] = []


func _init() -> void:
	node_type = TYPE_BRANCH
