{ ... }:

{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules.surround = {
      # Key mappings for surround operations
      mappings = {
        add = "sa"; # Add surrounding in Normal and Visual modes
        delete = "sd"; # Delete surrounding
        find = "sf"; # Find surrounding (to the right)
        find_left = "sF"; # Find surrounding (to the left)
        highlight = "sh"; # Highlight surrounding
        replace = "sr"; # Replace surrounding
        update_n_lines = "sn"; # Update `n_lines`
      };

      # Number of lines within which surrounding is searched
      n_lines = 20;

      # Whether to respect selection type:
      # - Place surroundings on separate lines in linewise mode.
      # - Place surroundings around cursor in blockwise mode.
      respect_selection_type = false;

      # How to search for surrounding (first inside current line, then inside
      # neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      # 'cover_or_nearest', 'next', 'prev', 'nearest'.
      search_method = "cover";

      # Whether to disable showing non-error feedback
      silent = false;
    };
  };
}