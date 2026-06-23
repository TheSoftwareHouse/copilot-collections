---
name: tsh-ui-verifying
description: UI verification criteria, structure checklists, severity definitions, and tolerance rules for comparing implementations against Figma designs. Use for verifying UI matches design, understanding what to check, and determining acceptable differences.
user-invocable: false
---

# UI Verification

Verification process, criteria, and tolerances for comparing UI implementations against Figma designs.

## Verification Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Validate inputs
- [ ] Step 2: Get EXPECTED from Figma
- [ ] Step 3: Get ACTUAL from implementation
- [ ] Step 4: Compare using verification categories
- [ ] Step 5: Generate report
```

**Step 1: Validate inputs**

Before starting verification, confirm:

- Figma URL is available for the component/section being verified
- Dev server URL is a **user-confirmed pinned session input**:
  - **Standalone verification without a caller-provided URL**: on the first verification in a session, ask the user to confirm the exact full dev server URL that should be used for verification. Do not infer it from project config, running processes, port scans, or other discovery.
  - **Delegated verification with a caller-provided user-confirmed URL**: use that exact full URL unchanged for the entire session. Do not rediscover it, normalize it, swap ports, inspect config to suggest another URL, or launch a different local app/server.
  - Once the user has confirmed the URL, every downstream verification and capture pass must treat it as pinned session state.
- Dev server is running and the **target page** is reachable through the CLI capture flow using that confirmed URL:
  - Use the CLI capture flow to open the page at the full target URL before verification begins
  - If the capture flow reports a **redirect to a login/authentication screen**: if the verifying agent has `vscode/askQuestions`, the immediate next action MUST be a `vscode/askQuestions` call such as: "The page redirected to [login URL]. How should I authenticate? Please provide credentials, a session token, or tell me how to bypass authentication for local development." Do not ask for credentials in plain assistant text first.
  - If the capture flow reports **unexpected content** (error page, blank page, different route): if the verifying agent has `vscode/askQuestions`, the immediate next action MUST be a `vscode/askQuestions` call such as: "The page at [URL] shows [description]. Is this the correct URL for [component name]?" Do not ask in plain assistant text first.
  - If the capture flow cannot find the expected component on the confirmed page: if the verifying agent has `vscode/askQuestions`, raise the blocker through that tool immediately rather than a freeform reply.
- If any input is missing or any blocker is encountered, stop and resolve it through `vscode/askQuestions` when that tool is available to the verifying agent — do not proceed, do not fall back to code-level review, and do not skip the verification step

**Step 2: Get EXPECTED from Figma**

Use `figma` to extract the design specifications:

- Layer hierarchy and component structure
- Layout direction, alignment, spacing
- Frame widths relative to page — these determine whether containers should be narrow/centered or full-width
- Typography, colors, radii, shadows
- Component variants and states

**Step 3: Get ACTUAL from implementation**

Use the `tsh-ui-capture-worker` capture flow to collect ACTUAL evidence from the running implementation. CLI capture is mechanical evidence collection only. The visual judge remains the reviewer brain comparing Figma EXPECTED against CLI ACTUAL using multimodal reasoning plus computed styles.

The capture worker must use only the caller-provided full URL for the current pass. It never discovers its own URL, never replaces the caller-provided URL, never inspects project config to pick another port, and never launches or switches to another local app/server. If the delegated task does not include the confirmed full URL, treat that as a blocker and return immediately.

You MUST collect **all three** ACTUAL evidence types — a verification that skips any type is incomplete:

1. **Structure & content** — element hierarchy, order, grouping via accessibility snapshot.
2. **Actual rendered dimensions** — computed widths, heights, paddings, margins, gaps, and other measured layout properties of every major container via JavaScript evaluation of computed styles. This is the most commonly missed step — without it you cannot detect sizing/layout differences.
3. **Visual appearance** — full-page screenshot for side-by-side comparison with the design.

If the three live-capture artifacts are not all present (`actual.png`, `computed-styles.json`, `a11y-snapshot.yml`), the verification is incomplete and invalid. Code reading is never a substitute for live capture.

### CLI-first capture flow

Use a named session and keep the flow explicit:

1. **Open named session** — `playwright-cli open -s <session-name>`.
2. **Resize to the Figma frame width** — `playwright-cli resize <figma-width> -s <session-name>`.
3. **Navigate to the full target URL** including query params — `playwright-cli goto <full-url> -s <session-name>`.
4. **Stabilize render** before collecting evidence:
   - `playwright-cli run-code -s <session-name> "async page => { await page.emulateMedia({ reducedMotion: 'reduce' }); await page.waitForLoadState('networkidle'); }"`
   - Add route mocks only when the task explicitly requires deterministic mocked data.
   - Mask dynamic regions when unavoidable so transient timestamps, avatars, ads, or animations do not dominate the evidence.
5. **Capture screenshot**:
   - Preferred: `playwright-cli screenshot --filename actual.png -s <session-name>` when the CLI invocation supports `fullPage: true` for the current environment.
   - Required fallback: `playwright-cli run-code -s <session-name> "async page => { await page.screenshot({ path: 'actual.png', fullPage: true }); }"`.
6. **Capture accessibility snapshot** — `playwright-cli --raw snapshot -s <session-name> > a11y-snapshot.yml`.
7. **Capture computed styles and measurements** — `playwright-cli --raw eval -s <session-name> "JSON.stringify(...)" > computed-styles.json`.
8. **Clean up** — `playwright-cli close -s <session-name>` or equivalent session cleanup if the capture flow aborts.

The `JSON.stringify(...)` payload should cover the major containers and controls being verified: bounding boxes, computed width/height, max-width, min-height, padding, margin, gap, alignment-relevant properties, and any targeted style values needed to explain differences.

> **CRITICAL**: The accessibility tree does NOT contain CSS dimensions. A full-width container and a narrow centered container produce identical accessibility trees. If you only collected structure without measuring actual rendered dimensions, your verification is INVALID — mark confidence as LOW and report what's missing.

### Render stabilization rules

- Wait for `networkidle` before capture.
- Emulate reduced motion before taking evidence.
- Use optional route mocks only to remove nondeterministic backend data, not to hide real UI defects.
- Mask dynamic regions when they are known noise sources.
- Different image heights or dimensions between Figma and the implementation are evidence for the reviewer brain; they are NOT hard failures that abort the loop.

### Artifact directory contract

Store each verification pass under:

```text
specifications/<task-id>/ui-verification/iteration-<N>/
  actual.png
  computed-styles.json
  a11y-snapshot.yml
  figma-expected.png
  pixel-gate/               # optional, phase 2 only
    report.json
    exit-code.txt
    *-diff.png
  report.md
