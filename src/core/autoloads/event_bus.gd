extends Node

## Project-wide signal hub — the ONLY cross-cluster communication path (arch §4.6).
## Forbidden: direct sibling-reference between clusters. Use these signals.
## All payloads are typed Resources. Forbidden: bare Dictionary payloads.
## Connections happen lazily when subscribers come online; EventBus just declares signals.

# Subscription / economy (Epic 2)
signal subscription_cancelled(payload: SubscriptionEvent)

# Investigation (Epic 5)
signal evidence_published(payload: PublicationEvent)

# Awakening Track — RPGCore re-emits here so ALL subscribers use one path (locked rule 4)
signal awakening_level_changed(old_level: int, new_level: int)

# Skill progression (RPGCore emits after each rank-up; Story 1.3 is the only XP caller)
# Forbidden: re-using awakening_level_changed — separate concepts, separate signals (locked rule 4).
# Forbidden: a per-XP-tick signal — XP is internal accounting until rank-up.
signal skill_levelled(skill_id: String, new_rank: int)

# Time (WorldClock re-emits here so non-clock clusters stay decoupled)
signal day_advanced(new_day: int)
signal week_advanced(new_week: int)

# Faction standing (Epic 7)
signal faction_standing_changed(faction_id: String, old_standing: String, new_standing: String)

# Interrogation Bridge output (Epic 7)
signal gnoym_interrogated(payload: InterrogationReport)

# Investigation board (Epic 5)
signal connection_drawn(payload: Variant)

# Politburo outputs (Epic 7)
signal politburo_event(payload: Variant)

# Theme system (ThemeManager re-emits after token swap)
signal theme_tokens_changed()

# Opening sequence (Epic 12)
signal schrodinger_resolved(npc_id: String, role: String)


func _ready() -> void:
	Logger.info("eventbus", "EventBus ready. All cross-cluster signals declared.")
