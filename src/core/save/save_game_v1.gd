class_name SaveGameV1 extends Resource

## Schema version 1 — the baseline save format.
## FIRST field is always schema_version (arch §3.7, rule 8).
## Stub @export fields are placeholders; later stories populate values.
## Forbidden: schema bump without migrate_from() implementation = release blocker.

@export var schema_version: int = 1

# RPG cluster (Stories 1.1–1.7)
@export var attributes: Dictionary = {}
@export var skills: Dictionary = {}
@export var talents: Array = []
@export var awakening_level: int = 1
@export var disposition: Dictionary = {}
@export var derived_stats: Dictionary = {}

# Day cycle (Story 2.1)
@export var world_clock_minutes: int = 0

# Tracking systems — these live in WorldState, owned by SaveSystem (arch §4.5)
# NOT autoloads. Their lifecycle is the save's lifecycle.
@export var world_state: Dictionary = {}

# Dialogue (Epic 6)
@export var conversation_log: Array = []

# Districts (Epic 9)
@export var district_heat: Dictionary = {}

# Recruitment (Epic 8)
@export var recruit_roster: Array = []


static func migrate_from(prev: Resource) -> SaveGameV1:
	## V1 baseline — just cast. Future versions chain V(N-1)->V(N) here.
	return prev as SaveGameV1
