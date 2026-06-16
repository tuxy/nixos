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
        keepassxc
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
        mpv
        imv
        supersonic
        eddie
        qbittorrent
        file-roller
        pulseaudio
        mesa
        darktable
        gapless
        nicotine-plus
        # bambu-studio
        freecad
        cinny-desktop
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
        # android-studio-full
        gh
        devenv
        opencode
        alejandra
        qemu
        python3
        geany
      ];
    };
  flake.nixosModules.packages-education =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xournalpp
        libreoffice-qt-fresh
        hunspell
        hunspellDicts.en_AU-large
        kdePackages.okular
        affine
        anki
        qalculate-gtk
        thunderbird
        typst
        typstyle
        tinymist
      ];
    };
}
