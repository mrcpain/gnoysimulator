class_name BalanceResource extends Resource

## All game magic numbers live here. Forbidden: hardcoded values outside this file (arch §7.2).
## See `docs/balance-guide.md` for the design-constant vs balance-tunable taxonomy.
## Stub fields — later stories populate values. All empty/zero defaults are intentional.

# RPG (Stories 1.1–1.7)
@export var dc_table: Dictionary = {}
# skill_xp_per_use: keys = outcome strings ("critical"/"success"/"fail"), values = int XP awarded.
# Baseline: {"critical": 2, "success": 1, "fail": 1} — fail always grants XP per AC2.
@export var skill_xp_per_use: Dictionary = {}
# skill_xp_thresholds: cumulative XP needed to reach rank i+1. 10 entries for ranks 1–10.
# E.g. thresholds[0]=10 means 10 total XP to reach rank 1.
@export var skill_xp_thresholds: Array[int] = []
@export var awakening_thresholds: Array[int] = []
# talent_passive_magnitudes: keyed as "{talent_id}.{modifier_key}" → float magnitude.
# Missing key → get_talent_modifier() returns 0.0 for that contribution (safe default).
# Boolean-style flags (active/inactive) use 1.0/0.0.
@export var talent_passive_magnitudes: Dictionary = {}
# talent_cost_overrides: keyed as talent_id → int cost. Missing = TalentDefinition.cost (default 1).
@export var talent_cost_overrides: Dictionary = {}

# Day cycle (Story 2.1) — duration tunables for time advance.
# Primary key:
#   minutes_per_slot: int — minutes a single advance_slot call advances the clock.
# Structural identity (4 slots/day, 7 days/week, slot id strings) remains LOCKED in
# WorldClock per the Story 1.12 contract; only durations are tunable here.
@export var day_cycle: Dictionary = {
	"minutes_per_slot": 360,
}

# Slot-spend per-type effects (Story 2.3). Read by SlotSpendEngine.commit on every spend.
# Schema: { slot_type_string: { "fatigue_delta": int, "cope_overwork_delta": int } }
# Missing slot_type → zero deltas (no-op). Missing keys inside an entry → zero for that channel.
# Negative deltas are legal: Rest's negative values encode "Rest restores Cope and reduces Fatigue."
# Initial values are placeholders for vertical-slice tuning — designers tune in playtest.
@export var slot_spend_effects: Dictionary = {
	"investigation": {"fatigue_delta":  4, "cope_overwork_delta":  1},
	"publication":   {"fatigue_delta":  2, "cope_overwork_delta":  3},
	"combat_op":     {"fatigue_delta":  6, "cope_overwork_delta":  4},
	"social":        {"fatigue_delta":  2, "cope_overwork_delta":  1},
	"maintenance":   {"fatigue_delta":  1, "cope_overwork_delta":  0},
	"cover":         {"fatigue_delta":  3, "cope_overwork_delta":  2},
	"rest":          {"fatigue_delta": -3, "cope_overwork_delta": -2},
}

# Politburo (Epic 7)
@export var politburo_tick_budget_ms: int = 500

# Audio (Epic 13)
@export var crossfade_duration_seconds: float = 4.0

# Subscription cancellation (Story 2.4). FR104 / FR106 / UX-DR40 / UX-DR83 / UX-DR131 / UX-DR132.
# feed_segment_delay_minutes: in-game minutes between commit and feed_segment_due dispatch.
# loading_spinner_duration_min/max_seconds: artificial 2-3s satire delay (UX-DR132).
# cancellation_stamp_duration_ms: stamp animation envelope [300, 500] (UX-DR131).
@export var subscription_cancellation: Dictionary = {
	"feed_segment_delay_minutes": 60,
	"loading_spinner_duration_min_seconds": 2.0,
	"loading_spinner_duration_max_seconds": 3.0,
	"cancellation_stamp_duration_ms": 400,
}

# Economy (Epic 2) — subscription monthly costs (Story 2.4 populated; Story 2.5 Sleep first reader).
# Keys mirror SubscriptionCatalog.ALL_IDS — test_balance_subscription_costs_match_catalog locks in sync.
@export var subscription_costs: Dictionary = {
	"sloppflix": 12,
	"deliver_easy": 15,
	"feedgram_premium": 10,
	"gnoy_gym": 20,
	"feedboost_supplements": 35,
	"trough_loyalty": 0,
}

# Monthly billing (Story 2.5) — FR103, FR105.
# days_per_month: in-game days between billing cycles. 28 = 4 weeks (calendar-friendly + clean math).
# starting_money: fresh-save wallet seed. 100 = enough to barely survive one month at default
#   rent (50) + subs (92) for the first month, design intent "slop economy bleeds you dry."
@export var billing: Dictionary = {
	"days_per_month": 28,
	"starting_money": 100,
}

# Rent per homebase stage (Story 2.5). Keys are int homebase stages 1-4 (FR98).
# 1=Apartment / 2=Office / 3=Underground HQ / 4=Distributed Cell Network.
# Locked rent ramp: each stage roughly doubles to create economic pressure to NOT advance recklessly.
@export var rent_per_homebase_stage: Dictionary = {
	1: 50,
	2: 100,
	3: 150,
	4: 200,
}

# Cope / Fatigue tick (Story 2.6) — FR79, FR80, FR81.
# sleep_recovery: deltas applied on every day_advanced (sleep, late slot-spend, etc.).
#   partial_fatigue_delta: regular-day fatigue reduction (~1 of 4 tier widths). Floor-clamped
#     in CopeFatigueEngine so accumulator never goes below 0.
#   partial_cope_delta: regular-day cope_overwork_debit reduction (~1 high-cost slot's worth).
#   Off-day FULL restore (deltas = -current_accumulator) is computed at runtime, not tuned here.
# fatigue_per_action: per-skill_id fatigue increment when EventBus.skill_check_resolved fires.
#   VS-locked default: only "npc_mode" mapped (FR80 — NPC Mode rolls in Xyoner-space pay fatigue).
#   Future Epic 6 ("contradiction" key) and Epic 9 ("xyoner_space_entry" or similar) extend.
#   Missing skill_id keys are silent no-ops (engine reads with default 0).
@export var cope_fatigue: Dictionary = {
	"sleep_recovery": {
		"partial_fatigue_delta": -25,
		"partial_cope_delta": -10,
	},
	"fatigue_per_action": {
		"npc_mode": 2,
	},
}

