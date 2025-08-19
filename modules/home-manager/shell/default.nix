{pkgs, ...}: let
  profile = import ../../../user/profile.nix {};
in {
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "${../../../scripts/rebuild}";
      rebuild-mobile = "${../../../scripts/rebuild-mobile}";
      console = "${pkgs.gamescope}/bin/gamescope -e -f -- steam -gamepadui";
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
