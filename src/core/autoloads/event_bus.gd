extends Node

## Project-wide signal hub — the ONLY cross-cluster communication path (arch §4.6).
## Forbidden: direct sibling-reference between clusters. Use these signals.
## All payloads are typed Resources. Forbidden: bare Dictionary payloads.
## Connections happen lazily when subscribers come online; EventBus just declares signals.

# Subscription / economy (Epic 2)
# Story 2.5 — monthly billing observability.
# bill_unpaid: primitive-arg signal fired once per line-item shortfall during the auto-deduct cycle.
# Subscribers (future): Epic 8 Story 8.6 (eviction-warning state machine reads rent shortfalls),
# Epic 9 (could spike Vault district Heat — TBD). 2.5 is the only writer.
signal bill_unpaid(item_id: String, amount: int)
# bills_deducted: typed Resource payload. Observability-only emission after the cycle completes.
# Subscribers (future): Story 2.6 (Cope/Fatigue tick may react to total_unpaid), Story 12.6 (Feed Forum
# may surface a "you owe X" segment). 2.5 is the only writer.
signal bills_deducted(payload: BillingCycleEvent)
# Story 2.5 — sleep observability. Fires AFTER WorldClock.advance_minutes completes (so subscribers
# reading WorldClock state in the handler see the post-mutation day/slot). Mirrors snooze_committed.
# Single-writer signal — only SleepAction.commit() emits. Subscribers (future): Story 12.1 apartment
# scene state machine (re-renders after sleep), telemetry.
signal sleep_committed(hours: int, minutes_advanced: int)
# Story 2.4 — first writer is SubscriptionCancellationEngine._finalize_commit on RetentionDialogVM.commit().
signal subscription_cancelled(payload: SubscriptionEvent)
# Story 2.4 — subscription cancellation cross-system event signals.
# faction_dossier_flag: primitive-arg observability signal. Future subscribers: Epic 7 Story 7.2.
signal faction_dossier_flag(faction_id: String, flag_id: String, reason: String)
# retention_dialog_opened: fires when SubscriptionCancellationEngine.begin returns a fresh VM.
signal retention_dialog_opened(payload: RetentionDialogOpenedEvent)
# retention_dialog_aborted: fires when RetentionDialogVM.abort() runs.
signal retention_dialog_aborted(payload: RetentionDialogAbortedEvent)
# feed_segment_queued: observability-only. Fires when FeedSegmentScheduler.schedule appends an entry.
signal feed_segment_queued(payload: FeedSegment)
# feed_segment_due: dispatch signal. Fires when FeedSegmentScheduler.tick_due_segments finds a due segment.
signal feed_segment_due(payload: FeedSegment)
# Story 2.2 — snooze observability. Fires AFTER WorldClock.advance_slot completes
# (so subscribers reading WorldClock state in the handler see the post-mutation slot).
# Single-writer signal — only SnoozeAction.commit() emits. Subscribers: Story 12.1
# (apartment scene state machine), telemetry, future Awakening-drift hooks.
signal snooze_committed(day: int)
# Story 2.3 — slot-spend observability. Fires AFTER WorldClock.advance_slot completes AND
# AFTER per-type derived-stat input deltas (fatigue_input / cope_overwork_input) have been
# emitted. Subscribers reading derived stats during the handler see the post-input snapshot.
# Single-writer signal — only SlotSpendEngine.commit() emits. Subscribers: Story 2.5 (sleep
# / genuine-off-day Cope full-restore), Story 2.6 (Cope/Fatigue tick — tag-filters on
# payload.slot_type), telemetry, future Story 12.1 apartment scene state machine.
signal slot_spent(payload: SlotSpendEvent)

# Investigation (Epic 5)
signal evidence_published(payload: PublicationEvent)

