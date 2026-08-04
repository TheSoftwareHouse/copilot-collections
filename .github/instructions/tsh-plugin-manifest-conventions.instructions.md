---
name: tsh-plugin-manifest-conventions
description: Rules for plugin, marketplace, and MCP manifest files, including root versus VS Code MCP responsibilities.
applyTo: "{plugin.json,.mcp.json,.vscode/mcp.json,.github/plugin/**/*.json,specifications/plugins-and-marketplace/**/*.md}"
---

# Plugin & MCP Manifest Conventions

## Root manifest responsibilities

- `plugin.json` must reference the repository-root `.mcp.json` via `mcpServers`; never point `plugin.json` to `.vscode/mcp.json`.
- Root `.mcp.json` is the plugin/CLI-facing MCP manifest. `.vscode/mcp.json` is the VS Code-facing MCP manifest.

## MCP parity and intentional differences

- When one MCP manifest changes, review the other for server parity.
- Preserve intentional runtime-specific differences and document them in the affected manifest or related specification.
- Root `.mcp.json` may intentionally omit VS Code-only fields such as `inputs`.
- `.vscode/mcp.json` may include VS Code-only fields and UX affordances that must not be copied blindly into root `.mcp.json`.

## Marketplace manifest conventions

- `.github/plugin/marketplace.json` should keep `source: "."` when the repository-root `plugin.json` is the source of truth.
- Marketplace entries should inherit component paths from root `plugin.json`; do not duplicate `agents`, `skills`, `commands`, or `mcpServers` overrides unless intentionally changing strategy.
- Do not add `strict` unless the repository intentionally moves away from the default root-manifest strategy.