# Wages + alt-income (Story 2.7) — FR36, FR164.
# paycheck_per_cover_slot: int credited to RPGCore.money on every successful cover-slot spend
#   while RPGCore.job_state == "employed". 0 disables the wage path (designer toggle).
#   Default 8: at default 4 slots/day with one Afternoon Cover spend per workday, this nets
#   ~160/month — covers default rent (50) + a couple subscriptions but not all, reinforcing
#   FR36's "financial pressure" intent.
# alt_income_rates: per-source credit applied once per day on day_advanced while job_state ==
#   "quit". Iteration order locked by JobIncomeEngine.ALT_INCOME_SOURCE_ORDER. VS-locked
#   defaults are ALL ZERO — sources are gated on systems that don't yet exist (Quartermaster
#   = Epic 8, Signal Hijack = Epic 6, boss seized-asset ops = Epic 11). Future stories raise
#   non-zero rates by Dictionary mutation.
@export var wages: Dictionary = {
	"paycheck_per_cover_slot": 8,
	"alt_income_rates": {
		"network_payments": 0,
		"pirate_broadcast": 0,
		"market_sales": 0,
		"seized_xyoner": 0,
	},
}

# Slop Damage track (Story 2.8) — FR20, FR106.
# heal_amounts: per-food-id Dictionary of {body_delta: int, slop_damage_delta: int}.
#   body_delta credited to RPGCore.attributes["BODY"] (clamped to [0, MAX] by Story 1.1).
#   slop_damage_delta emitted on EventBus.slop_damage_input (post-talent-modifier; the
#   slop_resistant talent halves it via Talents.MOD_SLOP_DAMAGE_TICK = -50.0).
#   VS-locked entries cover the three GDD §"The Fridge" foods + a placeholder combat-heal
#   entry; Epic 3 combat-heal story will replace combat_slop_pack with the real ID.
# drift_thresholds: tier-name -> minimum slop_damage value. Locked at four tiers; designer-tunable
#   numbers. tier_clean=0 is the no-drift baseline; tier_terminal=75 is the "the cost has come due."
# drift_per_tier: tier-name -> {body_drift: int, mind_drift: int, cope_overwork_delta: int}.
#   Applied by SlopDamageDriftEngine._on_sleep_committed once per in-game day. body_drift /
#   mind_drift are NEGATIVE (downward attribute drift); cope_overwork_delta is POSITIVE
#   (positive debit LOWERS the Cope snapshot per Story 1.7 compute_cope formula).
@export var slop: Dictionary = {
	"heal_amounts": {
		"mcxyon_leftovers": {"body_delta": 2, "slop_damage_delta": 8},
		"nutrimax_shake":   {"body_delta": 1, "slop_damage_delta": 4},
		"xtrasoda":         {"body_delta": 1, "slop_damage_delta": 6},
		"combat_slop_pack": {"body_delta": 3, "slop_damage_delta": 12},
	},
	"drift_thresholds": {
		"tier_clean":    0,
		"tier_marked":   25,
		"tier_swollen":  50,
		"tier_terminal": 75,
	},
	"drift_per_tier": {
		"tier_clean":    {"body_drift":  0, "mind_drift":  0, "cope_overwork_delta": 0},
		"tier_marked":   {"body_drift":  0, "mind_drift":  0, "cope_overwork_delta": 1},
		"tier_swollen":  {"body_drift": -1, "mind_drift":  0, "cope_overwork_delta": 2},
		"tier_terminal": {"body_drift": -1, "mind_drift": -1, "cope_overwork_delta": 4},
	},
}

