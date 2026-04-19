{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.desktop =
    { pkgs, config, lib, ... }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.thunar
      ];
      environment.systemPackages = with pkgs; [
        alacritty
      ];

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe config.programs.niri.package}";
            user = profile.name;
          };
        };
      };
    };
}
