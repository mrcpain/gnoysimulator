extends Node

## Manages save/load, schema versioning, and migration chain.
## Owns WorldState — the Three Tracking Systems live here, not as autoloads (arch §4.5).
## Dev saves: .tres (text, diffable). Release saves: .res (binary).
## Forbidden: manual save outside Ironman semantics (arch §7.2, §6.1).

const SAVE_DIR := "user://saves"
const CURRENT_SCHEMA_VERSION := 1

var world_state: WorldState = null


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	world_state = WorldState.new()
	Logger.info("save", "SaveSystem ready. WorldState initialised.")


func save_to_slot(slot: int, save: SaveGameV1) -> Error:
	save.attributes = RPGCore.attributes.duplicate(true)
	save.skills = RPGCore.skills.duplicate(true)
	save.skill_xp = RPGCore.skill_xp.duplicate(true)
	save.talent_points = RPGCore.talent_points
	var path := _slot_path(slot)
	var err := ResourceSaver.save(save, path)
	if err != OK:
		Logger.error("save", "save_to_slot(%d) failed — error %d, path '%s'" % [slot, err, path])
	else:
		Logger.info("save", "Saved slot %d to '%s'." % [slot, path])
	return err


func load_from_slot(slot: int) -> SaveGameV1:
	var path := _slot_path(slot)
	# FileAccess.file_exists() checks the OS filesystem directly —
	# ResourceLoader.exists() queries Godot's resource cache and is unreliable for user:// saves.
	if not FileAccess.file_exists(path):
		Logger.warn("save", "load_from_slot(%d): no file at '%s'." % [slot, path])
		return null
	var res := ResourceLoader.load(path)
	if res == null:
		Logger.error("save", "load_from_slot(%d): ResourceLoader returned null. File may be corrupt." % slot)
		return null
	var save := _migrate(res)
	if save == null:
		Logger.error("save", "load_from_slot(%d): migration returned null. Returning null for UI recovery flow." % slot)
		return null
	RPGCore.attributes = save.attributes.duplicate(true)
	RPGCore.skills = save.skills.duplicate(true)
	RPGCore.skill_xp = save.skill_xp.duplicate(true)
	RPGCore.talent_points = save.talent_points
	return save


func dump_save(slot: int) -> String:
	## JSON dump for --dump-save CLI flag (arch §3.7).
	var save := load_from_slot(slot)
	if save == null:
		return "{}"
	var d := {
		"schema_version": save.schema_version,
		"attributes": save.attributes,
		"skills": save.skills,
		"skill_xp": save.skill_xp,
		"talent_points": save.talent_points,
		"talents": save.talents,
		"awakening_level": save.awakening_level,
		"disposition": save.disposition,
		"derived_stats": save.derived_stats,
		"world_clock_minutes": save.world_clock_minutes,
		"world_state": save.world_state,
		"conversation_log": save.conversation_log,
		"district_heat": save.district_heat,
		"recruit_roster": save.recruit_roster,
	}
	return JSON.stringify(d, "\t")


func _slot_path(slot: int) -> String:
	if ProjectConfig.is_release:
		return "%s/save_%d.res" % [SAVE_DIR, slot]
	return "%s/save_%d.tres" % [SAVE_DIR, slot]


func _migrate(res: Resource) -> SaveGameV1:
	## Run migration chain to current schema version.
	## Loading a save newer than this build returns null (UI shows version-mismatch error).
	# res.get("schema_version") returns null if the property doesn't exist on this resource.
	# has_method("get") is always true on Resource — don't use it as a guard.
	var raw_version = res.get("schema_version")
	var version: int
	if raw_version == null:
		Logger.warn("save", "Save resource has no schema_version field; treating as V1.")
		version = 1
	else:
		version = int(raw_version)

	if version > CURRENT_SCHEMA_VERSION:
		Logger.error("save", "Save schema V%d is newer than this build (V%d). Cannot load." % [version, CURRENT_SCHEMA_VERSION])
		return null

	# V1 baseline — single-version chain; future saves extend here
	var migrated := SaveGameV1.migrate_from(res)
	if migrated == null:
		Logger.error("save", "Migration from V%d returned null. Save type: %s" % [version, res.get_class()])
	return migrated
