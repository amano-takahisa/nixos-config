# 実装計画書

`docs/plans/` は、複数ステップに分かれる作業やセッションをまたいで再開する作業の
計画と進捗を保存します。小さく明確な変更にはIssueと受け入れ条件だけを使います。

## ファイル構成

- `NNNN-kebab-case-title.md`: 日本語の計画書。番号は4桁ゼロ埋め
- `NNNN-tasks/N-M.md`: 複数セッションや実装者に独立したタスク仕様が必要な場合のみ作成

計画にはゴール、対象外、関連ADR、タスクごとの受け入れ条件、依存関係、実際に使う検証手順を
記載します。変更ファイルの一覧は競合を見つける補助情報として使い、ファイル名が異なること
だけで並列実装の安全性を判断しません。

## 共通スキル

Claude Code、Codex CLI、oh-my-piから同じ正本のスキルを利用します。呼び出し方と推奨フローは
[`modules/home-manager/misc/agent-workflow/README.md`](../../modules/home-manager/misc/agent-workflow/README.md)
を参照してください。

- `write-plan`: 長期作業の計画を作成・一覧・表示
- `next`: Issueまたは計画の次の未完了タスクを実装し検証
- `verify-change`: テストとユーザー可視の動作を確認
- `review-changes`: 受け入れ条件と差分を照合し、編集せず所見を報告
- `parallelize`: 独立作業の並列化と統合を計画

PRは変更の提出とCI・レビューの品質ゲートに使います。自動マージは行いません。
