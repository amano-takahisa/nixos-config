# PLAN-0001: LLM並列実装パイプライン（fanout）の導入

## ステータス

進行中（2026-07-17 開始）

## 関連ADR

- [ADR-0004: LLM並列実装パイプライン（fanout）の採用](../adr/0004-llm-fanout-pipeline.md)
- [ADR-0005: reviewer承認+機械的ゲートのみでの自動マージ（人間承認なし）](../adr/0005-fanout-auto-merge-without-human-approval.md)

## ゴール

`plan`スキルが依存関係とファイル所有権を明記したタスク分割をサポートし、`fanout`スキルが
implementer/reviewerサブエージェントを並列起動して、タスクの実装・レビュー・（`nix flake check`
成功時の）自動マージまでを一気通貫で行えるようになる。

## スコープ外

- Agent Teams（共有タスクリスト・エージェント間メッセージングによる密な協調）
- `tmux --tmux`による複数セッション監視
- Telegram通知の実装変更（既存の承認フローの流用を前提とし、今回は手を入れない）

## タスク

### マイルストーン 1: 基盤整備

- [x] 1-1: `plan`スキルのタスクテンプレートに「変更ファイル」「依存」フィールドを追加し、並列可否判定ルール（依存完了 かつ 書き込み対象globが互いに素）を明記する
  - 受け入れ条件: `plan/SKILL.md`のテンプレートと粒度ルールに新フィールドの記法と判定基準が明記されている
  - 変更ファイル: modules/home-manager/misc/claude-code/skills/plan/SKILL.md
  - 依存: なし
- [x] 1-2: `.claude/agents/`をNix宣言的に管理する仕組みを追加する（`skills`と同じ`home.file`シンボリックリンクパターン）
  - 受け入れ条件: `modules/home-manager/misc/claude-code/agents/`配下のmarkdownが`.claude/agents/`にリンクされ、`nix flake check`が通る
  - 変更ファイル: modules/home-manager/misc/claude-code/default.nix
  - 依存: なし

### マイルストーン 2: エージェント定義

- [ ] 2-1: `implementer`エージェントを定義する（model: haiku, tools: Read/Write/Edit/Bash/Glob/Grep, isolation: worktree）
  - 受け入れ条件: `agents/implementer.md`が存在し、frontmatterが仕様通りで`nix flake check`が通る
  - 変更ファイル: modules/home-manager/misc/claude-code/agents/implementer.md
  - 依存: 1-2
- [ ] 2-2: `reviewer`エージェントを定義する（model: sonnet, tools: Read/Grep/Glob/Bashのみ）
  - 受け入れ条件: `agents/reviewer.md`が存在し、Write/Edit権限を持たないことが確認できる
  - 変更ファイル: modules/home-manager/misc/claude-code/agents/reviewer.md
  - 依存: 1-2

### マイルストーン 3: fanoutスキル

- [ ] 3-1: `fanout`スキルを新設する（並列可能タスクの抽出、仕様ファイル生成・コミット、承認取得、implementer並列委譲、reviewer委譲、`nix flake check`ゲート、`--no-ff`マージとworktree削除、エスカレーション規則を手順として記述）
  - 受け入れ条件: `fanout/SKILL.md`にADR-0004/0005の手順が過不足なく反映されている
  - 変更ファイル: modules/home-manager/misc/claude-code/skills/fanout/SKILL.md
  - 依存: 1-1, 2-1, 2-2

### マイルストーン 4: 検証

- [ ] 4-1: 小規模な計画で`fanout`を実際に動かし、独立タスク2件以上を並列実装→reviewer承認→自動マージまで完走させる
  - 受け入れ条件: タスク仕様ファイルの粒度がimplementerにとって十分であることを確認し、マージまで人手を介さず完走する
  - 依存: 3-1

## 作業メモ

<!-- next スキルが実装中に得た知見・変更した前提をここに追記する -->

- 2026-07-17: 1-1完了。`plan/SKILL.md`に「変更ファイル」「依存」フィールドと
  並列可否判定ルール（依存完了 かつ 書き込み対象globが互いに素、読み取り専用は
  除外）を追記した。このPLAN-0001自体が新フィールドを使う最初の実例になっている。
- 2026-07-17: 1-2完了。`default.nix`に`agentsDir`/`agentFileEntries`を追加し、
  `skillFileEntries`と同じパターンで`.claude/agents/`にシンボリックリンクする
  ようにした。`agents/`ディレクトリは2-1/2-2でファイルが追加されるまで存在
  しないため、`builtins.pathExists`でガードしている。検証は
  `NIXPKGS_ALLOW_INSECURE=1 nix flake check --impure`で実施（このリポジトリの
  `nix flake check`は本タスクと無関係な既存のelectron insecureパッケージ問題で
  素のままでは失敗するため）。
