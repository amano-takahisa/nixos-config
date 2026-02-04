{ ... }:
{
  home.sessionPath = [
    "$HOME/ghq/personal/github.com/amano-takahisa/gitstats/bin"
  ];

  home.file.".config/gitstats/config".text = ''
    [table]
    include_defaults = true  # defaults: last_commit, last_fs, untracked, unpushed_br, unpushed_cm (Name is always included)

    [table.name]
    display_depth = 2  # trailing path segments shown in Name column

    [table.columns.tracking]
    command = "git ls-files --exclude-standard | wc -l"
    title   = "Tracking"
    type    = "int"       # string|int|size|duration (controls sorting/format)
    width   = 8           # optional column width
    timeout = "2s"        # optional per-command timeout (falls back to CLI timeout)
    # env    = { FOO = "bar" } # optional extra env vars

    [detail.commands.default]
    command = "git log -n 5"
    title   = "git log"
  '';
}
