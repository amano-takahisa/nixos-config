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

    [table.columns.last_commit]
    command = "git log -1 --format=%cs"
    width   = 10
    title   = "Commit"
    type    = "str"
    timeout = "2s"

    [table.columns.untracked]
    command = "git ls-files --others --exclude-standard | wc -l"
    title   = "??"
    width   = 5
    type    = "int"

    [table.columns.tracking]
    command = "git ls-files --exclude-standard | wc -l"
    title   = "ls-files"
    type    = "int"       # string|int|size|duration (controls sorting/format)
    width   = 8           # optional column width
    timeout = "2s"        # optional per-command timeout (falls back to CLI timeout)
    # env    = { FOO = "bar" } # optional extra env vars

    [detail.commands.default]
    command = "git status --short && echo --- stash --- && git stash list && echo ------------ && ls -lha"
    title   = "Status"
  '';
}
