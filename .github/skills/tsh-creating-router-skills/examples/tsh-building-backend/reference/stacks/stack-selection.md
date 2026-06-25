<!-- markdownlint-disable MD033 MD024 -->

# Stack Selection Leaf

<concept-first>
This leaf stays concept-first and abstract.
</concept-first>

<selection-and-ownership>
This is the direct router target for an exclusive stack choice in an abstract backend domain.
</selection-and-ownership>

## Load Trigger

loaded when: the router picks exactly one stack and the repo cues point to this one

## Selection Criteria

- Choose exactly one stack shape.
- Prefer this leaf when the decision is about stack ownership, not pattern composition.
- Keep the handoff one-hop and stop after selection.

## Ownership Boundaries

This leaf owns only stack selection, not pattern composition, not resource loading, and not backend business code.

## One-Hop Handoff

The router links here directly; this file is the end point for stack selection.

## Abstract Primitives

- stack boundary
- selection gate
- cue
- handoff marker

## Scaffold Notes

This leaf is a mutually exclusive alternative: the router loads exactly one stack leaf and does not continue to another routing layer.
