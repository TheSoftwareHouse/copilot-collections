# Docusaurus Documentation Site for Copilot Collections - Analysis Result

## Task Details

| Field | Value |
|---|---|
| Jira ID | N/A (prompt-driven task) |
| Title | Add Docusaurus documentation site, Vercel-ready, with content from existing README, agents, skills and prompts |
| Description | Create a public-facing documentation website using Docusaurus that presents the Copilot Collections project to the open-source community. The site should be ready for deployment on Vercel, propose content derived from the current README and all existing agents, skills, and prompts, and include dedicated sections on use-cases, KPIs (velocity, bug reduction, code quality, Figma design matching), and value proposition. |
| Priority | Medium |
| Reporter | adampolak |
| Created Date | 2026-02-20 |
| Due Date | N/A |
| Labels | documentation, docusaurus, vercel, dx |
| Estimated Effort | N/A |

## Business Impact

This documentation site is the primary outreach and onboarding channel for the open-source community. Today the only entry point is a long, flat `README.md` that mixes installation, concepts, reference, and marketing content in a single file. A structured documentation site will:

1. **Lower the adoption barrier** – new users can find installation instructions, understand the value prop, and navigate reference docs without scrolling through 540+ lines of markdown.
2. **Demonstrate ROI** – dedicated pages for use-cases and KPIs give engineering leaders the data they need to justify adopting the workflow to their teams.
3. **Enable contribution** – clear, navigable docs make it easier for the community to contribute agents, skills, and prompts.
4. **Improve discoverability** – Docusaurus generates SEO-friendly static pages, improving organic search traffic.
5. **Build credibility** – a professional documentation site reflects the quality and maturity of the tooling itself, reinforcing TSH's brand.

---

## Gathered Information

### Knowledge Base & Task Management Tools

No Jira issue or Confluence page is associated with this task. All context was gathered directly from the user prompt and the repository codebase.

### Codebase

#### Repository Overview

| Aspect | Detail |
|---|---|
| Repository type | Single-system repo (not a monorepo) |
| Primary purpose | Shared GitHub Copilot configuration for delivery teams |
| License | MIT (© 2026 The Software House) |
| Current documentation | Single `README.md` (542 lines), `CHANGELOG.md` (249 lines) |
| Existing tech | No build tooling, no `package.json`, no frontend framework – pure markdown/config files |
| Editor config | EditorConfig present (LF line endings, UTF-8) |
| `.gitignore` | `node_modules`, `.vscode/settings.json`, `.idea`, `.DS_Store` |

#### Content Inventory

The repository contains the following content assets that should be migrated into the documentation site:

**Agents (6):**
| Agent | File | Focus |
|---|---|---|
| Architect | `.github/agents/tsh-architect.agent.md` | Solution design, architecture, technical specs |
| Business Analyst | `.github/agents/tsh-business-analyst.agent.md` | Requirements, context, domain understanding |
| Software Engineer | `.github/agents/tsh-software-engineer.agent.md` | Code implementation (backend & frontend) |
| UI Reviewer | `.github/agents/tsh-ui-reviewer.agent.md` | Single-pass Figma vs implementation verification |
| Code Reviewer | `.github/agents/tsh-code-reviewer.agent.md` | Structured code review and risk detection |
| E2E Engineer | `.github/agents/tsh-e2e-engineer.agent.md` | Playwright-based end-to-end testing |

**Skills (10):**
| Skill | File | Focus |
|---|---|---|
| Task Analysis | `.github/skills/task-analysis/SKILL.md` | Context gathering, gap analysis, research reports |
| Architecture Design | `.github/skills/architecture-design/SKILL.md` | Solution design, patterns, implementation plans |
| Codebase Analysis | `.github/skills/codebase-analysis/SKILL.md` | Repository structure, dependencies, dead code |
| Code Review | `.github/skills/code-review/SKILL.md` | Quality verification, security, testing |
| Implementation Gap Analysis | `.github/skills/implementation-gap-analysis/SKILL.md` | Expected vs actual implementation state |
| E2E Testing | `.github/skills/e2e-testing/SKILL.md` | Playwright patterns, Page Objects, verification loops |
| Technical Context Discovery | `.github/skills/technical-context-discovery/SKILL.md` | Project conventions, coding standards |
| Frontend Implementation | `.github/skills/frontend-implementation/SKILL.md` | Accessibility, design system, component patterns |
| UI Verification | `.github/skills/ui-verification/SKILL.md` | Figma comparison criteria, tolerances, severity |
| SQL & Database | `.github/skills/sql-and-database/SKILL.md` | Schema design, SQL patterns, ORM integration |

