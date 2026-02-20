---
sidebar_position: 4
title: Context7
---

# Context7 MCP

**Server key:** `context7`  
**Type:** stdio  
**Package:** `@upstash/context7-mcp@latest`

Provides real-time access to library and framework documentation for accurate API usage and best practices.

## Capabilities

- Search documentation for any library by name and version.
- Retrieve code examples and usage patterns.
- Look up API references for specific functions or methods.
- Find solutions to errors and exceptions.

## Which Agents Use It

| Agent | When |
|---|---|
| **Architect** | Evaluating libraries, verifying compatibility, searching integration patterns |
| **Software Engineer** | API docs, error solutions, best practices for specific features |
| **Code Reviewer** | Verifying framework API usage, checking for known vulnerabilities |
| **UI Reviewer** | Design system documentation and UI library guidelines |
| **E2E Engineer** | Playwright API docs (library ID: `/microsoft/playwright.dev`) |

## Configuration

```json
{
  "context7": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@upstash/context7-mcp@latest"]
  }
}
```

## Usage Rules

### Always

- Check `package.json` (or equivalent) for the exact library version **before** searching.
- Include the version number in search queries for relevance.
- Prioritize official documentation and authoritative sources.

### Never

- Search for internal project logic (use codebase search instead).
- Rely on unverified blogs or forums (risk of context pollution).

## Authentication

No authentication required. Context7 runs locally via `npx` as a stdio process.

## Official Documentation

- [Context7 on GitHub](https://github.com/upstash/context7)

## E2E Engineer Shortcut

The E2E Engineer agent uses the library ID `/microsoft/playwright.dev` directly with `query-docs`, skipping the `resolve-library-id` step for faster Playwright documentation lookups.
