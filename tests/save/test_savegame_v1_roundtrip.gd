extends GutTest

## GUT test: SaveGameV1 round-trip serialization (AC4, Story 1.0).
## Verifies that every @export field survives ResourceSaver/ResourceLoader intact.
## schema_version == 1 must survive; no silent field drops allowed.

const TEST_PATH := "user://test_save_roundtrip.tres"


func after_each() -> void:
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))


func test_savegame_v1_roundtrip() -> void:
	# Build a SaveGameV1 with non-default values on every field
	var original := SaveGameV1.new()
	original.schema_version = 1
	original.attributes = {"strength": 5, "insight": 3}
	original.skills = {"infiltration": 2, "persuasion": 4}
	original.talents = ["iron_will", "quick_draw"]
	original.awakening_level = 3
	original.disposition = {"gnoy_awake": 0.42, "passive_rebel": 0.17}
	original.derived_stats = {"max_hp": 80, "composure": 10}
	original.world_clock_minutes = 1440
	original.world_state = {"politburo_week": 7}
	original.conversation_log = [{"id": "greystone_dave_01", "turn": 2}]
	original.district_heat = {"slopside_hollow": 3}
	original.recruit_roster = [{"id": "recruit_01", "loyalty": 55}]

	# Save to temp file
	var err := ResourceSaver.save(original, TEST_PATH)
	assert_eq(err, OK, "ResourceSaver.save should return OK")
	assert_true(FileAccess.file_exists(TEST_PATH), "Save file should exist after save")

	# Reload — bypass resource cache to ensure we read what was actually written to disk
	var loaded := ResourceLoader.load(TEST_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveGameV1
	assert_not_null(loaded, "ResourceLoader should return a non-null SaveGameV1")

	# Verify loaded is a fresh instance, not the same object
	assert_true(loaded != original, "Loaded resource must be a different instance than original")

	# Assert every field survives
	assert_eq(loaded.schema_version, 1, "schema_version must be 1")
	assert_eq(loaded.attributes, original.attributes, "attributes must match")
	assert_eq(loaded.skills, original.skills, "skills must match")
	assert_eq(loaded.talents, original.talents, "talents must match")
	assert_eq(loaded.awakening_level, original.awakening_level, "awakening_level must match")
	assert_eq(loaded.disposition, original.disposition, "disposition must match")
	assert_eq(loaded.derived_stats, original.derived_stats, "derived_stats must match")
	assert_eq(loaded.world_clock_minutes, original.world_clock_minutes, "world_clock_minutes must match")
	assert_eq(loaded.world_state, original.world_state, "world_state must match")
	assert_eq(loaded.conversation_log, original.conversation_log, "conversation_log must match")
	assert_eq(loaded.district_heat, original.district_heat, "district_heat must match")
	assert_eq(loaded.recruit_roster, original.recruit_roster, "recruit_roster must match")
