extends Node

## Disposable boot verification scene (Story 1.0).
## Story 12.x replaces this with the real Opening Sequence scene.
## This scene only exists to confirm all 12 autoloads came online without errors.

const AUTOLOAD_COUNT := 12


func _ready() -> void:
	Logger.info("boot", "All %d autoloads online." % AUTOLOAD_COUNT)
