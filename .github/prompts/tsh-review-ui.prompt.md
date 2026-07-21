---
agent: "tsh-ui-reviewer"
model: "Gemini 3.1 Pro (Preview)"
description: "Single-pass web UI verification: compare a browser implementation against Figma and report differences."
argument-hint: "[web/Figma URL or pinned node link] [exact full browser URL] [component/section name] [optional task-id or artifact directory]"
---

<goal>
Perform exactly one web/Figma browser verification pass comparing the current browser implementation against the Figma design. Report all differences found and never fix code in this workflow. This prompt does not provide native React Native verification.

<platform-boundary>
- This prompt supports web-compatible Figma verification using a user-confirmed browser URL and the caller-provided browser capture artifacts.
- For rendered React Native UI, do not require a browser URL or Playwright artifacts and do not present browser artifacts as proof of native safe areas, navigation, touch or gesture behavior, device behavior, VoiceOver/TalkBack behavior, or native end-to-end behavior.
- Native simulator/device, accessibility, and end-to-end evidence is target-project-owned. When no explicit target-project evidence contract is supplied, represent native verification as `VERIFICATION NOT RUN` with an explicit target-project prerequisite or limitation; do not claim a native PASS from this prompt.
</platform-boundary>

This prompt can run standalone or as the delegated reviewer step from `/tsh-implement`, but in both modes it must return an explicit, non-empty verdict. An empty response is invalid.
</goal>

<prerequisites>
- This web verification step is delegate-only. If the caller cannot actually invoke `tsh-ui-reviewer` with its required tools (`figma`), or cannot provide fresh `tsh-ui-capture-worker` artifacts for the current pass, the step is blocked and must return `VERIFICATION NOT RUN`.
- The caller must not try to perform UI verification itself as a fallback.
- For web/Figma browser work, the caller must run `tsh-ui-capture-worker` first for the current pass and provide the resulting artifact directory to this reviewer. This ordering does not apply to native React Native work because this prompt is not a native verifier.
</prerequisites>

<input-requirements>
- For web/Figma browser verification: Figma URL or pinned Figma node link for the exact component or section; a user-confirmed exact full browser URL; the component or section name; and, for delegated verification, a task ID and iteration number or an explicit artifact directory containing `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` for this pass.
- If the caller supplies a user-confirmed browser URL, use that exact URL unchanged. If no browser URL is supplied in a standalone web run, confirm one with the user before capture.
- For rendered React Native UI: do not request a browser URL or browser artifact directory. If this prompt is invoked despite the native boundary, return `VERIFICATION NOT RUN` and identify the target-project native evidence contract as the required prerequisite when none is supplied.
</input-requirements>

<required-skills>
Before starting, load and follow these skills:

- `tsh-ui-verifying` - verification process, criteria, tolerances, severity definitions, report format
  </required-skills>

<workflow>
Follow the 5-step verification process defined in the `tsh-ui-verifying` skill. The skill contains the complete workflow. For this prompt, enforce these additional rules:

1. Validate inputs first for web/Figma browser work: Figma URL, user-confirmed full browser URL, component name, and artifact-directory context. If the supplied implementation is rendered React Native UI, stop this browser workflow and return the native limitation described in `<platform-boundary>`; do not ask for browser inputs.
2. Get EXPECTED from Figma via `figma`.
   - MANDATORY: export the node image and save it as the shared `specifications/<task-id>/ui-verification/figma-expected.png` reference before comparison, or reuse that shared file when the Figma URL/node is unchanged.
   - If Figma cannot be fetched or saved, report `VERIFICATION NOT RUN`.
3. Get ACTUAL from a web implementation through caller-provided `tsh-ui-capture-worker` CLI artifacts written into `specifications/<task-id>/ui-verification/iteration-<N>/`.
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

For a native React Native limitation report, retain the same report headings but set `Verification Result` to `VERIFICATION NOT RUN`, mark the browser artifacts as `not-applicable`, set the browser URL and artifact directory to `UNKNOWN` or `not-applicable`, and state in `Blocker Resolution` that native evidence is target-project-owned and the missing evidence contract is the next prerequisite. Do not use this report to imply that browser evidence verifies native behavior.
</output-specification>

<constraints>
- Missing or blocked capture must report `VERIFICATION NOT RUN` with blocker-resolution guidance.
- Do not ask for credentials, session details, or blocker-resolution input in plain assistant text before invoking `vscode/askQuestions`.
- Do not improvise a fallback verification in the caller.
- This prompt's URL, Figma, and artifact requirements apply only to web-compatible browser verification; native React Native verification remains outside this collection-owned contract.
</constraints>

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-review-ui:v1 -->
