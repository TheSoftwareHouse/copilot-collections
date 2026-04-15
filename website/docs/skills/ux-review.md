---
sidebar_position: 13
title: UX Review
---

# UX Review

**Folder:** `.github/skills/tsh-ux-reviewing/`  
**Used by:** Product Designer

Performs structured UX reviews of Figma designs by checking them against established UX laws and usability heuristics. Produces actionable findings categorized by severity.

## Review Framework

The skill evaluates designs against two frameworks:

### Laws of UX (13 laws)

| Law                            | What to Check                                                 |
| ------------------------------ | ------------------------------------------------------------- |
| **Hick's Law**                 | Too many choices? Progressive disclosure used?                |
| **Fitts's Law**                | Interactive elements large enough? Primary actions reachable? |
| **Jakob's Law**                | Follows platform conventions users already know?              |
| **Miller's Law**               | Information grouped in digestible chunks (5-9 items)?         |
| **Law of Proximity**           | Related elements grouped spatially?                           |
| **Law of Similarity**          | Similar elements have consistent visual treatment?            |
| **Aesthetic-Usability Effect** | Visual design polished enough for perceived usability?        |
| **Doherty Threshold**          | Loading states and feedback designed for perceived speed?     |
| **Von Restorff Effect**        | Key CTAs and important elements stand out?                    |
| **Peak-End Rule**              | Key moments (onboarding, success, errors) well-designed?      |
| **Serial Position Effect**     | Important items at beginning or end of lists?                 |
| **Goal-Gradient Effect**       | Multi-step flows show progress?                               |
| **Tesler's Law**               | Inherent complexity managed, not eliminated incorrectly?      |

### Nielsen's 10 Usability Heuristics

1. Visibility of System Status
2. Match Between System and Real World
3. User Control and Freedom
4. Consistency and Standards
5. Error Prevention
6. Recognition Rather than Recall
7. Flexibility and Efficiency of Use
8. Aesthetic and Minimalist Design
9. Help Users Recognize, Diagnose, and Recover from Errors
10. Help and Documentation

## Severity Levels

| Severity       | Definition                                  | Action                    |
| -------------- | ------------------------------------------- | ------------------------- |
| **Critical**   | Blocks users from completing core tasks     | Must fix before release   |
| **Major**      | Causes significant confusion or frustration | Should fix before release |
| **Minor**      | Suboptimal but users can complete tasks     | Fix in next iteration     |
| **Suggestion** | Enhancement opportunity                     | Consider for future       |

## Connected Skills

- `tsh-figma-designing` — Team Figma conventions informing design system compliance checks.
- `tsh-ensuring-accessibility` — Accessibility-specific review criteria complementing UX checks.
- `tsh-ui-verifying` — Implementation-vs-design verification (separate concern from UX review).
