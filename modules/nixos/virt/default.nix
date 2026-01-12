{ pkgs, ... }:
let
  profile = import ../../../user/profile.nix { };
in
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "${profile.name}" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
  ];
}