```

Required files for the core flow are `actual.png`, `computed-styles.json`, `a11y-snapshot.yml`, `figma-expected.png`, and `report.md`. `pixel-gate/` is optional and only exists when the phase-2 tripwire runs.

### Exit codes and escalation rules

- `playwright-cli open` or `playwright-cli goto` non-zero: escalate immediately instead of silently continuing.
- Redirect to login, auth wall, or unexpected page content: escalate immediately instead of silently continuing.
- Missing component at the confirmed URL: escalate immediately.
- Session cleanup failures: note them in the report, then attempt explicit cleanup.
- Phase-2 tripwire exit `0`: evidence that the render is within the loose screenshot threshold; not the final verdict.
- Phase-2 tripwire exit `1`: evidence of visual difference; not the final verdict.

If open/goto/auth fails, if the page state is wrong, or if required artifacts are missing/incomplete, stop the capture flow and raise clarification through `vscode/askQuestions` when that tool is available to the verifying agent. Do not use a plain-text blocker request as a substitute. These are **pre-verification blockers**. Report the verification result as `VERIFICATION NOT RUN`, include blocker-resolution guidance, and rerun on fresh artifacts after the blocker is resolved. They do not consume any post-fix iteration budget and do not enter the post-5-iteration escalation gate. Do not substitute code reading for verification.

**Step 4: Compare using verification categories**

Compare EXPECTED (Figma) against ACTUAL (implementation) following the Verification Order and Categories below. The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.

**IMPORTANT**: Complete ALL verification categories in a single pass. Do not stop after finding differences in one category — continue through every category and collect every difference. The report must contain ALL differences found across all categories so the engineer can fix them all at once, minimizing verification iterations.

**Step 5: Generate report**

Produce a structured report following the Report Format below. Include exact values from both Figma and implementation for every difference found.

### Optional phase-2 tripwire: `toHaveScreenshot`

Use this only as a non-blocking signal layer after the core CLI-first capture exists.

- Baseline source: the Figma PNG export is the baseline, not a self-generated app screenshot.
- Run through the Playwright test runner, for example: `PLAYWRIGHT_HTML_OPEN=never npx playwright test --reporter=json`.
- Use `toHaveScreenshot` with a loose threshold such as `maxDiffPixelRatio`, `fullPage: true`, and masks for known dynamic regions.
- Save the runner JSON output and diff artifacts under `pixel-gate/`.
- Tripwire exit `0` or `1` is evidence for the reviewer brain. It never replaces the multimodal comparison and computed-style review.
- If dimensions differ and the screenshot assertion fails for that reason, keep the artifacts and continue the review loop. That size mismatch is itself evidence.

## Verification Order

Always verify in this order — **complete ALL categories regardless of findings**. Do not stop after finding differences in one category. The goal is to catch every difference in a single pass so all fixes can be applied at once.

1. **Structure** (CRITICAL)
2. **Layout** (CRITICAL)
3. **Dimensions** (CRITICAL)
4. **Visual** (CRITICAL)
5. **Components**

## Verification Categories

### Structure (CRITICAL)

| Check                   | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| **Container hierarchy** | Does DOM structure match Figma's layer hierarchy?        |
| **Nesting depth**       | Are elements nested at the same level as in Figma?       |
| **Grouping**            | Are related elements grouped together as in design?      |
| **Element order**       | Is the visual order of elements the same?                |
| **Wrapper elements**    | Are there extra/missing wrapper divs that change layout? |
| **Sections present**    | Are ALL sections from Figma present in implementation?   |

### Layout (CRITICAL)

| Check                   | Description                                        |
| ----------------------- | -------------------------------------------------- |
| **Flex/Grid direction** | row vs column, wrap behavior                       |
| **Alignment**           | justify-content, align-items values                |
| **Distribution**        | How space is distributed between elements          |
| **Positioning**         | relative, absolute, fixed - matches design intent? |
| **Centering**           | Is content centered as in design?                  |

### Dimensions (CRITICAL)

| Check                        | Description                                  |
| ---------------------------- | -------------------------------------------- |
| **Container width**          | max-width, fixed width constraints           |
| **Card/panel boundaries**    | Does card have same width as in Figma?       |
| **Content area vs viewport** | Ratio of content width to available space    |
| **Width/Height**             | Fixed, percentage, auto, min/max constraints |
| **Spacing**                  | Padding, margin, gap between elements        |
| **Gaps**                     | Space between flex/grid children             |

> **WARNING**: Accessibility tree does NOT contain CSS dimensions. A full-width container and a narrow centered one look identical in it. You must measure actual computed styles to detect width/sizing differences.

### Visual

| Check           | Description                                            |
| --------------- | ------------------------------------------------------ |
| **Typography**  | font-family, size, weight, line-height, letter-spacing |
| **Colors**      | Text, background, border colors                        |
| **Radii**       | border-radius values                                   |
| **Shadows**     | box-shadow, drop-shadow                                |
| **Backgrounds** | Solid, gradient, image                                 |

### Components

| Check                | Description                                     |
| -------------------- | ----------------------------------------------- |
| **Correct variants** | Is the right variant of a component used?       |
| **Design tokens**    | Are correct tokens used (not hardcoded values)? |
| **States**           | hover, focus, active, disabled states           |

## Tolerances

| Category         | Tolerance       | Notes                                |
| ---------------- | --------------- | ------------------------------------ |
| Structure        | **None**        | Any structural difference = FAIL     |
| Layout direction | **None**        | row vs column must match exactly     |
| Alignment        | **None**        | Centering, justify, align must match |
| Dimensions       | **1-2px**       | Only for browser rendering variance  |
| Colors           | **Exact match** | Must use correct design tokens       |
| Typography       | **Exact match** | Font properties must match           |
| Spacing          | **1-2px**       | Only for browser rendering variance  |

## Severity Definitions

| Severity     | Description                                        | Action                            |
| ------------ | -------------------------------------------------- | --------------------------------- |
| **Critical** | Structure/layout differences, wrong component used | Must fix immediately              |
| **Major**    | Dimensions off by >2px, wrong colors/typography    | Must fix before merge             |
| **Minor**    | 1-2px browser rendering variance                   | Acceptable, document if recurring |

### Content/data clarification gate

If structure, layout, dimensions, visual styling, and component usage are otherwise acceptable, and the remaining differences are limited to content/data that may plausibly vary by environment, seed data, locale, or user state, do not treat them as automatic UI defects.

In that branch:

1. Summarize the remaining content/data differences clearly.
2. Ask the user whether those values are intentionally environment-specific or whether the UI should match Figma exactly.
3. Keep the PASS/FAIL report format. Until the user confirms those values may differ, keep the overall result as `FAIL` and represent the items under `Clarification Needed` rather than as automatic fix items.
4. Only convert them into actionable fixes after the user confirms they should be corrected.

If the content/data mismatch also changes structure, layout, or visual fidelity in a real way, report that underlying UI defect normally.

## Verification Checklist

Before reporting PASS:

- [ ] Verified ENTIRE page (scrolled from top to bottom)
- [ ] All sections from Figma are present in implementation
- [ ] Container hierarchy matches Figma layers
- [ ] Flex/grid direction is correct
- [ ] Alignment (justify/align) matches design
- [ ] Element order matches design
- [ ] No extra/missing wrapper elements that change layout
- [ ] Actual computed container widths measured (not inferred from accessibility tree)
- [ ] Full-page screenshot taken and visually compared against Figma

## Report Format

```markdown
## Verification Result: [PASS | FAIL | VERIFICATION NOT RUN]

