{pkgs, ...}: {
  fonts.packages = [pkgs.nerd-fonts.fira-code];

  environment.systemPackages = with pkgs; [
    alejandra
    qemu
    python3
    gnome-extension-manager
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
    home-manager
    pmbootstrap
    gparted
    lxqt.lxqt-policykit
  ];
}