# Investigation — Thought Cabinet (Story 5.5)
# thought_completed: master observability fired LAST by ThoughtSlotEngine._apply_completion_side_effects.
# Subscribers: ThoughtCabinetController (UI refresh), Story 5.6 (stamp animation host),
# Story 5.7 (Awakening-aware addenda may react), telemetry.
signal thought_completed(payload: ThoughtEvent)
# evidence_reframed: per-evidence-definition-id observability fired once per reframing application.
# Subscribers: Story 5.7 (silent reframing surfacing on Physical Board / Dossier), Story 7.x.
# 5.5 has ZERO in-cluster subscribers — emit-only.
signal evidence_reframed(evidence_definition_id: String, reframing_tag: String, source_thought_id: String)
# dialogue_line_unlocked: per-dialogue-line observability fired once per unlock application.
# Subscribers: Epic 6 Story 6.1 / 6.2 (DialogueRunner subscribes for graph-traversal gating).
# 5.5 has ZERO in-cluster subscribers — emit-only.
signal dialogue_line_unlocked(line_id: String, source: String)

# Awakening Track — RPGCore re-emits here so ALL subscribers use one path (locked rule 4)
signal awakening_level_changed(old_level: int, new_level: int, reason: String)
# Cinematic gate — fires when Awakening level becomes 1, 5, or 10 (Story 1.5)
# Consumers: Epic 13 (visual/audio effects) and Epic 14 (narrative lock).
# This story stops at signal emission — no surface effect code here.
signal awakening_cinematic_due(level: int)

# Disposition Axes (Story 1.6) — write path (game systems emit; RPGCore subscribes + integrates)
# axis: Disposition.AXIS_GNOY_AWAKE or AXIS_PASSIVE_REBEL. delta is added to running value.
# RPGCore clamps the result to [-1.0, 1.0] before storing and emitting disposition_changed.
signal disposition_input(axis: String, delta: float, reason: String)
# Disposition Axes — read path (UI / ending-eligibility consumers subscribe; Epic 10 scope)
signal disposition_changed(axis: String, old_value: float, new_value: float)

# Derived Stats (Story 1.7) — write path: game systems emit deltas; RPGCore integrates.
# All deltas are int; positive = stat increases. RPGCore clamps the resulting snapshot to [0, 100].
# Reasons are free-form short tags ("eat_slop", "publication_committed", "rest", ...) for log + telemetry only.
signal heat_input(district_id: String, delta: int, reason: String)
signal slop_damage_input(delta: int, reason: String)
signal fatigue_input(delta: int, reason: String)
signal cope_overwork_input(delta: int, reason: String)
signal credibility_bonus_changed(delta: int, reason: String)
signal awareness_bonus_changed(delta: int, reason: String)
signal reach_bonus_changed(delta: int, reason: String)
# Derived Stats — read path: UI / HUD / consumer subscribers (Epics 5, 9, 13).
# scalar stats fire derived_stat_changed; per-district Heat fires district_heat_changed
# so subscribers get the district id without overloading stat_id (see Story 1.7 dev notes).
signal derived_stat_changed(stat_id: String, old_value: int, new_value: int)
signal district_heat_changed(district_id: String, old_value: int, new_value: int)

# Save System (Story 1.8) — trigger path: game systems emit; SaveSystem subscribes + commits.
# day_boundary_crossed is the primary autosave anchor. The four key-event signals are
# declared here so SaveSystem can subscribe; emitters live in Epics 2/3/9/14.
signal day_boundary_crossed(new_day: int)
signal ending_triggered(ending_id: String)
signal capture_resolved(outcome: String)            # "captured" / "escaped" / "yielded"
signal district_entered(district_id: String)
signal player_died()
# faction_standing_changed already declared below (Epic 7) — SaveSystem reuses it.

# Save System — observability path: UI / telemetry subscribers.
signal save_committed(slot: int, tag: String)
signal save_failed(slot: int, error_code: int, reason: String)
signal save_recovery_offered(slot: int, primary_path: String, backup_path: String)
signal save_load_failed(slot: int, reason: String)
# Save System (Story 1.9) — schema migration observability.
# Emitted AFTER a successful migration write-back. Subscribers (Epic 14 polish) can show a
# "Your save was upgraded from V%d to V%d" notice. from_v < to_v always; no-op migrations
# (from_v == to_v) do NOT emit.
signal save_migrated(slot: int, from_v: int, to_v: int)

