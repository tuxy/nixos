{ config, pkgs, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install firefox.
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  environment.systemPackages = with pkgs; [
      git
      neovim
      wget
      steam
      lutris
      kdePackages.kdeconnect-kde
      ksshaskpass 
   ];
}
