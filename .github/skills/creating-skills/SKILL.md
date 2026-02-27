---
name: creating-skills
description: "Create new skills (SKILL.md) for GitHub Copilot. Provides naming conventions (gerund form), description guidelines, body structure, progressive disclosure patterns, templates, and validation checklists. Use when creating, reviewing, or updating SKILL.md files, or when discussing skill design and organization."
---

# Creating Skills

Creates well-structured, reusable skills for GitHub Copilot. Enforces naming conventions, content structure, and progressive disclosure patterns based on the Agent Skills specification and best practices.

## Core Design Principles

<principles>

<what-is-a-skill>
A skill is a folder containing a `SKILL.md` file with YAML frontmatter and Markdown instructions. Skills provide **procedural knowledge** — step-by-step workflows, domain-specific context, templates, and reference materials that an agent loads on demand to perform specialized tasks.

- **Skills** = reusable workflows, domain knowledge, step-by-step processes, templates (SKILL.md files)
- **Agents** = behavior, personality, responsibilities, problem-solving approach (.agent.md files)
- **Prompts** = workflow triggers, task starters, reusable prompt templates (.prompt.md files)

A skill must NOT define who the agent is — that belongs in the agent file. A skill defines HOW to perform a specific task or workflow.
</what-is-a-skill>

<conciseness>
The context window is a shared resource. Every token in your skill competes with conversation history, other skills, and the user's actual request.

**Default assumption**: The LLM is already very smart. Only add context it doesn't already have.

Before adding any content, ask:

- "Does the LLM really need this explanation?"
- "Can I assume it already knows this?"
- "Does this paragraph justify its token cost?"

Write the minimum necessary to guide the agent effectively. Trim explanations of concepts the LLM already understands.
</conciseness>

<xml-syntax>
Use XML-like tags for structured content that requires explicit boundaries — principles, rules, specifications, or multi-part sections where nesting adds clarity. This ensures reliable parsing across all LLM model tiers.

Use plain Markdown for sequential content like step-by-step processes, guidelines, and reference tables where structure is already clear from headings and formatting.

**When to use XML tags**: Principles, rules, specifications, structured templates, sections with explicit open/close boundaries.
**When to use Markdown**: Steps, checklists, tables, guidelines, reference lists, code examples.
</xml-syntax>

<progressive-disclosure>
Skills use a three-tier loading model:

1. **Discovery** (~100 tokens): Only `name` and `description` are loaded at startup for all skills — this is how the agent decides which skills to activate.
2. **Activation** (< 5000 tokens recommended): The full `SKILL.md` body is loaded when the skill is triggered.
3. **Resources** (as needed): Files in `scripts/`, `references/`, and `assets/` are loaded only when required during execution.

Keep SKILL.md body **under 500 lines**. Move detailed reference material, examples, and templates to separate files. Reference those files from the SKILL.md body.
</progressive-disclosure>

</principles>

## Skill Directory Structure

A skill is a directory containing at minimum a `SKILL.md` file:

```
skill-name/
├── SKILL.md              # Required: instructions + metadata
├── scripts/              # Optional: executable code
├── references/           # Optional: additional documentation
└── assets/               # Optional: templates, static resources
```

- The directory name MUST match the `name` field in the SKILL.md frontmatter.
- Keep file references one level deep from SKILL.md — avoid deeply nested reference chains.
- Name files descriptively: `form-validation-rules.md`, not `doc2.md`.

## Skill Creation Process

Use the checklist below and track your progress:

```
Creation progress:
- [ ] Step 1: Define the skill's purpose
- [ ] Step 2: Create the skill name
- [ ] Step 3: Write the skill description
- [ ] Step 4: Write the skill body
- [ ] Step 5: Create supporting files (if needed)
- [ ] Step 6: Assemble and validate the skill
```

**Step 1: Define the skill's purpose**

Before writing anything, clarify the skill's purpose with the user. Use the `vscode/askQuestions` tool to gather answers to these questions in a single batch:

1. **What task does this skill perform?** — The core activity (e.g., "analyze test coverage", "generate API documentation").
2. **What triggers activation?** — When should the agent load this skill? What user requests or contexts should match?
3. **What does it produce?** — Expected output: a document, code changes, a report, analysis, etc.
4. **What makes it distinct?** — How is this different from existing skills? (List current skills for the user to compare against.)

If the user provided enough context in the conversation to answer these questions confidently, skip the clarification and proceed. Only ask about genuinely ambiguous or missing information.

**Step 2: Create the skill name**

<naming-conventions>

### Naming Formula

Use **gerund form** (verb + -ing) followed by the object:

```
{gerund-verb}-{object}
```

This format clearly describes the activity or capability the skill provides. It reads naturally as "this skill is about [doing something]."

### Rules

