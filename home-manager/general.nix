{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    ntfs3g
    kdePackages.kdeconnect-kde
    ksshaskpass
    alejandra
    virt-manager
    qemu
    tailscale
  ];
}
