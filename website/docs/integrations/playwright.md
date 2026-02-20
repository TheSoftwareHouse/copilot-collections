---
sidebar_position: 5
title: Playwright
---

# Playwright MCP

**Server key:** `playwright`  
**Type:** stdio  
**Package:** `@playwright/mcp@latest`

Provides browser automation capabilities for UI verification, testing, and interactive debugging.

## Capabilities

- Navigate to pages and interact with elements (click, fill, hover).
- Capture the accessibility tree for structured page analysis.
- Take screenshots for visual comparison.
- Inspect element state and properties.
- Simulate real user behavior.

## Which Agents Use It

| Agent | When |
|---|---|
| **Software Engineer** | Verifying UI implementation by interacting with the running app |
| **UI Reviewer** | Capturing ACTUAL state for Figma comparison |
| **E2E Engineer** | Exploring UI to discover locators and understand DOM structure |

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

- Local development server must be running.
- Target page must be accessible (authentication handled if needed).

## Official Documentation

- [Playwright MCP on GitHub](https://github.com/microsoft/playwright-mcp)

## Usage Notes

- Primarily operates on the **accessibility tree**, which is often more reliable than visual screenshots for verification.
- Used for **real-time interaction** — clicking buttons, filling forms, navigating pages.
- The UI Reviewer always pairs Playwright (ACTUAL) with Figma MCP (EXPECTED) for verification.
- **Not used for running test suites** — use the terminal for that. Playwright MCP is for interactive exploration and verification.
