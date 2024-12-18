{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    cargo
    python3
    dfu-util
    avrdude
    avrdudess
    qmk
    vial
  ];
}
