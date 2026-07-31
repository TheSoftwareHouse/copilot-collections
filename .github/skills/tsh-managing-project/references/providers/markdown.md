# Markdown Provider

`<markdown-root>` and `<ID>` in this document describe path and value shapes in prose. They are not executable placeholders.

## File layout

All canonical records are confined below the configured repository-relative root:

| Path shape | Purpose |
| --- | --- |
| `<markdown-root>/project.md` | Project-level metadata. |
| `<markdown-root>/items/<ID>.md` | One canonical file per work item. |

Any index, board view, or roll-up file is **regenerable** and **never authoritative**. The canonical Markdown records above are the only source of truth. Activity history within a record is preserved.

## Schema version 1

Both `project.md` and `items/<ID>.md` carry YAML frontmatter identified by schema version `1`.

### Project metadata

| Field | Meaning |
| --- | --- |
| `schema-version` | The integer schema version; this document defines version `1`. |
| `project-id` | Stable identifier for the project. |
| `title` | Human-readable project title. |
| `description` | Project description. |
| `created-at` | Creation timestamp. |
| `updated-at` | Most recent metadata or activity timestamp. |
| `archived-at` | Optional archival timestamp. |

### Item metadata

| Field | Meaning |
| --- | --- |
| `schema-version` | The integer schema version; this document defines version `1`. |
| `id` | Immutable item identifier matching the filename. |
| `title` | Human-readable item title. |
| `status` | Controlled work-item status. |
| `description` | Work-item description. |
| `relationships` | Links to related items using the allowed relationship types and stable IDs. |
| `created-at` | Allocation timestamp. |
| `updated-at` | Most recent metadata, status, relationship, or activity timestamp. |
| `archived-at` | Optional archival timestamp. |

The Markdown body may contain the record description and preserved activity history. Frontmatter remains the authoritative metadata for the record.

## Identifiers

Identifiers use the form `PREFIX-NNN`, where `PREFIX` is the validated configured `id-prefix` and defaults to `PM`. The router owns configuration validation; this leaf uses the resulting prefix without redefining that validation.

- IDs are immutable once allocated and are never reused, including after archival.
- Sequence values are compared numerically, never lexicographically.
- IDs render with at least three zero-padded digits.
- The width expands naturally beyond `999`; for example, `PM-1000` follows `PM-999`.

## Collision-safe allocation

Allocation must fail closed because concurrent Git work can observe and create records at the same time:

1. Scan **every** canonical `items/<ID>.md` record under the configured root, including records whose status is archived, and take the numerically greatest sequence value.
2. Select `max + 1` as the candidate ID.
3. Immediately before writing, rescan or re-check that the exact candidate path is still unoccupied.
4. Create the candidate file with an exclusive create that fails if the path already exists, not with a plain write.
5. If the candidate path is occupied, or the exclusive create loses a race, fail closed: return `conflict/id-already-allocated` with an explicit instruction to retry. Do not silently select another ID, overwrite, or merge.

There is no lock service, runtime daemon, or automatic merge. Safety comes from the re-check, exclusive create, and fail-closed conflict reporting.

## Outcome mapping

This leaf maps its provider-specific conditions into the router's closed vocabulary:

| Condition | Outcome |
| --- | --- |
| Markdown ID collision or allocation race | `conflict/id-already-allocated` |
| Path-confinement rejection | `invalid/markdown-root-outside-repository` |
| A record changed underneath an in-flight update | `conflict/record-changed` |
| A filesystem write failure | `error/filesystem-write-failed` |
| Normal completion | `success/completed` |
| Empty read result | `success/no-results` |

All other outcomes use only the router's exact closed category/reason vocabulary. This leaf introduces no new outcome values. Configuration validation, operation classification, policy enforcement, and provider dispatch remain owned by the router.

## Path confinement

- Reject absolute paths.
- Reject any path containing `..`.
- Resolve symlinks and reject the path if the resolved target escapes the repository.
- Keep **every** read and write under the resolved repository-relative root.

A path-confinement rejection returns `invalid/markdown-root-outside-repository`.

## Controlled statuses

The controlled work-item status values are exactly:

| Status |
| --- |
| `backlog` |
| `ready` |
| `in-progress` |
| `blocked` |
| `done` |
| `cancelled` |

Archive is not a seventh controlled status. The controlled status remains one of the six values above; archival is represented by archival metadata on the original record.

## Relationships

Relationships use exactly these types, and each relationship references a stable item ID:

| Type | Meaning |
| --- | --- |
| `parent` | Identifies the item's parent. |
| `blocks` | Identifies an item blocked by this item. |
| `blocked-by` | Identifies an item blocking this item. |
| `relates-to` | Identifies a related item. |
| `duplicates` | Identifies a duplicated item. |

Links between records use repository-relative paths.

## Archive lifecycle

Archive is a status-only lifecycle transition recorded in archival metadata in the original `items/<ID>.md` file. It does not add `archived` to the controlled status list. There is no archive directory and no file move or deletion; the record stays exactly where it was allocated. Physical deletion, overwriting, and automatic merging are prohibited.

The original record and its activity history remain preserved. An archive transition must not allocate a replacement ID or create a second canonical record.

## Explicit prohibitions

- Never overwrite or automatically merge a record; this protects a concurrent contributor's work.
- Never switch providers or act as a fallback for an unavailable external provider.
- Never write or change consumer configuration, including the consuming repository's root `.github/copilot-instructions.md`.
- This leaf does not synchronize with, mirror, or push to any external system.
