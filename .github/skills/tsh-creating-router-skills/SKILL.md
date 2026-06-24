---
name: tsh-creating-router-skills
description: "Creates router-style skills that keep one-domain SKILL.md files lean and route tasks to leaf references. Use when a single skill domain (backend, DevOps, SecOps, AI or agentic engineering, data, testing, or any other) is growing too large to navigate, when a domain spans many concerns or mutually exclusive choices, or when codifying a one-hop routing table where each leaf carries a load cue and mutually exclusive alternatives are flagged."
user-invocable: false
---

# Creating Router Skills

Router skills keep a growing domain navigable without turning the root `SKILL.md` into a knowledge dump. They route tasks to concept-first leaves and keep selection separate from ownership.

## Core Design Principles

<principles>

<selection-not-context-pressure>
The problem is selection and ownership, not context pressure. In normal use, only 1-3 skills load at once; the cost of scale is navigating and owning a growing library, not token bloat.
</selection-not-context-pressure>

<one-domain-one-router-one-skill-md>
Use one domain, one router, one `SKILL.md`. The router is a selector, not the knowledge container. Its job is to recognize the task, name the right leaf, and stay lean.
</one-domain-one-router-one-skill-md>

<router-behaves-like-selector>
The router body holds only the sharp domain description, the few global rules, and the routing table. All deeper domain knowledge belongs in leaves.
</router-behaves-like-selector>

</principles>

## File Topology vs Routing Topology

Folders MAY nest, but the routing link graph from `SKILL.md` must stay one hop. Keep it one-hop end to end.

If a reference grows its own internal structure, give it a folder. That helps ownership and keeps templates with the leaf that uses them. But the router must link straight to the leaf itself, never to a directory index that sends the agent onward. Reads degrade past one referenced file, so a second hop weakens the handoff.

A thin, human-facing index can exist for browseability, but it is not the router. The agent should still be able to land on the leaf in one hop.

## The Routing Table

A router is one routing table. Each row names a leaf and the cue that tells the agent when to load it:

| one-hop leaf | when to load / how to identify |
|---|---|
| `reference/<area>/leaf-a.md` | load when the task matches this leaf's cue (a signal in the repo, the task shape, or a declared target) |
| `reference/<area>/leaf-b.md` | load when the task matches this leaf's cue |

The agent decides how many leaves to load by reading the cues: it loads every leaf whose cue applies. That default — load what fits — needs no special declaration.

### Flag mutually exclusive leaves

The one thing the agent cannot infer from independent cues is exclusivity: when two leaves are alternatives and loading both would cross-wire them — for example, two competing tech-stack leaves whose idioms must not blend. Cues are written one row at a time, so nothing tells the agent that matching two is a mistake rather than a feature.

When leaves are mutually exclusive, say so in the cue:

| one-hop leaf | when to load / how to identify |
|---|---|
| `reference/stacks/stack-a.md` | load **exactly one** stack leaf — the one matching the repo's manifest or lockfile; never load a second |
| `reference/stacks/stack-b.md` | alternative to stack-a; load only if it is the matching stack |

Everything else is combinable by default. You do not declare a mode; you only flag exclusivity where loading two siblings would be wrong.

Every routing-table row still needs a per-leaf cue alongside its one-hop link. A bare label and link are not enough.

## Concept-First Leaf Authoring

Leaves are about 80% structure and 20% primitives. They should explain boundaries, lifecycle, decision rules, and diagrams first; concrete syntax comes last.

<concept-first>
A leaf should be concept-first. Prefer diagrams, shape sketches, and abstract interfaces over filled-in domain objects or concrete business code. A leaf that ships copied production code stops guiding the model and starts recruiting it into the wrong local idiom.
</concept-first>

Use primitives only when they stay abstract: empty skeletons, interface shapes, config defaults, or other minimal anchors that help the model build the right local result. Never turn the leaf into a code sample repository.

## Router Sizing and Naming

Keep the router body roughly under 500 lines. A router routes; it does not teach the whole domain.

Names are load-bearing:

- lowercase only
- hyphenated only
- `tsh-` prefix required
- directory name must match the `name` field exactly
- do not namespace with `/` or `:` because such skills silently fail to load

The router should read like a selector index for one domain, not like a handbook for the entire collection.

## `SKILL.md`, not `README.md`

Only `SKILL.md` frontmatter is loaded for selection. `README.md` is never auto-read, so it cannot route anything unless something else points to it. Case matters: `SKILL.md` is uppercase and must stay that way.

Use `README.md` for humans browsing the repository. Use `SKILL.md` for agent selection and routing.

