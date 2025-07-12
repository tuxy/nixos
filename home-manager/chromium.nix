{pkgs, ...}: {
  home.packages = [pkgs.chromium];
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      {id = "jinjaccalgkegednnccohejagnlnfdag";} # violent monkey
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
    ];
  };
}
