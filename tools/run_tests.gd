#!/usr/bin/env -S godot --headless -s
## Headless GUT test runner for CI.
## Usage: godot --headless -s tools/run_tests.gd
## Exit code 0 = all pass, 1 = failures present.
## Requires GUT addon installed and enabled (see docs/engine-version.md).
##
## Note: If you prefer GUT's built-in CLI runner (recommended for GUT 9.x), use:
##   godot --headless -s res://addons/gut/gut_cmdln.gd -gdir=res://tests -gexit

extends SceneTree


func _init() -> void:
	var gut_path := "res://addons/gut/gut.gd"
	if not ResourceLoader.exists(gut_path):
		push_error("GUT not found at '%s'. Install GUT addon first (see docs/engine-version.md)." % gut_path)
		quit(1)
		return

	var gut_class := load(gut_path)
	if gut_class == null:
		push_error("Failed to load GUT class from '%s'." % gut_path)
		quit(1)
		return

	var gut = gut_class.new()
	root.add_child(gut)

	gut.add_directory("res://tests/")

	# Use public API — avoid private _test_prefix field
	if gut.has_method("set_prefix"):
		gut.set_prefix("test_")

	gut.test_scripts()

	# GUT emits end_run when all tests are done (GUT 9.x for Godot 4.x)
	await gut.end_run

	var failed: int = 0
	if gut.has_method("get_fail_count"):
		failed = gut.get_fail_count()
	elif gut.has_method("get_summary"):
		failed = gut.get_summary().get_totals().failed

	if failed > 0:
		print("GUT: %d test(s) FAILED." % failed)
		quit(1)
	else:
		print("GUT: All tests passed.")
		quit(0)
