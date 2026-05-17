class_name DialogueEncounterContext extends RefCounted

## Story 6.1 — Abstract base for dialogue-as-combat encounter contexts.
## Story 6.6 subclasses as ComposureEncounterContext (multi-stage Composure HP).
## Architecture locked rule 6: the DialogueVM is the only runtime for dialogue;
## boss encounters attach a context, they do NOT use a separate VM.
##
## The five lifecycle methods default to no-op (or null return) so an attached
## context can selectively override only what it needs.

func on_dialogue_started(state: DialogueRuntimeState) -> void:
	pass


func on_node_entered(state: DialogueRuntimeState, node: DialogueNode) -> void:
	pass


func on_system_effect(state: DialogueRuntimeState, effect: Dictionary) -> bool:
	## Return true to CONSUME (skip default VM handling).
	## Composure damage example: ComposureEncounterContext intercepts
	## effect_type == "composure_damage" and reduces HP.
	return false


func on_dialogue_ended(state: DialogueRuntimeState, reason: String) -> void:
	pass


func should_interrupt(state: DialogueRuntimeState) -> Variant:
	## Return a Dictionary {end_reason: String} to force interrupt;
	## null to continue normally. Polled after every node resolution.
	return null
