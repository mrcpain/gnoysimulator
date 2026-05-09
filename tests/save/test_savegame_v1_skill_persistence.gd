extends GutTest

## Save round-trip test for skill persistence (Story 1.2, AC4).
## Mirrors test_savegame_v1_attribute_persistence.gd exactly:
## CACHE_MODE_IGNORE to bypass stale resource cache (Story 1.0/1.1 lesson).
## DirAccess.remove_absolute cleanup (OS.remove() doesn't exist in Godot 4.3).

const TEST_PATH := "user://test_skill_save.tres"


func after_each() -> void:
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))


func test_skill_roundtrip_preserves_all_24_ranks_xp_and_talent_points() -> void:
	var custom_skills := Skills.default_skill_ranks()
	custom_skills["rabbit_hole"] = 5
	custom_skills["hands"]       = 7
	custom_skills["receipts"]    = 3

	var custom_xp := Skills.default_skill_xp()
	custom_xp["rabbit_hole"] = 145  # mid-rank-5
	custom_xp["hands"]       = 305  # at rank-7 threshold
	custom_xp["receipts"]    = 50   # at rank-3 boundary

	var original := SaveGameV1.new()
	original.skills       = custom_skills
	original.skill_xp     = custom_xp
	original.talent_points = 7

	var err := ResourceSaver.save(original, TEST_PATH)
	assert_eq(err, OK, "ResourceSaver.save must return OK")
	assert_true(FileAccess.file_exists(TEST_PATH), "Save file must exist after save")

	# Bypass resource cache — Story 1.0/1.1 lesson: default cache returns stale data on repeat runs.
	var loaded := ResourceLoader.load(TEST_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveGameV1
	assert_not_null(loaded, "ResourceLoader must return a non-null SaveGameV1")

	# Per-key assert_eq for all 24 skill ranks (AC4 requires exact key-by-key verification)
	for id in Skills.ALL_IDS:
		assert_eq(
			loaded.skills.get(id),
			custom_skills[id],
			"Skill rank '%s' must survive round-trip" % id
		)

	# Per-key assert_eq for all 24 skill_xp values
	for id in Skills.ALL_IDS:
		assert_eq(
			loaded.skill_xp.get(id),
			custom_xp[id],
			"Skill XP '%s' must survive round-trip" % id
		)

	# Talent points
	assert_eq(loaded.talent_points, 7, "talent_points must survive round-trip")

	# Defence-in-depth: V1 schema invariant
	assert_eq(loaded.schema_version, 1, "schema_version must remain 1")
