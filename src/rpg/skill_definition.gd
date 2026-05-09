class_name SkillDefinition extends Resource

## Source: epics.md §"Story 1.2" + FR82 + game-architecture.md §4.1.
## Schema for a single skill entry in the SkillCatalog.
## Forbidden: raw English display_name / description strings — use tr() keys only.
## Forbidden: one class_name per skill subclass — one SkillDefinition schema, 24 resource instances.

@export var id: String = ""
@export var display_name_key: String = ""
@export var archetype: String = ""
@export var parent_attribute: String = ""
@export var description_key: String = ""
@export var voice_profile_id: String = ""
