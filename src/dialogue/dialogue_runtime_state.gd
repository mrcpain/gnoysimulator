class_name DialogueRuntimeState extends RefCounted

## Story 6.1 — Per-session ephemeral cursor and flag state for a running dialogue.
## NOT persisted. Per arch §3.9, dialogue cursor is ephemeral — cleared on dialogue end.
## Tests assert SaveGameV1 has zero dialogue_* fields (AC12).

var graph: DialogueGraph = null
var current_node_id: String = ""
var flags: Dictionary = {}
var voice_emit_counts: Dictionary = {}   # {voice_profile_id: int}
var unlocked_line_ids: Dictionary = {}   # {line_id: true}
var presented_choices: Array[Dictionary] = []
var encounter_context: RefCounted = null # null for normal dialogue; Story 6.6 sets ComposureEncounterContext
var committed_line_count: int = 0
var last_skill_check: Dictionary = {}    # most recent RPGCore.skill_check return — for tests + 6.6


func reset(new_graph: DialogueGraph) -> void:
	graph = new_graph
	current_node_id = new_graph.start_node_id if new_graph != null else ""
	flags = {}
	voice_emit_counts = {}
	unlocked_line_ids = {}
	presented_choices = []
	encounter_context = null
	committed_line_count = 0
	last_skill_check = {}


func current_node() -> DialogueNode:
	if graph == null:
		return null
	return graph.find_node(current_node_id)