| Rule | Requirement |
|---|---|
| Format | Gerund form: `{verb-ing}-{object}` |
| Characters | Lowercase letters, numbers, and hyphens only (`a-z`, `0-9`, `-`) |
| Length | 1–64 characters. Aim for **under 20 characters** (used as `/slash-commands`) |
| Start/end | Must NOT start or end with a hyphen |
| Consecutive hyphens | Must NOT contain `--` |
| Directory match | Must match the parent directory name exactly |

### Naming Examples

Good names (gerund form — preferred):

| Name | Chars | Slash command |
|---|---|---|
| `creating-agents` | 15 | `/creating-agents` |
| `reviewing-code` | 14 | `/reviewing-code` |
| `testing-e2e` | 11 | `/testing-e2e` |
| `analyzing-tasks` | 15 | `/analyzing-tasks` |
| `designing-architecture` | 24 | `/designing-architecture` |
| `gathering-context` | 17 | `/gathering-context` |
| `finding-gaps` | 12 | `/finding-gaps` |

Avoid:

| Pattern | Example | Why |
|---|---|---|
| Noun phrases | `task-analysis` | Passive — doesn't convey action |
| Vague names | `helper`, `utils`, `tools` | Indiscoverable — agent can't match them to tasks |
| Overly generic | `documents`, `data`, `files` | Too broad — will trigger on irrelevant tasks |
| Inconsistent form | Mix of `code-review` and `creating-agents` | Breaks convention — confuses pattern recognition |

> **Note**: Some existing skills in this workspace use noun-phrase form (e.g., `code-review`, `task-analysis`). Gerund form is the preferred convention for new skills. Existing skills will be renamed to gerund form incrementally.

### Shortening Long Names

When the gerund form gets too long (over ~20 chars), simplify the object — let the `description` field carry the specificity.

| Verbose | Shortened | Strategy |
|---|---|---|
| `analyzing-implementation-gaps` (30) | `finding-gaps` (12) | Simpler verb + shorter object |
| `discovering-technical-context` (30) | `gathering-context` (17) | Broader verb + drop qualifier |

### Confirming the Name

When multiple valid names exist, use `vscode/askQuestions` to let the user choose. Present 2-3 candidates with character counts and `/slash-command` previews. Mark the shortest gerund-form option as recommended.

</naming-conventions>

**Step 3: Write the skill description**

<description-guidelines>

### Purpose

The `description` field is the **primary discovery mechanism**. The agent reads all skill descriptions at startup to decide which skill to activate for a given task. Your description must provide enough detail for the agent to match it accurately from potentially 100+ available skills.

### Rules

| Rule | Requirement |
|---|---|
| Length | 1–1024 characters. Non-empty. |
| Point of view | Always third person. Never use "I", "you", or "we". |
| Content | Must describe both WHAT the skill does AND WHEN to use it. |
| Keywords | Include specific trigger terms that help the agent identify relevant tasks. |

### Formula

```
{What the skill does — core capabilities}. {When to use it — triggers and contexts}.
```

### Good Examples

```yaml
description: "Create custom agents (.agent.md) for GitHub Copilot in VS Code. Provides templates, guidelines, and a structured process for building agent definitions. Use when creating, reviewing, or updating .agent.md files."
```

```yaml
description: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction."
```

### Bad Examples

```yaml
# Too vague — agent can't determine when to activate:
description: "Helps with documents."

# Wrong point of view — causes discovery problems:
description: "I can help you process Excel files."

# Missing trigger context — agent doesn't know WHEN to use it:
description: "Processes data from various sources."
```

</description-guidelines>

**Step 4: Write the skill body**

The Markdown body after the frontmatter contains the skill instructions. There are no strict format restrictions — write whatever helps the agent perform the task effectively.

### Content Guidelines

<body-guidelines>

**Line limit**: Keep the SKILL.md body **under 500 lines**. If approaching this limit, split content into referenced files using progressive disclosure patterns.

**Structure the body with these sections** (see template at `./skill.template.md`):

| Section | Required | Purpose |
|---|---|---|
| Introduction | **Yes** | 1-2 sentences describing what the skill does. |
| Principles | No | Core design principles using `<principles>` XML tags — when the skill has foundational rules that constrain all decisions. |
| Process / Workflow | **Yes** | Step-by-step checklist and detailed instructions. The core of the skill. |
| Reference tables | No | Quick-reference tables for rules, patterns, or conventions. |
| Connected Skills | **Yes** | Links to related skills with brief rationale for each. |

**Conciseness rules**:

- Only add context the LLM doesn't already have.
- Use examples instead of explanations — they convey style and expectations more efficiently.
- See [examples/reviewing-code.skill.md](examples/reviewing-code.skill.md) for a complete example demonstrating conciseness.
- Provide a default approach, not multiple options. Add alternatives only when a specific condition requires them.
- Don't explain concepts the LLM already knows (e.g., what PDFs are, how REST APIs work).

**Consistent terminology**: Choose one term for each concept and use it throughout the skill. Don't alternate between "API endpoint", "URL", "route", and "path" if they mean the same thing.

