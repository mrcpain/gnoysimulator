extends Node

## Token registry + Awakening-aware token swap (arch §4.4, locked rule 10).
## Forbidden: hardcoded styles in any UI component. Use get_token().
## Full awakening variant swaps land in Epic 13.
## EventBus connection is deferred: EventBus (#12) is registered after ThemeManager (#8),
## so we cannot connect in _ready() — call_deferred ensures EventBus is fully in the tree.

signal theme_tokens_changed()

var _tokens: Dictionary = ThemeTokens.DEFAULTS.duplicate()


func _ready() -> void:
	call_deferred("_connect_signals")
	Logger.info("theme", "ThemeManager ready. Token count: %d" % _tokens.size())


func _connect_signals() -> void:
	EventBus.awakening_level_changed.connect(_on_awakening_level_changed)


func get_token(key: String) -> Variant:
	if not _tokens.has(key):
		Logger.warn("theme", "Token '%s' not found — returning null." % key)
		return null
	return _tokens[key]


func set_awakening(level: int) -> void:
	## No-op stub — Epic 13 implements awakening variant swap.
	Logger.debug("theme", "set_awakening(%d) — stub, no-op at this story." % level)


func _on_awakening_level_changed(_old: int, new_level: int) -> void:
	set_awakening(new_level)
	theme_tokens_changed.emit()
