{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ./tailscale.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "serverputer";

  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  users.users.tuxy = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.copySystemConfiguration = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
