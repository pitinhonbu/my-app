#!/bin/bash
# SessionStart: prepare Claude Code on the web sessions.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"
npm install --no-audit --no-fund

# Expose project CLIs (agent-browser, playwright, prettier) and point
# agent-browser at the container's preinstalled Chromium.
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export PATH=\"$CLAUDE_PROJECT_DIR/node_modules/.bin:\$PATH\""
    if [ -x /opt/pw-browsers/chromium ]; then
      echo "export AGENT_BROWSER_EXECUTABLE_PATH=/opt/pw-browsers/chromium"
      echo "export AGENT_BROWSER_ARGS=--no-sandbox"
    fi
  } >> "$CLAUDE_ENV_FILE"
fi
