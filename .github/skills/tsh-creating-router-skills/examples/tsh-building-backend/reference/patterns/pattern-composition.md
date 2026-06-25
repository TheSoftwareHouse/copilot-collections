<!-- markdownlint-disable MD033 MD024 -->

# Pattern Composition Leaf

<concept-first>
This leaf stays concept-first and abstract.
</concept-first>

<composition-and-ownership>
This leaf is for composable pattern guidance in an abstract backend domain.
</composition-and-ownership>

## Load Trigger

loaded when: the task needs composition guidance; may load alongside other applicable concern leaves

## Composition

- Combine only the primitives that actually apply.
- Keep composition rules separate from stack selection.
- Favor small, reusable shape fragments over concrete examples.

## Compatibility Notes

- Multiple patterns may load together.
- Composition should not turn into a second router.
- If a task only needs one stack choice, stay out of the way.

## Abstract Primitives

- composition boundary
- compatibility cue
- primitive merge
- handoff marker

## One-Hop Handoff

The router links here directly; the leaf stays on the pattern side of the split.

## Scaffold Notes

This leaf is composable: the router may load it alongside other applicable concern leaves.
