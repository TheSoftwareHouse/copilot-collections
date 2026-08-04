---
name: tsh-review-ui
description: "Single-pass UI verification: compare implementation against Figma and report differences."
user-invocable: true
argument-hint: "[Figma URL or pinned node link] [exact full dev server URL] [component/section name] [optional task-id or artifact directory]"
---
<routing>Run this workflow through the designated agent: `tsh-ui-reviewer`.</routing>

Perform exactly one UI verification pass against Figma. The reviewer consumes Figma EXPECTED data and fresh `tsh-ui-capture-worker` ACTUAL artifacts; it never fixes code.

<required-skills>
- `tsh-ui-verifying` - verification process, criteria, tolerances, severity, and report format.
</required-skills>

<workflow>
1. Validate the Figma URL, pinned full dev-server URL, component name, task context, and artifact directory.
2. Obtain or reuse the shared Figma expected image through `figma` and require `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` from capture.
3. Compare structure, layout, dimensions, visual styling, and components in one pass.
4. Return the complete structured report with PASS, FAIL, or VERIFICATION NOT RUN and blocker guidance.
</workflow>

<constraints>Do not use code reading, browser inspection, or compile results as a substitute for Figma plus live-capture evidence. Never fix implementation code.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-review-ui:v1 -->