**Prompts (8):**
| Prompt | File | Agent | Purpose |
|---|---|---|---|
| `/research` | `.github/prompts/research.prompt.md` | Business Analyst | Gather task context |
| `/plan` | `.github/prompts/plan.prompt.md` | Architect | Create implementation plan |
| `/implement` | `.github/prompts/implement.prompt.md` | Software Engineer | Execute the plan |
| `/implement-ui` | `.github/prompts/implement-ui.prompt.md` | Software Engineer | UI implementation with Figma loop |
| `/review` | `.github/prompts/review.prompt.md` | Code Reviewer | Structured code review |
| `/review-ui` | `.github/prompts/review-ui.prompt.md` | UI Reviewer | Single-pass Figma verification |
| `/e2e` | `.github/prompts/e2e.prompt.md` | E2E Engineer | Playwright E2E test creation |
| `/code-quality-check` | `.github/prompts/code-quality-check.prompt.md` | Architect | Dead code, duplications, improvements |

**MCP Integrations (5):**
| MCP Server | Purpose |
|---|---|
| Atlassian | Jira/Confluence access for research, planning, review |
| Figma MCP Server | Design extraction for UI verification |
| Context7 | Semantic search in external docs |
| Playwright | Browser automation for E2E and UI verification |
| Sequential Thinking | Advanced reasoning for complex analysis |

**Workflow:**
The core workflow is a 4-phase delivery flow: **Research → Plan → Implement → Review**, with specialized variants for frontend (Figma verification loop) and E2E testing.

### Relevant Links

