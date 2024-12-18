{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    git
    ntfs3g
    neovim
    wget
    kdePackages.kdeconnect-kde
    ksshaskpass
  ];
}
