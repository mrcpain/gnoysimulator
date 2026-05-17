class_name EvidenceInventoryDrawer extends Control

## Story 5.2 — Right-side panel on the Physical Board. Lists every un-pinned evidence
## instance as a small EvidenceCard. Drag-source AND click-source-then-target source.
##
## Refreshes on:
##   - _ready (initial mount).
##   - PhysicalBoardController calling refresh() after every pin / unpin.

signal row_picked_up(instance_id: String)

const EVIDENCE_CARD_SCENE: PackedScene = preload("res://src/ui/components/evidence_card.tscn")

var theme_variant: String = "resistance"
var _card_widgets: Dictionary = {}

@onready var _row_container: VBoxContainer = $RowContainer


func _ready() -> void:
	refresh()


func refresh() -> void:
	## Tears down + re-builds the row list from EvidenceInventory.all_instance_ids()
	## minus PhysicalBoardState.all_pinned_ids().
	## Hot path called on every pin/unpin — keep cheap.
	if not is_instance_valid(_row_container):
		return
	for child in _row_container.get_children():
		child.queue_free()
	_card_widgets.clear()

	var all_ids: Array[String] = EvidenceInventory.all_instance_ids()
	for id in all_ids:
		if PhysicalBoardState.is_pinned(id):
			continue
		var card: EvidenceCard = EVIDENCE_CARD_SCENE.instantiate()
		card.instance_id = id
		card.theme_variant = theme_variant
		card.set_in_drawer(true)
		card.card_picked_up.connect(_on_card_picked_up)
		_row_container.add_child(card)
		_card_widgets[id] = card


func _on_card_picked_up(instance_id: String) -> void:
	row_picked_up.emit(instance_id)
