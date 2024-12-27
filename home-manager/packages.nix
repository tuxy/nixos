{pkgs, ...}: {
  home.packages = with pkgs; [
    # Whatever home-manager package resides here (Which is most)
    wineWowPackages.staging
    dfu-util
    avrdude
    avrdudess
    qmk
    vial
    jdk
    prismlauncher
    gnome-extension-manager
    bat
    jq
    mindustry
    wezterm
  ];
}
