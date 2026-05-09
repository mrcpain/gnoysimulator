class_name SubscriptionEvent extends Resource

## Payload for EventBus.subscription_cancelled (Epic 2).
## Typed resource — never use bare Dictionary for cross-cluster signals (arch §4.6).
@export var subscription_id: String = ""
@export var reason: String = ""
