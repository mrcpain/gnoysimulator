# Deferred Work

## Deferred from: code review of 5-2-physical-board (2026-05-16)

- **`StyleBoxFlat` allocated on every EvidenceCard state change** — `_apply_state_style()` creates a new `StyleBoxFlat` and calls `add_theme_stylebox_override` on every hover/focus/arm event. Not a correctness issue; with many cards on screen this could be a frame-budget concern. Fix: cache one stylebox per state and mutate properties, or use a theme-based approach.
- **Double-emit `card_picked_up` on drag-after-click** — if a user left-clicks a drawer card (emitting `card_picked_up` in `_gui_input`) then immediately starts a drag (emitting it again via `_get_drag_data`), the controller sets `_armed_instance_id` twice. Non-corrupting since the second write is the same id, but watchers of `card_picked_up` will receive it twice. Fix: in `_get_drag_data`, skip emit if `_state == STATE_ARMED_SOURCE` already.
- **`refresh()` double-call same frame leaves one-frame ghost rows** — `queue_free()` is deferred; if `refresh()` fires twice before end-of-frame (unlikely in practice but possible), old nodes linger visually one frame. Fix: use `free()` (immediate) for the clear pass in `refresh()`, or guard with a dirty-flag and `call_deferred`.

## Deferred from: code review of 5-1-evidence-system (2026-05-17)

- **`restore_via_ghost_protocol` restores regardless of seizure source** — the method restores all ghost_protocol-gated seized evidence without tracking how it was seized. Currently only `seize_on_player_person` seizes evidence, so this is fine. If a future story adds a scripted/boss-forced seizure path that should be permanent, the restore logic will incorrectly undo it. Revisit when Epic 7 (Politburo) or Epic 11 (Boss investigations) introduces alternative seizure mechanisms.

## Deferred from: code review of 4-5-equipment-inventory-screen (2026-05-17)

- **Direct `RPGCore.crafted_inventory` mutation on equip** — `EquipmentScreenController._equip_item_to_slot` decrements `crafted_inventory[item_id]` directly. The spec's own AC5 pseudocode shows this pattern, and no `debit_crafted_item()` API exists on RPGCore. If a future story adds a proper inventory-debit API (e.g., Epic 9 loot-pickup), migrate this write-path to stay consistent with the "all writes through domain methods" architectural rule.
- **`queue_free()` deferred-removal race in `refresh()` calls** — `CraftedInventoryDrawer`, `RecipesPanel`, and `ModifierTotalsPanel` all call `child.queue_free()` then immediately add new children in the same `refresh()` call. If two signals fire in the same frame (e.g., `item_crafted` + `equipment_changed`), a double-refresh runs and both old + new children are alive until end-of-frame. Performance concern only — correctness is unaffected. Consider coalescing refreshes with `call_deferred("refresh")` or a dirty-flag pattern if frame-budget pressure increases.

## Deferred from: code review of 4-3-set-bonus-detection (2026-05-16)

- **`recompute_after_load()` ordering contract not enforced** — `OutfitStateEngine.recompute_after_load()` calls `EquipmentSlots.get_all_slots()` and must be called AFTER `EquipmentSlots.sync_from_rpgcore()`. This ordering is enforced by convention in `SaveSystem._apply_save_to_rpgcore` but not guarded at the call site. If a future refactor reorders the save-load pipeline, `recompute_after_load()` could silently compute against stale slot data. Consider adding an `EquipmentSlots._is_synced` guard flag if the load sequence complexity grows in Epic 9/12.

## Deferred from: code review of 4-2-quality-tiers-heat (2026-05-16)

