{
  config,
  pkgs,
  ...
}: {
  imports = [./gnome.nix];

  environment.systemPackages = with pkgs; [
    alejandra
    steam
    lutris
    qemu
    cargo
    python3
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
