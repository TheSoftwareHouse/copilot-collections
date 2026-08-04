---
name: tsh-review-codebase
description: "Perform a comprehensive code quality analysis: dead code, duplications, and improvement opportunities."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-architect`.</routing>

Perform a thorough repository code-quality analysis covering dead code, duplication, architecture, security, and improvement opportunities. Save `code-quality-report.md` in the repository root.

<required-skills>
- `tsh-codebase-analysing` - structured repository analysis.
- `tsh-technical-context-discovering` - project conventions.
- `tsh-code-reviewing` - quality and security criteria.
</required-skills>

<workflow>
1. Discover repository layers, stack, conventions, and tests.
2. Analyze each layer for dead code, duplications, complexity, boundaries, security, and missing coverage.
3. Review architecture and prioritize findings as Critical, Important, or Nice to Have.
4. Save a self-contained `code-quality-report.md` with findings, counts, and recommended action plan.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-review-codebase:v1 -->
