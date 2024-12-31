{pkgs, ...}: {
  imports = [./gnome.nix];

  environment.systemPackages = with pkgs; [
    alejandra
    steam
    lutris
    qemu
    python3
    gnome-extension-manager
    kicad-small
    qbittorrent
    file-roller
    pulseaudio
    mesa
 ];
}
