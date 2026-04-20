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
        localNetwork.openFirewall = true;
        package = pkgs.steam.override {
          extraArgs = "-system-composer";
        };
      };

      environment.systemPackages = with pkgs; [
        (pkgs.makeDesktopItem {
          name = "Steam (Big Picture)";
          exec = "gamescope -e -f -w 1920 -h 1080 -- steam -gamepadui -system-composer";
          desktopName = "steam-big-picture";
          icon = "steam";
        })

        wineWow64Packages.staging
        bottles
        ckan
        gamescope
        prismlauncher
        heroic
        protontricks
      ];
    };
}
