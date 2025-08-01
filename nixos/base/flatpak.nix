{lib, ...}: {
  services.flatpak.remotes = lib.mkOptionDefault [
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];

  services.flatpak.update.auto.enable = true;
  services.flatpak.uninstallUnmanaged = false;

  services.flatpak.packages = [
    "com.google.AndroidStudio"
  ];
}
