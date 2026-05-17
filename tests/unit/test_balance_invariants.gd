extends GutTest

## Story 1.10 — Balance.tres shape invariants.
## Failing here means balance.tres has drifted from its callers' assumptions.


func test_balance_autoload_loaded() -> void:
	assert_not_null(Balance.get_data(), "Balance autoload must load balance.tres at _ready()")


func test_skill_xp_thresholds_size_matches_max_rank() -> void:
	var bal := Balance.get_data()
	assert_eq(bal.skill_xp_thresholds.size(), Skills.MAX_RANK,
		"skill_xp_thresholds must have exactly %d entries (one per rank)" % Skills.MAX_RANK)


func test_skill_xp_thresholds_monotonic_non_decreasing() -> void:
	var bal := Balance.get_data()
	for i in range(1, bal.skill_xp_thresholds.size()):
		var prev: int = int(bal.skill_xp_thresholds[i - 1])
		var curr: int = int(bal.skill_xp_thresholds[i])
		assert_true(curr >= prev,
			"skill_xp_thresholds not monotonic at index %d: %d after %d" % [i, curr, prev])


func test_skill_xp_per_use_has_all_outcome_keys() -> void:
	var bal := Balance.get_data()
	for outcome in [Skills.OUTCOME_CRITICAL, Skills.OUTCOME_SUCCESS, Skills.OUTCOME_FAIL]:
		assert_true(bal.skill_xp_per_use.has(outcome),
			"skill_xp_per_use missing outcome key '%s'" % outcome)
		assert_true(int(bal.skill_xp_per_use[outcome]) >= 0,
			"skill_xp_per_use['%s'] must be non-negative" % outcome)


func test_talent_passive_magnitudes_keys_well_formed() -> void:
	var bal := Balance.get_data()
	for composite_key: String in bal.talent_passive_magnitudes.keys():
		var parts: PackedStringArray = composite_key.split(".", true, 1)
		assert_eq(parts.size(), 2,
			"talent_passive_magnitudes key '%s' must be 'talent_id.modifier_key'" % composite_key)
		assert_true(Talents.is_valid_id(parts[0]),
			"talent_passive_magnitudes key '%s' references unknown talent '%s'" % [composite_key, parts[0]])


func test_talent_cost_overrides_keys_valid_and_costs_positive() -> void:
	var bal := Balance.get_data()
	assert_not_null(bal.talent_cost_overrides, "talent_cost_overrides must exist (may be empty stub)")
	for talent_id: String in bal.talent_cost_overrides.keys():
		assert_true(Talents.is_valid_id(talent_id),
			"talent_cost_overrides key '%s' is not a valid talent id" % talent_id)
		assert_true(int(bal.talent_cost_overrides[talent_id]) >= 1,
			"talent_cost_overrides['%s'] must be >= 1" % talent_id)


func test_awakening_thresholds_size_in_legal_range() -> void:
	## 0 entries today (Story 1.5 deferred curve); when populated, must equal AWAKENING_MAX - 1.
	var bal := Balance.get_data()
	var size: int = bal.awakening_thresholds.size()
	var max_size: int = RPGCore.AWAKENING_MAX - 1
	assert_true(size == 0 or size == max_size,
		"awakening_thresholds must be empty or have %d entries; got %d" % [max_size, size])


func test_balance_not_in_save_schema() -> void:
	## Balance is build-state, not save-state. No SaveGameV1 @export field may share a name
	## with a BalanceResource @export field. (AC3 invariant.)
	var save := SaveGameV1.new()
	var bal_res := BalanceResource.new()
	var save_field_names: Array = []
	for prop in save.get_property_list():
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			save_field_names.append(prop["name"])
	for prop in bal_res.get_property_list():
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			assert_false(prop["name"] in save_field_names,
				"BalanceResource field '%s' collides with SaveGameV1 field — Balance must not be save-state" % prop["name"])


func test_combat_3_2_keys_exist() -> void:
	## Story 3.2 — Balance.combat must contain all 7 new keys plus the 2 Story 3.1 keys.
	var bal_combat: Dictionary = Balance.get_data().combat
	assert_true(bal_combat.has("hit_threshold_base"), "Balance.combat.hit_threshold_base missing")
	assert_true(bal_combat.has("hit_threshold_per_body"), "Balance.combat.hit_threshold_per_body missing")
	assert_true(bal_combat.has("gymmaxx_speed_curve"), "Balance.combat.gymmaxx_speed_curve missing")
	assert_true(bal_combat.has("gymmaxx_dodge_curve"), "Balance.combat.gymmaxx_dodge_curve missing")
	assert_true(bal_combat.has("hands_damage_curve"), "Balance.combat.hands_damage_curve missing")
	assert_true(bal_combat.has("hands_disarm_curve"), "Balance.combat.hands_disarm_curve missing")
	assert_true(bal_combat.has("ghost_mode_strike_curve"), "Balance.combat.ghost_mode_strike_curve missing")
	assert_true(bal_combat.has("invincibility_cap"), "Balance.combat.invincibility_cap missing")
	var cap: Dictionary = bal_combat.get("invincibility_cap", {})
	assert_true(cap.has("hit_threshold"), "Balance.combat.invincibility_cap.hit_threshold missing")
	assert_lte(int(cap["hit_threshold"]), 12, "FR16 lock: invincibility_cap.hit_threshold must be <= 12")


func test_combat_3_3_keys_exist() -> void:
	var bal_combat: Dictionary = Balance.get_data().combat
	var required_keys: Array[String] = [
		"yield_intel_dc",
		"yield_intel_curve",
		"yield_fail_intel_multiplier",
		"escape_dc_base",
		"escape_dc_situation_modifiers",
		"escape_fail_heat_penalty",
		"escape_fail_recruit_exposure_pct",
	]
	for k in required_keys:
		assert_true(bal_combat.has(k), "Balance.combat.%s missing (Story 3.3)" % k)


func test_combat_3_3_yield_intel_curve_is_length_11() -> void:
	var curve: Array = Balance.get_data().combat.get("yield_intel_curve", [])
	assert_eq(curve.size(), 11, "yield_intel_curve must have 11 entries (GUT 0–10)")


