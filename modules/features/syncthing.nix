{
  self,
  inputs,
  ...
}:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.syncthing =
    { pkgs, ... }:
    {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        user = profile.name;
        dataDir = "/home/${profile.name}";
        configDir = "/home/${profile.name}/.config/syncthing";
      };
    };
}
