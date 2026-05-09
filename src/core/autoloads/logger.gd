extends Node

## Structured logging with subsystem tags, ring buffer, and disk output.
## Arch §6.2: levels TRACE/DEBUG/INFO/WARN/ERROR; default ship level INFO.
## CLI flag --debug-logging bumps level to DEBUG.
## Forbidden: silent error swallowing. Always log; surface to user only when user-actionable.

enum Level { TRACE = 0, DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4 }

const RING_BUFFER_MAX := 10_000
const LOG_DIR := "user://logs"

var _level: Level = Level.INFO
var _ring: Array[String] = []
var _log_file: FileAccess = null


func _ready() -> void:
	# OS.has_feature() checks build tags, NOT CLI flags — use get_cmdline_args() for CLI
	if "--debug-logging" in OS.get_cmdline_args():
		_level = Level.DEBUG
	_open_log_file()


func trace(subsystem: String, msg: String) -> void:
	_write(Level.TRACE, subsystem, msg)


func debug(subsystem: String, msg: String) -> void:
	_write(Level.DEBUG, subsystem, msg)


func info(subsystem: String, msg: String) -> void:
	_write(Level.INFO, subsystem, msg)


func warn(subsystem: String, msg: String) -> void:
	_write(Level.WARN, subsystem, msg)


func error(subsystem: String, msg: String) -> void:
	_write(Level.ERROR, subsystem, msg)


func get_ring_buffer() -> Array[String]:
	return _ring.duplicate()


func _write(level: Level, subsystem: String, msg: String) -> void:
	if level < _level:
		return
	var label: String = Level.keys()[level]
	var timestamp := Time.get_datetime_string_from_system(true)
	var line := "[%s][%s][%s] %s" % [timestamp, label, subsystem, msg]
	_ring.append(line)
	if _ring.size() >= RING_BUFFER_MAX:
		_ring.pop_front()
	print(line)
	if _log_file:
		_log_file.store_line(line)


func _open_log_file() -> void:
	DirAccess.make_dir_recursive_absolute(LOG_DIR)
	# get_datetime_string_from_system returns "YYYY-MM-DDTHH:MM:SS" — sanitise for filesystem
	var datetime := Time.get_datetime_string_from_system(true).replace(":", "-").replace("T", "_")
	var path := "%s/session_%s.log" % [LOG_DIR, datetime]
	_log_file = FileAccess.open(path, FileAccess.WRITE)
	if not _log_file:
		push_warning("Logger: could not open log file at %s (error %d)" % [path, FileAccess.get_open_error()])


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and _log_file:
		_log_file.close()
