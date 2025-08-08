{pkgs, ...}: let
  profile = import ../../user/profile.nix {};
in {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = profile.hostname; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = profile.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = profile.defaultLocale;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = profile.layout;
    variant = "";
  };

  # Enable system services
  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.resolved.enable = true;
  services.gvfs.enable = true;

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libGL
    ];
  };

  # Enable flakes and unfree
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Necessary packages (IMPORTANT)
  environment.systemPackages = with pkgs; [
    git
    neovim
    ntfs3g
  ];
}
