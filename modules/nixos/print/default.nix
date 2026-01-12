{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.canon-cups-ufr2 pkgs.gutenprintBin ];
 } 
