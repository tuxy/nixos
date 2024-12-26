{pkgs, ...}: {
  home.packages = with pkgs; [
    # Whatever home-manager package resides here (Which is most)
    wine-staging
    dfu-util
    avrdude
    avrdudess
    qmk
    vial
    jdk
    prismlauncher
    gnome-extension-manager
  ];
}
