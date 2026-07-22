---
sidebar_position: 5.2
title: Plan Implementor
---

# Plan Implementor Agent

**File:** `.github/agents/tsh-plan-implementor.agent.md`

The Plan Implementor agent is an internal-only, strict single-task worker. It executes one delegated plan task exactly as written, reuses the shared `tsh-implement-common-task.prompt.md` worker prompt, and does not broaden scope beyond the assigned seam.

Before any file change, the delegation must identify a plan whose Human Approval record satisfies `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and a valid ISO 8601 UTC `Decision Timestamp` ending in `Z`. If any field is missing, stale, mismatched, or based only on Reviewer approval, refuse and return control to the Engineering Manager.

## Responsibilities

- Execute exactly one delegated plan task at a time.
- Follow the plan literally and stop when the seam is missing or the task is ambiguous.
- Use `vscode/askQuestions` only to report blockers, not to negotiate scope.
- Keep edits minimal and bounded to the delegated task.
- Update plan checkboxes only for the delegated scope.

## Outputs

- Completed implementation for the delegated plan task.
- A precise blocker report when the task cannot be executed safely.
- Updated plan checkboxes for the delegated task and its definition of done.

## Non-goals

- Not user-invocable.
- No dedicated prompt file; it reuses `tsh-implement-common-task.prompt.md`.
- No plan rewriting, task expansion, or adjacent follow-on fixes.
- Does not take on UI work or broader implementation orchestration.
- Does not discard, revert, stash, or clean uncommitted changes outside the delegated task — it treats the working tree as intentional and reports blockers instead of wiping them.

## Tool Access

| Tool                      | Usage                                                                      |
| ------------------------- | ---------------------------------------------------------------------------- |
| **Terminal**              | Run the command or script required by the delegated task                    |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                    |
| **Sub-agents**            | Not used for broader delegation; keep the task single-scope                 |
| **Todo**                  | Track the single delegated task and its checklist items                     |
| **VS Code Commands**      | Run repository commands related to the delegated task                       |
| **Ask Questions**         | Stop and report blockers when the seam is missing or the plan is ambiguous  |

## Skills Loaded

- `tsh-technical-context-discovering` — Confirm plan context and repository conventions before editing.
- `tsh-implementation-gap-analysing` — Verify which seams already exist and which still need work.
- `tsh-codebase-analysing` — Understand the existing patterns around the delegated task.

## Handoffs

This agent is internal-only and does not expose user-facing handoffs. The Engineering Manager delegates to it through the shared common-task prompt.