- **Missing Logger.warn when Balance null + Xyoner items equipped** — `get_xyoner_carrying_heat()` silently returns 0 when Balance is null but Xyoner items are equipped. Spec says "returns 0" with no logging requirement; within design intent. If Balance load failure becomes harder to diagnose, add `Logger.warn` at the null-Balance+xyoner_count>0 branch.
- **Save-load `_last_emitted_total` staleness** — `XyonerHeatEngine._current_district_id` and `_last_emitted_total` are static and survive save-load. Dev Notes explicitly describe these as ephemeral; Epic 9 `district_entered` re-entry corrects any stale state. Consider adding `XyonerHeatEngine.reset_for_test()`-style reset in `_apply_save_to_rpgcore` when Epic 9 wires district scene loading (Story 9.1/9.2).
- **`district_heat_inputs` accumulator has no lower-bound clamp** — `RPGCore._on_heat_input` accumulates without a floor; negative swap deltas can make the accumulator negative. Pre-existing Story 1.7 design decision. Address in a dedicated heat-floor hardening story or Epic 9 district-heat revisit.

## Deferred from: code review of 3-10-combat-difficulty-tuning (2026-05-16)

- **`get_auto_restart_on_death` bool coercion** — `bool("false") == true` in GDScript; if the toggle is ever persisted as a string by a future call site, the accessor silently returns the wrong value with no validation or log. Pre-existing pattern across all toggle accessors (`is_ironman`, `get_subtitles_enabled`, etc.); fix across all accessors in a hardening pass or add per-accessor validation.
- **Static `_invincibility_warn_logged_once` not reset between encounters** — `CombatParameters._invincibility_warn_logged_once` and `_balance_error_logged_once` persist for the entire session; the second encounter that hits the cap is silently swallowed. `force_reset_invincibility_warn()` exists but is only called in tests. EncounterDirector could call it on `encounter_entered` if per-encounter cap tracking is desired; defer until it surfaces as a real debugging pain point.
- **`threshold_unclamped = 0` before multiplier is silent** — if Balance base+body+talent all resolve to 0, the multiplier produces 0, which `max(1, ...)` silently fixes to 1. No log indicates the degraded balance state. Pre-existing gap; add a warn when `threshold_unclamped <= 0` before the multiplier is applied in a future hardening pass.
- **Mid-encounter difficulty desync** — `hit_threshold` is baked by `compute_from_rpgcore()` at encounter start/restart (old tier); `enemy_damage_mult` is read live per `apply_damage` call (new tier). A mid-encounter difficulty change via a future settings panel would produce split behaviour. Intentional per AC5 dev notes ("per-call read, no cache"). Revisit in Story 14.6/14.7 (Settings UI) to decide whether mid-encounter changes should be blocked or trigger a `compute_from_rpgcore` refresh.

## Deferred from: code review of 3-9-sound-as-gameplay-combat (2026-05-16)

- **Overlay tests run with `camera == null`** — `tests/unit/test_footstep_indicator_overlay.gd` and `tests/integration/test_footstep_pipeline.gd`: `viewport.get_camera_2d()` returns null in GUT scenes, so the `player_pos = Vector2.ZERO` fallback path is the one being exercised. The real-camera path (`camera.global_position` non-zero) is untested. Story 9.x camera/visibility-cone scope owns the test scaffolding for a real Camera2D in scene-tree tests; pip-direction regressions under cinematic / smoothing cameras will not be caught by current tests.
- **No initial-state `combat_intensity_changed(0, "")` emit at boot** — `music_director.gd`: `set_combat_intensity("")` short-circuits when `_last_combat_intensity == ""` (initial state). Late subscribers (Story 13.x stem-layer mixer) connecting after boot must poll `current_intensity_level()` rather than relying on a "state-on-subscribe" replay. Documented in `event_bus.gd` signal docstring ("transitions only"); flag for Story 13.x design note.
- **Missing pip texture would ship invisible UI without test failure** — `footstep_indicator_overlay.gd:_build_pip_sprite`: if `art/ui/footstep_pip_placeholder.svg` is missing, `_pip_texture = null`, pips spawn but render nothing. Tests check child-count, not visibility. Asset is present today; add a startup asset-existence assertion in Epic A pipeline tooling rather than per-overlay.
- **`_apply_balance` runs only at `_ready`** — `footstep_emitter.gd`: balance hot-reload during play is not propagated to existing emitters; designer changes to `balance.tres` require restart or per-emitter re-instantiation. Inconsistent with `MusicDirector` (re-reads on every `set_combat_intensity`). Acceptable VS limitation; revisit if dev-tooling adds live-balance support.
- **`WorldClock.minutes_since_start if WorldClock else 0` dead `else` branch** — `footstep_emitter.gd:emit_footstep` and `build_classifier.gd:188`: `WorldClock` is an autoload Object reference, always truthy. The defensive guard never triggers. Codebase-wide cleanup pass; not Story 3.9-introduced.