func test_combat_3_3_yield_intel_curve_monotonic_non_increasing() -> void:
	var curve: Array = Balance.get_data().combat.get("yield_intel_curve", [])
	for i in range(1, curve.size()):
		assert_lte(int(curve[i]), int(curve[i - 1]),
			"yield_intel_curve must be non-increasing at index %d" % i)


func test_combat_3_3_yield_intel_dc_positive() -> void:
	assert_gt(int(Balance.get_data().combat.get("yield_intel_dc", 0)), 0,
		"yield_intel_dc must be positive")


func test_combat_3_3_escape_dc_base_positive() -> void:
	assert_gt(int(Balance.get_data().combat.get("escape_dc_base", 0)), 0,
		"escape_dc_base must be positive")


func test_combat_3_3_escape_fail_heat_penalty_non_negative() -> void:
	assert_gte(int(Balance.get_data().combat.get("escape_fail_heat_penalty", -1)), 0,
		"escape_fail_heat_penalty must be non-negative")


func test_combat_3_3_yield_fail_intel_multiplier_at_least_one() -> void:
	assert_gte(float(Balance.get_data().combat.get("yield_fail_intel_multiplier", 0)), 1.0,
		"yield_fail_intel_multiplier must be >= 1.0")


func test_balance_captured_state_required_keys_exist() -> void:
	var bal_cs: Dictionary = Balance.get_data().captured_state
	var required_keys: Array[String] = [
		"sneak_dc", "dialogue_dc", "broadcast_dc",
		"sneak_fail_heat_penalty", "broadcast_fail_cooldown_attempts",
		"dead_man_switch_minutes_threshold", "dead_man_switch_min_awakening_stage",
	]
	for k in required_keys:
		assert_true(bal_cs.has(k), "Balance.captured_state.%s missing (Story 3.4)" % k)


func test_balance_captured_state_dcs_positive() -> void:
	var bal_cs: Dictionary = Balance.get_data().captured_state
	for k in ["sneak_dc", "dialogue_dc", "broadcast_dc"]:
		assert_gt(int(bal_cs.get(k, 0)), 0, "%s must be > 0" % k)


func test_balance_captured_state_sneak_fail_heat_penalty_non_negative() -> void:
	assert_gte(int(Balance.get_data().captured_state.get("sneak_fail_heat_penalty", -1)), 0,
		"sneak_fail_heat_penalty must be non-negative")


func test_balance_captured_state_broadcast_fail_cooldown_at_least_one() -> void:
	assert_gte(int(Balance.get_data().captured_state.get("broadcast_fail_cooldown_attempts", 0)), 1,
		"broadcast_fail_cooldown_attempts must be >= 1")


func test_balance_captured_state_dms_minutes_threshold_positive() -> void:
	assert_gt(int(Balance.get_data().captured_state.get("dead_man_switch_minutes_threshold", 0)), 0,
		"dead_man_switch_minutes_threshold must be > 0")


func test_balance_captured_state_dms_min_stage_in_range_1_10() -> void:
	var stage: int = int(Balance.get_data().captured_state.get("dead_man_switch_min_awakening_stage", 0))
	assert_gte(stage, 1, "dead_man_switch_min_awakening_stage must be >= 1")
	assert_lte(stage, 10, "dead_man_switch_min_awakening_stage must be <= 10")


func test_balance_weapons_required_top_keys_present() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	for k in ["weapon_damage_base", "weapon_range_base", "bare_hands_bonus", "ranged_lethal_heat_spike"]:
		assert_true(bal_weapons.has(k), "Balance.weapons.%s missing (Story 3.5)" % k)


func test_balance_weapons_all_33_weapon_ids_present() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	var expected_ids: Array[String] = [
		"pipe_wrench", "baseball_bat", "crowbar", "combat_knife", "security_baton",
		"brass_knuckles", "chain", "hammer", "fire_extinguisher", "skateboard",
		"shovel", "broken_bottle", "heavy_book",
		"taser", "tranq_syringe", "tranq_dart_gun", "pepper_spray", "rubber_bullet_pistol",
		"smoke_grenade", "flashbang", "sleep_gas_canister", "sedative_laced_food", "net_launcher",
		"suppressed_pistol", "standard_pistol", "shotgun", "smg_seized", "sniper_rifle", "zip_gun",
		"molotov", "rock_brick", "throwing_knife", "distraction_object",
	]
	assert_eq(expected_ids.size(), 33, "test sanity: expected_ids must have 33 entries")
	for id in expected_ids:
		assert_true(bal_weapons.has(id), "Balance.weapons missing weapon_id '%s'" % id)


func test_balance_weapons_ranged_lethal_heat_spike_positive() -> void:
	var spike: int = int(Balance.get_data().weapons.get("ranged_lethal_heat_spike", 0))
	assert_gt(spike, 0, "ranged_lethal_heat_spike must be > 0 (FR24 massive Heat intent)")


func test_balance_weapons_per_weapon_has_damage_range_heat_keys() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	var skip_keys := ["weapon_damage_base", "weapon_range_base", "bare_hands_bonus",
		"ranged_lethal_heat_spike", "max_carried_items", "megaphone_defection_curve"]
	for key in bal_weapons.keys():
		if key in skip_keys:
			continue
		var entry = bal_weapons[key]
		assert_true(entry is Dictionary,
			"Balance.weapons['%s'] must be a Dictionary" % key)
		assert_true(entry.has("damage"), "Balance.weapons['%s'] missing 'damage'" % key)
		assert_true(entry.has("range"),  "Balance.weapons['%s'] missing 'range'" % key)
		assert_true(entry.has("heat_on_use"), "Balance.weapons['%s'] missing 'heat_on_use'" % key)


func test_balance_weapons_no_negative_damage() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	var skip_keys := ["weapon_damage_base", "weapon_range_base", "bare_hands_bonus",
		"ranged_lethal_heat_spike", "max_carried_items", "megaphone_defection_curve"]
	for key in bal_weapons.keys():
		if key in skip_keys:
			continue
		var entry = bal_weapons[key]
		if not (entry is Dictionary):
			continue
		assert_gte(int(entry.get("damage", 0)), 0,
			"Balance.weapons['%s'].damage must be >= 0" % key)


