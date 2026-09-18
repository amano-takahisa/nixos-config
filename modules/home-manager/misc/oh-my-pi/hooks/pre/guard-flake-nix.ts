// tool_call hook: flake.nix の新規作成・更新は、Auto mode や自動承認設定
// (--auto-approve / tools.approvalMode: yolo) であっても必ずユーザーの確認を取る。
//
// omp にはパス単位の承認ポリシーが無いため hook で強制する。`edit` ツールの入力は
// モードによって形が違う (hashline は `[PATH#TAG]` パッチ、replace/patch は `path`、
// apply_patch はパッチ本文内の `*** ... File:`)。実行時には hashline モードの
// 対象パスが `path` / `paths` に正規化されて渡ってくるので、それを使い、届かない
// 形式だけパッチ本文から拾う。
import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

const FLAKE_BASENAME = "flake.nix";

/** write / edit が書き込む対象パスを集める。 */
function targetPaths(
  toolName: string,
  input: Record<string, unknown>,
): string[] {
  const paths: string[] = [];
  const push = (value: unknown): void => {
    if (typeof value === "string" && value.length > 0) paths.push(value);
  };

  if (toolName === "write") {
    push(input.path);
    return paths;
  }
  if (toolName !== "edit") return paths;

  // replace / patch モードの実パラメータと、hashline モードで正規化された対象パス。
  push(input.path);
  push(input._path);
  if (Array.isArray(input.paths)) for (const path of input.paths) push(path);

  // patch モードのリネーム先。
  if (Array.isArray(input.edits)) {
    for (const entry of input.edits) {
      if (entry && typeof entry === "object")
        push((entry as Record<string, unknown>).rename);
    }
  }

  // apply_patch / sloppy などパッチ本文に対象が埋まっている形式。
  const raw = input.input ?? input._input;
  if (typeof raw === "string") {
    for (const match of raw.matchAll(
      /^\*\*\* (?:Update|Add|Delete|Move to) File: (.+)$/gmu,
    )) {
      push(match[1].trim());
    }
    for (const match of raw.matchAll(/^MV\s+(.+)$/gmu)) {
      push(match[1].trim().replace(/^["']|["']$/gu, ""));
    }
  }

  return paths;
}

export default function hook(pi: HookAPI): void {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "write" && event.toolName !== "edit") return;

    const targets = targetPaths(event.toolName, event.input).filter(
      (path) => path.split("/").pop() === FLAKE_BASENAME,
    );
    if (targets.length === 0) return;

    const detail = `対象: ${targets.join(", ")}`;
    const reason = `flake.nix の新規作成・更新は、Auto mode や自動承認設定であっても必ずユーザーの確認を取ってください (${detail})。`;

    // UI が無いセッション (print モード / サブエージェント) では確認を取れないため、
    // 黙って通さずブロックする。
    if (!ctx.hasUI) return { block: true, reason };

    const approved = await ctx.ui.confirm("flake.nix を編集しますか?", reason);
    if (!approved) {
      return {
        block: true,
        reason: `ユーザーが flake.nix の編集を承認しませんでした (${detail})。`,
      };
    }
  });
}
