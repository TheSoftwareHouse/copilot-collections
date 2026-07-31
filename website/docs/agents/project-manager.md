---
sidebar_position: 16
title: Project Manager
---

# Project Manager Agent

**File:** `.github/agents/tsh-project-manager.agent.md`

The Project Manager is a unified internal worker for project records and metadata. It is not a product implementation agent and is not invoked directly by users.

## Scope and dispatch

Every project-management request goes through the `tsh-managing-project` router skill in `.github/skills/tsh-managing-project/SKILL.md`. The router validates consumer configuration, applies policy, selects exactly one provider, and returns the bounded result. The agent does not dispatch directly to Jira, Shortcut, or any external project-management service.

The agent may manage project records and metadata only. It never edits product code, application source, repository infrastructure, implementation plans, or consumer configuration. Its exact permitted tools are `read`, `search`, `edit`, `todo`, and `vscode/askQuestions`; `edit` is limited to authorized project-record and metadata writes under the configured provider root.

## Provider and credential boundaries

The configured provider is never inferred, switched, or used as a fallback. In this release, only Markdown is available. Jira and Shortcut return exactly `unavailable/provider-not-enabled-in-this-release`; the agent does not fall back to Markdown, switch providers, or write configuration. The agent refuses to collect, persist, or echo credentials, tokens, or secrets. It has no direct Jira, Shortcut, external PMS, or external-provider tools.

Consumer opt-in is a contract in the consuming repository's root `.github/copilot-instructions.md`. It is not a collection change: consumers document their own `provider`, non-secret `project-id`, `policy`, and, for Markdown, repository-relative `markdown-root`. The collection does not edit that file.

## Policy and operational writes

`read-only` blocks every write. `read-write` grants write eligibility only; mutating, destructive, and bulk operations still require applicable configuration, provider authorization, and explicit user confirmation.

Project-record writes are operational work, not implementation-plan file-changing delegation. They therefore do not invoke or bypass the Human Approval precondition applied to execution owners. The agent must not claim Human Approval or use its `edit` tool to substitute for that precondition.

## Result contract

The agent returns the router's bounded XML-like `pm-result` envelope. The vocabulary is closed:

| Category | Reasons |
| --- | --- |
| `success` | `success/completed`, `success/no-results` |
| `invalid` | `invalid/configuration-missing`, `invalid/configuration-malformed`, `invalid/unsupported-provider-value`, `invalid/markdown-root-outside-repository` |
| `blocked` | `blocked/read-only-policy`, `blocked/confirmation-required` |
| `unavailable` | `unavailable/provider-not-enabled-in-this-release` |
| `conflict` | `conflict/id-already-allocated`, `conflict/record-changed` |
| `error` | `error/filesystem-write-failed` |

Callers branch on the category; the reason supplies the precise two-level result. Markdown ID collisions use `conflict/id-already-allocated`, and path-confinement rejection uses `invalid/markdown-root-outside-repository`.

## Deferred gates

The following remain deferred: live Jira/Shortcut validation, including delegated MCP consent and result validation; Jira/Shortcut provider leaves and tools; migration beyond the six additive caller allowlist and guidance changes; Business Analyst safeguards and disposition; prompts; synchronization or migration; and physical deletion.
