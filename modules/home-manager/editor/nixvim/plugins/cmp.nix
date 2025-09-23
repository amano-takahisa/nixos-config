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

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() elseif require('luasnip').expand_or_jumpable() then require('luasnip').expand_or_jump() else fallback() end end, { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() elseif require('luasnip').jumpable(-1) then require('luasnip').jump(-1) else fallback() end end, { 'i', 's' })";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];

        formatting = {
          format = "function(entry, vim_item) local kind_icons = { Text = '', Method = '󰆧', Function = '󰊕', Constructor = '', Field = '󰇽', Variable = '󰂡', Class = '󰠱', Interface = '', Module = '', Property = '󰜢', Unit = '', Value = '󰎠', Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘', File = '󰈙', Reference = '', Folder = '󰉋', EnumMember = '', Constant = '󰏿', Struct = '', Event = '', Operator = '󰆕', TypeParameter = '󰅲', } vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) vim_item.menu = ({ buffer = '[Buffer]', nvim_lsp = '[LSP]', luasnip = '[LuaSnip]', path = '[Path]', })[entry.source.name] return vim_item end";
        };

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