# Story 2.6 — skill_check observability. Fires AFTER RPGCore.skill_check has awarded XP, BEFORE
# the function returns the result Dictionary to its caller. Single-writer signal — only RPGCore
# emits. Subscribers (today): CopeFatigueEngine._on_skill_check_resolved (per-action fatigue tick).
# Future subscribers: Epic 7 Story 7.5 (Reputation Web "talks crazy" tag spread on Max-Fatigue
# NPC Mode failure per FR80), telemetry.
signal skill_check_resolved(skill_id: String, outcome: String, dc: int)

# Story 2.6 — sleep-tick recovery observability. Fires once per day after CopeFatigueEngine
# applies the Cope/Fatigue recovery deltas. Subscribers (future): Story 12.1 apartment scene
# (rendering rested-state cue), Epic 13 music deterioration crossfade trigger, telemetry.
# 2.6 is the only writer.
signal cope_fatigue_recovery_applied(payload: CopeFatigueRecoveryEvent)

# Story 2.7 — job-quit observability. Fires when JobQuitEngine.commit transitions job_state
# from "employed" to "quit". Single-writer signal — only JobQuitEngine emits. Subscribers
# (today): zero. Future subscribers: Epic 12 Story 12.x (apartment/Greystone scene state),
# Epic 13 (resignation audio cue), telemetry. Reason String is free-form (e.g.,
# "greystone_resignation", "blackmail_exit") — Epic 12 dialogue authoring decides values.
signal job_quit(reason: String)

# Story 2.7 — paycheck credited observability. Fires AFTER JobIncomeEngine credits a Cover-slot
# paycheck (RPGCore.money mutated, payload built). Single-writer — only JobIncomeEngine emits.
# Subscribers (today): zero. Future subscribers: future wallet HUD pip, Story 12.6 Feed Forum
# monthly summary, telemetry. Skipped (NOT emitted) when paycheck_per_cover_slot == 0.
signal paycheck_credited(payload: PaycheckCreditedEvent)

# Story 2.7 — alt-income tick observability. Fires once per JobIncomeEngine.day_advanced cycle
# AFTER all per-source credits applied AND last_alt_income_day stamped. Single-writer — only
# JobIncomeEngine emits. ALWAYS emitted on a successful cycle (including zero-credit days, so
# subscribers can render "no income today" UI). Subscribers (future): Story 12.6 Feed Forum
# daily-summary segment, telemetry.
signal alt_income_credited(payload: AltIncomeCreditedEvent)

# Story 2.8 — slop heal observability. Fires AFTER SlopHealAction.commit applies BODY restore +
# slop_damage_input emit (so subscribers reading RPGCore state in the handler see the post-eat
# values). Single-writer — only SlopHealAction.commit emits. Always-emits on a successful
# commit (even when both deltas are 0 — observability anchor). Subscribers (today): zero.
# Future subscribers: Story 12.2 fridge "you ate" UI flash, Epic 3 combat heal HUD flash, telemetry.
signal slop_heal_committed(payload: SlopHealCommittedEvent)

# Story 2.8 — slop damage drift observability. Fires once per SlopDamageDriftEngine sleep-tick
# drift cycle when tier > tier_clean. Single-writer — only SlopDamageDriftEngine emits.
# Subscribers (today): zero. Future subscribers: Story 12.x apartment "morning mirror" UI,
# Epic 13 audio cue at tier_terminal, telemetry.
signal slop_damage_drift_applied(payload: SlopDamageDriftEvent)

# Story 2.8 — slop damage tier transition. Primitive-arg observability signal (mirrors the
# disposition_input / awakening_level_changed shape). Fires whenever the slop_damage snapshot
# crosses a tier boundary (in either direction). Single-writer — only
# SlopDamageDriftEngine._on_derived_stat_changed emits. Subscribers (today): zero. Future:
# Epic 12 Story 12.x mirror sprite-set swap (the *reason* this signal exists at all — engine
# extension point for the GDD "visible character art changes" spec).
signal slop_damage_tier_changed(old_tier: String, new_tier: String)

# Story 2.8 — attribute downward-drift observability. Typed payload. Fires when an engine
# mutates one of the seven attributes downward as a slow-decay side-effect (slop drift today;
# future "Inner Ring breaks you" / "starvation" / etc.). Distinct from derived_stat_changed —
# that fires on derived snapshots; this fires on the underlying seven-attribute base values.
# Today's writer: SlopDamageDriftEngine._drift_attribute. Subscribers (today): zero. Future:
# telemetry, future "your character has changed" diegetic UI.
signal attribute_drifted(payload: AttributeDriftEvent)

