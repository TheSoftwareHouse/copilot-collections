# Regression Test Suite — Hiber (HiberHilo) App

**Last updated:** 13 April 2026
**Platforms:** iOS, Android
**Test devices:** Samsung S21 (Android 14), Samsung Galaxy S24 Ultra (Android 16), iPhone 16 (iOS 26), iPad (iOS 26)
**Status legend:** P = Pass, F = Fail, B = Blocked, N/A = Not applicable

---

## 1. Authentication & Session Management

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-001 | Login with valid credentials | 1. Open app<br>2. Enter valid email and password<br>3. Tap Log In | User is redirected to Main view and logged in | | |
| R-002 | Login with invalid credentials | 1. Open app<br>2. Enter wrong email/password<br>3. Tap Log In | Validation error displayed under input field | | |
| R-003 | Forgot password link | 1. Open app<br>2. Tap "Forgot password" / "Contact our support" | User is redirected to support.hiber.global in browser | | |
| R-004 | Password visibility toggle | 1. Open app<br>2. Enter password<br>3. Tap show/hide password icon | Password text toggles between hidden and visible | | |
| R-005 | Session persistence — valid token | 1. Log in<br>2. Close app<br>3. Reopen app | User is still logged in, lands on Main view | | |
| R-006 | Session expiry — expired JWT | 1. Log in<br>2. Wait for JWT to expire<br>3. Reopen app | User is redirected to login screen or offline mode if previously logged in | | |
| R-007 | Offline access — valid past login | 1. Log in at least once while online<br>2. Go offline<br>3. Reopen app | User can access offline mode with locally stored data | | |
| R-008 | No offline access — no prior login | 1. Fresh install, never logged in<br>2. Open app without internet | User cannot access offline mode. Must connect to internet to log in | | |
| R-009 | Sign out | 1. Navigate to Settings<br>2. Tap Sign Out | User is logged out and redirected to login screen | | |
| R-010 | Remote log-out (HIB-114) | 1. Remote log-out triggered for user<br>2. User opens app | User is logged out and must re-authenticate | | |
| R-011 | MFA login flow (HIB-189) | 1. Open app<br>2. Enter valid credentials<br>3. Complete MFA challenge | User completes MFA and lands on Main view | | |
| R-012 | T&C — first login (HIB-109) | 1. Log in for the first time<br>2. Review T&C modal<br>3. Check acceptance checkbox<br>4. Tap Accept | Modal displayed with checkbox. Accept enabled only after check. User proceeds to dashboard | | |
| R-013 | T&C — subsequent login | 1. Log in after T&C already accepted | T&C modal does NOT appear, user goes directly to Main view | | |
| R-014 | T&C — viewable in Settings | 1. Navigate to Settings<br>2. Tap Terms & Conditions / Privacy Policy | T&C and Privacy Policy text displayed within app | | |

---

## 2. Main View — Device Lists

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-015 | ALL PRODUCTS tab — device groups | 1. Log in<br>2. Land on Main view<br>3. Check ALL PRODUCTS tab | All device groups displayed with picture, name, and ID | | |
| R-016 | MY PRODUCTS tab — assigned devices | 1. Tap MY PRODUCTS tab | Assigned devices listed with serial number, name, image, and status. Device count visible in tab name | | |
| R-017 | MY PRODUCTS — search by serial number | 1. Tap MY PRODUCTS tab<br>2. Enter serial number in search | List filtered to matching device(s) | | |
| R-018 | MY PRODUCTS — empty state | 1. Log in with user having no assigned devices<br>2. Tap MY PRODUCTS tab | Empty state displayed | | |
| R-019 | MY PRODUCTS — scroll/pagination | 1. User with large number of devices<br>2. Scroll through list | Infinite scroll / pagination works smoothly | | |
| R-020 | MY PRODUCTS — performance 1000+ devices | 1. Log in with user having 1000+ assigned devices<br>2. Scroll and search through list | App responds without significant lag or crashes | | |
| R-021 | Lifecycle status prioritization (HIB-112) | 1. User has devices with PENDING_MAINTENANCE / PENDING_REPLACEMENT<br>2. View MY PRODUCTS | Devices needing attention displayed at top with highlighted badge | | |
| R-022 | Device status labels — all statuses | 1. Verify devices with all statuses: ACCEPTANCE_TESTING, READY_TO_INSTALL, INSTALLED, PAUSED, DEFECTIVE, SPARE, DECOMMISSIONED | Each status displays correct label/badge | | |
| R-023 | Pull-to-refresh device list | 1. Pull down on device list | List refreshes with updated data from backend | | |
| R-024 | Device filtering — org/status (HIB-50) | 1. View device list | Only devices in user's organization with proper status are shown | | |

