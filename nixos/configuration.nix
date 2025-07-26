{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./disko-config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.rtkit.enable = true;
  # Enable pulseaudio service
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.tuxy = {
    isNormalUser = true;
    description = "tuxy";
    extraGroups = ["networkmanager" "wheel"];
    shell = "zsh";
  };

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.zsh.enable = true;

  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  services.resolved.enable = true;

  # Necessary packages (IMPORTANT)
  environment.systemPackages = with pkgs; [
    gnumake
    git
    neovim
    ntfs3g
    protonplus
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  system.stateVersion = "24.11"; # Did you read the comment?
}
