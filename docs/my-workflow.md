# My Game Dev Workflow (Solo Dev — Fast, but Planned Right)

A personal cheatsheet for how I move through BMAD/GDS to ship a game without skipping planning fundamentals.

**Philosophy:** Plan thoroughly up front so quick-dev can fly later. Skip the ceremonial review/sprint loops a team would need, but never skip the docs that lock the vision.

---

## Phase 1 — Vision (do not skip)

| Step | Skill | Output |
|---|---|---|
| 1 | `/gds-brainstorm-game` | Raw ideas, mechanics, hooks |
| 2 | `/gds-create-game-brief` | Locked vision: genre, audience, scope, hook |
| 3 | `/gds-domain-research` *(optional)* | Genre/competitor grounding — only if I'm in unfamiliar territory |

**Gate:** I should be able to describe the game in one sentence before moving on.

---

## Phase 2 — Design (do not skip)

| Step | Skill | Output |
|---|---|---|
| 4 | `/gds-create-gdd` | Game Design Document — mechanics, systems, loops, progression |
| 5 | `/gds-create-narrative` *(if story-driven)* | Story, world, characters |
| 6 | `/gds-create-ux-design` | HUD, menus, player feedback |
| 7 | `/gds-validate-gdd` | Sanity check the GDD before architecture |

Optional consult: `/gds-agent-game-designer` (Samus Shepard) if I'm stuck on creative direction.

**Gate:** GDD validated. No major mechanic still hand-wavy.

---

## Phase 3 — Architecture (do not skip — this is what makes quick-dev safe)

| Step | Skill | Output |
|---|---|---|
| 8 | `/gds-game-architecture` | Engine choice, systems, data flow, save format, scene structure |

Optional consult: `/gds-agent-game-architect` (Cloud Dragonborn) for deep architecture questions.

**Gate:** I know exactly what folders, scenes, and core systems exist before writing code.

---

## Phase 4 — Asset Pipeline Setup (project-specific — see `docs/asset-generation.md`)

Before any code or asset generation:

1. **Lock the style bible prompt** (gpt-image-1 has no ref-image support — prompt is the only consistency lever)
2. **Generate hero assets first** — main character, primary UI, one key environment
3. **Get those approved before batch generation**
4. **Define mood/tone per scene** for Beatoven music + ElevenLabs SFX
5. **Pre-build the engine-ready folder structure** so generated assets drop straight into place

**Gate:** Style bible locked + hero assets approved. After this, asset generation is a batch operation, not a creative decision.

---

## Phase 5 — Lightweight Planning (solo-dev shortcut)

For a solo project I skip full PRD + sprint ceremony. Minimum viable plan:

| Step | Skill | Output |
|---|---|---|
| 9 | `/gds-create-epics-and-stories` | Epic + story breakdown straight from GDD |
| 10 | `/gds-check-implementation-readiness` | Final gate: GDD + UX + Architecture + Epics aligned |

**Skip unless I need them:** `/gds-create-prd`, `/gds-sprint-planning`, `/gds-sprint-status`.

**Gate:** Implementation readiness check passes. I have a story list I can pull from.

---

## Phase 6 — Build (the fast loop)

Primary path — solo quick-flow:

- **`/gds-quick-dev`** — implements stories directly following the architecture I already locked in
- **`/gds-agent-game-solo-dev`** (Indie) — for rapid prototyping decisions

Heavier path — when a story is complex or risky:

- `/gds-create-story` → `/gds-dev-story` → `/gds-code-review`

Per story I ask myself: *"Does this touch a core system or is it content?"*
- **Core system** → use the heavier path with code review
- **Content / level / dialogue / asset wiring** → quick-dev

---

## Phase 7 — Validate (do not skip)

| Step | Skill | When |
|---|---|---|
| `/gds-test-design` + `/gds-test-automate` | After core systems land | Lock down the systems I'll regret breaking |
| `/gds-playtest-plan` | After first vertical slice | Real human feedback |
| `/gds-performance-test` | Before content scaling | Catch perf cliffs early |
| `/gds-correct-course` | When something's clearly off | Don't grind on a broken plan |
| `/gds-retrospective` | After each major epic | Compound lessons |

---

## My "What Do I Do Next?" Decision Tree

```
Just had an idea?              → /gds-brainstorm-game
Idea is clear?                 → /gds-create-game-brief
Brief locked?                  → /gds-create-gdd
GDD done?                      → /gds-create-ux-design (+ narrative if needed)
GDD validated?                 → /gds-game-architecture
Architecture locked?           → Lock style bible + generate hero assets
Hero assets approved?          → /gds-create-epics-and-stories
Epics ready?                   → /gds-check-implementation-readiness
Readiness passed?              → /gds-quick-dev (loop on stories)
Stuck or off-track?            → /gds-correct-course
Finished an epic?              → /gds-retrospective + /gds-playtest-plan
```

---

## Hard Rules I Set For Myself

1. **No code before architecture.** Quick-dev only flies when the rails exist.
2. **No batch asset generation before hero assets are approved.** Style drift is unrecoverable at scale.
3. **Style bible is a locked artifact.** I do not "tweak it a little" once it's set.
4. **Tests on core systems before content scaling.** Content stories are cheap to redo; system bugs aren't.
5. **If I'm tempted to skip Phase 1 or 2, I'm about to waste a week.**

---

## Skill Quick Reference

**Agents (consultation):**
- `/gds-agent-game-designer` — Samus Shepard (creative)
- `/gds-agent-game-architect` — Cloud Dragonborn (technical)
- `/gds-agent-game-solo-dev` — Indie (rapid prototyping)
- `/gds-agent-game-dev` — Link Freeman (heavier dev)

**Editing existing docs:** `/gds-edit-gdd`, `/gds-edit-prd`

**Project docs (brownfield):** `/gds-document-project`, `/gds-generate-project-context`
