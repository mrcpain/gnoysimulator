class_name DialogueSystemEffectNode extends DialogueNode

## Story 6.1 — Dialogue SystemEffect node: applies a list of closed-enum effects.
## Input-class effects route through EventBus single-writer channels (locked rule 11).
## EFFECT_QUEUE_SIGNAL has a LOCKED whitelist — expansion requires a new story.

const EFFECT_SET_FLAG: String            = "set_flag"
const EFFECT_CLEAR_FLAG: String          = "clear_flag"
const EFFECT_FATIGUE_DELTA: String       = "fatigue_delta"
const EFFECT_COPE_OVERWORK_DELTA: String = "cope_overwork_delta"
const EFFECT_HEAT_INPUT: String          = "heat_input"
const EFFECT_AWAKENING_INPUT: String     = "awakening_input"
const EFFECT_DISPOSITION_INPUT: String   = "disposition_input"
const EFFECT_COMPOSURE_DAMAGE: String    = "composure_damage"
const EFFECT_UNLOCK_LINE: String         = "unlock_line"
const EFFECT_QUEUE_SIGNAL: String        = "queue_signal"

const ALL_EFFECTS: Array[String] = [
	EFFECT_SET_FLAG, EFFECT_CLEAR_FLAG, EFFECT_FATIGUE_DELTA, EFFECT_COPE_OVERWORK_DELTA,
	EFFECT_HEAT_INPUT, EFFECT_AWAKENING_INPUT, EFFECT_DISPOSITION_INPUT,
	EFFECT_COMPOSURE_DAMAGE, EFFECT_UNLOCK_LINE, EFFECT_QUEUE_SIGNAL,
]

# Locked whitelist for EFFECT_QUEUE_SIGNAL.signal_name values.
const QUEUE_SIGNAL_WHITELIST: Array[String] = [
	"dialogue_line_unlocked",
	"evidence_reframed",
	"awakening_cinematic_due",
	"feed_segment_queued",
]

# Each entry: {effect_type, args: Dictionary}
@export var effects: Array[Dictionary] = []


func _init() -> void:
	node_type = TYPE_SYSTEM_EFFECT
