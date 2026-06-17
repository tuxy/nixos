{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {

      programs.gamemode.enable = true;
      programs.steam.protontricks.enable = true;

      programs.steam = {
        enable = lib.mkDefault true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        (pkgs.makeDesktopItem {
          name = "steam-big-picture";
          exec = "gamescope -e -f -w 1920 -h 1080 -- steam -gamepadui";
          desktopName = "Steam (Big Picture)";
          icon = "steam";
        })

        wineWow64Packages.staging
        ckan
        gamescope
        prismlauncher
        mangohud
        pcsx2
        heroic
        steam-rom-manager
      ];
    };
}
