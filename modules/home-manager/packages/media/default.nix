{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    vlc
    obs-studio
    figma-linux
    mpv-unwrapped
    imv
    openscad
    supersonic
    eddie
  ];
}
