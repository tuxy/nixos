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

    home.stateVersion = "25.05";
  };
}
