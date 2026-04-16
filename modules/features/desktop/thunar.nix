{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.thunar = {pkgs, ...}: {
    programs.xfconf.enable = true;
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
        thunar-vcs-plugin
      ];
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}
