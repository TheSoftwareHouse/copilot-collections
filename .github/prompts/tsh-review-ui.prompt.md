---
agent: "tsh-ui-reviewer"
model: "Gemini 3.1 Pro (Preview)"
description: "Single-pass UI verification: compare implementation against Figma and report differences."
argument-hint: "[Figma URL or pinned node link] [exact full dev server URL] [component/section name] [optional task-id or artifact directory]"
---

<goal>
Perform exactly one UI verification pass comparing the current implementation against the Figma design. Report all differences found and never fix code in this workflow.

This prompt can run standalone or as the delegated reviewer step from `/tsh-implement`, but in both modes it must return an explicit, non-empty verdict. An empty response is invalid.
</goal>

<prerequisites>
- This verification step is delegate-only. If the caller cannot actually invoke `tsh-ui-reviewer` with its required tools (`figma`), or cannot provide fresh `tsh-ui-capture-worker` artifacts for the current pass, the step is blocked and must return `VERIFICATION NOT RUN`.
- The caller must not try to perform UI verification itself as a fallback.
- The caller must run `tsh-ui-capture-worker` first for the current pass and provide the resulting artifact directory to this reviewer.
</prerequisites>

<input-requirements>
- Required: Figma URL or pinned Figma node link for the exact component or section being verified.
- Required: user-confirmed exact full dev server URL for the page under verification.
- Required: component or section name.
- Required for delegated verification: task ID and iteration number, or an explicit artifact directory path containing `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` for this pass.
- If the caller supplies a user-confirmed full URL, use that exact URL unchanged. If no URL is supplied in a standalone run, confirm one with the user before capture.
</input-requirements>

<required-skills>
Before starting, load and follow these skills:

- `tsh-ui-verifying` - verification process, criteria, tolerances, severity definitions, report format
  </required-skills>

<workflow>
Follow the 5-step verification process defined in the `tsh-ui-verifying` skill. The skill contains the complete workflow. For this prompt, enforce these additional rules:

1. Validate inputs first: Figma URL, user-confirmed full dev server URL, component name, and artifact-directory context.
2. Get EXPECTED from Figma via `figma`.
   - MANDATORY: export the node image and save it as the shared `specifications/<task-id>/ui-verification/figma-expected.png` reference before comparison, or reuse that shared file when the Figma URL/node is unchanged.
   - If Figma cannot be fetched or saved, report `VERIFICATION NOT RUN`.
3. Get ACTUAL from implementation through caller-provided `tsh-ui-capture-worker` CLI artifacts written into `specifications/<task-id>/ui-verification/iteration-<N>/`.
   - Required artifact set: `actual.png`, `computed-styles.json`, `a11y-snapshot.yml`.
   - If the caller did not provide the artifact directory or the artifact set is incomplete, return `VERIFICATION NOT RUN` and instruct the caller to run `tsh-ui-capture-worker` first for the same pinned URL.
4. Compare following the skill's verification categories and tolerances.
5. Generate a structured report following the output contract below.
6. If capture is blocked by auth redirect, missing confirmed URL, wrong page state, unreachable page, incomplete artifacts, or any other blocker, the immediate next action MUST be `vscode/askQuestions` before any further reply.
7. If `figma` MCP is unavailable, if the caller did not provide usable `tsh-ui-capture-worker` artifacts, or if this reviewer step itself was not actually delegated, the result MUST be `VERIFICATION NOT RUN` with blocker-resolution guidance.
8. Never return an empty response. Even when the flow is blocked before evidence collection, return the full blocker report skeleton with explicit unknowns marked as `UNKNOWN`.

Do not use browser navigation to figma.com, code inspection, compile/typecheck results, or caller-side reasoning as a substitute for the reviewer flow. EXPECTED must come from `figma`, ACTUAL must come from caller-provided `tsh-ui-capture-worker` artifacts, and the verdict must come from this reviewer.

The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.

**Enumerate ALL differences in a single pass.** Do not stop at the first critical finding. Complete every verification category (Structure, Layout, Dimensions, Visual, Components) and report every difference found. Never report `PASS` while any structure, layout, or >2px dimension difference remains.
</workflow>

<output-specification>
Return a Markdown report that always contains every section below in this order, even for `VERIFICATION NOT RUN`:

```markdown
## Verification Result: [PASS | FAIL | VERIFICATION NOT RUN]

### Component

[component or section name]

**Confidence:** [HIGH | MEDIUM | LOW]

### Sources

- Figma URL: [exact URL or UNKNOWN]
- Verified page URL: [exact full URL or UNKNOWN]

### Artifact Directory

- Path: [exact `specifications/.../iteration-<N>/` path or UNKNOWN]

### Artifact Status

| Artifact             | Status                    | Path or blocker          |
| -------------------- | ------------------------- | ------------------------ |
| figma-expected.png   | [present/missing/blocked] | [shared path or blocker] |
| actual.png           | [present/missing/blocked] | [path or blocker]        |
| computed-styles.json | [present/missing/blocked] | [path or blocker]        |
| a11y-snapshot.yml    | [present/missing/blocked] | [path or blocker]        |

### Differences

| Property         | Expected (Figma)    | Actual (Implementation) | Severity            |
| ---------------- | ------------------- | ----------------------- | ------------------- |
| [prop or `NONE`] | [expected or `N/A`] | [actual or `N/A`]       | [severity or `N/A`] |

### Blocker Resolution

- Blocker Type: [none or specific blocker]
- Blocking Step: [workflow step number or `NONE`]
- `vscode/askQuestions` used: [yes/no]
- Next Required Action: [specific next step]

### Recommended Fixes

- [specific fix]
```

Never omit `Verification Result`, `Component`, `Artifact Directory`, `Artifact Status`, or `Blocker Resolution`. If a value cannot be known, write `UNKNOWN` and explain why.
</output-specification>

<constraints>
- Missing or blocked capture must report `VERIFICATION NOT RUN` with blocker-resolution guidance.
- Do not ask for credentials, session details, or blocker-resolution input in plain assistant text before invoking `vscode/askQuestions`.
- Do not improvise a fallback verification in the caller.
</constraints>

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-review-ui:v1 -->
