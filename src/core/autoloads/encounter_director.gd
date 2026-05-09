extends Node

## Combat encounter snapshot/restore contract (arch §3.5).
## Snapshot captures the full encounter state before it plays out.
## Restore winds it back (used for "restart encounter" UX, not save-scumming).
## commit_resolution() finalises the outcome — no recovery possible after.
## Full implementation lands in Epic 3.

var _snapshot: Dictionary = {}


func _ready() -> void:
	Logger.info("encounter", "EncounterDirector ready — stub at Story 1.0.")


func take_snapshot() -> void:
	## Stub — Epic 3 captures full encounter state here.
	Logger.debug("encounter", "take_snapshot() — stub at Story 1.0.")


func restore_snapshot() -> void:
	## Stub — Epic 3 restores encounter state here.
	Logger.debug("encounter", "restore_snapshot() — stub at Story 1.0.")


func commit_resolution(outcome: String) -> void:
	## Stub — Epic 3 finalises and records the encounter outcome.
	Logger.debug("encounter", "commit_resolution('%s') — stub at Story 1.0." % outcome)
