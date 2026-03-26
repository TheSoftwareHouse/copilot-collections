---
name: tsh-implementing-forms
description: Form architecture, schema-based validation, field composition, error handling, multi-step form flows, and accessible form patterns. Use when building forms, implementing validation, creating multi-step wizards, or integrating form fields with a component library.
---

# Implementing Forms

Provides patterns and workflows for building robust, accessible forms with schema-based validation, composable field components, and multi-step form flows.

<principles>

<schema-first-validation>
Define validation rules as a separate schema, co-located with but decoupled from UI code. The schema is the single source of truth for what constitutes valid data. Infer TypeScript types from schemas to eliminate drift between validation rules and form types. Never duplicate type definitions manually — derive them from the schema.
</schema-first-validation>

<progressive-disclosure-of-errors>
Show validation errors at the right moment: on field blur or form submission, not on every keystroke. Help users fix errors rather than frustrate them with premature feedback. After the first validation pass, switch to on-change validation so users see errors clear as they correct them.
</progressive-disclosure-of-errors>

<accessible-by-default>
Every form field must have a visible label. Error messages must be announced to screen readers via `role="alert"` or `aria-live` regions. The form must be fully navigable by keyboard alone — Tab through fields, Enter to submit, Escape to cancel where applicable. Associate error messages with their fields using `aria-describedby`.
</accessible-by-default>

</principles>