## Applying the Pattern

1. Pick one domain and write its router `SKILL.md`.
   - Give it a sharp description.
   - Add the global rules that apply to every task in the domain.
   - List every leaf in one routing table, each with a `when to load / how to identify` cue. For leaves that are mutually exclusive alternatives, make the cue say to load exactly one.
2. Move detailed content into concept-first leaves under `reference/`.
   - Keep each leaf focused on one choice or one concern.
   - Give larger leaves their own folder when they need local templates or supporting files.
3. Link the router straight to each leaf.
   - Do not route through a directory index.
   - Keep the link graph one hop.
4. Verify on a live task.
   - Confirm the agent loads every applicable leaf.
   - Confirm it never loads two mutually exclusive leaves at once.
   - Confirm unrelated leaves stay out of context.
   - Watch for cross-wiring.
5. Iterate until the router is crisp.
   - If the router is carrying knowledge instead of selection, move that content into leaves.
   - If a leaf is still too concrete, raise it back to concept-first shape.

## Validation Checklist

```text
- [ ] Frontmatter: `name` uses lowercase hyphenated `tsh-` prefix and matches the directory name
- [ ] Frontmatter: `description` states what the skill does and when to use it, including router-pattern triggers
- [ ] Frontmatter: `user-invocable` is `false`
- [ ] Routing: mutually exclusive leaves say "load exactly one" in their cue; all other leaves are combinable by default
- [ ] Routing: every row has a one-hop leaf link
- [ ] Routing: every row includes a per-leaf `when to load / how to identify` cue
- [ ] Routing: the router stays one hop and never routes through an intermediate index
- [ ] Leaves: leaves stay concept-first and avoid filled-in domain objects or concrete business code
- [ ] Files: router body stays roughly under 500 lines
- [ ] Files: directory name matches the `name` field exactly
- [ ] Files: no namespaced `"/"` or `":"` form is used for the skill name
- [ ] Testing: a live task loads every applicable leaf and never loads two mutually exclusive leaves at once
- [ ] Testing: no cross-wiring appears between unrelated leaves
```

## Anti-Patterns to Avoid

| Anti-pattern | Why it's harmful | Fix |
|---|---|---|
| Routing through an intermediate index | Adds a second hop and degrades reads past the first referenced file | Link the router straight to the leaf |
| Loading two mutually exclusive leaves at once | Cross-wires alternatives whose idioms must not blend | Flag exclusivity in the cue: say "load exactly one — the one matching X" |
| Letting a leaf leak concrete code | Forces the model to imitate local implementation details instead of the domain shape | Keep the leaf concept-first and abstract |
| Using a namespaced name with `/` or `:` | Such skills silently fail to load | Use a flat `tsh-` prefixed hyphenated name |
| Putting routing logic in `README.md` | `README.md` is never auto-read for selection | Put routing in `SKILL.md` frontmatter and body |
| Listing leaves without per-row load cues | The router says where, but not why, so selection becomes guesswork | Add a `when to load / how to identify` cue to every row |
| Letting the router turn into a knowledge dump | The root file becomes hard to navigate and defeats the router pattern | Move detail into leaf references and keep the router lean |

## Templates and Examples

Use these supporting files when authoring or reviewing router skills:

A leaf is just a concept-first reference. The two leaf templates show two common shapes — a mutually exclusive alternative and a composable concern — and their filenames keep the canonical "stack"/"pattern" examples; rename them for any domain (provider, framework, control, runner, capability...).

- [Router template](./templates/router-skill.template.md) — scaffold for a router `SKILL.md`.
- [Stack leaf template](./templates/stack-leaf.template.md) — scaffold for a leaf that is a mutually exclusive alternative (stacks are the canonical example; its router cue says "load exactly one").
- [Pattern leaf template](./templates/pattern-leaf.template.md) — scaffold for a composable concern leaf (patterns are the canonical example; combinable by default).
- [Worked example: tsh-building-backend](./examples/tsh-building-backend/SKILL.md) — one example domain among many (DevOps, SecOps, AI engineering, data, and testing use the same routing); a complete one-hop router with two leaves and an on-demand resource.

## Connected Skills

- `tsh-creating-skills` - to author single-file skills when the domain stays small enough that a router is unnecessary
- `tsh-creating-agents` - to align router skills with agent behavior and keep responsibilities separate
- `tsh-creating-prompts` - to understand how prompts trigger skills and keep routing entry points clear
- `tsh-creating-instructions` - to place repository rules in instructions instead of inflating the router
