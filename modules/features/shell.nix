{self, ...}: {
  flake.nixosModules.shell = {pkgs, ...}: {
    programs.fish = {
      enable = true;
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
      config = {
        user = {
          name = "Binh Nguyen";
          email = "lastpass7565@gmail.com";
        };
        credential = {
          helper = "store";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      delta
      zoxide
    ];
  };
}
