{ ... }:

{
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      luaConfig = {
        pre = ''
          -- Define Rainbow highlight groups BEFORE indent-blankline setup
          local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
          }

          local hooks = require "ibl.hooks"
          -- Register highlight setup hook
          hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          end)

          -- Configure rainbow-delimiters integration
          vim.g.rainbow_delimiters = { highlight = highlight }
        '';
        post = ''
          local hooks = require "ibl.hooks"
          hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        '';
      };
      settings = {
        indent.char = "┊";
        whitespace.remove_blankline_trail = false;

        scope = {
          enabled = true;
          show_start = false;
          show_exact_scope = true;
          highlight = [
            "RainbowRed"
            "RainbowYellow"
            "RainbowBlue"
            "RainbowOrange"
            "RainbowGreen"
            "RainbowViolet"
            "RainbowCyan"
          ];
        };
      };
    };
    extraConfigLua = ''
      local indent_blankline_augroup = vim.api.nvim_create_augroup("indent_blankline_augroup", { clear = true })
        vim.api.nvim_create_autocmd("ModeChanged", {
          group = indent_blankline_augroup,
          pattern = "[vV\x16]*:*",
          command = "IBLEnable",
          desc = "Enable indent-blankline when exiting visual mode",
        })

        vim.api.nvim_create_autocmd("ModeChanged", {
          group = indent_blankline_augroup,
          pattern = "*:[vV\x16]*",
          command = "IBLDisable",
          desc = "Disable indent-blankline when exiting visual mode",
        })
    '';
  };
}

