{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
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