- [Docusaurus documentation](https://docusaurus.io/docs) – official docs for the static site generator
- [Deploying Docusaurus on Vercel](https://docusaurus.io/docs/deployment#deploying-to-vercel) – official deployment guide
- [Vercel Docusaurus template](https://vercel.com/templates/docusaurus) – Vercel's starter template
- [Atlassian MCP docs](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Figma MCP docs](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

### Relevant Charts & Diagrams

#### Core Workflow Diagram

```
┌──────────┐     ┌──────────┐     ┌──────────────┐     ┌──────────┐
│ /research│────▶│  /plan   │────▶│ /implement   │────▶│  /review │
│  (BA)    │     │ (Arch)   │     │ (SE)         │     │  (CR)    │
└──────────┘     └──────────┘     └──────────────┘     └──────────┘
                                         │
                                         ▼
                                  ┌──────────────┐
                                  │ /implement-ui│ (for frontend)
                                  │    ┌─loop──┐ │
                                  │    │/review-│ │
                                  │    │  ui   │ │
                                  │    └───────┘ │
                                  └──────────────┘
```

#### Agent Handoff Diagram

```
Business Analyst ──▶ Architect ──▶ Software Engineer ──▶ Code Reviewer
                                        │                      │
                                        ▼                      ▼
                                   UI Reviewer          (back to SE
                                   E2E Engineer          for fixes)
```

---

## Current Implementation Status

### Existing Components

- `README.md` - root file - **needs transformation into Docusaurus pages** (content will be split across multiple doc pages)
- `CHANGELOG.md` - root file - **will be rendered as a changelog page**
- `.vscode/mcp.json` - MCP server config - **can be referenced/embedded in installation docs**
- `.github/agents/*.agent.md` - 6 agent definitions - **content source for agent reference pages**
- `.github/skills/*/SKILL.md` - 10 skill definitions - **content source for skill reference pages**
- `.github/prompts/*.prompt.md` - 8 prompt definitions - **content source for prompt reference pages**
- `LICENSE` - MIT license - **can be linked or rendered**

### Key Files and Directories

- `/` (root) - Will contain `docusaurus.config.ts`, `package.json`, `vercel.json`
- `/docs/` - Docusaurus documentation pages (to be created)
- `/src/` - Docusaurus custom pages and components (to be created)
- `/static/` - Static assets like images, logos (to be created)
- `/blog/` - Not needed (changelog page only)
- `README.md` - Source content for migration (will remain as repo README, separate from docs)

---

## Proposed Documentation Site Structure

### Information Architecture

The content should be organized into the following sections, derived from the existing README structure and enriched with dedicated value-proposition content:

```
docs/
├── intro.md                          # What is Copilot Collections (from README hero section)
│
├── getting-started/
│   ├── prerequisites.md              # Copilot license, VS Code version requirements
│   ├── installation.md               # Clone, VS Code User Settings, enable features
│   └── mcp-setup.md                  # MCP server configuration with all 5 servers
│
├── workflow/
│   ├── overview.md                   # The 4-phase Research → Plan → Implement → Review
│   ├── standard-flow.md             # Standard backend/fullstack flow
│   ├── frontend-flow.md             # Frontend flow with Figma verification loop
│   └── e2e-flow.md                  # E2E testing flow
│
├── agents/
│   ├── overview.md                   # What are agents, how they collaborate
│   ├── architect.md                  # tsh-architect details
│   ├── business-analyst.md           # tsh-business-analyst details
│   ├── software-engineer.md          # tsh-software-engineer details
│   ├── ui-reviewer.md               # tsh-ui-reviewer details
│   ├── code-reviewer.md             # tsh-code-reviewer details
│   └── e2e-engineer.md              # tsh-e2e-engineer details
│
├── prompts/
│   ├── overview.md                   # What are prompts, how to use them
│   ├── research.md                   # /research command details
│   ├── plan.md                       # /plan command details
│   ├── implement.md                  # /implement command details
│   ├── implement-ui.md              # /implement-ui command details
│   ├── review.md                     # /review command details
│   ├── review-ui.md                 # /review-ui command details
│   ├── e2e.md                       # /e2e command details
│   └── code-quality-check.md        # /code-quality-check command details
│
├── skills/
│   ├── overview.md                   # What are skills, how they work
│   ├── task-analysis.md
│   ├── architecture-design.md
│   ├── codebase-analysis.md
│   ├── code-review.md
│   ├── implementation-gap-analysis.md
│   ├── e2e-testing.md
│   ├── technical-context-discovery.md
│   ├── frontend-implementation.md
│   ├── ui-verification.md
│   └── sql-and-database.md
│
├── integrations/
│   ├── overview.md                   # MCP integrations overview
│   ├── atlassian.md                  # Jira/Confluence MCP details
│   ├── figma.md                      # Figma MCP details
│   ├── context7.md                   # Context7 MCP details
│   ├── playwright.md                 # Playwright MCP details
│   └── sequential-thinking.md        # Sequential Thinking MCP details
│
└── value/
    ├── use-cases.md                  # Problem scenarios it solves
    └── kpis.md                       # Measurable impact metrics
```

### Custom Pages (non-docs)

```
src/pages/
├── index.tsx                         # Landing page / hero with value prop
└── changelog.md                      # Auto-rendered from CHANGELOG.md content
```

---

## Use-Cases (Problems It Solves)

The documentation should present these use-cases as scenarios that resonate with the target audience:

### Use-Case 1: Onboarding New Team Members
**Problem:** New developers join a project and spend days understanding the codebase, conventions, and task requirements before they can contribute.
**Solution:** The `/research` prompt + Business Analyst agent automatically gathers context from Jira, Confluence, Figma, and the codebase. The `/plan` prompt + Architect agent creates a step-by-step implementation plan. New developers get a structured understanding of the task and a clear path forward within minutes instead of days.

### Use-Case 2: Inconsistent Code Quality Across Teams
**Problem:** Different developers follow different patterns, leading to inconsistent codebases that are hard to maintain. Code reviews catch issues late in the cycle.
**Solution:** Skills like `technical-context-discovery`, `code-review`, and `frontend-implementation` encode tested best practices. The Code Reviewer agent enforces them automatically. The `/code-quality-check` prompt detects dead code, duplications, and anti-patterns repository-wide.

### Use-Case 3: UI Implementation Doesn't Match Designs
**Problem:** Frontend implementations deviate from Figma designs—wrong spacing, colors, component variants. QA catches these late, causing rework.
**Solution:** The `/implement-ui` prompt runs an automated Figma verification loop (up to 5 iterations) comparing the running app via Playwright against Figma specs. The UI Reviewer agent provides structured PASS/FAIL reports with exact pixel values before the code ever reaches human review.

### Use-Case 4: Flaky or Missing E2E Tests
**Problem:** E2E tests are written inconsistently, use brittle selectors, and break on unrelated changes. Teams don't trust them and skip them.
**Solution:** The E2E Engineer agent + `e2e-testing` skill enforces Page Object patterns, accessibility-first locators, dynamic test data, and a verification loop with flaky detection. Tests are verified for 3+ consecutive passes before being committed.

### Use-Case 5: Context Scattered Across Tools
**Problem:** Requirements live in Jira, designs in Figma, documentation in Confluence, code in GitHub. Developers constant context-switch to gather information.
**Solution:** MCP integrations (Atlassian, Figma, Context7, Playwright) bring all context into a single Copilot chat session. The Business Analyst agent synthesizes information from all sources into one research document.

### Use-Case 6: Lack of Structured Delivery Workflow
**Problem:** Teams lack a consistent process. Some devs jump straight to coding, skip planning, and produce code that doesn't fully meet requirements. Reviews are ad-hoc.
**Solution:** The enforced Research → Plan → Implement → Review workflow ensures every task goes through proper analysis, planning, implementation, and review. Each phase produces a documented artifact that feeds the next phase.

### Use-Case 7: Security and Best Practices Are Afterthoughts
**Problem:** Security reviews happen at the end of a sprint if at all. Best practices like DRY, KISS, and proper error handling are inconsistently applied.
**Solution:** Every plan includes security considerations. The Code Reviewer agent checks for security vulnerabilities, missing input validation, and exposed secrets. The SQL & Database skill enforces least-privilege, parameterized queries, and proper indexing.

### Use-Case 8: Database Schema and Query Quality Issues
**Problem:** ORMs hide performance problems. Developers create schemas without proper indexes, normalisation, or migration safety checks.
**Solution:** The `sql-and-database` skill provides comprehensive patterns for schema design (naming conventions, PK strategies, normalisation), indexing strategies, join optimisation, locking mechanics, and query debugging with EXPLAIN ANALYZE. Supports TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.

---

## KPIs (Measurable Impact)

The documentation site should present these KPIs as the metrics that teams can track to measure the impact of adopting Copilot Collections:

### Development Velocity

| KPI | Metric | Expected Impact |
|---|---|---|
| **Context gathering time** | Time from task assignment to starting implementation | Reduce by 60–80% (automated research replaces manual Jira/Figma/codebase exploration) |
| **Planning time** | Time to produce an implementation plan | Reduce by 50–70% (structured plan generation with gap analysis) |
| **Implementation speed** | Lines of code / features delivered per sprint | Increase by 30–50% (clear plan, no ambiguity, automated patterns) |
| **Onboarding time** | Time for new developer to deliver first meaningful PR | Reduce by 40–60% (structured workflow guides new developers) |
| **Rework cycles** | Number of times code is sent back after review | Reduce by 40–60% (automated code review catches issues before human review) |

### Bug Reduction

| KPI | Metric | Expected Impact |
|---|---|---|
| **UI defects found in QA** | Design mismatches caught post-merge | Reduce by 70–90% (automated Figma verification loop catches pixel-level issues) |
| **E2E test flakiness** | Percentage of flaky E2E tests | Reduce by 50–80% (enforced patterns: Page Objects, auto-waiting, dynamic data) |
| **Regression bugs** | Bugs introduced by new code in existing features | Reduce by 30–50% (implementation gap analysis prevents accidental changes) |
| **Security vulnerabilities** | Critical/high severity issues found in security scans | Reduce by 30–50% (automated security checks in every code review) |
| **Database performance issues** | Slow queries, missing indexes, N+1 problems | Reduce by 40–60% (SQL skill enforces EXPLAIN ANALYZE, indexing, and query patterns) |

### Code Quality

| KPI | Metric | Expected Impact |
|---|---|---|
| **Dead code percentage** | Unused imports, functions, files in the codebase | Reduce by 50–70% (automated dead code detection via `/code-quality-check`) |
| **Code duplication** | Percentage of duplicated logic across files | Reduce by 40–60% (duplication detection and consolidation recommendations) |
| **Test coverage** | Percentage of critical paths covered by tests | Increase by 20–40% (every plan includes test requirements, E2E engineer creates tests) |
| **Consistency score** | Adherence to project coding standards | Increase by 50–70% (technical context discovery enforces project conventions) |
| **Review cycle time** | Time from PR open to approval | Reduce by 30–50% (automated first-pass review, structured findings) |

### Figma Design Matching

| KPI | Metric | Expected Impact |
|---|---|---|
| **Design-to-code accuracy** | Percentage of UI components matching Figma within tolerance | Increase to 95–99% (automated verification with exact pixel comparison) |
| **Figma verification iterations** | Average number of fix-verify cycles per component | Target: ≤ 2 iterations (automated loop with structured diff reports) |
| **Design QA feedback rounds** | Number of design review rounds before sign-off | Reduce by 60–80% (issues caught before human design review) |
| **Accessibility compliance** | Percentage of components passing a11y checks | Increase by 30–50% (frontend implementation skill enforces semantic HTML, ARIA patterns) |

---

## Docusaurus & Vercel Configuration Requirements

### Technology Choice: Docusaurus

**Why Docusaurus:**
- Built on React – the most widely adopted frontend framework in the open-source ecosystem
- First-class Markdown/MDX support – natural fit for a repository that is entirely markdown-based
- Built-in versioning – can version docs as the project evolves
- Built-in search (via Algolia or local search plugin) – critical for navigating 30+ pages of docs
- Sidebar auto-generation from folder structure – reduces maintenance
- Active Meta/Facebook backing and large community
- SEO-optimized static output – each page is a proper HTML file with metadata

### Vercel Deployment

**Requirements:**
- Default Vercel URL is sufficient for now (no custom domain needed)
- No analytics required initially (can be added later)
- Standard Docusaurus build command: `npm run build`
- Output directory: `build/`
- `vercel.json` configuration for clean URLs and redirects
- GitHub integration for automatic deployments on push to main

### Changelog Page

- The existing `CHANGELOG.md` content should be rendered as a dedicated changelog page
- No full blog section is needed
- Changelog page should be accessible from the main navigation

### Design Considerations

- Use Docusaurus's default theme with customized colors matching TSH branding
- Dark mode support (Docusaurus default)
- Responsive design (Docusaurus default)
- Landing page with hero section, feature highlights, and call-to-action
- Clear navigation between conceptual docs (workflow, use-cases) and reference docs (agents, skills, prompts)

---

## Gap Analysis

### Question 1
#### Who is the primary audience for this documentation site?
The primary audience is the **external/open-source community** – any developer who finds the GitHub repo and wants to use Copilot Collections in their projects.

### Question 2
#### Should the site use a custom domain or default Vercel URL?
**Default Vercel URL** is sufficient for now. A custom domain can be configured later.

### Question 3
#### Should analytics be included from the start?
**No** – keep it simple for now. Analytics can be added later as needed.

### Question 4
#### Should the site include a blog section?
**Changelog page only** – the existing CHANGELOG.md content will be rendered as a dedicated page, but no full blog infrastructure is needed.

---

## Summary of Key Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Static site generator | Docusaurus | React-based, MDX support, built-in versioning, SEO-friendly |
| Hosting | Vercel | Zero-config for Docusaurus, automatic deploys, free tier sufficient |
| Domain | Default Vercel URL | Custom domain not needed initially |
| Analytics | None initially | Keep MVP lean; add later if needed |
| Blog | Changelog page only | Leverage CHANGELOG.md; full blog unnecessary for current needs |
| Content source | Existing README, agents, skills, prompts | All content already exists in markdown; needs restructuring, not writing from scratch |
| Navigation | Sidebar per section + top nav | Docusaurus convention; sidebar for deep reference, top nav for sections |
| Search | Local search plugin or Algolia | Important for 30+ page site; start with local search |
| Theme | Default Docusaurus + TSH brand colors | Low effort, professional look, dark mode included |
