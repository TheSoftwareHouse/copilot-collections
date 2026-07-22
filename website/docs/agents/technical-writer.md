---
sidebar_position: 15
title: Technical Writer
---

# Technical Writer Agent

**File:** `.github/agents/tsh-technical-writer.agent.md`

The Technical Writer is an internal worker agent that owns repository documentation, authoring and updating it based on a bounded documentation task delegated by the Engineering Manager. README, CHANGELOG, in-repo `/docs`, and the published documentation site are the targets of that ownership. It writes documentation only and never touches product code.

Before any file change, the delegation must identify a plan whose Human Approval record satisfies `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and a valid ISO 8601 UTC `Decision Timestamp` ending in `Z`. If any field is missing, stale, mismatched, or based only on Reviewer approval, refuse and return control to the Engineering Manager.

## Responsibilities

- Owning repository documentation as a whole, authoring and updating it across its targets — README files, CHANGELOG entries, in-repo `/docs` markdown, and the published documentation site.
- Verifying every factual claim — file paths, command names, version numbers, link targets — against the repository before writing it.
- Mirroring the structure, frontmatter, heading order, and link conventions of neighboring documentation pages.
- Keeping documentation accurate to what the system actually does, adding only project-specific information the reader cannot infer.

## What It Produces

Documentation content scoped to the delegated task, such as:

- **README updates** — accurate, consistent project and module documentation.
- **CHANGELOG entries** — appended in the existing format without rewriting history.
- **In-repo `/docs`** — markdown that follows neighboring document structure.
- **Docs site pages** — documentation pages with standard frontmatter and resolving links.

## What It Does NOT Do

- Does not write or edit product code, configuration logic, tests, or infrastructure.
- Does not perform formal code review or design review.
- Does not invent link targets to pages that do not exist (internal documentation links must resolve).
- Does not expand scope beyond the documentation files named in the delegated task.

## Tool Access

| Tool | Usage |
|---|---|
| **File Read** | Read source code, configuration, and existing docs to verify claims and mirror structure |
| **File Search** | Locate documentation files, link targets, and referenced artifacts |
| **File Edit** | Create and update documentation files only |
| **Todo** | Track multi-file or multi-step documentation work |

## Skills Loaded

- `tsh-writing-documentation` — Documentation structure conventions, documentation-site build expectations, and the write-vs-review boundary.
- `tsh-technical-context-discovering` — Confirm project conventions and existing documentation patterns before writing.
- `tsh-codebase-analysing` — Read and accurately describe the code or artifacts a documentation page covers.

## Handoffs

The Technical Writer is delegated to by the Engineering Manager via the internal `tsh-write-documentation.prompt.md` worker prompt for documentation-only work. It returns the documented changes and any unresolved dependency back to the Engineering Manager.
