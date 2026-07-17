# PLAN-0002: fanout実地検証（ドキュメント追加）

## ステータス

進行中（2026-07-17 開始）

## 関連ADR

- [ADR-0004: LLM並列実装パイプライン（fanout）の採用](../adr/0004-llm-fanout-pipeline.md)
- [ADR-0005: reviewer承認+機械的ゲートのみでの自動マージ（人間承認なし）](../adr/0005-fanout-auto-merge-without-human-approval.md)

## ゴール

[PLAN-0001](0001-llm-fanout-pipeline.md) タスク4-1の受け入れ条件（`fanout`で独立タスク
2件以上を並列実装→reviewer承認→自動マージまで完走させる）を、実際に`fanout`スキルを
動かして検証する。副産物として`docs/adr/`・`docs/plans/`それぞれに簡単な説明READMEを
追加する。

## スコープ外

- README以外のドキュメント整備

## タスク

### マイルストーン 1: READMEの追加

- [ ] 1-1: `docs/adr/README.md`を作成する（ADRの目的・一覧の見方・`adr`スキルでの運用方法を簡潔に説明する）
  - 受け入れ条件: `docs/adr/README.md`が存在し、ADRディレクトリの目的と`adr`スキルの使い方が1画面程度で説明されている
  - 変更ファイル: docs/adr/README.md
  - 依存: なし
- [ ] 1-2: `docs/plans/README.md`を作成する（実装計画書の目的・一覧の見方・`plan`/`next`/`fanout`スキルでの運用方法を簡潔に説明する）
  - 受け入れ条件: `docs/plans/README.md`が存在し、計画書ディレクトリの目的と`plan`/`next`/`fanout`スキルの使い方が1画面程度で説明されている
  - 変更ファイル: docs/plans/README.md
  - 依存: なし

## 作業メモ

<!-- next スキルが実装中に得た知見・変更した前提をここに追記する -->
