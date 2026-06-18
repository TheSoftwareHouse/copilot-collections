---
name: tsh-writing-documentation
description: "Authors and updates repository documentation — README, CHANGELOG, in-repo `/docs`, and the published documentation site. Covers documentation structure, documentation-site build expectations, and the write-vs-review boundary. Use when creating or editing documentation content without touching product code."
user-invocable: false
---

# Writing Documentation

Owns repository documentation: authors clear, accurate, and well-structured content and keeps the documentation set internally consistent. README, CHANGELOG, in-repo `/docs`, and the published documentation site are the targets of that ownership, with explicit conventions for structure, documentation-site builds, and the boundary between writing documentation and writing product code.

## Core Design Principles

<principles>

<documentation-scope>
This skill owns repository documentation broadly — content only, never product code. Its targets are README files, CHANGELOG entries, in-repo `/docs` markdown, and the published documentation site. It never writes or edits product code, configuration logic, tests, or infrastructure. When documentation must describe code behavior, read the code to describe it accurately, but do not modify it. If documentation cannot be written without first changing code, stop and report the dependency instead of editing code.
</documentation-scope>

<accuracy-over-volume>
Documentation must describe what the system actually does, not what it might do. Verify every factual claim — file paths, command names, option flags, version numbers, link targets — against the repository before writing it. The reader already understands general concepts; add only the project-specific information they cannot infer. Prefer a short, correct page over a long, speculative one.
Less is more: cut every word, sentence, and section that does not earn its place, because brevity serves the busy reader.
</accuracy-over-volume>

<structure-mirrors-neighbors>
New documentation pages mirror the structure of existing nearby pages rather than introducing a new shape. Match heading order, frontmatter fields, link style, and section naming used by sibling files in the same directory. Consistency across the docs set matters more than any individual stylistic preference.
</structure-mirrors-neighbors>

<links-must-resolve>
Internal documentation links must resolve, so a broken internal link is a build failure, not a cosmetic issue. Only link to pages that already exist or that you create in the same task. Never invent a link target to a page that does not exist; use plain code formatting or an existing valid link instead.
</links-must-resolve>

</principles>

## Writing for Busy Readers

The principles in *Writing for Busy Readers* by Todd Rogers and Jessica Lasky-Fink shape the reader-centered craft rules below.

<busy-reader-craft>
<enough-formatting>
Use headings, lists, and tables only when they improve navigation or comprehension. Remove decorative or redundant formatting that does not help the reader find or understand the content.
</enough-formatting>

<design-for-navigation>
Front-load the conclusion or most important information, and make headings descriptive enough for skimming. Structure pages so a reader scanning quickly can jump to the right section without guessing.
</design-for-navigation>

<make-reading-easy>
Write short sentences, use plain words, keep to one idea per paragraph, and prefer active voice. Avoid jargon unless the reader can reasonably be assumed to know it.
</make-reading-easy>

<show-why-it-matters>
State the purpose and relevance of a page or section early, so readers know why it matters to them. Connect the content to the task they are trying to complete.
</show-why-it-matters>

<make-acting-easy>
End pages or sections with clear next steps or actionable guidance. Make the reader's path forward obvious instead of leaving them to infer what to do next.
</make-acting-easy>
</busy-reader-craft>

## Documentation Targets

| Target | Location | Conventions |
| --- | --- | --- |
| README | repo root `README.md` and nested `README.md` files | Plain Markdown; keep headings and tone consistent with the existing file. |
| CHANGELOG | `CHANGELOG.md` | Append entries in the existing format; do not rewrite historical entries. |
| In-repo docs | `/docs` markdown | Plain Markdown; follow the structure of neighboring documents. |
| Documentation site | published documentation pages | Markdown documentation pages with standard frontmatter (`sidebar_position`, `title`); internal documentation links must resolve. |

## Workflow

Use the checklist below and keep it synchronized with your todo list:

```text
Documentation progress:
- [ ] Step 1: Identify the documentation target and audience
- [ ] Step 2: Gather accurate source facts
- [ ] Step 3: Match the neighboring structure
- [ ] Step 4: Write or update the content
- [ ] Step 5: Validate links and the docs build
```

**Step 1: Identify the documentation target and audience.** Determine which target type the task touches (README, CHANGELOG, in-repo `/docs`, or the documentation site), who the reader is, and what they need to accomplish. Confirm the change is documentation-only and not a disguised code change.

**Step 2: Gather accurate source facts.** Read the relevant code, configuration, and existing documentation to verify every claim you intend to make. Do not document behavior you have not confirmed.

**Step 3: Match the neighboring structure.** Open one or two sibling pages in the same directory and mirror their frontmatter, heading order, link conventions, and section naming. For the documentation site, reuse the established page shape for that section (agent pages, skill pages, prompt pages).

**Step 4: Write or update the content.** Write concise, accurate prose. Keep edits scoped to the documentation files named in the task. Do not touch product code, tests, or infrastructure.
When writing prose, apply the reader-centered craft rules in `Writing for Busy Readers` above.

**Step 5: Validate links and the documentation build.** For documentation-site changes, run the documentation site build; broken internal links must resolve or the build fails. For README, CHANGELOG, and `/docs` changes, verify referenced paths and links resolve manually. Fix issues before handing off.

## Write vs. Review

This skill writes and updates documentation. It does not perform formal code review or design review. When a documentation change depends on a product-code change, report the dependency to the orchestrator rather than making the code change. When the documentation needs sign-off on technical accuracy beyond what the source files reveal, surface the open question instead of guessing.

## Connected Skills

- `tsh-technical-context-discovering` - to confirm project conventions and existing documentation patterns before writing.
- `tsh-codebase-analysing` - to read and understand the code or artifacts a documentation page must accurately describe.
- `tsh-creating-instructions` - to keep declarative project rules in instruction files rather than narrative documentation.
