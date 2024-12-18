{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    ntfs3g
    kdePackages.kdeconnect-kde
    ksshaskpass
    alejandra
  ];
}