func test_balance_weapons_no_negative_range() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	var skip_keys := ["weapon_damage_base", "weapon_range_base", "bare_hands_bonus",
		"ranged_lethal_heat_spike", "max_carried_items", "megaphone_defection_curve"]
	for key in bal_weapons.keys():
		if key in skip_keys:
			continue
		var entry = bal_weapons[key]
		if not (entry is Dictionary):
			continue
		assert_gte(int(entry.get("range", 0)), 0,
			"Balance.weapons['%s'].range must be >= 0" % key)


## Story 3.6 — signature weapon balance invariants (AC2).

func test_balance_signature_weapons_six_ids_present() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	for id in ["evidence_brick", "slop_bag", "megaphone", "signal_jammer", "camera_flash", "fake_id_packet"]:
		assert_true(bal_weapons.has(id), "Balance.weapons missing signature weapon '%s' (Story 3.6)" % id)


func test_balance_signature_per_weapon_keys_well_formed() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	for id in ["evidence_brick", "slop_bag", "megaphone", "signal_jammer", "camera_flash", "fake_id_packet"]:
		var entry = bal_weapons.get(id, null)
		assert_true(entry is Dictionary, "Balance.weapons['%s'] must be a Dictionary" % id)
		assert_true(entry.has("damage"),      "Balance.weapons['%s'] missing 'damage'" % id)
		assert_true(entry.has("range"),       "Balance.weapons['%s'] missing 'range'" % id)
		assert_true(entry.has("heat_on_use"), "Balance.weapons['%s'] missing 'heat_on_use'" % id)


func test_balance_megaphone_defection_curve_well_formed() -> void:
	var curve = Balance.get_data().weapons.get("megaphone_defection_curve", null)
	assert_not_null(curve, "Balance.weapons.megaphone_defection_curve must exist")
	assert_true(curve is Dictionary, "megaphone_defection_curve must be a Dictionary")
	for k in ["yap_game_dc", "yap_game_critical_base_pct", "yap_game_success_base_pct",
			"yap_game_fail_base_pct", "clout_rank_bonus_pct", "max_defection_pct", "tier_restriction"]:
		assert_true(curve.has(k), "megaphone_defection_curve missing key '%s'" % k)


func test_balance_signature_weapons_damage_zero() -> void:
	var bal_weapons: Dictionary = Balance.get_data().weapons
	for id in ["evidence_brick", "slop_bag", "megaphone", "signal_jammer", "camera_flash", "fake_id_packet"]:
		var entry = bal_weapons.get(id, {})
		assert_eq(int(entry.get("damage", -1)), 0,
			"Balance.weapons['%s'].damage must be 0 (payload-by-effect design lock)" % id)


func test_balance_megaphone_defection_curve_tier_restriction_gnoy() -> void:
	var curve: Dictionary = Balance.get_data().weapons.get("megaphone_defection_curve", {})
	assert_eq(curve.get("tier_restriction", ""), "gnoy",
		"megaphone_defection_curve.tier_restriction must be 'gnoy' (design lock)")


## Story 3.7 — tier_ai_pool invariants (AC4).

func test_balance_combat_tier_ai_pool_present() -> void:
	assert_true(Balance.get_data().combat.has("tier_ai_pool"),
		"Balance.combat must have 'tier_ai_pool' key (Story 3.7)")


func test_balance_combat_tier_ai_pool_has_all_five_tiers() -> void:
	var pool: Dictionary = Balance.get_data().combat.get("tier_ai_pool", {})
	for t in EncounterTier.ALL_TIERS:
		assert_true(pool.has(t), "tier_ai_pool must have key '%s'" % t)


func test_balance_combat_tier_ai_pool_all_arrays_non_empty() -> void:
	var pool: Dictionary = Balance.get_data().combat.get("tier_ai_pool", {})
	for t in EncounterTier.ALL_TIERS:
		var arr = pool.get(t, [])
		assert_true(arr is Array and arr.size() > 0,
			"tier_ai_pool['%s'] must be a non-empty Array" % t)


func test_balance_combat_tier_ai_pool_all_values_are_strings() -> void:
	var pool: Dictionary = Balance.get_data().combat.get("tier_ai_pool", {})
	for t in EncounterTier.ALL_TIERS:
		var arr: Array = pool.get(t, [])
		for item in arr:
			assert_true(item is String,
				"tier_ai_pool['%s'] element '%s' must be a String" % [t, str(item)])


## Story 3.8 — counter_tactics + dossier invariants (AC4).

func test_balance_combat_counter_tactics_present() -> void:
	assert_true(Balance.get_data().combat.has("counter_tactics"),
		"Balance.combat must have 'counter_tactics' key (Story 3.8)")


func test_balance_combat_counter_tactics_has_four_scored_tags() -> void:
	var ct: Dictionary = Balance.get_data().combat.get("counter_tactics", {})
	var expected_keys := ["ghost", "broadcast", "hands", "grifter"]
	assert_eq(ct.keys().size(), expected_keys.size(),
		"counter_tactics must have exactly 4 keys")
	for k in expected_keys:
		assert_true(ct.has(k), "counter_tactics must have key '%s'" % k)


func test_balance_combat_counter_tactics_all_non_empty_arrays() -> void:
	var ct: Dictionary = Balance.get_data().combat.get("counter_tactics", {})
	for k in ["ghost", "broadcast", "hands", "grifter"]:
		var arr = ct.get(k, [])
		assert_true(arr is Array and arr.size() > 0,
			"counter_tactics['%s'] must be a non-empty Array" % k)


func test_balance_combat_counter_tactics_all_string_values() -> void:
	var ct: Dictionary = Balance.get_data().combat.get("counter_tactics", {})
	for k in ["ghost", "broadcast", "hands", "grifter"]:
		var arr: Array = ct.get(k, [])
		for item in arr:
			assert_true(item is String,
				"counter_tactics['%s'] element '%s' must be a String" % [k, str(item)])


func test_balance_dossier_present() -> void:
	assert_true("dossier" in Balance.get_data(),
		"Balance must have top-level 'dossier' Dictionary (Story 3.8)")


