{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
      git
      neovim
      wget
      steam
      lutris
      kdePackages.kdeconnect-kde
    ];
}
