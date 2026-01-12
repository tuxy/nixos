{pkgs, ...}: {
  home.packages = with pkgs; [
    xournalpp
    calibre
    libreoffice-qt-fresh
    kdePackages.okular
  ];
}