---

## 3. Bluetooth Connection

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-025 | Connect to device from MY PRODUCTS | 1. Tap device in MY PRODUCTS<br>2. App navigates to Connect screen | Connect screen shows "Connecting" state. Connection established | | |
| R-026 | Simplified BT — Add device (HIB-113) | 1. Tap "Add device"<br>2. App navigates to Search screen<br>3. Found devices listed<br>4. Tap "Add device" on found device | User redirected to Connect screen with Connecting state | | |
| R-027 | BT permission prompt — first connection | 1. Connect for first time | Bluetooth permission dialog appears | | |
| R-028 | BT connection failure — retry | 1. Attempt connection when device out of range | Error displayed with retry option | | |
| R-029 | BT connection timeout | 1. Attempt connection<br>2. Wait 30 seconds | Timeout message displayed ("Are you still there?") | | |
| R-030 | Auto-disconnect on back (HIB-86) | 1. Connect to device<br>2. Navigate back to main screen | Device automatically disconnected | | |
| R-031 | Manual BT disconnect — confirmation modal | 1. Connect to device via BT<br>2. Tap "Disconnect" button<br>3. Modal appears with Cancel / Confirm<br>4. Tap Confirm | Device disconnected. User redirected to Main View | | |

---

## 4. Installation Flow

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-032 | Start installation — READY_TO_INSTALL | 1. Tap READY_TO_INSTALL device in MY PRODUCTS | Installation flow starts for that device | | |
| R-033 | Step-by-step navigation | 1. Start installation<br>2. Navigate through steps via Yes/Next | Each step renders with correct text, images, instructions. Progress indicator accurate | | |
| R-034 | "No" response on step | 1. During installation, tap "No" on a step | Confirmation modal with "Go to support page" and "Exit" options | | |
| R-035 | Add note | 1. During installation, tap "Add Note"<br>2. Write note<br>3. Save | Modal opens, note saved. Button changes to "Edit note" | | |
| R-036 | Add photo — camera | 1. During installation, tap "Add Photo"<br>2. Take photo | System camera opens, photo captured and attached | | |
| R-037 | Add photo — gallery | 1. During installation, tap "Add Photo"<br>2. Select from gallery | Photo selected and attached | | |
| R-038 | Connectivity check step | 1. Reach connectivity check step<br>2. Tap "No" | First modal displayed. Third "No" displays second modal | | |
| R-039 | Mandatory photo/note step | 1. Reach mandatory step<br>2. Try to proceed without photo/note | Button disabled until both photo and note provided | | |
| R-040 | Complete installation flow | 1. Complete all installation steps<br>2. Tap "Complete installation" | Success page displayed. Device status changes to INSTALLED | | |
| R-041 | Reconnect to device after installation | 1. Complete installation flow<br>2. On success page, tap "Re-connect Device" | Device Details view displayed for the installed device | | |
| R-042 | Cancel mid-flow | 1. Tap back arrow during installation | Confirmation modal to cancel installation displayed | | |
| R-043 | Loading modal during upload (HIB-83) | 1. Complete installation with photos<br>2. App uploads data | Loading modal displayed during upload. Tap OK to proceed | | |
| R-044 | Location selection (HIB-115) | 1. During installation, reach location selection step | User can select/set installation location | | |
| R-045 | Photo instructions modal (HIB-194) | 1. During installation, view photo instruction | Photo instruction modal displayed correctly | | |
| R-046 | Save photos to gallery (HIB-195) | 1. Take photo during installation | Photo saved to device gallery | | |

