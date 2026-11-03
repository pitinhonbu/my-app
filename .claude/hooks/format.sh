#!/bin/bash
# PostToolUse (Edit|Write): format the edited file with Prettier.
# Never blocks Claude: formatting failures are ignored.
FILE_PATH=$(jq -r '.tool_input.file_path // empty')
PRETTIER="$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier"

if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ] && [ -x "$PRETTIER" ]; then
  cd "$CLAUDE_PROJECT_DIR" && "$PRETTIER" --write --ignore-unknown --log-level warn "$FILE_PATH" >&2 || true
fi
exit 0
