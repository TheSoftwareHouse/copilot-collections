---
sidebar_position: 5.05
title: UI Capture Worker
---

**File:** `.github/agents/tsh-ui-capture-worker.agent.md`

The UI Capture Worker is an internal weak worker used inside the UI verification loop. It performs the mechanical CLI capture steps that produce ACTUAL evidence for review, then returns the results to its caller. It does **not** make design judgments.

## Responsibilities

- Opening and managing the capture session for the current verification pass against a caller-provided, already-running, user-confirmed full URL.
- Collecting the required ACTUAL artifacts for the delegated page or component.
- Recording relevant session details, the exact full URL used, file outputs, exit codes, and blocker notes.
- Optionally running the non-blocking screenshot tripwire when the caller requests it.
- Escalating auth problems, redirects, missing target content, and other capture blockers back to the caller.

## Outputs

- The iteration artifact directory with files such as `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml`.
- An optional `pixel-gate/` folder when the screenshot tripwire runs.
- A structured capture summary for the caller.

## Non-goals

- Does not decide whether the implementation matches Figma.
- Does not interpret design intent or severity.
- Does not ask the user questions directly.
- Does not modify UI code, tests, or design artifacts.
- Does not infer a different URL or port, inspect config to discover one, or launch/start/switch to another local app/server.

## Tool Access

| Tool          | Usage                                                                    |
| ------------- | ------------------------------------------------------------------------ |
| **Terminal**  | Run the CLI capture flow, collect artifacts, and record command outcomes |
| **File Read** | Read only the task context and capture outputs needed for the summary    |

## Skills Loaded

- `tsh-ui-verifying` — CLI-first capture contract, artifact rules, stabilization, and tripwire semantics.
- `playwright-cli` — Exact command patterns and session handling for CLI capture.

## Collaboration

- Called by `tsh-ui-reviewer` when ACTUAL evidence is missing or stale.
- Used by `tsh-ui-engineer` as part of the implement -> capture -> review -> fix loop.
- Returns artifacts, the exact full URL used, and blocker notes to the caller rather than making the final verification decision.

If the confirmed full URL is missing from the delegated task, the worker returns a blocker immediately. It does not attempt fallback discovery.