## Deferred from: code review of 3-8-faction-build-counter (2026-05-16)

- **Escape action ordering latent hazard** — `build_classifier.gd:_on_encounter_resolved`: escape is stamped into the window after `encounter_resolved` fires (correct for future encounters) but classification for the current encounter was already cleared beforehand. Safe today; any reordering of `resume()` vs `emit()` in commit_resolution would mis-stamp the day. Flag for Story 7.2 when escape action feeds the persistent Player Dossier.
- **`window_snapshot()` shared refs** — `build_classifier.gd`: returns a copied Array but BuildAction objects are shared refs. Callers that write fields on returned entries corrupt the live window. Current callers are test-only and read-only; Story 7.2 (`dump_state`/`restore_state`) should use a deep-copy pattern when serializing.
- **`classifier_min_actions` zero/negative guard** — `build_classifier.gd:classify_at_day`: no positive-value clamp on `min_actions`. A zero value would classify from an empty window, potentially returning a spurious tag if total_weight becomes non-zero in future. Balance invariant test (`test_balance_dossier_classifier_min_actions_positive`) catches this at test time; add a runtime `max(1, min_actions)` clamp if live Balance hot-reload is ever added.
- **Static warn dict `_missing_classification_warned` accumulates without reset** — `counter_tactics.gd`: if Balance hot-reloads or adds new counter_tactics keys during development iteration, the warn dict blocks future warns for previously-missing classifications. Matches the established EncounterTier `_pool_warn_logged_once` pattern. Add a reset helper if hot-reload support is ever built.
- **Self-referential signal loop risk** — `build_classifier.gd` subscribes to `encounter_resolved` while its parent `EncounterDirector` emits it. Godot signals are synchronous; if a future Epic 3/7 `encounter_resolved` subscriber calls back into `EncounterDirector` mid-signal, it will see `_current_classification == TAG_UNKNOWN` (already cleared). Document this ordering invariant in EncounterDirector's Forbidden list when Epic 7 Story 7.2 adds the Player Dossier subscriber.
- **"critical_fail" filter dead code** — `build_classifier.gd:_on_skill_check_resolved`: the `if outcome == "critical_fail": return` guard is spec'd but current SkillCheck outcomes are "critical"/"success"/"fail". The filter is harmless as dead code today; if SkillCheck ever adds "critical_fail" as a live outcome, this gate becomes active. Track alongside SkillCheck outcome vocabulary.
- **Tie-breaking bias: exact-tie goes to TAG_GHOST** — `build_classifier.gd:classify_at_day`: if two tags share the exact highest score and both exceed the dominance threshold (e.g., 50% ghost + 50% broadcast), the first tag in SCORED_TAGS iteration order wins deterministically (ghost > broadcast > hands > grifter). Documented in Dev Notes as intentional for VS. Re-evaluate at playtest if players report unexpected ghost-biased counter-tactics at exactly balanced playstyles.

## Deferred from: code review of 3-7-combat-engagement-tiers (2026-05-16)

- **`MusicDirector._last_combat_intensity` not cleared on encounter resolution** — `music_director.gd`: `commit_resolution` and `force_reset_to_idle` do not call `set_combat_intensity("")` or any equivalent reset. Any Story 13.x subscriber reading `last_combat_intensity()` after encounter end but before a new encounter will see the stale previous tier and may apply incorrect crossfade logic. Stub today; Story 13.x wires the real crossfade and owns the reset contract.
- **`_capture_snapshot` default `tier` param is a footgun** — `encounter_director.gd:_capture_snapshot`: the `tier: String = EncounterTier.ROUTINE` default means any future call site omitting the 3rd arg silently records ROUTINE in `EncounterSnapshot.tier` regardless of actual encounter tier. No current call site is affected (single call site in `enter_encounter` passes all 3 args). Flag for refactor attention when additional snapshot capture paths are added (e.g. multi-phase boss Story 11.x).