# Combat (Story 3.1 + Story 3.2 + Story 3.3) — FR14, FR16, FR17, FR155 + arch §3.5 D-COMBAT-01.
# (Story 3.1 keys — unchanged)
#   restart_budget_ms: soft warn threshold for EncounterDirector.request_restart (UX-DR74).
# (Story 3.2 keys — unchanged)
#   hit_threshold_base: baseline shots-to-down at BODY=0 (Wageworker absorbs N shots before
#     BODY drops by 1). NOT zero — every player has one free recoverable hit per BODY.
#   hit_threshold_per_body: each BODY point adds this many shots to the threshold. BODY=5
#     → +5 shots over base; BODY=10 → +10. With base=2 and per_body=1: BODY=10 → 12-shot
#     threshold = exactly at invincibility_cap.hit_threshold = 12 (FR16 lock).
#   gymmaxx_speed_curve: 11-entry move-speed percentage curve (index 0 = rank 0 = 100%;
#     index 10 = rank 10 = 200%). LINEAR for VS; designer non-linear tuning at playtest.
#   gymmaxx_dodge_curve: 11-entry dodge-window milliseconds curve.
#   hands_damage_curve: 11-entry base melee damage curve. Story 3.5 weapons further modulate.
#   hands_disarm_curve: 11-entry disarm-chance percentage curve. Story 3.5 ships the effect.
#   ghost_mode_strike_curve: 11-entry stealth first-strike multiplier curve. ONE-SHOT per
#     encounter (does NOT grant invincibility per FR16 — bounded by encounter-lifetime budget).
#   invincibility_cap: design lock per FR16. hit_threshold MAY never exceed this value.
#     Balance lint test asserts <= 12 (build-time enforcement).
# (Story 3.3 keys — new)
#   yield_intel_dc: baseline DC for the YIELD GUT check. At GUT=5 (Wageworker default), pass
#     rate is roughly 25%. Lower DC = leniency.
#   yield_intel_curve: 11-entry array of intel-report counts per GUT value (index 0 = rank 0
#     = 4 reports; index 10 = rank 10 = 0 reports). Monotonic non-increasing. Story 3.3 emits
#     N gnoym_interrogated signals per the indexed value; Epic 7 Story 7.2 subscribes.
#   yield_fail_intel_multiplier: multiplier on intel_count when YIELD GUT check fails.
#     2× = "low GUT = significant intel leak" per gdd line 522.
#   escape_dc_base: baseline DC for the GHOST + Gymmaxx escape check. Tuning hook: 14 is the
#     "Wageworker fails ~95% of the time" gate. Investment in GHOST + Gymmaxx is the gateway.
#   escape_dc_situation_modifiers: RESERVED for Story 3.7+. Empty dict today; future
#     {"surrounded": 3, "high_heat_district": 2} entries will sum into the DC.
#   escape_fail_heat_penalty: heat delta applied to the encounter's district on failed escape.
#     15 = one tier-step (per hud_heat_thresholds 25/50/75).
#   escape_fail_recruit_exposure_pct: RESERVED for Epic 8 Story 8.5. Story 3.3 does NOT
#     consume this; just declares the centralized tuning hook for the recruit-exposure roll.
#
# (Story 3.8 added counter_tactics + new top-level dossier Dictionary — see below.)
@export var combat: Dictionary = {
	# ── Story 3.1 keys ──
	"restart_budget_ms": 500,
	# ── Story 3.2 keys ──
	"hit_threshold_base": 2,
	"hit_threshold_per_body": 1,
	"gymmaxx_speed_curve":  [100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200],
	"gymmaxx_dodge_curve":  [100, 130, 160, 190, 220, 250, 280, 310, 340, 370, 400],
	"hands_damage_curve":   [10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20],
	"hands_disarm_curve":   [0,   5,   10,  15,  20,  25,  30,  35,  40,  45,  50],
	"ghost_mode_strike_curve": [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0],
	"invincibility_cap": {"hit_threshold": 12},
	# ── Story 3.3 keys ──
	"yield_intel_dc": 12,
	"yield_intel_curve": [4, 3, 3, 2, 2, 1, 1, 1, 0, 0, 0],
	"yield_fail_intel_multiplier": 2,
	"escape_dc_base": 14,
	"escape_dc_situation_modifiers": {},
	"escape_fail_heat_penalty": 15,
	"escape_fail_recruit_exposure_pct": 25,
	## Story 3.7 — AI archetype pool per engagement tier (FR27; gdd §"Combat Engagement Tiers" line 584).
	##
	## tier_ai_pool: maps tier string → Array of archetype id strings.
	##   Archetype ids are string handles. The actual NPC AI implementation (scene loading, behavior
	##   trees) is Epic 3's future scope and Epic 11 (Boss Encounters). For VS, EncounterDirector
	##   logs the selected pool; no NPC instantiation happens from this lookup.
	##
	## VS-locked values below are minimal stubs — designers expand at playtest:
	##   routine:           Gnoy civilians + solo patrol (basic encounters, no tactics).
	##   operative:         Cage squad + faction enforcer (coordinated, higher difficulty).
	##   capture_op:        Cage tactical team + warden (designed to end in yield/escape, not kill).
	##   boss_phase:        Boss placeholder (Epic 11 owns the catalog; string is a forward-ref handle).
	##   endgame_set_piece: Inner Ring guards + commander (ending-specific — strings are forward refs).
	"tier_ai_pool": {
		"routine":            ["gnoym_drunk", "gnoym_mugger", "cage_patrol_solo"],
		"operative":          ["cage_squad_alpha", "cage_squad_bravo", "faction_enforcer"],
		"capture_op":         ["cage_tactical_alpha", "cage_tactical_bravo", "cage_warden"],
		"boss_phase":         ["boss_phase_placeholder"],
		"endgame_set_piece":  ["inner_ring_guard", "inner_ring_commander"],
	},
	## Story 3.8 — Counter-tactics per build classification (FR19, FR190; gdd line 539).
	##
	## counter_tactics: maps classification tag string → Array of tactic id strings.
	##   Tactic ids are forward-reference handles. EncounterDirector logs the dispatched list;
	##   future NPC AI / Feed / Cage subscribers consume the ids (Epic 3 post-VS, Epic 7, Epic 11).
	##
	## VS-locked stubs from gdd "Faction Build Counter-System" table (line 529-538):
	##   ghost     → thermal_sensors, thermal_vision_operatives
	##   broadcast → counter_publication_2x, engagement_architect_throttle
	##   hands     → ranged_only_squads
	##   grifter   → misinfo_flood, identity_verification_protocol (countermove to Fake ID Packet usage)
	##
	## UNKNOWN / MIXED are intentionally absent — CounterTactics returns [] for both.
	"counter_tactics": {
		"ghost":     ["thermal_sensors", "thermal_vision_operatives"],
		"broadcast": ["counter_publication_2x", "engagement_architect_throttle"],
		"hands":     ["ranged_only_squads"],
		"grifter":   ["misinfo_flood", "identity_verification_protocol"],
	},
	# ── Story 3.10 keys ──
	"difficulty_tiers": {
		# Lethal = locked baseline. Both mults MUST be exactly 1.0 (balance lint enforces).
		# "without removing one-hit-death risk on Lethal" (AC text) → Lethal does NOT soften
		# the existing Story 3.2 BODY+threshold model.
		"lethal":    {"enemy_damage_mult": 1.0, "hit_threshold_mult": 1.0},
		# Balanced = ~30% fewer enemy damage, ~30% more shots-to-down. Tunable; designer-set
		# at playtest. Mults preserve directional invariant: enemy_damage ≤ 1.0, hit_threshold ≥ 1.0.
		"balanced":  {"enemy_damage_mult": 0.7, "hit_threshold_mult": 1.3},
		# Forgiving = ~50% fewer enemy damage, ~60% more shots-to-down. Still bounded by
		# invincibility_cap.hit_threshold (FR16 — even Forgiving cannot exceed cap=12).
		"forgiving": {"enemy_damage_mult": 0.5, "hit_threshold_mult": 1.6},
	},
}

## Story 3.4 — captured-state escape vector tuning (FR18; gdd §"Capture Mechanic" line 525).
## Lives in its own Dictionary (NOT inside Balance.combat) because the substate is post-combat;
## designer separation reflects the dual lifecycle.
##   sneak_dc / dialogue_dc / broadcast_dc: d20 + stat_total vs DC; 14 = "Wageworker fails ~85% time."
##   sneak_fail_heat_penalty: heat delta on failed sneak. 10 = two-thirds of escape_fail (15)
##     — captured player has lower district presence.
##   broadcast_fail_cooldown_attempts: number of escape_attempts the broadcast vector is unavailable
##     after a fail. 2 = "after a botched call, the player's network is on edge for two more tries."
##   dead_man_switch_minutes_threshold: WorldClock minutes after capture before DMS is ready.
##     2880 = 48 hours per gdd line 380.
##   dead_man_switch_min_awakening_stage: minimum awakening_level for DMS eligibility. 3 = per
##     gdd "If captured at Stage 3+".
@export var captured_state: Dictionary = {
	"sneak_dc": 14,
	"dialogue_dc": 14,
	"broadcast_dc": 14,
	"sneak_fail_heat_penalty": 10,
	"broadcast_fail_cooldown_attempts": 2,
	"dead_man_switch_minutes_threshold": 2880,
	"dead_man_switch_min_awakening_stage": 3,
}

