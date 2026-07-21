---
sidebar_position: 32
title: React Native Implementation
---

# React Native Implementation

**Folder:** `.github/skills/tsh-implementing-react-native/`<br />
**Authority:** `.github/skills/tsh-implementing-react-native/SKILL.md`<br />
**Used by:** UI Engineer for rendered React Native UI; the existing non-UI route for business logic and other non-rendered work

This page is a curated summary. The source skill is the authority for React Native component design, platform-specific code, navigation, gestures, animations, and performance guidance.

## Profile-Driven Guidance

Before applying framework, router, package, version, or API guidance, inspect the target project's profile: Expo managed, Expo prebuild/dev client, or bare React Native; React Native, React, and Expo SDK versions when applicable; router and version; JavaScript engine; New Architecture setting; installed packages; native directories; package manager; and available build, test, capture, and verification tooling.

Use that profile and the relevant official compatibility documentation as the authority. Expo guidance is conditional, not a universal default. Preserve the target project's existing router and conventions, and do not add a package or assume an API without a compatibility check.

## UI Ownership

The UI Engineer owns rendered React Native screens, components, navigation, layout, styling, gestures, animations, and accessibility-facing UI, using this skill for RN guidance. React Native business logic, state, data, services, integrations, native modules, and other non-rendered work remain on the existing non-UI route.

Route and layout files follow the selected router's required export contract. Ordinary React Native components retain the named-export convention. Do not apply an ordinary-component export rule to a route or layout without checking the selected router and installed version.

## Measurement-First Performance

Record a baseline, representative workload, target profile, and success threshold before optimizing. Choose list implementations, FlatList tuning, memoization, image libraries, lazy loading, bundle analysis, engine settings, or animation libraries only when the measurement identifies a need and the exact target versions and tooling are compatible. Re-measure the same workload after each material change; retain the simpler fallback when it is sufficient or the measured benefit does not justify the added dependency or complexity.

See the source references for the detailed decision rules:

- `.github/skills/tsh-implementing-react-native/references/react-native-patterns.md`
- `.github/skills/tsh-implementing-react-native/references/react-native-navigation.md`
- `.github/skills/tsh-implementing-react-native/references/react-native-performance.md`

## Verification Boundary

Collection-supported browser and Figma verification applies only to web-compatible artifacts and workflows. Browser URLs, Playwright results, screenshots, and accessibility snapshots do not verify native React Native behavior. Native simulator or device builds, native accessibility checks, and native end-to-end evidence are owned by the target project when its tooling provides them; this collection does not claim to execute them.

:::warning Never Guess — Always Ask
If a design specification is unclear, a token is missing, or behavior is ambiguous, stop and ask. Do not guess or make assumptions about design intent.
:::
