{pkgs, ...}: {
  home.packages = with pkgs; [
    xournalpp
    calibre
    libreoffice-qt-fresh
    kdePackages.okular
    musescore
    logseq
    affine
    qalculate-gtk
    teams-for-linux
  ];
}
