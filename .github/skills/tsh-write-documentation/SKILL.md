---
name: tsh-write-documentation
description: "Author or update repository documentation according to a delegated documentation task and technical context."
user-invocable: false
---
<routing>Designated agent: `tsh-technical-writer`; private workflow skill: `tsh-write-documentation`.</routing>

Author repository documentation only: README, CHANGELOG, in-repo docs, and the documentation site targets named by the delegated task. Follow the canonical documentation-writing procedure and remain within the named files.

<required-skills>`tsh-writing-documentation`, `tsh-technical-context-discovering`</required-skills>
<workflow>Confirm the task is documentation-only; read relevant context and prior worker output; write only delegated targets; validate links and documentation build when applicable; return files, summaries, verification, and unresolved dependencies.</workflow>
<constraints>Do not modify product code, tests, infrastructure, unrelated documentation, or the existing `tsh-writing-documentation` skill.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-write-documentation:v1 -->
