{ ... }:

{
  programs.nixvim.plugins.lsp.servers = {
    # Nix
    nil_ls = {
      enable = true;
      settings = {
        formatting = {
          command = [ "nixpkgs-fmt" ];
        };
      };
    };

    # Lua
    lua_ls = {
      enable = false;
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT";
          };
          diagnostics = {
            globals = [ "vim" ];
          };
          workspace = {
            library = {
              __raw = "vim.api.nvim_get_runtime_file('', true)";
            };
          };
          telemetry = {
            enable = false;
          };
        };
      };
    };

    # Rust
    rust_analyzer = {
      enable = false;
      installCargo = true;
      installRustc = true;
      settings = {
        cargo = {
          allFeatures = true;
          loadOutDirsFromCheck = true;
          runBuildScripts = true;
        };
        checkOnSave = {
          allFeatures = true;
          command = "clippy";
          extraArgs = [ "--no-deps" ];
        };
        procMacro = {
          enable = true;
          ignored = {
            async-trait = [ "async_trait" ];
            napi-derive = [ "napi" ];
            async-recursion = [ "async_recursion" ];
          };
        };
      };
    };

    # Python
    pyright = {
      enable = true;
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true;
            diagnosticMode = "workspace";
            useLibraryCodeForTypes = true;
          };
        };
      };
    };


    # HTML/CSS
    html.enable = true;
    cssls.enable = true;

    # JSON
    jsonls.enable = true;

    # YAML
    yamlls.enable = true;

    # Markdown
    marksman.enable = true;

    # Bash
    bashls.enable = true;
  };
}
