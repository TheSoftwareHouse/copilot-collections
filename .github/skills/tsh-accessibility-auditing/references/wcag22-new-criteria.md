# WCAG 2.2 New Success Criteria

WCAG 2.2 introduces 9 new success criteria beyond WCAG 2.1. These MUST be explicitly checked in every audit.

| SC | Title | Level | What to Check |
|---|---|---|---|
| 2.4.11 | Focus Not Obscured (Minimum) | AA | When a UI component receives keyboard focus, it is not entirely hidden by author-created content (sticky headers, footers, modals, cookie banners). |
| 2.4.12 | Focus Not Obscured (Enhanced) | AAA | No part of the focused component is hidden by author-created content. |
| 2.4.13 | Focus Appearance | AAA | Focus indicator has sufficient area, contrast, and is not fully obscured. |
| 2.5.7 | Dragging Movements | AA | Any action using drag-and-drop has a single-pointer alternative (click/tap). Check sliders, sortable lists, map pans, file uploads. |
| 2.5.8 | Target Size (Minimum) | AA | Interactive targets are at least 24×24 CSS pixels, OR have sufficient spacing. Check small icons, close buttons, inline links in dense text. |
| 3.2.6 | Consistent Help | A | If help mechanisms (chat, contact, FAQ) appear on multiple pages, they are in the same relative order. |
| 3.3.7 | Redundant Entry | A | Information previously entered by the user in the same process is auto-populated or available for selection — users are not forced to re-enter it. |
| 3.3.8 | Accessible Authentication (Minimum) | AA | No cognitive function test (memorizing, transcribing, puzzle-solving) is required to log in, unless an alternative is provided (copy-paste, password manager support, biometric). Check CAPTCHAs, OTPs, custom login flows. |
| 3.3.9 | Accessible Authentication (Enhanced) | AAA | Same as 3.3.8 but with no exceptions for object/image recognition. |

> **Note:** WCAG 2.2 also removed SC 4.1.1 Parsing (it is obsolete). Do not report 4.1.1 violations.