## Deferred from: code review of 3-6-signature-weapons (2026-05-16)

- **`request_restart` does not restore `weapon_inventory_state`** — `encounter_director.gd` request_restart only restores BODY, cope, slop, RNG seed; the `weapon_inventory_state` field captured in the encounter snapshot is never re-applied to WeaponSlots/RPGCore on restart. If a caller consumes a signature weapon from carried-ids before calling `use_signature`, the weapon will be missing after an encounter restart. Pre-existing gap in the encounter restart system; Story 3.7+ or Epic 4 owns inventory-state restore.

## Deferred from: code review of 3-4-captured-state-escape (2026-05-16)

- **`day_of_capture` label shows 1 on instant-load** — `(now - captured_at) / MINUTES_PER_DAY + 1` in `captured_state_scene.gd:71`; if `minutes_since_start == entered_at_minutes` (first frame after load), result is 1 (acceptable). If clock rolled back (defensive edge), result could be wrong. Pre-existing WorldClock edge; Epic 14 UX polish pass owns display hardening.
- **`_balance_error_logged_once` static var declared but never used** — `captured_state.gd:38`; scaffold for future Balance-key-miss rate-limiting. Harmless; fill in when Balance hot-reload or modding support lands.

## Deferred from: code review of 3-2-stat-modulated-combat (2026-05-15)

- **Empty-curve array crash if curve key exists but value is `[]`** — `clampi(rank, 0, -1)` causes out-of-bounds access in `CombatParameters.compute_from_rpgcore`. Caught by balance lint test `test_balance_combat_curves_are_length_11` at test time. Add runtime `if curve.is_empty()` + Logger.warn guards if live modding support becomes a requirement.
- **Signal connections not explicitly disconnected in `_on_encounter_resolved`** — Godot 4 Node lifecycle auto-disconnects signals when a node is freed via `queue_free`. Safe under current encounter scene management. If CombatActor lifetime model changes to non-scene-bound, explicit `disconnect` calls should be added.
- **AC3 spec wording: "resets to `hit_threshold`" vs implemented "adds `threshold`" carry-over** — The implementation is correct (RPG carry-over damage model). The story spec should be corrected to say "adds `hit_threshold` to `_pending_hits`" for future readers.

## Deferred from: code review of 3-1-encounter-director-snapshot (2026-05-16)

- **Ctrl+Q on death screen quits without confirmation** — pressing Q calls `get_tree().quit()` immediately; no modifier-key guard. Epic 14 polish (UX-DR74 visual treatment) owns this.
- **Chained encounter invalidates prior capture autosave** — if a `commit_resolution` subscriber calls `enter_encounter` again, the new encounter's `is_in_encounter()==true` state causes `capture_resolved` to defer the TAG_CAPTURE autosave for the first encounter's outcome. No chained encounter callers exist before Story 3.2+; revisit when combat scene subscriptions land.
- **Ghost combat scene nodes after save-load mid-encounter** — `force_reset_to_idle` emits no signal; any in-tree combat scene (CombatActor etc.) from Story 3.2+ won't be cleaned up on load. Story 3.2 must subscribe to `encounter_resolved` or add a cleanup hook.

## Deferred from: code review of 2-7-job-quitting-alt-income (2026-05-11)

- **No upper bound on `last_alt_income_day` in validate_and_clamp** — a corrupt save with a huge `last_alt_income_day` (e.g. INT_MAX) permanently blocks all alt income. Consistent with the pre-existing unbounded pattern on `last_billing_day` / `last_sleep_recovery_day`; fix all three in a save-hardening pass post-VS (requires `_apply_save_to_rpgcore` access to compare against restored WorldClock day).
- **Corrupt `job_state` yields misleading "already quit" log** — when `RPGCore.job_state` holds a value that is neither "employed" nor "quit", the state gate in `JobQuitEngine.commit` logs "commit rejected: already quit" which is inaccurate. No functional impact; fix log message to distinguish "unknown state" from "known quit state" in a future engine-hardening pass.

