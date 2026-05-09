class_name InterrogationReport extends Resource

## Payload for EventBus.gnoym_interrogated (Epic 7 / Interrogation Bridge).
## Keyed by report_id, NOT by the originating Gnoym's identity (arch §5.1 Rule 1).
## The Gnoym is the *source*, not the *owner*, of the memory once it crosses.
@export var report_id: String = ""
@export var source_npc_surface_form: String = ""
@export var intel_category: String = ""
