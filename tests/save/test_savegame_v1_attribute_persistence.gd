extends GutTest

## Save round-trip test for attribute persistence (Story 1.1, AC4).
## Verifies all seven canonical attribute values survive ResourceSaver/ResourceLoader intact.
## Mirrors test_savegame_v1_roundtrip.gd patterns: CACHE_MODE_IGNORE, OS.remove cleanup.

const TEST_PATH := "user://test_attribute_save.tres"

const NON_DEFAULT_ATTRS: Dictionary = {
	"BODY": 7, "MIND": 5, "SOUL": 8, "MOUTH": 4, "GHOST": 6, "GUT": 3, "SIGNAL": 2
}


func after_each() -> void:
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))


func test_attribute_roundtrip_preserves_all_seven() -> void:
	var original := SaveGameV1.new()
	original.attributes = NON_DEFAULT_ATTRS.duplicate(true)

	var err := ResourceSaver.save(original, TEST_PATH)
	assert_eq(err, OK, "ResourceSaver.save must return OK")
	assert_true(FileAccess.file_exists(TEST_PATH), "Save file must exist after save")

	# Bypass resource cache — Story 1.0 lesson: default cache returns stale data on repeat runs.
	var loaded := ResourceLoader.load(TEST_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveGameV1
	assert_not_null(loaded, "ResourceLoader must return a non-null SaveGameV1")

	# Per-key assert_eq for all seven — AC4 requires exact key-by-key verification
	for attr_name in Attributes.NAMES:
		assert_eq(
			loaded.attributes.get(attr_name),
			NON_DEFAULT_ATTRS[attr_name],
			"Attribute '%s' must survive round-trip" % attr_name
		)

	# Defence-in-depth: V1 schema invariant
	assert_eq(loaded.schema_version, 1, "schema_version must remain 1")
