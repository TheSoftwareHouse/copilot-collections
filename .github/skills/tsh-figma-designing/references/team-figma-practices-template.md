# TSH Figma Practices — Template for Your Team

> **Purpose**: This document captures your team's Figma design practices and conventions.
> Fill in each section with your actual rules and practices. The examples provided are
> placeholders — replace them with your real conventions.
>
> Once completed, the content will be used to teach an AI agent how to create designs
> that match your team's standards in Figma.
>
> **How to fill this in**: Replace the example answers (marked with 💡) with your actual
> practices. Delete any sections that don't apply to your team. Add sections for practices
> not covered here.

---

## 1. File Organization

**How do you organize pages within a Figma file?**

💡 Example: "We use pages for: Cover (project info), Screens (one page per flow), Components (local file components), Archive (old versions)"

Your answer:

**Do you have a standard page naming convention?**

💡 Example: "PascalCase page names. Flows prefixed with flow number: '01 - Onboarding', '02 - Dashboard'"

Your answer:

**Do you use a cover page? What goes on it?**

💡 Example: "Yes — project name, status (Draft/In Review/Approved), last updated date, team members, links to Jira/Confluence"

Your answer:

**How do you handle versioning or archiving old designs?**

💡 Example: "Move outdated screens to an 'Archive' page. Prefix archived frames with 'ARCHIVED\_'. Never delete — always archive."

Your answer:

---

## 2. Frame & Layer Naming

**How do you name top-level frames (screens)?**

💡 Example: "kebab-case: 'login-desktop', 'dashboard-mobile'. Include viewport size: 'homepage-1440', 'profile-390'"

Your answer:

**How do you name sections within a screen?**

💡 Example: "UPPERCASE prefix: 'HERO/', 'NAV/', 'FOOTER/', 'SIDEBAR/'"

Your answer:

**How do you name inner layers?**

💡 Example: "lowercase-kebab-case: 'icon-search', 'text-heading', 'btn-primary'"

Your answer:

**Do you use prefixes for layout wrappers?**

💡 Example: "Yes — underscore prefix for auto-layout containers: '\_row-actions', '\_col-sidebar', '\_wrapper-modal'"

Your answer:

**What names are NOT allowed?**

💡 Example: "Default names like 'Frame 427', 'Group 12', 'Rectangle 5' are never accepted"

Your answer:

---

## 3. Component Conventions

**What naming pattern do you use for components?**

💡 Example: "Slash-separated hierarchy: 'Button/Primary/Large', 'Input/Text/With Label', 'Card/Product/Default'"

Your answer:

**How do you structure component variants?**

💡 Example: "Component properties preferred over nested variants. Properties: State (Default/Hover/Active/Disabled), Size (S/M/L), Type (Primary/Secondary/Ghost)"

Your answer:

**When should someone create a new component vs. modify an existing one?**

💡 Example: "Only create new when: 1) no existing component serves the need, 2) the element will appear 3+ times. Always check the library first. If extending, create a new variant, don't detach."

Your answer:

**What must every component include?**

💡 Example: "Auto-layout (always), description text, all state variants, responsive constraints, variables for all colors/spacing/radii"

Your answer:

**Where do local (file-specific) components go?**

💡 Example: "Dedicated '\_local-components' page. Prefix name with '.' (dot) to indicate local/draft status: '.Card/FeatureToggle'"

Your answer:

---

## 4. Design System & Variables

**What design system library do you use?**

💡 Example: "Main library: 'TSH Design System v3'. Semantic tokens on top of primitives. Two modes: Light/Dark."

Your answer:

**How are color variables organized?**

💡 Example: "Primitive → Semantic: primitives/blue-500 → semantic/primary, primitives/red-500 → semantic/error. Always use semantic tokens, not primitives."

Your answer:

**How are spacing variables organized?**

💡 Example: "spacing/xs (4px), spacing/sm (8px), spacing/md (16px), spacing/lg (24px), spacing/xl (32px), spacing/2xl (48px)"

Your answer:

**How are typography styles organized?**

💡 Example: "heading/h1, heading/h2, heading/h3, body/regular, body/small, body/caption, label/default, label/small"

Your answer:

**Are there rules about when to use variables vs. hardcoded values?**

💡 Example: "NEVER hardcode. Every color, spacing value, border-radius, and font must use a variable or text style. Only exception: one-off decorative elements approved by lead designer."

Your answer:

---

## 5. Auto-Layout Rules

**When must auto-layout be used?**

💡 Example: "Always. Every frame, component, and section must use auto-layout. Absolute positioning only for overlays, decorative elements, or badges."

Your answer:

**How do you handle responsive behavior?**

💡 Example: "Fill width for content containers, hug for buttons/tags. Min/max width set on card grids. Fixed width only for sidebars and fixed navigation."

Your answer:

**Any specific auto-layout conventions?**

💡 Example: "Padding uses spacing variables. Gap between items uses spacing variables. Never use spacer frames — use gap."

Your answer:

---

## 6. Prototyping Conventions

**How do you set up prototype flows?**

💡 Example: "One flow per user journey. Name flows descriptively: 'Happy Path - Checkout', 'Error Flow - Payment Failed'"

Your answer:

**What transitions do you use?**

💡 Example: "Smart Animate for tab/accordion changes. Dissolve (200ms ease) for page transitions. Instant for overlays. Never use Move or Slide unless reflecting real product behavior."

Your answer:

**How do you handle interactive states?**

💡 Example: "Component-level interactions (hover/pressed) defined in the component set. Page-level navigation in prototype mode."

Your answer:

---

## 7. Handoff Conventions

**How do you prepare designs for developer handoff?**

💡 Example: "All screens on a dedicated 'Handoff' page. Annotated with spacing specs where non-obvious. Link to the component in the library. Status label on each screen: Ready/In Progress/Changes Needed."

Your answer:

**What annotations do you include?**

💡 Example: "Edge cases noted as sticky notes. Responsive breakpoints noted. Animation specs for non-standard interactions."

Your answer:

**Do you use Dev Mode?**

💡 Example: "Yes — all handoff screens have Dev Mode ready status. Code Connect linked for core components."

Your answer:

---

## 8. Review & Approval Process

**How are designs reviewed before implementation?**

💡 Example: "Design review by lead designer before handoff. UX review using our heuristic checklist. Design system audit by DS maintainer for new/modified components."

Your answer:

**What checklist do you use before marking a design as ready?**

💡 Example: "1) All layers named properly, 2) All variables used (no hardcoded values), 3) All component instances connected, 4) Empty/error/loading states covered, 5) Responsive behavior set, 6) Accessibility checked (contrast, touch targets)"

Your answer:

---

## 9. Anything Else

Add any other practices, rules, or conventions that are important to your team's design workflow that weren't covered above.

Your answer:

---

## Next Steps

Once you've filled in this document:

1. Share it with your team for review and alignment
2. Return it so we can update the AI agent's `tsh-figma-designing` skill with your actual practices
3. The PLACEHOLDER comments in the skill's reference tables will be replaced with your real conventions

**Questions?** Reach out to the person who sent you this template.
