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
        self.nixosModules.packages-gaming
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
      ];
    };
  flake.nixosModules.packages-gaming =
    { pkgs, ... }:
    {
      programs.gamemode.enable = true;
      programs.kdeconnect.enable = true;

      environment.systemPackages = with pkgs; [
        bottles
        pcsx2
        ckan
        gamescope
        prismlauncher
        heroic
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
        gh
        devenv
        opencode
        alejandra
        qemu
        python3
        bitwarden-desktop
      ];
    };
  flake.nixosModules.packages-education =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xournalpp
        calibre
        libreoffice-qt-fresh
        kdePackages.okular
        affine
        anki
        qalculate-gtk
        thunderbird
      ];
    };
}
