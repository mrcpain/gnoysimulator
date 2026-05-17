class_name DialogueCatalog extends RefCounted

## Story 6.1 — Pure-static catalog of DialogueGraph instances.
## Mirrors EvidenceCatalog shape line-for-line.
## Source: src/dialogue/data/dialogue_index.tres (DialogueIndexResource).

static var _resource: DialogueIndexResource = preload("res://src/dialogue/data/dialogue_index.tres")
static var _catalog: Dictionary = {}        # {graph_id: DialogueGraph}
static var _ordered_ids: Array[String] = []
static var _cache_built: bool = false


static func _build_cache() -> void:
	if _cache_built:
		return
	_catalog = {}
	_ordered_ids = []
	if _resource == null:
		return
	for graph: DialogueGraph in _resource.graphs:
		if graph == null:
			continue
		if _catalog.has(graph.graph_id):
			push_warning("DialogueCatalog._build_cache: duplicate graph_id '%s' — earlier entry overwritten" % graph.graph_id)
			_catalog[graph.graph_id] = graph
			continue
		_catalog[graph.graph_id] = graph
		_ordered_ids.append(graph.graph_id)
	_cache_built = true


static func get_graph(graph_id: String) -> DialogueGraph:
	_build_cache()
	return _catalog.get(graph_id, null)


static func has_graph(graph_id: String) -> bool:
	_build_cache()
	return _catalog.has(graph_id)


static func all_graphs() -> Array[DialogueGraph]:
	_build_cache()
	var out: Array[DialogueGraph] = []
	for gid: String in _ordered_ids:
		var g: DialogueGraph = _catalog.get(gid, null)
		if g != null:
			out.append(g)
	return out


static func ordered_graph_ids() -> Array[String]:
	_build_cache()
	return _ordered_ids.duplicate()


static func validate() -> bool:
	if _resource == null:
		push_warning("DialogueCatalog.validate: dialogue_index.tres failed to preload — catalog is null")
		return false
	_build_cache()
	var ok := true
	var seen: Dictionary = {}
	for graph: DialogueGraph in _resource.graphs:
		if graph == null:
			push_warning("DialogueCatalog.validate: null entry in dialogue_index.tres graphs array")
			ok = false
			continue
		if seen.has(graph.graph_id):
			push_warning("DialogueCatalog.validate: duplicate graph_id '%s'" % graph.graph_id)
			ok = false
			continue
		seen[graph.graph_id] = true
		if not graph.validate():
			push_warning("DialogueCatalog.validate: graph '%s' failed validation" % graph.graph_id)
			ok = false
	return ok