# Skill progression (RPGCore emits after each rank-up; Story 1.3 is the only XP caller)
# Forbidden: re-using awakening_level_changed — separate concepts, separate signals (locked rule 4).
# Forbidden: a per-XP-tick signal — XP is internal accounting until rank-up.
signal skill_levelled(skill_id: String, new_rank: int)

# Talent unlocked — RPGCore emits after successful talent_points debit (Story 1.4)
signal talent_unlocked(talent_id: String)

# Time (WorldClock re-emits here so non-clock clusters stay decoupled)
signal day_advanced(new_day: int)
signal week_advanced(new_week: int)
# Story 2.1 — slot transition. Emitted by WorldClock.advance_minutes when the slot id rolls.
# Subscribers: DaySlotHUD (today), Story 2.3 SlotSpendEngine (next), 2.6 Cope/Fatigue tick (next).
signal slot_changed(old_slot: String, new_slot: String, new_day: int)

# Faction standing (Epic 7)
signal faction_standing_changed(faction_id: String, old_standing: String, new_standing: String)

# Interrogation Bridge output (Epic 7)
signal gnoym_interrogated(payload: InterrogationReport)

# Investigation board (Epic 5)
signal connection_drawn(payload: Variant)

# Politburo outputs (Epic 7)
signal politburo_event(payload: Variant)

# Input mode (Story 1.11) — declared here for Epic 3/5/6 combat/investigation/dialogue to emit.
# This story does NOT emit; the declaration ensures the signal exists from day one.
signal input_mode_changed(old_mode: String, new_mode: String)

# HUD on-demand screen routing (Story 1.12) — declared here so Epics 4/5/9/10 can subscribe
# when they ship Character / Board / Map / Inventory / Dossier / Journal screens.
# Today's only emitter is OnDemandHUDDispatcher; today's consumer count is zero.
signal hud_screen_requested(screen_id: String)

# Equipment (Epic 4) — slot mutation observability + dispatch (Story 4.1, FR28).
# slot: one of Equipment.ALL_SLOTS (15 valid strings).
# item_id: EquipmentDefinition.item_id for non-weapon slots, WeaponDefinition.weapon_id
#   for weapon slots, or "" for unequip / empty-equip.
# Sole writer: EquipmentSlots.equip / EquipmentSlots.unequip (and WeaponSlots.set_main_hand /
#   set_off_hand for the weapon-bridge path). Subscribers (today): zero.
# Future subscribers: Story 4.3 (set bonus detection + outfit_state_changed re-emit),
# Story 4.5 (paper-doll UI refresh), Epic 13 Story 13.x (Layer 2/3 sprite-overlay
# bone-rig consumer for Main Hand / Back), telemetry. Always emits on a successful
# equip / unequip — observability anchor; do NOT suppress for "same item re-equipped"
# (which is itself a meaningful UI gesture).
signal equipment_changed(slot: String, item_id: String)

# Set bonus / Outfit-State (Epic 4 Story 4.3, FR30; memory entry [[project_layered_outfit_state]]).
# state: one of Equipment.ALL_OUTFIT_STATES (6 valid strings — wageworker + 5 set ids).
# Sole writer: OutfitStateEngine.recompute_and_emit. Subscribers (today): zero.
# Future subscribers: Story 4.5 (paper-doll active-set badge), Epic 13 Layer 1 sprite-sheet
# swap (post-VS — the canonical reason this signal exists per memory [[project_layered_outfit_state]]),
# Epic 9 Heat decay engine (subscribe → re-read get_set_bonus_modifiers().special_flags.heat_decay_mult).
# Only fires on STATE TRANSITIONS — re-entering the same state suppresses the emit (idempotent).
signal outfit_state_changed(state: String)

