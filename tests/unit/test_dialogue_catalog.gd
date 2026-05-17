extends GutTest

## Story 6.1 — Unit tests for DialogueCatalog catalog shape.
## Mirrors test_evidence_catalog.gd structure.


func test_catalog_has_fixture_graph() -> void:
	assert_true(DialogueCatalog.has_graph("dialogue_vm_test_fixture"),
		"Catalog must contain the VS fixture graph (AC10)")


func test_catalog_get_graph_returns_non_null() -> void:
	var g := DialogueCatalog.get_graph("dialogue_vm_test_fixture")
	assert_not_null(g, "get_graph must return a DialogueGraph for fixture")


func test_catalog_get_graph_id_matches() -> void:
	var g := DialogueCatalog.get_graph("dialogue_vm_test_fixture")
	assert_eq(g.graph_id, "dialogue_vm_test_fixture")


func test_catalog_get_unknown_returns_null() -> void:
	assert_null(DialogueCatalog.get_graph("totally_not_a_real_graph_xyzzy"))


func test_catalog_all_graphs_non_empty() -> void:
	var all := DialogueCatalog.all_graphs()
	assert_gte(all.size(), 1, "all_graphs must return at least 1 graph (the fixture)")


func test_catalog_validate_passes() -> void:
	assert_true(DialogueCatalog.validate(), "DialogueCatalog.validate() must pass for all loaded graphs")
