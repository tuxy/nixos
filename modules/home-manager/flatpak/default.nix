{...}: {
  services.flatpak.update.auto.enable = true;
  services.flatpak.uninstallUnmanaged = false;

  services.flatpak.packages = [
    "com.bambulab.BambuStudio"
    "flathub org.freedesktop.Sdk"
    "flathub org.freedesktop.Platform"
  ];
}
