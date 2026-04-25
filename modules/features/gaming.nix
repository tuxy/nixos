{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs.gamemode.enable = true;

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        package = pkgs.steam.override {
          extraArgs = "-system-composer";
        };
      };

      environment.systemPackages = with pkgs; [
        (pkgs.makeDesktopItem {
          name = "steam-big-picture";
          exec = "gamescope -e -f -w 1920 -h 1080 -- steam -gamepadui -system-composer";
          desktopName = "Steam (Big Picture)";
          icon = "steam";
        })

        wineWow64Packages.staging
        bottles
        ckan
        gamescope
        prismlauncher
        mangohud
        pcsx2
        heroic
        protontricks
      ];
    };
}
