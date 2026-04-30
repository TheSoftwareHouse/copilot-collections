# React Native Accessibility Patterns

Accessibility patterns for the `tsh-implementing-react-native` skill. Load this reference when implementing accessible mobile components or verifying accessibility compliance on iOS (VoiceOver) and Android (TalkBack).

## Table of Contents

- [Core Props](#core-props)
- [Component Patterns](#component-patterns)
- [Focus Management](#focus-management)
- [Announcements](#announcements)
- [Testing with Assistive Technology](#testing-with-assistive-technology)
- [Platform Differences](#platform-differences)
- [Accessibility Checklist](#accessibility-checklist)
- [Anti-Patterns](#anti-patterns)

## Core Props

React Native exposes accessibility through props on `View`, `Text`, `Pressable`, and other components.

| Prop | Purpose | Example |
|------|---------|---------|
| `accessible` | Marks a view as an accessibility element (groups children) | `accessible={true}` |
| `accessibilityLabel` | Text read by screen reader (replaces visible text) | `accessibilityLabel="Close dialog"` |
| `accessibilityHint` | Describes the result of the action | `accessibilityHint="Removes item from cart"` |
| `accessibilityRole` | Communicates the element type | `accessibilityRole="button"` |
| `accessibilityState` | Communicates current state | `accessibilityState={{ disabled: true, selected: true }}` |
| `accessibilityValue` | Communicates value (sliders, progress) | `accessibilityValue={{ min: 0, max: 100, now: 50 }}` |
| `accessibilityActions` | Custom actions available via rotor/menu | See Custom Actions section |
| `accessibilityLiveRegion` | Announces dynamic changes (Android) | `accessibilityLiveRegion="polite"` |
| `importantForAccessibility` | Controls element visibility in a11y tree (Android) | `importantForAccessibility="no-hide-descendants"` |
| `accessibilityElementsHidden` | Hides elements from a11y tree (iOS) | `accessibilityElementsHidden={true}` |
| `accessibilityViewIsModal` | Limits a11y focus to this view (iOS modal) | `accessibilityViewIsModal={true}` |

## Component Patterns

### Buttons and Pressables

```typescript
<Pressable
  accessibilityRole="button"
  accessibilityLabel="Add to favorites"
  accessibilityHint="Saves this restaurant to your favorites list"
  accessibilityState={{ disabled: isLoading }}
  disabled={isLoading}
  onPress={handleAdd}
>
  <HeartIcon />
</Pressable>
```

Rules:
- Every `Pressable` must have `accessibilityRole="button"` (or appropriate role).
- Icon-only buttons require `accessibilityLabel`.
- If the button label is visible text, the label is read automatically — no `accessibilityLabel` needed.
- Communicate disabled state via both `disabled` prop and `accessibilityState={{ disabled: true }}`.

### Images

```typescript
// Informative image — describe the content
<Image
  source={productImage}
  accessibilityLabel="Red running shoe, side view"
  accessibilityRole="image"
/>

// Decorative image — hide from screen reader
<Image
  source={decorativeBorder}
  accessible={false}
  importantForAccessibility="no"  // Android
  accessibilityElementsHidden={true}  // iOS
/>
```

### Grouped Elements

Use `accessible={true}` on a parent `View` to group related elements into a single accessibility focus stop:

```typescript
// Screen reader reads: "John Smith, Senior Developer, 4.8 stars"
<View accessible={true} accessibilityLabel="John Smith, Senior Developer, 4.8 stars">
  <Text>John Smith</Text>
  <Text>Senior Developer</Text>
  <StarRating value={4.8} />
</View>
```

Group when:
- Child elements together form one semantic unit (a card header, a list item)
- Individual children are not independently interactive

Do NOT group when:
- Children are independently actionable (each has its own `onPress`)
- Users need to navigate between children

### Toggle / Switch

```typescript
<Switch
  value={isEnabled}
  onValueChange={setIsEnabled}
  accessibilityRole="switch"
  accessibilityLabel="Dark mode"
  accessibilityState={{ checked: isEnabled }}
/>
```

### Tab Navigation

```typescript
<Pressable
  accessibilityRole="tab"
  accessibilityState={{ selected: isActive }}
  accessibilityLabel={`${tabName} tab`}
  onPress={() => setActiveTab(tabName)}
>
  <Text>{tabName}</Text>
</Pressable>
```

### Headers / Headings

```typescript
<Text accessibilityRole="header">Section Title</Text>
```

Screen reader users can navigate between headers to scan page structure — use `accessibilityRole="header"` on section titles.

## Focus Management

### Programmatic Focus

Use `AccessibilityInfo` and ref-based focus for context changes:

```typescript
import { AccessibilityInfo, findNodeHandle } from 'react-native';

const errorRef = useRef<View>(null);

const onSubmitError = () => {
  const node = findNodeHandle(errorRef.current);
  if (node) {
    AccessibilityInfo.setAccessibilityFocus(node);
  }
};

<View ref={errorRef} accessible accessibilityRole="alert">
  <Text>Please correct the errors above</Text>
</View>
```

Move focus when:
- Modal/bottom sheet opens → focus the title or first element inside
- Modal closes → return focus to the trigger
- Navigation occurs → focus the screen title or main content
- Error appears → focus the error summary
- Content is dynamically inserted → announce or focus it

### Modal Focus Trapping (iOS)

```typescript
<View accessibilityViewIsModal={true}>
  {/* iOS VoiceOver will not escape this container */}
  <ModalContent />
</View>
```

On Android, use `importantForAccessibility="no-hide-descendants"` on the content behind the modal:

```typescript
<View importantForAccessibility={isModalOpen ? 'no-hide-descendants' : 'auto'}>
  <MainContent />
</View>
<Modal visible={isModalOpen}>
  <ModalContent />
</Modal>
```

## Announcements

For dynamic content updates that should be read without moving focus:

```typescript
import { AccessibilityInfo } from 'react-native';

// Announce a message (both platforms)
AccessibilityInfo.announceForAccessibility('Item added to cart');

// Android: use accessibilityLiveRegion on a container
<View accessibilityLiveRegion="polite">
  <Text>{statusMessage}</Text>
</View>
```

Use announcements for:
- Toast / snackbar messages
- Background data refresh completion
- Form submission success
- Counter updates (e.g., "3 items in cart")

## Testing with Assistive Technology

### iOS — VoiceOver

1. Enable: Settings → Accessibility → VoiceOver (or triple-click side button if configured).
2. Navigate: Swipe right/left to move between elements.
3. Activate: Double-tap to press the focused element.
4. Verify:
   - Every interactive element is reachable by swiping.
   - Labels are descriptive and concise.
   - Roles announce correctly ("button", "heading", "tab").
   - States announce correctly ("dimmed" for disabled, "selected").
   - Focus order follows visual top-to-bottom, left-to-right.
   - Modals trap focus (cannot swipe to content behind).

### Android — TalkBack

1. Enable: Settings → Accessibility → TalkBack.
2. Navigate: Swipe right/left to move between elements.
3. Activate: Double-tap to press the focused element.
4. Verify:
   - Same criteria as VoiceOver above.
   - `accessibilityLiveRegion` announcements fire for dynamic updates.
   - `importantForAccessibility` correctly hides/reveals elements.

### Automated Checks

- **Expo**: Use `expo-dev-client` with accessibility inspector enabled.
- **Maestro**: Use `assertAccessibilityText` and `assertVisible` commands to verify accessibility labels are present and correct.
- **Manual audit flow**: Navigate the entire screen with the screen reader. Every element you can touch must be reachable via swipe. Every action must be completable without seeing the screen.

## Platform Differences

| Behavior | iOS (VoiceOver) | Android (TalkBack) |
|----------|-----------------|-------------------|
| Modal focus trap | `accessibilityViewIsModal={true}` | `importantForAccessibility="no-hide-descendants"` on background |
| Live announcements | `AccessibilityInfo.announceForAccessibility()` | `accessibilityLiveRegion="polite"` on container |
| Hide from a11y tree | `accessibilityElementsHidden={true}` | `importantForAccessibility="no-hide-descendants"` |
| Custom actions | Rotor actions | Local context menu |
| Minimum touch target | 44×44 pt | 48×48 dp |
| Screen reader gesture | Swipe, double-tap, rotor | Swipe, double-tap, local context menu |

## Accessibility Checklist

```
Accessibility (React Native):
- [ ] Every Pressable has accessibilityRole and accessible label
- [ ] Icon-only buttons have accessibilityLabel
- [ ] Disabled state communicated via accessibilityState={{ disabled: true }}
- [ ] Images: informative ones have labels, decorative ones hidden
- [ ] Related elements grouped with accessible={true} on parent
- [ ] Section headings use accessibilityRole="header"
- [ ] Modal traps focus (accessibilityViewIsModal on iOS, hide background on Android)
- [ ] Focus moves to modal on open, returns to trigger on close
- [ ] Dynamic updates announced (AccessibilityInfo.announceForAccessibility or liveRegion)
- [ ] Touch targets meet minimum size (44×44 pt iOS / 48×48 dp Android)
- [ ] Focus order follows visual layout (top-to-bottom, left-to-right)
- [ ] Tested full screen navigation with VoiceOver (iOS)
- [ ] Tested full screen navigation with TalkBack (Android)
- [ ] No meaningful content hidden from accessibility tree
```

## Anti-Patterns

| Anti-Pattern | Instead Do |
|--------------|-----------|
| `Pressable` without `accessibilityRole` | Always set `accessibilityRole="button"` (or appropriate role) |
| Using `accessibilityLabel` on a `Text` with visible content | Screen reader reads the text automatically — label overrides it unnecessarily |
| Grouping interactive children under `accessible={true}` parent | Keep interactive elements individually focusable |
| Missing `accessibilityState` for disabled/selected/checked | Always reflect interactive state in `accessibilityState` |
| Using `accessibilityHint` for essential info | Hints are optional — put essential info in `accessibilityLabel` |
| Decorative images without hiding from a11y tree | Set `accessible={false}` + platform-specific hiding props |
| Hardcoded touch target < 44×44 pt / 48×48 dp | Ensure minimum `hitSlop` or explicit sizing |
| No focus management on modal open/close | Move focus to modal content on open, return on close |
