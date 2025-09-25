{ ... }:

{
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          always_divide_middle = false;
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" "diff" "diagnostics" ];
          lualine_c = [ "filename" ];
          lualine_x = [ "encoding" "fileformat" "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        inactive_sections = {
          lualine_a = [ ];
          lualine_b = [ ];
          lualine_c = [ "filename" ];
          lualine_x = [ "location" ];
          lualine_y = [ ];
          lualine_z = [ ];
        };
        tabline = {
          # show buffers and file path
          lualine_a = [{ __unkeyed-1 = "buffers"; show_filename_only = false; path = 3; }];
          lualine_b = [ ];
          lualine_c = [ ];
          lualine_x = [ ];
          lualine_y = [ ];
          lualine_z = [ "tabs" ];
        };
      };
    };
  };
}
