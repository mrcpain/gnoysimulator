extends Node

## In-game time keeper. Slot/day/week derivation lands in Story 2.1.
## Signals defined here so subscribers compile against them from the start (arch §4.5).

signal day_advanced(new_day: int)
signal week_advanced(new_week: int)

var minutes_since_start: int = 0


func _ready() -> void:
	Logger.info("clock", "WorldClock ready. minutes_since_start=%d" % minutes_since_start)
