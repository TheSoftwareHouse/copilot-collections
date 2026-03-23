---
name: tsh-figma-asset-handling
description: 'Prevents agents from recreating Figma design assets (icons, images, SVGs) in code. Enforces export-first workflow when implementing from Figma designs.'
applyTo: '**/*.{tsx,jsx,vue,svelte,ts,js,css,scss}'
---

# Figma Asset Handling

## Rule: Never recreate Figma assets in code

When implementing a UI from a Figma design, never recreate visual assets (icons, illustrations, images, logos) in code. Do not draw SVG paths inline, use CSS shapes, or substitute emoji/Unicode characters to approximate Figma assets.

## Required behavior

Before implementing a component that includes custom icons or images from a Figma design:

1. Check if the asset already exists in the project's asset directories (e.g., `public/`, `assets/`, `icons/`).
2. Check if it matches an icon from a library already used in the project (e.g., `lucide-react`, `heroicons`, `material-icons`).
3. If neither applies — stop and ask the user to export the asset from Figma before proceeding. Do not attempt to recreate it.

## Reference

See `tsh-implementing-frontend` skill, Step 2 for the full asset handling workflow.