func test_balance_dossier_has_opsec_delay_days() -> void:
	assert_true(Balance.get_data().dossier.has("opsec_delay_days"),
		"Balance.dossier must have 'opsec_delay_days'")


func test_balance_dossier_classifier_window_actions_positive() -> void:
	assert_gt(int(Balance.get_data().dossier.get("classifier_window_actions", 0)), 0,
		"classifier_window_actions must be > 0")


func test_balance_dossier_classifier_min_actions_positive() -> void:
	assert_gt(int(Balance.get_data().dossier.get("classifier_min_actions", 0)), 0,
		"classifier_min_actions must be > 0")


func test_balance_dossier_classifier_dominance_threshold_pct_in_range() -> void:
	var pct: int = int(Balance.get_data().dossier.get("classifier_dominance_threshold_pct", -1))
	assert_gte(pct, 0, "classifier_dominance_threshold_pct must be >= 0")
	assert_lte(pct, 100, "classifier_dominance_threshold_pct must be <= 100")


func test_balance_dossier_classifier_window_budget_ms_positive() -> void:
	assert_gt(int(Balance.get_data().dossier.get("classifier_window_budget_ms", 0)), 0,
		"classifier_window_budget_ms must be > 0")


func test_balance_dossier_tactical_response_budget_ms_positive() -> void:
	assert_gt(int(Balance.get_data().dossier.get("tactical_response_budget_ms", 0)), 0,
		"tactical_response_budget_ms must be > 0")


## Story 5.5 — Thought Cabinet Balance invariants (AC5).

func test_balance_thoughts_section_present() -> void:
	var bal := Balance.get_data()
	assert_not_null(bal, "Balance must load")
	assert_true(bal.get("thoughts") != null or bal.thoughts != null,
		"Balance.thoughts top-level Dictionary must be present (Story 5.5)")


func test_balance_thoughts_capacity_by_stage_matches_gdd() -> void:
	var caps: Dictionary = Balance.get_data().thoughts.get("active_thread_capacity_by_stage", {})
	assert_eq(int(caps.get(1, -1)), 2, "Stage 1 capacity must be 2 per GDD line 462")
	assert_eq(int(caps.get(2, -1)), 3, "Stage 2 capacity must be 3 per GDD line 462")
	assert_eq(int(caps.get(3, -1)), 5, "Stage 3 capacity must be 5 per GDD line 462")
	assert_eq(int(caps.get(4, -1)), 5, "Stage 4 capacity must be 5 (same as Stage 3 per GDD)")


func test_balance_thoughts_definitions_has_three_placeholders() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	assert_eq(defs.size(), 3, "Balance.thoughts.definitions must have exactly 3 VS placeholder thoughts")
	for tid in ["placeholder_grift_check", "placeholder_xyoner_pattern", "placeholder_self_doubt"]:
		assert_true(defs.has(tid), "Balance.thoughts.definitions must contain '%s'" % tid)


func test_balance_thoughts_every_definition_has_required_keys() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	var required_keys: Array[String] = [
		"title_key", "body_key", "voice_id", "cost_in_slots",
		"reframing_evidence_definition_ids", "reframing_tag",
		"dialogue_line_unlocks", "unlocked_from_start",
	]
	for tid in defs.keys():
		var entry: Dictionary = defs.get(tid, {}) as Dictionary
		for k in required_keys:
			assert_true(entry.has(k),
				"Balance.thoughts.definitions['%s'] must have key '%s'" % [tid, k])


func test_balance_thoughts_voice_id_empty_in_vs() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	for tid in defs.keys():
		var entry: Dictionary = defs.get(tid, {}) as Dictionary
		assert_eq(String(entry.get("voice_id", "MISSING")), "",
			"voice_id must be '' in VS placeholder thought '%s' (Epic 6 Story 6.3 populates)" % tid)


func test_balance_thoughts_dialogue_unlocks_empty_in_vs() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	for tid in defs.keys():
		var entry: Dictionary = defs.get(tid, {}) as Dictionary
		var unlocks: Array = entry.get("dialogue_line_unlocks", [])
		assert_eq(unlocks.size(), 0,
			"dialogue_line_unlocks must be [] in VS placeholder thought '%s' (Epic 6 Story 6.3 authors real ids)" % tid)


func test_balance_thoughts_reframing_def_ids_cross_reference_evidence_catalog() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	for tid in defs.keys():
		var entry: Dictionary = defs.get(tid, {}) as Dictionary
		var ev_ids: Array = entry.get("reframing_evidence_definition_ids", [])
		for ev_id in ev_ids:
			assert_true(EvidenceCatalog.has_evidence(String(ev_id)),
				"thought '%s' references unknown evidence_definition_id '%s' — must be a valid EvidenceCatalog id" % [tid, String(ev_id)])


func test_balance_thoughts_cost_in_slots_positive() -> void:
	var defs: Dictionary = Balance.get_data().thoughts.get("definitions", {})
	for tid in defs.keys():
		var entry: Dictionary = defs.get(tid, {}) as Dictionary
		var cost: int = int(entry.get("cost_in_slots", 0))
		assert_true(cost >= 1,
			"cost_in_slots for thought '%s' must be >= 1, got %d" % [tid, cost])


func test_balance_combat_dossier_opsec_delay_days_removed() -> void:
	assert_false(Balance.get_data().combat.has("dossier_opsec_delay_days"),
		"Balance.combat.dossier_opsec_delay_days must be REMOVED (migrated to dossier.opsec_delay_days)")


func test_save_perf_warn_ms_matches_nfr9() -> void:
	## NFR9: autosave wall-clock budget is 3000ms on min spec. Balance.save_perf_warn_ms is the
	## Logger.warn threshold that fires when this is breached. Drift here means we are tuning
	## the threshold instead of fixing the perf regression.
	var bal := Balance.get_data()
	assert_eq(bal.save_perf_warn_ms, 3000,
		"save_perf_warn_ms must equal NFR9 wall-clock budget (3000ms); change requires NFR9 update")


## Story 3.9 — Balance.audio invariants (AC5).

func test_balance_audio_present() -> void:
	var bal := Balance.get_data()
	assert_not_null(bal, "Balance must load")
	assert_true("audio" in bal, "Balance must have top-level 'audio' Dictionary (Story 3.9)")
	assert_true(bal.audio is Dictionary and not bal.audio.is_empty(),
		"Balance.audio must be a non-empty Dictionary")


