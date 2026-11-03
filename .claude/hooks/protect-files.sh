#!/bin/bash
# PreToolUse (Edit|Write): block direct edits to secrets, the lockfile and git internals.
# Exit code 2 blocks the tool call and shows stderr to Claude.
FILE_PATH=$(jq -r '.tool_input.file_path // empty')
FILE_PATH="${FILE_PATH//\\//}"
NAME=$(basename "$FILE_PATH")

case "$NAME" in
  .env.example) exit 0 ;;
  .env | .env.*)
    echo "Blocked: $FILE_PATH is a secrets file. Ask the user to edit it." >&2
    exit 2 ;;
  package-lock.json)
    echo "Blocked: don't edit package-lock.json by hand. Use npm install/uninstall instead." >&2
    exit 2 ;;
esac

if [[ "$FILE_PATH" == */.git/* || "$FILE_PATH" == .git/* ]]; then
  echo "Blocked: $FILE_PATH is inside .git/. Use git commands instead." >&2
  exit 2
fi
exit 0
