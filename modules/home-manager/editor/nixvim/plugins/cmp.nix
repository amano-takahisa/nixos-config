{ ... }:

{
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };

        completion = {
          autocomplete = false;
        };

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-n>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else cmp.complete() end end, { 'i', 's' })";
          "<C-p>" = "cmp.mapping.select_prev_item()";
        };

        sources = [
          { name = "copilot"; }
          { name = "git"; }
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];

        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder";
          };
        };
      };
    };

    # Snippet engine
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = "./snippets";
        }
      ];
    };

    # Additional completion sources
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
  };
}
