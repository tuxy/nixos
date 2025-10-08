{...}: {
  services.flatpak.update.auto.enable = true;
  services.flatpak.uninstallUnmanaged = false;

  services.flatpak.packages = [
    "com.google.AndroidStudio"
    "com.bambulab.BambuStudio"
    "com.vzhd1701.gridplayer"
    "flathub org.freedesktop.Sdk"
    "flathub org.freedesktop.Platform"
  ];
}
