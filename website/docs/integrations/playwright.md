---
sidebar_position: 5
title: Playwright
---

# Playwright MCP

**Server key:** `playwright`  
**Type:** stdio  
**Package:** `@playwright/mcp@latest`

Provides browser automation capabilities for interactive debugging, exploratory browser work, and E2E-oriented inspection inside Copilot.

:::note UI Verification Flow
Figma-backed UI verification in `/tsh-implement` does **not** collect ACTUAL evidence through Playwright MCP. That flow uses `tsh-ui-capture-worker`, which writes Playwright CLI artifacts such as `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` to disk for the reviewer.
:::

## Capabilities

- Navigate to pages and interact with elements (click, fill, hover).
- Capture the accessibility tree for structured page analysis.
- Take screenshots for visual comparison.
- Inspect element state and properties.
- Simulate real user behavior.

## Which Agents Use It

| Agent                 | When                                                            |
| --------------------- | --------------------------------------------------------------- |
| **Software Engineer** | Ad-hoc browser inspection while debugging implementation issues |
| **E2E Engineer**      | Exploring UI to discover locators and understand DOM structure  |

## Configuration

```json
{
  "playwright": {
    "command": "npx",
    "args": ["@playwright/mcp@latest"],
    "type": "stdio"
  }
}
```

## Prerequisites

- Playwright MCP configured in `mcp.json`.
- Local development server must be running.
- Target page must be accessible (authentication handled if needed).
- For the Figma-backed UI verification loop, `playwright-cli` must also be available to `tsh-ui-capture-worker` (`npx playwright-cli` or a global install).

## Official Documentation

- [Playwright MCP on GitHub](https://github.com/microsoft/playwright-mcp)

## Usage Notes

- Primarily operates on the **accessibility tree**, which is often more reliable than visual screenshots for verification.
- Used for **real-time interaction** — clicking buttons, filling forms, navigating pages.
- The Figma verification loop pairs Figma MCP (EXPECTED) with `tsh-ui-capture-worker` Playwright CLI artifacts (ACTUAL).
- **Not used for running test suites** — use the terminal for that. Playwright MCP is for interactive exploration and verification.
