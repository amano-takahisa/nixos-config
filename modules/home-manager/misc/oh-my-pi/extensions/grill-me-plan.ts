// input extension: `/grill-me` と `/skill:grill-me` を送信したとき、その時点の
// モデルが何であれ `modelRoles.plan` のモデル (thinking サフィックス込み) へ
// 自動で切り替える。
//
// omp の skill と slash command はどちらもモデルを変えない (SKILL.md の
// frontmatter は name/description/globs/alwaysApply/hide/disableModelInvocation のみ、
// slash command 側も description/name のみ) ため、`/model @plan` の手打ちを
// input イベントで置き換える。input は対話 UI の送信時にしか発火しないので、
// ヘッドレス実行やサブエージェントの挙動には影響しない。
//
// 切り替えはセッション単位で残る。grill-me → adr → plan は plan 級モデルで
// 進める設計フェーズなので、終了時に既定モデルへ戻さない。戻すのは
// `/clear` (新セッション) か `/model @default`。
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

/** `/grill-me` または `/skill:grill-me` をコマンドトークンとして検出する。 */
const TRIGGER = /(?:^|\s)\/(?:skill:)?grill-me(?=\s|$)/u;

/** `modelRoles` の値に付く thinking サフィックス (`:high` など)。 */
const THINKING_SUFFIX = /:(off|minimal|low|medium|high|xhigh|max)$/u;

/**
 * `modelRoles.plan` の thinking サフィックスを取り出す。extension の
 * `setModel` はロール値のサフィックスを適用しない (`ctx.models.resolve` も
 * ベースモデルだけを返す) ので、ロールの宣言をそのまま単一ソースとして読む。
 */
function planThinkingLevel(
  pi: ExtensionAPI,
): Parameters<ExtensionAPI["setThinkingLevel"]>[0] | undefined {
  try {
    const role = pi.pi.settings.get("modelRoles")?.plan;
    const suffix =
      typeof role === "string"
        ? THINKING_SUFFIX.exec(role.trim())?.[1]
        : undefined;
    return suffix as
      Parameters<ExtensionAPI["setThinkingLevel"]>[0] | undefined;
  } catch {
    // Settings 未初期化 (通常は起きない) はサフィックス無しとして扱う。
    return undefined;
  }
}

export default function grillMePlanModel(pi: ExtensionAPI): void {
  pi.on("input", async (event, ctx) => {
    if (event.source !== "interactive") return;
    if (!TRIGGER.test(event.text.trim())) return;

    const plan = ctx.models.resolve("@plan");
    if (!plan) {
      ctx.ui.notify(
        "grill-me: modelRoles.plan が未設定のため、現在のモデルで実行します",
        "warning",
      );
      return;
    }

    const current = ctx.models.current();
    if (current && current.provider === plan.provider && current.id === plan.id)
      return;

    if (!(await pi.setModel(plan))) {
      ctx.ui.notify(
        `grill-me: ${plan.provider}/${plan.id} の資格情報が無いため、現在のモデルで実行します`,
        "warning",
      );
      return;
    }

    const level = planThinkingLevel(pi);
    if (level) pi.setThinkingLevel(level);
    ctx.ui.notify(
      `grill-me: モデルを ${plan.provider}/${plan.id}${level ? `:${level}` : ""} (plan ロール) に切り替えました`,
      "info",
    );
  });
}
