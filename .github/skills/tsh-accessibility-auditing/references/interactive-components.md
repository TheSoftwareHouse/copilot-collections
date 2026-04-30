# Interactive Component Accessibility Patterns

These components are the most frequent sources of accessibility failures. Verify each using the [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/).

## Modals / Dialogs
- Must have `role="dialog"` and `aria-modal="true"` (or use `<dialog>`)
- Focus must move into the modal on open
- Focus must be trapped inside the modal while open
- `Escape` must close the modal
- Focus must return to the triggering element on close
- Background content must be inert (`inert` attribute or `aria-hidden="true"`)

## Tabs
- Tab list: `role="tablist"` on the container
- Each tab: `role="tab"`, `aria-selected="true/false"`, `aria-controls="panel-id"`
- Each panel: `role="tabpanel"`, `aria-labelledby="tab-id"`
- Arrow keys switch between tabs; `Tab` key moves into the active panel

## Accordions
- Trigger: `<button>` with `aria-expanded="true/false"` and `aria-controls="panel-id"`
- Panel: has a unique `id` matching the `aria-controls` value
- Heading level must fit the document hierarchy

## Carousels / Sliders
- Must have pause/stop controls if auto-advancing
- Previous/Next buttons must have accessible names
- Current slide must be announced (e.g., "Slide 2 of 5" via `aria-live="polite"` or `aria-label`)
- Must be operable with keyboard (arrow keys or buttons)

## Dropdown Menus / Navigation
- `aria-expanded` on the trigger button
- `Escape` closes the menu
- Arrow keys navigate menu items
- For navigation, prefer simple `<ul>` lists with disclosure buttons rather than ARIA menu roles

## Tooltips
- Must be triggered on focus (not just hover)
- Must be dismissable with `Escape` (SC 1.4.13 Content on Hover or Focus)
- Use `role="tooltip"` and link via `aria-describedby`

## Forms
- Every input has a visible `<label>` (or `aria-label` / `aria-labelledby`)
- Required fields: use `aria-required="true"` or `required` attribute
- Error messages: linked via `aria-describedby` or `aria-errormessage` with `aria-invalid="true"` on the field
- Group related fields with `<fieldset>` + `<legend>` (e.g., radio groups, address blocks)
- Use `autocomplete` attribute on personal data fields (name, email, address)
