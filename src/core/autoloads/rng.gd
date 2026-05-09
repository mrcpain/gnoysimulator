extends Node

## Seeded per-subsystem RNG streams.
## Forbidden: randomize() or bare RandomNumberGenerator.new() anywhere in game code.
## All gameplay code must call RNG.stream("subsystem_name") (arch §7.2).

const SUBSYSTEMS := ["rpg", "politburo", "dialogue", "combat"]

var _streams: Dictionary = {}


func _ready() -> void:
	for name in SUBSYSTEMS:
		var rng := RandomNumberGenerator.new()
		_streams[name] = rng
	Logger.info("rng", "RNG streams initialised for subsystems: %s" % str(SUBSYSTEMS))


func seed_all(master_seed: int) -> void:
	## (Re)seed every subsystem stream from a master seed using deterministic derivation.
	for name in _streams:
		var derived := hash("%s:%d" % [name, master_seed])
		(_streams[name] as RandomNumberGenerator).seed = derived
	Logger.debug("rng", "All streams re-seeded from master seed %d." % master_seed)


func stream(name: String) -> RandomNumberGenerator:
	if not _streams.has(name):
		Logger.error("rng", "Unknown RNG subsystem '%s'. Registered: %s" % [name, str(SUBSYSTEMS)])
		return null
	return _streams[name]
