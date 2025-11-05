{ pkgs, ... }:
let
  profile = import ../../../user/profile.nix { };
in
{
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "${../../../scripts/rebuild}";
      rebuild-mobile = "${../../../scripts/rebuild-mobile}";
      console = "${pkgs.gamescope}/bin/gamescope -w 1920 -h 1080 -F nis -e -f -- steam -gamepadui";
      blender = "nix-shell ${../../../scripts/blender-cuda.nix}";
    };
    shellInit = ''
      zoxide init fish | source
      export SSH_ASKPASS=""
      export EDITOR=nvim
    '';
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = profile.fullName;
        email = profile.email;
      };
      credential.helper = "store";
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
