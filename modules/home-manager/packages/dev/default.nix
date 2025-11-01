{pkgs, ...}: {
  home.packages = with pkgs; [
    avrdudess
    qmk
    vial
    sdkmanager
    flatpak-builder
    vscodium
  ];
}
