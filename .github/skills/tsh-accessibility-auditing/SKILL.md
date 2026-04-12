---
name: tsh-accessibility-auditing
description: "WCAG 2.2 Level AA accessibility auditing using POUR methodology, automated tools, and manual testing checklists. Generates technical audit reports and business-facing summaries. Use when conducting accessibility audits on URLs or codebases, producing audit reports, generating business summaries, or checking WCAG compliance."
---

# Accessibility Auditing

Conducts WCAG 2.2 Level AA accessibility audits using a hybrid approach of automated tools and manual testing, following the POUR (Perceivable, Operable, Understandable, Robust) methodology.

## Knowledge Base & Standards

Audits are strictly based on:
1. **W3C WCAG 2.2 Guidelines** (https://www.w3.org/WAI/standards-guidelines/wcag/)
2. **Polska Ustawa o dostępności cyfrowej** (https://orka.sejm.gov.pl/proc10.nsf/ustawy/241_u.html)
3. **LepszyWeb WCAG Guide** (https://wcag.lepszyweb.pl/)

**IMPORTANT**: WCAG 2.2 removed SC 4.1.1 Parsing. Do not report 4.1.1 violations.

## Audit Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Detect audit mode
- [ ] Step 2: Run automated tools
- [ ] Step 3: Perform manual testing
- [ ] Step 4: Check WCAG 2.2 new criteria
- [ ] Step 5: Classify and de-duplicate findings
- [ ] Step 6: Generate audit report
```

**Step 1: Detect audit mode**

Determine the audit type:
- **External Audit** (URL provided, no code access): Use `execute` tool to run CLI tools against the URL. Fetch page HTML for manual analysis.
- **Internal Audit** (codebase access): Use `read` and `search` tools to inspect source files. Run CLI tools against local dev server if available.

**Step 2: Run automated tools**

Run at least 2-3 tools for comprehensive coverage. See `./references/automated-tools.md` for the full tool list and usage commands.

Minimum automated checks:
```bash
pa11y <url> --reporter cli --standard WCAG2AA
axe <url> --tags wcag2a,wcag2aa
lighthouse <url> --only-categories=accessibility --output=cli --chrome-flags="--headless --no-sandbox"
```

If tools are not installed, run: `npm install -g pa11y @axe-core/cli lighthouse html-validate accessibility-checker`

**Step 3: Perform manual testing**

Automated tools miss 60-70% of accessibility issues. Supplement with manual checks:

### Keyboard Navigation
- Tab through the entire page — every interactive element must be reachable
- Focus order must follow visual/reading flow
- Focus indicator must always be visible
- Modals must be closable with Escape and trap focus internally
- No keyboard traps — user can always move forward and backward
- Skip-to-main-content link must be present and functional

### Screen Reader
- All images have appropriate alt text (informative or `alt=""` for decorative)
- Form fields have accessible names (visible labels or `aria-label`)
- Dynamic content changes are announced (`aria-live`, `role="alert"`)
- Landmark regions present (`<main>`, `<nav>`, `<header>`, `<footer>`)
- Links and buttons have discernible text

### Visual & Cognitive
- Text contrast ratio ≥ 4.5:1 (normal text) and ≥ 3:1 (large text)
- Non-text UI contrast ≥ 3:1 (borders, icons, focus rings)
- Page usable at 200% and 400% zoom without horizontal scrolling
- No content conveyed by color alone
- Animations respect `prefers-reduced-motion`

**Step 4: Check WCAG 2.2 new criteria**

Explicitly verify all WCAG 2.2 new success criteria. See `./references/wcag22-new-criteria.md` for the full table with check instructions.

Key checks:
- **SC 2.4.11** Focus Not Obscured — keyboard focus not hidden by sticky headers/footers/banners
- **SC 2.5.7** Dragging Movements — all drag-and-drop has single-pointer alternatives
- **SC 2.5.8** Target Size (Minimum) — interactive targets ≥ 24×24 CSS px
- **SC 3.3.7** Redundant Entry — previously entered info is auto-populated
- **SC 3.3.8** Accessible Authentication — no cognitive function tests for login

**Step 5: Classify and de-duplicate findings**

Use the severity matrix to rate every issue:

| Severity | Definition | User Impact |
|----------|-----------|-------------|
| 🔴 **Critical** | Blocks access entirely — users cannot complete a task | Prevents task completion for AT users |
| 🟠 **Serious** | Causes significant difficulty with major workarounds | Degrades experience severely |
| 🟡 **Moderate** | Creates inconvenience — sub-optimal experience | Slows users or causes confusion |
| 🔵 **Minor** | Small deviation — minimal user impact | Cosmetic or minor annoyance |

> **Note**: Severity levels follow accessibility auditing conventions (aligned with axe-core). For functional bug severity, see `tsh-functional-testing`'s severity matrix which uses Critical/High/Medium/Low.

When in doubt, classify **up** (more severe). De-duplicate findings across tools — report each unique issue once, noting which tools detected it.

**Step 6: Generate audit report**

Generate the technical audit report using the template at `./audit-report.example.md`.

For interactive component patterns (modals, tabs, accordions, carousels, etc.), reference `./references/interactive-components.md`.

## Business Summary Mode

When the user writes any of: `audit summary`, `create audit summary`, `/audit-summary`, `/create-audit-summary` — generate a business-facing report using the template at `./business-summary.example.md`.

## Multi-Page Audit Strategy

For sites with more than one page:
1. **Always audit**: Homepage, login/registration, contact page, main conversion page
2. **Template sampling**: Identify unique page templates, audit one representative per template
3. **Process flows**: Audit complete user journeys end-to-end
4. **Document scope**: Explicitly list which pages were audited and which were excluded
5. **Prioritize high-traffic pages** if analytics data is available

For internal audits, also identify **shared components** (header, footer, navigation, form components) — fixing these once fixes them everywhere.

## WCAG Naming Precision

For every guideline and success criterion in any report:
- Use the exact official wording from WCAG 2.2: https://www.w3.org/TR/WCAG22/
- Do not paraphrase, shorten, translate, or alter punctuation/capitalization
- Required format: `1.1.1 Non-text Content`, `2.4.7 Focus Visible`

## Contrast Checking Reference

| Element Type | Minimum Ratio | SC |
|---|---|---|
| Normal text (< 18pt / < 14pt bold) | 4.5:1 | 1.4.3 Contrast (Minimum) |
| Large text (≥ 18pt / ≥ 14pt bold) | 3:1 | 1.4.3 Contrast (Minimum) |
| UI components & graphical objects | 3:1 | 1.4.11 Non-text Contrast |
| Focus indicators | 3:1 against adjacent colors | 2.4.7 Focus Visible |
| Enhanced contrast (AAA) | 7:1 / 4.5:1 | 1.4.6 Contrast (Enhanced) |

## Codebase Search Patterns (Internal Audits)

Run these searches automatically during internal audits:
- Missing alt: `img` tags without `alt` attribute
- Unlabeled inputs: `input` without associated `label` or `aria-label`
- Empty buttons/links: `button` or anchor tags with no text content
- Missing lang: `html` tag without `lang` attribute
- Positive tabindex: `tabindex` values > 0
- Outline removal: CSS `outline: none` or `outline: 0` without replacement focus style
- Target size: small clickable icons with width/height < 24px
- Inaccessible SVGs: inline `<svg>` without `role="img"` + `aria-label` or `<title>`

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/audit <url>` | Run external audit on a URL |
| `/audit` | Run internal audit on current file/project |
| `/tools` | Recommend tools for a specific accessibility feature |
| `/audit-summary` | Create business-facing audit summary |
| `/checklist` | Print the full manual testing checklist |
| `/wcag22-new` | List all WCAG 2.2 new success criteria with checks |

## Interaction Rules (askQuestions)

Use `vscode/askQuestions` to resolve ambiguities before and during the audit. Follow these global rules for every question:

| Rule | Detail |
|------|--------|
| **One question per call** | Focus on the most critical ambiguity first |
| **Confidence threshold** | Ask when confidence in a finding's severity or an element's purpose is < 80% |
| **WCAG SC in header** | During-audit questions must include the SC number, e.g., `[SC 1.1.1]` |
| **Handling skips** | If the user skips or dismisses, mark the finding as **"Needs Manual Verification"** in the final report |
| **No repeated questions** | If the user answered a pattern-level question (e.g., "all images on this page are decorative"), apply the answer to all matching elements |
| **Batch similar findings** | If 5+ elements share the same issue type, ask once about the pattern rather than per-element |

### Pre-Audit — Scope & Configuration

Ask these **before** the audit begins to establish baseline parameters.

**Q1 — Audit Scope**
- **Header**: `Audit Scope`
- **Question**: "What is the scope of this audit?"
- **Options**:
  - `Full site` — "Audit all unique page templates and key user journeys"
  - `Specific pages` *(recommended)* — "Audit only the pages I specify"
  - `Single component` — "Audit a single component or widget in isolation"
- **When to ask**: Always, unless the user already specified a URL or file path with clear scope.

**Q2 — Compliance Level**
- **Header**: `WCAG Compliance Target`
- **Question**: "Which WCAG 2.2 conformance level should this audit target?"
- **Options**:
  - `Level A` — "Minimum — essential accessibility"
  - `Level AA` *(recommended)* — "Standard — recommended for most projects"
  - `Level AAA` — "Enhanced — highest conformance, often partially applied"
- **When to ask**: Always, unless the user explicitly stated the target level.

**Q3 — Priority Focus Areas**
- **Header**: `Priority Focus`
- **Question**: "Are there specific areas you want prioritized in this audit?"
- **multiSelect**: true
- **Options**:
  - `Forms & inputs` — "Login, registration, checkout, contact forms"
  - `Navigation & wayfinding` — "Menus, breadcrumbs, skip links, search"
  - `Media content` — "Images, video, audio, animations"
  - `Interactive widgets` — "Modals, tabs, accordions, carousels, drag-and-drop"
  - `All areas equally` *(recommended)* — "No specific priority"
- **When to ask**: For multi-page or full-site audits where prioritization helps allocate effort.

### Pre-Manual-Testing — Testing Approach

Ask after automated tools complete, before manual testing begins.

**Q4 — Manual Testing Method**
- **Header**: `Manual Testing Approach`
- **Question**: "How should manual accessibility testing be performed?"
- **Options**:
  - `Automated with Playwright` *(recommended)* — "Run Playwright scripts for keyboard nav, focus order, and screen reader simulation"
  - `Manual by me` — "Provide a step-by-step checklist and I'll test manually"
  - `Hybrid` — "Run Playwright for what can be automated, give me a checklist for the rest"
- **When to ask**: Always at the start of Step 3 (manual testing).
- **Follow-up behavior**:
  - If `Automated with Playwright` or `Hybrid`: generate Playwright test scripts targeting the audit URL.
  - If `Manual by me` or `Hybrid`: generate a printable manual testing checklist with pass/fail columns.

### During-Audit — Clarifications

Ask these **during** the audit when the agent encounters ambiguity. One question per call, most critical ambiguity first.

**Q5 — Image Purpose**
- **Header**: `[SC 1.1.1] Image Purpose`
- **Question**: "Is this image purely decorative or does it convey information? [image description/path]"
- **Options**:
  - `Decorative` — "Use empty alt=\"\", no information lost if hidden"
  - `Informative` — "Needs descriptive alt text conveying its meaning"
  - `Functional` — "It's a link/button — alt text should describe the action"
  - `Complex` — "Chart, diagram, or infographic — needs long description"
- **When to ask**: When confidence in image purpose is < 80%.

**Q6 — Link/Button Purpose**
- **Header**: `[SC 2.4.4] Link Purpose`
- **Question**: "What is the purpose of this link/button with text '[text]'? The surrounding context doesn't clarify it."
- **allowFreeformInput**: true
- **Options**:
  - `Navigation` — "Takes user to another page/section"
  - `Action` — "Triggers an operation (submit, delete, toggle)"
  - `Download` — "Initiates a file download"
  - `External` — "Opens a third-party site"
- **When to ask**: When link/button text is ambiguous (e.g., "Click here", "Read more", icon-only buttons without labels).

**Q7 — Custom Widget Keyboard Behavior**
- **Header**: `[SC 2.1.1] Custom Widget Keyboard`
- **Question**: "This custom [component type] has non-standard keyboard handling. What keys should activate/navigate it?"
- **allowFreeformInput**: true
- **Options**:
  - `Standard ARIA pattern` *(recommended)* — "Follow WAI-ARIA Authoring Practices for this widget role"
  - `Let me describe` — "I'll specify the expected keyboard interaction"
  - `Skip — verify manually` — "Mark as Needs Manual Verification"
- **When to ask**: When code reveals custom `onKeyDown`/`onKeyPress` handlers on non-native interactive elements.

**Q8 — Dynamic Content Purpose**
- **Header**: `[SC 4.1.3] Status Messages`
- **Question**: "This dynamic content update [description] — should it be announced to screen readers?"
- **Options**:
  - `Yes — status message` — "Needs aria-live or role=status/alert"
  - `Yes — error/warning` — "Needs role=alert for immediate announcement"
  - `No — background update` — "Silent update, no announcement needed"
  - `Unsure` — "Mark as Needs Manual Verification"
- **When to ask**: When dynamic DOM changes are detected but no `aria-live` region or status role is present.

**Q9 — Video/Audio Content Type**
- **Header**: `[SC 1.2.1] Media Content Type`
- **Question**: "What type of content does this media element contain?"
- **Options**:
  - `Pre-recorded with speech` — "Needs captions and transcript"
  - `Pre-recorded — visual only` — "Needs audio description or text alternative"
  - `Live stream` — "Needs live captions"
  - `Decorative/ambient` — "Background music/video, no informational content"
- **When to ask**: When `<video>` or `<audio>` elements are found without `<track>` elements or transcript links.

### Finding Classification — Severity & Verification

Ask during Step 5 (classification) when the agent needs human judgment.

**Q10 — Severity Confirmation**
- **Header**: `[SC X.X.X] Severity Confirmation`
- **Question**: "I found [issue description]. How severe is the impact on users?"
- **Options**:
  - `Critical` — "Completely blocks task completion for assistive tech users"
  - `Serious` — "Significant difficulty, major workarounds required"
  - `Moderate` *(recommended — agent's best guess)* — "Inconvenient but usable"
  - `Minor` — "Cosmetic, minimal user impact"
  - `Not an issue` — "False positive, dismiss this finding"
- **When to ask**: When the agent's severity confidence is below 80%, or when the issue is context-dependent.

**Q11 — Finding Verification**
- **Header**: `[SC X.X.X] Finding Verification`
- **Question**: "Can you verify this finding? [description with element reference]"
- **Options**:
  - `Pass` — "This element is accessible as implemented"
  - `Fail` — "Confirmed — this is a genuine accessibility issue"
  - `Needs Manual Verification` — "Can't confirm without hands-on testing"
- **When to ask**: For issues that require visual or interaction verification the agent cannot fully simulate.

### Post-Audit — Report Delivery

Ask after all findings are collected, before report generation.

**Q12 — Remediation Guidance Depth**
- **Header**: `Remediation Detail Level`
- **Question**: "How detailed should the fix recommendations be?"
- **Options**:
  - `Code fixes` *(recommended)* — "Provide corrected code snippets for each finding"
  - `Guidance only` — "Describe what to fix conceptually, no code"
  - `Quick wins first` — "Prioritize easy fixes, then detail complex ones"
- **When to ask**: For audits with 10+ findings, to tailor the report output.

## Connected Skills

- `tsh-functional-testing` — for test planning, edge-case detection, and regression analysis that complement accessibility audits
- `tsh-ensuring-accessibility` — for implementation-time WCAG 2.2 AA patterns (this skill audits existing implementations; that skill builds accessible components from scratch)
- `tsh-e2e-testing` — for automated accessibility checks integrated into e2e test suites
