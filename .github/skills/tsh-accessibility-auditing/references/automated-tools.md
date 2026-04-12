# Automated Accessibility Testing Tools

No single tool detects more than ~30-40% of accessibility issues. Always run at least 2-3 tools per audit.

## Tool Overview

| Tool | License | Repository | Description |
|---|---|---|---|
| pa11y | LGPL-3.0 | github.com/pa11y/pa11y | WCAG audit powered by HTML CodeSniffer |
| @axe-core/cli | MPL-2.0 | github.com/dequelabs/axe-core | Industry standard, broadest a11y rule set |
| Lighthouse | Apache-2.0 | github.com/GoogleChrome/lighthouse | a11y + performance + SEO audit (Google) |
| html-validate | MIT | github.com/html-validate/html-validate | HTML semantics validation, structural errors |
| accessibility-checker | Apache-2.0 | github.com/IBMa/equal-access | IBM rules, complementary to axe-core |

All tools are free, open-source, and safe for commercial use.

## Installation

```bash
npm install -g pa11y @axe-core/cli lighthouse html-validate accessibility-checker
```

## Usage Examples

### pa11y
```bash
# Basic WCAG 2.0 AA audit
pa11y https://example.com --standard WCAG2AA

# JSON output for programmatic processing
pa11y https://example.com --standard WCAG2AA --reporter json

# Against local dev server
pa11y http://localhost:3000 --standard WCAG2AA
```

### axe-core
```bash
# Basic audit with WCAG tags
axe https://example.com --tags wcag2a,wcag2aa

# Save JSON report
axe https://example.com --tags wcag2a,wcag2aa --save /tmp/axe-report.json

# Against local dev server
axe http://localhost:3000 --tags wcag2a,wcag2aa
```

### Lighthouse
```bash
# Accessibility-only audit
lighthouse https://example.com --only-categories=accessibility --output=cli --chrome-flags="--headless --no-sandbox"

# Against local dev server
lighthouse http://localhost:3000 --only-categories=accessibility --output=cli --chrome-flags="--headless --no-sandbox"
```

### html-validate
```bash
# Validate from stdin (fetched HTML)
curl -s https://example.com | html-validate --stdin

# Validate local HTML files
html-validate src/**/*.html
```

### accessibility-checker (IBM)
```bash
achecker https://example.com
```
