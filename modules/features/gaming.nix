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

      services.sunshine = {
        enable = true;
        autoStart = true;
        openFirewall = true;
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
        (pkgs.prismlauncher.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
          buildCommand = (old.buildCommand or "") + ''
            wrapProgram $out/bin/prismlauncher --set QT_QPA_PLATFORMTHEME gtk3
          '';
        }))
        mangohud
        pcsx2
        heroic
        steam-rom-manager
        lsfg-vk
        lsfg-vk-ui
        moonlight-qt
      ];
    };
}
