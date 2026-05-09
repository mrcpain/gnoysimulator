class_name BalanceResource extends Resource

## All game magic numbers live here. Forbidden: hardcoded values outside this file (arch §7.2).
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

# Day cycle (Story 2.x)
@export var slot_minutes: Dictionary = {}

# Politburo (Epic 7)
@export var politburo_tick_budget_ms: int = 500

# Audio (Epic 13)
@export var crossfade_duration_seconds: float = 4.0

# Economy (Epic 2)
@export var subscription_costs: Dictionary = {}
