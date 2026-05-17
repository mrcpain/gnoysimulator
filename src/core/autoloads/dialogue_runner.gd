extends Node

## Story 6.1 — DialogueRunner autoload: thin facade over DialogueVM.
## Architecture locked rule 6: one VM instance; no special-case code paths.
## Callers MUST NOT mutate the underlying DialogueVM instance.
## Only tests may read _vm internals via runtime_state().

var _vm: DialogueVM = null
var _offline_unlocks: Dictionary = {}  # {line_id: source} — stashed while VM inactive


func _ready() -> void:
	_vm = DialogueVM.new()
	EventBus.dialogue_line_unlocked.connect(_on_dialogue_line_unlocked)
	Logger.info("dialogue", "DialogueRunner ready — VM facade active (Story 6.1).")


func start_dialogue(graph_id: String, encounter_context: RefCounted = null) -> bool:
	var graph: DialogueGraph = DialogueCatalog.get_graph(graph_id)
	if graph == null:
		Logger.error("dialogue", "DialogueRunner.start_dialogue: graph_id '%s' not found in catalog" % graph_id)
		return false

	# Pass offline unlocks into start() so they are seeded BEFORE dialogue_started fires (AC5)
	var ok: bool = _vm.start(graph, encounter_context, _offline_unlocks)
	if ok:
		_offline_unlocks.clear()

	return ok


func submit_choice(choice_id: String) -> bool:
	return _vm.submit_choice(choice_id)


func accept_item_drop(instance_id: String) -> bool:
	return _vm.accept_item_drop(instance_id)


func interrupt(reason: String) -> void:
	_vm.interrupt(reason)


func attach_encounter_context(ctx: RefCounted) -> void:
	_vm.attach_encounter_context(ctx)


func is_active() -> bool:
	return _vm.is_active()


func current_node_id() -> String:
	return _vm.current_node_id()


func current_graph_id() -> String:
	return _vm.current_graph_id()


func runtime_state() -> DialogueRuntimeState:
	return _vm.runtime_state()


func _on_dialogue_line_unlocked(line_id: String, source: String) -> void:
	if _vm.is_active() and _vm.runtime_state() != null:
		_vm.runtime_state().unlocked_line_ids[line_id] = true
	else:
		_offline_unlocks[line_id] = source
