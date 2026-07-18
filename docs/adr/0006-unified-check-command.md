# ADR-0006: リポジトリ統一検証コマンド規約（nix develop -c check）

## ステータス

承認済み（2026-07-18）

## コンテキストと問題

[ADR-0004](0004-llm-fanout-pipeline.md) のfanoutパイプラインでは、コンテキストを
持たないimplementer/reviewerサブエージェントに検証コマンドをプロンプトで渡す。
検証コマンドがリポジトリごとに異なる（`nix flake check` / `pnpm test` /
`biome check` 等）と、計画作成のたびに正しいコマンドを調べて書く必要があり、
書き間違いがそのまま「検証をすり抜けた自動マージ」につながる。

全リポジトリで同一の検証コマンドが使える規約が欲しい。

## 決定ドライバー

- 小モデルに渡す検証コマンドは、リポジトリによらず同一であるほど事故が減る
- JS系リポジトリのテストをNixサンドボックス内で動かすのは保守コストが高い
- flake.nix + direnv は全リポジトリで既に前提になっている（CLAUDE.md）

## 検討した選択肢

- `nix flake check` にテスト・lintをすべて載せる（checks出力にテストを含める）
- devShellに `check` スクリプトを置き、`nix develop -c check` を統一入口にする
- 統一せず、計画書ごとに検証コマンドを都度記載する（現状維持）

## 決定内容

選択した選択肢: "devShellに `check` スクリプトを置き、`nix develop -c check` を統一入口にする"

各リポジトリの `flake.nix` のdevShellに、`writeShellScriptBin "check"` で
そのリポジトリの検証一式（lint・型チェック・テスト等）を実行するスクリプトを
定義する。これにより全リポジトリで:

- `nix develop -c check`（direnv有効時は単に `check`）

が統一検証コマンドになる。`plan` スキルは検証コマンドのデフォルトをこれとし、
`fanout` スキルはimplementer/reviewerへの委譲プロンプトにこれを渡す。

`nix flake check` を廃止するわけではない。フォーマッタ・Nix評価などサンドボックス
内で安価に走るものは引き続き `nix flake check` が担い、`check` スクリプトと併用する。
nixos-configのようにNix純度の高いリポジトリでは、`check` の中身が
`nix flake check` の呼び出し（相当）になってもよい。

`nix flake check` にテストを載せない理由:

- flakeのチェックはサンドボックス内（ネットワークなし）で走るため、
  `node_modules` を要するテストはpnpm2nix/dream2nix等でのNix化が必要になり、
  lockfile変更のたびに追従保守が発生する
- flakeはgit追跡済みファイルしか見ないため、未追跡ファイルがあると
  「手元では通るのにcheckでは見えない」不整合が起きうる

### 良い結果

- 計画書・fanout委譲プロンプトの検証コマンドがリポジトリによらず固定になり、
  書き間違い・調べ直しがなくなる
- サンドボックス外で走るため `node_modules` 問題がなく、追加保守がほぼ不要
- direnv有効時は人間も同じ `check` 一発で検証できる

### 悪い結果

- 各リポジトリの `flake.nix` に `check` スクリプトを追加する初期作業が必要
  （flake.nix編集は規約上ユーザー確認必須のため、都度確認が入る）
- `check` スクリプトの中身（何を検証するか）の品質は各リポジトリ任せであり、
  中身が薄いリポジトリでは検証ゲートも薄くなる
- サンドボックス外実行のため、環境差（ローカルの状態）に検証結果が影響される
  余地が残る

## 参考

- [ADR-0004: LLM並列実装パイプライン（fanout）の採用](0004-llm-fanout-pipeline.md)
- [ADR-0005: reviewer承認+機械的ゲートのみでの自動マージ（人間承認なし）](0005-fanout-auto-merge-without-human-approval.md)
