{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # packages for development, for all users
    bat # A cat(1) clone with syntax highlighting and Git integration.
    clang # C language family frontend for LLVM
    deno # Secure runtime for JavaScript and TypeScript
    gcc # GNU Compiler Collection
    gnumake # GNU make utility to maintain groups of programs
    htop # An interactive process viewer for Unix systems
    jq # Command-line JSON processor
    nodejs # Evented I/O for V8 javascript
    pkg-config # Tool that allows packages to find out information about other packages (wrapper script)
    tree # Command to produce a depth indented directory listing
    tree-sitter # Parser generator tool and an incremental parsing library
    unzip # Extraction utility for archives compressed in .zip format
    wl-clipboard # Command-line copy/paste utilities for Wayland
  ];
}
