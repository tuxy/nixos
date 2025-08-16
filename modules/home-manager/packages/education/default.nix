{pkgs, ...}: {
  home.packages = with pkgs; [
    xournalpp
    calibre
  ];
}
