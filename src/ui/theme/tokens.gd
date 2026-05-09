class_name ThemeTokens extends RefCounted

## Token registry — the only style source for all UI components (arch §4.4, locked rule 10).
## Forbidden: hardcoded styles in any UI component.
## Awakening variant table filled in Epic 13.

# Baseline token values — placeholders, replaced at art-pass / Epic 13
const DEFAULTS: Dictionary = {
	"color.surface": Color(0.08, 0.08, 0.12, 1.0),
	"color.primary": Color(0.88, 0.75, 0.50, 1.0),
	"color.text": Color(0.90, 0.90, 0.85, 1.0),
	"type.body": "res://art/ui/fonts/body.ttf",
	"spacing.s": 4,
	"spacing.m": 8,
	"motion.duration_fast": 0.12,
}
