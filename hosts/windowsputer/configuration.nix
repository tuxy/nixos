{ ... }: let
  profile = import ../../user/profile.nix {};
in {
  wsl = {
    enable = true;
    defaultUser = profile.name;
  };
}
