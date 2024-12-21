{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    qemu
    virt-manager
  ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["tuxy"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
