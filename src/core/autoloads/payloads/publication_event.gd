class_name PublicationEvent extends Resource

## Payload for EventBus.evidence_published (Epic 5).
## Typed resource — never use bare Dictionary for cross-cluster signals (arch §4.6).
@export var faction_id: String = ""
@export var evidence_id: String = ""
@export var framing_strength: float = 0.0
