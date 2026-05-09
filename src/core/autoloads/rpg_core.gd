extends Node

## Player RPG state: attributes, skills, talents, Awakening Track, dispositions.
## Stories 1.1–1.7 fill the implementations.
## Forbidden: any other cluster reading awakening_level directly.
##   Subscribers listen on EventBus.awakening_level_changed (arch locked rule 4).

signal awakening_level_changed(old_level: int, new_level: int)

var attributes: Dictionary = {}
var skills: Dictionary = {}
var skill_xp: Dictionary = {}
var talent_points: int = 0
var talents: Array = []
var awakening_level: int = 1
var disposition_gnoy_awake: float = 0.0
var disposition_passive_rebel: float = 0.0


func _ready() -> void:
	Logger.info("rpg", "RPGCore ready.")
	_seed_attributes_if_empty()
	_seed_skills_if_empty()


# ── Attribute API (Story 1.1) ─────────────────────────────────────────────────

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


# ── Skill API (Story 1.2) ─────────────────────────────────────────────────────

func get_skill_rank(skill_id: String) -> int:
	if not Skills.is_valid_id(skill_id):
		Logger.error("rpg", "get_skill_rank: unknown skill '%s'" % skill_id)
		return 0
	return skills.get(skill_id, 0) as int


func get_skill_xp(skill_id: String) -> int:
	if not Skills.is_valid_id(skill_id):
		Logger.error("rpg", "get_skill_xp: unknown skill '%s'" % skill_id)
		return 0
	return skill_xp.get(skill_id, 0) as int


func award_skill_xp(skill_id: String, outcome: String) -> void:
	if not Skills.is_valid_id(skill_id):
		Logger.error("rpg", "award_skill_xp: unknown skill_id '%s'" % skill_id)
		return
	if not Skills.is_valid_outcome(outcome):
		Logger.error("rpg", "award_skill_xp: unknown outcome '%s'" % outcome)
		return

	var current_rank := int(skills.get(skill_id, 0))
	if current_rank >= Skills.MAX_RANK:
		Logger.debug("rpg", "award_skill_xp: '%s' already at max rank; ignoring xp" % skill_id)
		return

	var bal := Balance.get_data()
	var delta: int
	if bal.skill_xp_per_use.has(outcome):
		delta = int(bal.skill_xp_per_use[outcome])
	else:
		Logger.warn("rpg", "award_skill_xp: skill_xp_per_use missing key '%s'; awarding 0 XP" % outcome)
		delta = 0

	skill_xp[skill_id] = int(skill_xp.get(skill_id, 0)) + delta

	var current_xp := int(skill_xp[skill_id])
	var thresholds: Array = bal.skill_xp_thresholds
	while current_rank < Skills.MAX_RANK and current_rank < thresholds.size() and current_xp >= int(thresholds[current_rank]):
		current_rank += 1
		skills[skill_id] = current_rank
		if Skills.is_talent_point_rank(current_rank):
			talent_points += 1
			Logger.info("rpg", "talent point awarded (skill '%s' reached rank %d)" % [skill_id, current_rank])
		EventBus.skill_levelled.emit(skill_id, current_rank)
		Logger.info("rpg", "skill '%s' levelled to rank %d" % [skill_id, current_rank])


func _seed_skills_if_empty() -> void:
	if skills.is_empty():
		skills = Skills.default_skill_ranks()
	if skill_xp.is_empty():
		skill_xp = Skills.default_skill_xp()


# ── Awakening Track (Story 1.5) ───────────────────────────────────────────────

func _set_awakening_level(new_level: int) -> void:
	## Internal setter — re-emits into EventBus per locked rule 4.
	var old := awakening_level
	awakening_level = new_level
	awakening_level_changed.emit(old, new_level)
	EventBus.awakening_level_changed.emit(old, new_level)