# Crafting (Epic 4 Story 4.4, FR165). item_id: EquipmentDefinition.item_id of the
# crafted output (always in EquipmentCatalog — validated by CraftingAction.commit
# and RecipeCatalog.validate). qty: int >= 1. source: one of
#   CraftingAction.SOURCE_PLAYER_CRAFT  ("player_craft")
#   CraftingAction.SOURCE_CRAFTER_PASSIVE ("crafter_passive")
# Sole writers: CraftingAction.commit, CrafterPassiveEngine._on_day_advanced.
# Subscribers (today): zero. Future subscribers: Story 4.5 (inventory drawer toast
# + materials drawer refresh), telemetry, Story 12.x homebase "Crafting bench
# completed" diegetic feedback. Always emits on a successful add_crafted_item
# write — observability anchor; passive yields emit one per yield even when the
# loop fires multiple yields in a single day_advanced tick.
signal item_crafted(item_id: String, qty: int, source: String)

# Theme system (ThemeManager re-emits after token swap)
signal theme_tokens_changed()

# Opening sequence (Epic 12)
signal schrodinger_resolved(npc_id: String, role: String)

# Story 3.1 — encounter lifecycle (arch §3.5). Three new signals + reuse of capture_resolved
# declared earlier (Story 1.8 for the SaveSystem TAG_CAPTURE trigger).
#
# encounter_entered: primitive-arg observability + dispatch signal. Sole writer:
# EncounterDirector.enter_encounter. Subscribers (today): zero. Future subscribers: Story 3.2
# (CombatActor scene setup), Story 3.5 (combat HUD slide-in per UX-DR85), Story 3.9
# (MusicDirector combat intensity routing), telemetry.
signal encounter_entered(encounter_id: String)

# encounter_resolved: primitive-arg observability + dispatch signal. Sole writer:
# EncounterDirector.commit_resolution. Subscribers (today): zero. Future subscribers:
# Epic 7 Story 7.2 (Player Dossier OPSEC-delayed update), Epic 7 Story 7.3 (Politburo
# input queue), Epic 11 (boss-specific completion arcs), Story 3.8 (Faction Build
# Counter-System learning input), telemetry.
signal encounter_resolved(outcome: String)

# encounter_restart_committed: primitive-arg observability ONLY. Sole writer:
# EncounterDirector.request_restart. Subscribers: zero (today + future) — pure telemetry /
# debug instrumentation channel. No gameplay subscriber expected; gameplay subscribers
# observe encounter_resolved instead.
signal encounter_restart_committed(encounter_id: String, restart_count: int)

# Note: capture_resolved (declared earlier with the Save System triggers) is RE-USED by
# Story 3.1 as the dispatch channel for capture-class outcomes from commit_resolution.
# First writer: EncounterDirector.commit_resolution (this story). Second writer (future):
# Story 3.3 YIELD/ESCAPE prompt resolution path. SaveSystem.TAG_CAPTURE handler subscribes.

# Story 3.2 — combat actor lifecycle (FR16; arch §3.5). Two new signals.
#
# combat_actor_ready: typed-payload dispatch signal. Sole writer: CombatActor._on_encounter_entered.
# Carries (encounter_id, parameters). Subscribers (today): zero. Future: Story 3.5 (combat HUD
# slide-in reads weapon-slot + parameters), Story 3.9 (MusicDirector reads parameters for
# combat intensity routing), telemetry.
signal combat_actor_ready(encounter_id: String, parameters: CombatParameters)

# combat_parameters_recomputed: typed-payload observability signal. Sole writer:
# CombatActor._on_encounter_restart_committed. Subscribers: zero — pure debug observability.
# Future telemetry can subscribe to capture per-restart parameter snapshots.
signal combat_parameters_recomputed(parameters: CombatParameters)

# Story 3.6 — signature weapon use observability + dispatch (FR26).
# signature_weapon_used: typed-payload dispatch signal. Sole writer: CombatActor.use_signature.
# Subscribers (today): zero. Future subscribers: Story 3.7+ (NPC AI applies stun/distract/blind/
# identity-confusion effects per payload.effect_tag), Story 3.8 (signal_jammer suppresses
# Cage backup calls in Faction Build Counter-System), Epic 5 Story 5.1 (camera_flash
# captured_evidence_id appended to evidence inventory), telemetry. ALWAYS fires on a
# successful use_signature call, INCLUDING when effect_tag == "no_effect" — observability
# anchor (Slop Bag vs Cage is a meaningful tactical mistake; telemetry must see it).
signal signature_weapon_used(payload: SignatureWeaponEffectEvent)

