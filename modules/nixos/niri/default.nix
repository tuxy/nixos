{ pkgs, ... }:
{
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    fuzzel
    xwayland-satellite
    brightnessctl
    gnome-control-center
    gnome-online-accounts-gtk
    gnome-calendar
    lxqt.lxqt-policykit
  ];

  security.polkit.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    polarity = "dark";
  };
}
