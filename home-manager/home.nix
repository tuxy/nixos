{...}: let
  profile = import ../user/profile.nix {};
in {
  home-manager.backupFileExtension = "bak";
  home-manager.users.${profile.name} = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ./config
      ./sway
      ./neovim
      ./browser
      ./package
    ];

    home = {
      username = profile.name;
      homeDirectory = "/home/${profile.name}";
      sessionVariables = {
        # Session
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";

        # Wayland
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";

        # GTK Theme
        GTK_THEME = "Breeze-Dark";
      };

      stateVersion = "24.11";
    };

    programs.git.enable = true;
  };
}