## Story 3.5 — Per-weapon stats + category-level tunables (FR22–FR25; gdd §"Combat System"
## lines 553–592).
##
## Top-level keys (not a weapon_id):
##   weapon_damage_base: fallback damage when a weapon_id has no explicit entry. Default 10.
##   weapon_range_base: fallback range (abstract units) when no explicit entry. Default 80.
##   bare_hands_bonus: flat damage added on top of CombatParameters.melee_damage when
##     main_hand slot is empty (BARE_HANDS_ID). Default 0 — bare hands = pure Hands-rank.
##   ranged_lethal_heat_spike: Heat delta emitted to the encounter district on EVERY ranged_lethal
##     weapon fire, BEFORE any weapon-specific heat_on_use. Per gdd "Ranged use spikes Heat
##     dramatically" (line 556). 25 = one full tier-step (hud_heat_thresholds tier boundary).
##   max_carried_items: cap on WeaponSlots._carried_ids size. Default 8 — matches the
##     spec contract and the WeaponSlots._MAX_CARRIED_DEFAULT fallback.
##
## Per-weapon entries (weapon_id → Dictionary):
##   damage:     int   base weapon damage added on top of melee_damage (melee) or standalone (non-melee).
##   range:      int   attack reach in abstract units (Epic 9 tiles TBD; VS uses relative comparisons).
##   heat_on_use: int  additional district Heat emitted when THIS weapon fires (on top of ranged_lethal_heat_spike
##               for ranged_lethal weapons). 0 = no additional Heat.
##
## VS-locked values are placeholder tuning; designers adjust at playtest.
##
## Story 3.6 — Signature weapon stats + per-weapon tuning (FR26; gdd §"Signature Weapons" lines 571–582).
##
## Six entries below mirror the Story 3.5 per-weapon schema (damage / range / heat_on_use) and add
## signature-specific keys consumed ONLY by SignatureWeaponEffect.resolve():
##   gnoy_stun_seconds:               Evidence Brick / Slop Bag stun duration when target is gnoym tier.
##   cage_distract_seconds:           Evidence Brick distract duration when target is cage tier.
##                                    Slop Bag deliberately ships 0.0 (Cage operatives ignore food).
##   backup_suppression_seconds:      Signal Jammer "no Cage backup calls" window.
##   blind_seconds:                   Camera Flash blind-cone duration.
##   identity_verification_seconds:   Fake ID Packet NPC-cross-verify window.
##   capture_evidence_id:             Camera Flash → SignatureWeaponEffectEvent.captured_evidence_id
##                                    (Epic 5 Story 5.1 subscribes; for VS this is a tag string
##                                    only — actual inventory write is Epic 5 scope).
##
## megaphone_defection_curve (top-level — not a per-weapon key):
##   yap_game_dc:                     DC fed to RPGCore.skill_check for the Megaphone activation roll.
##   yap_game_critical_base_pct:      base defection chance on a CRITICAL Yap Game outcome.
##   yap_game_success_base_pct:       base defection chance on a SUCCESS outcome.
##   yap_game_fail_base_pct:          base defection chance on a FAIL outcome.
##   clout_rank_bonus_pct:            per-rank Clout bonus added to the base (rank 10 = +20%).
##   max_defection_pct:               hard ceiling (100 = uncapped after clamp). 95 = even at
##                                    rank 10 + critical there's a 5% miss floor — never lock-in.
##   tier_restriction:                "gnoy" — locked. Cage tier returns 0% regardless of roll.
##
## VS-locked values; designers tune in playtest.
@export var weapons: Dictionary = {
	# Category-level and fallback keys
	"weapon_damage_base":         10,
	"weapon_range_base":          80,
	"bare_hands_bonus":            0,
	"ranged_lethal_heat_spike":   25,
	"max_carried_items":           8,
	# Melee
	"pipe_wrench":         {"damage":  12, "range":  80, "heat_on_use": 0},
	"baseball_bat":        {"damage":  15, "range":  90, "heat_on_use": 0},
	"crowbar":             {"damage":  13, "range":  80, "heat_on_use": 0},
	"combat_knife":        {"damage":  18, "range":  50, "heat_on_use": 0},
	"security_baton":      {"damage":  12, "range":  70, "heat_on_use": 0},
	"brass_knuckles":      {"damage":  10, "range":  30, "heat_on_use": 0},
	"chain":               {"damage":  11, "range": 100, "heat_on_use": 0},
	"hammer":              {"damage":  14, "range":  60, "heat_on_use": 0},
	"fire_extinguisher":   {"damage":  16, "range":  80, "heat_on_use": 0},
	"skateboard":          {"damage":  10, "range":  80, "heat_on_use": 0},
	"shovel":              {"damage":  13, "range":  90, "heat_on_use": 0},
	"broken_bottle":       {"damage":  11, "range":  50, "heat_on_use": 0},
	"heavy_book":          {"damage":   9, "range":  60, "heat_on_use": 0},
	# Non-lethal
	"taser":               {"damage":   5, "range":  60, "heat_on_use": 0},
	"tranq_syringe":       {"damage":   3, "range":  30, "heat_on_use": 0},
	"tranq_dart_gun":      {"damage":   3, "range": 200, "heat_on_use": 2},
	"pepper_spray":        {"damage":   2, "range":  50, "heat_on_use": 0},
	"rubber_bullet_pistol":{"damage":   6, "range": 250, "heat_on_use": 5},
	"smoke_grenade":       {"damage":   0, "range": 150, "heat_on_use": 3},
	"flashbang":           {"damage":   0, "range": 150, "heat_on_use": 3},
	"sleep_gas_canister":  {"damage":   0, "range": 120, "heat_on_use": 2},
	"sedative_laced_food": {"damage":   0, "range":  30, "heat_on_use": 0},
	"net_launcher":        {"damage":   0, "range": 200, "heat_on_use": 3},
	# Ranged lethal (each also gets +ranged_lethal_heat_spike district Heat on fire)
	"suppressed_pistol":   {"damage":  25, "range": 350, "heat_on_use":  5},
	"standard_pistol":     {"damage":  28, "range": 300, "heat_on_use":  0},
	"shotgun":             {"damage":  40, "range": 150, "heat_on_use":  0},
	"smg_seized":          {"damage":  22, "range": 250, "heat_on_use":  0},
	"sniper_rifle":        {"damage":  50, "range": 600, "heat_on_use":  0},
	"zip_gun":             {"damage":  20, "range": 200, "heat_on_use":  0},
	# Thrown / trap
	"molotov":             {"damage":  30, "range": 200, "heat_on_use":  8},
	"rock_brick":          {"damage":   8, "range": 180, "heat_on_use":  0},
	"throwing_knife":      {"damage":  15, "range": 150, "heat_on_use":  0},
	"distraction_object":  {"damage":   0, "range": 150, "heat_on_use":  0},
	# Signature (Story 3.6)
	"evidence_brick":    {"damage": 0, "range": 200, "heat_on_use": 0,
	                      "gnoy_stun_seconds": 4.0, "cage_distract_seconds": 2.0},
	"slop_bag":          {"damage": 0, "range": 150, "heat_on_use": 0,
	                      "gnoy_stun_seconds": 6.0, "cage_distract_seconds": 0.0},
	"megaphone":         {"damage": 0, "range": 250, "heat_on_use": 0},
	"signal_jammer":     {"damage": 0, "range": 100, "heat_on_use": 0,
	                      "backup_suppression_seconds": 30.0},
	"camera_flash":      {"damage": 0, "range":  80, "heat_on_use": 0,
	                      "blind_seconds": 4.0, "capture_evidence_id": "receipts_camera_flash"},
	"fake_id_packet":    {"damage": 0, "range": 150, "heat_on_use": 0,
	                      "identity_verification_seconds": 10.0},
	"megaphone_defection_curve": {
		"yap_game_dc":                 12,
		"yap_game_critical_base_pct":  60,
		"yap_game_success_base_pct":   30,
		"yap_game_fail_base_pct":       5,
		"clout_rank_bonus_pct":         2,
		"max_defection_pct":           95,
		"tier_restriction":         "gnoy",
	},
}

