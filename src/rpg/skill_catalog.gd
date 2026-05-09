class_name SkillCatalog extends Resource

## Single source of truth for all 24 SkillDefinition instances.
## Runtime code reads Skills.gd constants for ids; data lives here.
## Forbidden: individual per-skill .tres files — one catalog, 24 inline sub-resources.

@export var skills: Array[SkillDefinition] = []
