---
sidebar_position: 3
title: Figma
---

# Figma MCP

**Server key:** `figma-mcp-server`  
**Type:** HTTP  
**URL:** `https://mcp.figma.com/mcp`

Provides access to Figma designs for extracting specifications, verifying UI implementations, and understanding user flows.

## Capabilities

- Extract design specifications (spacing, typography, colors, dimensions).
- Read component variants and interaction states.
- Inspect layer hierarchy and structure.
- Access FigJam diagrams for flow analysis.

## Which Agents Use It

| Agent | When |
|---|---|
| **Business Analyst** | Understanding functional intent, identifying missing states, verifying requirements against designs |
| **Architect** | Translating visual requirements into technical specifications, identifying API/data needs |
| **Software Engineer** | Extracting exact design values for frontend implementation |
| **UI Reviewer** | Getting EXPECTED state for comparison (primary verification tool) |
| **Code Reviewer** | Verifying frontend implementation matches design specifications |
| **E2E Engineer** | Understanding expected UI behavior, extracting labels for locator strategies |

## Configuration

```json
{
  "figma-mcp-server": {
    "url": "https://mcp.figma.com/mcp",
    "type": "http"
  }
}
```

## Authentication

Connects to the Figma cloud API via HTTP. Requires the Figma desktop app to be running in Dev Mode for design extraction.

## Official Documentation

- [Guide to the Figma MCP Server](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)

## Usage Notes

- Figma URLs are extracted from research (`.research.md`) and plan (`.plan.md`) files.
- The UI Reviewer uses fileKey and nodeId from Figma URLs to locate specific components.
- If a Figma URL is missing, agents stop and ask the user — they never guess design values.
- Focus on **functional intent** (what), not **styling** (how), when in the BA/Architect role.
