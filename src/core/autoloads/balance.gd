extends Node

## Loads balance.tres once on _ready() and exposes it read-only.
## Fails loud (push_error + crash assert) if the file is missing or malformed.
## get_tree().quit() is deferred in Godot 4 — push_error + assert(false) ensures
## an immediate crash with a clear message before later autoloads try to use null data.
## Forbidden: magic numbers anywhere outside balance.tres (arch §7.2).

const BALANCE_PATH := "res://src/core/balance/balance.tres"

var _data: BalanceResource = null


func _ready() -> void:
	_data = ResourceLoader.load(BALANCE_PATH) as BalanceResource
	if _data == null:
		var msg := "FATAL — balance.tres missing or malformed at '%s'. Cannot continue." % BALANCE_PATH
		Logger.error("balance", msg)
		push_error(msg)
		# assert(false) makes the crash immediate and visible in the debugger,
		# rather than waiting for the deferred quit to fire (which lets other autoloads
		# proceed and crash on null get_data() first).
		assert(false, msg)
		get_tree().quit(1)
		return
	Logger.info("balance", "BalanceResource loaded OK.")


func get_data() -> BalanceResource:
	return _data
