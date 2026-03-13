{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineWow64Packages.staging
    protonup-ng
    bottles
    pcsx2
    steam-rom-manager
    ckan
    gamescope
    prismlauncher
    mindustry
    heroic
    protontricks
    discord
    mumble
  ];
}
