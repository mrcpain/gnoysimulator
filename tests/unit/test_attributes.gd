extends GutTest

## Unit tests for Attributes module (Story 1.1, AC1–AC3).
## Pure-function coverage: NAMES, MIN/MAX constants, clamp_value, is_valid_name, default_wageworker.


func test_wageworker_default_has_seven_keys() -> void:
	var d := Attributes.default_wageworker()
	assert_eq(d.size(), 7, "Wageworker default must have exactly 7 keys")
	for key in Attributes.NAMES:
		assert_true(d.has(key), "Key '%s' must be present in default" % key)


func test_wageworker_default_values() -> void:
	var d := Attributes.default_wageworker()
	assert_eq(d["BODY"],   4, "BODY default must be 4")
	assert_eq(d["MIND"],   2, "MIND default must be 2")
	assert_eq(d["SOUL"],   2, "SOUL default must be 2")
	assert_eq(d["MOUTH"],  3, "MOUTH default must be 3")
	assert_eq(d["GHOST"],  1, "GHOST default must be 1")
	assert_eq(d["GUT"],    5, "GUT default must be 5")
	assert_eq(d["SIGNAL"], 0, "SIGNAL default must be 0")


func test_clamp_low() -> void:
	assert_eq(Attributes.clamp_value(-5), 0, "clamp_value(-5) must be 0")


func test_clamp_high() -> void:
	assert_eq(Attributes.clamp_value(99), 10, "clamp_value(99) must be 10")


func test_clamp_in_range() -> void:
	assert_eq(Attributes.clamp_value(7), 7, "clamp_value(7) must be 7")


func test_is_valid_name_yes() -> void:
	for name in Attributes.NAMES:
		assert_true(Attributes.is_valid_name(name), "'%s' must be a valid attribute name" % name)


func test_is_valid_name_no() -> void:
	assert_false(Attributes.is_valid_name("body"),  "'body' (lowercase) must be invalid")
	assert_false(Attributes.is_valid_name(""),       "empty string must be invalid")
	assert_false(Attributes.is_valid_name("BRAIN"),  "'BRAIN' must be invalid")
	assert_false(Attributes.is_valid_name("FOO"),    "'FOO' must be invalid")


func test_default_wageworker_returns_independent_copy() -> void:
	var d1 := Attributes.default_wageworker()
	var d2 := Attributes.default_wageworker()
	d1["BODY"] = 999
	assert_eq(d2["BODY"], 4, "Mutating first copy must not affect second copy")