# Note: player_died (declared earlier with the Save System triggers + re-used by Story 3.1
# EncounterDirector subscriber) gets its FIRST live emitter via Story 3.2 CombatActor.
# apply_damage on BODY-hits-0. Subscriber chain: CombatActor.apply_damage → player_died →
# EncounterDirector._on_player_died → request_restart("body_zero") (auto-restart toggle on) OR
# DeathRestartScreen.tscn surfacing (toggle off).


# Story 3.9 — Sound-as-Gameplay (FR15, FR177).
#
# enemy_footstep_emitted: typed-payload dispatch signal. Sole writer: FootstepEmitter.emit_footstep.
# Subscribers (today): FootstepIndicatorOverlay (Story 3.9 AC4). Future subscribers: telemetry,
# combat-AI alertness ("the player heard us — call backup"), Story 9.x district-ambient ducking.
# ALWAYS fires on a successful emit_footstep call, including when stream is null (observability anchor).
signal enemy_footstep_emitted(payload: FootstepEvent)

# combat_intensity_changed: primitive-arg observability signal. Sole writer:
# MusicDirector.set_combat_intensity. Fires AFTER `_last_combat_intensity` is updated AND
# AFTER `_current_intensity_level` is recomputed, BEFORE the Logger.info line. Emits on
# transitions only — calling set_combat_intensity with the same tier twice does NOT re-emit.
# Subscribers (today): zero — pure dispatch hook for Story 13.x combat music stem layerer.
# Future subscribers: Epic 13 combat music stem layerer (consumes intensity_level to crossfade
# layer volumes), telemetry, Story 14.x music indicator UI (intensity tier surface for hearing-impaired).
signal combat_intensity_changed(intensity_level: int, tier: String)


# Dialogue (Epic 6, Story 6.1) — 11 new signals; EventBus baseline after 6.1 = 82.
# dialogue_started: sole writer: DialogueVM.start. Always emits on successful start.
signal dialogue_started(graph_id: String)
# dialogue_ended: sole writer: DialogueVM._teardown. Always emits on dialogue end.
signal dialogue_ended(graph_id: String, reason: String)
# dialogue_node_entered: observability-only. Sole writer: DialogueVM._advance_to_interactive.
signal dialogue_node_entered(graph_id: String, node_id: String, node_type: String)
# dialogue_line_presented: sole writer: DialogueVM._resolve_line_node.
signal dialogue_line_presented(payload: DialogueLinePresentedEvent)
# dialogue_choice_presented: sole writer: DialogueVM._resolve_choice_node.
signal dialogue_choice_presented(payload: DialogueChoicePresentedEvent)
# dialogue_choice_selected: observability-only. Sole writer: DialogueVM.submit_choice.
signal dialogue_choice_selected(graph_id: String, node_id: String, choice_id: String)
# dialogue_internal_voice_presented: sole writer: DialogueVM._resolve_internal_voice_node.
signal dialogue_internal_voice_presented(payload: DialogueInternalVoicePresentedEvent)
# dialogue_item_drop_armed: sole writer: DialogueVM._resolve_item_drop_node.
signal dialogue_item_drop_armed(payload: DialogueItemDropArmedEvent)
# dialogue_item_drop_resolved: sole writer: DialogueVM.accept_item_drop. Always emits (accepted or rejected).
signal dialogue_item_drop_resolved(graph_id: String, node_id: String, instance_id: String, accepted: bool)
# dialogue_line_committed: sole writer: DialogueVM._resolve_commit_node. Story 6.5 subscribes as log writer.
signal dialogue_line_committed(payload: DialogueLineCommittedEvent)
# dialogue_system_effect_applied: observability anchor. Sole writer: DialogueVM._resolve_system_effect_node.
signal dialogue_system_effect_applied(payload: DialogueSystemEffectAppliedEvent)


func _ready() -> void:
	Logger.info("eventbus", "EventBus ready. All cross-cluster signals declared.")
