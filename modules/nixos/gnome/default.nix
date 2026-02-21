{ pkgs, lib, ... }:
{
  # Enable gnome
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.quick-settings-audio-panel
    ibus
  ];

  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = [
    pkgs.ibus-engines.bamboo
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
    gnome-terminal
  ];
}
