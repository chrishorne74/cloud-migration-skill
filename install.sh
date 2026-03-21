#!/usr/bin/env bash
# Install the cloud-migration Claude skill
set -euo pipefail

COMMANDS_DIR="${HOME}/.claude/commands"
SKILL_URL="https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main/cloud-migration.md"

echo "Installing cloud-migration skill..."
mkdir -p "${COMMANDS_DIR}"
curl -fsSL "${SKILL_URL}" -o "${COMMANDS_DIR}/cloud-migration.md"
echo "✅ Installed to ${COMMANDS_DIR}/cloud-migration.md"
echo "   Restart Claude Code and invoke with: /cloud-migration"
