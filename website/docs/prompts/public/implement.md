---
sidebar_position: 4
title: /tsh-implement
---

**Agent:** Engineering Manager  
**Model array (from the agent):** GPT-5.6 Luna, Claude Sonnet 5
**File:** `.github/prompts/tsh-implement.prompt.md`

A thin trigger that starts implementation delivery. It routes execution to the [Engineering Manager](../../agents/engineering-manager) agent, whose shared model array is **GPT-5.6 Luna** and **Claude Sonnet 5**, and hands off to the canonical orchestration workflow — it does not define that workflow inline.

## Usage

```text
/tsh-implement <JIRA_ID, task description, *.research.md, or *.plan.md>
```

The four primary inputs are a task description, a Jira ID, a standalone `*.research.md` file, and a `*.plan.md` implementation plan. If a research or plan companion is missing, the workflow prepares it; it never authorizes no-plan implementation.

## What It Does

The prompt routes to the Engineering Manager, which loads the `tsh-orchestrating-implementation` skill and starts at **Step 0** of that workflow. From there, the skill — not the prompt — owns:

- **Step 0 flow-start todos** — creates the todos needed for the selected flow before any delegation begins.
- **Step 1 Full Flow establishment** — confirms Full Flow as the only implementation route and assesses planning readiness: research, plan, open questions, Technical Context, reviewer readiness, and Human approval state.
- **Full Flow** — planning readiness, plan review, todo and UI inventory, upfront execution plan, delegated execution routing via canonical Task-to-Owner Routing, including repository documentation via `tsh-technical-writer`; for app-code tasks, Plan Implementor is the default for actionable, low-risk seams and Software Engineer is the exception for complex non-UI work; and the UI-verification and code-review gates.

Full Flow requires Human approval of the exact current plan revision before the first file-changing delegation. The automated `tsh-plan-reviewer` `APPROVED` verdict is Reviewer approval only; it is not permission to implement. When the Architect records plan-authoring Human approval, authoring ends and delivery starts in a new discussion; `/tsh-implement` remains a thin trigger, and that discussion reuses the unchanged persisted approval without asking for approval twice.

## Key Behaviors

- **Thin trigger** — contains no workflow steps; the workflow lives in `tsh-orchestrating-implementation`.
- **Routes to one seat** — always hands off to the Engineering Manager using its shared model array of GPT-5.6 Luna and Claude Sonnet 5.
- **Starts at Step 0** — flow-start todos are created first, then Step 1 establishes Full Flow and checks planning readiness inside the skill.

## Output

- Code changes applied by delegated specialist agents.
- Updated plan checkboxes and Changelog entries.
- Code review findings from the delegated `tsh-code-reviewer` run, conditional on the delivered change set containing reviewable implementation artifacts.
