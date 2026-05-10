extends GutTest

## Integration tests for RPGCore skill API (Story 1.2, AC1–AC3).
## Uses get_node("/root/...") to avoid GDScript static-analysis class vs. singleton ambiguity
## (same pattern as test_rpgcore_attributes.gd, Story 1.1 lesson).

var _rpg: Node
var _logger: Node
var _event_bus: Node


func before_each() -> void:
	_rpg = get_node("/root/RPGCore")
	_logger = get_node("/root/Logger")
	_event_bus = get_node("/root/EventBus")
	_rpg.skills = {}
	_rpg.skill_xp = {}
	_rpg.talent_points = 0
	_rpg._seed_skills_if_empty()
	watch_signals(_event_bus)


func _has_new_entry_with(before_size: int, fragment: String) -> bool:
	var buf: Array = _logger.get_ring_buffer()
	for i in range(before_size, buf.size()):
		if (buf[i] as String).contains(fragment):
			return true
	return false


func test_fresh_rpgcore_seeds_24_skills_at_rank_0() -> void:
	assert_eq(_rpg.skills.size(), 24, "RPGCore must seed exactly 24 skills")
	for id in Skills.ALL_IDS:
		assert_true(_rpg.skills.has(id), "Skill '%s' must be present after seed" % id)
		assert_eq(_rpg.skills[id], 0, "Skill '%s' must start at rank 0" % id)


func test_get_skill_rank_returns_persisted() -> void:
	_rpg.skills["rabbit_hole"] = 5
	assert_eq(_rpg.get_skill_rank("rabbit_hole"), 5, "get_skill_rank must return persisted value")


func test_get_skill_rank_unknown_logs_error_returns_zero() -> void:
	var before: int = _logger.get_ring_buffer().size()
	var result: int = _rpg.get_skill_rank("foo")
	assert_eq(result, 0, "Unknown skill must return 0")
	assert_true(_has_new_entry_with(before, "[ERROR]"), "Unknown skill get must log an error")
	assert_true(_has_new_entry_with(before, "foo"), "Error log must name the unknown skill")


func test_award_skill_xp_success_increments_xp() -> void:
	var bal := Balance.get_data()
	var expected_xp: int = int(bal.skill_xp_per_use.get("success", 0))
	_rpg.award_skill_xp("rabbit_hole", "success")
	assert_eq(_rpg.get_skill_xp("rabbit_hole"), expected_xp,
		"award success must increment xp by skill_xp_per_use['success']")


func test_award_skill_xp_critical_grants_more_xp() -> void:
	var bal := Balance.get_data()
	var crit_xp: int = int(bal.skill_xp_per_use.get("critical", 0))
	var success_xp: int = int(bal.skill_xp_per_use.get("success", 0))
	assert_gt(crit_xp, success_xp, "critical XP delta must be greater than success XP delta")


func test_award_skill_xp_fail_still_grants_xp() -> void:
	var bal := Balance.get_data()
	var fail_xp: int = int(bal.skill_xp_per_use.get("fail", 0))
	assert_gt(fail_xp, 0, "fail outcome must grant > 0 XP per AC2 'regardless of outcome'")
	_rpg.award_skill_xp("rabbit_hole", "fail")
	assert_gt(_rpg.get_skill_xp("rabbit_hole"), 0, "skill_xp must increase after fail award")


func test_award_skill_xp_unknown_skill_logs_error_no_mutate() -> void:
	var snapshot: Dictionary = _rpg.skill_xp.duplicate(true)
	var before: int = _logger.get_ring_buffer().size()
	_rpg.award_skill_xp("foo", "success")
	assert_eq(_rpg.skill_xp, snapshot, "Unknown skill award must not mutate skill_xp")
	assert_true(_has_new_entry_with(before, "[ERROR]"), "Unknown skill must log an error")