---

## 5. Maintenance Flow

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-047 | Start — battery replacement | 1. Navigate to Device Details<br>2. Tap Maintenance<br>3. Select Battery replacement | Battery replacement flow starts | | |
| R-048 | Start — visual inspection | 1. Navigate to Device Details<br>2. Tap Maintenance<br>3. Select Visual Inspection | Visual inspection flow starts | | |
| R-049 | Step navigation Yes/No | 1. Progress through maintenance steps | Steps render correctly. "No" displays tip or support modal depending on step | | |
| R-050 | Notes and photos | 1. Add notes and photos during maintenance | Notes and photos captured same as installation flow | | |
| R-051 | Finish disabled without data (HIB-87) | 1. Reach last step of Visual Inspection<br>2. Try to finish without note/photo | "Yes (Finish)" button disabled until note and photo provided | | |
| R-052 | Instructional videos play offline | 1. Go offline<br>2. Start battery replacement or visual inspection<br>3. Reach step with instructional video<br>4. Tap play | Video plays without internet connection | | |
| R-053 | Maintenance completion | 1. Complete maintenance flow | Success screen with "Back to Main View" and "Contact Support" options | | |
| R-054 | Battery replacement without BT (HIB-108) | 1. Fail to connect via Bluetooth<br>2. See connection issue screen<br>3. Tap Troubleshooting | Replace Battery flow initiated bypassing BT. Confirmation sent to backend | | |

---

## 6. Device Details

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-055 | All elements visible | 1. Navigate to installed device details | Sensor image, maintenance button, disconnect button, serial number, battery status, activation state, acquisition period all visible | | |
| R-056 | Empty state (not installed) | 1. Navigate to device that is not installed | Empty state variant displayed | | |
| R-057 | Change acquisition period | 1. In Device Details<br>2. Change acquisition period (5min–240min) | Acquisition period updates successfully | | |
| R-058 | Activate/deactivate device | 1. In Device Details<br>2. Toggle activation state | Device activates/deactivates with appropriate confirmation | | |
| R-059 | Disconnect device | 1. In Device Details<br>2. Tap Disconnect | Device disconnected, user returned to main view | | |
| R-060 | Trigger new measurement (HIB-118) | 1. In Device Details<br>2. Trigger new measurement | New measurement triggered and result displayed | | |
| R-061 | Decommission sensor (HIB-119) | 1. In Device Details<br>2. Tap Decommission<br>3. Confirm | Sensor decommissioned, status updated | | |
| R-062 | BGAN RSSI via Webview (HIB-120) | 1. Navigate to BGAN device details<br>2. Open RSSI webview | RSSI data displayed correctly in webview | | |
| R-063 | Device reinstallation | 1. In Device Settings<br>2. Tap Device Reinstallation | Reinstallation flow initiated | | |
| R-064 | Device settings update (HIB-196) | 1. In Device Details<br>2. Access device settings | Updated settings UI with separate button displayed correctly | | |

---

