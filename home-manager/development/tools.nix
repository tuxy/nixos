{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    cargo
    dfu-util
    avrdude
    avrdudess
    qmk
    vial
    rust-analyzer
  ];
}
