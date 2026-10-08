{ ... }:

{
  programs.codex = {
    enable = true;
    settings = {
      sandbox_mode = "workspace-write";
      approval_policy = "on-request";
      approvals_reviewer = "auto_review";
    };
  };
}