**No time-sensitive information**: Don't include dates or version-dependent guidance. If you must reference a deprecated approach, use an "Old patterns" section.

**Use workflows for complex tasks**: Break operations into clear, sequential steps. Provide a checklist the agent can copy and track progress against.

**Implement feedback loops**: For quality-critical tasks, include validation steps: run validator → fix errors → repeat.

</body-guidelines>

### Degrees of Freedom

Match specificity to the task's fragility and variability:

| Freedom Level | When to use | Example |
|---|---|---|
| **High** (text instructions) | Multiple valid approaches; decisions depend on context | Code review guidelines |
| **Medium** (pseudocode / templates) | A preferred pattern exists but variation is acceptable | Report generation with customizable sections |
| **Low** (exact scripts, no params) | Operations are fragile; consistency is critical | Database migrations, file format validation |

**Step 5: Create supporting files (if needed)**

When the SKILL.md body approaches 500 lines, or when the skill includes resources that should be loaded on demand:

<supporting-files>

| File type | Location | Purpose | Load behavior |
|---|---|---|---|
| Templates | Skill root or `assets/` | Output format templates the agent fills in | Loaded when agent needs to produce output |
| Reference docs | `references/` | Detailed specs, API docs, domain knowledge | Loaded when agent needs specific details |
| Scripts | `scripts/` | Executable utility scripts | Executed (not read into context) — saves tokens |
| Examples | Skill root or `references/` | Input/output examples, sample files | Loaded when agent needs to understand expected format |

**File reference rules**:

- Use relative paths from the skill root: `./references/REFERENCE.md`
- Keep references **one level deep** from SKILL.md — avoid nested reference chains
- Make clear whether the agent should **execute** a script ("Run `analyze.py`") or **read** it as reference ("See `analyze.py` for the algorithm")
- Include a table of contents in reference files longer than 100 lines

</supporting-files>

**Step 6: Assemble and validate the skill**

Use the `./skill.template.md` template to build the SKILL.md file.
See [examples/reviewing-code.skill.md](examples/reviewing-code.skill.md) for a complete filled-in example.

After assembling the skill, use `vscode/askQuestions` to run a final review with the user. Present the proposed `name`, `description`, and a summary of the skill's workflow steps. Ask the user to confirm or request changes before finalizing.

Then validate against this checklist:

### Validation Checklist

```
Validation:
- [ ] Frontmatter: `name` is valid (gerund form, lowercase, hyphens, ≤64 chars)
- [ ] Frontmatter: `name` matches the parent directory name
- [ ] Frontmatter: `description` describes WHAT the skill does and WHEN to use it
- [ ] Frontmatter: `description` is in third person (no "I", "you", "we")
- [ ] Frontmatter: `description` includes specific trigger keywords
- [ ] Body: Under 500 lines total
- [ ] Body: Introduction is 1-2 sentences
- [ ] Body: Process/workflow has a trackable checklist
- [ ] Body: Only adds context the LLM doesn't already have
- [ ] Body: Uses consistent terminology throughout
- [ ] Body: No time-sensitive information
- [ ] Body: XML tags (if used) are properly opened and closed
- [ ] Body: Connected Skills section references existing skills
- [ ] Files: Supporting files are one level deep (no nested reference chains)
- [ ] Files: Template files (if any) use XML tags for structured sections
- [ ] Files: Reference files over 100 lines have a table of contents
- [ ] Testing: Skill tested with real usage scenarios
```

## Common Patterns

For standard workflow patterns (checklists, templates, conditional workflows, feedback loops), see [references/common-patterns.md](references/common-patterns.md).

## Anti-Patterns to Avoid

| Anti-pattern | Why it's harmful | Fix |
|---|---|---|
| Over-explaining known concepts | Wastes tokens; agent already knows what PDFs are | Remove. Only explain project/domain-specific knowledge |
| Offering too many options | Confusing; agent may pick wrong one | Provide a default, with escape hatch for edge cases |
| Deeply nested references | Agent may partially read files at depth > 1 | Keep all references one level deep from SKILL.md |
| Vague file names | `doc2.md`, `helpers.md` | Use descriptive names: `form-validation-rules.md` |
| Windows-style paths | Breaks on Unix systems | Always use forward slashes: `scripts/validate.py` |
| Inconsistent naming within collection | Confuses pattern recognition; breaks discoverability | Use gerund form consistently for all skill names |
| Magic numbers in scripts | Agent can't determine the right value | Document why: `TIMEOUT = 30  # HTTP requests typically complete within 30s` |

## Connected Skills

- `creating-agents` - to understand how skills relate to agent definitions and avoid overlap
- `creating-prompts` - to understand how prompts reference and trigger skills
- `technical-context-discovery` - to discover existing skill patterns in the project before creating a new one
- `codebase-analysis` - to analyze existing skills and identify conventions to follow
