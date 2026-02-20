---
agent: "tsh-workshop-analyst"
model: "Claude Opus 4.6"
description: "Clean a raw workshop or meeting transcript from small talk and structure it by topics."
---

Clean the provided raw transcript from small talk, filler words, off-topic tangents, and other non-business content. Structure the remaining content by discussion topics and extract key decisions, action items, and open questions.

The file outcome should be a markdown file named `cleaned-transcript.md` placed in the `specifications` directory under a folder named after the workshop topic in kebab-case format (e.g., `specifications/user-onboarding/cleaned-transcript.md`).

## Required Skills

Before starting, load and follow this skill:
- `transcript-processing` - for the structured cleaning process and output template

## Workflow

1. Identify the transcript format (speaker-labelled, timestamped, plain text, or mixed).
2. Extract meeting metadata (date, participants, topic) — ask the user if not present in the transcript.
3. Remove non-business content: greetings, small talk, filler words, technical difficulties, off-topic tangents.
4. Group remaining content by discussion topics with descriptive headings.
5. Extract key decisions, action items, and open questions into dedicated sections.
6. Preserve critical raw context (exact quotes where original wording matters).
7. Save the cleaned transcript following the `cleaned-transcript.example.md` template.

Follow the template structure and naming conventions strictly to ensure clarity and consistency.

When in doubt about whether content is business-relevant, keep it — it is better to preserve potentially useful context than to accidentally remove important information.
