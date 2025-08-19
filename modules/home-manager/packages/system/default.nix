{pkgs, ...}: {
  home.packages = with pkgs; [
    networkmanagerapplet
    gnome-extension-manager
    alacritty
    fsearch
    flatpak
    wlsunset
    gvfs
  ];
}
