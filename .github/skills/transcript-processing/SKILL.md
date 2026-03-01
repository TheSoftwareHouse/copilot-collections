---
name: transcript-processing
description: Clean raw workshop or meeting transcripts from small talk, filler words, and off-topic tangents. Extract and structure business-relevant content into a standardized format with discussion topics, key decisions, action items, and open questions.
---

# Transcript Processing

This skill helps you clean raw workshop or meeting transcripts and produce a structured, business-relevant document. It removes noise (small talk, greetings, filler words, off-topic tangents) while preserving all actionable and business-critical discussion points.

## Transcript Processing Process

Use the checklist below and track your progress:

```
Processing progress:
- [ ] Step 1: Identify transcript format and meeting metadata
- [ ] Step 2: Identify and tag participants
- [ ] Step 3: Remove non-business content
- [ ] Step 4: Group remaining content by discussion topics
- [ ] Step 5: Extract key decisions
- [ ] Step 6: Extract action items and open questions
- [ ] Step 7: Preserve critical raw context
- [ ] Step 8: Save the cleaned transcript
```

**Step 1: Identify transcript format and meeting metadata**

Determine the format of the raw transcript:
- Speaker-labelled transcript (e.g., `[Speaker Name]: text`)
- Plain text notes without speaker labels
- Timestamped transcript (e.g., `[00:12:34] text`)
- Mixed format
- PDF document (transcript or meeting notes exported/provided as PDF — use `pdf-reader` tool to extract text content first)

Extract meeting metadata where available:
- Date and time of the workshop
- Duration (if timestamps are present, calculate from first to last entry)
- Workshop topic or title
- Context (e.g., "Discovery workshop for Project X, Sprint 3 planning")

If metadata is not explicitly stated in the transcript, ask the user to provide it.

**Step 2: Identify and tag participants**

Scan the transcript for participant names or speaker labels. For each participant:
- Note their name or identifier
- Infer their role if mentioned or obvious from context (e.g., "Product Owner", "Developer", "Client stakeholder")
- If roles are not clear, list participants without roles — do not guess

**Step 3: Remove non-business content**

Systematically identify and remove:
- **Greetings and sign-offs**: "Hi everyone", "Let's wrap up", "Have a good weekend"
- **Small talk**: Weather, personal anecdotes, unrelated banter
- **Filler words and verbal tics**: "um", "uh", "you know", "like" (when used as filler)
- **Technical difficulties discussion**: "Can you hear me?", "Let me share my screen", "You're on mute"
- **Off-topic tangents**: Discussions clearly unrelated to the workshop's purpose
- **Repetitive restatements**: When the same point is made multiple times, keep the clearest version

**Important**: When in doubt about whether content is business-relevant, **keep it**. It is better to preserve potentially useful context than to accidentally remove important information.

**Step 4: Group remaining content by discussion topics**

Analyze the cleaned content and organize it into logical discussion topics:
- Identify natural topic boundaries (when the conversation shifts to a new subject)
- Create descriptive topic headings that summarize the theme
- Under each topic, list the key points discussed as bullet points
- Attribute points to speakers when speaker labels are available
- Maintain chronological order within each topic
- If a topic spans multiple disconnected parts of the transcript, consolidate them under one heading

**Step 5: Extract key decisions**

Review the structured content and identify explicit and implicit decisions:
- **Explicit decisions**: Statements like "We agreed to...", "The decision is...", "Let's go with..."
- **Implicit decisions**: When discussion converges on a direction without formal declaration
- For each decision, note:
  - What was decided
  - Who made or endorsed the decision (if clear)
  - Any conditions or caveats attached

**Step 6: Extract action items and open questions**

Scan for action items:
- Commitments to do something (e.g., "I'll prepare the wireframes by Friday")
- Assigned tasks (e.g., "Can you check the API documentation?")
- For each action item, note: what, who (if assigned), and any deadline mentioned

Scan for open questions:
- Unanswered questions raised during the workshop
- Items deferred for later discussion ("We'll revisit this next week")
- Ambiguities that were acknowledged but not resolved

**Step 7: Preserve critical raw context**

Identify and preserve exact quotes or passages where the original wording is important:
- Requirements stated in specific business language
- Constraints or limitations mentioned by stakeholders
- Conflicting viewpoints that need to be captured verbatim
- Domain-specific terminology defined or explained during the workshop

Place these in a "Preserved Context" section with attribution to the speaker.

**Step 8: Save the cleaned transcript**

Generate the final output following the `./cleaned-transcript.example.md` template.

Save the file to `specifications/<workshop-name>/cleaned-transcript.md`.

Review the output to ensure:
- No business-relevant content was accidentally removed
- Topics are logically grouped and clearly labelled
- Decisions, action items, and open questions are complete
- The document is readable and useful as a standalone reference

## Connected Skills

- `task-extracting` - uses the cleaned transcript as a primary input for identifying epics and stories
