{ lib, ... }:

let
  skillsDir = ./skills;
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDir)
  );

  skillEntries = prefix: builtins.listToAttrs (map
    (name: {
      name = "${prefix}/${name}";
      value.source = skillsDir + "/${name}";
    })
    skillNames);
in
{
  home.file = {
    # Shared personal instructions. Keep tool-specific configuration in each
    # agent's existing settings and hooks.
    ".claude/CLAUDE.md".source = ./AGENTS.md;
    ".codex/AGENTS.md".source = ./AGENTS.md;
    ".omp/agent/AGENTS.md".source = ./AGENTS.md;
  }
  // skillEntries ".claude/skills"
  // skillEntries ".agents/skills"
  // skillEntries ".omp/agent/skills";
}
