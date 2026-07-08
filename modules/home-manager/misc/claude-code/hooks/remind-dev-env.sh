#!/usr/bin/env bash
# SessionStart hook: remind Claude to use flake.nix + direnv-provided tools,
# and to prompt the user to create .envrc when it's missing.
set -euo pipefail

cwd="$PWD"
context=""

if [ -f "$cwd/flake.nix" ]; then
  context="このリポジトリには flake.nix があります。lint / formatter / test runner などの開発ツールは、必ず flake.nix でインストールされ direnv で有効化されたものを使ってください。グローバルにインストールされた同名コマンドを優先して使わないでください。"

  if [ ! -f "$cwd/.envrc" ]; then
    context="$context また、このリポジトリには .envrc がありません。作業を始める前にユーザーへ .envrc の作成(例: 'use flake' の追記と direnv allow の実行)を提案してください。"
  fi
fi

if [ -n "$context" ]; then
  jq -n --arg ctx "$context" '{
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: $ctx
    }
  }'
fi
