{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  virtualisation.waydroid.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      bamboo
    ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

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
