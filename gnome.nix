{pkgs, ...}: {
  # Enable kdeconnect with gsconnect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Adds some extensions
  environment.systemPackages = with pkgs.gnomeExtensions; [
    tray-icons-reloaded
    wifi-qrcode
    gsconnect
    advanced-alttab-window-switcher
    quick-settings-audio-panel
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
    gnome-calculator
    gnome-characters
    gnome-contacts
    gnome-font-viewer
    gnome-maps
  ];
}
