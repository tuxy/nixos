# Waydroid: run Android apps in an LXC container.
#
# The upstream nixpkgs module behind `virtualisation.waydroid.enable` sets up
# LXC, the waydroid-container systemd service, binderfs kernel checks and
# firewall rules for the waydroid0 interface. The waydroid package also ships
# its own "Waydroid" desktop launcher.
{
  ...
}:
{
  flake.nixosModules.waydroid =
    { pkgs, ... }:
    {
      virtualisation.waydroid.enable = true;

      # The stock package prefers iptables-legacy for the waydroid0 bridge,
      # but Linux 6.18 on this pin no longer ships the legacy ip_tables
      # modules (only nf_tables). The nftables variant avoids that path and
      # would otherwise fail with "Table does not exist".
      virtualisation.waydroid.package = pkgs.waydroid-nftables;

      environment.systemPackages = [
        # Clipboard sharing between the host and Android apps.
        pkgs.wl-clipboard
      ];

      # First-time setup, after the first rebuild (downloads the Android
      # images into /var/lib/waydroid):
      #
      #   sudo waydroid init
      #
      # Add "-s GAPPS -f" for Google Play services. After that, launch
      # "Waydroid" from the app menu, or from a Wayland terminal:
      #
      #   waydroid session start
      #   waydroid show-full-ui
    };
}