## Deferred from: code review of 2-6-cope-fatigue-tick (2026-05-11)

- **`validate_and_clamp` missing bounds on `fatigue_accumulator` / `cope_overwork_debit`** — `_safe_load_int` does not clamp these to `[0, 100]`. A corrupted save with negative values produces inverted off-day math (off-day emits positive fatigue delta, accumulator floats to 0 from below). Pre-existing Story 1.7 scope; add bounds in Story 1.7 retro or a save-system hardening pass.
- **`last_sleep_recovery_day` future-value disables all recovery** — `validate_and_clamp` clamps to `>= 0` but not `<= current_day`. An edited save with `last_sleep_recovery_day = 9999` silently disables recovery. Static `validate_and_clamp` cannot call autoloads to get current day; fix requires either a post-load check in `_apply_save_to_rpgcore` or a Story 1.8 retro.
- **`cope_overwork_debit < 0` off-day emits positive cope delta** — Correct math (brings debit to 0), but `cope_fatigue_recovery_applied` payload shows `cope_delta_applied > 0` on `is_off_day=true`, which may confuse future subscribers expecting negative deltas on recovery. Add a payload comment or clamp debit to `>= 0` at the `cope_overwork_input` integration point in a Story 1.7 retro.

## Deferred from: code review of 2-5-monthly-bills-autodeduct (2026-05-11)

- **Negative `days_since` when clock resets** — `run_cycle_if_due` computes `days_since = today - last_billing_day` which goes negative if the clock resets below `last_billing_day` (e.g., new game+, clock manipulation). `days_since < days_per_month` silently blocks billing forever. Add a guard: if `days_since < 0`, warn and reset `last_billing_day` to today. Deferred: clock resets are outside VS scope.
- **`_resolve_line_item_amount` value type not validated** — `rent_map[homebase_stage]` and `cost_map[item_id]` are not validated as numeric before `int()` cast. A non-numeric value in `balance.tres` silently returns 0. Mitigated by Balance.tres being type-safe at edit time; add value-type guards post-VS if designer-editable balance becomes a concern.

## Deferred from: code review of 2-4-subscription-cancellation (2026-05-10)

- **Token lookups not called in BillsScreen / RetentionDialog / CancellationStamp `.gd` files** — Theme tokens added to `tokens.gd` but not called at runtime in UI code (hardcoded animation values use `# balance-allow:` instead of `ThemeTokens.token()`). Full token-swap integration is Epic 13 (Story 13.1) territory; symbolic names are set up so the swap auto-works then.
- **Concurrent-dialog rejection not surfaced in UI** — `bills_screen.gd` logs a warning but does not render a `tr("ui.bills.error.concurrent_dialog")` polite error line in the modal. Secondary UX feature; add in a future Bills UI polish pass.
- **`_finalize_commit` is public static** — prefixed `_` by convention only; any code can bypass all `begin()` guards. No enforcement mechanism in GDScript. Architectural decision; document as invariant in PR description.
- **`_tick_due_segments` re-entrancy sort-order violation** — if a `feed_segment_due` listener re-calls `_tick_due_segments()`, newly-added segments may dispatch out of ascending order. No current subscriber violates this; add a re-entrancy guard if future stories add in-handler scheduling.
- **Multiple BillsScreen instances accumulate `subscription_cancelled` signal connections** — if BillsScreen is instanced multiple times without freeing old instances, each receives and processes the signal. Caller (Story 12.1 laptop-app router) must ensure only one instance lives at a time.
- **`_seed_subscriptions_if_empty` guard fails when `_clamp_id_array` drops all active ids** — if all active_subscription_ids entries are dropped by coercion (e.g., saved by a future build with different catalog ids), the seed guard (`cancelled_subscription_ids.is_empty()`) prevents re-seeding if cancelled is non-empty. Bills screen would show 0 subscriptions with no error. Low-probability pre-VS; add a Logger.error when both are empty after load if post-VS telemetry shows this.
- **`retention_dialog_open_for_ids.erase` runs before awakening/signal emissions in `_finalize_commit`** — a listener on `awakening_level_changed` could call `begin()` for the same id and succeed (id already cleared). Design decision per dev notes; no subscriber violates this today.

