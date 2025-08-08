{pkgs, ...}: {
  home.packages = with pkgs; [
    wineWowPackages.staging
    protonup-ng
    bottles
    pcsx2
    steam-rom-manager
    ckan
    gamescope
    prismlauncher
    mindustry
  ];
}
