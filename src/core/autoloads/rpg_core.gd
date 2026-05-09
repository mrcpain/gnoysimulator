extends Node

## Player RPG state: attributes, skills, talents, Awakening Track, dispositions.
## Stories 1.1–1.7 fill the implementations.
## Forbidden: any other cluster reading awakening_level directly.
##   Subscribers listen on EventBus.awakening_level_changed (arch locked rule 4).

signal awakening_level_changed(old_level: int, new_level: int)

var attributes: Dictionary = {}
var skills: Dictionary = {}
var talents: Array = []
var awakening_level: int = 1
var disposition_gnoy_awake: float = 0.0
var disposition_passive_rebel: float = 0.0


func _ready() -> void:
	Logger.info("rpg", "RPGCore ready.")
	_seed_attributes_if_empty()


func get_attribute(attr_name: String) -> int:
	if not Attributes.is_valid_name(attr_name):
		Logger.error("rpg", "get_attribute: unknown attribute '%s'" % attr_name)
		return 0
	return attributes.get(attr_name, 0) as int


func set_attribute(attr_name: String, value: int) -> void:
	if not Attributes.is_valid_name(attr_name):
		Logger.error("rpg", "set_attribute: unknown attribute '%s' (value=%d ignored)" % [attr_name, value])
		return
	var clamped := Attributes.clamp_value(value)
	if clamped != value:
		Logger.warn("rpg", "set_attribute: '%s' value %d clamped to %d (range [%d,%d])" % [attr_name, value, clamped, Attributes.MIN, Attributes.MAX])
	attributes[attr_name] = clamped


func _seed_attributes_if_empty() -> void:
	if attributes.is_empty():
		attributes = Attributes.default_wageworker()


func _set_awakening_level(new_level: int) -> void:
	## Internal setter — re-emits into EventBus per locked rule 4.
	var old := awakening_level
	awakening_level = new_level
	awakening_level_changed.emit(old, new_level)
	EventBus.awakening_level_changed.emit(old, new_level)