## Deferred from: code review of 2-2-snooze-morning-slot (2026-05-10)

- `Logger.warn` call is not asserted in any rejection test — no Logger spy/mock infrastructure exists in this project; would need a dedicated logging-capture framework; defer to post-EA test hardening pass.
- `watch_signals` negative-count assertions pass vacuously if watched signals are removed from EventBus — pre-existing pattern across all tests; add a `has_signal()` guard or signal-existence assertion layer if EventBus signal churn becomes a concern post-EA.

## Deferred from: code review of 2-1-worldclock-slots (2026-05-10)

- `_render` modulate `ThemeTokens.token(...) as Color` has no null-guard warning in `DaySlotHUD._render`. If token() returns null for a missing key, `cell.modulate = null` silently fails. Pre-existing Story 1.12 pattern; add a guard or assert at Epic 13 art-pass.
- `_slot_row` child count guard in `DaySlotHUD._render` silently skips rendering when count < 4 with no Logger.warn. Pre-existing Story 1.12 pattern; add warn when count < SLOT_IDS.size().
- Signal re-entrancy in `WorldClock.advance_minutes`: if any subscriber calls `advance_minutes` during signal emission, `new_day`/`new_week` in remaining emissions will be stale. No current subscriber violates this but future stories (2.3 slot-spend, 2.6 Cope/Fatigue) should avoid calling advance_minutes in their signal handlers.

## Deferred from: code review of 1-12-persistent-ambient-hud (2026-05-10)

