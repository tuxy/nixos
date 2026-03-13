{ ... }:
let
  profile = import ../../user/profile.nix { };
in
{
  home-manager.backupFileExtension = "bak";
  home-manager.users.${profile.name} =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      imports = [
        # ../../modules/home-manager/dconf
        #../../modules/home-manager/sway
        ../../modules/home-manager/shell
	../../modules/home-manager/niri
        ../../modules/home-manager/neovim
        ../../modules/home-manager/browser
        ../../modules/home-manager/flatpak
        ../../modules/home-manager/packages
        ../../modules/home-manager/tmux
      ];

      home = {
        username = profile.name;
        homeDirectory = "/home/${profile.name}";
        stateVersion = "25.11";
        sessionVariables = {
          # Session
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
	  DISPLAY = ":0";

          # Wayland
          MOZ_ENABLE_WAYLAND = "1";
          MOZ_USE_XINPUT2 = "1";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
        };
      };

      # catppuccin.enable = true;

      programs.git.enable = true;
    };
}
