extends GutTest

## Story 6.1 — Unit tests for DialogueGraph.validate() coverage.


func _make_minimal_graph() -> DialogueGraph:
	var g := DialogueGraph.new()
	g.graph_id = "test_graph"
	g.start_node_id = "n_start"
	var end := DialogueEndNode.new()
	end.node_id = "n_start"
	end.end_reason = "normal"
	g.nodes = [end]
	return g


func test_valid_minimal_graph_passes() -> void:
	var g := _make_minimal_graph()
	assert_true(g.validate(), "Minimal graph with valid End node must pass validate()")


func test_blank_graph_id_fails() -> void:
	var g := _make_minimal_graph()
	g.graph_id = ""
	assert_false(g.validate(), "Blank graph_id must fail validate()")


func test_missing_start_node_fails() -> void:
	var g := _make_minimal_graph()
	g.start_node_id = "n_nonexistent"
	assert_false(g.validate(), "Dangling start_node_id must fail validate()")


func test_blank_start_node_id_fails() -> void:
	var g := _make_minimal_graph()
	g.start_node_id = ""
	assert_false(g.validate(), "Blank start_node_id must fail validate()")


func test_duplicate_node_id_fails() -> void:
	var g := _make_minimal_graph()
	var extra := DialogueEndNode.new()
	extra.node_id = "n_start"
	extra.end_reason = "normal"
	g.nodes = [g.nodes[0], extra]
	assert_false(g.validate(), "Duplicate node_id must fail validate()")


func test_dangling_next_id_fails() -> void:
	var g := _make_minimal_graph()
	g.nodes[0].next_id = "n_nonexistent"
	assert_false(g.validate(), "Dangling next_id must fail validate()")


func test_unknown_node_type_fails() -> void:
	var g := _make_minimal_graph()
	g.nodes[0].node_type = "totally_invalid_type"
	assert_false(g.validate(), "Unknown node_type must fail validate()")


func test_branch_without_terminal_always_fails() -> void:
	var g := DialogueGraph.new()
	g.graph_id = "bad_branch"
	g.start_node_id = "n_branch"
	var branch := DialogueBranchNode.new()
	branch.node_id = "n_branch"
	# No always condition
	branch.conditions = [{"condition_type": "awakening_min", "args": {"awakening_min": 3}, "next_id": "n_end"}]
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [branch, end]
	assert_false(g.validate(), "Branch missing terminal 'always' must fail validate()")


func test_branch_non_terminal_always_fails() -> void:
	var g := DialogueGraph.new()
	g.graph_id = "bad_always"
	g.start_node_id = "n_branch"
	var branch := DialogueBranchNode.new()
	branch.node_id = "n_branch"
	# always is NOT last
	branch.conditions = [
		{"condition_type": "always", "args": {}, "next_id": "n_end"},
		{"condition_type": "awakening_min", "args": {"awakening_min": 1}, "next_id": "n_end"},
	]
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [branch, end]
	assert_false(g.validate(), "Non-terminal 'always' condition must fail validate()")


func test_branch_condition_empty_next_id_fails() -> void:
	var g := DialogueGraph.new()
	g.graph_id = "empty_next_id"
	g.start_node_id = "n_branch"
	var branch := DialogueBranchNode.new()
	branch.node_id = "n_branch"
	branch.conditions = [
		{"condition_type": "awakening_min", "args": {"awakening_min": 0}, "next_id": ""},
		{"condition_type": "always", "args": {}, "next_id": "n_end"},
	]
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [branch, end]
	assert_false(g.validate(), "Branch condition with empty next_id must fail validate()")


func test_choice_missing_skill_id_in_gate_args_fails() -> void:
	var g := DialogueGraph.new()
	g.graph_id = "bad_choice"
	g.start_node_id = "n_choice"
	var choice := DialogueChoiceNode.new()
	choice.node_id = "n_choice"
	choice.choices = [{"choice_id": "c1", "next_id": "n_end", "gate": "skill_check", "gate_args": {}}]
	var end := DialogueEndNode.new()
	end.node_id = "n_end"
	g.nodes = [choice, end]
	assert_false(g.validate(), "skill_check gate missing skill_id must fail validate()")


func test_find_node_returns_correct_node() -> void:
	var g := _make_minimal_graph()
	var found := g.find_node("n_start")
	assert_not_null(found, "find_node must return the correct node")
	assert_eq(found.node_id, "n_start")


func test_find_node_missing_returns_null() -> void:
	var g := _make_minimal_graph()
	assert_null(g.find_node("n_ghost"))
