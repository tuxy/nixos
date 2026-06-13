{ self, inputs, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.deckMode =
    { pkgs, config, lib, ... }:
    {
      imports = [
        inputs.jovian.nixosModules.default
        inputs.chaotic.nixosModules.default
        self.nixosModules.gaming
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;
      chaotic.nyx.cache.enable = true;
      services.greetd.enable = lib.mkForce false;
      
      jovian = {
        steam = {
          enable = true;
          autoStart = true;
          user = profile.name;
          desktopSession = "niri";
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
