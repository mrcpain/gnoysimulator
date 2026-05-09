extends GutTest

## Integration tests for RPGCore attribute API (Story 1.1, AC1–AC3).
## Accesses autoloads via get_node("/root/...") to avoid GDScript static analysis
## treating class_name-declared singletons as class types (Godot 4.3 headless behaviour).

var _rpg: Node
var _logger: Node


func before_each() -> void:
	_rpg = get_node("/root/RPGCore")
	_logger = get_node("/root/Logger")
	_rpg.attributes = {}
	_rpg._seed_attributes_if_empty()


func _has_new_entry_with(before_size: int, fragment: String) -> bool:
	var buf: Array = _logger.get_ring_buffer()
	for i in range(before_size, buf.size()):
		if (buf[i] as String).contains(fragment):
			return true
	return false


func test_fresh_rpgcore_seeds_wageworker() -> void:
	assert_eq(_rpg.get_attribute("BODY"),   4, "Fresh seed: BODY must be 4")
	assert_eq(_rpg.get_attribute("MIND"),   2, "Fresh seed: MIND must be 2")
	assert_eq(_rpg.get_attribute("SOUL"),   2, "Fresh seed: SOUL must be 2")
	assert_eq(_rpg.get_attribute("MOUTH"),  3, "Fresh seed: MOUTH must be 3")
	assert_eq(_rpg.get_attribute("GHOST"),  1, "Fresh seed: GHOST must be 1")
	assert_eq(_rpg.get_attribute("GUT"),    5, "Fresh seed: GUT must be 5")
	assert_eq(_rpg.get_attribute("SIGNAL"), 0, "Fresh seed: SIGNAL must be 0")


func test_get_attribute_returns_persisted() -> void:
	_rpg.attributes["BODY"] = 7
	assert_eq(_rpg.get_attribute("BODY"), 7, "get_attribute must return persisted value")


func test_get_attribute_unknown_logs_error_returns_zero() -> void:
	var before: int = _logger.get_ring_buffer().size()
	var result: int = _rpg.get_attribute("FOO")
	assert_eq(result, 0, "Unknown attribute must return 0")
	assert_true(_has_new_entry_with(before, "[ERROR]"), "Unknown attribute get must log an error")
	assert_true(_has_new_entry_with(before, "FOO"), "Error log must name the unknown attribute")


func test_set_attribute_clamps_high() -> void:
	var before: int = _logger.get_ring_buffer().size()
	_rpg.set_attribute("BODY", 99)
	assert_eq(_rpg.get_attribute("BODY"), 10, "Value 99 must be clamped to MAX (10)")
	assert_true(_has_new_entry_with(before, "[WARN]"), "Clamped-high set must emit a warn")


func test_set_attribute_clamps_low() -> void:
	var before: int = _logger.get_ring_buffer().size()
	_rpg.set_attribute("MIND", -3)
	assert_eq(_rpg.get_attribute("MIND"), 0, "Value -3 must be clamped to MIN (0)")
	assert_true(_has_new_entry_with(before, "[WARN]"), "Clamped-low set must emit a warn")


func test_set_attribute_unknown_does_not_mutate() -> void:
	var snapshot: Dictionary = _rpg.attributes.duplicate()
	var before: int = _logger.get_ring_buffer().size()
	_rpg.set_attribute("FOO", 5)
	assert_eq(_rpg.attributes, snapshot, "Unknown set must not mutate attributes dict")
	assert_true(_has_new_entry_with(before, "[ERROR]"), "Unknown attribute set must log an error")


func test_set_attribute_in_range_does_not_warn() -> void:
	var before: int = _logger.get_ring_buffer().size()
	_rpg.set_attribute("SIGNAL", 3)
	assert_eq(_rpg.get_attribute("SIGNAL"), 3, "In-range set must persist the value")
	assert_false(_has_new_entry_with(before, "[WARN]"), "In-range set must not emit a warn")
