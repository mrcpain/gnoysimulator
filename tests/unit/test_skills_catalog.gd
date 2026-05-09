extends GutTest

## Unit tests for skills.tres catalog integrity (Story 1.2, AC1).
## Validates the 24-entry SkillCatalog resource against the Skills module constants.

const CATALOG_PATH := "res://src/rpg/data/skills.tres"
const VALID_ARCHETYPES: Array[String] = ["MIND", "SOUL", "MOUTH", "GHOST", "BODY", "SIGNAL"]

var _catalog: SkillCatalog


func before_each() -> void:
	_catalog = load(CATALOG_PATH) as SkillCatalog
	assert_not_null(_catalog, "skills.tres must load as a non-null SkillCatalog")


func test_catalog_has_24_skills() -> void:
	assert_eq(_catalog.skills.size(), 24, "Catalog must contain exactly 24 SkillDefinitions")


func test_catalog_ids_match_skills_module() -> void:
	var catalog_ids: Array[String] = []
	for entry: SkillDefinition in _catalog.skills:
		catalog_ids.append(entry.id)
	catalog_ids.sort()
	var module_ids: Array[String] = Skills.ALL_IDS.duplicate()
	module_ids.sort()
	assert_eq(catalog_ids, module_ids, "Catalog ids must match Skills.ALL_IDS exactly")


func test_catalog_parent_attributes_valid() -> void:
	for entry: SkillDefinition in _catalog.skills:
		assert_true(
			Attributes.is_valid_name(entry.parent_attribute),
			"Skill '%s' has invalid parent_attribute '%s'" % [entry.id, entry.parent_attribute]
		)


func test_catalog_archetypes_valid() -> void:
	for entry: SkillDefinition in _catalog.skills:
		assert_true(
			entry.archetype in VALID_ARCHETYPES,
			"Skill '%s' has invalid archetype '%s'" % [entry.id, entry.archetype]
		)


func test_catalog_archetype_matches_parent_attribute() -> void:
	for entry: SkillDefinition in _catalog.skills:
		assert_eq(
			entry.archetype,
			entry.parent_attribute,
			"Skill '%s': archetype must equal parent_attribute" % entry.id
		)


func test_catalog_translation_keys_present() -> void:
	for entry: SkillDefinition in _catalog.skills:
		var expected_name_key := "skill.%s.name" % entry.id
		var expected_desc_key := "skill.%s.desc" % entry.id
		assert_eq(
			entry.display_name_key,
			expected_name_key,
			"Skill '%s' display_name_key must follow pattern 'skill.<id>.name'" % entry.id
		)
		assert_eq(
			entry.description_key,
			expected_desc_key,
			"Skill '%s' description_key must follow pattern 'skill.<id>.desc'" % entry.id
		)


func test_catalog_voice_profile_ids_present() -> void:
	for entry: SkillDefinition in _catalog.skills:
		assert_true(
			entry.voice_profile_id.length() > 0,
			"Skill '%s' must have a non-empty voice_profile_id" % entry.id
		)
