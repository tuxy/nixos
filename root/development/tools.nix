{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    python3
    wget
    git
  ];
}
