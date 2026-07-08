#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): force a confirmation prompt before flake.nix
# is created or modified, regardless of acceptEdits/bypassPermissions/Auto mode.
set -euo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

if [ -n "$file_path" ] && [ "$(basename -- "$file_path")" = "flake.nix" ]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "flake.nix の新規作成・更新は、Auto mode や自動承認設定であっても必ずユーザーの確認を取ってください。"
    }
  }'
fi
