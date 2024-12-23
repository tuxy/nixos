{
  config,
  pkgs,
  ...
}: {
  # Enable kdeconnect with gsconnect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Adds some extensions
  environment.systemPackages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.wifi-qrcode
    gnomeExtensions.gsconnect
  ];

  # Excludes some default applications
  environment.gnome.excludePackages = with pkgs; [
    cheese
    eog
    epiphany
    totem
    yelp
    evince
    file-roller
    geary
    seahorse
    gnome-calculator
    gnome-characters
    gnome-contacts
    gnome-font-viewer
    gnome-maps
  ];
}
