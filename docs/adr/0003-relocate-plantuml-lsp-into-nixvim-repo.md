---
status: accepted
date: 2026-06-21
deciders: takahisa
---

# plantuml-lsp を nixvim リポへ移動

## コンテキストと課題

`tools/plantuml-lsp` はローカルでビルドする PlantUML 用 LSP サーバで、`nixos-config` の
`flake.nix` で `plantumlLsp = pkgs.callPackage ./tools/plantuml-lsp { }` として組み立て、
`extraSpecialArgs` 経由で nixvim の `lsp-servers.nix` に渡している。利用箇所は
nixvim 設定のみ。

[[0001-extract-nixvim-as-standalone-flake]] で Nixvim 設定を新リポへ切り出すと、この
ツールをどこに置くかが問題になる。[[0002-standalone-nvim-self-containment-level]] により
plantuml(-lsp) は standalone でも同梱対象であり、新リポのビルド時に解決できる必要がある。

## 検討した選択肢

- **A. 新 nixvim リポへ移動**（設定とツールを同居させる）
- **B. nixos-config に残し、新リポが flake input として参照**（依存方向が新リポ→nixos-config
  に逆転し、循環参照リスク・見通しの悪化）
- **C. nixos-config に残し MSI 専用扱い**（standalone では PlantUML LSP を無効化、設定が二分）

## 決定

`tools/plantuml-lsp` を新リポ `nixvim-config` へ移動し、設定と同居させる（選択肢 A）。

## 理由

- PlantUML LSP は nvim 設定のためだけに存在するため、設定と同じリポに置くのが凝集度が高い。
- 新リポのスタンドアロンビルドが自己完結する（外部 input なしで plantuml-lsp を解決できる）。
- 選択肢 B は依存方向が逆転し、`nixos-config` が新リポを input にしつつ新リポも
  `nixos-config` を input にするという循環・混乱を招く。
- 選択肢 C は同じ設定が standalone と MSI で機能差を持つことになり、単一ソース化の方針に反する。

## 結果

- `nixos-config` の `flake.nix` から `plantumlLsp` の組み立てと `extraSpecialArgs` 受け渡しが
  不要になり、`tools/plantuml-lsp` が消えて構成がスッキリする。
- 新リポ内で plantuml-lsp をビルドし、`lsp-servers.nix` から内部的に参照する。
