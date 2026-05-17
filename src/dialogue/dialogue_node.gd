class_name DialogueNode extends Resource

## Story 6.1 — Abstract base for the 9 dialogue node types.
## Sealed list of node types: subclasses set `node_type` in _init / via override.
## DialogueVM dispatches on node_type via a switch (no virtual dispatch — concrete).

const TYPE_LINE: String           = "line"
const TYPE_CHOICE: String         = "choice"
const TYPE_SKILL_CHECK: String    = "skill_check"
const TYPE_INTERNAL_VOICE: String = "internal_voice"
const TYPE_ITEM_DROP: String      = "item_drop"
const TYPE_BRANCH: String         = "branch"
const TYPE_SYSTEM_EFFECT: String  = "system_effect"
const TYPE_COMMIT: String         = "commit"
const TYPE_END: String            = "end"

const ALL_NODE_TYPES: Array[String] = [
	TYPE_LINE, TYPE_CHOICE, TYPE_SKILL_CHECK, TYPE_INTERNAL_VOICE,
	TYPE_ITEM_DROP, TYPE_BRANCH, TYPE_SYSTEM_EFFECT, TYPE_COMMIT, TYPE_END,
]

@export var node_id: String = ""
# Unique within a DialogueGraph. DialogueGraph.validate() rejects duplicates / blanks.

@export var node_type: String = ""
# Must be one of ALL_NODE_TYPES. Subclasses set this in _init.

@export var next_id: String = ""
# Default routing target. For Choice / SkillCheck / Branch / ItemDrop, the
# concrete subclass overrides next routing — `next_id` is the fallback when
# no choice-specific routing applies (e.g., Choice with no edges).
