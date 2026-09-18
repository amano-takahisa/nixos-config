// before_agent_start hook: セッション開始時に、flake.nix + direnv で有効化された
// 開発ツールを使うこと、.envrc が無ければユーザーに提案することを思い出させる。
//
// `before_agent_start` はユーザーのプロンプトごとに発火するため、cwd 単位で
// 一度だけ注入する (サブエージェントのセッションと同じプロセスでも二重注入しない)。
import { existsSync } from "node:fs";
import { join } from "node:path";
import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

const REMINDER_TYPE = "dev-env-reminder";
const reminded = new Set<string>();

export default function hook(pi: HookAPI): void {
  pi.on("before_agent_start", (_event, ctx) => {
    if (reminded.has(ctx.cwd)) return;
    reminded.add(ctx.cwd);

    if (!existsSync(join(ctx.cwd, "flake.nix"))) return;

    let text =
      "このリポジトリには flake.nix があります。lint / formatter / test runner などの開発ツールは、" +
      "必ず flake.nix でインストールされ direnv で有効化されたものを使ってください。" +
      "グローバルにインストールされた同名コマンドを優先して使わないでください。";
    if (!existsSync(join(ctx.cwd, ".envrc"))) {
      text +=
        " また、このリポジトリには .envrc がありません。作業を始める前にユーザーへ .envrc の作成" +
        " (例: 'use flake' の追記と direnv allow の実行) を提案してください。";
    }

    return {
      message: { customType: REMINDER_TYPE, content: text, display: false },
    };
  });
}
