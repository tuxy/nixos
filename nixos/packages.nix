{pkgs, ...}: {
  imports = [./gnome.nix];

  environment.systemPackages = with pkgs; [
    alejandra
    lutris
    qemu
    python3
    gnome-extension-manager
    kicad-small
    qbittorrent
    file-roller
    pulseaudio
    mesa
    cloudflare-warp
    fd
    fzf
    mangohud
    sunshine
    ffmpegthumbnailer
  ];
}
