 {config, lib, pkgs, ... }:

let

  myVimPlugins = with pkgs.vimPlugins; [
        plenary-nvim
	      telescope-nvim
	      vim-surround
        nvim-lspconfig
        coc-texlab
  ];

  baseConfig    = builtins.readFile ./config/config.vim;
  telescopeConfig    = builtins.readFile ./config/telescope.vim;
  lspConfig = builtins.readFile ./config/lsp.vim;

in {
  programs.neovim = {
    enable       = true;
    extraConfig  = baseConfig + telescopeConfig + lspConfig;
    plugins      = myVimPlugins;
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;
    withNodeJs   = true; # for coc.nvim
    withPython3  = true; # for plugins
  };

}
