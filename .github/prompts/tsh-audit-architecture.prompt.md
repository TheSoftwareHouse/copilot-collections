---
agent: "tsh-architect"
description: "Audit the architecture of the complete monorepo and produce a prioritized evidence-based report."
---

<goal>
Assess the architecture of the complete monorepo and identify concrete, evidence-based weaknesses, risks, and improvement opportunities across its internal boundaries and delivery system. Produce a standalone prioritized report that gives maintainers a clear target direction and roadmap without modifying source code or prescribing implementation changes.
</goal>

<input-requirements>
- Treat the current workspace as the complete monorepo under audit, including all applications, packages, tooling, configuration, infrastructure, tests, and documentation that are relevant to its architecture.
- No user input is needed. Do not request or accept a package, application, directory, or focus-area argument that narrows the audit scope.
- Audit the full monorepo even when some areas appear less significant or are not directly related to the primary product flow.
</input-requirements>

<required-skills>
## Required Skills

Before starting, load and follow these skills:
- `tsh-technical-context-discovering` - to discover repository instructions, conventions, persisted context, and architectural constraints before assessment.
- `tsh-codebase-analysing` - to inventory the complete monorepo, dependencies, scripts, integrations, testing, infrastructure, and existing duplication or debt.
- `tsh-architecture-designing` - use strictly as assessment and evaluation lenses for boundaries, interactions, tradeoffs, scalability, resiliency, and target architectural direction. This prompt's output specification overrides that skill's plan-creation handoff: do not create a plan document and do not invoke plan review.
- `tsh-code-reviewing` - to substantiate architecture-relevant risks and verify security, quality gates, scalability, and evidence without turning the workflow into a code-quality review.
</required-skills>

<workflow>
## Workflow

1. **Discover technical context**: Discover the monorepo's technical context, repository instructions, persisted plans or research, conventions, and stated constraints. Record which local sources were used.
2. **Inventory the monorepo**: Inventory the complete topology: applications, packages, services, shared libraries, workspace declarations, package manifests, dependency constraints, build tooling, test tooling, deployment and infrastructure configuration, and repository-level scripts.
3. **Map architecture and boundaries**: Map the architecture and dependency directions across applications, packages, services, tooling, and external boundaries. Identify intended layers, ownership boundaries, coupling, cohesion, dependency cycles, forbidden directions, and boundary violations.
4. **Assess applications and packages**: Assess each significant application and package, then assess cross-cutting integration between them. Cover responsibilities, public surfaces, internal structure, reuse, isolation, and whether the topology supports independent evolution.
5. **Inspect contracts and delivery architecture**: Inspect API and domain contracts, data and persistence boundaries, shared state, event or messaging boundaries, configuration and environment boundaries, generated artifacts, quality gates, build graph, test architecture, release flow, and deployment structure.
6. **Assess operational architecture**: Inspect architecture-relevant security boundaries, trust transitions, secrets and credential handling, failure isolation, recovery behavior, observability where it affects resiliency, scaling assumptions, bottlenecks, and operational constraints.
7. **Substantiate findings**: Identify and substantiate findings. For every finding, trace the claim to concrete repository evidence such as file paths, configuration, package manifests, dependency declarations, scripts, or relevant source locations. Separate verified facts from inferences and record uncertainty. Do not block the audit or request user input when ambiguity remains; record unresolved ambiguity in the report's `Risks, assumptions, and open questions` section.
8. **Prioritize architectural direction**: Prioritize findings by architectural impact, likelihood, urgency, affected boundaries, and reversibility. Formulate a target-direction roadmap for Now, Next, and Later that describes architectural outcomes and decision priorities, without prescribing implementation changes.
9. **Write the audit report**: Write exactly one standalone report to the repository root as `architecture-audit-report.md` using the required output structure.
10. **Verify the report**: Verify the report before finishing: confirm that all major monorepo areas were considered, every finding has concrete evidence and an actionable recommendation, severity values are valid, claims are distinguishable as facts or inferences, and the Mermaid diagram reflects the repository evidence.
</workflow>

<output-specification>
## Output

Write exactly one standalone repository-root file: `architecture-audit-report.md`.

The report must include:
- An executive summary with the overall architectural picture and highest priorities.
- Scope and method, including the complete-monorepo scope, evidence sources, and limitations.
- A current architecture map with a Mermaid diagram that shows major applications, packages, dependency directions, and important external or operational boundaries.
- Strengths that are supported by repository evidence.
- A findings table with these columns: `ID`, `Severity`, `Evidence`, `Impact/Risk`, and `Recommendation`. Severity must be one of `Critical`, `High`, `Medium`, or `Low`.
- Detailed findings grouped by architecture category, including monorepo topology, package and app boundaries, dependency direction and cycles, coupling/cohesion, layering, API/contracts, shared state, ownership, build/test/release architecture, configuration boundaries, scalability, resiliency, security boundaries, and architecture-level duplication or debt as applicable.
- Dependency and boundary observations, including confirmed cycles, suspicious directions, implicit contracts, or areas where evidence is insufficient.
- A prioritized roadmap with distinct `Now`, `Next`, and `Later` horizons, expressed as target architectural outcomes and decision priorities.
- Risks, assumptions, and open questions.
- A conclusion that summarizes the target direction and remaining uncertainty.
- Record any unresolved ambiguity in the `Risks, assumptions, and open questions` section rather than blocking the audit or requesting user input.

Each finding must include concrete file or path evidence and an actionable recommendation. Recommendations may describe the desired architectural direction, boundary, or decision, but must not prescribe implementation changes.
</output-specification>

<constraints>
## Constraints

- Analyze the full monorepo only; do not add a scope argument or narrow the audit to a package, application, directory, or selected concern.
- Do not modify source code, configuration, tests, build files, or any existing repository files. The only requested artifact is `architecture-audit-report.md`.
- Distinguish verified facts from inferences. Label assumptions and uncertainty explicitly, and do not present speculation as a finding.
- Keep this distinct from the existing `/tsh-review-codebase` workflow: it produces `code-quality-report.md`; this workflow produces `architecture-audit-report.md` and concentrates on system and monorepo architecture. Reuse code-quality observations only where they have material architectural impact on boundaries, topology, dependencies, delivery, resilience, security, scalability, or maintainability at monorepo level.
- Local repository evidence is required for every finding. External sources may inform recommendations only when clearly labeled as external context, and they must not substitute for repository evidence.
- Do not prescribe implementation changes. Recommendations and roadmap items must remain at the architecture, boundary, target-state, or decision level.
</constraints>

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-audit-architecture:v1 -->
