class_name Skills extends RefCounted

## Source: epics.md §"Story 1.2" + FR82 + FR87 + game-architecture.md §4.1 line 379.
## Pure-utility static module — never instantiated.
##
## Design constants (locked by FR82 + FR87) live here, NOT in Balance:
##   - Skill ids (24 snake_case strings), archetype groupings, MIN_RANK, MAX_RANK,
##     TALENT_POINT_RANKS, outcome string keys.
##
## Balance tunables (XP per outcome, XP thresholds) live in balance.tres —
## because PM/testers must adjust them without code changes (arch §7.2).
##
## TALENT_POINT_RANKS: FR87 "every other Skill milestone" → reading #2 (per-skill even ranks).
## Justification in Dev Notes §"Talent-Point Cadence design call". Flagged for PM confirmation.

# ── Archetype id sets (FR82) ──────────────────────────────────────────────────

const MIND_IDS: Array[String]   = ["rabbit_hole", "x_fatigue",       "doxcraft",      "edit_farm"]
const SOUL_IDS: Array[String]   = ["glowie_sense", "yap_game",       "lore_depth",    "based_talk"]
const MOUTH_IDS: Array[String]  = ["rizz",         "npc_mode",       "ratio",         "clout"]
const GHOST_IDS: Array[String]  = ["ghost_mode",   "normie_cosplay", "receipts",      "opsec"]
const BODY_IDS: Array[String]   = ["gymmaxx",      "hands",          "anti_slop",     "irl_build"]
const SIGNAL_IDS: Array[String] = ["web",          "ghost_protocol", "sneaky_links",  "signal_hijack"]

# Flat literal — GDScript cannot compute Array + Array in a const expression (runtime op).
const ALL_IDS: Array[String] = [
	"rabbit_hole", "x_fatigue",       "doxcraft",       "edit_farm",
	"glowie_sense", "yap_game",       "lore_depth",     "based_talk",
	"rizz",         "npc_mode",       "ratio",          "clout",
	"ghost_mode",   "normie_cosplay", "receipts",       "opsec",
	"gymmaxx",      "hands",          "anti_slop",      "irl_build",
	"web",          "ghost_protocol", "sneaky_links",   "signal_hijack",
]

# ── Rank bounds (design constants — NOT balance tunables) ─────────────────────

const MIN_RANK: int = 0
const MAX_RANK: int = 10

# ── Talent-point cadence (FR87 "every other Skill milestone" → even ranks) ────

const TALENT_POINT_RANKS: Array[int] = [2, 4, 6, 8, 10]

# ── Outcome string keys — consumers MUST use these, not raw strings ───────────
# Prevents silent typo-errors in award_skill_xp calls. Story 1.3 is the only
# legitimate production caller; tests call award_skill_xp directly.

const OUTCOME_CRITICAL: String = "critical"
const OUTCOME_SUCCESS: String  = "success"
const OUTCOME_FAIL: String     = "fail"


# ── Static helpers ────────────────────────────────────────────────────────────

static func is_valid_id(skill_id: String) -> bool:
	return skill_id in ALL_IDS


static func is_valid_outcome(outcome: String) -> bool:
	return outcome in [OUTCOME_CRITICAL, OUTCOME_SUCCESS, OUTCOME_FAIL]


static func is_talent_point_rank(rank: int) -> bool:
	return rank in TALENT_POINT_RANKS


static func default_skill_ranks() -> Dictionary:
	## Returns a fresh {skill_id: 0} dict for all 24 skills.
	## Never returns a constant reference — always a new dict (Story 1.1 lesson).
	var d: Dictionary = {}
	for id: String in ALL_IDS:
		d[id] = 0
	return d


static func default_skill_xp() -> Dictionary:
	## Returns a fresh {skill_id: 0} dict for all 24 skills.
	var d: Dictionary = {}
	for id: String in ALL_IDS:
		d[id] = 0
	return d
