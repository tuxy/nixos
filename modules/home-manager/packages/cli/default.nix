{pkgs, ...}: {
  home.packages = with pkgs; [
    dfu-util
    alejandra
    avrdude
    jdk
    bat
    jq
    htop
    android-tools
    nix-init
    nixpkgs-fmt
    nixpkgs-review
    zoxide
    gallery-dl
    yt-dlp
    p7zip
  ];
}
