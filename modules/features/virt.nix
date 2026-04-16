{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.virt = {pkgs, ...}: {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
    ];
  };
}