func test_balance_audio_footstep_bus_is_sfx_world_or_master() -> void:
	var bus: String = String(Balance.get_data().audio.get("footstep_bus", ""))
	assert_true(bus in ["SFX_World", "Master"],
		"Balance.audio.footstep_bus must be 'SFX_World' or 'Master', got '%s'" % bus)


func test_balance_audio_footstep_visible_radius_positive() -> void:
	var r: float = float(Balance.get_data().audio.get("footstep_visible_radius_px", 0.0))
	assert_gt(r, 0.0, "footstep_visible_radius_px must be > 0")


func test_balance_audio_footstep_audible_radius_exceeds_visible() -> void:
	var audible: float = float(Balance.get_data().audio.get("footstep_audible_radius_px", 0.0))
	var visible: float = float(Balance.get_data().audio.get("footstep_visible_radius_px", 0.0))
	assert_true(audible > visible,
		"HARD INVARIANT: footstep_audible_radius_px (%s) must exceed footstep_visible_radius_px (%s) — sound-as-gameplay contract" % [audible, visible])


func test_balance_audio_footstep_attenuation_positive() -> void:
	var att: float = float(Balance.get_data().audio.get("footstep_attenuation", 0.0))
	assert_gt(att, 0.0, "footstep_attenuation must be > 0")


func test_balance_audio_footstep_volume_db_in_range() -> void:
	var vol: float = float(Balance.get_data().audio.get("footstep_volume_db", -999.0))
	assert_gte(vol, -60.0, "footstep_volume_db must be >= -60")
	assert_lte(vol, 0.0, "footstep_volume_db must be <= 0")


func test_balance_audio_footstep_pip_duration_positive() -> void:
	var dur: int = int(Balance.get_data().audio.get("footstep_pip_duration_ms", 0))
	assert_gt(dur, 0, "footstep_pip_duration_ms must be > 0")


func test_balance_audio_footstep_pip_fade_le_duration() -> void:
	var dur: int = int(Balance.get_data().audio.get("footstep_pip_duration_ms", 0))
	var fade: int = int(Balance.get_data().audio.get("footstep_pip_fade_ms", 0))
	assert_lte(fade, dur, "footstep_pip_fade_ms must be <= footstep_pip_duration_ms")


func test_balance_audio_combat_intensity_per_tier_has_all_five_tiers() -> void:
	var map: Dictionary = Balance.get_data().audio.get("combat_intensity_per_tier", {})
	for t in EncounterTier.ALL_TIERS:
		assert_true(map.has(t),
			"combat_intensity_per_tier must have key '%s'" % t)


func test_balance_audio_combat_intensity_levels_in_range() -> void:
	var map: Dictionary = Balance.get_data().audio.get("combat_intensity_per_tier", {})
	for t in map.keys():
		var level: int = int(map[t])
		assert_gte(level, 0, "combat_intensity_per_tier['%s'] must be >= 0" % t)
		assert_lte(level, 3, "combat_intensity_per_tier['%s'] must be <= 3" % t)


func test_balance_audio_combat_intensity_routine_is_zero() -> void:
	var map: Dictionary = Balance.get_data().audio.get("combat_intensity_per_tier", {})
	assert_eq(int(map.get("routine", -1)), 0,
		"INVARIANT: combat_intensity_per_tier.routine must be 0 (no-intensity tier)")


func test_balance_audio_combat_intensity_boss_phase_is_max_three() -> void:
	var map: Dictionary = Balance.get_data().audio.get("combat_intensity_per_tier", {})
	assert_eq(int(map.get("boss_phase", -1)), 3,
		"INVARIANT: combat_intensity_per_tier.boss_phase must be 3 (max intensity per GDD)")


## Story 3.10 — difficulty_tiers invariants (AC1).

func test_balance_combat_difficulty_tiers_present() -> void:
	assert_true(Balance.get_data().combat.has("difficulty_tiers"),
		"Balance.combat must have 'difficulty_tiers' key (Story 3.10)")


func test_balance_combat_difficulty_tiers_has_all_three() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	var expected := {"lethal": true, "balanced": true, "forgiving": true}
	assert_eq(tiers.keys().size(), 3, "difficulty_tiers must have exactly 3 keys")
	for k in expected.keys():
		assert_true(tiers.has(k), "difficulty_tiers must have key '%s'" % k)


func test_balance_combat_difficulty_lethal_baseline_locked() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	var lethal: Dictionary = tiers.get("lethal", {})
	assert_true(is_equal_approx(float(lethal.get("enemy_damage_mult", -1.0)), 1.0),
		"HARD INVARIANT: lethal.enemy_damage_mult must be exactly 1.0")
	assert_true(is_equal_approx(float(lethal.get("hit_threshold_mult", -1.0)), 1.0),
		"HARD INVARIANT: lethal.hit_threshold_mult must be exactly 1.0")


func test_balance_combat_difficulty_balanced_directional_invariant() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	var balanced: Dictionary = tiers.get("balanced", {})
	assert_lte(float(balanced.get("enemy_damage_mult", 99.0)), 1.0,
		"balanced.enemy_damage_mult must be <= 1.0")
	assert_gte(float(balanced.get("hit_threshold_mult", 0.0)), 1.0,
		"balanced.hit_threshold_mult must be >= 1.0")


func test_balance_combat_difficulty_forgiving_directional_invariant() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	var forgiving: Dictionary = tiers.get("forgiving", {})
	assert_lte(float(forgiving.get("enemy_damage_mult", 99.0)), 1.0,
		"forgiving.enemy_damage_mult must be <= 1.0")
	assert_gte(float(forgiving.get("hit_threshold_mult", 0.0)), 1.0,
		"forgiving.hit_threshold_mult must be >= 1.0")


