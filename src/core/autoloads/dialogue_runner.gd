extends Node

## Custom GDScript dialogue VM — stub. Full VM lands in Epic 6.
## Custom VM lives here. NOT Dialogic, Yarn, or Ink. See architecture §3.8 + §5.5.
## These third-party dialogue systems are explicitly rejected (arch locked rule 6).

func _ready() -> void:
	Logger.info("dialogue", "DialogueRunner ready — VM stub at Story 1.0.")


func start_dialogue(dialog_id: String) -> void:
	## No-op + log. Epic 6 implements the real VM.
	Logger.debug("dialogue", "start_dialogue('%s') — stub at Story 1.0." % dialog_id)
