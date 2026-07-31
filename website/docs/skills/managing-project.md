---
sidebar_position: 34
title: Managing Project
---

# Managing Project

**Folder:** `.github/skills/tsh-managing-project/`

Routes configured project-management operations through validation, policy enforcement, single-provider dispatch, and bounded `pm-result` results. The skill is exclusively used by the internal `tsh-project-manager` agent.

## Consumer configuration

Consumers opt in through the consuming repository's root `.github/copilot-instructions.md`. The collection documents the contract and does not write that file.

| Field | Requirement |
| --- | --- |
| `provider` | Required; `jira`, `shortcut`, or `markdown`. |
| `project-id` | Required non-secret project identifier. It is never a credential, token, or secret-bearing URL. |
| `policy` | Required; `read-only` or `read-write`. |
| `markdown-root` | Required for `provider: markdown`; repository-relative and confined to the repository. Absolute paths, `..`, and symlinks resolving outside the repository are rejected. |
| `id-prefix` | Optional; defaults to `PM` and must match `^[A-Z][A-Z0-9]{0,7}$`. |

Configuration is validated before operation classification and provider loading. The router classifies requests as `read`, `additive`, `mutating`, `destructive`, or `bulk`. `read-only` blocks every non-read operation. `read-write` grants write eligibility but does not replace provider authorization or explicit confirmation for mutating, destructive, and bulk operations.

## Provider behavior

The router dispatches to exactly one configured provider. Markdown is the only enabled provider in this release. Jira and Shortcut return exactly `unavailable/provider-not-enabled-in-this-release`; there is no fallback, provider switch, or configuration write. The router loads no external provider leaf or tool.

The Markdown provider reference is `.github/skills/tsh-managing-project/references/providers/markdown.md`. It defines the following model:

- Canonical records live at `<markdown-root>/project.md` and `<markdown-root>/items/<ID>.md`.
- Project and item files use YAML frontmatter with schema version `1`; indexes and views are regenerable, not authoritative.
- IDs are immutable `PREFIX-NNN` values allocated from the validated prefix and never reused.
- Every read and write stays below the resolved repository-relative root; absolute paths, `..`, and symlink escapes are rejected.
- The controlled work-item statuses are exactly `backlog`, `ready`, `in-progress`, `blocked`, `done`, and `cancelled`. Archive is archival metadata recorded as a status-only lifecycle transition in the original immutable record, with no `archived` status, move, or deletion.
- Markdown allocation is collision-safe and fails closed with `conflict/id-already-allocated` when a concurrent allocation wins the race. Physical deletion, overwrite, and automatic merging are prohibited.

## Bounded results

Every outcome uses the bounded XML-like `pm-result` envelope. Its closed two-level vocabulary is:

| Category | Reasons |
| --- | --- |
| `success` | `success/completed`, `success/no-results` |
| `invalid` | `invalid/configuration-missing`, `invalid/configuration-malformed`, `invalid/unsupported-provider-value`, `invalid/markdown-root-outside-repository` |
| `blocked` | `blocked/read-only-policy`, `blocked/confirmation-required` |
| `unavailable` | `unavailable/provider-not-enabled-in-this-release` |
| `conflict` | `conflict/id-already-allocated`, `conflict/record-changed` |
| `error` | `error/filesystem-write-failed` |

No other result is permitted. Callers may branch on the outcome category alone; the reason provides the precise result. Path-confinement rejection is `invalid/markdown-root-outside-repository`. External-provider unavailability remains `unavailable/provider-not-enabled-in-this-release` with no fallback, switch, or configuration write.

## Deferred gates

Deferred work includes live Jira/Shortcut validation, including delegated MCP consent and result validation; Jira/Shortcut provider leaves and tools; migration beyond the six additive caller allowlist and guidance changes; Business Analyst safeguards and disposition; prompts; synchronization or migration; and physical deletion.

## Source artifacts

- Router: `.github/skills/tsh-managing-project/SKILL.md`
- Markdown provider: `.github/skills/tsh-managing-project/references/providers/markdown.md`
- Internal consumer: `.github/agents/tsh-project-manager.agent.md`
