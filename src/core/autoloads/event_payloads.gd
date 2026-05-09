## Typed payload registry — preloads all cross-cluster signal payload classes.
## Forbidden: bare Dictionary signal payloads. Use the typed classes (arch §4.6).
## "Type churn is easier than dict-shape drift." — architecture §4.6
## Each payload is its own file (GDScript one-class-name-per-file constraint).
## Payload files live alongside this registry in src/core/autoloads/payloads/.

# No class_name here — this file is just documentation/registry.
# Payload classes loaded via their own files with class_name declarations.