func test_balance_combat_difficulty_forgiving_more_lenient_than_balanced() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	var balanced: Dictionary = tiers.get("balanced", {})
	var forgiving: Dictionary = tiers.get("forgiving", {})
	assert_lte(float(forgiving.get("enemy_damage_mult", 99.0)), float(balanced.get("enemy_damage_mult", 99.0)),
		"forgiving.enemy_damage_mult must be <= balanced.enemy_damage_mult")
	assert_gte(float(forgiving.get("hit_threshold_mult", 0.0)), float(balanced.get("hit_threshold_mult", 0.0)),
		"forgiving.hit_threshold_mult must be >= balanced.hit_threshold_mult")


func test_balance_combat_difficulty_all_mults_positive() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	for tier_name in tiers.keys():
		var tier: Dictionary = tiers[tier_name]
		for mult_key in ["enemy_damage_mult", "hit_threshold_mult"]:
			assert_gt(float(tier.get(mult_key, 0.0)), 0.0,
				"difficulty_tiers.%s.%s must be > 0.0" % [tier_name, mult_key])


func test_balance_combat_difficulty_all_mults_finite() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	for tier_name in tiers.keys():
		var tier: Dictionary = tiers[tier_name]
		for mult_key in ["enemy_damage_mult", "hit_threshold_mult"]:
			assert_true(is_finite(float(tier.get(mult_key, 0.0))),
				"difficulty_tiers.%s.%s must be finite (no NaN/INF)" % [tier_name, mult_key])


## Story 4.2 — AC4: Balance.equipment dictionary invariants.

func test_balance_resource_equipment_field_exists() -> void:
	var bal := Balance.get_data()
	assert_not_null(bal, "Balance must load")
	assert_true("equipment" in bal,
		"BalanceResource must have top-level 'equipment' Dictionary (Story 4.2)")


func test_balance_resource_equipment_xyoner_heat_default_is_5() -> void:
	var eq_dict: Dictionary = Balance.get_data().equipment
	assert_true(eq_dict.has("xyoner_carrying_heat_per_item"),
		"Balance.equipment must have 'xyoner_carrying_heat_per_item'")
	assert_eq(int(eq_dict["xyoner_carrying_heat_per_item"]), 5,
		"xyoner_carrying_heat_per_item must default to 5 (one-fifth of heat tier-step)")


func test_balance_resource_per_tier_stat_magnitude_has_all_5_tiers() -> void:
	var magnitude: Dictionary = Balance.get_data().equipment.get("per_tier_stat_magnitude", {})
	for tier in Equipment.ALL_TIERS:
		assert_true(magnitude.has(tier),
			"per_tier_stat_magnitude must have key '%s'" % tier)


func test_balance_tres_loads_equipment_dict() -> void:
	var eq_dict = Balance.get_data().equipment
	assert_true(eq_dict is Dictionary and not eq_dict.is_empty(),
		"balance.tres must serialize 'equipment' as a non-empty Dictionary")


func test_balance_tres_equipment_xyoner_heat_matches_resource_default() -> void:
	var tres_val: int = int(Balance.get_data().equipment.get("xyoner_carrying_heat_per_item", -1))
	var res_default: int = 5
	assert_eq(tres_val, res_default,
		"balance.tres xyoner_carrying_heat_per_item must match resource default (%d)" % res_default)


func test_balance_combat_difficulty_each_tier_has_both_keys() -> void:
	var tiers: Dictionary = Balance.get_data().combat.get("difficulty_tiers", {})
	for tier_name in tiers.keys():
		var tier: Dictionary = tiers[tier_name]
		assert_true(tier.has("enemy_damage_mult"),
			"difficulty_tiers.%s must have 'enemy_damage_mult' key" % tier_name)
		assert_true(tier.has("hit_threshold_mult"),
			"difficulty_tiers.%s must have 'hit_threshold_mult' key" % tier_name)


# ── Story 5.2 — Investigation balance invariants (AC10) ───────────────────────

func test_balance_investigation_section_present() -> void:
	var bal := Balance.get_data()
	assert_true(bal.investigation is Dictionary, "Balance.investigation must be a Dictionary")
	assert_true(bal.investigation.has("board_visible_capacity_by_stage"),
		"Balance.investigation must have board_visible_capacity_by_stage key")
	assert_true(bal.investigation.has("board_nudge_step_px"),
		"Balance.investigation must have board_nudge_step_px key")


func test_board_visible_capacity_by_stage_keyed_1_to_4_monotonic_ascending() -> void:
	var bal := Balance.get_data()
	var caps: Dictionary = bal.investigation.get("board_visible_capacity_by_stage", {})
	assert_eq(caps.keys().size(), 4, "board_visible_capacity_by_stage must have exactly 4 keys (stages 1–4)")
	for stage in [1, 2, 3, 4]:
		assert_true(caps.has(stage), "board_visible_capacity_by_stage must have key %d" % stage)
	var prev_val := -1
	for stage in [1, 2, 3, 4]:
		var val: int = int(caps[stage])
		assert_true(val > prev_val, "board_visible_capacity_by_stage must be strictly ascending: stage %d (%d) must be > %d" % [stage, val, prev_val])
		prev_val = val

func test_balance_investigation_connection_section_present() -> void:
	var inv: Dictionary = Balance.get_data().investigation
	for key in ["connection_skill_by_category", "connection_skill_category_precedence",
				"connection_dc_base", "connection_credibility_penalty",
				"connection_cage_planted_glowie_sense_modifier"]:
		assert_true(inv.has(key), "Balance.investigation missing key: %s" % key)


func test_connection_skill_by_category_covers_all_six_categories() -> void:
	var by_cat: Dictionary = Balance.get_data().investigation.get("connection_skill_by_category", {})
	var expected_cats := ["symbol", "forensic", "testimony", "digital", "physical", "receipt"]
	for cat in expected_cats:
		assert_true(by_cat.has(cat), "connection_skill_by_category missing category: %s" % cat)
		var skill_id: String = String(by_cat[cat])
		assert_true(Skills.is_valid_id(skill_id),
			"connection_skill_by_category[%s]=%s is not a valid skill id" % [cat, skill_id])


func test_connection_skill_category_precedence_six_entries_unique_categories() -> void:
	var prec: Array = Balance.get_data().investigation.get("connection_skill_category_precedence", [])
	assert_eq(prec.size(), 6, "connection_skill_category_precedence must have exactly 6 entries")
	var seen: Array = []
	for cat in prec:
		assert_false(seen.has(cat), "duplicate category in precedence: %s" % cat)
		seen.append(cat)


