> **PREREQUISITE**: This prompt extends [tsh-implement-common-task.prompt.md](./tsh-implement-common-task.prompt.md). You MUST read and follow **all steps** from that base workflow first. This prompt adds UI-specific behaviors on top — it does not remove or replace any base workflow steps.

Implement the UI feature according to the **research context** and **implementation plan**, using supplied Figma designs as the source of truth for visual implementation when applicable. The canonical orchestration route determines whether this is web UI or rendered React Native UI.

## Platform Contract

- **Web/Figma browser UI**: apply the Figma design and browser implementation contract below. The caller preserves the user-confirmed full browser URL and owns the capture-before-review verification loop.
- **Rendered React Native UI**: load `tsh-implementing-react-native` and apply its target-project profile gate. A browser URL and Playwright artifacts are not required for native verification. Browser screenshots, computed browser styles, and browser accessibility snapshots cannot prove native safe areas, navigation, touch or gesture behavior, device behavior, VoiceOver/TalkBack behavior, or native end-to-end behavior.
- Native simulator/device, accessibility, and end-to-end evidence is target-project-owned. If no explicit target-project evidence contract is supplied, report that as a prerequisite or limitation rather than claiming native verification.

## Required Skills

In addition to the skills required by the base workflow, load and follow these skills before starting when the route applies:

- `tsh-implementing-frontend` — for web component patterns, design system usage, composition, and platform-neutral performance guidelines
- `tsh-ensuring-accessibility` — for web WCAG 2.1 AA compliance, semantic HTML, ARIA, and browser accessibility verification
- `tsh-implementing-react-native` — for rendered React Native screens, components, navigation, layout, styling, gestures, animations, and accessibility-facing UI

---

## Web/Figma Design References from Research & Plan

For web/Figma-backed UI, always treat the **research** and **plan** files as the single source of truth for design links:

- Before starting implementation (during step 1–2 of the base workflow):
  - Open the **research file** (`research.md` in the same task specification directory as the associated `*.plan.md`, or a generic `*.research.md`) and look for:
    - Figma URLs in the `Relevant Links` section.
    - Any specific component/node links mentioned in `Gathered Information`.
  - Open the **plan file** (`*.plan.md`) and look for:
    - Figma URLs and design references in `Task details`.
    - If present, a structured "Design References" subsection mapping views/components to Figma URLs or node IDs.
- Use these Figma URLs as the **default source** for all `figma` calls during implementation.
- Before the first UI code edit for a Figma-backed component, resolve the exact relevant Figma node/view and inspect it through at least one real `figma/*` call. Finding the URL in the plan is not enough by itself; do not start writing UI code until that read has happened.

### When a web/Figma link is missing

If you cannot find a Figma URL for the component/section you are about to implement:

1. **Stop** — do not proceed with that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding with implementation
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT for web/Figma-backed UI:

- Skip implementation because the link is missing
- Guess what the design should look like
- Proceed with implementation without a Figma reference

For rendered React Native UI, use a supplied Figma reference as implementation design context when the plan provides one, but do not turn it into a browser URL or Playwright evidence requirement. If the plan requires design input that is missing, stop and resolve that missing input through the owning workflow rather than inventing it.

When you discover missing or updated design links during implementation, add them to the appropriate sections in the **plan** under `Task details` (and, if needed, note them in the Changelog).

---

## Additional Web/Figma Setup (before starting browser-backed implementation)

Before step 6 of the base workflow (starting implementation), ensure:

- The local development server is running.
- You can access the page you're implementing (authenticated if needed).
- You have identified all relevant Figma URLs from the research/plan files.
- You have already inspected the exact Figma node/view for the component you are about to implement through a real `figma/*` call.
- You understand the design system tokens and components available in the project.

For rendered React Native UI, inspect the target-project profile and follow its available native build, runtime, accessibility, and evidence prerequisites. Do not require a browser URL or browser capture artifacts for this route.

---

## UI Verification Boundary

**For web/Figma browser UI, UI verification against Figma is NOT your responsibility.** The `tsh-engineering-manager` handles the verify-fix loop by delegating to `tsh-ui-reviewer`. Focus only on implementing the UI according to the plan and design references. If you receive a verification report with issues to fix, apply the fixes and report back.

For rendered React Native UI, the caller must not present browser/Figma capture artifacts as native verification. Native evidence remains target-project-owned; when no target-project evidence contract is available, the caller records the explicit prerequisite or limitation.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-ui-common-task:v1 -->
