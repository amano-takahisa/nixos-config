---
status: accepted
date: 2026-06-21
deciders: takahisa
---

# Nixvim 設定をスタンドアロン flake として切り出す

## コンテキストと課題

Nixvim 設定は現在 `modules/home-manager/editor/nixvim/` に置かれ、`nixos-config` の
home-manager モジュールとして各ホスト（msi 等）に組み込まれている。

この設定を、

- MSI ではこれまでどおり**インストール済み**で使いたい
- Nix が入った別の PC でも、インストールせず**一時的に自分用にカスタマイズされた Neovim**
  を使いたい（`nix run` で起動）

という2つの用途で再利用したい。現状の構成は前者しか満たせない。

## 検討した選択肢

- **A. スタンドアロン flake パッケージのみ**（`nix run` 用パッケージだけを export）
- **B. home-manager モジュールとして再利用のみ**（input 参照で各マシンに組み込む）
- **C. package と home-manager module の両方を export**

さらに、MSI（`nixos-config`）が新リポを取り込む方式として、

- **A. home-manager モジュールとして import**（依存は MSI に追従、HM オプションで上書き可）
- **B. パッケージを `home.packages` に追加**（新リポ側でバージョン固定・設定封印）

## 決定

設定本体を新リポジトリ `nixvim-config`（`github.com/amano-takahisa/nixvim-config`,
public）に切り出し、**package（`nix run` 用）と home-manager module の両方を
export する（選択肢 C）**。

MSI 側の `nixos-config` は、**新リポの home-manager module を flake input 経由で
import する（取り込み方式 A）**。input は `nixpkgs` / `nixvim` を `follows` させて
MSI の依存に追従させる。開発中（GitHub へ push 前）は
`--override-input nvim-config ../nixvim-config` でローカル checkout を参照して反復する。

## 理由

- 設定本体は1か所（新リポ）にのみ存在し、二重管理を避けられる。
- MSI では module import により、これまでと同じ「インストール済み」挙動を維持しつつ、
  将来ホスト固有の差分（例: 特定 LSP を msi だけ）を HM オプションで後付けできる。
- 同じ設定モジュールから `nix run` 用パッケージも生成でき、出先の素の Nix マシンで
  一時利用できる。

## 結果

- シークレットを含まないため public 化に支障はない（Copilot 認証は実行時に
  `~/.config` 側で解決され、ビルド時シークレットは不要）。
- 取り込み方式 B（パッケージ封印）を採らないため、出先の `nix run` と MSI のバイナリは
  依存追従の差で完全一致しない可能性があるが、Neovim 用途では許容する。
- `nixos-config` の `modules/home-manager/editor/nixvim/` は、新リポの
  `homeModules.default` を import する薄いラッパへ置き換わる。
