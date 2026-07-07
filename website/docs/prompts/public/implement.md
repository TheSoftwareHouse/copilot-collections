---
sidebar_position: 4
title: /tsh-implement
---

**Agent:** Engineering Manager  
**Model:** GPT-5.4 mini  
**File:** `.github/prompts/tsh-implement.prompt.md`

A thin trigger that starts implementation delivery. It routes execution to the [Engineering Manager](../../agents/engineering-manager) agent on **GPT-5.4 mini** and hands off to the canonical orchestration workflow — it does not define that workflow inline.

## Usage

```text
/tsh-implement <JIRA_ID, task description, or path to a *.plan.md>
```

Provide at least one of: a task description, a Jira ID, or a `*.plan.md` implementation plan. Related context such as a `*.research.md` file can be included when available.

## What It Does

The prompt routes to the Engineering Manager, which loads the `tsh-orchestrating-implementation` skill and starts at **Step 0** of that workflow. From there, the skill — not the prompt — owns:

- **Step 0 flow-start todos** — creates the todos needed for the selected flow before any delegation begins.
- **Step 1 flow selection** — recommends Quick Flow or Full Flow based on scope, ambiguity, file impact, planning readiness, and Figma/UI-verification involvement.
- **Quick Flow** — direct delegation to the Software Engineer, validation checks, and a code-review gate.
- **Full Flow** — planning readiness, plan review, todo and UI inventory, upfront execution plan, delegated execution routing, and the UI-verification and code-review gates.

## Key Behaviors

- **Thin trigger** — contains no workflow steps; the workflow lives in `tsh-orchestrating-implementation`.
- **Routes to one seat** — always hands off to the Engineering Manager on GPT-5.4 mini.
- **Starts at Step 0** — flow-start todos are created first, then flow selection (Step 1) happens inside the skill, with the user able to override the recommendation.

## Output

- Code changes applied by delegated specialist agents.
- Updated plan checkboxes and Changelog entries.
- Code review findings from the delegated `tsh-code-reviewer` run.
