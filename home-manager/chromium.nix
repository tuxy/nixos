{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.chromium];
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
    ];
  };
}
