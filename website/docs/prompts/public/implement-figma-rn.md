---
sidebar_position: 4.1
title: /tsh-implement-figma-rn
---

**Agent:** UI Engineer  
**Model:** Claude Sonnet 5  
**File:** `.github/prompts/tsh-implement-figma-rn.prompt.md`

A fast path for implementing one Figma-backed React Native or Expo view in a known existing app. It uses the existing UI Engineer and skips full planning, orchestration, and browser verification loops.

## Usage

```text
/tsh-implement-figma-rn
FIGMA_NODE_URL: <figma node url>
SCREEN_NAME: <optional>
ENTRY_POINT: <optional>
TARGET_REPO: <optional workspace-relative app path>
```

`FIGMA_NODE_URL` is required. The other inputs are optional but help narrow the target screen, route, and repository.

## When To Use It

Use `/tsh-implement-figma-rn` when all of the following are true:

- the task is specifically a rendered React Native or Expo UI change
- Figma is the design source of truth
- you want a direct implementation path instead of the full `/tsh-implement` orchestration
- the target already exists as an app or package in the workspace
- the app can be identified by `TARGET_REPO` or an unambiguous `ENTRY_POINT`
- the work is limited to one rendered UI view rather than a cross-cutting feature

Prefer [`/tsh-implement`](./implement) instead when the task may need planning, mixed UI and non-UI work, broader routing, code review orchestration, or the normal delivery flow.

## What It Does

1. Resolves the target repository or entry point when provided.
2. Profiles the target React Native or Expo project before making framework, router, package, or API assumptions.
3. Reads the Figma node through Figma MCP before code changes.
4. Maps the design to existing React Native or Expo primitives and tokens.
5. Runs the narrowest relevant project validation, such as linting, type checking, or a focused test.
6. Records native visual verification as not run when the target project does not provide its own native evidence harness.

It intentionally does not create a plan, delegate to other agents, run the browser capture/review loop, or start code-review orchestration. Use the full flow when any of those safeguards are needed.

## Native Evidence Harness

A **native evidence harness** means verification tooling owned by the target mobile project, such as:

- simulator or device screenshot capture already used by the app
- layout metrics collected from native runtime or test screens
- Detox, Maestro, Appium, or another native E2E or evidence workflow
- a project-specific screenshot diff or visual regression setup for native surfaces

If the target project has this kind of setup, it can support stronger quantitative checks such as `<=1px` geometry drift and optional `<=1%` pixel diff. If it does not, the prompt still implements the UI, but native verification remains a documented limitation rather than a numeric pass.

## Output

- React Native or Expo UI changes in the target app
- A concise completion summary with changed files, commands and results
- Captured evidence path when available
- Clear blockers or native-verification limitations when the target project lacks its own evidence setup