## Story 4.2 — Equipment quality-tier tunables (FR29; gdd §"Quality Tiers" lines 602–612).
##
##   xyoner_carrying_heat_per_item: Heat delta emitted to the player's CURRENT district when
##     a Xyoner-seized item is equipped (and re-emitted on every district entry while at least
##     one Xyoner-seized item is equipped). Locked at 5 for VS — one-fifth of a tier-step
##     (hud_heat_thresholds tier boundaries 25/50/75). Three equipped Xyoner items = +15 Heat
##     on district entry ≈ crosses cool→warm threshold immediately. Designer-tunable.
##
##   per_tier_stat_magnitude: ADVISORY metadata only — read by NO engine in 4.2. Captures the
##     "stat profile" descriptors from GDD §"Quality Tiers" so designers can scale per-item
##     attribute_modifiers / skill_modifiers consistently when populating Story 4.4+ inventory.
##     Schema: { tier_id: { "attribute_total_target": int, "skill_total_target": int, "notes": String } }
##     Production code MUST NOT branch on this — it's tuning guidance, not a runtime contract.
@export var equipment: Dictionary = {
	"xyoner_carrying_heat_per_item": 5,
	"per_tier_stat_magnitude": {
		"gnoy_grade":         {"attribute_total_target": 0, "skill_total_target": 0, "notes": "Default starting clothing — placeholder, near-zero stats"},
		"standard":           {"attribute_total_target": 1, "skill_total_target": 1, "notes": "Modest stat bumps — purchased / found common"},
		"underground":        {"attribute_total_target": 2, "skill_total_target": 2, "notes": "Solid stats, resistance-flavor — underground market / specialist craft"},
		"resistance_crafted": {"attribute_total_target": 3, "skill_total_target": 3, "notes": "High stats, set-bonus eligible — Stage 2+ Crafter recruit"},
		"xyoner_seized":      {"attribute_total_target": 4, "skill_total_target": 0, "notes": "Highest stats; raises carrying Heat per xyoner_carrying_heat_per_item; often imposes social/stealth penalties"},
	},
	## Story 4.3 — Per-set bonus magnitudes (FR30; gdd §"Set Bonuses" lines 614–626).
	##
	##   set_bonus_magnitudes: maps Equipment.SET_* string → bonus dict with three sub-keys:
	##     attribute_modifiers: {attr_name: int delta}. Empty for VS — no set grants attribute
	##       bonuses in 4.3. Designer MAY populate post-VS.
	##     skill_modifiers: {skill_id: int delta}. Negative values are LEGAL (Full Tactical −5).
	##     special_flags: {flag_name: number_or_bool}. Floats for "_mult"/"_pct" suffixes;
	##       ints for "_bonus_turns"; bool (0/1 int) for "passes_light_checkpoints".
	##
	##   set_composition_thresholds: tunable thresholds (Underground min count; Hidden Operator
	##     min outer/hidden counts). Only these two sets have tunable thresholds today.
	"set_bonus_magnitudes": {
		"full_civilian": {
			"attribute_modifiers": {},
			"skill_modifiers": {"normie_cosplay": 3, "npc_mode": 2},
			"special_flags": {"heat_decay_mult": 1.20},
		},
		"full_tactical": {
			"attribute_modifiers": {},
			# All social skills −5 (GDD line 621). Eight skills per Skills.gd: MOUTH (rizz,
			# npc_mode, ratio, clout), social SOUL (yap_game, lore_depth, based_talk),
			# passing GHOST (normie_cosplay). Test asserts these exact 8 entries lock the
			# "all social" interpretation per Dev Notes §"What 'all social skills' means".
			"skill_modifiers": {
				"rizz": -5, "npc_mode": -5, "ratio": -5, "clout": -5,
				"yap_game": -5, "lore_depth": -5, "based_talk": -5, "normie_cosplay": -5,
			},
			"special_flags": {"combat_damage_mult": 1.20, "movement_speed_mult": 1.15},
		},
		"hidden_operator": {
			"attribute_modifiers": {},
			"skill_modifiers": {"npc_mode": -1},
			"special_flags": {"combat_damage_mult": 1.10, "weapon_pull_concealment_bonus_turns": 1},
		},
		"press_cover": {
			"attribute_modifiers": {},
			"skill_modifiers": {"receipts": 3, "doxcraft": 2},
			"special_flags": {"passes_light_checkpoints": 1},
		},
		"underground_standard": {
			"attribute_modifiers": {},
			"skill_modifiers": {"web": 1},
			"special_flags": {"underground_discount_pct": 10},
		},
	},
	"set_composition_thresholds": {
		"hidden_operator":      {"min_outer_count": 3, "min_hidden_count": 3},
		"underground_standard": {"min_count": 8},
	},
	## Story 4.4 — Crafting tunables (FR165; gdd §"Materials & Crafting" line 1382-1386).
	##
	##   recipes: tunables consumed by CraftingAction + CrafterPassiveEngine.
	##
	##     irl_build_xp_outcome_on_success: which Skills.OUTCOME_* string drives the XP
	##       award per successful active craft. Default "success" → 1 XP per the existing
	##       skill_xp_per_use defaults. Designer MAY raise to "critical" (2 XP) at playtest
	##       if crafting feels insufficiently rewarding. Must be a valid Skills.OUTCOME_*
	##       string; invalid → CraftingAction warns and falls back to "success".
	##
	##     crafter_passive_rate: int progress points accumulated per day_advanced while
	##       crafter_assigned == true. Default 5 = roughly one passive yield per 6 days
	##       (threshold 30). Tune for playtest pacing.
	##
	##     crafter_passive_threshold: progress required for ONE passive yield. Default 30.
	##
	##     crafter_passive_recipe_id: which recipe the passive engine auto-yields. MUST
	##       refer to a recipe with crafter_passive_eligible == true (cross-check test
	##       enforces). VS-locked default mirrors recipes.tres seed: "resistance_tactical_gloves".
	"recipes": {
		"irl_build_xp_outcome_on_success": "success",
		"crafter_passive_rate": 5,
		"crafter_passive_threshold": 30,
		"crafter_passive_recipe_id": "resistance_tactical_gloves",
	},
}