func test_connection_dc_base_is_int() -> void:
	var dc = Balance.get_data().investigation.get("connection_dc_base", null)
	assert_not_null(dc, "connection_dc_base must be present")
	assert_eq(typeof(dc), TYPE_INT, "connection_dc_base must be an int")


func test_connection_credibility_penalty_three_outcome_keys() -> void:
	var pen: Dictionary = Balance.get_data().investigation.get("connection_credibility_penalty", {})
	for key in ["verified", "probable", "uncertain"]:
		assert_true(pen.has(key), "connection_credibility_penalty missing outcome: %s" % key)



# Story 5.4 -- Publication section invariants

func test_balance_publication_section_present() -> void:
	var bal := Balance.get_data()
	assert_true(bal.has_method("get") or "publication" in bal,
		"Balance.publication section must be present")
	var pub = bal.publication
	assert_true(pub is Dictionary, "publication must be a Dictionary")
	assert_false((pub as Dictionary).is_empty(), "publication dict must not be empty")


func test_balance_publication_platforms_cover_catalog() -> void:
	var platforms: Dictionary = Balance.get_data().publication.get("platforms", {})
	for id in PublicationCatalog.ALL_PLATFORMS:
		assert_true(platforms.has(id),
			"Balance.publication.platforms must have entry for '%s'" % id)


func test_balance_publication_framings_cover_catalog() -> void:
	var framings: Dictionary = Balance.get_data().publication.get("framings", {})
	for id in PublicationCatalog.ALL_FRAMINGS:
		assert_true(framings.has(id),
			"Balance.publication.framings must have entry for '%s'" % id)


func test_balance_publication_audiences_cover_catalog() -> void:
	var audiences: Dictionary = Balance.get_data().publication.get("audiences", {})
	for id in PublicationCatalog.ALL_AUDIENCES:
		assert_true(audiences.has(id),
			"Balance.publication.audiences must have entry for '%s'" % id)


func test_balance_publication_outcome_multipliers_have_all_3_keys() -> void:
	var mults: Dictionary = Balance.get_data().publication.get("skill_check_outcome_multipliers", {})
	for outcome in ["critical_success", "success", "fail"]:
		assert_true(mults.has(outcome),
			"skill_check_outcome_multipliers must have key '%s'" % outcome)


func test_balance_publication_every_platform_skill_valid() -> void:
	var platforms: Dictionary = Balance.get_data().publication.get("platforms", {})
	for id in PublicationCatalog.ALL_PLATFORMS:
		var profile: Dictionary = platforms.get(id, {})
		var skill_id: String = String(profile.get("skill_id", ""))
		assert_true(Skills.is_valid_id(skill_id),
			"Balance.publication.platforms['%s'].skill_id='%s' must be valid" % [id, skill_id])


# Story 5.6 — stamp_grammar section invariants

func test_balance_stamp_grammar_section_present() -> void:
	var bal := Balance.get_data()
	assert_true(typeof(bal.stamp_grammar) == TYPE_DICTIONARY,
		"Balance.stamp_grammar must be a Dictionary")
	assert_false((bal.stamp_grammar as Dictionary).is_empty(),
		"Balance.stamp_grammar must not be empty")


func test_stamp_grammar_per_stamp_covers_all_four_types() -> void:
	var per: Dictionary = Balance.get_data().stamp_grammar.get("per_stamp", {})
	for id in ["skill_check_badge", "publication_stamp", "thought_completion", "subscription_cancel"]:
		assert_true(per.has(id),
			"Balance.stamp_grammar.per_stamp must have entry for '%s'" % id)


func test_skill_check_badge_envelope_under_200ms() -> void:
	var per: Dictionary = Balance.get_data().stamp_grammar.get("per_stamp", {})
	var ms: int = int(per.get("skill_check_badge", {}).get("duration_ms", 999))
	assert_lte(ms, 200,
		"stamp_grammar.per_stamp.skill_check_badge.duration_ms must be <= 200 (UX-DR130 hard ceiling)")


func test_commit_stamps_envelope_in_300_500_corridor() -> void:
	var per: Dictionary = Balance.get_data().stamp_grammar.get("per_stamp", {})
	for id in ["publication_stamp", "thought_completion", "subscription_cancel"]:
		var ms: int = int(per.get(id, {}).get("duration_ms", 0))
		assert_gte(ms, 300,
			"stamp_grammar.per_stamp.%s.duration_ms must be >= 300 (UX-DR131 corridor)" % id)
		assert_lte(ms, 500,
			"stamp_grammar.per_stamp.%s.duration_ms must be <= 500 (UX-DR131 corridor)" % id)


func test_rotation_degrees_locked_at_5_0_minus5() -> void:
	var sg: Dictionary = Balance.get_data().stamp_grammar
	assert_almost_eq(float(sg.get("rotation_verified_deg", 0.0)), 5.0, 0.001,
		"rotation_verified_deg must be exactly 5.0 (locked design)")
	assert_almost_eq(float(sg.get("rotation_probable_deg", 99.0)), 0.0, 0.001,
		"rotation_probable_deg must be exactly 0.0 (locked design)")
	assert_almost_eq(float(sg.get("rotation_uncertain_deg", 0.0)), -5.0, 0.001,
		"rotation_uncertain_deg must be exactly -5.0 (locked design)")


func test_dice_flip_count_in_3_to_4_corridor() -> void:
	var count: int = int(Balance.get_data().stamp_grammar.get("dice_flip_count", 0))
	assert_gte(count, 3, "dice_flip_count must be >= 3 (UX-DR130 spec)")
	assert_lte(count, 4, "dice_flip_count must be <= 4 (UX-DR130 spec)")


func test_legacy_cancellation_stamp_duration_key_still_present() -> void:
	var sub_cancel: Dictionary = Balance.get_data().subscription_cancellation
	assert_true(sub_cancel.has("cancellation_stamp_duration_ms"),
		"Legacy subscription_cancellation.cancellation_stamp_duration_ms must still exist for 2.4 back-compat")


## Story 5.7 — awakening_reveal sub-dict invariants (AC1).

