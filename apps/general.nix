{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    kdePackages.kdeconnect-kde
    ksshaskpass
  ];
}