## Story 3.8 — Dossier-cluster tunables (FR190 OPSEC delay + classifier rolling window;
## gdd "OPSEC delay" line 766). New top-level Dictionary; Story 7.2 (Player Dossier)
## expands with `threat_axes_weights`, `aliases_unlock_thresholds`, etc.
##
##   opsec_delay_days: in-game days between an action being logged and being visible to the
##     classifier. 0 = no delay (every action immediately reads through). Designer tuning
##     hook for FR190 ("counter-tactics lag the build switch by ... × OPSEC modifier").
##     Currently flat — Story 7.2 will multiply by RPGCore.skill OPSEC rank.
##   classifier_window_actions: max size of BuildClassifier._actions. Bounded to keep
##     classify_at_day O(1) wrt time. 200 keeps the window ~2 weeks of moderate play.
##   classifier_min_actions: minimum observed actions before the classifier returns
##     anything other than UNKNOWN. 5 = "give the player one play session to declare a build."
##   classifier_dominance_threshold_pct: minimum percentage of total weight a single tag
##     must hold to be returned (otherwise MIXED). 40 = "no tag wins unless it owns ≥40%
##     of the weighted actions in the window." Designer-tunable; lower = stickier tags.
##   classifier_window_budget_ms: classify_at_day soft-warn threshold (NFR11 first half = <100ms).
##   tactical_response_budget_ms: CounterTactics.resolve_for_encounter soft-warn threshold
##     (NFR11 second half = <500ms).
@export var dossier: Dictionary = {
	"opsec_delay_days": 0,
	"classifier_window_actions": 200,
	"classifier_min_actions": 5,
	"classifier_dominance_threshold_pct": 40,
	"classifier_window_budget_ms": 100,
	"tactical_response_budget_ms": 500,
}

## Story 5.2 — Investigation board tunables (FR4; GDD §"Layer 1 — Physical Board" lines 436–442).
##
##   board_visible_capacity_by_stage: maps homebase_stage int → visible-card capacity int.
##     The board does NOT enforce a hard cap (pinning above this count is allowed and the
##     ScrollContainer simply scrolls). The capacity hint Label uses this for the
##     `n/cap` display so the player has a soft signal that the board is "filling up."
##     VS-locked from GDD line 442: Stage 1 ≈ 30 items; Stage 4 = 200 (distributed-cells flat
##     view; the per-cell subboard switcher is Story 8.6 scope).
##   board_nudge_step_px: pixels-per-keystroke for arrow-key card nudging (UX-DR107
##     keyboard alt). 8 = matches the 32px tile alignment grid divided by 4.
@export var investigation: Dictionary = {
	"board_visible_capacity_by_stage": {1: 30, 2: 60, 3: 100, 4: 200},
	"board_nudge_step_px": 8,
	"connection_skill_by_category": {
		"symbol":    "lore_depth",
		"forensic":  "x_fatigue",
		"testimony": "x_fatigue",
		"digital":   "rabbit_hole",
		"physical":  "rabbit_hole",
		"receipt":   "rabbit_hole",
	},
	"connection_skill_category_precedence": ["symbol", "forensic", "testimony", "digital", "physical", "receipt"],
	"connection_dc_base": 10,
	"connection_credibility_penalty": {
		"verified":  0,
		"probable": -2,
		"uncertain": -5,
	},
	"connection_cage_planted_glowie_sense_modifier": 0,
	## Story 5.7 — Awakening reframes evidence (FR8 surfacing thresholds).
	##
	##   cage_planted_reveal_at_awakening: int — Awakening level at which a connection
	##     whose cage_planted_resolution == true AND outcome == "verified" gets silently
	##     marked as "questioned" (UX-DR96 silent surfacing — no toast). Default 7.
	##   symbol_tooltip_at_awakening: int — Awakening level at which EvidenceCard widgets
	##     for evidence definitions with category == "symbol" gain a translation hover
	##     tooltip. Default 5 (matches gdd.md "Awakening 5 cinematic" line 329).
	##   default_reframing_tag_visible_at_awakening: int — fallback Awakening floor at
	##     which a reframing_tag from RPGCore.evidence_reframing_flags renders the badge
	##     on an evidence card. Default 1 (Awakening 1 = always — preserves Story 5.5
	##     contract that reframing flags surface immediately on thought completion).
	##   per_tag_visible_at_awakening: Dictionary — per-reframing_tag override of the
	##     default threshold. Keys are reframing_tag strings. Values are Awakening levels
	##     [1, 10]. Missing key = use default. Default {}.
	"awakening_reveal": {
		"cage_planted_reveal_at_awakening":           7,
		"symbol_tooltip_at_awakening":                5,
		"default_reframing_tag_visible_at_awakening": 1,
		"per_tag_visible_at_awakening":               {},
	},
}

## Story 5.4 — Publication tunables (FR5, FR6, FR74; gdd "Publication Commit"; arch 5.4).
@export var publication: Dictionary = {
	"platforms": {
		"pirate_broadcast": {
			"reach": 80, "credibility_mult": 1.0, "heat_mult": 1.4,
			"skill_id": "signal_hijack", "dc": 12,
			"faction_affinities": {},
		},
		"underground_forum": {
			"reach": 40, "credibility_mult": 1.3, "heat_mult": 0.7,
			"skill_id": "web", "dc": 10,
			"faction_affinities": {},
		},
		"mainstream_leak": {
			"reach": 150, "credibility_mult": 0.8, "heat_mult": 1.8,
			"skill_id": "doxcraft", "dc": 14,
			"faction_affinities": {},
		},
		"encrypted_source_drop": {
			"reach": 20, "credibility_mult": 1.6, "heat_mult": 0.9,
			"skill_id": "opsec", "dc": 12,
			"faction_affinities": {},
		},
		"satirical_meme_dump": {
			"reach": 60, "credibility_mult": 0.6, "heat_mult": 0.6,
			"skill_id": "edit_farm", "dc": 10,
			"faction_affinities": {},
		},
		"anonymous_tip": {
			"reach": 30, "credibility_mult": 1.0, "heat_mult": 0.5,
			"skill_id": "ghost_protocol", "dc": 10,
			"faction_affinities": {},
		},
	},
	"framings": {
		"expose":                {"credibility_delta":  8, "heat_delta": 12, "faction_polarity": {"xyoner": -3, "resistance": 2}},
		"witness_testimony":     {"credibility_delta":  6, "heat_delta":  6, "faction_polarity": {"xyoner": -2, "resistance": 2}},
		"anonymous_tip":         {"credibility_delta": -2, "heat_delta": -3, "faction_polarity": {}},
		"neutral_document_drop": {"credibility_delta":  4, "heat_delta":  4, "faction_polarity": {}},
		"satirical":             {"credibility_delta": -2, "heat_delta": -4, "faction_polarity": {"xyoner": -1}},
		"personal_testimony":    {"credibility_delta":  5, "heat_delta":  5, "faction_polarity": {"resistance": 2}},
	},
	"audiences": {
		"resistance_sympathizers": {"reach_mult": 0.6, "faction_resonance": {"resistance":  3, "xyoner": -1}},
		"general_public":          {"reach_mult": 1.0, "faction_resonance": {}},
		"xyoner_corporate":        {"reach_mult": 0.4, "faction_resonance": {"xyoner":     -3, "resistance":  1}},
		"mass_market":             {"reach_mult": 1.5, "faction_resonance": {"xyoner":     -1}},
		"specialist_press":        {"reach_mult": 0.5, "faction_resonance": {"resistance":  1}},
		"underground_only":        {"reach_mult": 0.4, "faction_resonance": {"resistance":  4, "xyoner": -2}},
	},
	"skill_check_outcome_multipliers": {
		"critical_success": {"credibility_mult": 1.5, "heat_mult": 0.8, "faction_standing_mult": 1.5},
		"success":          {"credibility_mult": 1.0, "heat_mult": 1.0, "faction_standing_mult": 1.0},
		"fail":             {"credibility_mult": 0.4, "heat_mult": 1.5, "faction_standing_mult": 0.5},
	},
	"seized_evidence_credibility_penalty": -3,
	"seized_evidence_heat_bonus": 2,
}

