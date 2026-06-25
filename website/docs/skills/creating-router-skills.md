---
sidebar_position: 34
title: Creating Router Skills
---

# Creating Router Skills

**Folder:** `.github/skills/tsh-creating-router-skills/`
**Used by:** Copilot Engineer

Router skills keep a growing domain easy to navigate without stuffing the root `SKILL.md` with everything the domain knows. They route tasks to concept-first leaves and keep selection separate from ownership.

## Core Design Principles

- **Selection over context pressure** — The challenge is choosing the right leaf, not fighting token limits.
- **One domain, one router, one `SKILL.md`** — The router is a selector, not the knowledge container.
- **Stay lean at the top** — Keep the router to the sharp domain description, the global rules, and the routing table.

## The Routing Table

A router is one routing table. Each row names a leaf and a `when to load / how to identify` cue. The agent loads every leaf whose cue matches — deciding how many to load on its own. That default needs no declaration.

The one thing cues cannot express on their own is exclusivity: when two leaves are alternatives and loading both would cross-wire them (for example, two competing tech-stack leaves). For those, make the cue say to load exactly one — the one matching the authoritative signal (a manifest or lockfile for a tech stack, a provider config for infrastructure, a declared compliance target for security). Everything else is combinable by default.

## Validation Checklist

- Frontmatter `name` matches the directory name and uses the required `tsh-` prefix
- The `description` says what the router does and when to use it
- `user-invocable` remains `false`
- Mutually exclusive leaves say "load exactly one" in their cue
- All other leaves are combinable by default
- Every routing row includes a one-hop leaf link and a cue for when to load it
- The router never routes through an intermediate index
- Leaf files stay concept-first and avoid concrete business-code examples

## Connected Skills

- `tsh-creating-skills` — to author single-file skills when the domain is small enough that a router is unnecessary
