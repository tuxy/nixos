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
    alacritty
    protonup-ng
    bottles
    htop
    wakatime-cli
    flameshot
    ffmpeg
    kdenlive
    vlc
    obs-studio
    android-studio
    sdkmanager
    android-tools
    figma-linux
  ];
}

