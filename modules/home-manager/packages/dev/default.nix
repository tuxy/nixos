{ pkgs, ... }:
{
  home.packages = with pkgs; [
    avrdudess
    qmk
    vial
    sdkmanager
    flatpak-builder
    vscodium
    android-studio-full
    gh
  ];

  nixpkgs.config.android_sdk.accept_license = true;
}
