{ pkgs, ... }:
{
  home.packages = with pkgs; [
    avrdudess
    gcc
    qmk
    vial
    sdkmanager
    flatpak-builder
    vscodium
    android-studio-full
    androidStudioPackages.canary
    gradle_9-unwrapped
    gh
    devenv
  ];

  nixpkgs.config.android_sdk.accept_license = true;
}
