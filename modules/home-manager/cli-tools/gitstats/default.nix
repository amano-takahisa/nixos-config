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
    width   = 10
    title   = "Commit"
    type    = "datetime"
    format  = "YYYY-MM-DD"
    timeout = "2s"

    [table.columns.last_fs]
    width   = 10
    type    = "datetime"
    format  = "YYYY-MM-DD"
    timeout = "2s"

    [table.columns.untracked]
    # command = "git ls-files --others --exclude-standard | wc -l"
    title   = "??"
    width   = 2
    type    = "int"

    [table.columns.unpushed_br]
    title   = ""
    width   = 2
    type    = "int"

    [table.columns.unpushed_cm]
    title   = ""
    width   = 2
    type    = "int"

    [table.columns.uncommitted]
    command = "git diff --name-only HEAD | wc -l"
    title   = "MM"
    width   = 2
    type    = "int"

    [table.columns.stash]
    command = "git rev-list --walk-reflogs --count refs/stash 2>/dev/null || echo 0"
    title   = "s"
    width   = 2
    type    = "int"

    [table.columns.tracking]
    command = "git ls-files --exclude-standard | wc -l"
    title   = "ls"
    type    = "int"       # string|int|size|duration (controls sorting/format)
    width   = 5           # optional column width
    timeout = "2s"        # optional per-command timeout (falls back to CLI timeout)
    # env    = { FOO = "bar" } # optional extra env vars

    [detail.commands.default]
    command = """
    echo $ git status && \
    git status --short && \
    echo ------------ && \
    echo $ git stash list && \
    git stash list && \
    echo ------------ && \
    echo $ ls -lha && \
    ls -lha
    """
    title   = "Status"
  '';
}
