extends GutTest

## Unit tests for Skills module (Story 1.2, AC1–AC2).
## Pure-function coverage: id sets, constants, static helpers, default dicts.


func test_all_ids_count_is_24() -> void:
	assert_eq(Skills.ALL_IDS.size(), 24, "ALL_IDS must have exactly 24 entries")


func test_all_ids_unique() -> void:
	var seen: Dictionary = {}
	for id in Skills.ALL_IDS:
		assert_false(seen.has(id), "Duplicate skill id detected: '%s'" % id)
		seen[id] = true
	assert_eq(seen.size(), 24, "Unique-id set must still be 24")


func test_archetype_ids_each_size_4() -> void:
	assert_eq(Skills.MIND_IDS.size(),   4, "MIND must have 4 skills")
	assert_eq(Skills.SOUL_IDS.size(),   4, "SOUL must have 4 skills")
	assert_eq(Skills.MOUTH_IDS.size(),  4, "MOUTH must have 4 skills")
	assert_eq(Skills.GHOST_IDS.size(),  4, "GHOST must have 4 skills")
	assert_eq(Skills.BODY_IDS.size(),   4, "BODY must have 4 skills")
	assert_eq(Skills.SIGNAL_IDS.size(), 4, "SIGNAL must have 4 skills")


func test_is_valid_id_yes() -> void:
	for id in Skills.ALL_IDS:
		assert_true(Skills.is_valid_id(id), "'%s' must be a valid skill id" % id)


func test_is_valid_id_no() -> void:
	assert_false(Skills.is_valid_id("FOO"),          "'FOO' must be invalid")
	assert_false(Skills.is_valid_id("rabbit hole"),   "id with space must be invalid")
	assert_false(Skills.is_valid_id(""),              "empty string must be invalid")
	assert_false(Skills.is_valid_id("Rabbit_Hole"),   "mixed-case must be invalid")


func test_is_valid_outcome_true() -> void:
	assert_true(Skills.is_valid_outcome("critical"), "'critical' must be valid")
	assert_true(Skills.is_valid_outcome("success"),  "'success' must be valid")
	assert_true(Skills.is_valid_outcome("fail"),     "'fail' must be valid")


func test_is_valid_outcome_false() -> void:
	assert_false(Skills.is_valid_outcome("crit"),  "'crit' must be invalid")
	assert_false(Skills.is_valid_outcome("win"),   "'win' must be invalid")
	assert_false(Skills.is_valid_outcome(""),      "empty string must be invalid")


func test_is_talent_point_rank_true() -> void:
	for rank in [2, 4, 6, 8, 10]:
		assert_true(Skills.is_talent_point_rank(rank), "rank %d must award a talent point" % rank)


func test_is_talent_point_rank_false() -> void:
	for rank in [0, 1, 3, 5, 7, 9, 11]:
		assert_false(Skills.is_talent_point_rank(rank), "rank %d must NOT award a talent point" % rank)


func test_default_skill_ranks_returns_24_zeros() -> void:
	var d := Skills.default_skill_ranks()
	assert_eq(d.size(), 24, "default_skill_ranks must have 24 keys")
	for id in Skills.ALL_IDS:
		assert_true(d.has(id), "Key '%s' must be present" % id)
		assert_eq(d[id], 0, "Default rank for '%s' must be 0" % id)


func test_default_skill_ranks_returns_independent_copy() -> void:
	var d1 := Skills.default_skill_ranks()
	var d2 := Skills.default_skill_ranks()
	d1["rabbit_hole"] = 999
	assert_eq(d2["rabbit_hole"], 0, "Mutating first copy must not affect second copy")


func test_default_skill_xp_returns_24_zeros() -> void:
	var d := Skills.default_skill_xp()
	assert_eq(d.size(), 24, "default_skill_xp must have 24 keys")
	for id in Skills.ALL_IDS:
		assert_true(d.has(id), "Key '%s' must be present" % id)
		assert_eq(d[id], 0, "Default xp for '%s' must be 0" % id)


func test_all_ids_matches_archetype_group_union() -> void:
	var from_groups: Array[String] = []
	from_groups.append_array(Skills.MIND_IDS)
	from_groups.append_array(Skills.SOUL_IDS)
	from_groups.append_array(Skills.MOUTH_IDS)
	from_groups.append_array(Skills.GHOST_IDS)
	from_groups.append_array(Skills.BODY_IDS)
	from_groups.append_array(Skills.SIGNAL_IDS)
	from_groups.sort()
	var all_sorted: Array[String] = Skills.ALL_IDS.duplicate()
	all_sorted.sort()
	assert_eq(all_sorted, from_groups, "ALL_IDS must exactly match the union of all six archetype group arrays")
