{
  lib,
  pkgs,
  ...
}: let
  profile = import ../../user/profile.nix {};
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "$HOME/nixos/scripts/rebuild";
      console = "${pkgs.gamescope}/bin/gamescope -e -f -- steam -gamepadui";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
    sessionVariables = {
      SSH_ASKPASS = ""; # Empty string for no askpass program
    };
    initContent = lib.mkOrder 1500 "eval \"$(zoxide init zsh)\"";
  };
  programs.git = {
    enable = true;
    userName = profile.fullName;
    userEmail = profile.email; # Git information
    extraConfig = {
      credential.helper = "store"; # Store git credentials
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=13";
      };
    };
  };
}
