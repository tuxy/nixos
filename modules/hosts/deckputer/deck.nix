{ self, inputs, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.deckMode =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.jovian.nixosModules.default
        inputs.chaotic.nixosModules.default
        self.nixosModules.gaming
      ];

      # boot.kernelPackages = pkgs.linuxPackages_latest;
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

      systemd.services.steam-cef-debug = lib.mkIf config.jovian.decky-loader.enable {
        description = "Create Steam CEF debugging file";
        serviceConfig = {
          Type = "oneshot";
          User = config.jovian.steam.user;
          ExecStart = "/bin/sh -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
