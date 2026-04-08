#!/bin/bash
EVENT=$(cat)

COMMAND=$(echo "$EVENT" | jq -r '.tool_input.command // ""')

# Only trigger for test commands
if echo "$COMMAND" | grep -qiE "test|cy:run|cypress|jest|vitest|gradlew.*test|pytest|mocha"; then
  EXIT_STATUS=$(echo "$EVENT" | jq -r '.tool_response.exit_status // "unknown"')
  OUTPUT=$(echo "$EVENT" | jq -r '.tool_response.result // "No output captured"')

  echo "TEST_RUN_DETECTED"
  echo "COMMAND: $COMMAND"
  echo "EXIT_STATUS: $EXIT_STATUS"
  echo "OUTPUT:"
  echo "$OUTPUT"
fi

exit 0
