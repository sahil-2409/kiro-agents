#!/bin/bash
EVENT=$(cat)

COMMAND=$(echo "$EVENT" | jq -r '.tool_input.command // ""')

# Only trigger for test commands
if ! echo "$COMMAND" | grep -qiE "test|cy:run|cypress|jest|vitest|gradlew.*test|pytest|mocha"; then
  exit 0
fi

CWD=$(echo "$EVENT" | jq -r '.cwd // "."')
OUTPUT=$(echo "$EVENT" | jq -r '.tool_response.result // "No output captured"')
EXIT_STATUS=$(echo "$EVENT" | jq -r '.tool_response.exit_status // "unknown"')

# Collect git info
BRANCH=$(cd "$CWD" && git branch --show-current 2>/dev/null || echo "unknown")
COMMIT=$(cd "$CWD" && git log -1 --pretty=format:"%h - %s" 2>/dev/null || echo "unknown")

# Collect project info
PROJECT="unknown"
VERSION="0.0.0"
if [ -f "$CWD/package.json" ]; then
  PROJECT=$(jq -r '.name // "unknown"' "$CWD/package.json")
  VERSION=$(jq -r '.version // "0.0.0"' "$CWD/package.json")
elif [ -f "$CWD/settings.gradle" ]; then
  PROJECT=$(grep -oP "rootProject.name\s*=\s*'\\K[^']+" "$CWD/settings.gradle" 2>/dev/null || echo "unknown")
fi

# Load history if exists
HISTORY=""
if [ -f "$CWD/reports/history.json" ]; then
  HISTORY=$(cat "$CWD/reports/history.json")
fi

# Output instruction + data back to the active agent via STDOUT
cat << EOF
[TEST RUN DETECTED — GENERATE REPORT]

A test run just completed. Generate a full stakeholder-friendly HTML test report following these instructions:

1. Create ./reports/test-report-$(date +%Y-%m-%d)-v${VERSION}.html — a single self-contained HTML file with inline CSS/JS and Chart.js from https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js
2. Include all 7 sections: Executive Summary, Test Execution Summary, Defect Summary, Coverage Analysis, Risk Assessment, Environment & Configuration, Recommendations
3. Translate all errors to plain English — no stack traces, no technical jargon
4. Use verdict logic: pass rate ≥95% and 0 critical = "Safe to release" (green #639922), 85-94% or 1-2 critical = "Release with caution" (amber #EF9F27), <85% or 3+ critical = "Do not release" (red #E24B4A)
5. Header background: #0C447C
6. Convert to PDF: npx puppeteer-cli print ./reports/test-report-$(date +%Y-%m-%d)-v${VERSION}.html ./reports/test-report-$(date +%Y-%m-%d)-v${VERSION}.pdf --format A4 --margin-top 12mm --margin-bottom 12mm --margin-left 14mm --margin-right 14mm --print-background true
7. Update ./reports/history.json (keep last 10 entries)

DATA:
- Project: $PROJECT
- Version: $VERSION
- Date: $(date +%Y-%m-%d)
- Branch: $BRANCH
- Commit: $COMMIT
- Command: $COMMAND
- Exit status: $EXIT_STATUS
- Test output:
$OUTPUT

- Previous history:
$HISTORY
EOF

exit 0
