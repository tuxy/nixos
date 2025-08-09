{lib, ...}: let
  profile = import ../../user/profile.nix {};
in {
  home = {
    userName = lib.mkDefault profile.name;
    homeDirectory = "/home/${profile.name}";
    stateVersion = "24.11";
  };
}
