#!/bin/bash
# UserPromptSubmit hook — catches destructive intent in user prompts

INPUT=$(cat)
echo "$INPUT" >> /tmp/claude-hook-debug.log

PROMPT=$(echo "$INPUT" | jq -r '.prompt // .message // .userMessage // empty' 2>/dev/null)

# Fall back to scanning the raw JSON if jq found nothing
if [ -z "$PROMPT" ]; then
  PROMPT="$INPUT"
fi

if echo "$PROMPT" | grep -iqE "delete all|destroy everything|remove all resources|wipe|nuke|drop all|destroy all"; then
  echo '{"decision": "block", "reason": "Destructive intent detected. Please use /tf-destroy for controlled infrastructure teardown."}'
  exit 2
fi