## Story 3.9 -- Sound-as-Gameplay tunables (FR15, FR177, FR178; gdd line 1491-1501).
## Splits the audio namespace: 3.9 owns gameplay-mechanics audio; Story 13.x will add
## deterioration-crossfade keys (e.g., `xyoner_tier_thresholds`) into the SAME dict.
##
##   footstep_bus: AudioServer bus name for footstep playback. SFX_World per arch §3.3.
##   footstep_placeholder_stream: path to a single placeholder step .wav. Epic A ships
##     real per-surface footstep banks (concrete / metal / carpet / outdoor / blood) post-VS.
##   footstep_visible_radius_px: approximate camera-visible radius. UX-DR101 visual-indicator
##     overlay AND future visibility checks read this. 240 = roughly half of 1080p height.
##   footstep_audible_radius_px: max distance the AudioStreamPlayer2D plays at. MUST be > visible
##     so the player can HEAR before they SEE. 2× visible is the locked default.
##   footstep_attenuation: AudioStreamPlayer2D.attenuation (Godot 4.3 semantic — higher = faster falloff).
##   footstep_volume_db: AudioStreamPlayer2D.volume_db. -6 = noticeable but not dominating.
##   footstep_pip_duration_ms: how long an accessibility overlay pip stays visible.
##   footstep_pip_fade_ms: trailing fade window (subset of duration).
##
##   combat_intensity_per_tier: maps EncounterTier constant string → intensity_level int.
##     Stem-layer count for Story 13.x combat music; observability surface for Story 3.9.
##       routine          → 0  (ambient combat bed only)
##       operative        → 1  (bed + low-energy lead layer)
##       capture_op       → 2  (bed + lead + percussion layer)
##       boss_phase       → 3  (all layers)
##       endgame_set_piece → 3  (all layers — Epic 14 may override per-ending)
@export var audio: Dictionary = {
	"footstep_bus": "SFX_World",
	"footstep_placeholder_stream": "res://audio/sfx/footsteps/placeholder_step.wav",
	"footstep_visible_radius_px": 240.0,
	"footstep_audible_radius_px": 480.0,
	"footstep_attenuation": 2.0,
	"footstep_volume_db": -6.0,
	"footstep_pip_duration_ms": 1500,
	"footstep_pip_fade_ms": 400,
	"combat_intensity_per_tier": {
		"routine":           0,
		"operative":         1,
		"capture_op":        2,
		"boss_phase":        3,
		"endgame_set_piece": 3,
	},
}

## Story 6.1 — Dialogue VM tunables.
##
##   node_resolve_budget_ms: int — Hard cap on a single node resolution time
##     (arch §6.3 / NFR8). DialogueVM perf test asserts max <= this value.
##     Default 50.
##   vm_frame_budget_ms: int — Soft per-frame budget for the VM (arch §6.3).
##     Informational only in 6.1; not asserted per-frame (VM is event-driven).
##     Default 1.
##   voice_cap_per_dialogue: int — Max InternalVoice emissions per dialogue
##     run (UX-DR86). Story 6.3 enforces; 6.1 records but does not enforce.
##     Default 6.
##   voice_first_speak_flourish_ms: int — Duration of the first-speak flourish
##     animation envelope (UX-DR86). Passthrough payload; 6.3 consumes.
##     Default 400.
##   tier_ids: Array[String] — Locked enum of dialogue tier tags (FR66). Story
##     6.10 enforces word-budgets keyed by these strings. 6.1 stores the tag
##     on DialogueGraph.tier; validator accepts empty + ALL_TIER_IDS members.
##   tier_word_budgets: Dictionary — Per-tier word budget (Story 6.10). Empty
##     in 6.1; populated by 6.10.
##   voice_scaling_default: Dictionary — Placeholder linear coefficients for
##     InternalVoice frequency computation. Story 6.3 replaces with real curve.
##     Schema:
##       base_floor: float — minimum frequency floor (clamped from below).
##       awakening_curve: float — added per awakening_level.
##       fatigue_curve: float — added per fatigue derived-stat unit (scaled).
##       cope_curve: float — added per cope_overwork_debit derived-stat unit (scaled).
@export var dialogue: Dictionary = {
	"node_resolve_budget_ms": 50,
	"vm_frame_budget_ms": 1,
	"voice_cap_per_dialogue": 6,
	"voice_first_speak_flourish_ms": 400,
	"tier_ids": ["boss", "recruit_personal", "awakening_beat", "reputation_side", "routine"],
	"tier_word_budgets": {},
	"voice_scaling_default": {
		"base_floor": 0.1,
		"awakening_curve": 0.08,
		"fatigue_curve": 0.05,
		"cope_curve": 0.03,
	},
}

## HUD Heat color-band thresholds (Story 1.12 / FR37). Three ascending values:
## heat < hud_heat_thresholds[0] → cool (blue)
## heat < hud_heat_thresholds[1] → warm (orange)
## heat < hud_heat_thresholds[2] → hot (red)
## heat >= hud_heat_thresholds[2] → critical (flashing red)
@export var hud_heat_thresholds: PackedInt32Array = PackedInt32Array([25, 50, 75])

