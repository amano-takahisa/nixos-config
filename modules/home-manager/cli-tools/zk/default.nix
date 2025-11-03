{ pkgs, lib, ... }:

let
  caseTransformPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/zk_notebooks;
  caseTransformExists = builtins.pathExists caseTransformPath;
in
if caseTransformExists then {
  programs.zk = {
    enable = true;
    settings = {
      notebook = {
        dir = "/home/takahisa/ghq/personal/github.com/amano-takahisa/zk_notebooks";
      };

      note = {
        language = "en";
        default-title = "Untitled";
        filename = "{{id}}-{{slug title}}";
        extension = "md";
        template = "default.md";
        id-charset = "alphanum";
        id-length = 6;
        id-case = "lower";
      };

      extra = {
        author = "Takahisa";
      };

      group = {
        daily = {
          note = {
            filename = "{{format-date now \"year\"}}/{{format-date now \"%j\"}}";
            template = "daily.md";
          };
        };
        task = {
          note = {
            filename = "{{format-date now}}";
            template = "task.md";
          };
        };
        review = {
          note = {
            filename = "{{format-date now}}-{{id}}-{{slug title}}";
            template = "review.md";
          };
        };
      };

      format = {
        markdown = {
          hashtags = true;
          colon-tags = true;
        };
      };

      tool = {
        editor = "nvim";
        shell = "/home/takahisa/.nix-profile/bin/fish";
        pager = "less -FIRX";
        fzf-preview = "bat -p --color always {-1}";
      };

      filter = {
        recents = "--sort created- --created-after 'last two weeks'";
      };

      alias = {
        edlast = "zk edit --limit 1 --sort modified- $argv";
        recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
        lucky = "zk list --quiet --format full --sort random --limit 1";
        daily = "zk new --print-path --no-input \"$ZK_NOTEBOOK_DIR/daily\"";
        touch = "zk new --print-path --no-input --title \"$argv\"";
        task = "zk new --no-input \"$ZK_NOTEBOOK_DIR/task\"";
        review = "zk new --no-input \"$ZK_NOTEBOOK_DIR/review\"";
      };

      lsp = {
        diagnostics = {
          wiki-title = "hint";
          dead-link = "error";
        };
      };
    };
  };
} else {
  warnings = [ "zk_notebooks not found. Please run: ghq get git@github.com:amano-takahisa/zk_notebooks.git" ];
}
