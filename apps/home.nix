{ config, pkgs, ... }:{  
  home-manager.users.tuxy = { pkgs, ... } : {
    home.packages = [
      # pkgs.chromium
      pkgs.mangohud
      pkgs.prismlauncher
    ];
    programs.bash = {
      enable = true;
      shellAliases = {
        update = "sudo -v && cd /etc/nixos && sudo git pull && sudo nixos-rebuild switch && cd -";
      };
    };

    # CHROMIUM SETTINGS
    programs.chromium = {
      enable = true;
      extensions = [
        # Ublock
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        # Bitwarden
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
      ]; 
    };
    
    # Neovim packages
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
	telescope-nvim
        nvim-treesitter
        # Treesitter parsers
	nvim-treesitter-parsers.rust
	nvim-treesitter-parsers.toml
      ];
    };

    home.stateVersion = "25.05";
  };
}