# Save System (Story 1.8) — runtime policy knobs.
# save_perf_warn_ms: Logger.warn threshold for autosave wall-clock duration (NFR9 = 3000 on min spec).
# save_key_event_debounce_ms: minimum wall-clock gap between key-event commits to prevent thrash
#   when multiple key events fire in the same frame (e.g. district_entered + faction_standing).
# save_backup_count: number of .bak generations retained in default mode. 0 disables backups.
#   Currently honored as 0 or ≥1 (single .bak retained); multi-generation rotation is reserved
#   for future work and is out of scope for vertical slice (Story 1.8 Dev Notes).
@export var save_perf_warn_ms: int = 3000
@export var save_key_event_debounce_ms: int = 500
@export var save_backup_count: int = 1

## Story 5.6 — Shared stamp-animation envelope (UX-DR130 / UX-DR131).
##
##   duration_ms: total envelope for the parallel tween (per-stamp override below). Authoring
##     corridor: SkillCheckBadge ≤ 200 (UX-DR130); commit stamps 300–500 (UX-DR131).
##   scale_start: entrance scale-in start value (1.0 = no scale-up; 0.5 = UX-DR130 spec).
##   scale_end: entrance scale-in end value (always 1.0 — final state must match the static
##     widget for `set_data()`-only call sites).
##   rotation_start_deg: entrance rotation start angle (15° = UX-DR131 prototype value from 2.4).
##   rotation_verified_deg: locked +5 per UX-DR130 / UX-DR88.
##   rotation_probable_deg: locked 0 per UX-DR130 / UX-DR88.
##   rotation_uncertain_deg: locked -5 per UX-DR130 / UX-DR88.
##   fade_in_fraction: alpha-fade-in duration as a fraction of the total envelope (0.3 = 2.4's
##     proven value; the fade is intentionally shorter than the scale + rotation tweens so the
##     stamp "snaps in" rather than easing through transparency).
##   dice_flip_count: how many times the DC label flips through random ints before settling on
##     the actual roll value (UX-DR130 spec: 3–4 flips).
##   dice_flip_step_ms: per-flip duration. 3 flips × 50ms = 150ms — fits inside the 200ms cap.
##   per_stamp: per-stamp-type overrides keyed by stamp_id. Empty dict = use shared values.
@export var stamp_grammar: Dictionary = {
	"duration_ms": 400,
	"scale_start": 0.5,
	"scale_end": 1.0,
	"rotation_start_deg": 15.0,
	"rotation_verified_deg": 5.0,
	"rotation_probable_deg": 0.0,
	"rotation_uncertain_deg": -5.0,
	"fade_in_fraction": 0.3,
	"dice_flip_count": 3,
	"dice_flip_step_ms": 50,
	"per_stamp": {
		"skill_check_badge":   {"duration_ms": 180},
		"publication_stamp":   {"duration_ms": 450},
		"thought_completion":  {"duration_ms": 400},
		"subscription_cancel": {"duration_ms": 400},
	},
	"sfx_placeholder_streams": {
		"skill_check_badge":   "res://audio/sfx/ui/dice_rattle.wav",
		"publication_stamp":   "res://audio/sfx/ui/typewriter_clatter.wav",
		"thought_completion":  "res://audio/sfx/ui/wax_seal_thud.wav",
		"subscription_cancel": "res://audio/sfx/ui/stamp_press.wav",
	},
}

## Story 5.5 — Thought Cabinet tunables (FR7; gdd lines 458–464; arch §4.1).
##
## active_thread_capacity_by_stage: max simultaneously-active thoughts per homebase stage.
##   Per GDD line 462: Stage 1 = 2, Stage 2 = 3, Stage 3+ = 5.
##   Talents / MIND extensions are post-VS polish (deliberately NOT scaffolded here).
##
## definitions: per-thought_id ThoughtDefinition Dictionary.
##   title_key: tr() key for thought title (cabinet UI + completion stamp).
##   body_key: tr() key for thought body text (cabinet UI detail panel).
##   voice_id: "" in VS — Epic 6 Story 6.3 populates with one of the 24 Inner Voice ids.
##   cost_in_slots: int >= 1; how many rumination-tagged Investigation slots to complete.
##   reframing_evidence_definition_ids: Array[String]; on completion, each def_id gets the
##     reframing_tag appended to RPGCore.evidence_reframing_flags[def_id].
##   reframing_tag: short tag string; the value appended to the flags Array per def_id.
##   dialogue_line_unlocks: Array[String]; on completion, each line_id gets
##     RPGCore.dialogue_line_unlocks[line_id] = true. ALWAYS [] in VS — Epic 6 Story 6.3
##     authors real line_ids.
##   unlocked_from_start: bool; true = visible + slot-able from day 1. False = post-VS gate.
##     Story 5.7 may add `unlocked_at_awakening: int` to expand on this.
##   awakening_addenda: Array[Dictionary], optional, default []. Each entry is
##     {at_awakening: int (1..10), body_key: String tr-key}. Rendered in
##     ThoughtSlotWidget body when RPGCore.awakening_level >= entry.at_awakening
##     (Story 5.7 — FR8 surfacing per UX-DR62 + UX-DR96).
@export var thoughts: Dictionary = {
	"active_thread_capacity_by_stage": {
		1: 2,
		2: 3,
		3: 5,
		4: 5,  # Stage 4 Distributed Cell Network — same cap as Stage 3 per GDD
	},
	"definitions": {
		"placeholder_grift_check": {
			"title_key": "ui.cabinet.thought.grift_check.title",
			"body_key":  "ui.cabinet.thought.grift_check.body",
			"voice_id":  "",
			"cost_in_slots": 2,
			"reframing_evidence_definition_ids": ["forum_thread_screenshot"],
			"reframing_tag": "reframed_as_grift",
			"dialogue_line_unlocks": [],
			"unlocked_from_start": true,
		},
		"placeholder_xyoner_pattern": {
			"title_key": "ui.cabinet.thought.xyoner_pattern.title",
			"body_key":  "ui.cabinet.thought.xyoner_pattern.body",
			"voice_id":  "",
			"cost_in_slots": 3,
			"reframing_evidence_definition_ids": ["xyoner_symbol_pamphlet"],
			"reframing_tag": "reframed_as_pattern_visible",
			"dialogue_line_unlocks": [],
			"unlocked_from_start": true,
		},
		"placeholder_self_doubt": {
			"title_key": "ui.cabinet.thought.self_doubt.title",
			"body_key":  "ui.cabinet.thought.self_doubt.body",
			"voice_id":  "",
			"cost_in_slots": 2,
			"reframing_evidence_definition_ids": ["passport_scan"],
			"reframing_tag": "reframed_as_self_doubt",
			"dialogue_line_unlocks": [],
			"unlocked_from_start": true,
		},
	},
}
