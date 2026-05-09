# Engine & Tool Versions

## Godot Engine

- **Version:** Godot 4.3 (stable)
- **Download:** https://godotengine.org/download/archive/
- **Renderer:** Mobile (used in editor and export — must match export target per arch §3.1)
- **Rationale:** Pinned at story 1.0. Update only with explicit team approval + full regression run.

## GUT (Godot Unit Test)

- **Version:** GUT 9.3.1 (pinned — GUT 9.4+ requires Godot 4.4+; GUT 9.6+ requires Godot 4.6 APIs)
- **Source:** https://github.com/bitwes/Gut/releases/tag/9.3.1
- **Install location:** `addons/gut/`
- **Plugin enable:** `project.godot` → `[editor_plugins]` section (already set)
- **Test root:** `tests/` (subdirectories: `unit/`, `integration/`, `save/`, `determinism/`)
- **Run via editor:** GUT panel → "Run All"
- **Run headless:** `godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit`

## Installation Steps (one-time)

1. Open the project in Godot 4.3.
2. Go to AssetLib tab → search "GUT" → Install (or download from GitHub and copy `addons/gut/` manually).
3. Project Settings → Plugins → Enable GUT.
4. Verify GUT panel appears in the bottom dock.
5. Click "Run All" — the SaveGameV1 round-trip test (Story 1.0) should pass green.
