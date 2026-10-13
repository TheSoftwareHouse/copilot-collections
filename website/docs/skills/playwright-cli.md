---
sidebar_position: 36
title: Playwright CLI
---

# Playwright CLI

**Folder:** `.github/skills/playwright-cli/`  
**Used by:** [UI Capture Worker](../agents/ui-capture-worker)

Browser automation through the `playwright-cli` command: open pages, interact with elements, take snapshots and screenshots, and manage sessions and storage. Allowed tools are `playwright-cli`, `npx`, and `npm` via Bash.

## Key Areas

| Area | Coverage |
|---|---|
| **Core commands** | `open`, `goto`, `click`, `fill`, `type`, `hover`, `select`, `upload`, `check`, `eval`, `resize`, `close` |
| **Snapshots** | Page state snapshots with element refs (`e15`), optional depth limits, element scoping, and bounding boxes |
| **Targeting** | Snapshot refs by default; CSS selectors and Playwright locators such as `getByRole` also work |
| **Save as** | Screenshots (page or element) and PDF export |
| **Tabs and sessions** | Tab management, named sessions (`-s=`), persistent profiles, multiple browsers |
| **Storage** | `state-save` / `state-load`, cookies, localStorage, sessionStorage |
| **Network and DevTools** | Request routing and mocking, console, requests, tracing, video recording, `run-code` |
| **Output** | `--raw` for result-only output, `--json` for structured replies |

## Authenticated Capture

For pages behind a login, the skill defines a real-login flow with session reuse:

- Credentials come from the repo-root `.env`, using variables named `TSH_UI_LOGIN_<NORMALIZED_FIELD_KEY>` derived from the actual login form fields.
- If the page redirects to login and those variables are missing, the caller is asked to add them to `.env`; `.env` is reloaded before the next attempt.
- After a genuine login through the real sign-in UI, the session is saved with `state-save` to a secret path and reused with `state-load`.

Rules:

- Never print the values of `TSH_UI_LOGIN_*` variables.
- Keep the storage-state file out of version control and outside committed artifact directories such as `specifications/**`.
- Never inject cookies, tokens, `localStorage`, or `sessionStorage` by hand to fake a signed-in state.

## Installation

If the global `playwright-cli` command is missing, try the local version with `npx playwright-cli`; otherwise install it globally with `npm install -g @playwright/cli@latest`.

## Reference Files

The skill links to deeper references for running and debugging tests, request mocking, running code, session management, spec-driven testing, storage state, test generation, tracing, video recording, and inspecting element attributes.

## Connected Skills

- [UI Verification](./ui-verification) — consumes the captured evidence in the verification loop.
- [E2E Testing](./e2e-testing) — Playwright test patterns that complement CLI automation.
