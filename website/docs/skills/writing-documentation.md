---
sidebar_position: 33
title: Writing Documentation
---

# Writing Documentation

**Folder:** `.github/skills/tsh-writing-documentation/`  
**Used by:** [Technical Writer](../agents/technical-writer) via `tsh-write-documentation.prompt.md`

Owns repository documentation, authoring clear, accurate, well-structured content without touching product code. README, CHANGELOG, in-repo `/docs`, and the published documentation site are the targets of that ownership.

## Documentation Targets

| Target | Location | Conventions |
|---|---|---|
| **README** | repo root and nested `README.md` | Plain Markdown; consistent with the existing file |
| **CHANGELOG** | `CHANGELOG.md` | Append in the existing format; do not rewrite history |
| **In-repo docs** | `/docs` markdown | Plain Markdown; follow neighboring document structure |
| **Documentation site** | published documentation pages | Markdown documentation pages with standard frontmatter; internal documentation links must resolve |

## Process

### Step 1: Identify the Target and Audience

Determine which documentation target the task touches, who the reader is, and what they need to accomplish. Confirm the change is documentation-only and not a disguised code change.

### Step 2: Gather Accurate Source Facts

Read the relevant code, configuration, and existing documentation to verify every claim before writing it. Documentation describes what the system actually does, not what it might do.

### Step 3: Match the Neighboring Structure

Mirror the frontmatter, heading order, link conventions, and section naming of sibling pages in the same directory. Consistency across the docs set matters more than individual stylistic preference.

### Step 4: Write or Update the Content

Write concise, accurate prose scoped to the documentation files named in the task. Never touch product code, tests, or infrastructure.

### Step 5: Validate Links and the Build

For documentation-site changes, run the documentation site build. Any broken internal link is a build failure, so internal documentation links must resolve. For README, CHANGELOG, and `/docs` changes, verify referenced paths and links resolve manually.

## Write vs. Review

This skill writes and updates documentation; it does not perform formal code or design review. When a documentation change depends on a product-code change, the dependency is reported to the orchestrator rather than resolved by editing code.

## Connected Skills

- `tsh-technical-context-discovering` — confirm project conventions and existing documentation patterns before writing.
- `tsh-codebase-analysing` — read and understand the code or artifacts a documentation page must describe.
- `tsh-creating-instructions` — keep declarative project rules in instruction files rather than narrative documentation.
