{
  self,
  ...
}:
{
  flake.nixosModules.packages-all =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.packages-base
        self.nixosModules.packages-media
        self.nixosModules.packages-education
        self.nixosModules.packages-development
      ];
    };
  flake.nixosModules.packages-base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        alejandra
        jdk
        bat
        jq
        htop
        btop
        android-tools
        aria2
        nixos-anywhere
        caligula
        ffmpegthumbnailer
        gparted
        nss.tools
        sbctl
        gnupg
      ];
    };
  flake.nixosModules.packages-media =
    { pkgs, ... }:
    {
      programs.kdeconnect.enable = true;
      programs.localsend.enable = true;

      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.mpv

        ffmpeg
        vlc
        figma-linux
        mpv
        imv
        openscad
        supersonic
        eddie
        jellyfin-mpv-shim
        qbittorrent
        file-roller
        pulseaudio
        mesa
        darktable
        gapless
        nicotine-plus
      ];
    };
  flake.nixosModules.packages-development =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux

        avrdudess
        gcc
        qmk
        vial
        sdkmanager
        vscodium
        android-studio
        gh
        devenv
        opencode
        alejandra
        qemu
        just
        python3
        bitwarden-desktop
        geany
      ];
    };
  flake.nixosModules.packages-education =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xournalpp
        libreoffice-qt-fresh
        kdePackages.okular
        affine
        anki
        qalculate-gtk
        thunderbird
      ];
    };
}
