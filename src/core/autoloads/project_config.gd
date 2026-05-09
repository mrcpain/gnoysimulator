extends Node

## Build flags and runtime feature toggles.
## Build flags come from OS.has_feature() + CLI args.
## Runtime toggles are persisted to user://settings.cfg via Godot ConfigFile.

const SETTINGS_PATH := "user://settings.cfg"

var is_dev: bool = false
var is_release: bool = false
var enable_debug_overlay: bool = false

var _config := ConfigFile.new()


func _ready() -> void:
	is_dev = OS.has_feature("editor") or "--dev" in OS.get_cmdline_args()
	is_release = OS.has_feature("release") and not is_dev
	enable_debug_overlay = "--debug-overlay" in OS.get_cmdline_args()
	_load_settings()
	Logger.info("config", "ProjectConfig ready — dev=%s release=%s debug_overlay=%s" % [is_dev, is_release, enable_debug_overlay])


func get_toggle(key: String, default: Variant = false) -> Variant:
	return _config.get_value("toggles", key, default)


func set_toggle(key: String, value: Variant) -> void:
	_config.set_value("toggles", key, value)
	_config.save(SETTINGS_PATH)


func _load_settings() -> void:
	var err := _config.load(SETTINGS_PATH)
	if err != OK and err != ERR_FILE_NOT_FOUND:
		Logger.warn("config", "Could not load settings.cfg (err %d); using defaults." % err)
