extends GutTest

## Story 6.1 — Unit tests for DialogueSystemEffectNode Resource schema.


func test_system_effect_node_default_node_type() -> void:
	var node := DialogueSystemEffectNode.new()
	assert_eq(node.node_type, "system_effect")


func test_system_effect_node_effect_constants_present() -> void:
	assert_eq(DialogueSystemEffectNode.EFFECT_SET_FLAG, "set_flag")
	assert_eq(DialogueSystemEffectNode.EFFECT_CLEAR_FLAG, "clear_flag")
	assert_eq(DialogueSystemEffectNode.EFFECT_FATIGUE_DELTA, "fatigue_delta")
	assert_eq(DialogueSystemEffectNode.EFFECT_COPE_OVERWORK_DELTA, "cope_overwork_delta")
	assert_eq(DialogueSystemEffectNode.EFFECT_HEAT_INPUT, "heat_input")
	assert_eq(DialogueSystemEffectNode.EFFECT_AWAKENING_INPUT, "awakening_input")
	assert_eq(DialogueSystemEffectNode.EFFECT_DISPOSITION_INPUT, "disposition_input")
	assert_eq(DialogueSystemEffectNode.EFFECT_COMPOSURE_DAMAGE, "composure_damage")
	assert_eq(DialogueSystemEffectNode.EFFECT_UNLOCK_LINE, "unlock_line")
	assert_eq(DialogueSystemEffectNode.EFFECT_QUEUE_SIGNAL, "queue_signal")


func test_system_effect_node_all_effects_count() -> void:
	assert_eq(DialogueSystemEffectNode.ALL_EFFECTS.size(), 10, "ALL_EFFECTS must have 10 entries")


func test_system_effect_node_queue_signal_whitelist_count() -> void:
	assert_gte(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.size(), 1)
	assert_true(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("dialogue_line_unlocked"))
	assert_true(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("evidence_reframed"))
	assert_true(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("awakening_cinematic_due"))
	assert_true(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("feed_segment_queued"))


func test_system_effect_node_subscription_cancelled_not_in_whitelist() -> void:
	assert_false(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("subscription_cancelled"),
		"subscription_cancelled MUST NOT be re-emittable from dialogue — AC7 lock")


func test_system_effect_node_player_died_not_in_whitelist() -> void:
	assert_false(DialogueSystemEffectNode.QUEUE_SIGNAL_WHITELIST.has("player_died"),
		"player_died MUST NOT be in whitelist — defense-in-depth")
