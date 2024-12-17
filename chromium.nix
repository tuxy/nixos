{ config, pkgs }:{
  environment.systemPackages = with pkgs; [
    chromium
  ];

  programs.chromium.enable = true;
}
