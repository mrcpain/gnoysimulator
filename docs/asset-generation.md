# Asset Generation Strategy

This project uses OpenAI's image generation APIs to create all game assets. Assets must be generated systematically — consistent style across everything is critical.

## Models

**gpt-image-1** — used for anything that needs a transparent background (PNG with alpha channel):
- Character sprites (player, NPCs, enemies/creatures)
- UI elements (buttons, icons, HUD components, item icons)
- Items and objects placed in the world
- Any sprite that gets composited over a background

**gpt-image-2** — used for high-resolution assets where transparency isn't needed:
- Environment backgrounds
- Tilesets and terrain
- Battle/scene backgrounds
- Cutscene or loading screen art

## Style Consistency

Every generation call must include a shared style bible prompt prefix. Once the visual style is locked in during early production, the first batch of approved assets become reference images fed into gpt-image-2 calls (supports up to 16 reference images) to keep everything cohesive.

## Pipeline

1. Style bible defined before any assets are generated
2. Generate canonical "hero" assets first (main character, primary UI, key environment)
3. Get approval on those before batch-generating the rest
4. All assets organized into engine-ready folder structure on generation (not manually sorted after)
5. Sprite sheets and animation frames generated as coordinated batches, not one-offs

## Asset Categories

- **Characters**: player (all directions + animation frames), NPCs, creatures/enemies
- **UI**: HUD, menus, dialogue boxes, inventory, battle UI
- **Environment**: overworld tiles, indoor tiles, battle backgrounds, world map
- **Effects**: attack animations, status effects, transitions
- **Items**: held items, key items, badges/collectibles
- **Audio**: see Audio section below

## Key Constraint

gpt-image-1 does not support reference images the way gpt-image-2 does, so style consistency for sprites relies entirely on precise, repeatable prompt engineering. The style bible prompt must be treated as a locked artifact once approved.

---

## Audio

Audio is split across two tools depending on type. All generated audio is royalty-free.

### Sound Effects
**ElevenLabs Sound Effects V2** (Sept 2025) — used for all in-game SFX:
- UI sounds, footsteps, interactions, ambient effects
- Supports 20+ second clips, seamless looping, 48kHz output
- API pricing: 200 credits/generation (auto duration) or 40 credits/second
- Clean API, easiest to integrate, best quality for short-form audio

### Background Music
**Beatoven.ai** — used for all background/scene music:
- Purpose-built for game developers, generates looping instrumental tracks from text prompts
- Handles per-scene music (overworld, indoor, tense moments, menus)
- Royalty-free, diffusion-based generation, cheaper than ElevenLabs for long-form audio

### Audio Pipeline
1. Define the mood/tone for each scene type before generating
2. Generate music loops first, get approval, then generate SFX to complement
3. All audio organized into engine-ready folder structure on generation
4. Loops tested for seamless playback before being committed to the project
