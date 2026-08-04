---
name: tsh-review
description: "Check the implementation against the plan and feature context."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-code-reviewer`.</routing>

Review the implementation against the plan and feature context, including correctness, security, quality, testing, scalability, documentation, and migration acceptance criteria. The reviewer owns E2E execution.

<required-skills>
- `tsh-code-reviewing` - structured quality and security review.
- `tsh-implementation-gap-analysing` - compare implementation to plan.
- `tsh-technical-context-discovering` - project conventions.
- `tsh-engineering-prompts` - when reviewing runtime LLM prompt code.
</required-skills>

<workflow>
1. Read the research, plan, and applicable instructions.
2. Review changed artifacts against requirements and definitions of done.
3. Run relevant quality gates, including E2E tests owned by this reviewer.
4. Return findings, update only delegated plan progress where authorized, and record review outcome in the plan changelog when applicable.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-review:v1 -->
