# Business Summary Example

Use this template when generating business-facing audit summaries for non-technical stakeholders (business leaders, legal/compliance, product owners, managers).

---

# Accessibility Audit — Business Summary

## 1. Executive Overview

[Plain language paragraph describing business risk and impact. No technical jargon. Focus on: what was audited, what standard was used, and the overall finding.]

- **Standard:** WCAG 2.2 Level AA
- **Audit Date:** [date]
- **Scope:** [pages/screens/templates/components assessed]

## 2. Testing Methodology

A hybrid approach was used combining automated and manual testing:

**Manual Testing:**
- Keyboard-only navigation
- Focus order and visibility checks
- Screen reader verification
- Responsive and mobile checks

**Automated Testing Suite:**
- pa11y (HTML CodeSniffer engine)
- @axe-core/cli (Deque Systems)
- Lighthouse (Google)
- html-validate (structural validation)
- accessibility-checker (IBM Equal Access)

**Environment:** [e.g., macOS Sequoia, VoiceOver, Chrome]

## 3. Summary of Key Findings

- **Critical:** [X] issues
- **High / Serious:** [X] issues
- **Medium / Moderate:** [X] issues
- **Low / Minor:** [X] issues

**Most Important User Barriers:**
- [Barrier 1 in plain language]
- [Barrier 2 in plain language]

**Compliance / Legal Exposure:**
[Summary of regulatory risk]

**Business Impact:**
[Summary of impact on customer trust, conversion, support burden, reputation]

## 4. Strategic Recommendations

### Immediate (0–30 days)
| Action | Ownership |
|--------|-----------|
| [Action item] | [Design / Frontend / QA / Content / Product] |

### Short-term (1–3 months)
| Action | Ownership |
|--------|-----------|
| [Action item] | [Design / Frontend / QA / Content / Product] |

### Medium-term (3–6 months)
| Action | Ownership |
|--------|-----------|
| [Action item] | [Design / Frontend / QA / Content / Product] |

## 5. POUR Compliance Tables

### Perceivable

| Guideline | Level | Description | Status | Location of the Problem | Description of the Problem | Recommendations | Tools | Comment |
|-----------|-------|-------------|--------|-------------------------|---------------------------|-----------------|-------|---------|
| 1.1 Text Alternatives | A | 1.1.1 Non-text Content | Pass/Fail/N/A | [Location] | [Problem description] | [Recommendation] | [manual/automated tool] | [Comment] |

### Operable

| Guideline | Level | Description | Status | Location of the Problem | Description of the Problem | Recommendations | Tools | Comment |
|-----------|-------|-------------|--------|-------------------------|---------------------------|-----------------|-------|---------|
| 2.1 Keyboard Accessible | A | 2.1.1 Keyboard | Pass/Fail/N/A | [Location] | [Problem description] | [Recommendation] | [manual/automated tool] | [Comment] |

### Understandable

| Guideline | Level | Description | Status | Location of the Problem | Description of the Problem | Recommendations | Tools | Comment |
|-----------|-------|-------------|--------|-------------------------|---------------------------|-----------------|-------|---------|
| 3.1 Readable | A | 3.1.1 Language of Page | Pass/Fail/N/A | [Location] | [Problem description] | [Recommendation] | [manual/automated tool] | [Comment] |

### Robust

| Guideline | Level | Description | Status | Location of the Problem | Description of the Problem | Recommendations | Tools | Comment |
|-----------|-------|-------------|--------|-------------------------|---------------------------|-----------------|-------|---------|
| 4.1 Compatible | AA | 4.1.2 Name, Role, Value | Pass/Fail/N/A | [Location] | [Problem description] | [Recommendation] | [manual/automated tool] | [Comment] |

## 6. Conclusion

- **Overall Conformance:** [Fully Conformant / Partially Conformant / Non-Conformant]
- **Estimated Remediation Effort:** [S / M / L or timeline estimate]
- **Recommended Re-audit Date:** [Date]