func test_award_skill_xp_unknown_outcome_logs_error_no_mutate() -> void:
	var snapshot: Dictionary = _rpg.skill_xp.duplicate(true)
	var before: int = _logger.get_ring_buffer().size()
	_rpg.award_skill_xp("rabbit_hole", "win")
	assert_eq(_rpg.skill_xp, snapshot, "Unknown outcome award must not mutate skill_xp")
	assert_true(_has_new_entry_with(before, "[ERROR]"), "Unknown outcome must log an error")


func test_skill_levels_up_at_threshold() -> void:
	var bal := Balance.get_data()
	var threshold_0: int = int(bal.skill_xp_thresholds[0])
	_rpg.skill_xp["hands"] = threshold_0 - 1
	_rpg.award_skill_xp("hands", "success")
	assert_eq(_rpg.get_skill_rank("hands"), 1, "Skill must reach rank 1 after crossing threshold")
	assert_signal_emitted(_event_bus, "skill_levelled")


func test_talent_point_awarded_at_rank_2() -> void:
	var bal := Balance.get_data()
	var threshold_1: int = int(bal.skill_xp_thresholds[1])
	_rpg.skill_xp["rabbit_hole"] = threshold_1 - 1
	_rpg.award_skill_xp("rabbit_hole", "success")
	assert_eq(_rpg.get_skill_rank("rabbit_hole"), 2, "Skill must reach rank 2")
	assert_eq(_rpg.talent_points, 1, "One talent point must be awarded on reaching rank 2")


func test_talent_point_not_awarded_at_odd_ranks() -> void:
	var bal := Balance.get_data()
	# Push to rank 1 — no TP
	_rpg.skill_xp["yap_game"] = int(bal.skill_xp_thresholds[0]) - 1
	_rpg.award_skill_xp("yap_game", "success")
	assert_eq(_rpg.get_skill_rank("yap_game"), 1, "Must reach rank 1")
	assert_eq(_rpg.talent_points, 0, "Rank 1 must not award a talent point")
	# Push to rank 3 — still only 1 TP (from rank 2)
	_rpg.skill_xp["yap_game"] = int(bal.skill_xp_thresholds[2]) - 1
	_rpg.award_skill_xp("yap_game", "success")
	assert_eq(_rpg.get_skill_rank("yap_game"), 3, "Must reach rank 3")
	assert_eq(_rpg.talent_points, 1, "Rank 3 must not add another talent point (rank 2 gave 1)")


func test_skill_capped_at_rank_10() -> void:
	_rpg.skills["rabbit_hole"] = 10
	_rpg.skill_xp["rabbit_hole"] = 99999
	var before_xp: int = _rpg.get_skill_xp("rabbit_hole")
	_rpg.award_skill_xp("rabbit_hole", "critical")
	assert_eq(_rpg.get_skill_rank("rabbit_hole"), 10, "Rank must remain capped at 10")
	assert_eq(_rpg.get_skill_xp("rabbit_hole"), before_xp, "XP must not increase at rank 10")
	assert_signal_emit_count(_event_bus, "skill_levelled", 0)


func test_multi_level_up_in_single_award() -> void:
	var bal := Balance.get_data()
	# Set XP to threshold[1] - 1 (one "success" award crosses both threshold[0] and threshold[1]).
	var xp_setup: int = int(bal.skill_xp_thresholds[1]) - int(bal.skill_xp_per_use.get("success", 1))
	_rpg.skill_xp["hands"] = xp_setup
	_rpg.award_skill_xp("hands", "success")
	assert_eq(_rpg.get_skill_rank("hands"), 2, "Must advance two ranks in a single award")
	assert_signal_emit_count(_event_bus, "skill_levelled", 2)


func test_award_skill_xp_does_not_emit_awakening_signal() -> void:
	for _i in range(15):
		_rpg.award_skill_xp("web", "success")
	assert_signal_emit_count(_event_bus, "awakening_level_changed", 0)