## Form Implementation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Define the data model
- [ ] Step 2: Build field components
- [ ] Step 3: Compose the form
- [ ] Step 4: Handle multi-step flows (if applicable)
- [ ] Step 5: Verify accessibility
```

**Step 1: Define the data model**

- Identify all fields: names, types, required vs. optional, default values.
- Define a validation schema in a co-located file (`*.schema.ts` or `validation/` directory). The schema declares every constraint: required fields, min/max lengths, patterns, custom rules, cross-field dependencies.
- Infer the form's TypeScript type directly from the schema — do not write a separate interface that duplicates the schema's structure.
- Document any async validation rules (e.g., "check if username is available") — these run on blur or submit, never on every keystroke.

**Step 2: Build field components**

Create composable field wrapper components that connect the form library's state to the component library's inputs. Each field wrapper:

- Receives the field name (and optionally the form context) as props.
- Renders a visible `<label>`, the input element, and an error message container.
- Reads touched/dirty/error state from the form library and reflects it in the UI.
- Sets accessibility attributes:
  - `aria-invalid="true"` when the field has an error.
  - `aria-describedby` pointing to the error message element's `id`.
  - `aria-required="true"` for required fields.
- Supports all relevant input types: text, select, checkbox, radio, textarea, date, file upload.
- For file inputs: hide the native `<input type="file">` visually and use a styled trigger button with `aria-label`. Display selected file name(s), size, and a remove action. Validate file type and size in the schema — reject invalid files before upload begins.
- Keeps the wrapper generic — the same field component works for different forms by accepting the field name as a parameter.

**Step 3: Compose the form**

Assemble field components into a form:

- Wrap field components with the form library's provider/context so fields can access form state.
- Add `novalidate` attribute to the `<form>` element when using custom validation — this disables browser-native validation bubbles that conflict with the form library's error display. The schema-based validation from Step 1 replaces the browser's built-in constraints.
- Handle submission flow:
  1. Validate all fields against the schema.
  2. If invalid — display errors and focus the first invalid field.
  3. If valid — transform data if needed (trim strings, format dates), then call the submit handler.
  4. During async submission: disable the submit button and show a loading indicator.
  5. On success — navigate, show confirmation, or reset form as appropriate.
  6. On server error — map API error responses to specific form fields where possible. Display unmapped errors as a form-level message.
- Prevent double submission by disabling the submit button while a submission is in flight.
- Ensure the form is submittable via the Enter key (native `<form>` behavior — do not break it with `preventDefault` on the wrong element).

**Step 4: Handle multi-step flows (if applicable)**

When a form spans multiple steps or pages:

- Split the form into discrete steps, each with its own validation schema. Only validate the fields visible in the current step.
- Persist state across steps using form-level state (component state or a store) — not URL parameters. Users must not lose data when navigating between steps.
- Validate the current step before allowing navigation to the next step. Show errors on the current step, do not allow skipping ahead past invalid steps.
- Allow back-navigation without losing previously entered data.
- Show a progress indicator (stepper, progress bar, or step labels) so users know where they are and how many steps remain.
- On the final step, submit all accumulated data from all steps together.

**Step 5: Verify accessibility**

Use the `tsh-ensuring-accessibility` skill for a thorough audit. At minimum, verify:

- Every `<input>`, `<select>`, and `<textarea>` has an associated `<label>` element (via `for`/`id` pairing or wrapping).
- Error messages use `role="alert"` or are in an `aria-live="polite"` region so screen readers announce them.
- Tab order follows the visual layout — no unexpected focus jumps.
- The form can be submitted by pressing Enter in a text field.
- Focus moves to the first invalid field after a failed submission attempt.
- Required fields are indicated both visually (e.g., asterisk) and programmatically (`aria-required`).

## Validation Timing

| Validation mode           | When to use                                                          | Behavior                                                                                                          |
| ------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| On submit                 | Simple forms, few fields                                             | Validate all fields on submit, show all errors at once                                                            |
| On blur                   | Complex forms, many required fields                                  | Validate each field when the user leaves it                                                                       |
| On change (with debounce) | Real-time feedback needed (password strength, username availability) | Validate as user types, debounced to avoid excessive checks                                                       |
| Mixed                     | Best UX for most forms                                               | Validate on blur initially; after the first error, switch to on-change so errors clear immediately when corrected |

## Error Display Patterns

| Pattern            | Description                                                                                          |
| ------------------ | ---------------------------------------------------------------------------------------------------- |
| Inline below field | Error message directly under the invalid field — most common, recommended default                    |
| Summary at top     | List of all errors at the top of the form — useful for long forms, aids screen readers               |
| Inline + summary   | Both inline and summary — best accessibility (screen reader reads summary, sighted users see inline) |
| Toast/notification | Only for server-side submission errors, never for field-level validation                             |

## Form Checklist

```
Form:
- [ ] Validation schema defined separately from UI
- [ ] TypeScript type inferred from schema (no manual duplication)
- [ ] Every field has a visible label
- [ ] Error messages shown inline below fields
- [ ] Errors announced to screen readers (role="alert" or aria-live)
- [ ] Submit button disabled during submission
- [ ] Server-side errors mapped to specific fields
- [ ] Tab order follows visual layout
- [ ] Form submittable via Enter key
- [ ] Loading state during async submission
```

## Anti-Patterns

| Anti-Pattern                              | Instead Do                                      |
| ----------------------------------------- | ----------------------------------------------- |
| Manual validation in event handlers       | Use a schema-based validation library           |
| Duplicating types between schema and form | Infer types from the schema                     |
| Showing errors on every keystroke         | Use blur or mixed-mode validation               |
| Unlabeled inputs (placeholder as label)   | Always use visible `<label>` elements           |
| Generic "Form has errors" message         | Specific per-field error messages               |
| Losing form data on back-navigation       | Persist state across steps                      |
| Ignoring server-side errors               | Map API errors to specific form fields          |
| Submit button without loading state       | Disable button + show spinner during submission |

## Connected Skills

- `tsh-implementing-frontend` — for component composition patterns and framework-specific references (form library integration, validation library choice)
- `tsh-implementing-react-native` — for React Native form implementation (KeyboardAvoidingView, mobile input patterns)
- `tsh-ensuring-accessibility` — for WCAG compliance in form fields, labels, and error announcements
- `tsh-writing-hooks` — for custom form-related hooks/composables (useFormField, useMultiStepForm)
- `tsh-reviewing-frontend` — for form-specific review criteria during code review