## 7. Firmware Update (HIB-106)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-065 | FW update indicator on device list | 1. View MY PRODUCTS<br>2. Device has pending FW update | Device shows FW update indicator | | |
| R-066 | FW update — start | 1. Connect to device<br>2. View Device Details with FW update available<br>3. Tap "Update Firmware" | Update modal appears with Start/Cancel options | | |
| R-067 | FW update — progress bar | 1. Confirm FW update | Progress bar with estimated time. Cannot cancel during update | | |
| R-068 | FW update — completion & reconnect | 1. FW update completes<br>2. Device reboots | Success screen with reconnect info. Timer before redirect | | |
| R-069 | FW update — verify new version | 1. Reconnect after FW update<br>2. Check Device Details | New FW version displayed. Backend notified | | |
| R-070 | FW update failure — retry | 1. FW update fails mid-transfer | Modal with "Try Again" and "Contact Support". Device not unusable | | |
| R-071 | FW update — BLE disconnect | 1. BLE disconnects during FW update | User disconnected and redirected to main page | | |

---

## 8. User Settings

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-072 | User info displayed (HIB-74) | 1. Navigate to Settings | User name, email, and organization displayed | | |
| R-073 | Pressure unit (Bar/Psi/kPa) | 1. Navigate to Settings<br>2. Change pressure unit | Unit changes reflected throughout app | | |
| R-074 | Temperature unit (°C/°F) | 1. Navigate to Settings<br>2. Change temperature unit | Unit changes reflected throughout app | | |
| R-075 | Language switcher EN/ES (HIB-104) | 1. Navigate to Settings<br>2. Switch language to Spanish | App UI changes to Spanish. Switch back works | | |
| R-076 | Sign out | 1. Navigate to Settings<br>2. Tap Sign Out | User logged out, redirected to login screen | | |

---

## 9. Feedback System (HIB-184)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-077 | After installation flow | 1. Complete installation flow | Feedback prompt displayed | | |
| R-078 | After maintenance flow | 1. Complete maintenance flow | Feedback prompt displayed | | |
| R-079 | In User Settings | 1. Navigate to Settings | Feedback option visible and accessible | | |
| R-080 | ALL PRODUCTS tab (30-day rule) | 1. Navigate to ALL PRODUCTS tab | Feedback displayed once every 30 days | | |
| R-081 | Like/dislike immediate request | 1. Tap Like or Dislike | Request sent immediately with selected value | | |
| R-082 | Cooldown after reaction | 1. Select Like<br>2. Immediately try to change to Dislike | Change prevented during cooldown period | | |
| R-083 | Textarea revealed after reaction | 1. Select Like or Dislike | Comment textarea becomes visible (hidden by default) | | |
| R-084 | Comment 2000 char limit | 1. Select reaction<br>2. Type more than 2000 characters | Input limited/stopped at 2000 characters | | |
| R-085 | Comment sent independently | 1. Select reaction<br>2. Type comment<br>3. Tap "Send feedback" | Separate request sent with comment. NOT sent automatically | | |

---

## 10. Notifications & Error Handling

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-086 | Success notification | 1. Complete an action triggering success | Success notification displayed | | |
| R-087 | Warning notification | 1. Trigger a warning condition | Warning notification displayed | | |
| R-088 | Error notification | 1. Trigger an error condition | Error notification displayed | | |
| R-089 | Error banners (HIB-188) | 1. Trigger error scenarios across flows | Error banners display correctly per updated design | | |
| R-090 | Button delay/debounce (HIB-187) | 1. Tap action buttons rapidly | No duplicate actions; button has appropriate delay | | |

---

## 11. Offline Mode (HIB-193)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-091 | MY PRODUCTS list available offline | 1. Go offline<br>2. Open MY PRODUCTS tab | Previously synced devices displayed from local storage | | |
| R-092 | Installation flow works offline | 1. Start installation while offline<br>2. Complete flow | Flow completes offline. Data stored locally. Status → INSTALLED | | |
| R-093 | Maintenance flow works offline | 1. Start maintenance while offline<br>2. Complete flow | Flow completes offline. Data stored locally | | |
| R-094 | Data sync when back online (HIB-116) | 1. Complete flows offline<br>2. Reconnect to internet | Stored data automatically synced to backend | | |
| R-095 | Loading modal NOT shown offline (HIB-83) | 1. Complete flow with photos while offline | Upload loading modal NOT displayed while offline | | |
| R-096 | Photo/note sync (HIB-186) | 1. Take photos and write notes offline<br>2. Go online | Photos and notes synced per adjusted sync logic | | |

