---
sidebar_position: 4
title: Codebase Analysis
---

# Codebase Analysis

**Folder:** `.github/skills/codebase-analysis/`  
**Used by:** Architect, Business Analyst, Software Engineer

Provides a comprehensive 12-step process for analyzing an entire codebase, with support for monorepos.

## 12-Step Analysis Checklist

1. **Repository structure** — File organization, folder hierarchy.
2. **Dependencies** — Package audit, outdated dependencies.
3. **Scripts** — Build, test, lint, deploy scripts.
4. **High-level architecture** — System components and interactions.
5. **Backend** — API structure, data access, business logic.
6. **Frontend** — Components, state management, routing.
7. **Infrastructure** — Deployment config, CI/CD, environment setup.
8. **Third-party integrations** — External services, APIs.
9. **Testing** — Test coverage, patterns, gaps.
10. **Security** — Security approach and vulnerabilities.
11. **Improvements** — Prioritized improvement opportunities.
12. **Dead code & duplications** — Unused code and duplication detection.

## Key Capabilities

- Repository type identification (monorepo vs single system).
- Architecture diagramming from code.
- Dependency audit and outdated dependency detection.
- Dead code and duplication detection.
- Security approach rating.
- Improvement prioritization (Critical / To be implemented / Nice to have).

## Output

A structured report (`codebase-analysis.example.md` template) covering all 12 steps. For monorepos, findings are organized per app/package.
