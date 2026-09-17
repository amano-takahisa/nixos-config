# oh-my-pi (omp) coding agent for the msi host.
#
# The package is built from the pinned `oh-my-pi` flake input (Bun + Rust, no
# binary cache), so the first build after a lock update is slow.
# `programs.omp.package` defaults to that input's package; declarative settings
# go in `programs.omp.settings` and are written to ~/.omp/agent/config.yml.
{ oh-my-pi, ... }:

{
  imports = [ oh-my-pi.homeManagerModules.default ];

  programs.omp.enable = true;
}