### Component: [name]

**Confidence:** [HIGH | MEDIUM | LOW]

### Differences

| Property | Expected (Figma) | Actual (Implementation) | Severity   |
| -------- | ---------------- | ----------------------- | ---------- |
| [prop]   | [expected]       | [actual]                | [severity] |

> **List ALL differences found across ALL verification categories.** Do not omit lower-severity items when critical ones exist. The engineer needs the complete list to fix everything in one iteration.

### Clarification Needed

- [content/data differences that may be intentional]
- [question asking whether the observed values should remain or match Figma exactly]

> When this section is used, keep `## Verification Result` as `FAIL` until the user confirms the content/data/state differences are acceptable, and do not promote them to `Recommended Fixes` before that confirmation.

### Recommended Fixes

- [specific fix with exact values]
```

Use `VERIFICATION NOT RUN` only when capture is missing or blocked. It is not a pass, not a clean fail, and must never be treated as a gate pass. The required action is to obtain the live-capture artifacts or escalate the blocker, then rerun verification on fresh artifacts.

`VERIFICATION NOT RUN` is a pre-verification blocker state. It is distinct from the post-5-iteration gate used for genuine exhausted verify-fix loops.

### Re-verify After Fix

After any fix prompted by a verification finding, discard stale artifacts, collect a fresh capture, and run a fresh verification pass on the new artifacts before deciding PASS or FAIL. Never reuse pre-fix evidence or assume the fix worked.

**Confidence levels:**

- **HIGH** — Both Figma and implementation data complete, comparison is reliable
- **MEDIUM** — Some values couldn't be extracted, manual review recommended
- **LOW** — Tool errors occurred, manual verification required before making changes

When content/data differences are the only remaining gaps and may be intentional, ask for user confirmation before escalating them as defects. Keep the report in the normal PASS/FAIL format and treat the result as `FAIL` pending clarification.

## Connected Skills

- `tsh-implementing-frontend` - for implementing fixes following design system patterns
- `tsh-technical-context-discovering` - for understanding project's design token conventions
