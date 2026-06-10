{ self, inputs, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.deckMode =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.jovian.nixosModules.default
        self.nixosModules.gaming
      ];

      jovian = {
        steam = {
          enable = true;
          autoStart = true;
          user = profile.name;
          desktopSession = "niri-session";
        };

        steamos.useSteamOSConfig = true;

        decky-loader = {
          enable = true;
          user = profile.name;
        };

        devices.steamdeck = {
          enable = true;
          enableGyroDsuService = true;
          enableVendorDrivers = true;
        };
      };
    };
}
