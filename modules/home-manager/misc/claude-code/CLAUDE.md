# 開発環境の利用方針

- リポジトリで作業する際、lint・formatter・test runner などの開発ツールは、
  必ず `flake.nix` でインストールされ `direnv` で有効化されたものを使用する。
  グローバルに入っている同名コマンド(PATH 上のもの)を優先して使わない。
- 作業対象のリポジトリに `flake.nix` があるのに `.envrc` が存在しない場合は、
  作業前にユーザーへ `.envrc` の作成(例: `echo "use flake" > .envrc && direnv allow`)
  を提案する。
- `flake.nix` の新規作成、または既存 `flake.nix` の編集は、Auto mode を含む
  自動承認設定であっても必ずユーザーに確認を取ってから行う
  (この確認は hook によっても強制されている)。