---

## 12. Multitech Gateway (HIB-225)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-097 | 4 variants in ALL PRODUCTS | 1. Navigate to ALL PRODUCTS<br>2. Scroll to Multitech gateways | AA bgan, AC Cellular 4g, DC bgan, DC Cellular 4g listed with correct assets | | |
| R-098 | Visible in MY PRODUCTS | 1. Tap MY PRODUCTS with assigned Multitech devices | Multitech devices listed with correct status | | |
| R-099 | Installation flow (no BT) | 1. Start installation for any Multitech variant<br>2. Complete all steps | Flow renders from JSON guide. No BT steps. Completes successfully | | |
| R-100 | INSTALLED opens device view | 1. Tap INSTALLED Multitech device in MY PRODUCTS | Basic device view displayed, not installation flow | | |

---

## 13. BBB Temperature Sensor (HIB-190)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-101 | BBB temp sensor in device lists | 1. View ALL PRODUCTS and MY PRODUCTS | BBB temperature sensor listed with correct image and info | | |
| R-102 | BBB temp sensor — installation | 1. Start installation for BBB temperature sensor | Installation flow works correctly | | |

---

## 14. Adding Gateway Device (HIB-171)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-103 | Gateway device — visible in lists | 1. View ALL PRODUCTS / MY PRODUCTS | Gateway device type listed correctly | | |
| R-104 | Gateway device — installation | 1. Start adding gateway device | Flow completes using guide/step content | | |

---

## 15. Retrofitting Device (HIB-191)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-105 | Retrofitting — flow available | 1. Navigate to eligible device<br>2. Start retrofitting flow | Flow available and renders correctly | | |
| R-106 | Retrofitting — complete flow | 1. Complete all retrofitting steps | Flow completes successfully, status updated | | |

---

## 16. Force Update on Wi-Fi (HIB-192)

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-107 | Force update — prompt displayed | 1. App detects mandatory update<br>2. User is on Wi-Fi | Force update prompt displayed | | |
| R-108 | Force update — cannot bypass | 1. Dismiss/ignore force update prompt | User cannot proceed until update applied | | |

---

## 17. Cross-Cutting Concerns

| # | Test Case | Steps | Expected Result | iOS | Android |
|---|---|---|---|---|---|
| R-109 | App icon displays as HiberHilo | 1. Check app icon on device home screen | Correct icon and name "HiberHilo" displayed | | |
| R-110 | Splash screen on launch | 1. Open app | Splash screen displayed before login/main view | | |
| R-111 | Translations — EN locale | 1. Set language to English<br>2. Navigate all screens | No missing translations or raw keys visible | | |
| R-112 | Translations — ES locale | 1. Set language to Spanish<br>2. Navigate all screens | No missing translations or raw keys visible | | |
| R-113 | App version in API calls (HIB-185) | 1. Monitor API calls via proxy | All API calls include app version number | | |
| R-114 | Multiple login providers (HIB-121) | 1. Attempt login with configured provider | Authentication succeeds via configured provider | | |
| R-115 | Textarea usability — long text | 1. Navigate to any textarea<br>2. Type long text | Textarea fully visible and scrollable. Not obscured | | |
| R-116 | Device rotation | 1. Rotate device portrait ↔ landscape on key screens | UI adapts, no overflow, no data loss | | |
| R-117 | Kill app and reopen | 1. Force-kill app during any flow<br>2. Reopen | App recovers gracefully, no data corruption | | |
| R-118 | Network loss mid-operation | 1. Perform action<br>2. Lose network mid-way | Appropriate error or offline handling. No crash | | |
