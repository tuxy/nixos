{pkgs, ...}: {
  home.packages = with pkgs; [
    gnome-extension-manager
    alacritty
    fsearch
    flatpak
    wlsunset
    gvfs
  ];
}