- `_process` double-computes WorldClock values in `DaySlotHUD` (key built in `_process`, then recomputed inside `_render`). By spec design; Story 2.1 adds `slot_changed` signal to replace polling — swap `_process` for `EventBus.slot_changed.connect(_render)` at that point.
- `SLOT_IDS` is duplicated in both `WorldClock` and `DaySlotHUD` as independent `const` values. If they diverge, slot highlighting silently shows the wrong cell. Fix when Story 2.1 stabilizes the slot-id contract by referencing `WorldClock.SLOT_IDS` directly from `DaySlotHUD`.
- `minutes_since_start` negative → GDScript modulo returns negative → `current_slot()` crashes with OOB index. No code path can produce negative values today; Story 2.1 (time mutators) must validate the incoming delta before assigning.
- `hud_heat_thresholds` ascending-order invariant not enforced in code — balance validator should add a lint rule checking `thresholds[i] < thresholds[i+1]` (noted as TODO in `balance_resource.gd` comments; Story 14.x scope).
- `.tscn` default Color values in `day_slot_hud.tscn` and `heat_indicator.tscn` are hardcoded rather than sourced from theme tokens (scene geometry can't reference GDScript runtime values). Cosmetic only — `_render()` overwrites via tokens in `_ready()`; revisit at Epic 13 art-pass if the flicker-in-editor becomes a friction point.
- `MarginContainer` margin override values (8px) in `persistent_hud.tscn` duplicate `ThemeTokens.DEFAULTS["spacing.m"]`. Cannot inject GDScript into .tscn format; acceptable. Epic 13 token-swap pass should verify margins remain visually correct when spacing tokens change.
- `OnDemandHUDDispatcher._unhandled_input` doesn't guard against `InputMap.has_action` returning false — handled by `InputRebinder.apply_defaults_then_overrides` at boot; if ever called before that (e.g., from an injected test without InputRebinder), the missing action is silently skipped. Add `if not InputMap.has_action(action_id): continue` if the dispatcher ever runs outside the normal boot sequence.

## Deferred from: code review of 1-11-control-scheme-rebinds (2026-05-10)

- `find_conflicts` is mode-unaware — it scans all registered actions regardless of modes, producing false-positive conflict warnings (e.g., SPACE-as-dodge vs SPACE-as-ui_accept, SHIFT-as-sprint vs SHIFT-as-escape_grab). Harmless UX noise for now; add mode-context parameter when mode-switching (Epic 3/5/6) is wired.
- `sprint` and `escape_grab` both default to `KEY_SHIFT` in overlapping modes (sprint: exploration+combat, escape_grab: combat-only). This is an intentional catalog design (Shift serves two distinct affordances), but find_conflicts will always flag it as a structural conflict. Suppress these known same-key pairs when mode-aware conflict detection lands.
- `clear_all` clears Godot builtin actions (ui_accept, ui_cancel) including their joypad bindings. After clear_all + apply_defaults_then_overrides, gamepad navigation breaks (joypad bindings from Godot engine startup are not re-installed by the catalog). Add a `godot_builtin` guard in `clear_all` before Steam Deck Verified scope (Story 14.11).
- `_install_default` and `apply_defaults_then_overrides` erase joypad bindings for `ui_accept`/`ui_cancel` that Godot registers at engine startup. Steam Deck's A button (joypad 0) maps to ui_accept — after any reset-to-default, gamepad navigation through Godot UI breaks. Fix: detect and skip Godot engine-registered joypad events for builtin actions during install. Story 14.11 scope.
- Pause state save/restore — `controls_menu._exit_tree` unconditionally sets `get_tree().paused = false` even if the tree was already paused for another reason before the menu opened. When Epic 3 combat scene can run alongside Settings, add save/restore of prior pause state.

## Deferred from: code review of 1-10-balance-magic-numbers (2026-05-10)

- Hex / binary literal bypass in validator NUMERIC_RE — `0x1F` and `0b1010` literals do not match the regex; trivially evades lint. No such literals in `src/` today. Extend regex (or add a `0x`/`0b` site exemption) if hex appears in Epic 13 theme work.
- Multi-line `"""..."""` triple-quoted string false-positive — `_strip_comments_and_strings` is per-line only and does not track triple-quote state across line boundaries. None in `src/` today; mitigation is the `# balance-allow:` pragma. Documented in story Dev Notes.
- Stale SITE_EXEMPTIONS rot — a renamed file leaves its exemption silently inert; no test or report flags "rule entry never matched." Consider a `--audit-rules` mode that reports zero-match rules.
- `talent_passive_magnitudes` modifier_key not validated against `Talents.MOD_*` constants — `test_talent_passive_magnitudes_keys_well_formed` only checks that `parts[0]` is a valid talent id; a typo in `parts[1]` would silently return 0 from `get_talent_modifier`. Pin the modifier_key set when the talent ownership story lands.
- `save_backup_count ≥ 2` silently treated as 1 — `save_system._rotate_backup` retains a single `.bak` regardless of value above 1. Documented in `balance_resource.gd` field comment and Story 1.8 dev notes; multi-generation rotation is reserved for future work.

## Deferred from: code review of 1-9-schema-versioning-migrations (2026-05-10)

- When `CURRENT_SCHEMA_VERSION` bumps to 2+, the final cast `working as SaveGameV1` in `SaveMigrations.run` must be updated to cast to `SaveGameV{CURRENT}` — at V1 baseline this never triggers (the chain walk never executes) but it is a latent bug for V2+. Procedure documented in story 1.9 dev notes §"When CURRENT_SCHEMA_VERSION bumps".
- `SaveMigrations.run` V1 baseline block (`if version == 1 and current_target == 1`) bypasses when `current_target > 1`, leaving `working` as the raw Resource before the while-loop. The first step fn must handle this raw cast. Acceptable now; add a baseline-cast step before the loop when V2 lands.
- `SaveGameV1.migrate_from` property-copy loop passes values to `v1.set()` without type-checking — a corrupt save with e.g. `attributes` as String survives into `validate_and_clamp` unchecked. Low risk at V1 (no foreign-schema saves exist); add type guards in a future hardening pass.
- Extra disposition axes (beyond AXIS_GNOY_AWAKE/AXIS_PASSIVE_REBEL) that appear in a future save schema pass through `validate_and_clamp` unclamped. Fix when a third axis is introduced.

## Deferred from: code review of 1-8-save-system-ironman (2026-05-09)

- `awakening_level_changed` signal signature change (2-arg → 3-arg) — Story 1.5 change, not 1.8. Pre-existing in the codebase; no callers depend on the old signature today, so no migration needed unless an Epic 13/14 subscriber binds the old contract.
- ~~`dump_save(slot)` triggers EventBus traffic on corrupt slots because it now goes through the post-1.8 `load_from_slot` recovery branches.~~ **Fixed in Story 1.9** via `_load_for_diagnostics`.
- ~~`Disposition.AXIS_*` constant drift would silently zero old saves under future renames — schema-migration concern; Story 1.9 owns it.~~ **Addressed in Story 1.9** via `validate_and_clamp` + frozen reference fixture CI check.
- Steam Deck sleep/resume `Time.get_ticks_msec()` deltas can briefly debounce key-event commits after wake. Extreme edge; defer to post-EA hardening.
- Multi-generation `.bak` rotation (`.bak.1`, `.bak.2`, …) — `save_backup_count >1` is currently a no-op; field reserved for future implementation if EA telemetry shows demand.

## Deferred from: code review of 1-7-derived-stats (2026-05-09)

- Reentrancy in `_emit_changed_for_diffs`: if a `derived_stat_changed` subscriber calls back into `set_attribute`, signals fire mid-loop with partially updated state. Godot queues signals so safe now, but add a call-depth guard when Epic 5/9 subscribers land.
- `set_attribute` called during `load_from_slot` would be unsafe (fires derived-stat signals into uninitialized game state). The load path uses direct dict assignment, so this is currently safe, but add a comment warning when the save system is extended in Story 1.8/1.9.

## Deferred from: code review of 1-6-disposition-axes (2026-05-09)

- Re-entrant `disposition_changed` causes out-of-order events for future Epic 10 subscribers — no subscribers exist in this sprint; guard with deferred emit or call-depth flag when Epic 10 lands
- Integration test `before_each` has no null guard for `/root/RPGCore` and `/root/EventBus` — pre-existing pattern across all integration tests; suite-level fix when test infrastructure matures
- `after_each` `DirAccess.remove_absolute(ProjectSettings.globalize_path(...))` fragility on non-desktop exports — pre-existing pattern from awakening_persistence; safe for headless GUT on desktop

## Deferred from: code review of 1-5-awakening-track-engine (2026-05-10)

- Load-time subscribers miss state after save/load — ThemeManager/MusicDirector state not re-initialized on load because direct `RPGCore.awakening_level = save.awakening_level` emits no signal; intentional for this sprint, Epic 13 scope
- ~~No range clamping on loaded `awakening_level` (corrupted save) — consistent with existing pattern for all other saved fields; validation strategy is Story 1.9 (schema versioning/migrations)~~ **Fixed in Story 1.9** via `validate_and_clamp`.
- Save test bypasses `SaveSystem.save_to_slot/load_from_slot` — mirrors existing talent/skill persistence test pattern; direct ResourceSaver path tests schema correctness, not service wiring

## Deferred from: code review of 1-4-40-talents (2026-05-09)

- `talents: Array` is untyped (bare Array, not `Array[String]`) in `rpg_core.gd:15` — pre-existing field from Story 1.0 schema; type annotation refactor when all consumers are stable
- O(n²) in `get_talent_modifier` — `_get_talent_definition` called per-unlocked-talent inside loop; acceptable at 40 entries; profile in Story 1.10 balance pass
- `unlock_talent` is not atomic with saves — point debit and talent append happen before explicit save; by design (save system is explicit-only, Epic 2 scope)
- All `mutual_exclusions` arrays empty in `talents.tres` — code path correct but never exercised by live data; balance team populates after combat/stealth systems land
- `seized_assets.seized_asset_conversion_pct` = 0.0 in balance — intentional stub until Economy system (Epic 2+); balance pass sets real value
- ~~Stale talent IDs from old saves persist undetected after rename/removal — migration strategy is Story 1.9 (schema versioning + migrations)~~ **Fixed in Story 1.9** via `validate_and_clamp` (drops unknown talent IDs on load).
- Mutual-exclusion check reports only first conflict — spec defines single `conflicting_talent` key; consistent with AC3 contract
- Prerequisite check runs before cost check — ordering unspecified by spec; no caller impact until multi-prereq talents are added