func test_balance_investigation_awakening_reveal_sub_dict_present() -> void:
	var inv: Dictionary = Balance.get_data().investigation
	assert_true(inv.has("awakening_reveal"),
		"Balance.investigation must have 'awakening_reveal' sub-dict (Story 5.7)")
	var reveal: Dictionary = inv.get("awakening_reveal", {})
	assert_true(reveal is Dictionary, "awakening_reveal must be a Dictionary")
	for key in ["cage_planted_reveal_at_awakening", "symbol_tooltip_at_awakening",
				"default_reframing_tag_visible_at_awakening", "per_tag_visible_at_awakening"]:
		assert_true(reveal.has(key), "awakening_reveal missing key: %s" % key)


func test_awakening_reveal_thresholds_in_1_10_range() -> void:
	var reveal: Dictionary = Balance.get_data().investigation.get("awakening_reveal", {})
	var cage_val: int = int(reveal.get("cage_planted_reveal_at_awakening", 0))
	assert_gte(cage_val, 1, "cage_planted_reveal_at_awakening must be >= 1")
	assert_lte(cage_val, 10, "cage_planted_reveal_at_awakening must be <= 10")
	var sym_val: int = int(reveal.get("symbol_tooltip_at_awakening", 0))
	assert_gte(sym_val, 1, "symbol_tooltip_at_awakening must be >= 1")
	assert_lte(sym_val, 10, "symbol_tooltip_at_awakening must be <= 10")


func test_awakening_reveal_default_reframing_threshold_equals_1_for_5_5_back_compat() -> void:
	var reveal: Dictionary = Balance.get_data().investigation.get("awakening_reveal", {})
	assert_eq(int(reveal.get("default_reframing_tag_visible_at_awakening", -1)), 1,
		"default_reframing_tag_visible_at_awakening must be 1 (Story 5.5 back-compat: immediate surfacing)")


func test_awakening_reveal_per_tag_dict_typeof_dictionary() -> void:
	var reveal: Dictionary = Balance.get_data().investigation.get("awakening_reveal", {})
	var per_tag = reveal.get("per_tag_visible_at_awakening", null)
	assert_not_null(per_tag, "per_tag_visible_at_awakening must be present")
	assert_eq(typeof(per_tag), TYPE_DICTIONARY, "per_tag_visible_at_awakening must be a Dictionary")


func test_balance_investigation_connection_credibility_penalty_unchanged_post_5_7() -> void:
	var pen: Dictionary = Balance.get_data().investigation.get("connection_credibility_penalty", {})
	assert_eq(int(pen.get("verified", 999)), 0, "connection_credibility_penalty.verified must still be 0")
	assert_eq(int(pen.get("probable", 999)), -2, "connection_credibility_penalty.probable must still be -2")
	assert_eq(int(pen.get("uncertain", 999)), -5, "connection_credibility_penalty.uncertain must still be -5")


func test_awakening_reveal_cage_planted_default_7_and_symbol_default_5() -> void:
	var reveal: Dictionary = Balance.get_data().investigation.get("awakening_reveal", {})
	assert_eq(int(reveal.get("cage_planted_reveal_at_awakening", 0)), 7,
		"cage_planted_reveal_at_awakening default must be 7 (UX-DR96 / GDD line 94)")
	assert_eq(int(reveal.get("symbol_tooltip_at_awakening", 0)), 5,
		"symbol_tooltip_at_awakening default must be 5 (GDD line 329 — Awakening 5 cinematic)")


func test_sfx_placeholder_streams_all_four_paths_present() -> void:
	var streams: Dictionary = Balance.get_data().stamp_grammar.get("sfx_placeholder_streams", {})
	for id in ["skill_check_badge", "publication_stamp", "thought_completion", "subscription_cancel"]:
		assert_true(streams.has(id),
			"stamp_grammar.sfx_placeholder_streams must have entry for '%s'" % id)
		assert_ne(String(streams.get(id, "")), "",
			"stamp_grammar.sfx_placeholder_streams['%s'] must not be empty" % id)


## Story 6.1 — AC2: Balance.dialogue sub-dict invariants.

func test_balance_dialogue_sub_dict_present() -> void:
	var data := Balance.get_data()
	assert_true(data.get("dialogue") != null or data.has_method("get") or data.dialogue != null,
		"Balance must have 'dialogue' export var (Story 6.1 AC2)")
	var d: Dictionary = data.dialogue
	assert_true(d is Dictionary, "Balance.dialogue must be a Dictionary")


func test_balance_dialogue_node_resolve_budget_ms_positive() -> void:
	var d: Dictionary = Balance.get_data().dialogue
	var v: int = int(d.get("node_resolve_budget_ms", 0))
	assert_gt(v, 0, "node_resolve_budget_ms must be > 0 (NFR8)")


func test_balance_dialogue_voice_cap_per_dialogue_positive() -> void:
	var d: Dictionary = Balance.get_data().dialogue
	var v: int = int(d.get("voice_cap_per_dialogue", 0))
	assert_gt(v, 0, "voice_cap_per_dialogue must be > 0")


func test_balance_dialogue_tier_ids_non_empty_array() -> void:
	var d: Dictionary = Balance.get_data().dialogue
	var tier_ids: Variant = d.get("tier_ids", null)
	assert_not_null(tier_ids, "tier_ids must be present in dialogue dict")
	assert_gt((tier_ids as Array).size(), 0, "tier_ids must be non-empty (FR66)")


func test_balance_dialogue_voice_scaling_default_has_all_keys() -> void:
	var d: Dictionary = Balance.get_data().dialogue
	var vsd: Dictionary = d.get("voice_scaling_default", {})
	for key in ["base_floor", "awakening_curve", "fatigue_curve", "cope_curve"]:
		assert_true(vsd.has(key), "voice_scaling_default must have key '%s'" % key)


func test_balance_dialogue_tier_word_budgets_is_dictionary() -> void:
	var d: Dictionary = Balance.get_data().dialogue
	var twb: Variant = d.get("tier_word_budgets", null)
	assert_not_null(twb, "tier_word_budgets must be present")
	assert_eq(typeof(twb), TYPE_DICTIONARY, "tier_word_budgets must be a Dictionary (may be empty in 6.1)")
