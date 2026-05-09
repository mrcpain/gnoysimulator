class_name Attributes extends RefCounted

## Source: epics.md §"Story 1.1" + FR76 + FR77 + game-architecture.md §4.1.
## Clamp range is [0, 10] for all seven attributes. MIN=0 because SIGNAL starts at 0
## per FR77 and GDD design intent ("zero SIGNAL" = unawakened). FR76's "1–10" describes
## the active gameplay range; 0 is the legal uninitialised/unawakened floor. One uniform
## range avoids a SIGNAL-specific special case bleeding into every consumer.
## WAGEWORKER_DEFAULT values are locked design constants per FR77, not balance tunables.
## Future archetype starting distributions (when added) will go in Balance.tres.

const NAMES: Array[String] = ["BODY", "MIND", "SOUL", "MOUTH", "GHOST", "GUT", "SIGNAL"]
const MIN: int = 0
const MAX: int = 10
const WAGEWORKER_DEFAULT: Dictionary = {
	"BODY": 4, "MIND": 2, "SOUL": 2, "MOUTH": 3, "GHOST": 1, "GUT": 5, "SIGNAL": 0
}


static func is_valid_name(name: String) -> bool:
	return name in NAMES


static func clamp_value(value: int) -> int:
	return clampi(value, MIN, MAX)


static func default_wageworker() -> Dictionary:
	return WAGEWORKER_DEFAULT.duplicate(true)
