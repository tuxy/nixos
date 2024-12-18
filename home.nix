{ config, pkgs, ... }:{  
  home-manager.users.tuxy = { pkgs, ... } : {
    home.packages = [
      pkgs.chromium
      pkgs.mangohud
      pkgs.prismlauncher
    ];
    programs.bash.enable = true;

    # CHROMIUM SETTINGS
    programs.chromium.enable = true;

    programs.chromium.extensions = [
      # Ublock
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
    ]; 

    home.stateVersion = "24.11";
  };
}
