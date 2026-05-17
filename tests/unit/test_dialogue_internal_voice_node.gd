extends GutTest

## Story 6.1 — Unit tests for DialogueInternalVoiceNode Resource schema.


func test_internal_voice_node_default_node_type() -> void:
	var node := DialogueInternalVoiceNode.new()
	assert_eq(node.node_type, "internal_voice")


func test_internal_voice_node_default_frequency() -> void:
	var node := DialogueInternalVoiceNode.new()
	assert_eq(node.base_frequency, 1.0, "base_frequency must default to 1.0 (always emit)")


func test_internal_voice_node_chorus_tier_default() -> void:
	var node := DialogueInternalVoiceNode.new()
	assert_eq(node.chorus_tier, "quiet")


func test_internal_voice_node_set_fields() -> void:
	var node := DialogueInternalVoiceNode.new()
	node.voice_profile_id = "doxcraft"
	node.body_key = "dialogue.test.doxcraft"
	node.chorus_tier = "interjecting"
	node.base_frequency = 0.5
	assert_eq(node.voice_profile_id, "doxcraft")
	assert_eq(node.chorus_tier, "interjecting")
	assert_eq(node.base_frequency, 0.5)
