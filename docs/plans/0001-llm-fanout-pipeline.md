# PLAN-0001: LLM並列実装パイプライン（fanout）の導入

## ステータス

完了（2026-07-18）

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

- [x] 2-1: `implementer`エージェントを定義する（model: haiku, tools: Read/Write/Edit/Bash/Glob/Grep, isolation: worktree）
  - 受け入れ条件: `agents/implementer.md`が存在し、frontmatterが仕様通りで`nix flake check`が通る
  - 変更ファイル: modules/home-manager/misc/claude-code/agents/implementer.md
  - 依存: 1-2
- [x] 2-2: `reviewer`エージェントを定義する（model: sonnet, tools: Read/Grep/Glob/Bashのみ）
  - 受け入れ条件: `agents/reviewer.md`が存在し、Write/Edit権限を持たないことが確認できる
  - 変更ファイル: modules/home-manager/misc/claude-code/agents/reviewer.md
  - 依存: 1-2

### マイルストーン 3: fanoutスキル

- [x] 3-1: `fanout`スキルを新設する（並列可能タスクの抽出、仕様ファイル生成・コミット、承認取得、implementer並列委譲、reviewer委譲、`nix flake check`ゲート、`--no-ff`マージとworktree削除、エスカレーション規則を手順として記述）
  - 受け入れ条件: `fanout/SKILL.md`にADR-0004/0005の手順が過不足なく反映されている
  - 変更ファイル: modules/home-manager/misc/claude-code/skills/fanout/SKILL.md
  - 依存: 1-1, 2-1, 2-2

### マイルストーン 4: 検証

- [x] 4-1: 小規模な計画で`fanout`を実際に動かし、独立タスク2件以上を並列実装→reviewer承認→自動マージまで完走させる
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
- 2026-07-17: 2-1・2-2完了。`fanout`スキル(3-1)がまだ存在しないため、ADR-0004の
  プロトコルに沿って親（このセッション）が直接2つのgeneral-purposeサブエージェント
  を`isolation: worktree`で並列起動し、それぞれ`task/0001-2-1`/`task/0001-2-2`
  ブランチに実装・コミットさせた。reviewer.md自身がまだ無いため、レビューは親が
  手動で代行（内容照合 + `NIXPKGS_ALLOW_INSECURE=1 nix flake check --impure`）し、
  両ブランチを`git merge --no-ff`でmainに取り込んでworktree/ブランチを削除した。
  分かった点: `isolation: worktree`で作られるworktreeは、Agent呼び出し時点の
  最新HEADではなく、セッション開始時点のコミットから分岐した（merge-baseが
  `314439e`になった）。派生元コミットが古くても`git merge`自体は問題なく解決
  できたが、fanoutスキル(3-1)ではこの分岐元がどの時点かを前提にしないよう
  設計する必要がある。
- 2026-07-17: 3-1完了。`fanout/SKILL.md`を新設した。2-1/2-2で発覚した
  worktree分岐タイミングの問題を受けて先にADR-0004を修正し（仕様ファイルは
  監査証跡、実行の正しさはimplementerへの委譲プロンプトへの全文埋め込みで
  担保する方針に変更）、その修正後の方針をfanoutスキルに反映した。また、
  reviewerが`task/NNNN-X`をチェックアウトできるよう、reviewer委譲前に
  implementer側のworktreeを削除する手順を明記した。
- 2026-07-18: 4-1完了。[PLAN-0002](0002-fanout-dry-run.md)（`docs/adr/README.md`・
  `docs/plans/README.md`の2独立タスク）で`fanout`を実地検証し、
  implementer並列実行→reviewer承認→`nix flake check`成功→`git merge --no-ff`
  自動マージまで完走した。同時に**重大な安全上の発見**があった:
  implementerが、指示した作業ブランチの作成・コミット・マージを自分の
  worktree内ではなく親のメイン作業ディレクトリ側で実行してしまい、親の
  カレントブランチが一時的に切り替わる事故が発生した（実害はなく復旧済み）。
  `isolation: worktree`は「サブエージェントが自分のworktree内でのみ動く」
  ことを強制しないため、委譲プロンプトに「最初に`pwd`/
  `git rev-parse --show-toplevel`で自分のworktreeパスを確認し、そこから
  出ない」という安全ルールを明記する必要がある（reviewer側ではこのルールを
  明記して問題なく機能した）。この安全ルールをADR-0004・
  `implementer`/`reviewer`エージェント定義・`fanout`スキル本文に反映する
  フォローアップが必要（詳細は[PLAN-0002作業メモ](0002-fanout-dry-run.md)参照）。
