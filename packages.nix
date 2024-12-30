{pkgs, ...}: {
  imports = [./gnome.nix];

  environment.systemPackages = with pkgs; [
    alejandra
    steam
    lutris
    qemu
    cargo
    rustc
    rustup
    python3
    gnome-extension-manager
    kicad-small
    qbittorrent
    gcc
    file-roller
    pulseaudio
    mesa
  ];
}
