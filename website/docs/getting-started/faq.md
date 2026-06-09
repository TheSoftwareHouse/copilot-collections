---
sidebar_position: 5
title: FAQ & Best Practices
---

# FAQ & Best Practices

This page captures the practical working habits TSH teams use with Copilot Collections day to day.

It is not a rigid protocol. Think of it as a set of defaults from the people who built and use the framework on real projects.

If you are new to the framework, start with the [Workflow Overview](../workflow/overview), then come back here for the operating advice teams usually ask about after the first few sessions.

:::tip The Short Version
- Default to `/tsh-analyze-materials` when you need to shape or expand a task.
- Default to `/tsh-implement` when you need to build, fix, or change something.
- Use one session for one meaningful slice of work, not one tiny story at a time.
- Review `research.md` and `plan.md` carefully, but keep durable human documentation separate.
:::

## Which prompts should I use most of the time?

For most projects, a small set of prompts covers nearly all daily work:

- `/tsh-analyze-materials` when you need to create or refine a task, backlog item, or specification.
- `/tsh-implement` when you need to implement a feature, hotfix, or larger change.
- `/tsh-review` when you want an explicit code review pass.
- `/tsh-review-ui` when you need to verify a UI against Figma.

In practice, TSH teams try to keep the workflow simple. The common default is:

1. Shape the task with `/tsh-analyze-materials` if needed.
2. Deliver it with `/tsh-implement`.
3. Run `/tsh-review` or `/tsh-review-ui` when the task needs an explicit quality check.

You do not need to keep switching agents manually for every step. The framework is designed so the main prompts route work to the right agents for you.

## How big should one `/tsh-implement` session be?

Usually bigger than people expect.

TSH teams do not optimize for a strict rule like "stay below 50% of context". A more useful default is to keep one session focused on one meaningful implementation slice: often a large story, a few related stories, or even an epic if the work is coherent.

Doing everything story by story is often less efficient because the framework has to rebuild task context, technical context, and planning overhead again and again.

Good examples of one session:

- one large story
- several related stories from the same epic
- a coherent epic with shared context

Bad examples of one session:

- two unrelated implementations
- one session that keeps drifting across different features
- a session that has already become mostly cleanup after a completed feature

## Should I watch token percentage and open a new chat at 50%?

No. TSH does not use a fixed percentage rule.

The practical question is whether the session is still productive and cost-effective. Sessions often remain useful well beyond 50%, and larger projects would become awkward very quickly if you forced a hard cutoff.

Use these signals instead:

- The task scope has drifted into a different problem.
- The conversation starts compacting repeatedly.
- The agent has to reconstruct too much intent from a long history.
- You are no longer changing the same feature slice.

If none of those are happening, continuing in the same session is usually fine.

## What should I do when conversation compaction starts?

Treat it as a signal, not an automatic failure.

If compaction appears once but you are still working on the same coherent slice, you can often continue. If it keeps happening or the task has grown too wide, narrow the scope and start a new session with a tighter request.

A practical split is often better than a tiny split. For example, instead of restarting for every story, move to something like "epic 1, stories 1-4" if that is still one coherent change.

## Is it better to work story by story?

Usually not.

TSH actively discourages over-splitting implementation into tiny sessions when the work shares the same technical and business context. Repeating the surrounding workflow for every story can consume as many or more tokens than handling a larger slice once.

If the work belongs together, bundle it. If it is a real scope break, split it.

## After implementation, should I keep writing in the same chat or run `/tsh-implement` again?

Use the size of the follow-up change as the rule.

Stay in the same chat when:

- it is a small fix
- you found a bug during manual testing
- the issue can likely be resolved in 2-3 messages
- you want to preserve the already-built technical context

Start a new `/tsh-implement` flow when:

- the change is substantial
- the scope is shifting
- you need fresh research or a fresh plan
- the current session is already bloated

Keeping a small follow-up in the same session can be cheaper because the model can reuse the context it already built.

## If I type a plain follow-up like "here is the bug, fix it", will the Engineering Manager still delegate?

Usually yes.

In TSH's experience, the Engineering Manager often still delegates follow-up work when it is meaningful enough. Only very small fixes may stay local and not trigger broader delegation.

If you want a full structured pass with fresh research and planning, use `/tsh-implement` explicitly.

## How should I use `research.md` and `plan.md`?

Treat them as working artifacts for the agent and for you as the developer solving the task.

