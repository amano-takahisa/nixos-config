{ pkgs, plantumlLsp, ... }:

{
  programs.nixvim.plugins.lsp.servers = {
    # Nix
    nil_ls = {
      enable = true;
      settings = {
        formatting = {
          command = [ "nixpkgs-fmt" ];
        };
        nix = {
          flake = {
            autoArchive = true;
          };
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
      enable = true;
      installCargo = false;
      installRustc = false;
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

    # Python linting with ruff
    ruff = {
      enable = true;
      extraOptions = {
        init_options = {
          settings = {
            lineLength = 79;
            lint = {
              select = [ "E" "F" "W" ];
            };
          };
        };
      };
    };


    # Go
    gopls = {
      enable = true;
      settings = {
        gopls = {
          analyses = {
            unusedparams = true;
            shadow = true;
          };
          staticcheck = true;
          gofumpt = true;
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
        };
      };
    };

    # TypeScript/JavaScript
    vtsls = {
      enable = true;
      filetypes = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
      ];
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

  # PlantUML LSP
  programs.nixvim.plugins.lsp.preConfig = ''
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')

    if not configs.plantuml_lsp then
      configs.plantuml_lsp = {
        default_config = {
          cmd = {
            "${plantumlLsp}/bin/plantuml-lsp",
            "--exec-path", "${pkgs.plantuml}/bin/plantuml"
          },
          filetypes = { 'plantuml', 'puml' },
          root_dir = lspconfig.util.root_pattern('.git', '.plantuml'),
          settings = {},
        },
      }
    end
  '';

  programs.nixvim.plugins.lsp.postConfig = ''
    require('lspconfig').plantuml_lsp.setup{}
  '';
}
