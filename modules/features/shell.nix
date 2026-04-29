{ self, ... }:
{
  flake.nixosModules.shell =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        shellInit = ''
          zoxide init fish | source
          pay-respects fish --alias | source
          alias cd=z
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
          # delta config below
          core = {
            pager = "delta";
          };
          interactive = {
            diffFilter = "delta --color-only";
          };
          delta = {
            navigate = true;
            dark = true;
            side-by-side = true;
            line-numbers = true;
          };
          merge = {
            conflictStyle = "zdiff3";
          };
        };
      };

      programs.bash = {
        interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };

      environment.systemPackages = with pkgs; [
        delta
        zoxide
        pay-respects
      ];
    };
}
