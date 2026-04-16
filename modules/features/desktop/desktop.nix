{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${self.packages.${pkgs.stdenv.hostPlatform.system}.niri}/bin/niri";
          user = profile.name;
        };
      };

      imports = [
        self.nixosModules.niri
        self.nixosModules.thunar
      ];
      environment.systemPackages = with pkgs; [
        alacritty
      ];
    };
}
