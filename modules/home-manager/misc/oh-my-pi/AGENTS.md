# 開発環境の利用方針 (oh-my-pi)

## 開発ツール (flake.nix / direnv)

- リポジトリで作業する際、lint・formatter・test runner などの開発ツールは、
  必ず `flake.nix` でインストールされ `direnv` で有効化されたものを使用する。
  グローバルに入っている同名コマンド (PATH 上のもの) を優先して使わない。
- 作業対象のリポジトリに `flake.nix` があるのに `.envrc` が存在しない場合は、
  作業前にユーザーへ `.envrc` の作成 (例: `echo "use flake" > .envrc && direnv allow`)
  を提案する。
  この注意はセッション開始時に hook (`hooks/pre/remind-dev-env.ts`) からも注入される。
- `flake.nix` の新規作成、または既存 `flake.nix` の編集は、Auto mode を含む
  自動承認設定 (`--auto-approve` / `tools.approvalMode: yolo`) であっても必ず
  ユーザーに確認を取ってから行う。
  この確認は hook (`hooks/pre/guard-flake-nix.ts`) によって強制される
  (UI が無いセッションではブロックされる)。

## スキルとスラッシュコマンド

| 呼び出し                         | スキル     | 用途                                          |
| -------------------------------- | ---------- | --------------------------------------------- |
| `/grill-me <テーマ>`             | `grill-me` | 仕様・設計を一問一答で詰める                  |
| `/adr <new\|list\|show\|status>` | `adr`      | `docs/adr/` の ADR を MADR 形式で管理         |
| `/skill:plan [args]`             | `plan`     | `docs/plans/` の実装計画書を作成・管理        |
| `/fanout [計画番号]`             | `fanout`   | 計画の並列可能タスクを implementer で並列実装 |
| `/next [計画番号]`               | `next`     | 計画の次の未完了タスクを1つ実装               |
| `/commit [説明]`                 | `commit`   | 作業ツリーの変更を論理単位に分割してコミット  |

- `/plan` は omp 組み込みの plan mode (`plan.enabled`) が予約しているため、
  plan スキルは `/skill:plan` で呼ぶ。両者は別物:
  組み込み plan mode は「その場で計画してから実行する」モード、
  plan スキルは `docs/plans/NNNN-*.md` に永続的な計画書を作る作業。
- スキル本文は `skill://<name>` で読める。サブエージェントは `autoloadSkills`
  で明示しない限りスキル本文を自動では持たないので、委譲時は必要な仕様を
  プロンプト本文に書くこと。

## 標準の開発フロー

1. `/grill-me` で仕様を対話的に決定する (必要なモデル: `modelRoles.plan` 級)
2. `/adr` で決定を `docs/adr/` に記録する
3. `/skill:plan` で実装計画書を `docs/plans/` に作る
4. `/clear` して親コンテキストを捨てる (仕様はすべてファイルに永続化済み)
5. `/fanout` (並列) または `/next` (逐次) で実装する
6. `/commit` でコミットする

## サブエージェントとモデル

- `implementer`: 実装専用。`model: "@worker"`、`task.isolation.enabled` により
  spawn ごとの隔離ワークスペースで作業し、成果は patch として親ツリーに適用される。
- `reviewer`: レビュー専用。`model: "@review"`、コードは編集しない。
- 役割 (`modelRoles`) でモデルを切り替える。実体は `~/.omp/agent/config.yml` に
  宣言されており、ホスト設定 (nixos-config の `programs.omp.settings`) が正。
  `/settings` での実行時変更は次回の `home-manager switch` で宣言値に戻る。
- 親は調整役なので既定モデルのままでよい。設計を厚くしたいときは
  `/model @plan` に切り替えるか、`modelRoles.default` 自体を強いモデルにする。
