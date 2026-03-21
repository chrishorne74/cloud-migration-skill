#!/usr/bin/env bash
# Install the cloud-migration Claude skill
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main"
COMMANDS_DIR="${HOME}/.claude/commands"
DATA_DIR="${COMMANDS_DIR}/cloud-migration"

echo "Installing cloud-migration skill..."

# Create directories
mkdir -p "${COMMANDS_DIR}"
mkdir -p "${DATA_DIR}/guardrails"
mkdir -p "${DATA_DIR}/criteria"
mkdir -p "${DATA_DIR}/red-flags"

# Install main skill file
curl -fsSL "${BASE_URL}/cloud-migration.md" -o "${COMMANDS_DIR}/cloud-migration.md"

# Install reference data files
curl -fsSL "${BASE_URL}/guardrails/migration-guardrails.md"  -o "${DATA_DIR}/guardrails/migration-guardrails.md"
curl -fsSL "${BASE_URL}/criteria/migration-criteria.json"    -o "${DATA_DIR}/criteria/migration-criteria.json"
curl -fsSL "${BASE_URL}/red-flags/migration-red-flags.json"  -o "${DATA_DIR}/red-flags/migration-red-flags.json"

echo "Installed to ${COMMANDS_DIR}/cloud-migration.md"
echo "Reference data installed to ${DATA_DIR}/"
echo "Restart Claude Code and invoke with: /cloud-migration"
