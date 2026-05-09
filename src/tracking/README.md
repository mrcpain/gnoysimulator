# Three Tracking Systems — Legal-Distinctness Contract

**This file is the legal-distinctness contract for the Three Tracking Systems vs. US 10,926,179 (WB Nemesis). Re-read before touching `src/tracking/` per architecture §7.3 code-review checklist.**

Any code change in `src/tracking/` requires referencing this README in the PR description. See architecture §5.1 and §7.1.

---

## §5.1 Three Tracking Systems Triad — Legal-Distinctness Enforcement

**The single most important code-level constraint in this project.**

The Brief and GDD spell out that the Dossier / Politburo / Reputation Web triad must be structurally distinct from US 10,926,179 (WB Nemesis). The architecture enforces this at code level via four rules. Each rule maps to a specific module and is enforced by code review (and ideally, lint at EA).

### Rule 1: The Player Dossier MUST NOT contain per-NPC memory.

- `src/tracking/player_dossier.gd` owns: threat axes, build classifier, known associates (recruit ids), known operations, warrants, suspected aliases, plant flags, last-update timestamp, OPSEC delay-debt.
- It does **not** contain: a Gnoym's specific memory of a specific conversation, a Gnoym's name keyed to a quote, a Gnoym's personal grievance.
- Quotes that enter the Dossier come **only via the Interrogation Bridge** (Rule 3), and they enter as faction-intel records (`InterrogationReport`) — keyed by report id, not by the originating Gnoym's identity-as-an-individual. The Gnoym is the *source*, not the *owner*, of the memory once it crosses the bridge.

### Rule 2: The Politburo Simulation MUST NOT read the player-action graph directly.

- `src/tracking/politburo/politburo_sim.gd` reads: previous Politburo state, RNG seed, the queued **input list** for this tick.
- It does **not** read: the Player Dossier directly, the Reputation Web directly, the player's action history.
- The input list is constructed by `EventBus` subscribers that *summarize* relevant player actions for the tick (e.g., `OperativeEliminated(boss_id)`, `EvidencePublished(faction_id, framing_strength)`). These summaries are the only player-input vector. The simulation rules then determine outcomes per its own logic — promotions, succession, betrayals — none of which are scripted off player actions.
- **Why this matters legally:** the patent claim hinges on player actions causing hierarchy changes. In our architecture, the player provides inputs; the simulation determines hierarchy per its own independent rules. The hierarchy would still update if the player did nothing (succession from old age, internal politics, blackmail-debt cycles).

### Rule 3: Interrogation Bridge is the ONLY data path from Reputation Web to Player Dossier.

- `src/tracking/reputation_web/interrogation_bridge.gd` is the single function. It is called explicitly when an interrogation event resolves. It writes an `InterrogationReport` to the Dossier with the source Gnoym's quoted-back surface form.
- No other code may import from `reputation_web/` into `player_dossier.gd`. This is enforced by:
  1. A `# DISTINCTNESS CONTRACT — see §6.1` comment header in `player_dossier.gd` listing the only allowed import.
  2. A code-review checklist item.
  3. (Future, EA prep) a static analysis check.
- **Reputation Web is self-contained.** Gnoym remember the player. They gossip. They quote the player. None of this enters the faction system except via interrogation.

### Rule 4: A standing legal-distinctness README in `src/tracking/README.md`.

This file is the documented contract. Any code change in `src/tracking/` that AI agents propose must be reviewed against this README before merge. The README quotes GDD §Three Tracking Systems verbatim and points back to this section.

---

## Naming Clarification (legal-distinctness adjacent)

The **player's own evidence dossier** (`src/investigation/dossier_interface.gd`) is the player's notes — what the player has gathered and can publish. It is **NOT** the same thing as the **Faction Dossier** (`src/tracking/player_dossier.gd`), which is what the Xyoners know about the player.

- **Evidence Dossier** — player-side, `src/investigation/` cluster
- **Faction Dossier** — Xyoner-side, `src/tracking/` cluster

Future AI agents must not conflate these. [Source: architecture §5.4, §6.1]

---

*Pointer: architecture §5.1 and §7.1 are the primary reference. This README quotes them verbatim and is the files-of-record §6 per architecture §7.4.*