The intended flow is:

1. The agent produces `research.md`.
2. You review it critically and continue the discussion if anything looks wrong or incomplete.
3. The agent produces `plan.md`.
4. You review the plan critically before implementation starts.
5. Only then do you proceed with implementation.

The important part is not the file names. The important part is that you read these artifacts carefully instead of treating them as automatic approvals.

## Are `research.md` and `plan.md` the same as project documentation?

No.

They are useful implementation artifacts, but they are not a substitute for durable documentation intended for humans.

If a task produces knowledge the team should keep, turn that into proper documentation such as:

- ADRs for important architectural decisions
- developer-facing feature documentation
- team documentation in the repository or Confluence

This split helps in two ways: you keep long-lived documentation readable for humans, and you avoid overloading the main repository with stale implementation artifacts that the agent may over-trust later.

## When should I create ADRs or human documentation?

Whenever a decision matters beyond the current session.

At TSH, an ADR is a good default when you make an important architectural or technical decision. It can be detailed or lightweight. The point is to capture the reasoning in a form the team can revisit later.

It is also common to ask Copilot to generate documentation for the development team after implementation, for example based on the feature you just built or the last few commits on the branch.

## Where should I keep specifications and old planning artifacts?

There are two practical patterns.

Pattern 1: keep them in the main repository while they are still active.

This is convenient when the specs are fresh and you still refer to them often.

Pattern 2: move older or less relevant specs to a separate `-meta` repository.

This is useful when the main repository starts accumulating outdated material. Too many old specs can pollute context and make the agent pull in information that is no longer trustworthy.

The `-meta` approach works especially well with a VS Code multi-root workspace. You keep the archive available, but only add the specific folders you need into the active workspace.

## If I extend an existing feature later, should I reuse the old plan or start from scratch?

It depends on how far the change moves away from the original intent.

Reuse the existing specification or plan when:

- the new work is an extension of the same feature
- the previous intent is still valid
- you want Copilot to preserve continuity without rediscovering everything from code

Start fresh when:

- the change is a major deviation from the original scope
- the old specs are stale or misleading
- the new direction needs a new research phase anyway

One practical middle ground is to ask for a second plan in the same folder that extends the base plan and explicitly references what changed.

Another valid approach is to archive the current state in a `-meta` repository, then rerun the full `research -> plan` flow with the new requirements.

## Should I attach previous specification files when extending a feature?

Usually yes, if they still represent the same feature direction.

Attaching the previous specification can help Copilot preserve continuity and understand the earlier intent without rediscovering everything only from code. The trade-off is extra context load, so it is worth doing when the earlier documents are still relevant and trustworthy.

If the previous spec is stale, contradictory, or from a substantially different direction, do not force it into the new session.

## How should I organize specification folders?

Use names that stay readable after a few weeks, not just on the day they were created.

If you do not have an external task identifier such as a Jira ticket, a practical convention is:

```text
NNNN-short-description
```

That gives you ordering and makes it easier to scan many specification folders later.

## Should I ask several related things at once or keep chatting line by line?

Batch related requests whenever possible.

One of the core working habits behind Copilot Collections is to issue clear requests and expect outcomes, instead of walking the agent sentence by sentence. Saving up several related questions or instructions into one prompt is usually more efficient than stretching the same intent across many tiny turns.

This is especially useful when you already know the goal and can provide context up front.

## Do I need to switch models manually?

Usually no.

For normal use of the framework, TSH recommends relying on the default model configured by Copilot Collections and avoiding unnecessary model juggling. The main prompts are designed around that setup.

Manual model selection makes the most sense when you are using a pure custom agent directly and have a clear reason to override the default.

## Should I enable Bypass Approvals?

If your environment and risk tolerance allow it, many teams find it useful.

The reason is simple: the workflow can involve a lot of repeated approvals for file operations and tool usage, especially during implementation. Removing unnecessary approval friction makes the framework much easier to use in practice.

Only do this if it matches your team's security expectations and the kind of repositories you work on.

## What is the best default mindset for using Copilot Collections?

Use the framework to do the heavy lifting, but keep human review where it matters.

That means:

- let the main prompts orchestrate the work
- keep sessions large enough to preserve useful context
- avoid needless agent and model switching
- review research, plans, and code critically
- promote durable knowledge into real team documentation

Copilot Collections works best when you treat it as a structured delivery workflow, not as a chat toy.