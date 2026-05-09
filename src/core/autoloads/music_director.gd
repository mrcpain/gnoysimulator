extends Node

## Music context switcher + tier crossfade scheduler.
## Tier crossfade logic lands in Story 13.x.
## FORBIDDEN: runtime DSP on a tier-1 stream to fake higher tiers (arch locked rule 7).
##   Comment preserved here as a permanent reminder.
## EventBus connection is deferred: EventBus (#12) is registered after MusicDirector (#9).

func _ready() -> void:
	call_deferred("_connect_signals")
	Logger.info("music", "MusicDirector ready.")


func _connect_signals() -> void:
	EventBus.awakening_level_changed.connect(_on_awakening_level_changed)


func set_context(context_id: String) -> void:
	## Stub — logs only at this story. Story 13.x wires the real crossfade.
	Logger.debug("music", "set_context('%s') — stub at Story 1.0." % context_id)


func _on_awakening_level_changed(_old: int, _new_level: int) -> void:
	## No-op at this story. Story 13.x implements tier transitions.
	pass
