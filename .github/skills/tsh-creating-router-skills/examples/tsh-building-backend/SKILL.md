---
name: tsh-building-backend
description: "Routes a concept-first backend domain into one-hop leaf references. Use when the task needs to select a backend stack, apply backend patterns, or load on-demand resources."
user-invocable: false
---

<!-- markdownlint-disable MD033 MD024 -->

# Building Backend Router

> This backend domain is one illustrative example. The same one-hop routing model applies to DevOps, SecOps, AI engineering, data, testing, and any other domain — only the leaves change.

<selection-and-ownership>
Selection and ownership for a concept-first backend domain.
</selection-and-ownership>

<router-overview>
<what-this-router-does>
This router keeps the domain lean and resolves tasks in one-hop routing.
</what-this-router-does>
<one-hop-routing>
One-hop routing stays straight from the router to the leaf; no intermediate index, no second hop.
</one-hop-routing>
</router-overview>

## Core Design Principles

<principles>
  <selection-not-context-pressure>
    The problem is selection and ownership, not context pressure.
  </selection-not-context-pressure>
  <one-domain-one-router-one-skill-md>
    One domain, one router, one `SKILL.md`.
  </one-domain-one-router-one-skill-md>
  <router-behaves-like-selector>
    The router is a selector, not the knowledge container.
  </router-behaves-like-selector>
</principles>

## File Topology vs Routing Topology

<topology-notes>
Folders MAY nest deeper for ownership, but the routing link graph stays one hop end to end. The router links straight to leaves and never routes through an intermediate index.
</topology-notes>

## Routing Table

<routing>
| one-hop leaf | when to load / how to identify |
|---|---|
| [stack-selection](reference/stacks/stack-selection.md) | load **exactly one** stack leaf — the one matching the repo's backend manifest or lockfile; never load a second |
| [pattern-composition](reference/patterns/pattern-composition.md) | load when the task needs composition guidance; combinable with other applicable concern leaves |
</routing>

## On-Demand Resource

<resources>
On-demand support material: [backend-router.template](resources/backend-router.template.md)
</resources>

## Concept-First Leaf Authoring

<concept-first>
Keep every leaf concept-first and abstract. Use shape sketches, boundaries, and minimal primitives only; never introduce filled-in backend business code.
</concept-first>

## Router Sizing and Naming

<router-sizing>
Keep the router compact and selector-like so the model can resolve the right leaf without carrying the whole domain.
</router-sizing>

## `SKILL.md`, not `README.md`

<readme-rule>
Only `SKILL.md` frontmatter is loaded for selection, so this router lives in `SKILL.md` and points directly to its leaves.
</readme-rule>

## Applying the Pattern

<steps>
1. Match the task against the routing table cues.
2. Load every applicable leaf in one hop; load exactly one stack leaf.
3. Keep the leaf concept-first and abstract.
4. If supporting material is needed, load it on demand from the co-located resource.
</steps>

## Validation Checklist

<validation>
- [ ] Frontmatter uses `tsh-building-backend`
- [ ] Frontmatter description follows `{what}. {when — triggers}.` and includes `Use when`
- [ ] `user-invocable` is `false`
- [ ] The body contains the literal `one-hop`
- [ ] The stack leaf cue says to load exactly one
- [ ] Other leaves are combinable by default
- [ ] Each row includes a `when to load / how to identify` cue
- [ ] The router links directly to `reference/stacks/stack-selection.md`
- [ ] The router links directly to `reference/patterns/pattern-composition.md`
- [ ] The router links directly to `resources/backend-router.template.md`
- [ ] No intermediate index appears between router and leaf
</validation>

## Connected Skills

<connected-skills>
- `tsh-creating-skills` — aligns with the skill-format conventions for router bodies and validation
- `tsh-creating-instructions` — keeps repository rules in instructions instead of inflating the router
</connected-skills>
