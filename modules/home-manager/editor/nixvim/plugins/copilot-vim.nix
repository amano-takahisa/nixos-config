{ ... }:

{
  programs.nixvim = {
    plugins.copilot-vim = {
      enable = true;
    };
    extraConfigLua = ''
      vim.g.copilot_filetypes = { ["*"] = true }
    '';
  };
}
