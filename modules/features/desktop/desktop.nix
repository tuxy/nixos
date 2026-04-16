{ self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${self.packages.${pkgs.stdenv.hostPlatform.system}.niri}/bin/niri";
          user = "tuxy";
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
